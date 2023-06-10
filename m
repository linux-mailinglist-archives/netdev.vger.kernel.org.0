Return-Path: <netdev+bounces-9801-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 62B8372A9EA
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 09:32:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 85C281C20D39
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 07:32:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B24CA943;
	Sat, 10 Jun 2023 07:32:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280575C85
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 07:32:42 +0000 (UTC)
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 565613A8C
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 00:32:41 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-977d4a1cf0eso371538266b.1
        for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 00:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1686382360; x=1688974360;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=l7M0YngHom5+WNuAaqS8ORg1O1Fioma4l8vDyZ5uMCE=;
        b=FD2ljasmKR4FCNVKlrbvbiFQif9C0mf2yzEBy4Qx3/P9vPzkYiPKpRpLusAqq+LHU7
         WwEwp25JWtWMjVCKxCuTx0YY3fuyrcT2TpwayU1x39KF3SCY/fcG2yn991d4FPSgfhla
         r0KE1RndWSboXnv9iOkGlNuoupLmUH2YEGQmtcZGgLTcODd51dqFJM+aIHbP7c2tgf71
         QGppQ21EIY9jI+eGnPzKAJaT7WZ3veTnSShuNlv/p4ciM6sXWwP8AVd0XK2uW1zlWrVD
         fcLnhGqEwqo4wbPZy2gc35QP+i9fF+Jg8QnKyIoDm39/3JVCx0GpfJ/G8E4PGnuB3/uE
         7LpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686382360; x=1688974360;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l7M0YngHom5+WNuAaqS8ORg1O1Fioma4l8vDyZ5uMCE=;
        b=INYJ4hhPZS8WNvEefSMIgaLetJGhd7ttpubmZ6C5lod73YG4YHhaL9vf1j3mpjZfcO
         aG9gxl3qEjZNEpQmQIH2+Pmz84buL8t8VkQdA8BTQEBTgJmp21VjgN0g5WOYdatnCGH7
         bTzCfEzOS2RJJJQ5RVoLqOl7Wj2rjZbchhiAAtrGOZqGsiBcbdPFlG5fzPIo557PdI2+
         B+o7Z+wdnhe9vSV1wqm/CMqmMyx8du68dhUHxFmHYXLZE5YX2AAyQAMCAqPwR26Kc8pd
         yiL1u8wIs+3atquysrCF58Q/ntBhfwx26ze6hUGirMvn5Cl8vZikOkjJISxXboed4JI/
         57dQ==
X-Gm-Message-State: AC+VfDyH9B5sUZSPCuaM1N9PipK6fljZay6bveGnKyLMW2qp0uZIAvWw
	nI02OgjeL2qTvT5b608H82V+Zg==
X-Google-Smtp-Source: ACHHUZ6TNnOo+D3MGLaaLLt1WOqYeiIrCCME57vcIFwab6WYjt9d7cZidy6pJt20xNgdAB/dJoH9Sg==
X-Received: by 2002:a17:907:7212:b0:978:8a30:aaf with SMTP id dr18-20020a170907721200b009788a300aafmr3607778ejc.64.1686382359799;
        Sat, 10 Jun 2023 00:32:39 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id f10-20020a170906824a00b00971433ed5fesm2223482ejx.184.2023.06.10.00.32.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jun 2023 00:32:39 -0700 (PDT)
Date: Sat, 10 Jun 2023 09:32:38 +0200
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
Subject: Re: [RFC PATCH v8 05/10] dpll: api header: Add DPLL framework base
 functions
Message-ID: <ZIQnFqRBhmv3+SF8@nanopsycho>
References: <20230609121853.3607724-1-arkadiusz.kubalewski@intel.com>
 <20230609121853.3607724-6-arkadiusz.kubalewski@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230609121853.3607724-6-arkadiusz.kubalewski@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Fri, Jun 09, 2023 at 02:18:48PM CEST, arkadiusz.kubalewski@intel.com wrote:
>From: Vadim Fedorenko <vadim.fedorenko@linux.dev>

[...]

>+struct dpll_device_ops {
>+	int (*mode_get)(const struct dpll_device *dpll, void *dpll_priv,
>+			enum dpll_mode *mode, struct netlink_ext_ack *extack);
>+	int (*mode_set)(const struct dpll_device *dpll, void *dpll_priv,
>+			const enum dpll_mode mode,
>+			struct netlink_ext_ack *extack);
>+	bool (*mode_supported)(const struct dpll_device *dpll, void *dpll_priv,
>+			       const enum dpll_mode mode,
>+			       struct netlink_ext_ack *extack);
>+	int (*source_pin_idx_get)(const struct dpll_device *dpll,
>+				  void *dpll_priv,
>+				  u32 *pin_idx,
>+				  struct netlink_ext_ack *extack);

I'm pretty sure I wrote this to the last patchset version as well.
You call this op from anywhere, it's a leftover, please remove it.
In ptp_ocp remove it as well and implement the state_on_dpll pin op
instead. I'm pretty sure no one tested ptp_ocp with this patchset
version otherwise this would show-up :/

[...]

