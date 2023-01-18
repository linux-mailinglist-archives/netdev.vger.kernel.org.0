Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E843672988
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 21:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbjARUhu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 15:37:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbjARUhs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 15:37:48 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E69127488;
        Wed, 18 Jan 2023 12:37:47 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id mp20so235240ejc.7;
        Wed, 18 Jan 2023 12:37:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8/LiTJJ5Qi/26ASTQ+c/zGl/U5Nymj3a07/CAG0OPfY=;
        b=TXCevLNwZcQj/I2OpK5l4DOQBtD/f3us9DQrt+Lf5X5gUMU/TQ0RTT3wiLXOM6md9S
         2zSbXGfVxCO4qlFDFqYi0XCOM3VzFmZzY1MZaOYhxQvT1JneRxBP1ApmLPKliZYHTdm4
         RQ3E0tpmN4eHbzfLFaBMmN7J0ULykcQIqNsEXj6gWn2ZDC/EKaPElA5saeSsxOBlD973
         HGkQqo2ptrizkqbrxy377++TqJgAyqx/Qy4QiY+eC2sBmOmvcSYNgFYp6hhcwVU7hhe4
         5G00dnZRftIJ/Vjt2o1z+SMKskUFezBiZ8XnbmeMbzcG8NruKeYm6ajwP41oFEQwx+IX
         slRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8/LiTJJ5Qi/26ASTQ+c/zGl/U5Nymj3a07/CAG0OPfY=;
        b=O/+CpQKbwFqXv569TugBUQ6WTfXKI358QuBGJbQR+h8vu/8K3Sf/7VD9Hv023aTarY
         6r9nU6zsWsryZVsgYwtlTnUDMmRfkb6jW37X/lseyVPjASYT8m1Nyd+UZfDPrg3NTFj/
         If6Ydorf5kGbok8HYrEHJZn0JlTh+gr9NAjgoB13CWERwmiUkZP/PMYS/e/4pzw+zrwx
         kiMKpdLRPoTNtzDEL1mwDNnb/FT8raaXscJD7pYWxEgDX7Is16/MqS+CjxU03REXlezb
         MqK3OCOXAjizknoKmBHBL9kLBhk76Na41aHLxLJSzCIDpoLELzi5PtHI3zfMurkBjojf
         m94A==
X-Gm-Message-State: AFqh2kotsYw7/TAzbkbQVgRr4kj02ppwKp3XznvNvBqGC7VwABBbL9hO
        ONoFjyqG6yLcwLoNRHfuqDg=
X-Google-Smtp-Source: AMrXdXvlYZqesdp0Vhg9EyVhdwpJOrD8La+FHd23Y3om4qGjRWSbBFUtVDe9fqJnOA1NW35dVSiSEw==
X-Received: by 2002:a17:907:8a07:b0:7c1:5ee1:4c57 with SMTP id sc7-20020a1709078a0700b007c15ee14c57mr9750521ejc.8.1674074265823;
        Wed, 18 Jan 2023 12:37:45 -0800 (PST)
Received: from localhost ([91.92.109.126])
        by smtp.gmail.com with ESMTPSA id a11-20020aa7d74b000000b0049e08f781e3sm4986036eds.3.2023.01.18.12.37.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 12:37:44 -0800 (PST)
Date:   Wed, 18 Jan 2023 22:37:41 +0200
From:   Maxim Mikityanskiy <maxtram95@gmail.com>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, sgoutham@marvell.com, lcherian@marvell.com,
        gakula@marvell.com, jerinj@marvell.com, sbhatta@marvell.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        saeedm@nvidia.com, richardcochran@gmail.com, tariqt@nvidia.com,
        linux-rdma@vger.kernel.org
Subject: Re: [net-next Patch v2 4/5] octeontx2-pf: Add devlink support to
 configure TL1 RR_PRIO
Message-ID: <Y8hYlYk/7FfGdfy8@mail.gmail.com>
References: <20230118105107.9516-1-hkelam@marvell.com>
 <20230118105107.9516-5-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230118105107.9516-5-hkelam@marvell.com>
X-Spam-Status: No, score=1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 18, 2023 at 04:21:06PM +0530, Hariprasad Kelam wrote:
> All VFs and PF netdev shares same TL1 schedular, each interface
> PF or VF will have different TL2 schedulars having same parent
> TL1. The TL1 RR_PRIO value is static and PF/VFs use the same value
> to configure its TL2 node priority in case of DWRR children.
> 
> This patch adds support to configure TL1 RR_PRIO value using devlink.
> The TL1 RR_PRIO can be configured for each PF. The VFs are not allowed
> to configure TL1 RR_PRIO value. The VFs can get the RR_PRIO value from
> the mailbox NIX_TXSCH_ALLOC response parameter aggr_lvl_rr_prio.

I asked this question under v1, but didn't get an answer, could you shed
some light?

"Could you please elaborate how these priorities of Transmit Levels are
related to HTB priorities? I don't seem to understand why something has
to be configured with devlink in addition to HTB.

Also, what do MDQ and SMQ abbreviations mean?"

BTW, why did you remove the paragraphs with an example and a limitation?
I think they are pretty useful.

Another question unanswered under v1 was:

"Is there any technical difficulty or hardware limitation preventing from
implementing modifications?" (TC_HTB_NODE_MODIFY)
