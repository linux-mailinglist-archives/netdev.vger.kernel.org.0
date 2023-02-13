Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97E88694766
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 14:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbjBMNs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 08:48:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230386AbjBMNsU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 08:48:20 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 880391B55E;
        Mon, 13 Feb 2023 05:48:15 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id lf10so138203ejc.5;
        Mon, 13 Feb 2023 05:48:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Qgkug+k8MRaxvHhyz3g02hyZ9Wk5TRp+jzL8m6fkolU=;
        b=aFReOqTaY+PNWxTCkXEX9L2yJFY2wYUQS3onqFLxO4eHmQlpEe739GJAOZZvG+XmD4
         6j05mv3s29lex83RMuu/JfNoWTnCHRCnW8e0U7XX6vELTmZMBquw2w9gWDGplQNSWttG
         2xuiLL2m2Vh6uKrywztokGukEPEshujd4uxw9uJ9wQiw/zd/pm1GM9ROwmmxgyxs/ilR
         1eJRQrBhEbAcKLqlwiY6xWN/zmsl5tXfRiKjgd2VnOjuUei1SfALBHDWhVNhLNRIgivj
         dtIXSRgE6Tx/oBv0+VojlMH2PvFARwW0DzS9sAgY5pQ0xCjCV3u9SAFuY5CUIK3rQzr7
         bjAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qgkug+k8MRaxvHhyz3g02hyZ9Wk5TRp+jzL8m6fkolU=;
        b=eb/GT+TzzvnX23PIfPB3xPEKXuM6MJyQGfPkBHzedEV8bwbqfV0jjzUkVdH73W5wd1
         xDlvcWpQUsHPFY67r4/8NefuTiWJ2nfo5lxgWHA2kF15lHQoOJsa+V7dvwN3gTd3WfxF
         8PagpmeCda0w/KuaMe6V4BUKrSzSjgS9+oLQO4AjQJMEnmejnTQUCtqYj/R/MbULhkz7
         pcE3FDTyOSRWG3m6D1Iwa7cMivB58nki7yssZtfMfq/U2uyeTkrGRjMz+FusO4F0iBQX
         YSEMFEFgS5rZYwY1+o01xykKLNZ6e6DlEjtCXmLWWz54IumTCNjv1TeRF7Ih5lWFsUVC
         AVLA==
X-Gm-Message-State: AO0yUKUaD6UPw6oHAZvTgyINkLNvwMRgVtLB3lwycQzA4dVAiyNmCCEf
        18flOmTH/32kbOeTkqOepLM=
X-Google-Smtp-Source: AK7set/SAf7iUOkmXApeTAGnEkgtW3PQL2Pg3Htd7kEadyL0tpNbDVsHhXAm2dhe6neJvnEoIoapBg==
X-Received: by 2002:a17:906:1515:b0:879:ab3:93cd with SMTP id b21-20020a170906151500b008790ab393cdmr24935089ejd.46.1676296094005;
        Mon, 13 Feb 2023 05:48:14 -0800 (PST)
Received: from skbuf ([188.26.185.183])
        by smtp.gmail.com with ESMTPSA id b12-20020a170906038c00b0088f464ac276sm6739560eja.30.2023.02.13.05.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 05:48:13 -0800 (PST)
Date:   Mon, 13 Feb 2023 15:48:11 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Richard van Schagen <richard@routerhints.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Arinc Unal <arinc.unal@arinc9.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH] Fix Flooding: Disable by default on User ports and
 Enable on CPU ports
Message-ID: <20230213134811.elcgnzfryyxxegau@skbuf>
References: <20230212214027.672501-1-richard@routerhints.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230212214027.672501-1-richard@routerhints.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NACK.
- the change needs to be localized to the file it touches by specifying the
  "net: dsa: mt7530: " prefix.
- the rest of the 80-character short commit message needs to be a well
  summarized description of the change.
- any time the "fix", "broken", etc words are used, a description of the
  breakage is expected, and its projected impact upon users of the driver
- patches which solve a bug must have a Fixes: tag pointing to the patch
  that introduced the problem
- if that patch being fixed is in the mainline kernel already, the
  --subject-prefix of the patch must be "PATCH net", otherwise "PATCH
  net-next". These correspond to the net.git and net-next.git trees.
- your signed-off tag is missing
- maybe more problems
