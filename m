Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25DED11DC83
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 04:13:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727789AbfLMDN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 22:13:27 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:5268 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726631AbfLMDN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 22:13:27 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBD3BONa025041;
        Thu, 12 Dec 2019 19:13:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0818; bh=jHXy15QEwjWW6lcWIbJsN6gqgKYFOy2yXeUtkUmWiHA=;
 b=kdUqsEnevSAcsjgnf9AkoXoF2e/P74hJm7NihHF/TJl+yvV1z2xyorlzUw3pVjOuMET0
 HJ8m0u9TniVMrtel8kzB2aBVgS4+eKVQWGWib2wTKyTs4uTkjBNxotsCT+Zpothaamy7
 0WTg0O4sOzrIBLsNyVh54qshSKSyM328OAcD8/uwbQRl2fU3ICQNNlqvu1wdCzB1I/IE
 M/W6R4zmnJcvCqTX9os9R2PmLTKhmO0APG+/mUlF9VEYex18W6Hwcv+cxSbUHXbtPdsx
 aPvDBGJNlVg5OdjM4VChmPbRZYb0WTXWXefhR1uarJANtIDbMuItFkb/Z6gcmQWUqAeM sw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2wue9mvhu3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 12 Dec 2019 19:13:24 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 12 Dec
 2019 19:13:22 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 12 Dec 2019 19:13:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PYIMTI/dsJhjxK7a5UtrYOgUPs7L1dLnwLElzFAu7zHQ5RkIGcpB8kNWbskcUK2iUyrAe+gDHUPHoXpgL3QRPrBZAWK4M5OfbcihIF9S37OUZFoM9aYtSdsZ/8YNrQ5NBUZwLsDDMiZIhVKasVOsySJqPjm7XzoF7G+VT4aBJXxI4Qprqg//lJ8ni8gjl7JL77E/yf/ze1+atLX/7PDhXXuwZDlMzw2pnEnoOrOzmXDOJg20z9XtK6QTS/2S3B0+2/ERlUdL64uWUkZLHi83qqEn9/Kg/tvJzQmPnkzhpvpG+AKF7DCOw+nahYee4nwdHa29kY/AKo7+w3EmwuzL9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jHXy15QEwjWW6lcWIbJsN6gqgKYFOy2yXeUtkUmWiHA=;
 b=ajJ1ewheEPs/XD6lNk3srY+sOfxkbSWxXMEpwXcd3wHjhxuTyS9p8Xqdy8KcPJ25Dh3Cjal1fsk7NJFwjFDUA1JuvDMmdncZ+IAYst4PeaEwxgJCqYYsmRLlFMdIw5/mSvMR8LkKv4OWQdSMHVTYxuI+pSu+fe9o/f0toWF/OK4huSnBtlPAA2Q9DRyxsgV2/BePsMRdI05HFin1r+6gJWGWXASpd6YCEE4y8arTBsqhR3NO6q/WlczkrA1ndnNdJ3WPRCKPzjemYjdzrxA596GMw+yijBDGYQO9yk/189SKiT0kFupdx81KRmg7WZ++m9iX9OfaPQNcIQiagn4WoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jHXy15QEwjWW6lcWIbJsN6gqgKYFOy2yXeUtkUmWiHA=;
 b=PF1CZWX4hmt16MrbYGpvmB2E33ObetIh8HbHBXqDPTbbgEcvm9E3dOjBOQcyIjB2rGXYFyhtyFSH8TO56JQh5LdkSSp3Fd/6lxADlu8SeHvcJG5PdqY9gYVkIpEYTUmmxNi+SgdVYpqwpjbJxKvzA2DrRLDwzmmgDAElOt5rtoE=
Received: from DM6PR18MB3388.namprd18.prod.outlook.com (10.255.174.205) by
 DM6PR18MB2474.namprd18.prod.outlook.com (20.179.106.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Fri, 13 Dec 2019 03:13:21 +0000
Received: from DM6PR18MB3388.namprd18.prod.outlook.com
 ([fe80::b18e:16c:b407:64d3]) by DM6PR18MB3388.namprd18.prod.outlook.com
 ([fe80::b18e:16c:b407:64d3%2]) with mapi id 15.20.2516.018; Fri, 13 Dec 2019
 03:13:21 +0000
From:   Manish Chopra <manishc@marvell.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        Manish Chopra <manishc@marvell.com>
Subject: LRO/HW_GRO is not disabled when native xdp is installed
Thread-Topic: LRO/HW_GRO is not disabled when native xdp is installed
Thread-Index: AdWxYyOH9Q0NPNE5QOubY6DZVvHbMw==
Date:   Fri, 13 Dec 2019 03:13:21 +0000
Message-ID: <DM6PR18MB338861990B56CCA5A4384779AB540@DM6PR18MB3388.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2405:204:908d:b8a0:1d9f:24aa:ca39:806]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7ff273e5-1f7f-4977-9e6b-08d77f7a68cb
x-ms-traffictypediagnostic: DM6PR18MB2474:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR18MB24742F828C4F71C0E8BC833EAB540@DM6PR18MB2474.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0250B840C1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(136003)(366004)(346002)(376002)(189003)(199004)(86362001)(5660300002)(66476007)(64756008)(66446008)(2906002)(316002)(66556008)(186003)(478600001)(7696005)(6506007)(6916009)(76116006)(66946007)(33656002)(9686003)(55016002)(52536014)(107886003)(54906003)(4326008)(71200400001)(8936002)(81166006)(8676002)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR18MB2474;H:DM6PR18MB3388.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Hjuc2O0pYdKoGK7wjys1fG/ZFS/gaOaucgN42+LbXamroe4ONui90piROvtbTn5tMv/3iAa8ZQGDVtu5Bb+9UifJ4F3BhrZWiMega3D6F0oBCNqMlom06/r5MaBneGAOrEFthaC2NcQAAWcFCWsmoNmMGeALpkWs06q6cYVSJDamipuz6PopZJg3n5TGUdhYHvZPp8N7Glc89XOq/jNLPkaOqC/DbI864bjQtgWIGA29zShr3AWEN3NVrpuAkXbJUl6N7ItH8Wp/3EXQ9KjkrJPCpLlH2SFquNUI3k0wYxvCXfKm/aLlZMsOrSA5QNItFOTPfiyoUC2+VSd2zwM2xi+O0WezltnV+PjpE+eQD3PMJVJ2rFT+poAd9GfNeC/0wRHt8vzOgFmeDHjytrGoQi5MRVaTnwCyNIGB02oviDtdb7SzuRlpZmHmDmt8OFSM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ff273e5-1f7f-4977-9e6b-08d77f7a68cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2019 03:13:21.6537
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: npdtYNuEIhCrnfToAdtiXoxGbVXumYB6gCrzRg1P5bvU1k8zT58iMb8JP5kU9FpMYxul1ETddNB2U2cgy+qLow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB2474
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-12_08:2019-12-12,2019-12-12 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

When attaching native xdp program, device's aggregation features (i.e LRO/H=
W_GRO) are not getting disabled.=20
They seems to be getting disabled only in case of generic xdp install, not =
in case of native/driver mode xdp,
Shouldn't it be done something like below ?? if so, please let me know if I=
 can post a patch like below.

diff --git a/net/core/dev.c b/net/core/dev.c
index c7db39926769..8a128a34378f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4580,8 +4580,6 @@ static int generic_xdp_install(struct net_device *dev=
, struct netdev_bpf *xdp)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 stati=
c_key_slow_dec(&generic_xdp_needed);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 } else if (new && !old) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 stati=
c_key_slow_inc(&generic_xdp_needed);
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_dis=
able_lro(dev);
-=A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0dev_dis=
able_gro_hw(dev);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 break;

@@ -7216,8 +7214,12 @@ int dev_change_xdp_fd(struct net_device *dev, struct=
 netlink_ext_ack *extack,
=A0=A0=A0=A0=A0=A0=A0 }

=A0=A0=A0=A0=A0=A0=A0 err =3D dev_xdp_install(dev, bpf_op, extack, flags, p=
rog);
-=A0=A0=A0=A0=A0=A0 if (err < 0 && prog)
+=A0=A0=A0=A0=A0=A0 if (err < 0 && prog) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 bpf_prog_put(prog);
+=A0=A0=A0=A0=A0=A0 } else {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_disable_lro(dev);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_disable_gro_hw(dev);
+=A0=A0=A0=A0=A0=A0 }

=A0=A0=A0=A0=A0=A0=A0 return err;
}

Thanks,
Manish

