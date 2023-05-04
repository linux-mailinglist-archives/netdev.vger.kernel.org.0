Return-Path: <netdev+bounces-271-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DF5E66F69AD
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 13:18:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EB3D71C210FA
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 11:18:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53106FBF9;
	Thu,  4 May 2023 11:18:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47EFB10EC
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 11:18:54 +0000 (UTC)
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEAE546B3
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 04:18:52 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id ffacd0b85a97d-3062c1e7df8so216330f8f.1
        for <netdev@vger.kernel.org>; Thu, 04 May 2023 04:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1683199131; x=1685791131;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+zf/6Kk7wlwMzgoieI4ADc/0KpgI0PIbW0Orbu7zEQs=;
        b=mHXJwM4DZUdQ9nMOoHFqCV/rylGCREHQlvXjGTuXiu4NuSqSjbKOkFDi1AqL/VrWIa
         8bgpj35qpmDVlsHPnkhZyLoX3YPGNREIGgzQqWhJZ6F7na4krZHnJVkeBa6DmyZIbOSb
         vWX6aImlbHkXQOqAR+RErvc51Tt/O1NA+cyxGjyrGoJ25fuiyK28H6TWs5f+Ho3nD9eG
         y+L7XVA0jJaADlVKBJsH+98VFvKkQImvCuMlBkchaW7wFE42tNRikWSoDPQFa3AkKNuq
         m4g33KwCJqdY/OsZffYNNECF0lTL/Kxhq22llvRBGPUB4Pbr9LFU/Pxumr+D+ShHbBFo
         CwZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683199131; x=1685791131;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+zf/6Kk7wlwMzgoieI4ADc/0KpgI0PIbW0Orbu7zEQs=;
        b=PeUz+dyqnvuAwkP1D4oDPrLB9H0Eph8k0u0M0We2EMJioWX4ICXxildKURBM11tfrZ
         /wqjd6kuJpS6JL/6uYwWwwWakDYn+Gg/Mg+io4p3UEQrorMrGJD6IV6vpzO9yiNOTHVH
         UdnTFKKLtHUnZIPQe7Qne2ndKTZT276heTbgitr5pU54VZ3rxPVyLQtLK0qpMvP28eO7
         Zb7HiWoWTzpowx0ssoJ4bfVpmOlAVHYEIEYQ4NTmRBQcGkiL2ch2CYRnXdca8zDq/sUG
         v7KiYQ0oi/vhsPKPvmuwJu4oUv4Sjidf0il3smRtNEutDWJxloEi3z0Z+JyMdOngu3dn
         qhaw==
X-Gm-Message-State: AC+VfDwWEhRKZ+61Pcywd/ZN8+iXAIsFbvXPl2qUllGDR+/R+5p+Vvpi
	XRw+BtHkwevHWdMmF5PzPBR1hA==
X-Google-Smtp-Source: ACHHUZ5Yxe+2HE+FmRZTFXmd1OCmP7KFW6mShX4t7u7KkCglAhepqWTRe15E6vN8DjmdQO4CSD6gLA==
X-Received: by 2002:a5d:6681:0:b0:303:97db:ae93 with SMTP id l1-20020a5d6681000000b0030397dbae93mr2001914wru.44.1683199131275;
        Thu, 04 May 2023 04:18:51 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id d2-20020a5d5382000000b00306423904d6sm4514221wrv.45.2023.05.04.04.18.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 May 2023 04:18:50 -0700 (PDT)
Date: Thu, 4 May 2023 13:18:49 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Vadim Fedorenko <vadfed@meta.com>
Cc: Jakub Kicinski <kuba@kernel.org>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Jonathan Lemon <jonathan.lemon@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Milena Olech <milena.olech@intel.com>,
	Michal Michalik <michal.michalik@intel.com>,
	linux-arm-kernel@lists.infradead.org,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>, poros@redhat.com,
	mschmidt@redhat.com, netdev@vger.kernel.org,
	linux-clk@vger.kernel.org
Subject: Re: [RFC PATCH v7 2/8] dpll: Add DPLL framework base functions
Message-ID: <ZFOUmViuAiCaHBfc@nanopsycho>
References: <20230428002009.2948020-1-vadfed@meta.com>
 <20230428002009.2948020-3-vadfed@meta.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230428002009.2948020-3-vadfed@meta.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Fri, Apr 28, 2023 at 02:20:03AM CEST, vadfed@meta.com wrote:

[...]


>diff --git a/include/uapi/linux/dpll.h b/include/uapi/linux/dpll.h
>index e188bc189754..75eeaa4396eb 100644
>--- a/include/uapi/linux/dpll.h
>+++ b/include/uapi/linux/dpll.h
>@@ -111,6 +111,8 @@ enum dpll_pin_direction {
> 
> #define DPLL_PIN_FREQUENCY_1_HZ		1
> #define DPLL_PIN_FREQUENCY_10_MHZ	10000000
>+#define DPLL_PIN_FREQUENCY_10_KHZ	10000
>+#define DPLL_PIN_FREQUENCY_77_5_KHZ	77500

This should be moved to patch #1.
please convert to enum, could be unnamed.

[...]

