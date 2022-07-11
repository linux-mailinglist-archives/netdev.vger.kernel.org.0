Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3357256F985
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 11:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiGKJCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 05:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiGKJCb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 05:02:31 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCFF821E16;
        Mon, 11 Jul 2022 02:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657530150; x=1689066150;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FHNhkaA1lSlR8HpSbcH/11xXdvPozSuBY7JOVQNkAUY=;
  b=EOhe1o/pY9KKYMllQ9Ky/dzAdtt5eG9DC+9I/mEcT6UCKNGfWSBsmXni
   s+cYDvtgzTfBkTp+WGrwDINdb+gFFYzqOmmEJH+ckL/WHmFQ6qiT3aDVU
   RhK5xX4p/aG5Xd8X8MgMl2EdCHry4TpuD7Efe2VBq3NKmIl43q8jIV7SK
   6FJT5yisUqYwEWrAPFcZbUnrZW6dGxsTxmqLXkL3a0QSYMm47jr0ib1Ny
   /Er3cuCC/JyHavs/QmBweJCOwSfKGbzWQWhnYVnFDyjNQ6lYoZJjffZ6U
   8fKIGelZGffVUxgjrJ6MFbLsuYJV5Ed/EhMdROtdjlfj3bezjAOwaP3CS
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="346298948"
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="346298948"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:02:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="662474781"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 11 Jul 2022 02:02:30 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 11 Jul 2022 02:02:29 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 11 Jul 2022 02:02:29 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 11 Jul 2022 02:02:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HjUv3joq0FHOAxhYIDyp3Y06Cz7o5ivSHMG74k7JwlgylHxJqDGzTC8ToblL3j6Nh9GR7x48Bwy29tCH+g6PdmqAPhDUa+gKhxi9ixSPoq3PA4oq+YG5cT2Hk5zjnkoEaThPCKlu7Nj8NjLyviICI7D69NTciQLmyeeUbwNoYWuKf5VX+8S/+3hmYE5Bj8sVBK8xhZgljM5bjcRIy0wBDU/B3uYdI9dFVBTRLHfNzXpAEYBh9bCFWgQ873GbSVdw64cU3N1Wpam2y0yr0uZnjSADFok9NCjXZOtFXc6DQ19Zr6UExzAXB54JAnJ+j8prG4pbFEM0vpb9d2lC3/U6jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4cENUefA3+Z5ISJb8uDECsk1IIP6Dur6xoCN22Xy7FA=;
 b=CgWfAea6DVmt0f0WN6emZ1+komTDQ19r1o1UY0kB3pQN4jrbStzPMCVZkNKFHcSf9SEibh8ZB8k9JtFTIAeDTlV5ggAO7zAXD65qimqQ5kDxhzVqANXk61OV+5/+LfuwUetYlW5BXuRUOPUuocua1VZ4oVa1qjF/JMHzsQHLsanWlg3ETyTYeriWideecT4NFxYMs7I9lbvTfJhKQbuFMPyErNi5HL9AE1j1KbqVpCqLrKnQhCxk9+iQHkMEoPc7ENFKcQaRFNL1Z3i+55hUCFEozAagGVJ8n5N9xXRqzSGwL66sdvnNK4boiRw+8gSBXQq11pI/tUICmoRoD7rhrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 DM6PR11MB3883.namprd11.prod.outlook.com (2603:10b6:5:19f::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5417.23; Mon, 11 Jul 2022 09:02:28 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::2ce4:94fa:eef0:b822]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::2ce4:94fa:eef0:b822%5]) with mapi id 15.20.5417.020; Mon, 11 Jul 2022
 09:02:28 +0000
From:   "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
CC:     Vadim Fedorenko <vadfed@fb.com>, Aya Levin <ayal@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: RE: [RFC PATCH v2 2/3] dpll: add netlink events
Thread-Topic: [RFC PATCH v2 2/3] dpll: add netlink events
Thread-Index: AQHYiZJ5zeS9OiYOPkW4rEeGr6WnDq149o2A
Date:   Mon, 11 Jul 2022 09:02:28 +0000
Message-ID: <DM6PR11MB46573FA8D51D40DAD2AC060B9B879@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20220626192444.29321-1-vfedorenko@novek.ru>
 <20220626192444.29321-3-vfedorenko@novek.ru>
In-Reply-To: <20220626192444.29321-3-vfedorenko@novek.ru>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b207f131-1059-4788-70ba-08da631c148e
x-ms-traffictypediagnostic: DM6PR11MB3883:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kJxgMkKPPbYccKh9tCMfi9Fv+/Z6MW4ym58weieRCSL1hWlgusifQT4CqpFyhuL8Tfe5PKL2npxETrPgX23adQh/etVbyFmx9ibwGdoVLLk+urP4SdqvSmyqAqQBLzEdB8W3mfsMzJ5I7blY0k5FhSxOOdItmmYZj0NMA240qh+bEKR4PerUPSD3WVIbSxsLuL+NIlKcxjZOeuRCHnCJr0PyK2Z7PpEwr8RioVjE5rVqA8KD6uCSLCyxQtO7gRM5EsLS9zNwiPiaVv/TFIIC+j2j9a+mH6JS3VMjUGtWWUbAcLNMmrLbgGOOcsLzd3gFZQF5JQGWf5GvISHu5bfLHCYkFnmcWhqhsQakcD7HRP96mqlIfZPTRbxBq2v7h9cesaxKcNVF9vMToe6nKvur1Qf8XoSp6rKlL0d6/8CpHcb2evJ1y+jiOcWTjgaHdyBng2RHHELPfzhGzQKz/I90nkGxrjy2inA8xV0S0GDX5bM+/XvT9wr45Qqr+sfK+lQc3vcyxdO6lJbKeIflzoFsZoZp3+j2/zFCdcGsESvny8eLCKR9q4AMY2Mb44uFwcr+sgmCw+f9XCB6D/gjkijvcNsOlqTCfk+EVmuC4H1sDWqCIuMtsl0Ta+TIoYcI/DV8FiPQB5uPWlxtDH/gtgL8Mf2bUCjycSa595wpNJuOSJzjJg0HgtSy+yakhaGsaH5pXSW5U1L8xqZOPiTel/iH8wEnnWESj1Tm7tlgUFgcRic9afBf6Jn/Bz96bhSS+Jh8XHlYlPVLg6VW9xVpsMWhzHQxQmMRtVnghbPrMn2JngUG3kAObTr5gd1RoNuMjfH1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(39860400002)(396003)(366004)(376002)(2906002)(6506007)(7696005)(54906003)(52536014)(316002)(5660300002)(55016003)(38070700005)(478600001)(71200400001)(41300700001)(33656002)(26005)(9686003)(110136005)(76116006)(4326008)(66946007)(122000001)(8676002)(64756008)(66446008)(66556008)(38100700002)(83380400001)(66476007)(82960400001)(8936002)(86362001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XSozqzcvDDckc0J5PBr7N3HOgILgaUxnWsFlBWbrdf/6XhGIa9MGfFRruiHc?=
 =?us-ascii?Q?uLXJEBpAfDnBV2373OfmR+OAEJr1P8hBQ0JLolC8FOZ6OW6nntg7CVQjWs5r?=
 =?us-ascii?Q?p/O5UaY39z+RzJGim2DyPG6sW7gZ441JtcZNyGL9c/JimNZxpgikg0Stv0Bs?=
 =?us-ascii?Q?zoU3IXS4zdcCWEDm3IGxSCo7DbYUmqjJB8CMQcFIackiPv7AWH4lXtLpkeWG?=
 =?us-ascii?Q?pjKJ6IW7EMzof6eK2X8IlEmq9aSe4dkMZ02KFE4/adGRDtSv4M+mjngTtK1+?=
 =?us-ascii?Q?JbIPI+8tDaWvSN5Ooxu4N20g192isbtkguU4E9eervVrpT6HiKkxJ+duCjM+?=
 =?us-ascii?Q?bXPQSNcNpQ4TiqbqoLcqbE0lJTkZctCmQ3HplW2BnfLbWQcrHG8P0+PEuimG?=
 =?us-ascii?Q?vNcCsDxQRki+YQbVjJmPI4S1r2TttS8bl490G/+Ew2MHMBzM1IVejoVXTIiF?=
 =?us-ascii?Q?M7r+GFE89yfh4jgSfpA5HWTV1R06dSUpP2fwrVSZBFAef8GSbQOsmna0HhMt?=
 =?us-ascii?Q?yGDTw/3y3DEHkatO9BTHnq94zzIj60e327nWDeYl7Duq95mwNBaog/PbrzqI?=
 =?us-ascii?Q?pfvxU1zHMSrIWOJjv021QqVX3Jr0SX1+qbeMZf4GTDO1OVr3V73s8Qs7rpRQ?=
 =?us-ascii?Q?hlvedgjPkqxywl2pHz+kmpAqHf2m/+bzqX5v29gtycRpuYYM/1exWf0k87nU?=
 =?us-ascii?Q?krcTXFfCW6I7maoYFTbvJc5CJIabvLebudAhGgGbF8VPx5z44BT17ZDYbqaq?=
 =?us-ascii?Q?CQxVSw8CYb+9OJNXo3ritIX68XagJuUHUKdGJrMf3i+bKVksvB+2gsuv/9Kw?=
 =?us-ascii?Q?L9StIi6TNC+BoeZDEfO5i3esVU5GfUPM48QEx4hykvXf0GbP3ZSD+llzaRMd?=
 =?us-ascii?Q?yZAtdanoe/PhJsAlg4WhR7msqq5jnlZYwQgYHwaBNKv5JfYesO+zP+em0+hu?=
 =?us-ascii?Q?uojhDA5/oVC1ixEnC96rB+x066RMU1kL6TVWlzDpziw2lpig+pWeXEvlFdtx?=
 =?us-ascii?Q?X5a2tU0vChIqDo6fiaDlL++Dk/uGJ3Y5bIpCSHrM08xGs5XdlBsEK8dv4r0x?=
 =?us-ascii?Q?n+xZUrNCPDDvGd5Me3DJCRAgBWsmZopXqvHNP5oGKYkbzslDRKPjGuMsnHv/?=
 =?us-ascii?Q?JV+4rV+DQ3BIMBEDaGV5W6jUvLCwjzFhL1BHaZNAFzk9DOvPXSug2uVzBq3e?=
 =?us-ascii?Q?+5NEJohQQLAdTxXUGq9hj7JUqJa+C6h9vzMI8xolBUtrn6qd/G/yLTonPCyp?=
 =?us-ascii?Q?Cf3MWjPrLB8iqYoWSbsKDDn9wYoJ24GHmFmqGZy7Co87zA+WwS2ut6p7o4sJ?=
 =?us-ascii?Q?sIZfW67QTwvfhsfBCO2V/zNay2vN9kQq/swRsy8ZHkaLMyabJb790kQLPh50?=
 =?us-ascii?Q?MfrFQ+vDD0p/p2y9J6VL7+OvvNnkkP4ZMsaGTjzJ+bF4vYM2oNYTuW53hT1N?=
 =?us-ascii?Q?JiDIXga8dtU4CH1oN1zUb2JfIVcHYwuNiBzViphyPxkUSFK7cZ5Zu++HH9a3?=
 =?us-ascii?Q?S34bjU/Ub9hXIt/nvBxeY7tcz76mtyrW7uiIXNhEyX0//UgpPh7rNJpZvSeQ?=
 =?us-ascii?Q?cSdMv2H2j1PhnWihZRXWTIR18cFxYtV5Tc7PiOCOBRcGuKb61lRepITM++6H?=
 =?us-ascii?Q?fA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b207f131-1059-4788-70ba-08da631c148e
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2022 09:02:28.1304
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g5OuOtoRFPQYZ31tuIDmFNW2/DRR8RlZ80h3p0hT3eI0BoeR42Nz/0fY7k2VN/VbHEbIziI6B33xHm5Va5fHxYGbvWd4OxxM9Upaymz4oAM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3883
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-----Original Message-----
From: Vadim Fedorenko <vfedorenko@novek.ru>=20
Sent: Sunday, June 26, 2022 9:25 PM
>
>From: Vadim Fedorenko <vadfed@fb.com>
>
>Add netlink interface to enable notification of users about
>events in DPLL framework. Part of this interface should be
>used by drivers directly, i.e. lock status changes.
>
>Signed-off-by: Vadim Fedorenko <vadfed@fb.com>
>---
> drivers/dpll/dpll_core.c    |   2 +
> drivers/dpll/dpll_netlink.c | 141 ++++++++++++++++++++++++++++++++++++
> drivers/dpll/dpll_netlink.h |   7 ++
> 3 files changed, 150 insertions(+)
>
>diff --git a/drivers/dpll/dpll_core.c b/drivers/dpll/dpll_core.c
>index dc0330e3687d..387644aa910e 100644
>--- a/drivers/dpll/dpll_core.c
>+++ b/drivers/dpll/dpll_core.c
>@@ -97,6 +97,8 @@ struct dpll_device *dpll_device_alloc(struct dpll_device=
_ops *ops, int sources_c
> 	mutex_unlock(&dpll_device_xa_lock);
> 	dpll->priv =3D priv;
>=20
>+	dpll_notify_device_create(dpll->id, dev_name(&dpll->dev));
>+
> 	return dpll;
>=20
> error:
>diff --git a/drivers/dpll/dpll_netlink.c b/drivers/dpll/dpll_netlink.c
>index e15106f30377..4b1684fcf41e 100644
>--- a/drivers/dpll/dpll_netlink.c
>+++ b/drivers/dpll/dpll_netlink.c
>@@ -48,6 +48,8 @@ struct param {
> 	int dpll_source_type;
> 	int dpll_output_id;
> 	int dpll_output_type;
>+	int dpll_status;
>+	const char *dpll_name;
> };
>=20
> struct dpll_dump_ctx {
>@@ -239,6 +241,8 @@ static int dpll_genl_cmd_set_source(struct param *p)
> 	ret =3D dpll->ops->set_source_type(dpll, src_id, type);
> 	mutex_unlock(&dpll->lock);
>=20
>+	dpll_notify_source_change(dpll->id, src_id, type);
>+
> 	return ret;
> }
>=20
>@@ -262,6 +266,8 @@ static int dpll_genl_cmd_set_output(struct param *p)
> 	ret =3D dpll->ops->set_source_type(dpll, out_id, type);
> 	mutex_unlock(&dpll->lock);
>=20
>+	dpll_notify_source_change(dpll->id, out_id, type);
>+
> 	return ret;
> }
>=20
>@@ -438,6 +444,141 @@ static struct genl_family dpll_gnl_family __ro_after=
_init =3D {
> 	.pre_doit	=3D dpll_pre_doit,
> };
>=20
>+static int dpll_event_device_create(struct param *p)
>+{
>+	if (nla_put_u32(p->msg, DPLLA_DEVICE_ID, p->dpll_id) ||
>+	    nla_put_string(p->msg, DPLLA_DEVICE_NAME, p->dpll_name))
>+		return -EMSGSIZE;
>+
>+	return 0;
>+}
>+
>+static int dpll_event_device_delete(struct param *p)
>+{
>+	if (nla_put_u32(p->msg, DPLLA_DEVICE_ID, p->dpll_id))
>+		return -EMSGSIZE;
>+
>+	return 0;
>+}
>+
>+static int dpll_event_status(struct param *p)
>+{
>+	if (nla_put_u32(p->msg, DPLLA_DEVICE_ID, p->dpll_id) ||
>+		nla_put_u32(p->msg, DPLLA_LOCK_STATUS, p->dpll_status))
>+		return -EMSGSIZE;
>+
>+	return 0;
>+}
>+
>+static int dpll_event_source_change(struct param *p)
>+{
>+	if (nla_put_u32(p->msg, DPLLA_DEVICE_ID, p->dpll_id) ||
>+	    nla_put_u32(p->msg, DPLLA_SOURCE_ID, p->dpll_source_id) ||
>+		nla_put_u32(p->msg, DPLLA_SOURCE_TYPE, p->dpll_source_type))
>+		return -EMSGSIZE;
>+
>+	return 0;
>+}
>+
>+static int dpll_event_output_change(struct param *p)
>+{
>+	if (nla_put_u32(p->msg, DPLLA_DEVICE_ID, p->dpll_id) ||
>+	    nla_put_u32(p->msg, DPLLA_OUTPUT_ID, p->dpll_output_id) ||
>+		nla_put_u32(p->msg, DPLLA_OUTPUT_TYPE, p->dpll_output_type))
>+		return -EMSGSIZE;
>+
>+	return 0;
>+}
>+
>+static cb_t event_cb[] =3D {
>+	[DPLL_EVENT_DEVICE_CREATE]	=3D dpll_event_device_create,
>+	[DPLL_EVENT_DEVICE_DELETE]	=3D dpll_event_device_delete,
>+	[DPLL_EVENT_STATUS_LOCKED]	=3D dpll_event_status,
>+	[DPLL_EVENT_STATUS_UNLOCKED]	=3D dpll_event_status,
>+	[DPLL_EVENT_SOURCE_CHANGE]	=3D dpll_event_source_change,
>+	[DPLL_EVENT_OUTPUT_CHANGE]	=3D dpll_event_output_change,
>+};
>+/*
>+ * Generic netlink DPLL event encoding
>+ */
>+static int dpll_send_event(enum dpll_genl_event event,
>+				   struct param *p)
>+{
>+	struct sk_buff *msg;
>+	int ret =3D -EMSGSIZE;
>+	void *hdr;
>+
>+	msg =3D genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
>+	if (!msg)
>+		return -ENOMEM;
>+	p->msg =3D msg;
>+
>+	hdr =3D genlmsg_put(msg, 0, 0, &dpll_gnl_family, 0, event);
>+	if (!hdr)
>+		goto out_free_msg;
>+
>+	ret =3D event_cb[event](p);
>+	if (ret)
>+		goto out_cancel_msg;
>+
>+	genlmsg_end(msg, hdr);
>+
>+	genlmsg_multicast(&dpll_gnl_family, msg, 0, 1, GFP_KERNEL);

All multicasts are send only for group "1" (DPLL_CONFIG_SOURCE_GROUP_NAME),
but 4 groups were defined.
 =20
>+
>+	return 0;
>+
>+out_cancel_msg:
>+	genlmsg_cancel(msg, hdr);
>+out_free_msg:
>+	nlmsg_free(msg);
>+
>+	return ret;
>+}
>+
>+int dpll_notify_device_create(int dpll_id, const char *name)
>+{
>+	struct param p =3D { .dpll_id =3D dpll_id, .dpll_name =3D name };
>+
>+	return dpll_send_event(DPLL_EVENT_DEVICE_CREATE, &p);
>+}
>+
>+int dpll_notify_device_delete(int dpll_id)
>+{
>+	struct param p =3D { .dpll_id =3D dpll_id };
>+
>+	return dpll_send_event(DPLL_EVENT_DEVICE_DELETE, &p);
>+}
>+
>+int dpll_notify_status_locked(int dpll_id)
>+{
>+	struct param p =3D { .dpll_id =3D dpll_id, .dpll_status =3D 1 };
>+
>+	return dpll_send_event(DPLL_EVENT_STATUS_LOCKED, &p);
>+}
>+
>+int dpll_notify_status_unlocked(int dpll_id)
>+{
>+	struct param p =3D { .dpll_id =3D dpll_id, .dpll_status =3D 0 };
>+
>+	return dpll_send_event(DPLL_EVENT_STATUS_UNLOCKED, &p);
>+}
>+
>+int dpll_notify_source_change(int dpll_id, int source_id, int source_type=
)
>+{
>+	struct param p =3D  { .dpll_id =3D dpll_id, .dpll_source_id =3D source_i=
d,
>+						.dpll_source_type =3D source_type };
>+
>+	return dpll_send_event(DPLL_EVENT_SOURCE_CHANGE, &p);
>+}
>+
>+int dpll_notify_output_change(int dpll_id, int output_id, int output_type=
)
>+{
>+	struct param p =3D  { .dpll_id =3D dpll_id, .dpll_output_id =3D output_i=
d,
>+						.dpll_output_type =3D output_type };
>+
>+	return dpll_send_event(DPLL_EVENT_OUTPUT_CHANGE, &p);
>+}
>+
> int __init dpll_netlink_init(void)
> {
> 	return genl_register_family(&dpll_gnl_family);
>diff --git a/drivers/dpll/dpll_netlink.h b/drivers/dpll/dpll_netlink.h
>index e2d100f59dd6..0dc81320f982 100644
>--- a/drivers/dpll/dpll_netlink.h
>+++ b/drivers/dpll/dpll_netlink.h
>@@ -3,5 +3,12 @@
>  *  Copyright (c) 2021 Meta Platforms, Inc. and affiliates
>  */
>=20
>+int dpll_notify_device_create(int dpll_id, const char *name);
>+int dpll_notify_device_delete(int dpll_id);
>+int dpll_notify_status_locked(int dpll_id);
>+int dpll_notify_status_unlocked(int dpll_id);
>+int dpll_notify_source_change(int dpll_id, int source_id, int source_type=
);
>+int dpll_notify_output_change(int dpll_id, int output_id, int output_type=
);

Only dpll_notify_device_create is actually used, rest is not.
I am getting confused a bit, who should call those "notify" functions?
It is straightforward for create/delete, dpll subsystem shall do it, but wh=
at
about the rest?
I would say notifications about status or source/output change shall origin=
ate
in the driver implementing dpll interface, thus they shall be exported and
defined in the header included by the driver.

>+
> int __init dpll_netlink_init(void);
> void dpll_netlink_finish(void);
>--=20
>2.27.0
>
