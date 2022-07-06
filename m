Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC0275689F6
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 15:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233010AbiGFNsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 09:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233467AbiGFNsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 09:48:30 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C88EABF1;
        Wed,  6 Jul 2022 06:48:28 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id h17so9013049wrx.0;
        Wed, 06 Jul 2022 06:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7VGDIlKV6gAV8St0jIFraWnG2EvF6VYrYLOYj9aX/Sc=;
        b=GmdcHEVeVUWW4yGaLtIyHZprjnISw5pW33LwCwJJ7/fDA6Hcfxby9OeEN4idkGEUJr
         tlORqJvsztOQN74ymQ3E4sWlPqW/6bsqHfxN0YB8ADgv1BjiKCRCjYDOh7lZQBb3Tgl5
         BdUozqnyBMsdWXGwJFWBmb35kvsmDF2WLkvQp9mRsWZPmu6EbUWcypm8pcp2H715FnU4
         ipRQuQXENffTeeb6WWoDToEU9RkLs53PtRT5L1YrX7g0bef34vYKUzk1UcPVf5OSAeT5
         XYbuV7KUIBSkcnstqa0uuwHszYv7gMD72sraYPrXUBZl/08SljwdSVHfeHp5mJ+welFO
         bGEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7VGDIlKV6gAV8St0jIFraWnG2EvF6VYrYLOYj9aX/Sc=;
        b=4SGArS9OC4LziXmsCsYGBgdBut5nCJLRneBTOep1W7bemhUtqfIXrekVF67eIirlnl
         GGLZaa5QLfz07mIiFg03Zo69c42rKFquZpchF6qqqAD+Dl6igxNKpCHcp8jr3GIUkC9v
         9x+jgKQ30wRklijN3fRNF03YA1/kFHmeOJ/ctjTU8/PJAHlVwI4IFJP8kCairBzNHU4k
         n3rjdd6EpcwSZBdOCEvPoyxWllYdm899foiwhOZZP4kaM7+SuxB045F738yXyqQRc2TV
         uF75t1EIMcSLKebub7a61VRGAfF1sl504bbiIBptTUq9TG8AY6+LQFGsNkRf08BhjTPG
         5jig==
X-Gm-Message-State: AJIora+rB9gU/Ub/Zqaq0Ru4H+PBZ1X7Os2KqIhodVOtQqoAp0U3/2rj
        HDZ4UsbHFpQD1afYGZpnT48TnQ6xwuXsYfhKSSo=
X-Google-Smtp-Source: AGRyM1ts1iVFzqxNpdFOtNBXP9pYfOs+b0mF015rNdoOcHmF9GTVipUoZ3vq1ks20WVLwoAkcEDLb99UfUxDajaENIY=
X-Received: by 2002:a5d:658d:0:b0:21d:6e90:c2ed with SMTP id
 q13-20020a5d658d000000b0021d6e90c2edmr11899137wru.113.1657115307223; Wed, 06
 Jul 2022 06:48:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220524152144.40527-1-schultz.hans+netdev@gmail.com>
 <20220524152144.40527-4-schultz.hans+netdev@gmail.com> <20220627180557.xnxud7d6ol22lexb@skbuf>
 <CAKUejP7ugMB9d3MVX3m9Brw12_ocFoT+nuJJucYdQH70kzC7=w@mail.gmail.com>
 <CAKUejP5u9rrH8tODODG0a1PLXfLhk7NLe5LUYkefkbs15uU=BQ@mail.gmail.com> <20220706132834.rdw7mmpbwt55kt4r@skbuf>
In-Reply-To: <20220706132834.rdw7mmpbwt55kt4r@skbuf>
From:   Hans S <schultz.hans@gmail.com>
Date:   Wed, 6 Jul 2022 15:48:16 +0200
Message-ID: <CAKUejP7DjCoEjyzGWs4ZQF3_gfy6tBhCYs+H9Ja7hXcFw09qww@mail.gmail.com>
Subject: Re: [PATCH V3 net-next 3/4] net: dsa: mv88e6xxx: mac-auth/MAB implementation
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
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
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 6, 2022 at 3:28 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Tue, Jul 05, 2022 at 05:05:52PM +0200, Hans S wrote:
> > Hi, does anybody know what it going on with this variable?
> > struct dsa_port *dp ->ageing_time;
> >
> > I experience that it changes value like a factor ~10 at times.
>
> Could you be a bit more specific? Are you talking about STP Topology
> Change Notification BPDUs, which trigger this code path?
>
> diff --git a/net/bridge/br_stp.c b/net/bridge/br_stp.c
> index 7d27b2e6038f..9b25bc2dcb3e 100644
> --- a/net/bridge/br_stp.c
> +++ b/net/bridge/br_stp.c
> @@ -671,10 +671,10 @@ void __br_set_topology_change(struct net_bridge *br, unsigned char val)
>
>                 if (val) {
>                         t = 2 * br->forward_delay;
> -                       br_debug(br, "decreasing ageing time to %lu\n", t);
> +                       br_info(br, "decreasing ageing time to %lu\n", t);
>                 } else {
>                         t = br->bridge_ageing_time;
> -                       br_debug(br, "restoring ageing time to %lu\n", t);
> +                       br_info(br, "restoring ageing time to %lu\n", t);
>                 }
>
>                 err = __set_ageing_time(br->dev, t);
>
> Coincidentally the default values of 2 * br->forward_delay and br->bridge_ageing_time
> are 1 order of magnitude apart from each other.
>
> [  139.998310] br0: topology change detected, propagating
> [  140.003490] br0: decreasing ageing time to 3000
> [  175.193054] br0: restoring ageing time to 30000
>
> What's the problem anyway?

It might be a topology change as you indicate, though I am not sure.
So I am not using that variable any more for determining the ageing
time for the locked FDB entries, but instead I have made a function to
read the time from the chip instead.

The problem with that, I have mentioned in my latest reply to the
mac-auth patch set...
