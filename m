Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68A6D633A99
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 11:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232556AbiKVKxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 05:53:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbiKVKxU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 05:53:20 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 545CC2AC75
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 02:53:19 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id bj12so34794898ejb.13
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 02:53:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=qrat0Pjzpc2UdTChGgfw6N6SPZm+lQzUeXb2AdSMzjo=;
        b=C1/cubd0PIuUcCiAe+ibYh9Ew8XP4io9382EKY4T5xriMKD7StRrLoeOhUnzGq+2N3
         qSsbDk1k8hyz9oE9ryxJKYFH9zAHr84EFsf95DMhq9JK1wBjupS5Mdyt3D8PqCdGp0WN
         81QGK7ejvCdONc7Lgc2CKywhG+tJY4Qn1jMgk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qrat0Pjzpc2UdTChGgfw6N6SPZm+lQzUeXb2AdSMzjo=;
        b=ojMLUswWxBwUbhaTsWVdzVjWhEC+8iHEvYz+YB1kpdK+n3+jmbFbWVmsjKlihZSUrb
         B1sty2NS/EO0eIVUBckNpt/wHKl8hjZ/pYf1IdEQOSzaHMSLdNPugLRKm/scKShZEppK
         pXBnMYyPTKPeLLokbCN/yHCh3puevbdmOndnlX53q9x1zjXaZ251zyyksEqgFtjN4MGW
         0kbTjKIRJRn+XxJ4payWB2t2aQAv3G92C+RT3SJincEVVwzaB62bNZKcXK/mxlDsUvkw
         oiUXcMPZi1WGURWyTgddb59ogCAOfgsnODTDH+JTQgCVVr+PJFn4Gf5Or6GP9nHD02Vu
         LE+Q==
X-Gm-Message-State: ANoB5pmdsdwnoBdUuYrrtKiIUEQjS+TMA8vsFnHNUuqKrBFN1Emybaus
        xISvOCamIxymmdM84GRPeXQ40w==
X-Google-Smtp-Source: AA0mqf7XAJOqNlO6A5nDCWImDOCW+OdFx5uaS68GJz7vfX/5OZJyDnya1hUAtopXJKKk4IzXrtB/Pw==
X-Received: by 2002:a17:906:8503:b0:7ad:8480:309d with SMTP id i3-20020a170906850300b007ad8480309dmr8154821ejx.156.1669114397871;
        Tue, 22 Nov 2022 02:53:17 -0800 (PST)
Received: from cloudflare.com (79.184.204.15.ipv4.supernova.orange.pl. [79.184.204.15])
        by smtp.gmail.com with ESMTPSA id 8-20020a170906318800b007b47748d22fsm3755160ejy.220.2022.11.22.02.53.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 02:53:17 -0800 (PST)
References: <20221119130317.39158-1-jakub@cloudflare.com>
 <f8e54710-6889-5c27-2b3c-333537495ecd@I-love.SAKURA.ne.jp>
 <a850c224-f728-983c-45a0-96ebbaa943d7@I-love.SAKURA.ne.jp>
 <87wn7o7k7r.fsf@cloudflare.com>
 <ef09820a-ca97-0c50-e2d8-e1344137d473@I-love.SAKURA.ne.jp>
 <87fseb7vbm.fsf@cloudflare.com>
 <f2fdb53a-4727-278d-ac1b-d6dbdac8d307@I-love.SAKURA.ne.jp>
User-agent: mu4e 1.6.10; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tom Parkin <tparkin@katalix.com>,
        syzbot+703d9e154b3b58277261@syzkaller.appspotmail.com,
        syzbot+50680ced9e98a61f7698@syzkaller.appspotmail.com,
        syzbot+de987172bb74a381879b@syzkaller.appspotmail.com
Subject: Re: [PATCH net] l2tp: Don't sleep and disable BH under writer-side
 sk_callback_lock
Date:   Tue, 22 Nov 2022 11:46:58 +0100
In-reply-to: <f2fdb53a-4727-278d-ac1b-d6dbdac8d307@I-love.SAKURA.ne.jp>
Message-ID: <871qpvmfab.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 06:48 PM +09, Tetsuo Handa wrote:
> On 2022/11/22 6:55, Jakub Sitnicki wrote:
>> First, let me say, that I get the impression that setup_udp_tunnel_sock
>> was not really meant to be used on pre-existing sockets created by
>> user-space. Even though l2tp and gtp seem to be doing that.
>> 
>> That is because, I don't see how it could be used properly. Given that
>> we need to check-and-set sk_user_data under sk_callback_lock, which
>> setup_udp_tunnel_sock doesn't grab itself. At the same time it might
>> sleep. There is no way to apply it without resorting to tricks, like we
>> did here.
>> 
>> So - yeah - there may be other problems. But if there are, they are not
>> related to the faulty commit b68777d54fac ("l2tp: Serialize access to
>> sk_user_data with sk_callback_lock"), which we're trying to fix. There
>> was no locking present in l2tp_tunnel_register before that point.
>
> https://syzkaller.appspot.com/bug?extid=94cc2a66fc228b23f360 is the one
> where changing lockdep class is concurrently done on pre-existing sockets.
>
> I think we need to always create a new socket inside l2tp_tunnel_register(),
> rather than trying to serialize setting of sk_user_data under sk_callback_lock.

While that would be easier to handle, I don't see how it can be done in
a backward-compatible way. User-space is allowed to pass a socket to
l2tp today [1].

>
>> However, that is also not related to the race to check-and-set
>> sk_user_data, which commit b68777d54fac is trying to fix.
>
> Therefore, I feel that reverting commit b68777d54fac "l2tp: Serialize access
> to sk_user_data with sk_callback_lock" might be the better choice.

I'm okay with that. Providing we can come up with have an alternative
fix to the race between l2tp and other sk_user_data users.

[1] https://elixir.bootlin.com/linux/v6.1-rc6/source/net/l2tp/l2tp_netlink.c#L220
