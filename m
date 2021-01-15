Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFF432F7719
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 12:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731929AbhAOLAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 06:00:24 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:44400 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731710AbhAOLAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 06:00:16 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10FAnaXW008591;
        Fri, 15 Jan 2021 02:58:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=+UoYzLEFVgywrksu2JukJqttTB9sbeU3oKabxbWOsng=;
 b=QTqz/yIaEoPtT41x/dfxhmjRWgdCiw83qzt9UIGT8qQRXQFLP1wYeyQ+f0GwtM9ZszWC
 xYGIw5qFeDFZ2cba41e8rZRdrdG1gymxBXpy+FUwq6BNjmXYJEc/lhgw0vMhreljZbxE
 Bvq9hkrAlg8sLA4uceWGV2WSQ5E2HfENwOKv+rcLp4KdYKXMvqJaW+92NGv9AWVKxAAh
 tEsYU10yrPFMs/8c4AnpR6N/PcP9SZGbD1AnX/SoyCm+tT7baM17Ytbm1PpcIcBfdHVB
 YJxXRCmH0WNI83aVPPy8B7nGfehkLD5RqOorxs0uUM9/Xfb+h2WbakOx4+IfCDeogEIp Iw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 35ycvq29fe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 15 Jan 2021 02:58:52 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 15 Jan
 2021 02:58:51 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.171)
 by DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 15 Jan 2021 02:58:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k8tnIJ3Tp+GqWSXKiFf3zF7r+dl/p3u6zSAMfMETbOjjX2PcbdC6VDh/IuJ5aCg7M6FGFa1/JoF2h1ElQrlbcg4pGmdWLJ6iVLTXCuzTdmA/GpL9PXEd7PnUixfgmnRygU1H61tCG3s2NZGFfIsUJTp9lyuB4GAKv143s16Tx/i2FBTto8pUKtnrh+M2bAgzOHn9rvvI2yUtodO3EQ2S/qypukydyIuP7PBbyeNvaC51+gek48V9PIQkwu/sStL9akzP9+4oUB9/8jRTVG5OccLrrchgPCX0iQifNtiLHgAb+PJhFa0815C+ey1tw4VMIzih/WE3x66v1MIC4rt0AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+UoYzLEFVgywrksu2JukJqttTB9sbeU3oKabxbWOsng=;
 b=RBNHf2dccyJqIQ+vw+otGXtFhMZr+EPMu1vynFBCFs6yQet5Vcg84GJtSWKeNBKFkUphocIn49FwsH4JqkIZnBgg21sbrj0R9PjtdHat9hCn9Zf6p2fONVXTcs+39+1ySceXPC271dO1M8ne8BJ9pqriOvcgdNi+m98SazzyTAjMj6GSxVLcKxDBmVgW/Cl27M79ijipaV98FgYaY9xCUmApKxpm0YoOAweUGjKY1vS835fh8H1FtpzPgoYbN+9j3nUBoc8xeFlbkO0Mr/fDrt7ZZkMFHm3wuCtTazPl13UUI45u2zpnG9nm5zz9291srCZgivNl8XsgoiOfllNs8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+UoYzLEFVgywrksu2JukJqttTB9sbeU3oKabxbWOsng=;
 b=Cp7bpikgBWKwxTcORSUBwAd05DnBDBpy8N+sdWUSt5vH32PJW8HfgWRb9cn6ITxi9iDDNddu3F/IRHohHboqNW8gMpw4+VDImVUt4GKD7QqG3LLa45ptagqLDzUGCbfgeCOO+G97sevsf52Ttan0Fo1jMYB3/wVcFtQvaEOIfzI=
Received: from DM6PR18MB2602.namprd18.prod.outlook.com (2603:10b6:5:15d::25)
 by DM6PR18MB2601.namprd18.prod.outlook.com (2603:10b6:5:187::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Fri, 15 Jan
 2021 10:58:49 +0000
Received: from DM6PR18MB2602.namprd18.prod.outlook.com
 ([fe80::d0c1:d773:7535:af80]) by DM6PR18MB2602.namprd18.prod.outlook.com
 ([fe80::d0c1:d773:7535:af80%6]) with mapi id 15.20.3763.012; Fri, 15 Jan 2021
 10:58:49 +0000
From:   Geethasowjanya Akula <gakula@marvell.com>
To:     "wangyingjie55@126.com" <wangyingjie55@126.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Vidhya Vidhyaraman" <vraman@marvell.com>,
        "Stanislaw Kardach [C]" <skardach@marvell.com>
CC:     Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [EXT] [PATCH v3] octeontx2-af: Fix missing check bugs in
 rvu_cgx.c
Thread-Topic: [EXT] [PATCH v3] octeontx2-af: Fix missing check bugs in
 rvu_cgx.c
Thread-Index: AQHW6jaUR+BOYwOiKUyzQgRY1H3tH6oog6IB
Date:   Fri, 15 Jan 2021 10:58:49 +0000
Message-ID: <DM6PR18MB26023B6D29E67754CDF8FB2FCDA71@DM6PR18MB2602.namprd18.prod.outlook.com>
References: <1610602240-23404-1-git-send-email-wangyingjie55@126.com>
In-Reply-To: <1610602240-23404-1-git-send-email-wangyingjie55@126.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: 126.com; dkim=none (message not signed)
 header.d=none;126.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [106.66.46.162]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c44ef7cf-fe04-45c7-e957-08d8b94489cc
x-ms-traffictypediagnostic: DM6PR18MB2601:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR18MB26017D371A58B731071ED62FCDA71@DM6PR18MB2601.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FvJguv9srtnBiQJYiXIeDxOOqOevagQNQU3HOObCtWHJYqsOWUEDZs/X46FUFWlZ43Qj5vkrW9W1eX8Ahajgg3TMpk0S4MCqKgCly/cfb7PhKHTtReeF12q90sLG/fgnrH3+6RnTJwGkxkGU0qNLA9YqSExJA3A9UyGR+g9Dh16AjQmbUU4uyfTlnOR+ihOUaG6Qi9bOumWYSaxG9ov53WW21xDFM+ykfdAK/zl4CmD8r9RpJJ1b0982xv2UQUXlZxLL0kLSY1dO/c001MLdaAv7CtVffHHuRmT8PuD+snLqbyciHep1MYmk+hHOCL6NPsQHtz5NLuIq61c8+Oeh3CNRK5wd5/iDVDBwT9fj1+05jUKppfJtqFBaWgcfcSs4vNUb1lWxvJUgoqGF0N2A2A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB2602.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(39860400002)(136003)(396003)(376002)(7696005)(8936002)(2906002)(8676002)(6636002)(478600001)(91956017)(66946007)(64756008)(86362001)(66476007)(66556008)(66446008)(316002)(110136005)(26005)(186003)(55236004)(53546011)(6506007)(76116006)(9686003)(54906003)(5660300002)(55016002)(52536014)(4326008)(33656002)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?ho9RDnrPlLi6ceyug2+BTOQyMk6s32UY0DZQu/5AmwYklEoMAvra9Js36PXX?=
 =?us-ascii?Q?FK1tipSfD/lQoZsukHWl8ZnpRRRHG6uKqIELgJZDEFHmsrgQEIntQBN6RbQV?=
 =?us-ascii?Q?flM9NnLYcHj4De42VDsInFyd+BsVEiWGfu2iUYGHeoUlfOPgfxW0FQwhJgtr?=
 =?us-ascii?Q?KeKRU44I0mXFNFdU9mmNMq/desSpPqSf3Tk8MX9j5i1tDU7P782Ro/SPcbIP?=
 =?us-ascii?Q?w5jTGZTvnvT2nGG95Qyl7I2L9xzpOgmq819I6gdUkcBCX25SmjRBkC5T/mzu?=
 =?us-ascii?Q?gD1UnY4psxPFu6cidytvHp/3vGONQUZbwzCp6rpraxIouBqmMT3x+LnCWkOU?=
 =?us-ascii?Q?c+tUYGCtPHXep0INPQ0F4m4XySrZ2ZNYCtGYlqfSfJdfzzv++IVcwx5O8uHU?=
 =?us-ascii?Q?lPBnrHfuPQfOV7u2kWWRGWcGazipaSFeq73ZSRSXo64aJmqvWH7KyArTRx+G?=
 =?us-ascii?Q?optGVbwr44A5C3pu37u3dPl+wdEnUc4SzI5yWOGQvp5Izs7NB95gwSr0/bYm?=
 =?us-ascii?Q?fQmD0G+ssuuqpnZhuJSILmEWkVR9eXvTPNXptcSMHXe+i7/40KG7hFXSehnQ?=
 =?us-ascii?Q?RsD/22kc6HGhkJySuHZMmTbpE4Mr4RcHtZc4nh9PKGLbkeJ40R+8Fu5DOKSN?=
 =?us-ascii?Q?jVOZdm3wnZ/LBox/yk+4LGBvEn50C6XFX2YMWmCv/UPO4afpl0WOiidJavQn?=
 =?us-ascii?Q?0M8MdWLp2oAVdaxR3YR4bjTr8jeyYe+qc1/byXTaBDmuSzXaSEiek+f431LH?=
 =?us-ascii?Q?91wqRkFoggzGwMJEGpQpJyjVTbCeNF4cmTJoMfClcM8hFSTMaJCLlNj+GJlO?=
 =?us-ascii?Q?BZAru2DW2SG6NuwmmzozsCNU3qbWByj/ar8VUqgTxJ0WT0V+MbTzbJraHY34?=
 =?us-ascii?Q?kCY+b39waVbyQvAXAJDyfZ8HRsHlBipRXZuerUnyR4QCCFZac2aTuy8/Kyz/?=
 =?us-ascii?Q?WDl3d37Pu1Nf1C/jRT85mCgfiRUwGGAsQzjU1W5d4sk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB2602.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c44ef7cf-fe04-45c7-e957-08d8b94489cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2021 10:58:49.1848
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Aw7o9OAl7UAvEaSdUJbCK0/JPaF0WvjCRq5+oWpoPZkdaSizwiSRGU2vHoQN5zRcJSb1ou+8cZeIYZnGxfk2uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB2601
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-15_06:2021-01-15,2021-01-15 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The changes look good to me.

You can add:
Reviewed-by: Geetha sowjanya<gakula@marvell.com>

________________________________________
From: wangyingjie55@126.com <wangyingjie55@126.com>
Sent: Thursday, January 14, 2021 11:00 AM
To: davem@davemloft.net; kuba@kernel.org; Vidhya Vidhyaraman; Stanislaw Kar=
dach [C]
Cc: Sunil Kovvuri Goutham; Linu Cherian; Geethasowjanya Akula; Jerin Jacob =
Kollanukkaran; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Yingji=
e Wang
Subject: [EXT] [PATCH v3] octeontx2-af: Fix missing check bugs in rvu_cgx.c

External Email

----------------------------------------------------------------------
From: Yingjie Wang <wangyingjie55@126.com>

In rvu_mbox_handler_cgx_mac_addr_get()
and rvu_mbox_handler_cgx_mac_addr_set(),
the msg is expected only from PFs that are mapped to CGX LMACs.
It should be checked before mapping,
so we add the is_cgx_config_permitted() in the functions.

Fixes: 96be2e0da85e ("octeontx2-af: Support for MAC address filters in CGX"=
)
Signed-off-by: Yingjie Wang <wangyingjie55@126.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/=
net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index d298b9357177..6c6b411e78fd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -469,6 +469,9 @@ int rvu_mbox_handler_cgx_mac_addr_set(struct rvu *rvu,
        int pf =3D rvu_get_pf(req->hdr.pcifunc);
        u8 cgx_id, lmac_id;

+       if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
+               return -EPERM;
+
        rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);

        cgx_lmac_addr_set(cgx_id, lmac_id, req->mac_addr);
@@ -485,6 +488,9 @@ int rvu_mbox_handler_cgx_mac_addr_get(struct rvu *rvu,
        int rc =3D 0, i;
        u64 cfg;

+       if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
+               return -EPERM;
+
        rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);

        rsp->hdr.rc =3D rc;
--
2.7.4

