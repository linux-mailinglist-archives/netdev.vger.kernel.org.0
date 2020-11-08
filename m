Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C79B02AA9D0
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 07:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbgKHGwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 01:52:15 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:26416 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726014AbgKHGwP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 01:52:15 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A86pkrC010677;
        Sat, 7 Nov 2020 22:51:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=zm5Wf+gr/E85Sp5bQGMaOmdI667q+KY3pvzPt8qx2ms=;
 b=SKXXiPvk4gnarwj6bxe7LZ5X9n55EQBrJmwIEx5aDHJnXrLhDQY1nwSBno4JWdEejTxD
 OYirvoMVt/C5AtZxzAruW1vycG6LxiJPDou2DAiCrLfXLF2q272JKL0Hi3YnFCzlX75T
 VMn1iifaKHTJCv56W+VtRftOembcjkur4K5Hj5OiUBDMpn0LuQQqbNqdPZafoeVpaTAk
 XXJnMNANG38GtbC2ygcrIriQbug1Pj+opdZic207wtZShUOIProOI9M+pD4lLOaVkhiY
 UUEwo3qSwLH1s6NzG3HpA3Q0m9hXX59rB+COhWSXGE/l1QyokUDgjK0MvckGTvtWF3Ur DQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 34nsttkvgm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 07 Nov 2020 22:51:46 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 7 Nov
 2020 22:51:45 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 7 Nov
 2020 22:51:45 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.175)
 by SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sat, 7 Nov 2020 22:51:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b+CAGlk/nm0KjdWy9Ag/7GOD2Y16v9Mc2tjFcdzF3Y7CL7dtdAPtumfDugGPABWmsnVdsTVwWi9fnAZJ4iWFtZLFTsKipyI7BFiWMFuOYdmOi3KUm77KKNzfVK4TCSp/mTDemwgMt8w34iyr7XRvcle4de7XncIhiRPSzqvibEw8QANo1sYlXGXv0dJxTPXzLtYL8gUzHitsNmM2cS3SNXq/1SyCoLoHjlyT3v2t0Btd6pXuzhs4twSs2m/GWQuZmYDDzp1koJFosHRcNebH7vXhTql7K3j8RDsz7ue7+u0ZVmzGvy4Lg8Rv56L5evMhiRxP2a5bgDG1WeWo71ndKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zm5Wf+gr/E85Sp5bQGMaOmdI667q+KY3pvzPt8qx2ms=;
 b=R8C78KSWz5/tQEpDbTYPWo1HsaR9Ug4d+H5iIN8V1x9nrPvkzbsqF4THto+NmUdaiVQXke3JJTMYL4Ts3P+FnhSivJIGFHgOqS0IFWO/Jl0KyGW/UpiHG40BMUfNLb5YWkO/SQZn+o/L43RlF0RKuzb3Wm0a1qISOydcqLnmYrKF9Blt9aksdpih63he7cb79LprMn4/EqGEAoC6grQAdF0x00/wACvl8uxa2mn1yo1R5Nxi+VREQbTehZSjEHOE/3yIxYQpFBBB6tH2ffvvGg6Ox7QcUZVpH5zLnq/edFDjjAG8GupcZy5HgDBOBZ+6v4AyUefcz432d4/MjJL/Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zm5Wf+gr/E85Sp5bQGMaOmdI667q+KY3pvzPt8qx2ms=;
 b=MUF4l3KtJ+Gdj5ywm1XjyxGupfZTSR7lWVJkCqwRCexkhvmLIIq2J0rDmNsnrQ7ybbcxlZmEDj6s7jGXggvbSM3UtykNf5My7m2qw4cQjSKYMuL671hj+fOLqdSy0E0shyBOhNrF68GNmPW5KSHCq3D+l+PtbIPOTbD5hXud26A=
Received: from PH0PR18MB3845.namprd18.prod.outlook.com (2603:10b6:510:27::11)
 by PH0PR18MB4088.namprd18.prod.outlook.com (2603:10b6:510:3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Sun, 8 Nov
 2020 06:51:44 +0000
Received: from PH0PR18MB3845.namprd18.prod.outlook.com
 ([fe80::89df:9094:449f:db13]) by PH0PR18MB3845.namprd18.prod.outlook.com
 ([fe80::89df:9094:449f:db13%4]) with mapi id 15.20.3541.025; Sun, 8 Nov 2020
 06:51:44 +0000
From:   Shai Malin <smalin@marvell.com>
To:     "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "Sagi Grimberg" <sagi@grimberg.me>,
        Boris Pismenny <borispismenny@gmail.com>,
        Boris Pismenny <borisp@mellanox.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>, "hch@lst.de" <hch@lst.de>,
        "axboe@fb.com" <axboe@fb.com>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "edumazet@google.com" <edumazet@google.com>
CC:     Yoray Zack <yorayz@mellanox.com>,
        Ben Ben-Ishay <benishay@mellanox.com>,
        "boris.pismenny@gmail.com" <boris.pismenny@gmail.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>
Subject: RE: [PATCH net-next RFC v1 05/10] nvme-tcp: Add DDP offload control
 path
Thread-Topic: [PATCH net-next RFC v1 05/10] nvme-tcp: Add DDP offload control
 path
Thread-Index: AQHWl0YkhZx0w+eA2kKERaDc7kEIzKmOU6cAgCzu6ACAAsQ98A==
Date:   Sun, 8 Nov 2020 06:51:43 +0000
Message-ID: <PH0PR18MB3845CCB614E7D0EC51F91258CCEB0@PH0PR18MB3845.namprd18.prod.outlook.com>
References: <20200930162010.21610-1-borisp@mellanox.com>
 <20200930162010.21610-6-borisp@mellanox.com>
 <c6bb16cc-fdda-3c4e-41f6-9155911aa2c8@grimberg.me>
 <PH0PR18MB3845430DDF572E0DD4832D06CCED0@PH0PR18MB3845.namprd18.prod.outlook.com>
In-Reply-To: <PH0PR18MB3845430DDF572E0DD4832D06CCED0@PH0PR18MB3845.namprd18.prod.outlook.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lists.infradead.org; dkim=none (message not signed)
 header.d=none;lists.infradead.org; dmarc=none action=none
 header.from=marvell.com;
x-originating-ip: [79.179.110.211]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3d768dc4-e3fb-47c0-ae7b-08d883b2c11d
x-ms-traffictypediagnostic: PH0PR18MB4088:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR18MB4088F123786DDCA91B2C25A8CCEB0@PH0PR18MB4088.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Yan8s1p7a1CRPVYEY3nu/gvhb8LrA35p6LwBK/YpHX3Cf0matlNE3IxAruBWT3beOR16cEUPzyMgHIR0f9zK3zIg419IR9Divd38NmX1ByHqwsq4lU3Nu16AgbfYezv9phBGhqlCH0GKQmY7qvWBIyNnPO4wN3TmQFaaCtSJKbegHfyZdhm6WkDv9c2KFjUIYgYcvLKUxEWUbDM6Tw3sm++oc4Yp+ViXTXcAbg/Oto2ih6y2sOMTANoUfRfWX9Fw2UyX3GDIEly+KEEnwJWO1aMCRFOvvPEVgdeiNrliqjZB0ruNWMn0ewqnPAIOGKp0EIjLuRkRQWDI5cfmXOmcSyZhrnggO7oIANEK5hHzqND6KNpVqSiecz/bOWDHTHPt
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR18MB3845.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39850400004)(366004)(396003)(136003)(376002)(54906003)(33656002)(55016002)(86362001)(4326008)(9686003)(76116006)(52536014)(66476007)(66556008)(2906002)(66446008)(64756008)(478600001)(66946007)(110136005)(316002)(83380400001)(26005)(186003)(71200400001)(7696005)(53546011)(6506007)(107886003)(7416002)(8936002)(8676002)(5660300002)(921003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: +IPkZauVLZMWbSNQ131G+z7wG40rDM3mzbjCXdBg+NEag0oeIXBX8S57PkhSDLv/4hZ7DcHq0mrZTd0TO4MCepPgp88MHAbA3wZHtoN9q75UeWQ1Qgo4XaAN5lx97F+CLLNbuJ1+8Kgb0Brom7p5YKgfW4mjSPAb/GtIJ2+Bn0/aIqE3K3QTaL1K59Vgp6E1SmJWHmzR15uXHQ8YikvMwqQ6J4NJ7iVzjdSFoYoT1v5seEDs5fIwrBzxP+DRGuAmH698O8auPu/3EtU39/LEno+mjWHf8bG33Ki+tVL2WFklDOH9r+dXdi5iRVqjJveEqN99h6hEWYONJxZhNDan30gYaSK2xtDsEzQ1Zx8pg7lH9rQVz5MiTjmfkFhob7nVPt/JT5OAhq8KRnv1j5NwaXEMOe8pwSHTuKno1JjouxiR6fREeL4bIFzuG+HOloO/0X8KSKO2lLmSoW4xMQZgO8Fg/9j79POPIIOe9RXakrwE1x577WfBteEstGgA3IEq5H/1YEQBHGm0CUZs0cuesPt+btmArwaUc8euJ3wcU8PXIAfe+CCuyZRs1gUy4/LnsYBrdlhtH5f4oPYLlZZDNkHcTh0z8iuyGM+UVNgT4CXFDMuXHxYzNSlTGV6oNA691KyTj0eL5WuAkI+G1LgVPA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR18MB3845.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d768dc4-e3fb-47c0-ae7b-08d883b2c11d
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2020 06:51:43.9304
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ipkdsriRvt1/GAullznisYxg8vvOsmSSFNbNRZ17uqwTjNQ7gTOk6bEoc+8I3LpONvBFGI3QrfnTUTyx8kLU+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR18MB4088
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-08_01:2020-11-05,2020-11-08 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 09/10/2020 1:19, Sagi Grimberg wrote:
> On 9/30/20 9:20 AM, Boris Pismenny wrote:
> > This commit introduces direct data placement offload to NVME TCP.
> > There is a context per queue, which is established after the=20
> > handshake using the tcp_ddp_sk_add/del NDOs.
> >
> > Additionally, a resynchronization routine is used to assist hardware=20
> > recovery from TCP OOO, and continue the offload.
> > Resynchronization operates as follows:
> > 1. TCP OOO causes the NIC HW to stop the offload 2. NIC HW=20
> > identifies a PDU header at some TCP sequence number, and asks=20
> > NVMe-TCP to
> confirm
> > it.
> > This request is delivered from the NIC driver to NVMe-TCP by first=20
> > finding the socket for the packet that triggered the request, and=20
> > then fiding the nvme_tcp_queue that is used by this routine.
> > Finally, the request is recorded in the nvme_tcp_queue.
> > 3. When NVMe-TCP observes the requested TCP sequence, it will=20
> > compare it with the PDU header TCP sequence, and report the result=20
> > to the NIC driver (tcp_ddp_resync), which will update the HW, and=20
> > resume offload when all is successful.
> >
> > Furthermore, we let the offloading driver advertise what is the max=20
> > hw sectors/segments via tcp_ddp_limits.
> >
> > A follow-up patch introduces the data-path changes required for this=20
> > offload.
> >
> > Signed-off-by: Boris Pismenny <borisp@mellanox.com>
> > Signed-off-by: Ben Ben-Ishay <benishay@mellanox.com>
> > Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
> > Signed-off-by: Yoray Zack <yorayz@mellanox.com>
> > ---
> >   drivers/nvme/host/tcp.c  | 188
> +++++++++++++++++++++++++++++++++++++++
> >   include/linux/nvme-tcp.h |   2 +
> >   2 files changed, 190 insertions(+)
> >
> > diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c index
> > 8f4f29f18b8c..06711ac095f2 100644
> > --- a/drivers/nvme/host/tcp.c
> > +++ b/drivers/nvme/host/tcp.c
> > @@ -62,6 +62,7 @@ enum nvme_tcp_queue_flags {
> >   	NVME_TCP_Q_ALLOCATED	=3D 0,
> >   	NVME_TCP_Q_LIVE		=3D 1,
> >   	NVME_TCP_Q_POLLING	=3D 2,
> > +	NVME_TCP_Q_OFFLOADS     =3D 3,

Sagi - following our discussion and your suggestions regarding the NVMeTCP =
Offload ULP module that we are working on at Marvell in which a TCP_OFFLOAD=
 transport type would be added, we are concerned that perhaps the generic t=
erm "offload" for both the transport type (for the Marvell work) and for th=
e DDP and CRC offload queue (for the Mellanox work) may be misleading and c=
onfusing to developers and to users. Perhaps the naming should be "direct d=
ata placement", e.g. NVME_TCP_Q_DDP or NVME_TCP_Q_DIRECT?
Also, no need to quote the entire patch. Just a few lines above your respon=
se like I did here.

