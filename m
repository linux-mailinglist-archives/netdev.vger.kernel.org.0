Return-Path: <netdev+bounces-9805-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C59B572AA60
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 10:46:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 29988281A9B
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 08:46:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34951A94D;
	Sat, 10 Jun 2023 08:46:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B68256A
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 08:46:34 +0000 (UTC)
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 382C030E3
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 01:46:28 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-977e7d6945aso455397566b.2
        for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 01:46:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1686386786; x=1688978786;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GSF/kGcyY2T2khZJqq+hCJQP4iKE4wxL6SaGITXlZUU=;
        b=vPqW/4cgWBMZqvNav8/FBRdZ6lhCUBgsIM8pQ5Gg3GquE2/TYesv4Waxzc/3x+dILw
         TWNvQvs+aURb9biLk02QrXJhyIAC/6m0vL+ZxuEkNMgQSO0/pRGmTGvdVj05VYFN887A
         wYEtbFOZQB+7kMqy/rlBYfXhDsh7ECy4sqhtp7R7WlZccZdrym7KECuHS51Zz2QpH2ON
         5oRp/6dRYseCmzhm8plYETPrnr+Z1rBEXj9QKgbH0H+HMb1gGtQ0V8xxq5t0rD8STIFE
         HpC/grAuC3vzf0WQ9QkzNejFkFrSSAwormnz2+WGGx2DRmUoeZGZIMdIeLDXOR7Djkv7
         msgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686386786; x=1688978786;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GSF/kGcyY2T2khZJqq+hCJQP4iKE4wxL6SaGITXlZUU=;
        b=IeJcGU0VXy1Qn2zlK0zIXzKD2vWbpXVWRz5VoVC/pop6cqGKFG8oY0d5ikrUlZ+vvq
         F/U/ylE7hhbXpLHHsSEHiQ9glNOc4E+E/1AtTgei8/Gny0kjp1NrbdkyLttWhAPW3Nms
         eB7UVtFFBdzYu0HtrOXM1GiODmFUZNHvG1DIoq9vILp3iqMbm7BcsIaH/JbOMOD7I+gz
         EonYccUpuJBD/QGvRl2Q9ysfth1SmRPBTpvlnW1jIyWUuKosH+TtCOvhovQCwv3iECOo
         8UDlQ9EuZQn2N8poz1yk2oONBEYWzXkZ7Mr+O/m7FlOrXSy1E96e8GQ2pOTUkt2OBFih
         lczQ==
X-Gm-Message-State: AC+VfDzKljN/61Ih9FIKvnXw+e77UyV41lxAF7DKDjYFcAAv97D+B6sV
	E3mvAMYPPDesSXFVEBWZrUZUNw==
X-Google-Smtp-Source: ACHHUZ5LHz1bCgQJ2R7YL5ObCo6ELGPyZh7ubwZwZFv3S+EJf5VUf5LWqRdui3wAKHpRAI/qsA1fWg==
X-Received: by 2002:a17:906:ee85:b0:966:5a6c:752d with SMTP id wt5-20020a170906ee8500b009665a6c752dmr4041983ejb.20.1686386786589;
        Sat, 10 Jun 2023 01:46:26 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id lj20-20020a170906f9d400b0094f23480619sm2333994ejb.172.2023.06.10.01.46.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jun 2023 01:46:25 -0700 (PDT)
Date: Sat, 10 Jun 2023 10:46:24 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Cc: kuba@kernel.org, vadfed@meta.com, jonathan.lemon@gmail.com,
	pabeni@redhat.com, corbet@lwn.net, davem@davemloft.net,
	edumazet@google.com, vadfed@fb.com, jesse.brandeburg@intel.com,
	anthony.l.nguyen@intel.com, saeedm@nvidia.com, leon@kernel.org,
	richardcochran@gmail.com, sj@kernel.org, javierm@redhat.com,
	ricardo.canuelo@collabora.com, mst@redhat.com, tzimmermann@suse.de,
	michal.michalik@intel.com, gregkh@linuxfoundation.org,
	jacek.lawrynowicz@linux.intel.com, airlied@redhat.com,
	ogabbay@kernel.org, arnd@arndb.de, nipun.gupta@amd.com,
	axboe@kernel.dk, linux@zary.sk, masahiroy@kernel.org,
	benjamin.tissoires@redhat.com, geert+renesas@glider.be,
	milena.olech@intel.com, kuniyu@amazon.com, liuhangbin@gmail.com,
	hkallweit1@gmail.com, andy.ren@getcruise.com, razor@blackwall.org,
	idosch@nvidia.com, lucien.xin@gmail.com, nicolas.dichtel@6wind.com,
	phil@nwl.cc, claudiajkang@gmail.com, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	intel-wired-lan@lists.osuosl.org, linux-rdma@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, poros@redhat.com,
	mschmidt@redhat.com, linux-clk@vger.kernel.org,
	vadim.fedorenko@linux.dev
Subject: Re: [RFC PATCH v8 07/10] ice: add admin commands to access cgu
 configuration
Message-ID: <ZIQ4YCX+1FbZHpRQ@nanopsycho>
References: <20230609121853.3607724-1-arkadiusz.kubalewski@intel.com>
 <20230609121853.3607724-8-arkadiusz.kubalewski@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230609121853.3607724-8-arkadiusz.kubalewski@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Fri, Jun 09, 2023 at 02:18:50PM CEST, arkadiusz.kubalewski@intel.com wrote:
>Add firmware admin command to access clock generation unit
>configuration, it is required to enable Extended PTP and SyncE features
>in the driver.

Empty line here perhaps?


>Add definitions of possible hardware variations of input and output pins
>related to clock generation unit and functions to access the data.
>
>Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>

I just skimmed over this, not really give it much of a time. Couple of
nits:


>+
>+#define MAX_NETLIST_SIZE	10

Prefix perhaps?

[...]


>+/**
>+ * convert_s48_to_s64 - convert 48 bit value to 64 bit value
>+ * @signed_48: signed 64 bit variable storing signed 48 bit value
>+ *
>+ * Convert signed 48 bit value to its 64 bit representation.
>+ *
>+ * Return: signed 64 bit representation of signed 48 bit value.
>+ */
>+static inline

Never use "inline" in a c file.


>+s64 convert_s48_to_s64(s64 signed_48)
>+{
>+	const s64 MASK_SIGN_BITS = GENMASK_ULL(63, 48);

variable with capital letters? Not nice. Define? You have that multiple
times in the patch.


>+	const s64 SIGN_BIT_47 = BIT_ULL(47);
>+
>+	return ((signed_48 & SIGN_BIT_47) ? (s64)(MASK_SIGN_BITS | signed_48)

Pointless cast, isn't it?

You don't need () around "signed_48 & SIGN_BIT_47"


>+		: signed_48);

Return is not a function. Drop the outer "()"s.


The whole fuction can look like:
static s64 convert_s48_to_s64(s64 signed_48)
{
	return signed_48 & BIT_ULL(47) ? signed_48 | GENMASK_ULL(63, 48) :
					 signed_48;
}

Nicer?


[...]



>+int ice_get_pf_c827_idx(struct ice_hw *hw, u8 *idx)
>+{
>+	struct ice_aqc_get_link_topo cmd;
>+	u8 node_part_number;
>+	u16 node_handle;
>+	int status;
>+	u8 ctx;
>+
>+	if (hw->mac_type != ICE_MAC_E810)
>+		return -ENODEV;
>+
>+	if (hw->device_id != ICE_DEV_ID_E810C_QSFP) {
>+		*idx = C827_0;
>+		return 0;
>+	}
>+
>+	memset(&cmd, 0, sizeof(cmd));
>+
>+	ctx = ICE_AQC_LINK_TOPO_NODE_TYPE_PHY << ICE_AQC_LINK_TOPO_NODE_TYPE_S;
>+	ctx |= ICE_AQC_LINK_TOPO_NODE_CTX_PORT << ICE_AQC_LINK_TOPO_NODE_CTX_S;
>+	cmd.addr.topo_params.node_type_ctx = ctx;
>+	cmd.addr.topo_params.index = 0;

You zeroed the struct 4 lines above...


>+
>+	status = ice_aq_get_netlist_node(hw, &cmd, &node_part_number,
>+					 &node_handle);
>+	if (status || node_part_number != ICE_ACQ_GET_LINK_TOPO_NODE_NR_C827)
>+		return -ENOENT;
>+
>+	if (node_handle == E810C_QSFP_C827_0_HANDLE)
>+		*idx = C827_0;
>+	else if (node_handle == E810C_QSFP_C827_1_HANDLE)
>+		*idx = C827_1;
>+	else
>+		return -EIO;
>+
>+	return 0;
>+}
>+

[...]

