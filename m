Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADAE26FDAA
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 14:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgIRM5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 08:57:04 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:29802 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725955AbgIRM5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 08:57:03 -0400
X-Greylist: delayed 1579 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Sep 2020 08:57:03 EDT
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08ICPDjQ019071;
        Fri, 18 Sep 2020 05:30:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=s79yUyNGJTf4AySgRPdWYKAadjglGIu64QUWeUWlrc4=;
 b=VyE9BSyiGwwWngAXZvuIfhZE5DfQsG9h9vZ/DXax+hgVenJK56ggiqcfa2N6LJFYEfoD
 V7Rp28UJX6aVepkJ6R+gLYCYzhVH+XPkggPHch+3s/+81AEJWfJhRQZ6y2a06NH50B3Z
 iBPQ0YBgi6sFeKdO2lk14VZU21Qs5vPj5WtvrSyhJ6Jd6u8kwNxFrJKRalI4r9nxEBw+
 4dUKpiveOl9ZQ+/gLnln+pbb4aUCkPS9H1/WmlA4T/aWzVXoUo+A0yJk7xvpn+jj7jyU
 GKTp/J3/ZvWC5N+GlWlKZqPkEolVp2Tru/02pKzfdkRvjakM2b1fJcO+0T38JIPq3XqO vQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 33m73mve5s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 18 Sep 2020 05:30:36 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 18 Sep
 2020 05:30:35 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 18 Sep
 2020 05:30:34 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 18 Sep 2020 05:30:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gBIVNo04uTvEkxoQ41NkKKngjkVLgpcQcWbGNkFI+XuxGqJba4tlrCJAP4fVWpB76JCCYOnHtHNTzKIkEPQ56DYuVklFgaUL1PTX+vDHAksEsqbFM4dYWB4rp5CvSIqkZoL0uxs/R7HeRjoXDQ0xZAvGEEU8CNt24Rh6Go9Y0E7wZ2gxTEa3rRV3WpWMFsDXKu+CSEGSiiNv7RDjuvPBwflJTJVqU077hoDeICszQtqULBLIZnBpun7bua87C8dwrZhy6pd8uPh7ezo9/BVSjl1Wl8NPTqbl69loQWtIKuW6JhIqKBR+bqNlkAVMrx4RAucuio59OWNdbKihtcTTaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s79yUyNGJTf4AySgRPdWYKAadjglGIu64QUWeUWlrc4=;
 b=PWPz8Vs/cfdkyPuiCDlrF+QgsuAwctWVqb27lPvzlBFH6l654lnDr1BzetT+CxykZfp/AohBLJy68lyL6/Mn3l3E139UC/7KYQ4nzM5ST/oOv8Rz3DpN+toGAmhHQrvokFpkdDceWoKHxRSeCjK8k+XcwRKSRLFxSTNPipQFojzh7MYNHKWZQsGqD3gy/5K5Pzwv2MgNPSKRWVPBZlE+ihYbKXNWZI85Knvaw/UEl7qRQYd9fo/JKyvSE8ijBpmSif1/uA+Y7tcpQOFKpPGgmGkSfxHL71Up0BbXEPcBYRxauE8K3iqh4x5WssteZXId9e7coNqaLNr8B9MrLI48wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s79yUyNGJTf4AySgRPdWYKAadjglGIu64QUWeUWlrc4=;
 b=LDqPVuPpWUnXDf0sIOdErHjSiSTyZdWdKtZ7hVaR7hjPqchd4+1V/EAvfxS81WNrjUthmsTx8zwsSCaVcWR3Jy5lkkyweoia7Xck44JgD0u/EnHD7pGTxmjUoEG7VPsYUy7abYJKa8JhXc47+W77V0hBbOaWcxoamds8L98JuCE=
Received: from BYAPR18MB2791.namprd18.prod.outlook.com (2603:10b6:a03:111::21)
 by BY5PR18MB3089.namprd18.prod.outlook.com (2603:10b6:a03:1aa::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Fri, 18 Sep
 2020 12:30:31 +0000
Received: from BYAPR18MB2791.namprd18.prod.outlook.com
 ([fe80::1cac:1a9f:7337:34a6]) by BYAPR18MB2791.namprd18.prod.outlook.com
 ([fe80::1cac:1a9f:7337:34a6%7]) with mapi id 15.20.3391.014; Fri, 18 Sep 2020
 12:30:30 +0000
From:   Srujana Challa <schalla@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Suheil Chandran <schandran@marvell.com>,
        "Narayana Prasad Raju Athreya" <pathreya@marvell.com>
Subject: RE: [EXT] Re: [PATCH v3,net-next,0/4] Add Support for Marvell
 OcteonTX2 Cryptographic
Thread-Topic: [EXT] Re: [PATCH v3,net-next,0/4] Add Support for Marvell
 OcteonTX2 Cryptographic
Thread-Index: AQHWjPaH0HxyBR0eJ06mT6bHoX3CWKltam8AgADGOBA=
Date:   Fri, 18 Sep 2020 12:30:30 +0000
Message-ID: <BYAPR18MB2791FA01F325DCD41991A229A03F0@BYAPR18MB2791.namprd18.prod.outlook.com>
References: <20200917132835.28325-1-schalla@marvell.com>
 <20200917153044.7123aabc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200917153044.7123aabc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [2409:4070:11e:ecd8:68a1:9f06:3564:5286]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d5c4d216-be25-410c-c916-08d85bcea1c3
x-ms-traffictypediagnostic: BY5PR18MB3089:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR18MB30898BB392F52494F735CB69A03F0@BY5PR18MB3089.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vFwB9uqlLkJD7kZONbMYWLDY31SXiQjHPdL5s/J3eNqJtdVZqadN0WzvmsI5Qdy7exRljML2uZx5JZ3M/jVA6Y9raPvl5lvMCqEZ47djfGOKf7JvF2e3riiz0d/vfFIInc+nOjFit1HiProta5ATuexZVgtzxoVyrVVtJUCb1+DbxJeGVz4c4RlIl/5OpUwq8/neyZ3F9sFCs36Uq5FA37ATqF8Qy1Wa8c2Brj8xv5dDr1Sq+rAGlcqGt1s3vOMQY0AnOGh9Ul5HpzNlLESqXtxBu/y11E7VoPXomzTDEKEC1SEus9PmAbXrW0Lepwkp
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2791.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(396003)(136003)(346002)(376002)(9686003)(54906003)(55016002)(71200400001)(2906002)(107886003)(64756008)(66476007)(316002)(8936002)(76116006)(66556008)(66446008)(4326008)(33656002)(66946007)(186003)(52536014)(6506007)(5660300002)(478600001)(7696005)(86362001)(8676002)(6916009)(83380400001)(4744005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 1etjS4WHfxGb/43zZNMxwf7sQe4qWu0fExaYPdCKD9hlEol663xVjOloeuEAw7WCUduwZqcv344te/OZuq5T7UZdCh2Zh6kf9sAcfEr8GzNX0tw39MuMhDQw+HFX5xy6cMyMqtK1EsGTr0OubUcFQ8UYanpJwFPg7TlKFaV01gcTJa8JnvGkHeFg5AxD/y88HTwHjkgNDuvmcU+WbbsYkXdBmZGcPt6gL2CNgV4otrdUvLGUM6T2Zabk19/SJ16m7lyu+gJeoPHlra7xt/CaZQtxB42lmXv8HryP9wURITWc2f29l5ARqtfpjAHcWRduwW/G1gcL4lcq9A98Onj+/Wf8oQZFQX0rmDeyJY/isLmv/Uf/ta2Xjx5JAg93GAyZL/avYN6lcCiMKwlaXivIpdXC0pCXaoY8STkYGSFOFYoNcFuST+PS67XL5QVjplvM+af7wRwWvJECVlQnLvxTk5NyDuXdXhGZyrvaxYyUghfJZfcfMCro04o65GtoTJa4Yl/d8jflxZfmW8z5qBKFp1+mlc+/uGe6wMa1iIy2zGJsNV9K1PXbrdbRAhVhma1NVGhLZiOyut07MFUqVKWtltYPpCKQzGJwfyT2N98vmFTWG4mX/tKW5NiPDR4YOU70A2MeZrSorAdVxHrdagKl1ENEbDbt1kMdK43FSzN0YKK8vqgdvFnIBawnH5wtEZjTqjQ/NHZxiqACt3UNsYDqdg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2791.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5c4d216-be25-410c-c916-08d85bcea1c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2020 12:30:30.5090
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s0o55NhE4PkpF4yKWLl/ztCRDRjt0tXKU959c99t6QNzA3QktCiIHkIPdYszo16dZZ4ZW0InUygXDgt4f/OizQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR18MB3089
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-18_14:2020-09-16,2020-09-18 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: [EXT] Re: [PATCH v3,net-next,0/4] Add Support for Marvell Octeon=
TX2
> Cryptographic
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> On Thu, 17 Sep 2020 18:58:31 +0530 Srujana Challa wrote:
> > The following series adds support for Marvell Cryptographic Acceleratio=
n
> > Unit(CPT) on OcteonTX2 CN96XX SoC.
> > This series is tested with CRYPTO_EXTRA_TESTS enabled and
> > CRYPTO_DISABLE_TESTS disabled.
>=20
> No writeable debugfs files, please

I would like to get more clarity on few things, would you like debugfs entr=
ies to be read only =20
and could you let me know the reason for not having writable entries?
>=20
> Please provide more information about how users are going to make use
> of the functionality and what the capabilities are. You add 10K LoC
> and patches barely have barely a commit message.
