Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1400D640412
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 11:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233016AbiLBKHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 05:07:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232068AbiLBKHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 05:07:09 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B2B31DFF;
        Fri,  2 Dec 2022 02:07:08 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id h4-20020a1c2104000000b003d0760654d3so4696289wmh.4;
        Fri, 02 Dec 2022 02:07:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lAa3hJppo/WCjU0fQNZHE/GMES32D4NEtcCS38fhV6k=;
        b=M8AhBwVKSD2KcvVRm4IPXCoeG36NL36s7PzGMw96pQhs2Dsz4R4OuRRymRuNv9mzvp
         KKAUal+dFEej+AQhzflGTMmXHhfp1acwf+6ljGPEkyIop81lycMM/hn8PEkKpUkBVr3u
         ZfWXtdXfe+DjFY1h5J7V9FX48K7ruRpPqnSijNoXNStM/QTbk63WlbmxgcQa3BqMVN1x
         q9aLDz2Cecdwb6C8IPEdwcf+xd4BHQgQOfdiol4Ji4SDrAa5nP+DAO3XNWxosU15LPVq
         gZRC2CCVg9p2icsaJT6cbqwPJDM+Gsy244qsmWN0f7l48cEQjG+ItkHB0Ga02Wu/ix/k
         KQRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lAa3hJppo/WCjU0fQNZHE/GMES32D4NEtcCS38fhV6k=;
        b=IFsTDXI/+4lr4lo/DTBALqaa6OtgiSt+mj4l8joqTbx6dLk5o4nTqfl+5zg8XdEdQn
         h5jWJr+1qSZSx7ocI6+2Eci9gc9EvKNdHZ0w0BunaaH6si26y+Y6znERWc+KPzL2UuX5
         qFcHNK36WU0dfefaE/U5w0SnnSfLfT3ZuP36Q6UXRsRGQZy64q61iMMXYOOIXp2zskU9
         ghqq9w3BgHCVDo9w5TZ/PMgwUYxjlONPl523ei89c0RJnGNHMs2mAY3vJsoYRm1BimGg
         e8iqM6+xVB9Og+k9x5EyZ1a7q7aZMUfqZ+iqqBG1xxzKUW+X5vivZCG/Squ3LOD5o/Lt
         xz+w==
X-Gm-Message-State: ANoB5pmc98eMypKUL/BdaKvKgjLYBbLhLGT8FyJbu7G4niRy35vKpUiM
        +8AEwf+ZS2342yXk25wowFI=
X-Google-Smtp-Source: AA0mqf6JN9UcErRqw1RX+MtISkloDSr0XVelCruFc28l+9eoUnnZFaooK84KGNmW3hETtQIOGHa5KA==
X-Received: by 2002:a05:600c:2213:b0:3cf:a6eb:3290 with SMTP id z19-20020a05600c221300b003cfa6eb3290mr45034149wml.116.1669975626845;
        Fri, 02 Dec 2022 02:07:06 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id bi18-20020a05600c3d9200b003c65c9a36dfsm7815781wmb.48.2022.12.02.02.07.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 02:07:06 -0800 (PST)
Date:   Fri, 2 Dec 2022 13:07:02 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Li Qiong <liqiong@nfschina.com>, Peilin Ye <yepeilin.cs@gmail.com>
Cc:     Simon Horman <horms@verge.net.au>, Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        coreteam@netfilter.org, Yu Zhe <yuzhe@nfschina.com>
Subject: Re: [PATCH] ipvs: initialize 'ret' variable in do_ip_vs_set_ctl()
Message-ID: <Y4nORiViTw0XlU2a@kadam>
References: <20221202032511.1435-1-liqiong@nfschina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221202032511.1435-1-liqiong@nfschina.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 02, 2022 at 11:25:11AM +0800, Li Qiong wrote:
> The 'ret' should need to be initialized to 0, in case
> return a uninitialized value because no default process
> for "switch (cmd)".
> 
> Signed-off-by: Li Qiong <liqiong@nfschina.com>

If this is a real bug, then it needs a fixes tag.  The fixes tag helps
us know whether to back port or not and it also helps in reviewing the
patch.  Also get_maintainer.pl will CC the person who introduced the
bug so they can review it.  They are normally the best person to review
their own code.

Here it would be:
Fixes: c5a8a8498eed ("ipvs: Fix uninit-value in do_ip_vs_set_ctl()")

Which is strange...  Also it suggest that the correct value is -EINVAL
and not 0.

The thing about uninitialized variable bugs is that Smatch and Clang
both warn about them so they tend to get reported pretty quick.
Apparently neither Nathan nor I sent forwarded this static checker
warning.  :/

regards,
dan carpenter
