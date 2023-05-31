Return-Path: <netdev+bounces-6865-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B3015718761
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 18:31:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 470FD1C20F24
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 16:31:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB53114294;
	Wed, 31 May 2023 16:31:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5E9182B1
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 16:31:39 +0000 (UTC)
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA8711F
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 09:31:37 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id af79cd13be357-75b08ceddd1so686129485a.1
        for <netdev@vger.kernel.org>; Wed, 31 May 2023 09:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685550697; x=1688142697;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=w73ltNZc5pXeMMTWyNcRJ5LtRedmy6B7sFFw9WIQ3PM=;
        b=aspHGLOfuOWnJuuulWdWfaAp6LxL9uynHMirkiQrACFXT8Fa7OsPaRsEQ7QRxnyjVR
         tJXvaJHMWV7MfkbkMfkosPtvMtdF14dISA4OE7utFCMpDyJkECtLmAwyWrWAaxBjPmy8
         3+m9VMdmKm4tkrXkilnAarMrLJO0gW3bkV8MJ6rLYDDmh+W0q5c8zq/wADCHLm57T451
         /MikdwkJISnh1S/El2ikDp/W7X+8aCuAiZedsSdKOchZQ7VK7GqHjD8j6ONn5OgJxiCd
         iVBldLScImdi/K99L4bjzBkR5usFUpBaKwxxU71KjZ+7en10bykQhVwcbikF8xsqu6kR
         DdeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685550697; x=1688142697;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w73ltNZc5pXeMMTWyNcRJ5LtRedmy6B7sFFw9WIQ3PM=;
        b=j5DTxFK8hMJGjZlSNB4evQwdjEARwDduTVR6AAM1yDfzycakzbvxP7nNb8rzTcxRFf
         asUlVxnDwN36hUzRp8tmXKIMurZvuVZOTFg3fMYyFLAQt8OqLoFGqT2nJ4gYdm5P6gHz
         mHosu6sM1VEqYTBU8SuPKYyHqoVOMX6pmK40BPMtrK0Y+Xca0DYOMxB7hZlKoVn0N514
         6H6aO02zJdi1HtqRZ1rQ9vmuhX/+BcOa7JFg9vICf5j2Lkfia0+UOn9VqnaZeRuHfs8r
         fnCOUEXlZ9NHP5YaYG5XnfMtVIa3xleBlMqtrHAYqMRouThFX+4CBxroUTNdzMyiSzmU
         j/GA==
X-Gm-Message-State: AC+VfDyAYWLYBtAmCxBa8GlQ9OHSEZoBXJhtp+6H2X5Q/THCbprZDIXM
	4j3JQFd43uxCxLpuwdlz/0s=
X-Google-Smtp-Source: ACHHUZ4KmWugDXjfdw9xCKvet69mC2zcMEKUskI0dNPSjj0oHa3f9U5xatmTGY9IkifIi3LfIq+6+w==
X-Received: by 2002:a05:620a:2b38:b0:75b:23a0:de87 with SMTP id do56-20020a05620a2b3800b0075b23a0de87mr6601087qkb.5.1685550696935;
        Wed, 31 May 2023 09:31:36 -0700 (PDT)
Received: from ?IPV6:2001:470:42c4:101:5893:3995:788b:ca6? ([2001:470:42c4:101:5893:3995:788b:ca6])
        by smtp.gmail.com with ESMTPSA id o14-20020a05620a130e00b0075cb085cbc8sm5007306qkj.97.2023.05.31.09.31.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 May 2023 09:31:36 -0700 (PDT)
Message-ID: <7ea57097-b458-c30b-bb53-517b901d3751@gmail.com>
Date: Wed, 31 May 2023 10:31:33 -0600
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: Regression in IPv6 autoconf, maybe "ipv6/addrconf: fix timing bug
 in tempaddr regen"
Content-Language: en-US
To: Jan Engelhardt <jengelh@inai.de>
Cc: Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>
References: <4n64q633-94rr-401n-s779-pqp2q0599438@vanv.qr>
From: Sam Edwards <cfsworks@gmail.com>
In-Reply-To: <4n64q633-94rr-401n-s779-pqp2q0599438@vanv.qr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hey there Jan,

On 5/31/23 03:20, Jan Engelhardt wrote:
> Greetings.
> 
> I am observing that between kernel 5.19 and 6.0, a change was introduced
> that makes the system just stop generating IPv6 Privacy Addresses after
> some time.

I'd been encountering this exact problem very reliably since at least 
the early 4.x days, which was my motivation for authoring this patch 
(which had fully fixed the problem for me).

So imagine my surprise to learn that not only did the patch not 
completely resolve the issue, and that the problem doesn't happen 
reliably enough for you on the earlier kernels to see it in your 
regression test, but that my patch is evidently making the problem 
happen *more* frequently in your case!

You're probably right to single this commit out of your shortlog, since 
it is directly related to this problem, but just to be sure: could you 
skip the bisecting ahead to test this commit vs. its parent?

I'm going to be very confused if this change is definitely to blame. 
Before this change, the problem happened because there was a narrow time 
window for temporary address regeneration, where addrconf_verify_rtnl() 
had to run right before the previous temporary address was about to run 
out its preferred lifetime, but before it actually did so. This patch 
ought not to be doing anything more than removing the requirement that 
the old address is still preferred, so it should make the problem happen 
less often (if at all) -- not more.

Since we're having some pretty extreme Works On My Machine Syndrome 
here, we should really figure out what's different in your case from 
mine. What arch are you building these kernels for? Could you share the 
defconfig? Are you able to see this on multiple machines/networks or 
have you only tried the one? Is this machine real hardware or a VM?

Kind regards,
Sam

