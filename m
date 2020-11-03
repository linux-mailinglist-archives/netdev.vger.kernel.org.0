Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9EE2A3BA4
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 06:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbgKCFG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 00:06:28 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:7008 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725980AbgKCFG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 00:06:27 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A355mrY006259;
        Mon, 2 Nov 2020 21:06:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0220; bh=o0O26hsEziVBxMSezrcWpOP7FrK3yHhmSKZ9xMma1Jc=;
 b=X7grOll66c+kHzgEsTwuqD4QycUzGcuwmUZuErtQhT6lJtBAHIQswQGv47h478a0xs/F
 a6WQoDZ+Uh0+qFg1W0wAEw+m3qIXIbrlZp/ilL2k64NCFii95/n2qcJ7ITrFGZRzPlH9
 4JjGFXoTULlmZCj6GEFrnnho4HaV/2P/8xy8RlOcaQl1wre4cNMBIT75XXxrjDw1JQ7h
 e1k46ErW8qDhjpTsYWjopz3efhxaYNXa16r8eT8vUncgSEYUUDV45hZz1dmreapGJfpk
 gCPzH/nfCBHYtzenszqxutjhh2A+I3vM68HF+bJUForHhUF1Zm6aKDZGHw2T09FQ9gLW ig== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 34h7enues3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 02 Nov 2020 21:06:22 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 2 Nov
 2020 21:06:21 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 2 Nov
 2020 21:06:21 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 2 Nov 2020 21:06:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aGTvojaWzr9D2sjNjLF4v8QXdN7qmZCduEVi7G1sXfOBzuhwY/NPXmvF9QrjHrF5XdnuzymAqV1ZV08Jzh6Sc0dtMatIBtulwTNno2sUPmiU3/DQS/fIQW6YMfaO6y8qxIJAhZnWA6F4A4SZTgvJP7kbBv+sY6G4hhXWMSsCtmp8/OrwxVhLs0zQpXk+uBjtBRGmKhBFHqWwytB+ZZabMlQBRiW5nL4Pzouc46UnU//qDYppY6rdQuaM+2IdOkmVmbORG70t5qblZ41lI3UaHZ1/V6nlew0en7iRt3/qW17XeDXvGRtow19IGeNb+pmUaCn6e8f5ckseGTD+O0aupw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o0O26hsEziVBxMSezrcWpOP7FrK3yHhmSKZ9xMma1Jc=;
 b=QQaKneS9NqFi8ehheVTlA71yw6gPuWfdNzNNMyN9KbNWrcLQ46KASNu2vg6WxPCXBrbLDtdfk/FsyYM/dTlWARcBIKaqb211/OllVuy1phwJZ0q8NGgfbmxHF1vlkI/tZI+ia+vOKqpaSSR0rFG2332owQpftuZc/kq84b+TZRMUljhCAQaN3l9gXtvSbsR2Uvf4HaUAnGGn2pdDHWGYNtokkOM0HGTNfislngTNR2knbiROCRGpD+hIEIioVTKnT0bHPBuUx6z3mNFbY61rC8qsYnxDiCR9hkG/Oj2bkU/cD0TG+VCQUF0UDZuQ4hqgaRl2oTs4atYvAGKJ4VYpxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o0O26hsEziVBxMSezrcWpOP7FrK3yHhmSKZ9xMma1Jc=;
 b=rtSEJsuVleNVPIa5kbemv5IaEGmg2JVfHBDmfHm5EF0hnxKOa+WbuMu04p0I0lhVtL1+jqmOA8ZveR2Wk4xHpkz1YCR1/J8G/YTgRmcVhkAGfPNEsF12wsAMertFzABHC8vK0zXJO7jOfyGltZfmKUElFLEb7GLnYKVm1ZrUNBU=
Received: from DM6PR18MB3212.namprd18.prod.outlook.com (2603:10b6:5:14a::15)
 by DM5PR18MB1082.namprd18.prod.outlook.com (2603:10b6:3:31::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.29; Tue, 3 Nov
 2020 05:06:19 +0000
Received: from DM6PR18MB3212.namprd18.prod.outlook.com
 ([fe80::a1ad:948b:abf5:a5ef]) by DM6PR18MB3212.namprd18.prod.outlook.com
 ([fe80::a1ad:948b:abf5:a5ef%7]) with mapi id 15.20.3499.030; Tue, 3 Nov 2020
 05:06:19 +0000
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        "Geethasowjanya Akula" <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Kiran Kumar Kokkilagadda <kirankumark@marvell.com>
Subject: Re: [PATCH net-next 02/13] octeontx2-af: Verify MCAM entry channel
 and PF_FUNC
Thread-Topic: [PATCH net-next 02/13] octeontx2-af: Verify MCAM entry channel
 and PF_FUNC
Thread-Index: AdaxnsyU9PGb60qHSmaKvFDtl8KR/g==
Date:   Tue, 3 Nov 2020 05:06:19 +0000
Message-ID: <DM6PR18MB3212BE3C13B421D8865371F6A2110@DM6PR18MB3212.namprd18.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [124.123.178.65]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 74c1fac3-425a-4459-7f91-08d87fb63371
x-ms-traffictypediagnostic: DM5PR18MB1082:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB10825A227924A81565449237A2110@DM5PR18MB1082.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1WcfQDYwXfEHwOejhtve7ZgLL4ntWUDfbCzVAri97Xuw1qGopt0VFNC3Be8aPE/qk5CA1oQYF25fA94gS/AzX8oOq9kjUI4l5YEDp/DhFJJtW3rRuE415Tw5+6JBynAoGglmw3oWpPOarjG6Hcj7aw7/VwcNan7fuYU88TlyYZ7Ob2vGmbgMWPUkgncLeU897f/jmVPZq5Zl4sAZVxi4HWM81nRAi+8a2oyBWlmg6eQWlLikTson3RVtVl+y1abPd+l1qMXoPdjj0f4XYOtLOSdAjFW3v8uUWJsXx2tExke/d4a9UuyY2EUre2oQegPtbGuGK3zcjYOOLvworRh0eQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3212.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(376002)(396003)(346002)(136003)(7696005)(66446008)(64756008)(52536014)(83380400001)(54906003)(9686003)(76116006)(66556008)(66476007)(55016002)(8676002)(66946007)(478600001)(5660300002)(316002)(15650500001)(71200400001)(86362001)(107886003)(2906002)(6916009)(186003)(33656002)(53546011)(8936002)(4326008)(6506007)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 7grZEYOuPihs0axYZsPyHbkfsRGUq2bT/ACVyXNZjznFS1DNNzT42HKbmEBWxuZhfiy6XMQyw7nHXJvIAUP0avb4dnF/2VV3XCgh5AFshiEJEb//hjq0rDE+EZhMXV8T7aexOH2BoZjzZb+Xb+c/3PPJ89ddcFuVxE3r7Daxn16u5TnZsASwVQ1kmh/q+KpxHXAhn1OTA+rRRet4bBjjmE1/BUjHQyaAQ5DCJleG5oUWmbDQSMr818KEuJpo1EcA1ZCks+HiSxJMMfTy3C4ATBqMSTSYWm9zHnBZPjzY/zw8Pz6RHrKJ/Ad8/kgnSH4WN4POr9aRtUOx8e/kUOfct9gE4X054+c7AAPZzyDrHCzww3LwiiAOBSQFjMrhJnazx7FOu42KBmwBPWLHFGsqcuuqtYaVnyoRQhAlQRd6qVeD8K6egXci4nULewv9QHWVGPzg+bTivjTjPKgik6z0SwcFU9fGB57qkHZ/PGwOgEX4RGhKedrQfXMKbOGDH4V48xL37EBuXrXL3eVniHSF1csZ9RHcumuaaIz5qn7Z0/kItbfGQOxkgeeyWBWcEpOYC1QVDzdEWhDNqNi9DyrYDhUDP5E8TS6U5OcWZy8d9MriecNNLafCMQMV21SY7rdZzJcX5M7jycoATsiXBbf+7Q==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3212.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74c1fac3-425a-4459-7f91-08d87fb63371
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2020 05:06:19.5037
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YpLXWfvrXykjayEcdAm6xtbJ+qagiZNici/VvKjsq0GVJRf/R4SkGS3TnR16UD/L1L+JEy7msX1aGJhPkLCI2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB1082
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-03_02:2020-11-02,2020-11-03 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Monday, November 2, 2020 11:23 PM
> To: Naveen Mamindlapalli <naveenm@marvell.com>
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> davem@davemloft.net; Sunil Kovvuri Goutham <sgoutham@marvell.com>; Linu
> Cherian <lcherian@marvell.com>; Geethasowjanya Akula
> <gakula@marvell.com>; Jerin Jacob Kollanukkaran <jerinj@marvell.com>;
> Subbaraya Sundeep Bhatta <sbhatta@marvell.com>; Hariprasad Kelam
> <hkelam@marvell.com>; Kiran Kumar Kokkilagadda
> <kirankumark@marvell.com>
> Subject: Re: [PATCH net-next 02/13] octeontx2-af: Verify MCAM entry
> channel and PF_FUNC
>=20
> On Mon, 2 Nov 2020 11:41:11 +0530 Naveen Mamindlapalli wrote:
> > From: Subbaraya Sundeep <sbhatta@marvell.com>
> >
> > This patch adds support to verify the channel number sent by mailbox
> > requester before writing MCAM entry for Ingress packets.
> > Similarly for Egress packets, verifying the PF_FUNC sent by the
> > mailbox user.
> >
> > Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> > Signed-off-by: Kiran Kumar K <kirankumark@marvell.com>
> > Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> > Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
>=20
> drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c:81:17: warning: incor=
rect
> type in assignment (different base types)
> drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c:81:17:    expected
> unsigned short [assigned] [usertype] pf_func
> drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c:81:17:    got restric=
ted
> __be16 [usertype]

I will fix these warnings in v2

Thanks,
Naveen
