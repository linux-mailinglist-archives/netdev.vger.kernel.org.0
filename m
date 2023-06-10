Return-Path: <netdev+bounces-9837-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 158EB72AD5B
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 18:36:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE87A28147C
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 16:36:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E018CC8E8;
	Sat, 10 Jun 2023 16:36:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D347D23C5
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 16:36:47 +0000 (UTC)
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E73D359A
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 09:36:44 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-974638ed5c5so592852066b.1
        for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 09:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1686415002; x=1689007002;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=X8VbRFbQOuqhFAPglq3rUuEFETDHIQvOfBEZigyYE00=;
        b=fcZwhYQXbZrGUCxD2cxWjeGu7RFEU0ScoH6Fu1j8oZlTPWxdTpxZpMcmjp2EzDf/9d
         FfZHTb9Jegul55u7V0zCjPzL5GRZCoYWPuup8y0FgDEX/VE4abtLSaelCPLmqGhOFvXf
         0hiMFMG0SHOUJHmTFAtrpSUozKDhB5uBNbxOAm1l9CSRT6MqowUWZKvUTc/wZ1A942wY
         p8bL7na2XtF6nwgC4GwchfUxPf/wCWr8c/90iLSEeM82o53tpfNniHl2LweqNqiJTqEo
         8La/4VPf8P1Wsh/9IK2QftfK8rl0/botcKtufVlRAOULG+cZ15IapPXlNaqykMscXVUg
         hfOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686415002; x=1689007002;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X8VbRFbQOuqhFAPglq3rUuEFETDHIQvOfBEZigyYE00=;
        b=WYl6ZPDmYEIrO4JA3d2Xu14nPox2NqKHASjDhKFakpKynp/yO1mQR01zcURUCculfR
         mYm+DzqW0haTx9x2p/F3hNP71CtA8O0p859MBs5f1SeHvSiuI8j4VrWBe9jr2k4STy9K
         k0/duVRxf7S2az8PdWHyEdFD2YhOktpqSpXvkZOqFEVUtTW9CgDd1NP3OL6TFJw4xeRI
         YayaTTo/VpAnMI6pXb2W1RemT7kAdEKXTwtGVHqlr7DtIIH8NZrw64mRPQdJQr4sjaci
         mIp7G50+Q3WhWwRpzTXspx3fIwfh4rSa/zP5aN3VyxxpTyjWvsQ0FNOE7TnqVDo4HAN7
         kZoQ==
X-Gm-Message-State: AC+VfDy7h1y53c1rshux0r6WHYe7704P3tPKdBe/owZmEPIyGUnBHN61
	XVIy/YllzvIAG2MjuP/nGu92sA==
X-Google-Smtp-Source: ACHHUZ4Vwbn5FWH4cTwcJAta6H8LObUb+MmlwTVJNnxgyTP9w4AqfMkvEAq7AY8i3/cgxY1KiIKmkw==
X-Received: by 2002:a17:906:58c5:b0:974:5e8b:fc28 with SMTP id e5-20020a17090658c500b009745e8bfc28mr5052733ejs.9.1686415002366;
        Sat, 10 Jun 2023 09:36:42 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id t16-20020a1709064f1000b0096f89fd4bf8sm2728669eju.122.2023.06.10.09.36.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jun 2023 09:36:41 -0700 (PDT)
Date: Sat, 10 Jun 2023 18:36:40 +0200
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
Subject: Re: [RFC PATCH v8 08/10] ice: implement dpll interface to control cgu
Message-ID: <ZISmmH0jqxZRB4VX@nanopsycho>
References: <20230609121853.3607724-1-arkadiusz.kubalewski@intel.com>
 <20230609121853.3607724-9-arkadiusz.kubalewski@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230609121853.3607724-9-arkadiusz.kubalewski@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Fri, Jun 09, 2023 at 02:18:51PM CEST, arkadiusz.kubalewski@intel.com wrote:

[...]


>+static int ice_dpll_mode_get(const struct dpll_device *dpll, void *priv,
>+			     enum dpll_mode *mode,
>+			     struct netlink_ext_ack *extack)
>+{
>+	*mode = DPLL_MODE_AUTOMATIC;

I don't understand how the automatic mode could work with SyncE. The
There is one pin exposed for one netdev. The SyncE daemon should select
exacly one pin. How do you achieve that?
Is is by setting DPLL_PIN_STATE_SELECTABLE on the pin-netdev you want to
select and DPLL_PIN_STATE_DISCONNECTED on the rest?


[...]

