Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1069D6E4770
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 14:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbjDQMTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 08:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbjDQMT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 08:19:27 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DEE046A4;
        Mon, 17 Apr 2023 05:19:21 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id u3so11577219ejj.12;
        Mon, 17 Apr 2023 05:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681733960; x=1684325960;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ala6pnVWRI+DISyg+Zfj6GT1Nc0i1dyOe1WIhGmL7jY=;
        b=BNzSOCzPWeoxnj/JLpp3hZglGHowRJ1iJiGstMZDhWc/awGw7sN9GxX1H8p/I7cClT
         wc7EPDLY8dfEK6hfigSpiz+IV6ptgfeQW5n0x9K9VL9LQENwpE1Axq6d49SPjWfrylfc
         BcNNMhM6HjHoYYfmUbmqZPaONMbw/9+5b7sQUOEyxf+nLj9emDuAVtXYBLiI1jvEUhRO
         ZX/u5ObxdAkGLWGLR/LyOC8Bmdaojpwx7BEjO7ShUHunSaFtSffxdnPD5wAuFzJPwgs9
         FOolhQKe3t9RJcksduvWrEefKLmHhfftBkujDPRq+sjyg/fkXJlyH+OQfO+QG83b4OAw
         2fqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681733960; x=1684325960;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ala6pnVWRI+DISyg+Zfj6GT1Nc0i1dyOe1WIhGmL7jY=;
        b=a77WOxKInn6hWsbt0osim16uKm26qaiNIq1MSbLrYOXdKmPIcevs4YVDPZu1hdlQNd
         vpQ4YTDaUYotu4JH3BVZhwX0t1UXgzidtCcELU6dPB3930yl9m7htEl7IFU+f5mzz0xZ
         MMrmWRBhA9UB1nJ/h1ZLNiFK+rIgATwKZASUZTIxnAF9c7WD4Fx/yhDsUy1hqHEVrEXg
         REl9/Jj42Xx7RjDlq5rYZBcF0HioYxXp2U38tCoM5aULb6KwBlYOfqHEnk9ewwsiutLK
         0Q/XZgC/64O13yj+LKA1/+xEJsjmM96pt6oQzF+7CJ3+eXIjXQPFgHz2bBNkX++uw1Ab
         fmrA==
X-Gm-Message-State: AAQBX9dEF5LnG+YLO3r+F6Pms8bDGOISFHyc6t0f9gk3bo9IxO/k3HRU
        m2UHoiO6Ep2E9KKtCj9DegA=
X-Google-Smtp-Source: AKy350bcG31fIZqNlJZTSZo/nH0fIjRaSQ+Aq9hFTF4IF2ue3ktDSHpAXiNLDSxSd/hfy5axh/FTVA==
X-Received: by 2002:a17:906:d101:b0:94e:c43f:316b with SMTP id b1-20020a170906d10100b0094ec43f316bmr7329496ejz.19.1681733959738;
        Mon, 17 Apr 2023 05:19:19 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id eq17-20020a170907291100b0094efe88a037sm4320883ejc.9.2023.04.17.05.19.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 05:19:19 -0700 (PDT)
Date:   Mon, 17 Apr 2023 15:19:17 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Petr Machata <petrm@nvidia.com>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, Eric Dumazet <edumazet@google.com>,
        kernel@pengutronix.de, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v1 2/2] net: dsa: microchip: Add partial ACL
 support for ksz9477 switches
Message-ID: <20230417121917.cfixzwoqds6wwlyu@skbuf>
References: <20230411172456.3003003-1-o.rempel@pengutronix.de>
 <20230411172456.3003003-1-o.rempel@pengutronix.de>
 <20230411172456.3003003-3-o.rempel@pengutronix.de>
 <20230411172456.3003003-3-o.rempel@pengutronix.de>
 <20230416165658.fuo7vwer7m7ulkg2@skbuf>
 <20230417045710.GB20350@pengutronix.de>
 <20230417101209.m5fhc7njeeomljkf@skbuf>
 <20230417110311.GA11474@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230417110311.GA11474@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 17, 2023 at 01:03:11PM +0200, Oleksij Rempel wrote:
> Certain aspects of the chip specification appeared ambiguous, leading me
> to decide to allocate a separate time slot for investigating the counter
> topic if necessary.
> 
> For example, according to the
> KSZ9477 4.4.18 ACCESS CONTROL LIST (ACL) FILTERING:
> 
> "It is also possible to configure the ACL table so that multiple processing
> entries specify the same action rule. In this way, the final matching result is
> the OR of the matching results from each of the multiple RuleSets.
> The 16 ACL rules represent an ordered list, with entry #0 having the highest
> priority and entry #15 having the lowest priority. All matching rules are
> evaluated. If there are multiple true match results and multiple corresponding
> actions, the highest priority (lowest numbered) of those actions will be the
> one taken."
> 
> A summary of this part of documentation is:
> 1. ACL table can have multiple entries specifying the same action rule.
> 2. Final matching result is the OR of multiple RuleSets' results.
> 3. 16 ACL rules form an ordered list, with priority descending from #0 to #15.
> 4. All matching rules are evaluated.
> 5. When multiple true matches and actions occur, the highest priority action is
>    executed.
> 
> Considering this, there is a possibility that separate action rules would not
> be executed, as they might not be the highest priority match.  Since counters
> would have separation action rules, they would not be executed or prevent other
> action rules from execution.
> 
> To confirm my hypothesis, additional time and testing will be required.
> Nonetheless, I hope this issue does not impede the progress of this patch.

This is the kind of stuff you'd have to know when adding a software model
for the rules, right? Could you consider writing a selftest that
precisely illustrates the matching pattern of the hardware? It would be
good if the same test could then be run on a software-only implementation
and if the behavior would match. The tc tool should be more than a
vendor agnostic tool of doing vendor specific stuff. It should offload
as faithfully as possible the software data path. It would also be good,
but I haven't studied or used this test personally, if the test could be
based on the existing tools/testing/selftests/net/forwarding/skbedit_priority.sh.

> > > > Have you considered the "skbedit priority" action as opposed to hw_tc?
> > > 
> > > I had already thought of that, but since bridging is offloaded in the HW
> > > no skbs are involved, i thought it will be confusing. Since tc-flower seems to
> > > already support hw_tc remapping, I decided to use it. I hope it will not harm,
> > > to use it for now as mandatory option and make it optional later if other
> > > actions are added, including skbedit.
> > 
> > Well, skbedit is offloadable, so in that sense, its behavior is defined
> > even when no skbs are involved. OTOH, skbedit also has a software data
> > path (sets skb->priority), as opposed to hw_tc, which last time I checked,
> > did not.
> 
> Alright, having tc rules be portable is certainly a benefit. I presume
> that in this situation, it's not an exclusive "either...or" choice. Both
> variants can coexist, and the skbedit action can be incorporated at a
> later time. Is that accurate?

I believe Petr Machata (now copied) could have an opinion here too.
