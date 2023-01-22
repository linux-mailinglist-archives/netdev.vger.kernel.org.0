Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDC9676D11
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 14:13:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbjAVNLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 08:11:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjAVNLF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 08:11:05 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0C9E1557C
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 05:11:02 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id az20so24390648ejc.1
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 05:11:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rfrj/yWVqfB1MwmDOElhvJKYnmfLcyJ/3uBsa2bwsHc=;
        b=QtaOanI2pZwId3KgxPT6j9Jy8yCb5DhVuaLUjF1XDZtOtIGl+Lg8EZy19hHbwBcflb
         dPp0k8gNVAX9kO6SngFOQiBwGhEpTdvDXtNLHoT9y2Ng6PkBYe/5vzJT5AIKO9eVRv5Y
         GSGf02KwYN6XhOsRBb+07+rDth51WW16FOLDyNvQlxbN7Cae7Yl/OGIbWO3ycOQBaA44
         +U2/VCi1WX9bmqTR8QlH3a6jdWfFPwf498cg1+DU1mLn50l292NXFH/9cEiYiPmVDIJN
         XIQnu6igtOO/zsGoag6Ag9bwkzJc9Ylb9XmVzvd9Fd9K92g2Sgwk/nT5+1c50LlRS9A3
         udAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rfrj/yWVqfB1MwmDOElhvJKYnmfLcyJ/3uBsa2bwsHc=;
        b=TYYxqvsFaQZx1IQYwl9fZSxcdRl5LQyk4xhfKtykkMvwK9YD8VD5uY1ibNLb7b//yy
         XAyrypmXagwZVIu1z47tXz4ZAZNvOgER3716yGdHK4jhV0LRgYlY8fq3ApDbFFsJSaNh
         /ofTY8V8oIY4eRfIQZjxrx8IeShLevd+fgcYHaJ4Cso/n8kchaxJ28GGBewePSHoBnUJ
         rDvvWJqLMdyjkmzZOyineG2wnCMCEB86eOlyYsFPIOeDArqwOyVg6tVAqfCaJFclie7I
         X1ckQfpJNnH+LOsFQniYzPU9MhxhNM+qpfLXh+/lUiBUNFS5AlyLMWhD5scMxwKLmZJw
         Q11A==
X-Gm-Message-State: AFqh2kpBgt41xfX+wiwESgKfaJxqfNj/FgPQNzXVfFjsw70MUzVlyciL
        MFU6dXAKzxvROtZ1ie7VrmhhsfXN02agSQ==
X-Google-Smtp-Source: AMrXdXvkyYWvkvcPtOPkUKwZHPp9o3xICRvdxnGuJA+tHsQUXLD0Tpu4gmJjC+7Mr2lF4yF+eUQsHw==
X-Received: by 2002:a17:906:354d:b0:85c:dc1b:dfb0 with SMTP id s13-20020a170906354d00b0085cdc1bdfb0mr22560558eja.47.1674393061248;
        Sun, 22 Jan 2023 05:11:01 -0800 (PST)
Received: from skbuf ([188.25.254.227])
        by smtp.gmail.com with ESMTPSA id b2-20020a1709063ca200b00877a0ebccc0sm3652081ejh.125.2023.01.22.05.11.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Jan 2023 05:11:00 -0800 (PST)
Date:   Sun, 22 Jan 2023 15:10:58 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Aaron Thompson <dev@aaront.org>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>, netdev@vger.kernel.org
Subject: Re: mv88e6xxx assisted learning on CPU port
Message-ID: <20230122131058.n4b2jejecksane3j@skbuf>
References: <01000185d7afea8b-cdad9c75-b82b-456e-80c1-ce62d6afe761-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01000185d7afea8b-cdad9c75-b82b-456e-80c1-ce62d6afe761-000000@email.amazonses.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 22, 2023 at 04:15:08AM +0000, Aaron Thompson wrote:
> Hi Tobias, Vladimir, et al.,
> 
> Just a quick question: Is there a reason why the patch to enable
> assisted_learning_on_cpu_port for mv88e6xxx never made it to mainline? It
> was included in this RFC series:
> 
> https://lore.kernel.org/all/20210224114350.2791260-14-olteanv@gmail.com/
> 
> But not in the series that eventually made it to mainline. In my searching
> on lore, I haven't been able to find anything else about it, yea or nay.
> 
> Thanks,
> -- Aaron

Because since commit ce5df6894a57 ("net: dsa: mv88e6xxx: map virtual
bridges with forwarding offload in the PVT"), the mv88e6xxx driver
supports a more potent feature (bridge TX forwarding offload), which
sends packets from software to the switch in a way in which the switch
can automatically learn their MAC SA + VLAN ID, among other benefits.
More details can be found here:
https://www.kernel.org/doc/html/latest/networking/dsa/dsa.html#bridge-layer
