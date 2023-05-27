Return-Path: <netdev+bounces-5857-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02AC8713322
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 09:43:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B9F301C210B9
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 07:43:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E32C3138C;
	Sat, 27 May 2023 07:43:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3BE37E
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 07:43:27 +0000 (UTC)
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE25E6C
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 00:42:52 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-51440706e59so2123550a12.3
        for <netdev@vger.kernel.org>; Sat, 27 May 2023 00:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1685173368; x=1687765368;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=R5NtrsS95R0xqEat/hRLg7n7Lnwa8zfFWiq0ILj5PL0=;
        b=pxFOQH8e4RFaqdirSlDbMpOD3p4erot8D9vXM/cnn3b/Yz/vz7mPUfPRi+ZsgGYGb7
         Hf5ytBTJUGmk3+HJ4uJYOCtB5ZDcUjEKXV6A/FbLKid4h4T1Re0ikDohAWNAgYBzEE8I
         koGAKB2hlYYIZ4uyfTJ6HSeqXvfEoLTgBJs0o5KB20WNCIZbJlIH6GRRLwQYCMBudxBB
         ATXlhLxNp1W59cS+zmg1ofo6WYuDnBHDNuZ6sXUaEh3akNJNn3s1KcRr+obMmV50jmMT
         WLjGAZ9OxUT3PIHM+Y3ftIBfrfxF7oGw3PR9zdrsWALE9+aUUy8bEoV/3HCWbFwXhT68
         odBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685173368; x=1687765368;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R5NtrsS95R0xqEat/hRLg7n7Lnwa8zfFWiq0ILj5PL0=;
        b=cuAkojMssLL0GeVq9XEZhESYf+B8MfSKlr5WmdSYVbuCMJN/La3rYPwoctCq9P95Y4
         qBQe7MJwmUpfMbz/Pr6Z85s4aysCtE61wUDZbTjUQXa8AZgHg5o1ZEEsYuVppOgR5QtH
         y3KTxNBEup33Fp9J8Kwf+MomSFSc5RTr7f78lgM/lLOASNml3qxpJaFtd1PbU0y3YW92
         KRE0Ox5GxtLbFje5dyWE1wZiuRnQYvShHBzThUHhaNJ15u1mP4aAWHSE8kwT0y6ztvEe
         dkmwArqB8syM9KNse+UH4BSXc1bHLFOF5G7shtjCUNwTknovR1OVjD1x4+nk3+7RtvHz
         pA/A==
X-Gm-Message-State: AC+VfDy0RSLLMtcoak+p+gNgzqa3eEe2BVINKMfLACORr88+U7U6pblo
	JGu2ldv7jWA6Mb3S3s72ygwkfM4ZveF9J2C5fGeE+Q==
X-Google-Smtp-Source: ACHHUZ6BVqCX+ScrfDOccnLgFyIpZRrOSyc6JnPImigvpmxjQq+GAv3g5vdZ9NZgzKbRAOvvw5S3CQ==
X-Received: by 2002:a17:907:25c2:b0:96f:d556:b926 with SMTP id ae2-20020a17090725c200b0096fd556b926mr4264062ejc.77.1685173368240;
        Sat, 27 May 2023 00:42:48 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id g11-20020a17090669cb00b0096efd44dbefsm3129478ejs.1.2023.05.27.00.42.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 May 2023 00:42:47 -0700 (PDT)
Date: Sat, 27 May 2023 09:42:45 +0200
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
Message-ID: <ZHG0dSuA7s0ggN0o@nanopsycho>
References: <20230526102841.2226553-1-jiri@resnulli.us>
 <20230526102841.2226553-15-jiri@resnulli.us>
 <20230526211008.7b06ac3e@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230526211008.7b06ac3e@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Sat, May 27, 2023 at 06:10:08AM CEST, kuba@kernel.org wrote:
>On Fri, 26 May 2023 12:28:40 +0200 Jiri Pirko wrote:
>> Move port_del() from devlink_ops into newly introduced devlink_port_ops.
>
>I didn't think this thru last time, I thought port_new will move 
>in another patch, but that's impossible (obviously?).
>
>Isn't it kinda weird that the new callback is in one place and del
>callback is in another? Asymmetric ?

Yeah, I don't know how to do it differently. port_new() has to be
devlink op, as it operates not on the port but on the device. However,
port_del() operates on device. I was thinking about changing the name of
port_del() to port_destructor() or something like that which would make
the symmetricity issue bit less visible. IDK, up to you. One way or
another, I think this could be easily done as a follow-up (I have 15
patches now already anyway).

Thanks!

