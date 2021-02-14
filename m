Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53AB031AEC4
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 03:50:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbhBNCq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 21:46:59 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:28232 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229615AbhBNCq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 21:46:56 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11E2kCob014428;
        Sat, 13 Feb 2021 18:46:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=me6Ws+lPVYtdNNgI22zNSz8N9sOeUNk3hrLpqIk8TDI=;
 b=CbHr+C9tyQqBLx1HBrTtqIOlkYGZtrTzkzGhCCjriPjCp6iU5F/xuIepQfYI+buBtRoz
 VUw72BkgB/fRRzbO091ilmTPCxGJGf00iEjIOM0vtlaP7ZZf26CVxSMAXBexul4yKjtZ
 RPJj6KqjVn36/FKhVZIz+ZwvPxPTP6SfiAAnH7mab53JXwwhCH5VLZeAD4oMt2iE2nrt
 Vi6SXDnh0zo+0ltJmUhnrOBno5xzLnqaSY+bDVyYcCm7prNYXiLgWkV1C1s1vdrzBvF8
 nQegfHuXyX7BPquIbN8FPUpg3woupeOCA2VXKQ6jSYXe2gNAWO0f9TYGoNK8YPLJ2k3x Hg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 36pf5trxua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 13 Feb 2021 18:46:12 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 13 Feb
 2021 18:46:10 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 13 Feb
 2021 18:46:09 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sat, 13 Feb 2021 18:46:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D/5bLgK9g6QAkRLTw8NAmFbg0bMKtnXMRGEyZyY33k+eBxchOjq5DR6UCRyhgctWwhGFYKgXPPFni1n5xZrB9zOT6I7zBXUnB2XzqFrPcatLe3Rc+xPLA0lV0fXYQDMd9e3oIRwrQnYO9ZEJRiIC9UuF9CN6KLiRdl85q5Uqd2WBgRvKx8uqZCLGR3YXyTzjkdtDiJHlKN7/FXI37yQ/4EYqqdTMyD1xvCCHnDY5Iqz/qIuYQHBhsDKVOWhljr6C3Rga1w9Wr73AOkiX/2tUXIfaoFIjJa7b3a3lzpyRpF0j8O/n4j31qYPlObqDE8dPTowKdVzmoC5NvfPJwa5LwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=me6Ws+lPVYtdNNgI22zNSz8N9sOeUNk3hrLpqIk8TDI=;
 b=nykLHG9bpZtWDak4EjYtJ89BuZqBb7JtnXOKVWMjphRSal5Wl0gnhqiSCsqXn3fyAmvvjyz3BE7ijLdHQnfjw1DwYcUfUlDz2rDPHrHrUdDtLeuJTGhOaunQQBA8iB/grKTdOFCV8P34blzphBnGiQGhjMuZWz7SdA+g9V+zd4thREe6NcXt0f972ffgU0eS70X0+DpC5gSLyqRIVL9TKKsY5lzk1MWN3CtGgA8NLcD24ZV3OmWBxnNgWDo5ZyvRgNfreFeYAdJ4ooKMZ3Zipq4yc7a8+QACImdUWEsnG9a5A2zcYlx5fHg6MqXPecsL451tOyOl+4BJdfoIsJoZCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=me6Ws+lPVYtdNNgI22zNSz8N9sOeUNk3hrLpqIk8TDI=;
 b=awHsez6AnFOGn5pBXQHO+0Wbb59uSzp+h3vF2kejBT2IkqAGURj0PIfv4gOMrHfAQTJJfC2/rZ1YceZgUHwX8hbwCEFMpT6xBuyiYJ8A5TH8/d1ExEG8FK7j7KomLk1TRPEy8GRG6nbdGPCySdwYu8QdrOnoGjv3ezpa2dKsioc=
Received: from DM6PR18MB2602.namprd18.prod.outlook.com (2603:10b6:5:15d::25)
 by DM5PR18MB1626.namprd18.prod.outlook.com (2603:10b6:3:14c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Sun, 14 Feb
 2021 02:46:07 +0000
Received: from DM6PR18MB2602.namprd18.prod.outlook.com
 ([fe80::d0c1:d773:7535:af80]) by DM6PR18MB2602.namprd18.prod.outlook.com
 ([fe80::d0c1:d773:7535:af80%6]) with mapi id 15.20.3846.038; Sun, 14 Feb 2021
 02:46:07 +0000
From:   Geethasowjanya Akula <gakula@marvell.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        "Jerin Jacob Kollanukkaran" <jerinj@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [EXT] [bug report] octeontx2-af: cn10k: Identical code for
 different branches
Thread-Topic: [EXT] [bug report] octeontx2-af: cn10k: Identical code for
 different branches
Thread-Index: AQHXAXnrJmqNgDgas0KO+JbsSOWr4apW8aLW
Date:   Sun, 14 Feb 2021 02:46:07 +0000
Message-ID: <DM6PR18MB2602C27CB4B042203861239FCD899@DM6PR18MB2602.namprd18.prod.outlook.com>
References: <20210212200129.GA281901@embeddedor>
In-Reply-To: <20210212200129.GA281901@embeddedor>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [103.252.145.190]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fe05b1af-9a1b-4a94-3473-08d8d092add9
x-ms-traffictypediagnostic: DM5PR18MB1626:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB162692A4F8C945C7D7CB0AEBCD899@DM5PR18MB1626.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:551;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uIQlPPfoRYDdPa/NMV9BiNlo2hCTb4I2aZaBh4hm59i6WHsN/D+Apdivy5uC18J94kpuFHiLFlP4H4XWU6GIUNSRT2pZSPrzpjyOmBa2zZVq2C6iG9Ad742+NH0jLC6FatTrzLbP1PoM7kZqDbijkB6GfPM8yiV6bqBMC8sdoJ7bFw3xx8qB5JohL+Qxm8t+YnWPBL36GdxYaV14bXv8Bjb1/O3egZXEOQINXjwy1rCCNdvBwhDTJcS6+9x+S++FsOZCTclf6NWC6HQrTn9hCVuw5yWRL5hhIsSEtcr5GY+YeMTuRDoYCtDGIl2fFJfd6gq2tkgY0ZdRIuLAvjjcyboDus4G4PkGMWbtRSah61HEtqW5dyyLJ1akNa5/CqiqPMT7hKgZ0msqK001bIVSCVX86NJcUMTkSaCzAwFt76kwfLajqo9oeOCTT7GIC1s8bVvpSsLBlqQvfkKwT3BucdYNxhD80dxYc0bkOpI0mWrz6B132WSuJBgfZJdPpb2PkRsAzML6TkWGwHjRJhNkHg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB2602.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(39850400004)(136003)(376002)(366004)(316002)(86362001)(110136005)(478600001)(2906002)(33656002)(66946007)(4326008)(7696005)(71200400001)(6506007)(26005)(8676002)(76116006)(91956017)(66556008)(54906003)(66446008)(186003)(5660300002)(66476007)(64756008)(8936002)(52536014)(9686003)(55016002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?+Vm/EVF6HsQ90MtB4VaoYfI6TlrWcggDSG5ZQQW2qaNUv7EnjHaAj70gK/?=
 =?iso-8859-1?Q?6akWEsqAn4cE2/bGR1sBa0xlL1OC2mwTcHegxn/aF/stERt9ILYY0tq9JX?=
 =?iso-8859-1?Q?gfPugP2l4pqq9RVsju1jgDK76cXT8TWEc+7RBD8ZIy2LaVLTqad5rtJtVI?=
 =?iso-8859-1?Q?nm2M+SCupzOfAxsuRhAiAQlcRX6wDSG24rJWwXVKu92tK5JkY7rx/7D137?=
 =?iso-8859-1?Q?oSEF0ysqNlZskB15fcenEoHIMGBeiLgOWhlC3wzmVxOd9euBvwwnTJglXg?=
 =?iso-8859-1?Q?67YXZsVnd5MsGZNzqRrkQHlvpUiV3/lCibXSrWWgsCa2GRxDOClN6eyj4l?=
 =?iso-8859-1?Q?zhTj1WdizdipO+xIKZa74SICNY+V4TsFOYI0RqKS7oGeCLtO5Z+akws5RK?=
 =?iso-8859-1?Q?b1JXExz+m722MKmagPnn+WIKYzEv70723Adw5wzqtP86CpbhdWGhFDdEyq?=
 =?iso-8859-1?Q?Bnsd2bebfZ0Ag20dK/oh0419eUB868F3l5f+cDc0gk9U4GxoR7sCBwHYso?=
 =?iso-8859-1?Q?AhqxVhKPNZRS83psHCnqS8s107ApoR+RrVpQ3GmEf5A8NVF/vPeEd+Y/75?=
 =?iso-8859-1?Q?mPY49Xv4LoiO+Go/mbV4KN3XeJ4rWeYr/t9Erq8D3PJl07XuFJXDBxZlj5?=
 =?iso-8859-1?Q?oxrlrPoGJCIoV3Ih9XGGZPVJ3AFfioyu/3I2W11zigdRhRODpsdzdQKV3v?=
 =?iso-8859-1?Q?SAp1J5RXHCERZ5gO4grvCl+62qohgbfbuyp1wXhQLjaSPGNLsomptvemRs?=
 =?iso-8859-1?Q?t7KYcWcmMzushPSEleQ39wCXyZjL0vJLyEm/MbnTdk3yFxS8Gz4kRFQq9q?=
 =?iso-8859-1?Q?AKv8OxLT93AZbzXtNgq6wysfdZYl6UXhh9nV4j3xlRJY/3Tcoo0ALRL+4E?=
 =?iso-8859-1?Q?acBikquJlkA4MEhw/++t4+vAMJqEIMtgyw59IUaSiNo2l0hN6c8k9SRAIM?=
 =?iso-8859-1?Q?fr/w/jzbwM+8EwKE+b+5G4d1yPzHA/xEvd3ZzZCGjmB5hba1KiBo4Vi7Jn?=
 =?iso-8859-1?Q?+U+JkrVhUsshhzvAPGIZdreDGlnia1OhBgi/4LFSXaksVqV8lqP3fHc4K1?=
 =?iso-8859-1?Q?k4jhjtcTaR6ohmtDMG2/gbgwV3mdcV82XOlqb4/3iarIm+33sB3NrM62m8?=
 =?iso-8859-1?Q?BXpBpxQYzVFXYXY/reAS9SzOvkfauJXVFlCk2wtP8bOPxptHX/MWY0kOtj?=
 =?iso-8859-1?Q?B+QnYeNkhEqQqPFzgV0vZHknpcsJUtPjE3hjrGZV0C06ZjcgWCiRKnGeHc?=
 =?iso-8859-1?Q?WCrEiFLjmMPPzxJq/Y+uz5s45lt9NCZHrBB6CN9CwFgkCnIWc49tzx8A2x?=
 =?iso-8859-1?Q?+rGvRuIomBr5SGqzcDI6taolZoLNXyHcrjaT6qtGmfNtp5lp/bT8+ubfsn?=
 =?iso-8859-1?Q?09pbiM+jSA?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB2602.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe05b1af-9a1b-4a94-3473-08d8d092add9
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2021 02:46:07.1492
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i5nRhsd1EYOQgmJ2Gg1p48PQK2qC5ELVxcmZ4u6sDOYKBYH9MGvr29+khQO6qvfWm10tjWOgyFu6tWLLC/aPmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB1626
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-13_02:2021-02-12,2021-02-13 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Gustavo,=0A=
=0A=
Please see inline.=0A=
=0A=
=0A=
________________________________________=0A=
>From: Gustavo A. R. Silva <gustavoars@kernel.org>=0A=
>Sent: Saturday, February 13, 2021 1:31 AM=0A=
>To: Sunil Kovvuri Goutham; Linu Cherian; Geethasowjanya Akula; Jerin Jacob=
 >Kollanukkaran; Hariprasad Kelam; Subbaraya Sundeep Bhatta; David S. Mille=
r; Jakub >Kicinski=0A=
>Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Gustavo A. R. Si=
lva=0A=
>Subject: [EXT] [bug report] octeontx2-af: cn10k: Identical code for differ=
ent branches=0A=
=0A=
>External Email=0A=
=0A=
----------------------------------------------------------------------=0A=
Hi,=0A=
=0A=
>In file drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c, function =
rvu_dbg_init()=0A=
>the same code is executed for both branches:=0A=
=0A=
>2431         if (is_rvu_otx2(rvu))=0A=
>2432                 debugfs_create_file("rvu_pf_cgx_map", 0444, rvu->rvu_=
dbg.root,=0A=
>2433                                     rvu, &rvu_dbg_rvu_pf_cgx_map_fops=
);=0A=
>2434         else=0A=
>2435                 debugfs_create_file("rvu_pf_cgx_map", 0444, rvu->rvu_=
dbg.root,=0A=
>2436                                     rvu, &rvu_dbg_rvu_pf_cgx_map_fops=
);=0A=
=0A=
>This issue was introduced by commit 91c6945ea1f9 ("octeontx2-af: cn10k: Ad=
d RPM >MAC support")=0A=
=0A=
>What's the right solution for this?=0A=
Thanks Gustavo for pointing out.  below is the right cod for else conductio=
n.=0A=
=0A=
else=0A=
      debugfs_create_file("rvu_pf_rpm_map", 0444, rvu->rvu_dbg.root,=0A=
                                    rvu, &rvu_dbg_rvu_pf_cgx_map_fops);=0A=
=0A=
Thanks=0A=
---=0A=
Gustavo=0A=
