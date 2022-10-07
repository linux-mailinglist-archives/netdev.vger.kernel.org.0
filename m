Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE0445F7BCB
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 18:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbiJGQrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 12:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbiJGQrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 12:47:41 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D260A59A5;
        Fri,  7 Oct 2022 09:47:40 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id j7so8129786wrr.3;
        Fri, 07 Oct 2022 09:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HiiUNJDOhM1Nd+slN6vUFMPWfVZfoaBty2cdSA5NAn0=;
        b=kx/dFy1kPcGnmHRof0PzfpQMXCVDWmazurTZ0WxolS437CwJ2okhptOqaHzTgmw2wy
         0KT0G9gzvE7HnKpvo9xGxydJNK9PJ/OXBVcgG4BZUCTJH+K2E8MxrA293+P4ZRHhpHar
         jaaWqnC+1TUQjQMs8PVQZJ+XmdaI8UZpvo+RyGBKA4OT5A3hwF+EK27Kz67TNU+eMej0
         f0fNjlOf8WnTQBFr+vaG51hiV0tUAJnnzEaVOS/WCmV3LMxDgDTgEx2FgBDmGSV1WvkV
         AcmCDRjU9FFlGtm4WKJ22tauXXID3ItV9kGzk0wCbLHBsLOag1x9pEUbE3bEy9A2Tudq
         DehA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HiiUNJDOhM1Nd+slN6vUFMPWfVZfoaBty2cdSA5NAn0=;
        b=D7kh0FqbYTvKjdpB8SyK6QijIvMDasg4gSy4deItb3G4vR4+Cfw/xhrSq20V0/ioXJ
         s9+x6am8WbsH1ZFIhNEraDkvS1e6yNHA4DIvxZS9DnSiCD5Q1TueCXyfUmuwH+PJ7ysb
         f/mrc+m2dlep/enpVjytRYKQ7EYE/pRL9BXb6eOhgbA6QC7HNxxdRZGao6VaOgclRpKL
         K/YGhGQ/Mez4W/mZeRHspEPfrGByB3cYgoruzLsWO+YvcFKsBB1JQ5ZrrQ/OI9nqSDjG
         7J2VB/NH9d6PmIzRLDrO+O9K4NybC/5YgxYNLAZV3tKXc0i4Jr+v+ECdiKAK1IGFFVAT
         bTkg==
X-Gm-Message-State: ACrzQf2AXfcrunmayIsK+//BS72EhDiyArVIjODQJlFFwxwkdV1VMmpc
        3DQb70iunCY5UWKtzXzV9J0TMLMhdirUrw==
X-Google-Smtp-Source: AMsMyM7c5Rsrv3mM6eDXZxyB2k9kTwEx6CzvGsPRwnmogHLCPd3/HCv8xYS3KtF9+LA8ulIyZmInPw==
X-Received: by 2002:a5d:64c3:0:b0:22e:57e7:6230 with SMTP id f3-20020a5d64c3000000b0022e57e76230mr3978538wri.482.1665161258756;
        Fri, 07 Oct 2022 09:47:38 -0700 (PDT)
Received: from [192.168.0.17] (33130E93.skybroadband.com. [51.19.14.147])
        by smtp.gmail.com with ESMTPSA id x13-20020a1c7c0d000000b003c42749b2c4sm151772wmc.15.2022.10.07.09.47.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Oct 2022 09:47:38 -0700 (PDT)
Message-ID: <1eca7cd0-ad6e-014f-d4e2-490b307ab61d@gmail.com>
Date:   Fri, 7 Oct 2022 17:47:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [REGRESSION] Unable to NAT own TCP packets from another VRF with
 tcp_l3mdev_accept = 1
Content-Language: en-US
To:     Maximilien Cuony <maximilien.cuony@arcanite.ch>
Cc:     netdev@vger.kernel.org, Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>,
        David Ahern <dsahern@kernel.org>,
        netfilter-devel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
References: <98348818-28c5-4cb2-556b-5061f77e112c@arcanite.ch>
 <20220930174237.2e89c9e1@kernel.org>
From:   Mike Manning <mvrmanning@gmail.com>
In-Reply-To: <20220930174237.2e89c9e1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On Wed, 28 Sep 2022 16:02:43 +0200 Maximilien Cuony wrote:
>
> However when the issue is present, the SYNACK does arrives on eth2, but 
> is never "unNATed" back to eth1:
>
> 10:25:07.644433 eth0 Out IP 192.168.5.1.48684 > 99.99.99.99.80: Flags 
> [S], seq 3207393154
> 10:25:07.644782 eth1 In  IP 192.168.5.1.48684 > 99.99.99.99.80: Flags 
> [S], seq 3207393154
> 10:25:07.644793 eth2 Out IP 192.168.1.1.48684 > 99.99.99.99.80: Flags 
> [S], seq 3207393154
> 10:25:07.668551 eth2 In  IP 54.36.61.42.80 > 192.168.1.1.48684: Flags 
> [S.], seq 823335485, ack 3207393155
>
> The issue is only with TCP connections. UDP or ICMP works fine.
>
> Turing off net.ipv4.tcp_l3mdev_accept back to 0 also fix the issue, but 
> we need this flag since we use some sockets that does not understand VRFs.
>
> We did have a look at the diff and the code of inet_bound_dev_eq, but we 
> didn't understand much the real problem - but it does seem now that 
> bound_dev_if if now checked not to be False before the bound_dev_if == 
> dif || bound_dev_if == sdif comparison, something that was not the case 
> before (especially since it's dependent on l3mdev_accept).
>
> Maybe our setup is wrong and we should not be able to route packets like 
> that?
>
> Thanks a lot and have a nice day!
>
> Maximilien Cuony

Hi Maximilien,

Apologies that you have now hit this issue. Further to David's reply
with the link for the rationale behind the change, the bisected commit
you found restores backwards compatibility with the 4.19 kernel to allow
a match on an unbound socket when in a VRF if tcp_l3mdev_accept=1, the
absence of this causing issues for others. Isolation between default and
other VRFs as introduced by the team I worked for back in 2018 and
introduced in 5.x kernels remains guaranteed if tcp_l3mdev_accept=0.

There is no appetite so far to introduce yet another kernel parameter to
control this specific behavior, see e.g.
https://lore.kernel.org/netdev/f174108c-67c5-3bb6-d558-7e02de701ee2@gmail.com/

Is there any possibility that you could use tcp_l3mdev_accept=0 by
running any services needed in the VRF with 'ip vrf exec <vrf> <cmd>'?

Is the problem specific to using NAT for eth2 in the VRF, i.e. have you
tried on another interface in that VRF, or on eth2 without NAT config?

While match on an unbound socket in the VRF is now possible again and
somehow causing the issue, I would have thought that a bound socket
should still be chosen due to it having a higher score c.f. compute_score().

No doubt you are doing this, but can I also check that your VRF config
is correct according to
https://www.kernel.org/doc/Documentation/networking/vrf.txt , so
reducing the local lookup preference, etc., e.g.

ip route add table 1200 unreachable default metric 4278198272

ip -6 route add table 1200 unreachable default metric 4278198272

ip rule add pref 32765 from all lookup local

ip rule del pref 0 from all lookup local

(and check output of 'ip rule' & 'ip route ls vrf firewall', no need to 
reply with this)

Thanks

Mike





