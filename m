Return-Path: <netdev+bounces-6026-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C080371464A
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 10:31:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5FDE5280DFC
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 08:31:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C22336AAA;
	Mon, 29 May 2023 08:31:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F056AAE
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 08:31:21 +0000 (UTC)
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA41A7
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 01:31:18 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-3f6dbe3c230so31183795e9.3
        for <netdev@vger.kernel.org>; Mon, 29 May 2023 01:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1685349077; x=1687941077;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XYB47tk3oTjGn0jdy+GnB7AOxTC39Hztvvoi5m6eUhc=;
        b=e1qIMQLPiFgXLR1x4Unz8uD1jBLB8BcjYwWxb6hfHDSRkLP9eSjn2ZmLZjnXL3rAqs
         dMElwrYsixMzAo8kE14xs1ODKBLQJ3nM3r1gxJRhyU5v766G1hpVRlmOG87VXB1DyIPj
         hUHKjRR8cgEmJ8uhsykdcU5rBjfDVmg2BT60fIcpK23aPWdkmHccof6Lg7UapwxT30JA
         2IGRRm42DykYFqQg7GQgDDE3Rwu5Q2h6yThleBoQ8j0lAluf/8NuTPRMKQJi/juya8w8
         PQjNSZYxzybUGC3rxRfmKGPZlVqI59iC5X4QO0YoaNeqV8aN62sx/U1CrYuanoi75HpX
         QEug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685349077; x=1687941077;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XYB47tk3oTjGn0jdy+GnB7AOxTC39Hztvvoi5m6eUhc=;
        b=PRrJot7vJGrDqnOKDntIXtcdBPtcgbismlbhjgSwLnwEEt5ZLYT7AYWQ5yIXmrdFr3
         3lWWSYouFNrfwQl+vBnrq6XwljXS3EuKkx0K1jDckXWBQrbuYufyXMHvHfUmg9oXi/Yq
         gJcEhRrqFBX09a7oTTGEc9B6zhmgWFwlC6MsBQ//Ef/x2GJ/vBO/YHf1nKB9gpjhhBRy
         Kgu6dUwwR0Nnxt5uqrSljVo1h9sQgbB8Thg9Bmian6ycsGw5vaxuqJDisa++6+0TPy/V
         UiuvWxrwfpDr/PHsBNlkwi4WAfORvxMRLlCAzZGoiGOt8EW9NNT/Ui7p0abIYPCIucSf
         G3Gg==
X-Gm-Message-State: AC+VfDwID4pv3D+nQgkxZRPIJRNFsHRGLogCOVyyFs0ijNcSTAcjdmpF
	vNEH2Nk91sS8fJtThvpyOnnEJSVjVAJdeillL/Q=
X-Google-Smtp-Source: ACHHUZ5IG6l/pm9EPUQt43/jqaqPVayhdOaMtDjXJMhlqN1JbooKryz1thYYnQ3Dj2Ei6hgVOX+nOw==
X-Received: by 2002:a1c:f616:0:b0:3f4:1cd8:3e99 with SMTP id w22-20020a1cf616000000b003f41cd83e99mr9413645wmc.28.1685349076959;
        Mon, 29 May 2023 01:31:16 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id y8-20020a7bcd88000000b003f6038faa19sm16759390wmj.19.2023.05.29.01.31.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 01:31:15 -0700 (PDT)
Date: Mon, 29 May 2023 10:31:14 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
	edumazet@google.com, leon@kernel.org, saeedm@nvidia.com,
	moshe@nvidia.com, jesse.brandeburg@intel.com,
	anthony.l.nguyen@intel.com, tariqt@nvidia.com, idosch@nvidia.com,
	petrm@nvidia.com, simon.horman@corigine.com, ecree.xilinx@gmail.com,
	habetsm.xilinx@gmail.com, michal.wilczynski@intel.com,
	jacob.e.keller@intel.com
Subject: Re: [patch net-next v2 14/15] devlink: move port_del() to
 devlink_port_ops
Message-ID: <ZHRi0qZD/Hsjn0Fq@nanopsycho>
References: <20230526102841.2226553-1-jiri@resnulli.us>
 <20230526102841.2226553-15-jiri@resnulli.us>
 <20230526211008.7b06ac3e@kernel.org>
 <ZHG0dSuA7s0ggN0o@nanopsycho>
 <20230528233334.77dc191d@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230528233334.77dc191d@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Mon, May 29, 2023 at 08:33:34AM CEST, kuba@kernel.org wrote:
>On Sat, 27 May 2023 09:42:45 +0200 Jiri Pirko wrote:
>> >I didn't think this thru last time, I thought port_new will move 
>> >in another patch, but that's impossible (obviously?).
>> >
>> >Isn't it kinda weird that the new callback is in one place and del
>> >callback is in another? Asymmetric ?  
>> 
>> Yeah, I don't know how to do it differently. port_new() has to be
>> devlink op, as it operates not on the port but on the device. However,
>> port_del() operates on device. I was thinking about changing the name of
>> port_del() to port_destructor() or something like that which would make
>> the symmetricity issue bit less visible. IDK, up to you. One way or
>> another, I think this could be easily done as a follow-up (I have 15
>> patches now already anyway).
>
>One could argue logically removing a port is also an operation of 
>the parent (i.e. the devlink instance). The fact that the port gets
>destroyed in the process is secondary. Ergo maybe we should skip 
>this patch?

Well, the port_del() could differ for different port flavours. The
embedding structure of struct devlink_port is also different.

Makes sense to me to skip the flavour switch and have one port_del() for
each port.


