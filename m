Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4A52BFBD9
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 22:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbgKVVzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Nov 2020 16:55:37 -0500
Received: from outbound-ip24a.ess.barracuda.com ([209.222.82.206]:58988 "EHLO
        outbound-ip24a.ess.barracuda.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726107AbgKVVzh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Nov 2020 16:55:37 -0500
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (mail-bn3nam04lp2050.outbound.protection.outlook.com [104.47.46.50]) by mx2.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Sun, 22 Nov 2020 21:55:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a5n1EDh70wrjHmeZkYqoXiYZgOMzTYLfroSu4fIoonWp42d8Bcfx0j14P1YvtqkAMLmb073/qWjV2zHG91g+D8fJpauWLe5VwfJ0l3YwkNZl5w+eBmCt11mUZD216rewaIOtaOXSHDNq0Cq/6K3UFhCbOPS47G18OAoDbKhnZvAypQ4XcaX1ppq/8DLbstp6GSq3/CHvGs6Dt3M8CplNEqVIWfU8mkmmFr5Sem0QyiFgWy0mq1D7PmHFV+Jjomw7j5wRnxjlw0j6JejMq+x7XDG+1dmUR8qRcrE6BIvbe1lp565lSBF+F7IEtxdp4pvcoELPaamkLP3EUUKYHFk4uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RbSBP1629M7W9U26HHC9jI0/e8KNif6fkwCtuQ0dqAQ=;
 b=G8BLnabrN5P1RheUpp/cX5KtD9NC2L8+MEfv/0yPudQo9QO3IX4V/WRLb2DJcE5wIajkj+/y9uMolf4eS+bk31eOulTjZl+rhEYvUa/XZ1wklHVJ3evGbaXtYmglIZYzifWgIxvm1bFhhwqmp8BU/JbUoD3JGItGR9cprsVUDiVga8iXemD0FEsaCHkVwLy48y3LIahKe1W+i3OhROZjtdGW6560QOCrrmKRPtTjaVG88UKOt25mgiCHYEbBRhQCEbWRbYXCN0iYx/nvGrG9+2hTYGzEkqxGHGB7dN1kvDtuXoZAwf8XXacF62f/CoXkdxA4bfFy/hBbtuROA5VolQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digi.com; dmarc=pass action=none header.from=digi.com;
 dkim=pass header.d=digi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digi.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RbSBP1629M7W9U26HHC9jI0/e8KNif6fkwCtuQ0dqAQ=;
 b=ToKQGxvMFKeLrGANSwTGFEdzN4dn7mrxDpP6eRUi1YdJFohkva7JhKHlkBwpJwCxVyF6Xlod1XbWvkEQ0Jcnc8/ANE+JkrU2lBAZbGMX/BeLlusgm3cbHZ683TH6U03qlu+2dfFFW32/K1Mg2gLr1jOP7bZdhZWLOatlzr+kAtc=
Received: from CY4PR1001MB2311.namprd10.prod.outlook.com
 (2603:10b6:910:44::24) by CY4PR1001MB2168.namprd10.prod.outlook.com
 (2603:10b6:910:48::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28; Sun, 22 Nov
 2020 21:55:21 +0000
Received: from CY4PR1001MB2311.namprd10.prod.outlook.com
 ([fe80::a956:bdc0:5119:197]) by CY4PR1001MB2311.namprd10.prod.outlook.com
 ([fe80::a956:bdc0:5119:197%6]) with mapi id 15.20.3564.033; Sun, 22 Nov 2020
 21:55:21 +0000
From:   "Ramsay, Lincoln" <Lincoln.Ramsay@digi.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Florian Westphal <fw@strlen.de>,
        Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dmitry Bogdanov <dbogdanov@marvell.com>
Subject: Re: [PATCH v4] aquantia: Remove the build_skb path
Thread-Topic: [PATCH v4] aquantia: Remove the build_skb path
Thread-Index: AQHWvs8ZM2n6oge2KEC89hbATIw5VanTGxgAgAGaZCs=
Date:   Sun, 22 Nov 2020 21:55:21 +0000
Message-ID: <CY4PR1001MB2311A96AFCC886F646359530E8FD0@CY4PR1001MB2311.namprd10.prod.outlook.com>
References: <CY4PR1001MB23118EE23F7F5196817B8B2EE8E10@CY4PR1001MB2311.namprd10.prod.outlook.com>
        <2b392026-c077-2871-3492-eb5ddd582422@marvell.com>
        <CY4PR1001MB2311C0DA2840AFC20AE6AEB5E8E10@CY4PR1001MB2311.namprd10.prod.outlook.com>
        <CY4PR1001MB231125B16A35324A79270373E8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
        <CY4PR1001MB2311E1B5D8E2700C92E7BE2DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
        <CY4PR1001MB2311F01C543420E5F89C0F4DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
        <20201119221510.GI15137@breakpoint.cc>
        <CY4PR1001MB23113312D5E0633823F6F75EE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
        <20201119222800.GJ15137@breakpoint.cc>
        <CY4PR1001MB231116E9371FBA2B8636C23DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
        <20201119225842.GK15137@breakpoint.cc>
        <CY4PR1001MB2311844FE8390F00A3363DEEE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>,<20201121132204.43f9c4fb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201121132204.43f9c4fb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-AU, en-US
Content-Language: en-AU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=digi.com;
x-originating-ip: [158.140.192.185]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cca6fa01-8691-4bf3-5ae8-08d88f314f26
x-ms-traffictypediagnostic: CY4PR1001MB2168:
x-microsoft-antispam-prvs: <CY4PR1001MB216885823C957FCB30540F25E8FD0@CY4PR1001MB2168.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rEO5V+DtqKFelj332osN94tD3wdSRkUGN/4CVHRtvMpVKYwfnzdaV9wHuttA5RHT3+9wuAtsF9rNnJs5wcAXLYwY5YwdcUZeUooXiRBa7B9vS+lEoqnIrctLCGLbDKicLKQ/Z+d8GUK/dHtyTRa82v4oBnpsdEjJHMvBIgJSlEqVwTk29RhDIY9EPc80WohpskrpkU92FeX6pquUrsnpdehZJRReZWjtbqdkADEmbMh+A29XQOZ8Q86eVqnxkOyZ5Ar5s4MdhxvnQM2YkBZv6ukssvk178r0xEheIWw/h5BMDjhzWEDwm0uXYv+PdiXS
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1001MB2311.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(366004)(39840400004)(396003)(66946007)(91956017)(9686003)(55016002)(76116006)(8676002)(6506007)(4744005)(478600001)(7696005)(8936002)(186003)(26005)(316002)(66446008)(52536014)(5660300002)(66556008)(64756008)(33656002)(6916009)(4326008)(54906003)(2906002)(86362001)(71200400001)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: v4PkntxJCYP7xObsGLmVtxUc3snnmUiwNJuKah6RXUtE6CCQbJ2aGM8Kid0hzFodiwZ63WUbjNhujlBSiwjbCayD2yHDGYqGQu5JVxOU+3cS2sCIgNakouzpVMLf6HAfPI8GHHynQsZ/LrmkBz1Xfoe4NL4PfN8+CXuT+joVJnzFNuxFb2QQT8JWRzlLqGGvrFIcgfcDXcNYmVIluPbmCZruU/AOktLWSmy9VguzEEshBqhhrt3EFnEOHkTUC638c1rPxjzmuL8497JcS5RYNTrUpaisfXVCXlqx2WwDfmnncyTGzYJdBnSDA42c9abo9uFCvKH+Cn+1POlFexlP2JtnkoOOfdoSiEX6lU7s+IB9WiVVtXpxNSeiB2AXLruBz2X1zNrSWSqqZjnnib3LXx1ql7dyRq7Z5DOtei+d2gBeG5wCuZagUn5XnZz4SUHMgmcUmA86myVWBMzUf1jRQxsEo0qOd0p0/XQUU89yv6JmvQ+0l6/K9LIGGYcom6qXrEeky11a3i7l7NVtu9r3AnJVZ1uz/eilRZgOPB4bTv1o+rMc15XMFbho/gC1bzwsiGdbX4qB53zi4HAK7A8aS5EXP9vFPDakpdec+D/thMh//jjzYck5gpLmvr+nBVo3RAFvKIyGrWZpsMgNfsl/O/Mp+HEZsZbNILh8JgYSuyI1NmVttmRoKS3GTgkI7EWwMQUnYa0q4ZZGepMXkM/vTeNKifTqtoddFLZgC2SxfnV1ToSyLNAmjZZLlAWH6d5sg1nfgoiw0krno29PJDG6m5cErA6cwGwKMwE7tyYD+CtrFr0Awf65X6+57OjhmmFNEawJxyzRxalGRRJPMFwL9lGOgaqcFu3ExqU3H1J4OcrwhCsqGe9MeW3993E5pg2PC7cVqJSLK9CM+6CdUBHH5g==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: digi.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1001MB2311.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cca6fa01-8691-4bf3-5ae8-08d88f314f26
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2020 21:55:21.5269
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: abb4cdb7-1b7e-483e-a143-7ebfd1184b9e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aMe35vnbq4vusbZ3FVFQH6yd6qcE0ka43mpB+Tn9vrubbB9VC+qNFavRXefN4EikmI+ZDalj1jtJULIOE+0fyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2168
X-BESS-ID: 1606082123-893002-7040-125218-1
X-BESS-VER: 2019.1_20201120.2333
X-BESS-Apparent-Source-IP: 104.47.46.50
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.228372 [from 
        cloudscan8-169.us-east-2a.ess.aws.cudaops.com]
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------
        0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS112744 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status: 1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Align continuations of the lines under '(' like:=0A=
=0A=
Oh... I didn't run the patch checker over this revised patch. In this case,=
 I am only changing the leading indent. Am I still expected to satisfy the =
patch checker?=0A=
=0A=
The current patch is very clear about what is happening if you do a diff -w=
 but if I start changing other things to satisfy the checker, that goes awa=
y.=0A=
=0A=
I can do that... just double checking that it's wanted...=0A=
=0A=
Lincoln=0A=
