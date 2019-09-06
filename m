Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79DE6AC19B
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 22:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388647AbfIFUt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 16:49:26 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:1696 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732650AbfIFUt0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 16:49:26 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x86KnJgZ029529
        for <netdev@vger.kernel.org>; Fri, 6 Sep 2019 13:49:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : subject
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0818; bh=CQB9veAN2WoLnfkqh9BS/hrRMJtQ+zzyMLWUh/x0rWw=;
 b=BUkeB10Kgb40iCuTeL9+OkWQYsnXDQNiXmEnPOfiXDRNyXuplHnrs7/+Xly6C8rxFtYG
 SUWtk4+ysSQmKZoRTG/jy6QdhHCTjhsNLgMSRkiDqtMLld1MvY43qDRYuXfrP5fr7Dd4
 A9mXZ33ctoWhKTe/LtqGBcNoAbjMSylA854aFB0Bhz0VEZqANij0MzGBriTLd/8jr53V
 iaqZ/CfGVbJB8s0clHBJgeCldiirfLDvUSlaxH/0OK/K9nn/HY7HQVCudwr8mf7XxY3O
 OEggfwDh8cT3F8D3Vwlo7y7YvWO5rheLD/LAHHMLov9tKiNWslzCy4FTfOZpi/NeU7Ib WA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2uuuu70sgn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 13:49:24 -0700
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Fri, 6 Sep
 2019 13:49:22 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.56) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Fri, 6 Sep 2019 13:49:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=npWRkNokxAcBl2tMoz9I/nnsksJPnjwgLbn2VnbzpraXFvBb/qTCWP7Dt3lsGjMwce2KIR3i4IjjSwNt96Nv/RVjENonwYw5mReAeveMirhDUl7jBEcstwFWh3skRy1wGrVdFBtcr7WdKSFxC/BKoUFuDBgjaflllXyJv40q/lyEA2CjPxet/i7zrMsH3z0pZSPiEdQ9lIhAluVMJwxANNkCmtqXU+gTZJOO9ioEsb3v1aevie6PRTB5wO9/7yuXoM98zcQ+KBiYX1mKHNqBoMz3p8c9cI2zvzjMLlbHt8XC0o/zuPWU8eXvLdYgaY6ee/woyxN2EjLEsDF+Xv/guw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CQB9veAN2WoLnfkqh9BS/hrRMJtQ+zzyMLWUh/x0rWw=;
 b=Lr8tpiXbjkuanbwg7BgDnjRFqEGhhFucDa0ZqK95AqTudDzoEn9iawH7jVyFIDpctTRW/bd0NAZgctSo2jmkoS+ay5/+J2RprM3coKC9srzdkMOdE/HThGzerZzIa6W0mIyXPZySO1ZxM0vS3RbKjPk4KHZRQnZiwFrDpSaHl/z9bieeeXDWY9aak2UX5BIqlTZ6GeWMEdXU9sz0kYsvRaGmkKUOT18ULw4b0VgPgZs3ApEbwjRLKIiQs4L20lywhJfpFJg86JGaR3w73O3sfq8hjd2feLkMEXlZb9BxeWmG4yQXJEmpBotGVahmDnGC+QdIAnRy9PVvhhiwsafSnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CQB9veAN2WoLnfkqh9BS/hrRMJtQ+zzyMLWUh/x0rWw=;
 b=iq1ufdBPiwiiXUyFEQeIBKUocJyWlsrfjlyGEnmQckRHmBs/4Gog94NIhPoSPrWS0uQELxHUNAjn3F4yV9nq4zH8A5cYaKMAwTwGnZmyIJidHEnKE1dvpdkX/fhN/7o73IVaQ2QBMCe+vc9Lcv9Zz2CBnZvrUOdqZQ93Hr0A1LA=
Received: from DM6PR18MB3388.namprd18.prod.outlook.com (10.255.174.205) by
 DM6PR18MB2793.namprd18.prod.outlook.com (20.179.50.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Fri, 6 Sep 2019 20:49:21 +0000
Received: from DM6PR18MB3388.namprd18.prod.outlook.com
 ([fe80::1cce:a328:e947:c473]) by DM6PR18MB3388.namprd18.prod.outlook.com
 ([fe80::1cce:a328:e947:c473%5]) with mapi id 15.20.2241.018; Fri, 6 Sep 2019
 20:49:21 +0000
From:   Manish Chopra <manishc@marvell.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: ndo_xdp_xmit - on which queue to transmit the packet (if core_id >=
 total_xdp_queues ) ?
Thread-Topic: ndo_xdp_xmit - on which queue to transmit the packet (if core_id
 >= total_xdp_queues ) ?
Thread-Index: AdVk9IsdO6HlsUsCRa6batgqx5YKmg==
Date:   Fri, 6 Sep 2019 20:49:20 +0000
Message-ID: <DM6PR18MB3388D5F49B3A0A3522A40184ABBA0@DM6PR18MB3388.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2409:4042:270c:17a0:ac31:9d02:b80e:8358]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9e46c3d4-8597-4999-1725-08d7330bb174
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DM6PR18MB2793;
x-ms-traffictypediagnostic: DM6PR18MB2793:
x-microsoft-antispam-prvs: <DM6PR18MB2793686728ED18766562BF93ABBA0@DM6PR18MB2793.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0152EBA40F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(346002)(39850400004)(396003)(199004)(189003)(46003)(55016002)(5640700003)(9686003)(8676002)(53936002)(6506007)(102836004)(81156014)(476003)(486006)(1730700003)(99286004)(81166006)(6436002)(14454004)(186003)(7736002)(66946007)(66556008)(74316002)(76116006)(64756008)(66446008)(66476007)(305945005)(25786009)(7696005)(8936002)(5660300002)(4744005)(316002)(52536014)(33656002)(6116002)(86362001)(2906002)(256004)(6916009)(71200400001)(71190400001)(478600001)(2501003)(2351001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR18MB2793;H:DM6PR18MB3388.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 3678rlcyZts7A+Rj8Qog/+dmVNhrMVAk8fqVbk/Zk+YLZMJwx7TYLgI2LbPy2CzIgQ464jmAUz38TqRD2TJC9DRYSB7qo5rKCNaK4R/w2UQJpkA8uCGiH+XPQJv0sRo5G4RnQbUtAe7KfP7ocVHcc75FQGpG96i+cwb7FSlQ8HYaS3UR0Zk63mR+X1U/wgEvKzeX2smc6rKYNlm3Yq7gzVujSt7XZOirAezbho/JPCuPNzc2FoM/EYGtGiNa7KY6K13s0Adk77C5mDfI1pDmnlGRtyAj00REz+9r+Z934xjZ527N6Q/iDHjmaJVgG4FptVrqryRZNr6akiThJMEIAMON1tEdpTy2b9p0VxaEUhu84fCKd9Kg8b4PytyTXxvfS/CsXM9+lvQxIPfJp13EVoOQj5P3P0uin8ZvrXr7WJs=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e46c3d4-8597-4999-1725-08d7330bb174
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2019 20:49:20.9847
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DtlPiZU0fK2nIg4qw9XggeXkUUl83WQG+7yaNb/A7SccsM8UnhCoPkac4gXIsnJU4vO3dl05wPi/eMKIjX/RMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB2793
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-06_09:2019-09-04,2019-09-06 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I am working on XDP_REDIRECT implementation and got a query. Some of the et=
hernet drivers decide the xdp queue index on which xdp packet should be red=
irected based
on smp_processor_id() in their ndo_xdp_xmit() handler, if smp_processor_id(=
) >=3D total_num_xdp_queues, they decide to drop the packets and return err=
or from the handler.
I am hitting the same condition where using 8 XDP queues, I get CPU id 8 to=
 redirect the XDP packet and I am not sure if it should be dropped or can b=
e transmitted on a
queue (=3D smp_processor_id() % total_num_xdp_queues) safely ?.

freescale/dpaa2 seems to be handling this case by sending the packet on the=
 queue (=3D smp_processor_id() % total_num_xdp_queues) but unsure what shou=
ld be the expected behavior.=20

Regards,
Manish Chopra.
