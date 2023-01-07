Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3E1B66116A
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 20:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232480AbjAGTw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 14:52:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231218AbjAGTwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 14:52:25 -0500
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6070332EBD
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 11:52:25 -0800 (PST)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-142b72a728fso4887782fac.9
        for <netdev@vger.kernel.org>; Sat, 07 Jan 2023 11:52:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WMjls6sqj3WusjSqyr/1NgaNU3Qupb3k+51tz5KbLlE=;
        b=eDjEW5x8D3p7vfDJfcz9oOEmBfB8YhtGRyhh+saV/OUZLaMxHXssSdIJofXVyJTkVW
         5nOm1CkZvSCiFvIS5xQpbvNvFJDiawhxvbmaVAq8pEyyVnw4nESVSVN4aF11OKAWg7fs
         gUUU/48uAdrZLIWzlcXJU05nLp9bjiz52zFAyYgvbb7vrE5MZ+wv3zXDrGnj+otHb0d/
         Vd1hWXLuOttXx64GSBAFJUcMt5Z89FWVptVsbli8iT8lUKArXnHScpQJdorYkP9JW9ud
         uogDiHkbMM1XMAstIsJ7ldqsQb9ofQJ7GGxAE3agJL/NnonP8AMPgked/RVRKXGWnILf
         bkRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WMjls6sqj3WusjSqyr/1NgaNU3Qupb3k+51tz5KbLlE=;
        b=Ze+KWeewGM571O7ead/zAW1WxTr3ESXizC0gu/chDeCnmR35o7cFhO12MdcvDSPL+Y
         aLQpggrenQgwLEHirWg76oAerdpjThTPPljUzvb7abgJy2/LcA/YomuWZ0a5NqDFcZ1C
         QCBS+LSiClCyPFE6mg6qMrc8DRoUmHdqVqi5pKNNt0qDILOyEisELHGiv3Ty7lskYXjt
         YFrMlxqvxQamnoSlX9bZ7CLVmAqMhrEn0R2KAf1rNpbtlODqOhKKFByLxMKn2reN7h9U
         WnnP0tWZxFU89/0BhejbfDV6ur3afYFp0imIxwNtfb7QBoVNOhS7LLHZE3298O994qky
         A3yQ==
X-Gm-Message-State: AFqh2kqBzr8L/fRma7bi3X8W09aBsga8CECLFUzT1PUvyMkoxBkau7+F
        HAPhGlKtarSBDqVrLrwAEQHLI1HyxW4=
X-Google-Smtp-Source: AMrXdXtC0b3d6lbDmp4iw6u5Bazg2LM/rzxHBV69lx5sLcXAYz2Nvx4QcASzr3RJmz9HHClLVsoJKQ==
X-Received: by 2002:a05:6870:4b4f:b0:14b:b6e2:c203 with SMTP id ls15-20020a0568704b4f00b0014bb6e2c203mr31861243oab.15.1673121144505;
        Sat, 07 Jan 2023 11:52:24 -0800 (PST)
Received: from localhost ([2600:1700:65a0:ab60:d403:a631:b9f0:eacb])
        by smtp.gmail.com with ESMTPSA id k8-20020a056870350800b001417f672787sm2047482oah.36.2023.01.07.11.52.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Jan 2023 11:52:24 -0800 (PST)
Date:   Sat, 7 Jan 2023 11:52:23 -0800
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     netdev@vger.kernel.org, g.nault@alphalink.fr,
        Cong Wang <cong.wang@bytedance.com>,
        syzbot+52866e24647f9a23403f@syzkaller.appspotmail.com,
        syzbot+94cc2a66fc228b23f360@syzkaller.appspotmail.com,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [Patch net 2/2] l2tp: close all race conditions in
 l2tp_tunnel_register()
Message-ID: <Y7nNdx1yDoEEPrwY@pop-os.localdomain>
References: <20230105191339.506839-1-xiyou.wangcong@gmail.com>
 <20230105191339.506839-3-xiyou.wangcong@gmail.com>
 <Y7m85XdeKwi9+Ytt@x130>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7m85XdeKwi9+Ytt@x130>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 07, 2023 at 10:41:41AM -0800, Saeed Mahameed wrote:
> On 05 Jan 11:13, Cong Wang wrote:
> > From: Cong Wang <cong.wang@bytedance.com>
> > 
> > The code in l2tp_tunnel_register() is racy in several ways:
> > 
> > 1. It modifies the tunnel socket _after_ publishing it.
> > 
> > 2. It calls setup_udp_tunnel_sock() on an existing socket without
> >   locking.
> > 
> > 3. It changes sock lock class on fly, which triggers many syzbot
> >   reports.
> > 
> > This patch amends all of them by moving socket initialization code
> > before publishing and under sock lock. As suggested by Jakub, the
> > l2tp lockdep class is not necessary as we can just switch to
> > bh_lock_sock_nested().
> > 
> > Fixes: 37159ef2c1ae ("l2tp: fix a lockdep splat")
> > Fixes: 6b9f34239b00 ("l2tp: fix races in tunnel creation")
> 
> This patch relies on the previous one which doesn't include any tags.
> If you are interested in this making it to -stable then maybe you need to
> add those tags to the previous commit ?
> 

But technically patch 1/2 does not fix anything alone, this is why I
heisitate to add any Fixes tag to it.

Since this is a patchset, I think maintainers can easily figure out this
is a whole set.

Thanks.
