Return-Path: <netdev+bounces-10653-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 82B0E72F909
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 11:27:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 46B3D280FF8
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 09:27:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EE885686;
	Wed, 14 Jun 2023 09:27:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71FC43FE6
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 09:27:33 +0000 (UTC)
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC54F1713
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 02:27:30 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3f7378a75c0so4153665e9.3
        for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 02:27:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1686734849; x=1689326849;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HtefXDjYklud7abCsC+WgTuAbpHOK06ISGHObSNNODA=;
        b=yrfI34Q6GvN+FjN0tBMhRhIOeZ+VqlZlmPBIeLwUQwYA9symwc6XeIfHRDvjxLjG6V
         mWI92FC7g4Iy+mbS+/EKtIv6gpw4bdc2QDKWvI32GRRv8eRIejwNFcMqxmc54nmtzfOS
         vf3+qYecBp+aVBHQXycTqZiXDwW3Cs5cTChM//GSlmbcUKVdqWeA+3LPSuydIIMrsEB+
         q1rV5ytMHmwhHX17niRkrt4lA0p7by3+yJTr4CpUmls7/tfRMGt4+9e4kjWUuWR080Qf
         P3ot1hflAhk4tZAoWorHdR08BCgd3svaC365uWcMicY8oIDQ/xlHHpPBO6Z0nBwgzCNt
         WmZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686734849; x=1689326849;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HtefXDjYklud7abCsC+WgTuAbpHOK06ISGHObSNNODA=;
        b=AlE4MA85650mKEuDdWdxBUGCdm/aaM7zep1Syi2LE2HjTgOExZ19KQPMcjACSdMW5H
         Ou9Nq8SVLjvA+PjHyd9fYACyNsEafWI9uxDIBslmqRKFri0qFmV1CVqD/Yd3X36kNwnY
         mqifC5aTFjZeyyV3nA38zsIuz2ii3XGfV48nERkjCwNFLNNF9/WJUVHtUBW/cA3OqcBf
         va0ISypx65fUgsFt9IOPHVLmS+6DMnjY8mc+gQ7FDTXQfz+NHqL3FpDjMTAALJ8BWsk3
         sWlI8LKHhwUjw7XyUDj2js07g7tv18y4fN4OyI6V9qbuuqBTaKF6oAa1UdATitpQgiUU
         acVg==
X-Gm-Message-State: AC+VfDxUvtKzApuKrZ7K1yxVIJgtlB2fQVv7Os816lAcYbQTCRFjG8l1
	9clpUVrhtnbc41oCuj+0FFmyzQ==
X-Google-Smtp-Source: ACHHUZ7GlBUfe4DA2qBjSg64mcltE0M9LgJWODvo3Av0ztoxCP/DZKdZxYp0GD/Cv/+mNbbxd4YpFg==
X-Received: by 2002:adf:e54c:0:b0:30f:bd48:6828 with SMTP id z12-20020adfe54c000000b0030fbd486828mr7876719wrm.31.1686734849068;
        Wed, 14 Jun 2023 02:27:29 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id s14-20020adfeb0e000000b0030ae53550f5sm17681103wrn.51.2023.06.14.02.27.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 02:27:28 -0700 (PDT)
Date: Wed, 14 Jun 2023 11:27:27 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>, vadfed@meta.com,
	jonathan.lemon@gmail.com, pabeni@redhat.com, corbet@lwn.net,
	davem@davemloft.net, edumazet@google.com, vadfed@fb.com,
	jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
	saeedm@nvidia.com, leon@kernel.org, richardcochran@gmail.com,
	sj@kernel.org, javierm@redhat.com, ricardo.canuelo@collabora.com,
	mst@redhat.com, tzimmermann@suse.de, michal.michalik@intel.com,
	gregkh@linuxfoundation.org, jacek.lawrynowicz@linux.intel.com,
	airlied@redhat.com, ogabbay@kernel.org, arnd@arndb.de,
	nipun.gupta@amd.com, axboe@kernel.dk, linux@zary.sk,
	masahiroy@kernel.org, benjamin.tissoires@redhat.com,
	geert+renesas@glider.be, milena.olech@intel.com, kuniyu@amazon.com,
	liuhangbin@gmail.com, hkallweit1@gmail.com, andy.ren@getcruise.com,
	razor@blackwall.org, idosch@nvidia.com, lucien.xin@gmail.com,
	nicolas.dichtel@6wind.com, phil@nwl.cc, claudiajkang@gmail.com,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
	linux-rdma@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	poros@redhat.com, mschmidt@redhat.com, linux-clk@vger.kernel.org,
	vadim.fedorenko@linux.dev
Subject: Re: [RFC PATCH v8 01/10] dpll: documentation on DPLL subsystem
 interface
Message-ID: <ZImH/6GzGdydC3U3@nanopsycho>
References: <20230609121853.3607724-1-arkadiusz.kubalewski@intel.com>
 <20230609121853.3607724-2-arkadiusz.kubalewski@intel.com>
 <20230612154329.7bd2d52f@kernel.org>
 <ZIg8/0UJB9Lbyx2D@nanopsycho>
 <20230613093801.735cd341@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230613093801.735cd341@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Tue, Jun 13, 2023 at 06:38:01PM CEST, kuba@kernel.org wrote:
>On Tue, 13 Jun 2023 11:55:11 +0200 Jiri Pirko wrote:
>> >> +``'pin': [{
>> >> + {'clock-id': 282574471561216,
>> >> +  'module-name': 'ice',
>> >> +  'pin-dpll-caps': 4,
>> >> +  'pin-id': 13,
>> >> +  'pin-parent': [{'pin-id': 2, 'pin-state': 'connected'},
>> >> +                 {'pin-id': 3, 'pin-state': 'disconnected'},
>> >> +                 {'id': 0, 'pin-direction': 'input'},
>> >> +                 {'id': 1, 'pin-direction': 'input'}],
>> >> +  'pin-type': 'synce-eth-port'}
>> >> +}]``  
>> >
>> >It seems like pin-parent is overloaded, can we split it into two
>> >different nests?  
>> 
>> Yeah, we had it as two and converged to this one. The thing is, the rest
>> of the attrs are the same for both parent pin and parent device. I link
>> it this way a bit better. No strong feeling.
>
>Do you mean the same attribute enum / "space" / "set"?

Yeah, that is my understanding. Arkadiusz, could you please clarify?


>In the example above the attributes present don't seem to overlap.
>For user space its an extra if to sift thru the objects under
>pin-parent.
>
>> >Also sounds like setting pin attrs and pin-parent attrs should be
>> >different commands.  
>> 
>> Could be, but what't the benefit? Also, you are not configuring
>> pin-parent. You are configuring pin:pin-parent tuple. Basically the pin
>> configuration as a child. So this is mainly config of the pin itsest
>> Therefore does not really make sense to me to split to two comments.
>
>Clarity of the API. If muxing everything thru few calls was the goal
>we should also have very few members in struct dpll_pin_ops, and we
>don't.

How the the internal kernel api related to the uapi? I mean, it's quite
common to have 1:N relationsip between cmd and op. I have to be missing
your point. Could you be more specific please?

Current code presents PIN_SET command with accepts structured set of
attribute to be set. The core-driver api is pretty clear. Squashing to
a single op would be disaster. Having one command per attr looks like an
overkill without any real benefit. How exactly do you propose to change
this?

