Return-Path: <netdev+bounces-9899-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E8D8372B144
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 12:01:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 106DF2813D2
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 10:01:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AA208466;
	Sun, 11 Jun 2023 10:01:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC7A7469
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 10:01:18 +0000 (UTC)
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81A321709
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 03:01:16 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id 4fb4d7f45d1cf-514ab6cb529so8920968a12.1
        for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 03:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1686477675; x=1689069675;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=U7HN0f6TOWWkr11pJT0tfFyGZ1Me6eKxGL1ZqHz5p/E=;
        b=CK+40rDIEO4qBWIjslHU71w2FzcpmL66yJ2ffo8QNiGyJVgjt2njdUY13r8vlWLyRh
         bFzF3aspyFifeybgeAm5JsTbvM0Y0U+htlNyMhY4rZdso0DpijNINO8CzRHkG4h6vTm2
         qDNewH1UtM2COGT2JZr0R53kucC4xe+Scno8vkuo9GrhvTpVhzxcRtNBK/Aq+CslaRWL
         6hGnkuO6xqG3ciKigTB9qYkhGVxQ+wJ/f/yVK+VC1tnSVF3wpmP3pZLfGG23kH9vlrXt
         mefPq9PTmMZ08D7NdNkgeJfPZ4BFv+VTpfc09VRr8QF7C3rGqDJ7tFv5INdS55jkARsQ
         vZYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686477675; x=1689069675;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U7HN0f6TOWWkr11pJT0tfFyGZ1Me6eKxGL1ZqHz5p/E=;
        b=EtGP9fMMpay2aZ5e5ZGo5zDn0EjdowVMDQkpYHSwk+sWkaMIMRahPD9VYLR8lyB1ba
         nZgqZeExaqgQupRgL63QpFoXEGffkIxi2ieuEhZpklzoD42HSpj63/H3BsXQNfpwwaT/
         t+aKWzNLZubXheKLr87f67ApXwtpdyE14BJARgnymCggH8RpczCSghQPZAnBeO7dGJJ/
         9YYZE9L1Vgym1z2umIGeL1PKNJbZ90lxdj/IzsSbenbnizyDqvHvbA+yYq7pkRO2e8Z+
         U2PC035fjgg0NGbEgvwmmYPInqxSxYBBtbbNDJWCKtikErykIXmfhCRwDsbRsZ49DEI1
         7hqQ==
X-Gm-Message-State: AC+VfDwoPFbaQIVHnGKu/OZIVfT3j/wbvcLAGp/UfUWusSuB0NrdTI9F
	/4JcaxS47wpfMK0JPLDdmz348A==
X-Google-Smtp-Source: ACHHUZ5gWuO7BIceLcmBKNYkMGao9xFPw4XyyBHtMY8YchWoEkZuudgzgArbFrxLghboz06yhmTvFA==
X-Received: by 2002:a05:6402:520a:b0:516:a1d5:846f with SMTP id s10-20020a056402520a00b00516a1d5846fmr3286182edd.1.1686477674815;
        Sun, 11 Jun 2023 03:01:14 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id c7-20020aa7df07000000b00514b854c399sm3744198edy.84.2023.06.11.03.01.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jun 2023 03:01:13 -0700 (PDT)
Date: Sun, 11 Jun 2023 12:01:12 +0200
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
Subject: Re: [RFC PATCH v8 03/10] dpll: core: Add DPLL framework base
 functions
Message-ID: <ZIWbaLd87EMbkDAY@nanopsycho>
References: <20230609121853.3607724-1-arkadiusz.kubalewski@intel.com>
 <20230609121853.3607724-4-arkadiusz.kubalewski@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230609121853.3607724-4-arkadiusz.kubalewski@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Fri, Jun 09, 2023 at 02:18:46PM CEST, arkadiusz.kubalewski@intel.com wrote:
>From: Vadim Fedorenko <vadim.fedorenko@linux.dev>

[...]


>+ * dpll_xa_ref_dpll_first - find first record of given xarray
>+ * @xa_refs: xarray
>+ *
>+ * Context: shall be called under a lock (dpll_lock)
>+ * Return: first element on given xaaray

typo: xarray


>+ */
>+struct dpll_pin_ref *dpll_xa_ref_dpll_first(struct xarray *xa_refs)

[...]


>+/**
>+ * dpll_device_get - find existing or create new dpll device
>+ * @clock_id: clock_id of creator
>+ * @device_idx: idx given by device driver
>+ * @module: reference to registering module
>+ *
>+ * Get existing object of a dpll device, unique for given arguments.
>+ * Create new if doesn't exist yet.
>+ *
>+ * Context: Acquires a lock (dpll_lock)
>+ * Return:
>+ * * valid dpll_device struct pointer if succeeded
>+ * * ERR_PTR(-ENOMEM) - failed memory allocation

Yeah, that is kind of obvious, isn't? Really, drop this pointless
coments.


>+ * * ERR_PTR(X) - failed allocation on dpll's xa
>+ */
>+struct dpll_device *
>+dpll_device_get(u64 clock_id, u32 device_idx, struct module *module)

[...]


>+/**
>+ * dpll_pin_register - register the dpll pin in the subsystem
>+ * @dpll: pointer to a dpll
>+ * @pin: pointer to a dpll pin
>+ * @ops: ops for a dpll pin ops
>+ * @priv: pointer to private information of owner
>+ *
>+ * Context: Acquires a lock (dpll_lock)
>+ * Return:
>+ * * 0 on success
>+ * * -EINVAL - missing pin ops
>+ * * -ENOMEM - failed to allocate memory

Does not make sense to assign one errno to one specific error.
Avoid tables like this.


>+ */
>+int
>+dpll_pin_register(struct dpll_device *dpll, struct dpll_pin *pin,
>+		  const struct dpll_pin_ops *ops, void *priv)
>+{
>+	int ret;
>+
>+	mutex_lock(&dpll_lock);
>+	if (WARN_ON(!(dpll->module == pin->module &&
>+		      dpll->clock_id == pin->clock_id)))
>+		ret = -EFAULT;

-EINVAL;


>+	else
>+		ret = __dpll_pin_register(dpll, pin, ops, priv);
>+	mutex_unlock(&dpll_lock);
>+
>+	return ret;
>+}

[...]

