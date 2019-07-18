Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAB176CC9A
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 12:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727701AbfGRKN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 06:13:56 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:42922 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726454AbfGRKN4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 06:13:56 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x6IA9jIu029669;
        Thu, 18 Jul 2019 03:12:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=9qhUbsemVLP7aNlbL5PoiaJx8BdWGkPdFBidX9kgWjo=;
 b=UVlSVAgYoNFdt8wAx3rB+bqmWvluUafa9J5ginbIsoBDdO9XAzRNvMzBvU7WwHGP/tnC
 VjSjdVxQOTVIdKM4p9bsGGNRhuj0Iihz3Jtsbddz4E01MQcEz4+q/U2KKEwpmYyx4NnY
 Ac9u0OgjKHTm8g1ZVWT2ex+J5kELzLrpizrL/OCJM6v4DAIXRXILYUAh0nppX3NQfOse
 WURrWvtPdo/RERbvWoql6mgqyVfh46VbelIreKH/rtHzdWbIU/9gMQgE5kYzPqpBpPux
 nRKtP5EDLoxVqLFWkbyO+qIZRLGXsxRikixe9m8n22kXkweBfc7Tc7uV3bVnt75N5MRA rQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2ts0a2bgn9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 18 Jul 2019 03:12:24 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 18 Jul
 2019 03:12:22 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (104.47.32.54) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 18 Jul 2019 03:12:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QPNK20rsBwdO8iUlDosuJJfvEU0rqBJ2tlEGEf7krAefI6Mf1cN6AK/qPyZaOz07CRB2uMjX4kbTTUDA7k1sv9YLDLtQKJ+CAJQ1HLhTAms1t6mfD/e4/ypAJbu4zrCWdUs0SybA9bgr6RLAWBik4JcQ2MN5bg/S0W5URtsGRwI+ykW7s7V53XB+e1ifJMqDr3GY+7YPX9hsoIiifmPCPEKtBM1T65v6HZwUda6npEvRbeM0jbLrsWst113izn6fcp2fncJhHELBXRXRTVaNSeECmZIYxJekhfhgyNeLQruejYAGFlFJU7efJPoLYSRVdlCxKEGRC5/SKcrxEFdYBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9qhUbsemVLP7aNlbL5PoiaJx8BdWGkPdFBidX9kgWjo=;
 b=UO+EaV7OoFeUgC11haSby3efiioSP65v7Q1A7gTNuqlWhn2G/jMMY7SFOMKPJmKVQR/qf50yu7khsYgAxZEiiVKEniSmWlsx1EkPbPq/LFQX3bvmT6JQs3qfU4sUvPyPqAzCmhJt4qAUGYTm11/So/Cx1XrYPFCABeNECy1eMcOItbrkrJNm7hjttujRTM/6BTwdOwKZyS+E2gq5PB5zfcm5ks3GDUypyxWmJAl/bQugXJklObKLx46cTEvIaXqMedNtguGH//DqAc6rjbBDjEF5HgTFArM/2AwB+eA+U4vUYTr6B5QFkCgxL8/Lq3DhD0mVD3SOC3XVhlCEeZ0jUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=marvell.com;dmarc=pass action=none
 header.from=marvell.com;dkim=pass header.d=marvell.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9qhUbsemVLP7aNlbL5PoiaJx8BdWGkPdFBidX9kgWjo=;
 b=TYLSkEQTMHDxjxpr5ouXh59NvuvflOj1a7HC/I9CONaRRTFRlSHIb1tE7IwVTmHxn0Xue8lo7RM+npqd2CJFm6bFzvjbOtDeAW4DUKIZDpPbTopsOsMtONM+aTN6yZTJ2UkFYZiLQJbEWp3bTIE162CglN2JgZOfjNHRmw4dBkk=
Received: from DM6PR18MB2697.namprd18.prod.outlook.com (20.179.49.204) by
 DM6PR18MB2954.namprd18.prod.outlook.com (20.179.50.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Thu, 18 Jul 2019 10:12:20 +0000
Received: from DM6PR18MB2697.namprd18.prod.outlook.com
 ([fe80::4dfc:58ee:74f6:4e05]) by DM6PR18MB2697.namprd18.prod.outlook.com
 ([fe80::4dfc:58ee:74f6:4e05%5]) with mapi id 15.20.2073.012; Thu, 18 Jul 2019
 10:12:20 +0000
From:   Manish Chopra <manishc@marvell.com>
To:     Brian King <brking@linux.vnet.ibm.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>
CC:     Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] [PATCH] bnx2x: Prevent load reordering in tx completion
 processing
Thread-Topic: [EXT] [PATCH] bnx2x: Prevent load reordering in tx completion
 processing
Thread-Index: AQHVO1Y5fnqDy0Qkck+BsN4Ckh4KAqbQK98Q
Date:   Thu, 18 Jul 2019 10:12:20 +0000
Message-ID: <DM6PR18MB2697C972B49EAD3AE7C3F37AABC80@DM6PR18MB2697.namprd18.prod.outlook.com>
References: <1563226910-21660-1-git-send-email-brking@linux.vnet.ibm.com>
In-Reply-To: <1563226910-21660-1-git-send-email-brking@linux.vnet.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2409:4042:2103:ad8b:b927:61f1:6bda:ba8d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8a43af1a-2861-4448-155e-08d70b686b7e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DM6PR18MB2954;
x-ms-traffictypediagnostic: DM6PR18MB2954:
x-microsoft-antispam-prvs: <DM6PR18MB2954CB714AC0AFB3B89D2C16ABC80@DM6PR18MB2954.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 01026E1310
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(39840400004)(346002)(376002)(136003)(189003)(199004)(13464003)(86362001)(71190400001)(53936002)(486006)(71200400001)(53546011)(6506007)(7736002)(52536014)(478600001)(7696005)(66946007)(102836004)(66446008)(64756008)(6436002)(76116006)(229853002)(4326008)(9686003)(6636002)(55016002)(66476007)(5660300002)(46003)(305945005)(25786009)(54906003)(81156014)(476003)(446003)(8936002)(81166006)(6246003)(11346002)(8676002)(186003)(256004)(99286004)(2906002)(76176011)(66556008)(110136005)(33656002)(68736007)(14454004)(74316002)(316002)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR18MB2954;H:DM6PR18MB2697.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: gvnESRxZQ072XJ4NpqZvH5MVMC58ai68x/PgmIhAJBGh9+mVvWMusz0eOemsm6QDPufXmlxqhxoRGvN4a71dvg/Ak/IN1fA5sbcGiYjhpcN+Sgev7kIrqWLSNc19NRKnlU7UhF/nKW4VjwTQTARKTRARFJgAlb+3jXPWyG9AoikDWkNbvOS5hDnY0wgH/q5U1MPTpl9BYQpNTcew1782IudaIqwhvDgM5KeA/WgHszOUFdUUFntPXEqWmqvIfjm2alq5d+bsEg4Td1KPLuRVMJysSPbwerEDwLfF//qkqIz8zh1bxjp8j5iXItZlMIKeUm11PinkEfje39zouVWJF1cfxZ0dXO0syWIPLPPCBqOuc05ZQPUQnoUfqhJT2dCsVcJylZzZzE9hAwhKhIhBXWxn/EXH2vaXjpEbKVjC1kY=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a43af1a-2861-4448-155e-08d70b686b7e
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2019 10:12:20.2704
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: manishc@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB2954
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-07-18_05:2019-07-18,2019-07-18 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Brian King <brking@linux.vnet.ibm.com>
> Sent: Tuesday, July 16, 2019 3:12 AM
> To: GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>
> Cc: Sudarsana Reddy Kalluru <skalluru@marvell.com>; Ariel Elior
> <aelior@marvell.com>; netdev@vger.kernel.org; Brian King
> <brking@linux.vnet.ibm.com>
> Subject: [EXT] [PATCH] bnx2x: Prevent load reordering in tx completion
> processing
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> This patch fixes an issue seen on Power systems with bnx2x which results =
in
> the skb is NULL WARN_ON in bnx2x_free_tx_pkt firing due to the skb pointe=
r
> getting loaded in bnx2x_free_tx_pkt prior to the hw_cons load in
> bnx2x_tx_int. Adding a read memory barrier resolves the issue.
>=20
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
> ---
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
> b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
> index 656ed80..e2be5a6 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
> @@ -285,6 +285,9 @@ int bnx2x_tx_int(struct bnx2x *bp, struct
> bnx2x_fp_txdata *txdata)
>  	hw_cons =3D le16_to_cpu(*txdata->tx_cons_sb);
>  	sw_cons =3D txdata->tx_pkt_cons;
>=20
> +	/* Ensure subsequent loads occur after hw_cons */
> +	smp_rmb();
> +
>  	while (sw_cons !=3D hw_cons) {
>  		u16 pkt_cons;
>=20
> --
> 1.8.3.1

Could you please explain a bit in detail what could have caused skb to NULL=
 exactly ?
Curious that if skb would have been NULL for some reason it did not cause N=
ULL pointer dereference in bnx2x_free_tx_pkt() on below call -

prefetch(&skb->end);

Which is prior to the said WARN_ON(!skb) in bnx2x_free_tx_pkt().
