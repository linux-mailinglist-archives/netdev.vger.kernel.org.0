Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1294A8F94
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 22:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237726AbiBCVIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 16:08:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240624AbiBCVIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 16:08:39 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 152BFC061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 13:08:39 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id c194so3237019pfb.12
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 13:08:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=e7F96jPx4YyudImtYpzXWJgKTFEs9blUunAZh2t7hH4=;
        b=eWsju9QIMmbr8rvzJQMXPJWkMZhpnrsC64WDh1kOAG/6ZuUyebtGmn9m4REv+Jdh7e
         f2aliZvB0Vatbm/Mls3el6d7hiEusCDfB22M5LJLdTgMapD60qJ/H/TURPny7XMRKObJ
         xh7pslzzsP1XAy24J1L/0DSmBHfSgApY9yVr4XleuBefDuBxq1wy0TQPiycWyoKsOgZi
         Bdk/DoLwCarzLXVkm7724YvCqaFoAIxHoiw4AEmpXOxt5HvIozXR8Y1pn8tZ57FH3L+C
         LFKHvTYtVGSjvYcWRky1uA/vulbj8GjJ8P1PSyCLYPhguItUIEdVC1ohVCm8AGt8M3fT
         IYog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=e7F96jPx4YyudImtYpzXWJgKTFEs9blUunAZh2t7hH4=;
        b=ZREuYVyYBP9RX7urWSdM0qxxZDpfFJCTWqBIDoLY+R3uY0QwPNEOsynGfcwKls1pLb
         ct5N2v72zeWZYrSd+efkDEEJVnSAcHQ+QyUPMLY4w6L4kj0V15xEmcEyoe1V3++hRJRz
         YRygCZ06jpjNX2bUHoGfRFDwQ7V6uCH+zHnvbWj3tPgYx4Gx8FS95hNLFZdAPlWMd2HG
         c4hZYsVwIjOys4vgFvjNWdS4kQze2mIiHHwTfG4e8KnGtAAngMh+UhcFP4u4TZRFrIww
         2VsvhT3/iIuL8tRd1CLXPhuLJvPXF0kz1TfxOeerL2fpB9tVQX7vh06kpnHpRAtIGYkw
         0reg==
X-Gm-Message-State: AOAM530di1A9Xk4kfAlM5aOK+jE43/n4Fje2W4+1q1/07Xn7V/6N1aEp
        t7TVVjBc1FdblTztky8SNWkNKG6z3sYr/Q==
X-Google-Smtp-Source: ABdhPJzboxgiPNtLroSj1EhfbS/12Dqc8nwJYkxsiH8eB8WLMQJHGqOo6sTFjF2wlvfR4NDzHhID9g==
X-Received: by 2002:a63:1655:: with SMTP id 21mr29315704pgw.498.1643922517771;
        Thu, 03 Feb 2022 13:08:37 -0800 (PST)
Received: from ?IPv6:2001:470:b:9c3:82ee:73ff:fe41:9a02? ([2001:470:b:9c3:82ee:73ff:fe41:9a02])
        by smtp.googlemail.com with ESMTPSA id bj7sm10402553pjb.9.2022.02.03.13.08.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 13:08:37 -0800 (PST)
Message-ID: <802be507c28b9c1815e6431e604964b79070cd40.camel@gmail.com>
Subject: Re: [PATCH net-next 05/15] ipv6/gso: remove temporary HBH/jumbo
 header
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>
Date:   Thu, 03 Feb 2022 13:08:36 -0800
In-Reply-To: <CANn89iKzDxLHTVTcu=y_DZgdTHk5w1tv7uycL27aK1joPYbasA@mail.gmail.com>
References: <20220203015140.3022854-1-eric.dumazet@gmail.com>
         <20220203015140.3022854-6-eric.dumazet@gmail.com>
         <0d3cbdeee93fe7b72f3cdfc07fd364244d3f4f47.camel@gmail.com>
         <CANn89iK7snFJ2GQ6cuDc2t4LC-Ufzki5TaQrLwDOWE8qDyYATQ@mail.gmail.com>
         <CAKgT0UfWd2PyOhVht8ZMpRf1wpVwnJbXxxT68M-hYK9QRZuz2w@mail.gmail.com>
         <CANn89iKzDxLHTVTcu=y_DZgdTHk5w1tv7uycL27aK1joPYbasA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-2.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-02-03 at 11:59 -0800, Eric Dumazet wrote:
> On Thu, Feb 3, 2022 at 11:45 AM Alexander Duyck
> <alexander.duyck@gmail.com> wrote:
> 
> > It is the fact that you are adding IPv6 specific code to the
> > net/core/skbuff.c block here. Logically speaking if you are adding the
> > header in ipv6_gro_receive then it really seems li:ke the logic to
> > remove the header really belongs in ipv6_gso_segment. I suppose this
> > is an attempt to optimize it though, since normally updates to the
> > header are done after segmentation instead of before.
> 
> Right, doing this at the top level means we do the thing once only,
> instead of 45 times if the skb has 45 segments.

I'm just wondering if there is a way for us to do it in
ipv6_gso_segment directly instead though. With this we essentially end
up having to free the skb if the segmentation fails anyway since it
won't be able to go out on the wire.

If we assume the stack will successfully segment the frame then it
might make sense to just take care of the hop-by-hop header before we
start processing the L4 protocol.


