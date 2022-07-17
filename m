Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8FF157774D
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 18:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232803AbiGQQZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 12:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiGQQZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 12:25:04 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86C0513CE6;
        Sun, 17 Jul 2022 09:25:03 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id a5so13756606wrx.12;
        Sun, 17 Jul 2022 09:25:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rwSneiH5xSNmTYynHVLLuzHsfAWoKgKKKN3H7FS7rMk=;
        b=Aa/n1738ntBuPAWlhWhRZjFLdhg8myxMR8iZ6ftlyCeOiQ/9YT8wiSQDcg0c7UVHIb
         2Zf+Xsi8VkZXPDEp01hK59xKVY+ZeOj4PS2UxKfYEv4K3yTRf9K2tX6EMzePC9j4jIKH
         KqE0qziR4v/rSbMbLc6LQsa3oLHRC90c3EkGtQFBzwWt46gIvb/hbxlvPS5EVjBA8Y6A
         oA+BKnFpc7syZFnPPTRyec4XOuVWoPrd0uyUJ4vobAUIhE09YyViry6TZxnnzAauydiz
         qsFW/1eGnCix7ZOzsUHc/RXx+Lpk23JF/BP9ido13S6OxIOCNapP3PBFdxuYeYy9NFdW
         2UuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rwSneiH5xSNmTYynHVLLuzHsfAWoKgKKKN3H7FS7rMk=;
        b=FdDQGPf5JD/zrbwFO3Kw9nRo7F+Wq0BPW0jaLz9/JIInHr0dJ085tUiO2p7Rj/4I+p
         dthNc8xGz73jjuQlVKoRC8puI4SRtFLtXyluGbAr3HM2LU3UuCA9D/jQaoepm626Ki+/
         cQZ3DwErbPJGVM8L0gwkMrZrxa6SbCjXmGjBk4XR/vAx78+63JebxV3ctArvvESet5su
         iAPlm+gqWX4zNEv65zLJM4QBAPm/rdDNTf/yOhNgvklt7qK3rTK6k0tn6wmTzYey3RS/
         Cbvx/4Z1F/AfGDIxEtKVnbXncXMJnDf6QaVr+jRjEmG19lZAL0icPtP292TgW4QM2w8Z
         yqdA==
X-Gm-Message-State: AJIora/8lpWZLT0Fz8fbB5XEORa/RNp2VWDC+MdEXwJkQP53tQc/6B2v
        EhWxF7PrFbYDDX6TK+YCPKVKhs+UYR3k8sy2g98=
X-Google-Smtp-Source: AGRyM1tKKG1DTxpJhgljLKjM1b0ZBI1n3j2cO/EQg0uio6SMOdiW6aawdpL2hUIf0EJQ/Yx0Ma8Z86scLN5oUYig9mY=
X-Received: by 2002:a5d:6a88:0:b0:21d:6ee4:1fb1 with SMTP id
 s8-20020a5d6a88000000b0021d6ee41fb1mr19575491wru.249.1658075102011; Sun, 17
 Jul 2022 09:25:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220630111634.610320-1-hans@kapio-technology.com>
 <Yr2LFI1dx6Oc7QBo@shredder> <CAKUejP6LTFuw7d_1C18VvxXDuYaboD-PvSkk_ANSFjjfhyDGkg@mail.gmail.com>
 <Yr778K/7L7Wqwws2@shredder> <CAKUejP5w0Dn8y9gyDryNYy7LOUytqZsG+qqqC8JhRcvyC13=hQ@mail.gmail.com>
 <20220717134610.k3nw6mam256yxj37@skbuf> <20220717140325.p5ox5mhqedbyyiz4@skbuf>
In-Reply-To: <20220717140325.p5ox5mhqedbyyiz4@skbuf>
From:   Hans S <schultz.hans@gmail.com>
Date:   Sun, 17 Jul 2022 18:22:57 +0200
Message-ID: <CAKUejP6g3HxS=Scj-2yhsQRJApxnq1e31Nkcc995s7gzfMJOew@mail.gmail.com>
Subject: Re: [PATCH net-next v1 1/1] net: bridge: ensure that link-local
 traffic cannot unlock a locked port
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Ido Schimmel <idosch@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 17, 2022 at 4:03 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Sun, Jul 17, 2022 at 04:46:10PM +0300, Vladimir Oltean wrote:
> > Here, what happens is that a locked port learns the MAC SA from the
> > traffic it didn't drop, i.e. link-local. In other words, the bridge
> > behaves as expected and instructed: +locked +learning will cause just
> > that. It's the administrator's fault for not disabling learning.
> > It's also the mv88e6xxx driver's fault for not validating the "locked" +
> > "learning" brport flag *combination* until it properly supports "+locked
> > +learning" (the feature you are currently working on).
> >
> > I'm still confused why we don't just say that "+locked -learning" means
> > plain 802.1X, "+locked +learning" means MAB where we learn locked FDB entries.
>
> Or is it the problem that a "+locked +learning" bridge port will learn
> MAC SA from link-local traffic, but it will create FDB entries without
> the locked flag while doing so? The mv88e6xxx driver should react to the
> 'locked' flag from both directions (ADD_TO_DEVICE too, not just ADD_TO_BRIDGE).

Yes, it creates an FDB entry in the bridge without the locked flag
set, and sends an ADD_TO_DEVICE notice with it.
And furthermore link-local packets include of course EAPOL packets, so
that's why +learning is a problem.
