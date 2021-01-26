Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB4B303145
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 02:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727487AbhAZBaF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 25 Jan 2021 20:30:05 -0500
Received: from mga03.intel.com ([134.134.136.65]:50872 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731230AbhAZB1e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 20:27:34 -0500
IronPort-SDR: Volfh2KGnOT8QxXloKeLIjB1bR6cxvq4MflOOrgz8rnVWbzQNSZ6Y5QbDqh43lk+uUH7OwKSd8
 BfXM8Xk5dJ+g==
X-IronPort-AV: E=McAfee;i="6000,8403,9875"; a="179909629"
X-IronPort-AV: E=Sophos;i="5.79,375,1602572400"; 
   d="scan'208";a="179909629"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 16:39:21 -0800
IronPort-SDR: ShCaldHqtzaM8oxJfXsNGxmzh0pNz0/dSvuS2I+C7n1vfg6KUOv1p05e1VXXkRXJ0JPrhsJeBk
 taxpz99OxAnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,375,1602572400"; 
   d="scan'208";a="402570112"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga004.fm.intel.com with ESMTP; 25 Jan 2021 16:39:21 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 25 Jan 2021 16:39:21 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 25 Jan 2021 16:39:20 -0800
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.1713.004;
 Mon, 25 Jan 2021 16:39:20 -0800
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>
Subject: RE: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
 implement private channel OPs
Thread-Topic: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
 implement private channel OPs
Thread-Index: AQHW8RlTrNE3qjtLukSnj7NcX24DDao3Ul6AgAFbdYA=
Date:   Tue, 26 Jan 2021 00:39:20 +0000
Message-ID: <3de0df06f50541aab9ecf61d035c839a@intel.com>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
 <20210122234827.1353-8-shiraz.saleem@intel.com>
 <20210124134551.GB5038@unreal>
In-Reply-To: <20210124134551.GB5038@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.22.254.132]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
> implement private channel OPs
> 
> 
> > +static int irdma_devlink_rsrc_limits_validate(struct devlink *dl, u32 id,
> > +					      union devlink_param_value val,
> > +					      struct netlink_ext_ack *extack) {
> > +	u8 value = val.vu8;
> > +
> > +	if (value > 7) {
> > +		NL_SET_ERR_MSG_MOD(extack, "resource limits selector range
> is (0-7)");
> > +		return -ERANGE;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int irdma_devlink_enable_roce_validate(struct devlink *dl, u32 id,
> > +					      union devlink_param_value val,
> > +					      struct netlink_ext_ack *extack) {
> > +	struct irdma_dl_priv *priv = devlink_priv(dl);
> > +	bool value = val.vbool;
> > +
> > +	if (value && priv->drvdata->hw_ver == IRDMA_GEN_1) {
> > +		NL_SET_ERR_MSG_MOD(extack, "RoCE not supported on
> device");
> > +		return -EOPNOTSUPP;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int irdma_devlink_upload_ctx_get(struct devlink *devlink, u32 id,
> > +					struct devlink_param_gset_ctx *ctx) {
> > +	ctx->val.vbool = irdma_upload_context;
> > +	return 0;
> > +}
> > +
> > +static int irdma_devlink_upload_ctx_set(struct devlink *devlink, u32 id,
> > +					struct devlink_param_gset_ctx *ctx) {
> > +	irdma_upload_context = ctx->val.vbool;
> > +	return 0;
> > +}
> > +
> > +enum irdma_dl_param_id {
> > +	IRDMA_DEVLINK_PARAM_ID_BASE =
> DEVLINK_PARAM_GENERIC_ID_MAX,
> > +	IRDMA_DEVLINK_PARAM_ID_LIMITS_SELECTOR,
> > +	IRDMA_DEVLINK_PARAM_ID_UPLOAD_CONTEXT,
> > +};
> > +
> > +static const struct devlink_param irdma_devlink_params[] = {
> > +
> 	DEVLINK_PARAM_DRIVER(IRDMA_DEVLINK_PARAM_ID_LIMITS_SELE
> CTOR,
> > +			     "resource_limits_selector",
> DEVLINK_PARAM_TYPE_U8,
> > +			      BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
> > +			      NULL, NULL, irdma_devlink_rsrc_limits_validate),
> > +
> 	DEVLINK_PARAM_DRIVER(IRDMA_DEVLINK_PARAM_ID_UPLOAD_CON
> TEXT,
> > +			     "upload_context", DEVLINK_PARAM_TYPE_BOOL,
> > +			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
> > +			     irdma_devlink_upload_ctx_get,
> > +			     irdma_devlink_upload_ctx_set, NULL),
> > +	DEVLINK_PARAM_GENERIC(ENABLE_ROCE,
> BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
> > +			      NULL, NULL, irdma_devlink_enable_roce_validate),
> > +};
> 
> RoCE enable knob is understandable, but others are not explained.
> 

OK. That can be fixed.
