Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE9967668D
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 14:35:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbjAUNf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Jan 2023 08:35:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbjAUNfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Jan 2023 08:35:55 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AC2349426;
        Sat, 21 Jan 2023 05:35:54 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id az20so20426528ejc.1;
        Sat, 21 Jan 2023 05:35:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z4YcSrMX/G5vP45y4HfVQg5h76ReOicUsuhYXyLi4UM=;
        b=jloDOGfndeuHEZxorJIwmvQ6L+AiemwBGczaRnr41DRAjQG2j38Fi10rAMziWmYTqd
         xbY4/wAkeP4stBfqV2UO1T/d7BDq9oZXl2qLUrZ9DcW1xiagrLbdOzolPWWDNlQJ9OLX
         kuKQKXm0I4QTxokTyShw6/S3aDPyqM2QJj8ROqCTEqL7NuE52SNbZyuOd/Qv34vbDH4h
         NoSIWlB3tJ+wL2Ss9NMpCwukvdEfj2HaMrPRP2UcIjstSD0CFOYV9V7zazSE/BvIHTE4
         R/u/eD93slmsPVS0SaNgRmsKsbM8RyFn7+4BVV7YYPDLA4OcJz7DYhv6UW9POvaZdM1W
         w5UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z4YcSrMX/G5vP45y4HfVQg5h76ReOicUsuhYXyLi4UM=;
        b=CQu8RUTEzpSb4zu2dH9OAeDevSGRMfnq3dfCE51EkjrPcF6Kg4JUJntGeazasOEwkr
         CDbbZAGiazoNo//DgQ9z7Z9Xq4obtBi2XH7SBc++nYplqMLZOzkAmcWJ2zdM41vnYOvk
         s0NvbQYuHooL+1/ecLF7lm3zXyUU9TiOFRa8HWvKcEcyvXUEyo2xEw8f7fxZw1QO+3G6
         kiMx//w1THWf5c9JmSfsmPV5eAe6itWfkiDnPly5jqD1SQsLtjzcR3LXzRujbMCvndqd
         cg48musnsSMg6d/nNr9bGMZERdUacRXqiYO8eKtDzEJHSgaw88oiuyolfDkE7KkTHWM8
         tC2w==
X-Gm-Message-State: AFqh2kqMVJOvjDQ1HbzoHqdDvjf6P4y5Kc3szO8LOMea+hZCfI8GXUjF
        uhwy5rEBzkMWs8zM4Nk5uoQ=
X-Google-Smtp-Source: AMrXdXsPpai+v7vXEdVZk4hFPRkJ6JsEZRPcBoIrNVqKXxgikg3WGoLXEh7W648s8JrWjE/pxGYQvQ==
X-Received: by 2002:a17:906:8e0a:b0:7c1:1444:da41 with SMTP id rx10-20020a1709068e0a00b007c11444da41mr34521652ejc.40.1674308152684;
        Sat, 21 Jan 2023 05:35:52 -0800 (PST)
Received: from skbuf ([188.27.185.42])
        by smtp.gmail.com with ESMTPSA id et21-20020a170907295500b00871f66bf354sm7695559ejc.204.2023.01.21.05.35.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Jan 2023 05:35:52 -0800 (PST)
Date:   Sat, 21 Jan 2023 15:35:49 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>
Subject: Re: [BUG] vlan-aware bridge breaks vlan on another port on same gmac
Message-ID: <20230121133549.vibz2infg5jwupdc@skbuf>
References: <trinity-e6294d28-636c-4c40-bb8b-b523521b00be-1674233135062@3c-app-gmx-bs36>
 <20230120172132.rfo3kf4fmkxtw4cl@skbuf>
 <trinity-b0df6ff8-cceb-4aa5-a26f-41bc04dc289c-1674303103108@3c-app-gmx-bap60>
 <20230121122223.3kfcwxqtqm3b6po5@skbuf>
 <trinity-7c2af652-d3f8-4086-ba12-85cd18cd6a1a-1674304362789@3c-app-gmx-bap60>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <trinity-7c2af652-d3f8-4086-ba12-85cd18cd6a1a-1674304362789@3c-app-gmx-bap60>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 21, 2023 at 01:32:42PM +0100, Frank Wunderlich wrote:
> so first patch fixes the behaviour on bpi-r3 (mt7531)...but maybe mt7530 need the tagging on cpu-port
> 
> > Can you try the second patch instead of the first one? Without digging
> > deeply into mt7530 hardware docs, that's the best chance of making
> > things work without changing how the hardware operates.
> 
> second patch works for wan, but vlan on bridge is broken, no packets receiving my laptop (also no untagged ones).

It's hard for me to understand how applying only patch "tag_mtk only
combine VLAN tag with MTK tag is user port is VLAN aware" can produce
the results you describe... For packets sent to port lan0, nothing
should have been changed by that patch, because dsa_port_is_vlan_filtering(dp)
should return true.

If you can confirm there isn't any mistake in the testing procedure,
I'll take a look later today at the hardware documentation and try to
figure out why the CPU port is configured the way it is.
