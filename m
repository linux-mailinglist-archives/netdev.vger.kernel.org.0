Return-Path: <netdev+bounces-11214-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E1DC731F59
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 19:38:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CECC01C20EF5
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 17:38:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D9AF2E0F0;
	Thu, 15 Jun 2023 17:37:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01DE8EAD8
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 17:37:28 +0000 (UTC)
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC75D2721
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 10:37:26 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id 4fb4d7f45d1cf-5193c97ecbbso2647873a12.1
        for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 10:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1686850645; x=1689442645;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=e1697TduVfJPLqCEsyLxlOjc1g2z5WxEkrtVluvOtQI=;
        b=eKI+eiK7vWxeG2E1D0IXNTcXmQFoZ0RKtwRCJ60VW/aoLwxqm1mcUkubg9YP1uApUX
         r1TMCKypSPDnohy5hAPvJ9YMj9jSwMIITkAULstq4gajGreOtgwYz/9KK91zKMeIurxt
         Zt01bvGT/nKeEEsZjcaHrDQJIEu5M0k4fGu8WZ5czaVTzRXywniPB3FbWONmZANmh1TZ
         cWVVTP99EiotEee76IKnyXMSx/UrW+Cgy2eG6mVsZZvug9HI5gsDOcA8pegMrkSCvc2C
         iy3u7AbGPuZYageOzXYq9izFmvZGhLlb4WM+1DyvcElUOJIwttFXZqY2z0tmBAawypnP
         SGyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686850645; x=1689442645;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e1697TduVfJPLqCEsyLxlOjc1g2z5WxEkrtVluvOtQI=;
        b=B1iOhLMpze6hNWnA3JcVHpp7HAoPwR3ss82kPXYVopKxw2YCdeBsIycRmZyZ0fuFE5
         5PQDcZeim0RO9VuF0DHeDYOgdHidQaYgNEdLqYmIZThK76vLhkSSt29jUO/mueguv+49
         k15uDYOyOJLPMzxAfmJwObWq32EeYmMbKFYre5jM8ffllksWH7YiaE/3HsGLQQ7aIF2I
         /4um2yi2x4dkssjdfePFUy9JWnCvSuUf/Tosw1lwDgIi1zgbFs2wTKKEwM5wzclA/bYL
         iRqKjraFdMMeByctzIZe6Fnhtt5S566Yj/NQDXDr+8Fbb7SNjOQch4/7nJgrVbyKEYEu
         6deQ==
X-Gm-Message-State: AC+VfDznv0aSWemtoKU1p3xMGrUhXc+J+GjbRwJoRKy55j3Da92qUO13
	l6jO6/YKcqGnTSC6RMOHGtkKsA==
X-Google-Smtp-Source: ACHHUZ4phw8d+5Yy0MHiF0nRRkkJ4H7vRDBrZ4eFGxnIV9Ich8gzxczT+FYwctI9ljTT4jGzTcpFSA==
X-Received: by 2002:a50:ed85:0:b0:518:7415:3b61 with SMTP id h5-20020a50ed85000000b0051874153b61mr5729638edr.23.1686850644815;
        Thu, 15 Jun 2023 10:37:24 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id a12-20020aa7cf0c000000b00514b8d5eb29sm9173417edy.43.2023.06.15.10.37.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jun 2023 10:37:24 -0700 (PDT)
Date: Thu, 15 Jun 2023 19:37:23 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Saeed Mahameed <saeed@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>,
	netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
	Shay Drory <shayd@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>
Subject: Re: [net-next 14/15] net/mlx5: Light probe local SFs
Message-ID: <ZItMUwiRD8mAmEz1@nanopsycho>
References: <20230610014254.343576-1-saeed@kernel.org>
 <20230610014254.343576-15-saeed@kernel.org>
 <20230610000123.04c3a32f@kernel.org>
 <ZIVKfT97Ua0Xo93M@x130>
 <20230612105124.44c95b7c@kernel.org>
 <ZIj8d8UhsZI2BPpR@x130>
 <20230613190552.4e0cdbbf@kernel.org>
 <ZIrtHZ2wrb3ZdZcB@nanopsycho>
 <20230615093701.20d0ad1b@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230615093701.20d0ad1b@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Thu, Jun 15, 2023 at 06:37:01PM CEST, kuba@kernel.org wrote:
>On Thu, 15 Jun 2023 12:51:09 +0200 Jiri Pirko wrote:
>> The problem is scalability. SFs could be activated in parallel, but the
>> cmd that is doing that holds devlink instance lock. That serializes it.
>> So we need to either:
>> 1) change the devlink locking to be able to execute some of the cmds in
>>    parallel and leave the activation sync
>> 2) change the activation to be async and work with notifications
>> 
>> I like 2) better, as the 1) maze we just got out of recently :)
>> WDYT?
>
>I guess we don't need to wait for the full activation. Is the port
>creation also async, then, or just the SF devlink instance creation?

I'm not sure I follow :/
The activation is when the SF auxiliary device is created. The driver then
probes the SF auxiliary device and instantiates everything, SF devlink,
SF netdev, etc.

We need wait/notification for 2 reasons
1) to get the auxiliary device name for the activated
   SF. It is needed for convenience of the orchestration tools.
2) to get the result of the activation (success/fail)
   It is also needed for convenience of the orchestration tools.

