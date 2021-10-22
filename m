Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 251D243801C
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 00:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233793AbhJVWKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 18:10:03 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:57286 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231363AbhJVWKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 18:10:02 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19MKjf9M011316;
        Fri, 22 Oct 2021 15:07:40 -0700
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by mx0a-0016f401.pphosted.com with ESMTP id 3buu23tkas-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Oct 2021 15:07:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U5yA3ontKb0z69TjlmD07uPZ4MPuOmSsipxvLGqa0NSUIMaO2i6ENz7aqVMT5Cnt4RrihPglfe/NkQS1/GVDY8mJYzdoTWGyyzlOm0nUURieHyWy+gXeqmLiNl9bunBstvb9m3ksEyd4MjHoXazQD4WE4ICe3XyikTfCX2v232W5sizlyh9/9C5cHwc9xwnvLBEQ+TQj32tIQKiJdt25noqEMKUiZtR4mFQzKAsnjN53DgfQ42q9Q+jQ5wE70rPT8GHV7vZk9TNSSqQk5bjPyfnvmlDeJ5+r7Y5ckljvLDkPVq2bSRgf2jUj8hO8aCMgpWbtw7C3BFXTfZ2ha6kCuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4zJm45ipoO0sZ4kvYiCWLeAynp5nVjD8iU9dgR1JTPk=;
 b=EbceDYPhfUbOrQnkO9rTlkG66B7EGlEao6hmEHBKKG5Sm+29B8kviAFjID9QZlx4degNEaePdRaawiw+6CjILLMOgpq3gGNowsfFIQ+/ZoZpCNNEG5yfCRhWjZW0V97ILZtAz/eC1j2Q+oJqJ8xLKnQcpHn25GDyMkGQXaZLSfGhO6vzeAR7YhHImtpsSRppu68lFn98lFup5tbTS7umeJJxVRNzhRtbE+Ku9A/LQHiFqZErRjaz9MUBX8EhS3UyEudvfaG/jj5ughtB3kRDvMv35eT+ztxccLP8vuYQmfN8zXP7t0MND4E5x4OwvtX9UAp1jdCtnjE9jbPuo7F4FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4zJm45ipoO0sZ4kvYiCWLeAynp5nVjD8iU9dgR1JTPk=;
 b=Ctk58yJbOjS1WvzbfCwYSb10/I2Ycu7MuFT+dmuwHW3LSrefAHF+2G3YwJU0n0fwgr+batlvmQDueBkRKpAGiOAV7fqBuISNvASpjex7J6z3R+Tv18g5oGHQlVWE5MvMAQXtL6cVAvjHkvbAs/S8IefkFvx0f4nNM8CrbhG+gEw=
Received: from SJ0PR18MB4009.namprd18.prod.outlook.com (2603:10b6:a03:2eb::24)
 by BY5PR18MB3364.namprd18.prod.outlook.com (2603:10b6:a03:1a5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Fri, 22 Oct
 2021 22:07:37 +0000
Received: from SJ0PR18MB4009.namprd18.prod.outlook.com
 ([fe80::919c:1891:e266:2502]) by SJ0PR18MB4009.namprd18.prod.outlook.com
 ([fe80::919c:1891:e266:2502%8]) with mapi id 15.20.4628.018; Fri, 22 Oct 2021
 22:07:37 +0000
From:   "Volodymyr Mytnyk [C]" <vmytnyk@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        "Vadym Kochan [C]" <vkochan@marvell.com>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        "Taras Chornyi [C]" <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v3] net: marvell: prestera: add firmware v4.0
 support
Thread-Topic: [PATCH net-next v3] net: marvell: prestera: add firmware v4.0
 support
Thread-Index: AQHXx5E5UFu2sPd+NEWZnXxi/R2JAQ==
Date:   Fri, 22 Oct 2021 22:07:37 +0000
Message-ID: <SJ0PR18MB40099F73BA61422DDB103C5CB2809@SJ0PR18MB4009.namprd18.prod.outlook.com>
References: <1634722349-23693-1-git-send-email-volodymyr.mytnyk@plvision.eu>
 <20211021161336.76885ef8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211021161336.76885ef8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-GB, uk-UA, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: d926bdb8-1bd6-fc61-c638-6e212045172a
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 319ee0c2-f498-477e-5185-08d995a85bb4
x-ms-traffictypediagnostic: BY5PR18MB3364:
x-ld-processed: 70e1fb47-1155-421d-87fc-2e58f638b6e0,ExtAddr
x-microsoft-antispam-prvs: <BY5PR18MB33643E37B26346C9C13CB242B2809@BY5PR18MB3364.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1751;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BRjoEwGIXGyft2JAZ1J/ppacy7Gwn5fgjTy/LA6/T8yTuXW+sUUkjlh1MVIW0KHJS0AyalQUSovSRBg5W3VDw1L4ES68/JZ+pPIf60+FrD/grj9qHXB0Pg0VMcKQqJyXS79dTn5NLeGa9YTzCNhpAa1xeoFA1cg2h1R2cXxe5iD7pr+nWvXdBOTSDK4i+xWMevQ+FRA1tUo6qyOENg3zQXRqSdXaX/38o7XgsHiLAI+OP0pAkGKejg7Gj4xQTT/6cLTN/yx88a4JmVcFxYKIz2S1IIow2vzZoNNmPCFaVy9y5belW8uCz0aAM8OucbobOCPqYeJc6515heCbf2M1+yhEkZPIaKj5was19c4CnytaD+EKhM3MCqe4EcXrGH6H6OWJ0dxnvYIwi8dksy/ZuAS0AWauSluNM3adF020yGVYsvPOI3Cumnb+c8OmXf+alCY9GBWGjQMBFwvOTSIFXAwhkR5lX8G4oA/ZjfZPnGbSjTZ6/zLvBsiPgw4lwp/YM3Npr0jEB4cYS9LTZXNXv1wQcMnV558CddOA5B47Fhj+8+6F7PRaccPXoH29d5c7OoIoXpIzJTpAjdmDqXkJdYM5jf2ywwMNqAiNy7/6gaO62nKMO0Jrpo2GPFk4IS2S0UOjHNBaJQ/i6q8+f82hHcswXLLDg5ueXJ8BvBAu5aHZcx90amlMTF7etBf8MI3IHRmGCjG2FBt4tbvZkFWGBg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB4009.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(38070700005)(66556008)(6916009)(9686003)(55016002)(8676002)(508600001)(66446008)(86362001)(66476007)(71200400001)(7696005)(54906003)(83380400001)(64756008)(122000001)(6506007)(4326008)(66946007)(4744005)(52536014)(26005)(5660300002)(8936002)(186003)(76116006)(2906002)(33656002)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?TshrHf/HRMLJidsTmeYfdaY1XbNkZ+j2tbKAfGdr5uN4ecAmppjm4H03Op?=
 =?iso-8859-1?Q?keKajZoDBjEy8CUN4uYomcVmLquCjT3OVYXfJ7brbkymic91B+kNcoBXdE?=
 =?iso-8859-1?Q?QadgRfMG9zrdmK4DbWtWmot8FYhcssXJlvY/jJwR7DNY18HOUI0Cz3Xrxr?=
 =?iso-8859-1?Q?er/fUeO0UEambICybyrEslNXjXe809Irdax599iD62mVkqv3Dc8xBU+Pje?=
 =?iso-8859-1?Q?7DZf9d4BWGpnuyywYe0iUqxBT1TJ3Ew757uoAIsI5UrwqcMI4KSpDCao6p?=
 =?iso-8859-1?Q?rPVONo5JqlPmNVDixtf//1YlPVH9W5wunOchX5AHYtgszAD3k+AAZf33RG?=
 =?iso-8859-1?Q?kOCcKEnSzN+zDnPtSeBEVsbfZoGA+WiDSCJ/CWmWT3BwrR49QRoFK4ka3r?=
 =?iso-8859-1?Q?gBVmaKN2Hb1nwu0W/iJPvMPQ6jNpO3dnsCB+YdoFo3HHmj6ZYsHa2jCQUI?=
 =?iso-8859-1?Q?uaYl8h0hrOJUB/wxGoIcKCksx6IDtNLcT1Km1xzNogmy3Li0lURGNhIuOx?=
 =?iso-8859-1?Q?PBOzMNVAD5sA5uFGxFFAfwUj7bH9cjULxF32CFo4GMju7K9tlaCI+NMd3/?=
 =?iso-8859-1?Q?52KZO7g4z2caK2OON5swEfaRbYlE+CVuBGRcv1fj1Q3RN1BrhWNeM8Qz/0?=
 =?iso-8859-1?Q?EtrXO2WJxPaiPPTq4Cd8/NMO/YkpeTQef3JU+JgHKCGpQSf62QD7QWmYk8?=
 =?iso-8859-1?Q?TbKXTybpMMcZA5NC0uNjYwvBTxR25BmDYLSVKeGGb0PcpyQ0sQxtIfU+P8?=
 =?iso-8859-1?Q?EhdHdzaLGfuH7c5gTOSQ8weKyWdnPjIOXxgcC0Ismpum8I7EAdB3XQlfK6?=
 =?iso-8859-1?Q?Ts17xR4E7/SHSGHFc9uM13PKSYny8v4BlAmzHMadaivOd86hRyeK3pujUo?=
 =?iso-8859-1?Q?n58bvSyUPYpHRPgu62NMvT7pArCZO4/Q+YLBQ5UYanqqNJLF2MBba84aiI?=
 =?iso-8859-1?Q?mGZT4fwgrHnw+gv4vSbyhf7GRt9NivmURn2nrSMH77gMMbCGmKPsRBx1QC?=
 =?iso-8859-1?Q?42VO5xEfGUpu82q9R4we+nzrmGwrdd4xh24IWPSZb7uoRdA9BKYtMqK4EI?=
 =?iso-8859-1?Q?QVQM1cGFrBOrLVczdFfeOGtRtXeCv7n/BRXsY8KxWjTMth7sa4SGJKjwWQ?=
 =?iso-8859-1?Q?tDyyo5QsQGCB4wvj6QEJZdlRP/xYy9EgmHzq/AK13m68WkuQIqHirzBeoJ?=
 =?iso-8859-1?Q?z6bz27s1zsLEYHoAEpe6b+SvSLIWIwnxVZEfuYNO+OvYuOx0NlakHjim3P?=
 =?iso-8859-1?Q?V752qpkOhBIRjK/map+whMrYGDLcCnrVNzXcAXiiX/mO+PUWM/Y/V7sqS+?=
 =?iso-8859-1?Q?eBGL8GSZos5mNqfi7L2wvTpPwvW3GZdkM8NikxduN3WOKhgb9/42Knj4ns?=
 =?iso-8859-1?Q?Ri17tlz5g2f5uL4hKkvtSm47Wo3Zn+Cu/EEXuOLCzDzaRxvHqMrftKZNwa?=
 =?iso-8859-1?Q?7W3to2DjnCupSpULswlQa+6ILx7MBWsnZDfQI6P8UCPNjrRs8+8+w3PWql?=
 =?iso-8859-1?Q?Y=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB4009.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 319ee0c2-f498-477e-5185-08d995a85bb4
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2021 22:07:37.2655
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vmytnyk@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR18MB3364
X-Proofpoint-GUID: U0PbnD4eETHJvhx8uAyjCgfGNTrg74qf
X-Proofpoint-ORIG-GUID: U0PbnD4eETHJvhx8uAyjCgfGNTrg74qf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-22_05,2021-10-22_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>=0A=
> > +struct prestera_port_mac_state {=0A=
> > +=A0=A0=A0=A0 bool oper;=0A=
> > +=A0=A0=A0=A0 u32 mode;=0A=
> > +=A0=A0=A0=A0 u32 speed;=0A=
> > +=A0=A0=A0=A0 u8 duplex;=0A=
> > +=A0=A0=A0=A0 u8 fc;=0A=
> > +=A0=A0=A0=A0 u8 fec;=0A=
> > +};=0A=
> > +=0A=
> > +struct prestera_port_phy_state {=0A=
> > +=A0=A0=A0=A0 u64 lmode_bmap;=0A=
> > +=A0=A0=A0=A0 struct {=0A=
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 bool pause;=0A=
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 bool asym_pause;=0A=
> > +=A0=A0=A0=A0 } remote_fc;=0A=
> > +=A0=A0=A0=A0 u8 mdix;=0A=
> > +};=0A=
> > +=0A=
> > +struct prestera_port_mac_config {=0A=
> > +=A0=A0=A0=A0 bool admin;=0A=
> > +=A0=A0=A0=A0 u32 mode;=0A=
> > +=A0=A0=A0=A0 u8 inband;=0A=
> > +=A0=A0=A0=A0 u32 speed;=0A=
> > +=A0=A0=A0=A0 u8 duplex;=0A=
> > +=A0=A0=A0=A0 u8 fec;=0A=
> =0A=
> Is it just me or these structures are offensively badly laid out?=0A=
> =0A=
> pahole is your friend.=0A=
=0A=
Thanks! will fix it in next patch set.=0A=
=0A=
> =0A=
> > +};=0A=
> > +=0A=
> > +/* TODO: add another parameters here: modes, etc... */=0A=
> > +struct prestera_port_phy_config {=0A=
> > +=A0=A0=A0=A0 bool admin;=0A=
> > +=A0=A0=A0=A0 u32 mode;=0A=
> > +=A0=A0=A0=A0 u8 mdix;=0A=
> > +};=0A=
=0A=
  Volodymyr=
