Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA61C2F26F3
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 05:19:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729375AbhALESd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 23:18:33 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:5098 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726560AbhALESd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 23:18:33 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10C4FHwx025384;
        Mon, 11 Jan 2021 20:17:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=kY1ZGJUjOhMHW/8+ytG9jtytpbIBa87ihYRF19j0tDM=;
 b=XNUXKlGxIl0NOuMaC2GHBX+eB7y3h8EjakfS5nb0TGQLQCLJOtJ3kNcSnYZrEtZi0H02
 AEKHVy0+qbB1RNUV5g3rs1COzH0PtzBzuFAzZs/ZiMd0TZih7hGYD6SinuAnkA+NXthv
 sC57mCiKw1iKM9MAGNKf9OsdKFrK+HIp1UU+PwPVHRNkO6Qayh4756qP5N3Xgjq4RvkE
 kyr5OLQF6QmAsvCCVgz9nbyeYtpJTcDAeatVoWFJpC6BoxEvvpkuNYr5Uc7VOa629QEc
 cAajDi8xmJRuHLRpDCgNXFS0uVpb8MQqLNPJw+Z2hfP2OW6KbQLh0RXUpTF6gkt3o8wm cg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 35yaqspqdn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 20:17:47 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 11 Jan
 2021 20:17:46 -0800
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.57) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 11 Jan 2021 20:17:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PCNPt3CfAGTOWU6Az5DgYS12pHu2xDYuNFw7NdyENju1JbaHkmmdwgWO99FBEo3KigADRZe0LGeYmFlgeldPuCANzUhNLDT6ES56zDgbQfgtMVygL6leG0D2x9B1SnVcQbBG5atzU2RYBanYWqJVob/Q1YPObSOaYqGKKJPg8ycok26wiAEZF3CMxGjk8T3HQOolh4+bfbX/8CdX7GJASFe/zZrEVuFmD6INVBOGFZ4eq+75rdE68iRKTwYipgdz8yDJA5pUtNRyI6AvZzi1KILreB0bRDXBS36JjD3FYXf5s6os6r9NtmhuK5was62XI3i+zkiwcGbJnSJBnhNzbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kY1ZGJUjOhMHW/8+ytG9jtytpbIBa87ihYRF19j0tDM=;
 b=AN11Qz+4UQZdVEOPraPKHBbJ6Kngmg+2PD7sFNwn7x7hTqhv2Omop6m1+VzmJFSV2k8kmABU6gJ0TmPwrkDbpFaMmJH3F25Kfe63r1asSqsMB0lFhPuCh+vtMC5lYk4No3+Y31EXjwLvywc/3P/OGmjh9x/48YKP5krkhQIJ0/E5cF+2CAqa8xlalQpuawe4g4/TxXAYMLLNZE7xd1msxn6pFeWV2ZSJVuOV6CwONjnkSmoQW1lWYC42koilgKQxfGZwYXBH2OexjMnSx7lZhr+BXm8Sx9PPZHCbbmOxLWYUXGTQou7BXC/oQLzpZXLufiuUFN1UPE55I4d1MlFCvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kY1ZGJUjOhMHW/8+ytG9jtytpbIBa87ihYRF19j0tDM=;
 b=O1fg2bpbdtwbjnZ85c/zrmhPRA+ogWp1vqX8kdNXBjY0xQMp1jSFWkuwJIHy36BxIZZ1SW938IiTHOYGTTeXXhRbtI6x8LgKKW41OMVN8caKoarrXLeGqMpzsz2vGYUj7ldoSjcojzkQh/Qq4SAQQwwvPAZGu8VQLv0c7CnSj0Q=
Received: from DM6PR18MB2602.namprd18.prod.outlook.com (2603:10b6:5:15d::25)
 by DM6PR18MB2411.namprd18.prod.outlook.com (2603:10b6:5:15c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Tue, 12 Jan
 2021 04:17:44 +0000
Received: from DM6PR18MB2602.namprd18.prod.outlook.com
 ([fe80::d0c1:d773:7535:af80]) by DM6PR18MB2602.namprd18.prod.outlook.com
 ([fe80::d0c1:d773:7535:af80%6]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 04:17:44 +0000
From:   Geethasowjanya Akula <gakula@marvell.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: Re: [PATCv4 net-next] octeontx2-pf: Add RSS multi group support
Thread-Topic: [PATCv4 net-next] octeontx2-pf: Add RSS multi group support
Thread-Index: AQHW4molLA2YJtBEhEqeFulj9Mq5YKojbnva
Date:   Tue, 12 Jan 2021 04:17:44 +0000
Message-ID: <DM6PR18MB2602DD7FFC517C638D8876B9CDAA9@DM6PR18MB2602.namprd18.prod.outlook.com>
References: <20210104072039.27297-1-gakula@marvell.com>
In-Reply-To: <20210104072039.27297-1-gakula@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=marvell.com;
x-originating-ip: [106.66.46.84]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9d307510-45f5-4b03-17a4-08d8b6b102ed
x-ms-traffictypediagnostic: DM6PR18MB2411:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR18MB2411567B54DEFD825F650AC3CDAA9@DM6PR18MB2411.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2201;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PoBrgUvs4O3GjGj4HOKhAUMTy5XHHPC7kOEC91P9Z9ouzzFFCAPNak/OmMm5MGfi7tTUYMZNpMeAqDAdHzevvgNRTWX/bieGWquHroLy4ZGcHbIxtC9Xb1SK6FU6X7YIcbjch6Oc4VFLjNz7LZGs5/KoeTVjrqO348rfRXW9gYOA3bUDh8PM8m2yv8YxZ1Aq3Uallqz5fsu0vKK/fuIvlrhjQZe2spRlJSvtZiRq+XjeYcSRPJw7ofT28uu+wpEsrAzFFnapbqRrHy/d5nIWbvUrdh4RJtkrEh8B5Mo2+wbNw0AZjyBK1xQHDbszLMrHPMImI8CPyy6kJZe9KgMw3w5FlZoqY5pehx/P0wxt1mpg91T4Yd96kHouu8/hcYenqkP8CvRHBjY4XSU3kEL7Ww==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB2602.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(346002)(366004)(376002)(396003)(9686003)(8676002)(55016002)(52536014)(8936002)(26005)(55236004)(186003)(110136005)(64756008)(316002)(71200400001)(66476007)(66946007)(91956017)(4326008)(2906002)(6506007)(54906003)(66556008)(33656002)(76116006)(53546011)(7696005)(5660300002)(66446008)(30864003)(478600001)(83380400001)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?TBDYpDmN5KP2pDRLBp8eBoRheosZhCPA0kBD0vX6j8+dPw6NsI/p/Rmc/QLy?=
 =?us-ascii?Q?PD8SyTE2nLJOB8GfDro8FoX5RnsVS59+sCm2zL4KdSuee6uwIkiywKWK1kGR?=
 =?us-ascii?Q?gRXqdyRFWhRrrjQbEbDI1BWfTNTxqqCpRh8m5+xsu8jg+KSdf9IWvIJIMTHH?=
 =?us-ascii?Q?aTcCYi2dhFbEqdSCHZJg2OdqpuBmDubHOUPQ4CHz+uLhddmxHTd5PX9kp56N?=
 =?us-ascii?Q?WOo/7G16HQ9fRaeBzAT6f8DQ/s4GMW9LnhAengEiWaS3VIGh6s9Z6VVaXfuu?=
 =?us-ascii?Q?hTxRvoQwZ7T79JsmjeHN3SgAxLpYWNef55qPvw+Hbnf6DpzlTWSIg7jp8uOF?=
 =?us-ascii?Q?GgqhbueYjo6zhwssd5oHe+14CAAGYU3rENnLQNiGt1DJFIphBhYZp5c22ulV?=
 =?us-ascii?Q?JM17Q7XC28Bb2Xke3qce08A/PkZTvdOhxB9B+t3sCgQ20T0oWlPDIdvV4LZ8?=
 =?us-ascii?Q?FPUvEMDfjD1uiz97q9QTVY+QAVDjXJ532lmPUJXb0cdjDyoY/b+YXZLU3GPj?=
 =?us-ascii?Q?T3YDf1/9VFW0wdse6o0lDDSMUlP+0RVhyxZ53ZiArzhZI6C+tWPZLky1QNJS?=
 =?us-ascii?Q?DS2dClROQ+pUdga6LgnElRqrr3d0xLzENjdJkW9bvJ2LecVy5RCpc044MTEw?=
 =?us-ascii?Q?0tfPsMuKpZZqdlp6EyuIOT33O3JjYyhwzh792KoYbmefeTyJ8QS1/woOu+a3?=
 =?us-ascii?Q?HVA42d8ITB2cj1G+Iwbvp+xFxTCDIrt4bkL1DmYj2fb87T186nyXYYK/i1wT?=
 =?us-ascii?Q?W+/1wSY+vSnivOUuP+rogjrqzh+PovO7+quAlrMNlKwW5Nb1n7Yf8lH7s0Mv?=
 =?us-ascii?Q?99G+7VFOi8w9tI8x5cqCLW/Jk7vQffFevOY+IL9Y0Y35CyIs5DrPePz5CbDh?=
 =?us-ascii?Q?6YhwOk6u1Ju+qaqciuc8TK+RD6VIp2eU0i9SQTmyWawCDPAY8HxI1uax5xYj?=
 =?us-ascii?Q?ZQY2lSSxh93H90hOwjPOniQz7JOGSNiRGRbzoC3qM4s=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB2602.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d307510-45f5-4b03-17a4-08d8b6b102ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2021 04:17:44.6095
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3IZD985WcLP6QHXb11PXfC7TuwMpBmSs1DfCMtv4oEplcD0390UtQyobudPe/9O9Isu+j4lHy95fo2PEf4xobw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB2411
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_01:2021-01-11,2021-01-12 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

Any feedback on this patch.


Thank you,
Geetha.

________________________________________
From: Geetha sowjanya <gakula@marvell.com>
Sent: Monday, January 4, 2021 12:50 PM
To: netdev@vger.kernel.org; linux-kernel@vger.kernel.org
Cc: Sunil Kovvuri Goutham; davem@davemloft.net; kuba@kernel.org; Geethasowj=
anya Akula
Subject: [PATCv4 net-next] octeontx2-pf: Add RSS multi group support

Hardware supports 8 RSS groups per interface. Currently we are using
only group '0'. This patch allows user to create new RSS groups/contexts
and use the same as destination for flow steering rules.

usage:
To steer the traffic to RQ 2,3

ethtool -X eth0 weight 0 0 1 1 context new
(It will print the allocated context id number)
New RSS context is 1

ethtool -N eth0 flow-type tcp4 dst-port 80 context 1 loc 1

To delete the context
ethtool -X eth0 context 1 delete

When an RSS context is removed, the active classification
rules using this context are also removed.

Change-log:

v4
- Fixed compiletime warning.
- Address Saeed's comments on v3.

v3
- Coverted otx2_set_rxfh() to use new function.

v2
- Removed unrelated whitespace
- Coverted otx2_get_rxfh() to use new function.


Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
---
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |  26 ++--
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  11 +-
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  | 133 ++++++++++++++++-=
----
 .../ethernet/marvell/octeontx2/nic/otx2_flows.c    |  37 +++++-
 4 files changed, 163 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/dri=
vers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 73fb94d..bdfa2e2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -270,14 +270,17 @@ int otx2_set_flowkey_cfg(struct otx2_nic *pfvf)
        return err;
 }

-int otx2_set_rss_table(struct otx2_nic *pfvf)
+int otx2_set_rss_table(struct otx2_nic *pfvf, int ctx_id)
 {
        struct otx2_rss_info *rss =3D &pfvf->hw.rss_info;
+       const int index =3D rss->rss_size * ctx_id;
        struct mbox *mbox =3D &pfvf->mbox;
+       struct otx2_rss_ctx *rss_ctx;
        struct nix_aq_enq_req *aq;
        int idx, err;

        mutex_lock(&mbox->lock);
+       rss_ctx =3D rss->rss_ctx[ctx_id];
        /* Get memory to put this msg */
        for (idx =3D 0; idx < rss->rss_size; idx++) {
                aq =3D otx2_mbox_alloc_msg_nix_aq_enq(mbox);
@@ -297,10 +300,10 @@ int otx2_set_rss_table(struct otx2_nic *pfvf)
                        }
                }

-               aq->rss.rq =3D rss->ind_tbl[idx];
+               aq->rss.rq =3D rss_ctx->ind_tbl[idx];

                /* Fill AQ info */
-               aq->qidx =3D idx;
+               aq->qidx =3D index + idx;
                aq->ctype =3D NIX_AQ_CTYPE_RSS;
                aq->op =3D NIX_AQ_INSTOP_INIT;
        }
@@ -335,9 +338,10 @@ void otx2_set_rss_key(struct otx2_nic *pfvf)
 int otx2_rss_init(struct otx2_nic *pfvf)
 {
        struct otx2_rss_info *rss =3D &pfvf->hw.rss_info;
+       struct otx2_rss_ctx *rss_ctx;
        int idx, ret =3D 0;

-       rss->rss_size =3D sizeof(rss->ind_tbl);
+       rss->rss_size =3D sizeof(*rss->rss_ctx[DEFAULT_RSS_CONTEXT_GROUP]);

        /* Init RSS key if it is not setup already */
        if (!rss->enable)
@@ -345,13 +349,19 @@ int otx2_rss_init(struct otx2_nic *pfvf)
        otx2_set_rss_key(pfvf);

        if (!netif_is_rxfh_configured(pfvf->netdev)) {
-               /* Default indirection table */
+               /* Set RSS group 0 as default indirection table */
+               rss->rss_ctx[DEFAULT_RSS_CONTEXT_GROUP] =3D kzalloc(rss->rs=
s_size,
+                                                                 GFP_KERNE=
L);
+               if (!rss->rss_ctx[DEFAULT_RSS_CONTEXT_GROUP])
+                       return -ENOMEM;
+
+               rss_ctx =3D rss->rss_ctx[DEFAULT_RSS_CONTEXT_GROUP];
                for (idx =3D 0; idx < rss->rss_size; idx++)
-                       rss->ind_tbl[idx] =3D
+                       rss_ctx->ind_tbl[idx] =3D
                                ethtool_rxfh_indir_default(idx,
                                                           pfvf->hw.rx_queu=
es);
        }
-       ret =3D otx2_set_rss_table(pfvf);
+       ret =3D otx2_set_rss_table(pfvf, DEFAULT_RSS_CONTEXT_GROUP);
        if (ret)
                return ret;

@@ -986,7 +996,7 @@ int otx2_config_nix(struct otx2_nic *pfvf)
        nixlf->sq_cnt =3D pfvf->hw.tx_queues;
        nixlf->cq_cnt =3D pfvf->qset.cq_cnt;
        nixlf->rss_sz =3D MAX_RSS_INDIR_TBL_SIZE;
-       nixlf->rss_grps =3D 1; /* Single RSS indir table supported, for now=
 */
+       nixlf->rss_grps =3D MAX_RSS_GROUPS;
        nixlf->xqe_sz =3D NIX_XQESZ_W16;
        /* We don't know absolute NPA LF idx attached.
         * AF will replace 'RVU_DEFAULT_PF_FUNC' with
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/dri=
vers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 1034304..143ae04 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -51,13 +51,17 @@ enum arua_mapped_qtypes {
 #define NIX_LF_POISON_VEC                      0x82

 /* RSS configuration */
+struct otx2_rss_ctx {
+       u8  ind_tbl[MAX_RSS_INDIR_TBL_SIZE];
+};
+
 struct otx2_rss_info {
        u8 enable;
        u32 flowkey_cfg;
        u16 rss_size;
-       u8  ind_tbl[MAX_RSS_INDIR_TBL_SIZE];
 #define RSS_HASH_KEY_SIZE      44   /* 352 bit key */
        u8  key[RSS_HASH_KEY_SIZE];
+       struct otx2_rss_ctx     *rss_ctx[MAX_RSS_GROUPS];
 };

 /* NIX (or NPC) RX errors */
@@ -643,7 +647,7 @@ void otx2_cleanup_tx_cqes(struct otx2_nic *pfvf, struct=
 otx2_cq_queue *cq);
 int otx2_rss_init(struct otx2_nic *pfvf);
 int otx2_set_flowkey_cfg(struct otx2_nic *pfvf);
 void otx2_set_rss_key(struct otx2_nic *pfvf);
-int otx2_set_rss_table(struct otx2_nic *pfvf);
+int otx2_set_rss_table(struct otx2_nic *pfvf, int ctx_id);

 /* Mbox handlers */
 void mbox_handler_msix_offset(struct otx2_nic *pfvf,
@@ -684,10 +688,11 @@ int otx2_get_flow(struct otx2_nic *pfvf,
 int otx2_get_all_flows(struct otx2_nic *pfvf,
                       struct ethtool_rxnfc *nfc, u32 *rule_locs);
 int otx2_add_flow(struct otx2_nic *pfvf,
-                 struct ethtool_rx_flow_spec *fsp);
+                 struct ethtool_rxnfc *nfc);
 int otx2_remove_flow(struct otx2_nic *pfvf, u32 location);
 int otx2_prepare_flow_request(struct ethtool_rx_flow_spec *fsp,
                              struct npc_install_flow_req *req);
+void otx2_rss_ctx_flow_del(struct otx2_nic *pfvf, int ctx_id);
 int otx2_del_macfilter(struct net_device *netdev, const u8 *mac);
 int otx2_add_macfilter(struct net_device *netdev, const u8 *mac);
 int otx2_enable_rxvlan(struct otx2_nic *pf, bool enable);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/dr=
ivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index 67171b66a..aaba045 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -581,7 +581,7 @@ static int otx2_set_rxnfc(struct net_device *dev, struc=
t ethtool_rxnfc *nfc)
                break;
        case ETHTOOL_SRXCLSRLINS:
                if (netif_running(dev) && ntuple)
-                       ret =3D otx2_add_flow(pfvf, &nfc->fs);
+                       ret =3D otx2_add_flow(pfvf, nfc);
                break;
        case ETHTOOL_SRXCLSRLDEL:
                if (netif_running(dev) && ntuple)
@@ -641,42 +641,50 @@ static u32 otx2_get_rxfh_key_size(struct net_device *=
netdev)

 static u32 otx2_get_rxfh_indir_size(struct net_device *dev)
 {
-       struct otx2_nic *pfvf =3D netdev_priv(dev);
-
-       return pfvf->hw.rss_info.rss_size;
+       return  MAX_RSS_INDIR_TBL_SIZE;
 }

-/* Get RSS configuration */
-static int otx2_get_rxfh(struct net_device *dev, u32 *indir,
-                        u8 *hkey, u8 *hfunc)
+static int otx2_rss_ctx_delete(struct otx2_nic *pfvf, int ctx_id)
 {
-       struct otx2_nic *pfvf =3D netdev_priv(dev);
-       struct otx2_rss_info *rss;
-       int idx;
+       struct otx2_rss_info *rss =3D &pfvf->hw.rss_info;

-       rss =3D &pfvf->hw.rss_info;
+       otx2_rss_ctx_flow_del(pfvf, ctx_id);
+       kfree(rss->rss_ctx[ctx_id]);
+       rss->rss_ctx[ctx_id] =3D NULL;

-       if (indir) {
-               for (idx =3D 0; idx < rss->rss_size; idx++)
-                       indir[idx] =3D rss->ind_tbl[idx];
-       }
+       return 0;
+}

-       if (hkey)
-               memcpy(hkey, rss->key, sizeof(rss->key));
+static int otx2_rss_ctx_create(struct otx2_nic *pfvf,
+                              u32 *rss_context)
+{
+       struct otx2_rss_info *rss =3D &pfvf->hw.rss_info;
+       u8 ctx;

-       if (hfunc)
-               *hfunc =3D ETH_RSS_HASH_TOP;
+       for (ctx =3D 0; ctx < MAX_RSS_GROUPS; ctx++) {
+               if (!rss->rss_ctx[ctx])
+                       break;
+       }
+       if (ctx =3D=3D MAX_RSS_GROUPS)
+               return -EINVAL;
+
+       rss->rss_ctx[ctx] =3D kzalloc(sizeof(*rss->rss_ctx[ctx]), GFP_KERNE=
L);
+       if (!rss->rss_ctx[ctx])
+               return -ENOMEM;
+       *rss_context =3D ctx;

        return 0;
 }

-/* Configure RSS table and hash key */
-static int otx2_set_rxfh(struct net_device *dev, const u32 *indir,
-                        const u8 *hkey, const u8 hfunc)
+/* RSS context configuration */
+static int otx2_set_rxfh_context(struct net_device *dev, const u32 *indir,
+                                const u8 *hkey, const u8 hfunc,
+                                u32 *rss_context, bool delete)
 {
        struct otx2_nic *pfvf =3D netdev_priv(dev);
+       struct otx2_rss_ctx *rss_ctx;
        struct otx2_rss_info *rss;
-       int idx;
+       int ret, idx;

        if (hfunc !=3D ETH_RSS_HASH_NO_CHANGE && hfunc !=3D ETH_RSS_HASH_TO=
P)
                return -EOPNOTSUPP;
@@ -688,20 +696,85 @@ static int otx2_set_rxfh(struct net_device *dev, cons=
t u32 *indir,
                return -EIO;
        }

+       if (hkey) {
+               memcpy(rss->key, hkey, sizeof(rss->key));
+               otx2_set_rss_key(pfvf);
+       }
+       if (delete)
+               return otx2_rss_ctx_delete(pfvf, *rss_context);
+
+       if (*rss_context =3D=3D ETH_RXFH_CONTEXT_ALLOC) {
+               ret =3D otx2_rss_ctx_create(pfvf, rss_context);
+               if (ret)
+                       return ret;
+       }
        if (indir) {
+               rss_ctx =3D rss->rss_ctx[*rss_context];
                for (idx =3D 0; idx < rss->rss_size; idx++)
-                       rss->ind_tbl[idx] =3D indir[idx];
+                       rss_ctx->ind_tbl[idx] =3D indir[idx];
        }
+       otx2_set_rss_table(pfvf, *rss_context);

-       if (hkey) {
-               memcpy(rss->key, hkey, sizeof(rss->key));
-               otx2_set_rss_key(pfvf);
+       return 0;
+}
+
+static int otx2_get_rxfh_context(struct net_device *dev, u32 *indir,
+                                u8 *hkey, u8 *hfunc, u32 rss_context)
+{
+       struct otx2_nic *pfvf =3D netdev_priv(dev);
+       struct otx2_rss_ctx *rss_ctx;
+       struct otx2_rss_info *rss;
+       int idx, rx_queues;
+
+       rss =3D &pfvf->hw.rss_info;
+
+       if (hfunc)
+               *hfunc =3D ETH_RSS_HASH_TOP;
+
+       if (!indir)
+               return 0;
+
+       if (!rss->enable && rss_context =3D=3D DEFAULT_RSS_CONTEXT_GROUP) {
+               rx_queues =3D pfvf->hw.rx_queues;
+               for (idx =3D 0; idx < MAX_RSS_INDIR_TBL_SIZE; idx++)
+                       indir[idx] =3D ethtool_rxfh_indir_default(idx, rx_q=
ueues);
+               return 0;
+       }
+       if (rss_context >=3D MAX_RSS_GROUPS)
+               return -ENOENT;
+
+       rss_ctx =3D rss->rss_ctx[rss_context];
+       if (!rss_ctx)
+               return -ENOENT;
+
+       if (indir) {
+               for (idx =3D 0; idx < rss->rss_size; idx++)
+                       indir[idx] =3D rss_ctx->ind_tbl[idx];
        }
+       if (hkey)
+               memcpy(hkey, rss->key, sizeof(rss->key));

-       otx2_set_rss_table(pfvf);
        return 0;
 }

+/* Get RSS configuration */
+static int otx2_get_rxfh(struct net_device *dev, u32 *indir,
+                        u8 *hkey, u8 *hfunc)
+{
+       return otx2_get_rxfh_context(dev, indir, hkey, hfunc,
+                                    DEFAULT_RSS_CONTEXT_GROUP);
+}
+
+/* Configure RSS table and hash key */
+static int otx2_set_rxfh(struct net_device *dev, const u32 *indir,
+                        const u8 *hkey, const u8 hfunc)
+{
+
+       u32 rss_context =3D DEFAULT_RSS_CONTEXT_GROUP;
+
+       return otx2_set_rxfh_context(dev, indir, hkey, hfunc, &rss_context,=
 0);
+}
+
 static u32 otx2_get_msglevel(struct net_device *netdev)
 {
        struct otx2_nic *pfvf =3D netdev_priv(netdev);
@@ -771,6 +844,8 @@ static const struct ethtool_ops otx2_ethtool_ops =3D {
        .get_rxfh_indir_size    =3D otx2_get_rxfh_indir_size,
        .get_rxfh               =3D otx2_get_rxfh,
        .set_rxfh               =3D otx2_set_rxfh,
+       .get_rxfh_context       =3D otx2_get_rxfh_context,
+       .set_rxfh_context       =3D otx2_set_rxfh_context,
        .get_msglevel           =3D otx2_get_msglevel,
        .set_msglevel           =3D otx2_set_msglevel,
        .get_pauseparam         =3D otx2_get_pauseparam,
@@ -866,6 +941,8 @@ static const struct ethtool_ops otx2vf_ethtool_ops =3D =
{
        .get_rxfh_indir_size    =3D otx2_get_rxfh_indir_size,
        .get_rxfh               =3D otx2_get_rxfh,
        .set_rxfh               =3D otx2_set_rxfh,
+       .get_rxfh_context       =3D otx2_get_rxfh_context,
+       .set_rxfh_context       =3D otx2_set_rxfh_context,
        .get_ringparam          =3D otx2_get_ringparam,
        .set_ringparam          =3D otx2_set_ringparam,
        .get_coalesce           =3D otx2_get_coalesce,
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/driv=
ers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
index be8ccfc..6dd442d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -16,6 +16,7 @@ struct otx2_flow {
        u32 location;
        u16 entry;
        bool is_vf;
+       u8 rss_ctx_id;
        int vf;
 };

@@ -245,6 +246,7 @@ int otx2_get_flow(struct otx2_nic *pfvf, struct ethtool=
_rxnfc *nfc,
        list_for_each_entry(iter, &pfvf->flow_cfg->flow_list, list) {
                if (iter->location =3D=3D location) {
                        nfc->fs =3D iter->flow_spec;
+                       nfc->rss_context =3D iter->rss_ctx_id;
                        return 0;
                }
        }
@@ -429,7 +431,7 @@ int otx2_prepare_flow_request(struct ethtool_rx_flow_sp=
ec *fsp,
        struct flow_msg *pkt =3D &req->packet;
        u32 flow_type;

-       flow_type =3D fsp->flow_type & ~(FLOW_EXT | FLOW_MAC_EXT);
+       flow_type =3D fsp->flow_type & ~(FLOW_EXT | FLOW_MAC_EXT | FLOW_RSS=
);
        switch (flow_type) {
        /* bits not set in mask are don't care */
        case ETHER_FLOW:
@@ -532,9 +534,13 @@ static int otx2_add_flow_msg(struct otx2_nic *pfvf, st=
ruct otx2_flow *flow)
                /* change to unicast only if action of default entry is not
                 * requested by user
                 */
-               if (req->op !=3D NIX_RX_ACTION_DEFAULT)
+               if (flow->flow_spec.flow_type & FLOW_RSS) {
+                       req->op =3D NIX_RX_ACTIONOP_RSS;
+                       req->index =3D flow->rss_ctx_id;
+               } else {
                        req->op =3D NIX_RX_ACTIONOP_UCAST;
-               req->index =3D ethtool_get_flow_spec_ring(ring_cookie);
+                       req->index =3D ethtool_get_flow_spec_ring(ring_cook=
ie);
+               }
                vf =3D ethtool_get_flow_spec_ring_vf(ring_cookie);
                if (vf > pci_num_vf(pfvf->pdev)) {
                        mutex_unlock(&pfvf->mbox.lock);
@@ -555,14 +561,16 @@ static int otx2_add_flow_msg(struct otx2_nic *pfvf, s=
truct otx2_flow *flow)
        return err;
 }

-int otx2_add_flow(struct otx2_nic *pfvf, struct ethtool_rx_flow_spec *fsp)
+int otx2_add_flow(struct otx2_nic *pfvf, struct ethtool_rxnfc *nfc)
 {
        struct otx2_flow_config *flow_cfg =3D pfvf->flow_cfg;
-       u32 ring =3D ethtool_get_flow_spec_ring(fsp->ring_cookie);
+       struct ethtool_rx_flow_spec *fsp =3D &nfc->fs;
        struct otx2_flow *flow;
        bool new =3D false;
+       u32 ring;
        int err;

+       ring =3D ethtool_get_flow_spec_ring(fsp->ring_cookie);
        if (!(pfvf->flags & OTX2_FLAG_NTUPLE_SUPPORT))
                return -ENOMEM;

@@ -585,6 +593,9 @@ int otx2_add_flow(struct otx2_nic *pfvf, struct ethtool=
_rx_flow_spec *fsp)
        /* struct copy */
        flow->flow_spec =3D *fsp;

+       if (fsp->flow_type & FLOW_RSS)
+               flow->rss_ctx_id =3D nfc->rss_context;
+
        err =3D otx2_add_flow_msg(pfvf, flow);
        if (err) {
                if (new)
@@ -647,6 +658,22 @@ int otx2_remove_flow(struct otx2_nic *pfvf, u32 locati=
on)
        return 0;
 }

+void otx2_rss_ctx_flow_del(struct otx2_nic *pfvf, int ctx_id)
+{
+       struct otx2_flow *flow, *tmp;
+       int err;
+
+       list_for_each_entry_safe(flow, tmp, &pfvf->flow_cfg->flow_list, lis=
t) {
+               if (flow->rss_ctx_id !=3D ctx_id)
+                       continue;
+               err =3D otx2_remove_flow(pfvf, flow->location);
+               if (err)
+                       netdev_warn(pfvf->netdev,
+                                   "Can't delete the rule %d associated wi=
th this rss group err:%d",
+                                   flow->location, err);
+       }
+}
+
 int otx2_destroy_ntuple_flows(struct otx2_nic *pfvf)
 {
        struct otx2_flow_config *flow_cfg =3D pfvf->flow_cfg;
--
2.7.4

