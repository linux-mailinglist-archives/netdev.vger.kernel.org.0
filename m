Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31DEC6447FC
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 16:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234213AbiLFP0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 10:26:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235053AbiLFP0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 10:26:40 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7126B12636;
        Tue,  6 Dec 2022 07:26:34 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id m19so20734465edj.8;
        Tue, 06 Dec 2022 07:26:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Tqp+rZqwBIbM0e7U8ET8WBjF4JT9ospITgGCw9GEAz4=;
        b=DhRpIWOmwJWg06s5+Y55Z62Y4TC+KzQtgMC7iZGL1lQnmpSgKwBuElQuNrhdnWV894
         e6w/mfu/JgsqlFoujbG/TIo89ZUToso4s2+pFaEWT6bfrtsPRm/psmCfdz5TIASFv5SC
         AN/I8t0IqgHypQNs8rT/M1ZckvyvOdWGNnbB0gxQDG75C+itVBM8GdKJnCEeA1RuKRWq
         LuNMkbX0pA44wOjKB7Gm5wsXsDRhaT3pw8S/ybNfz8nkznrszGyIfrC14JKpblBQdbVX
         dFWA8Ozos/acesVXHKZIzACM59NiHfqf+P9PYhGlgn+eqvvRoqagLIvdYgWQsyviE60P
         1qmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tqp+rZqwBIbM0e7U8ET8WBjF4JT9ospITgGCw9GEAz4=;
        b=PgthjwOouMLQBhAi43eV0VV4rvjDdukIkkxc2ZS0bv/aN44jgqb1fqmSBcGUwqxBDD
         /6qWbQJP3HkSLloifCZRFKwmOVrNLNI9Tsgjy9OvwA6e2Fn4m5bWFSxvWzSdBSdrNLdr
         qqKeYXl5nXaH19achb+YWwU+YZMfuArgSqKIjkTsfT0K5hrPa4+w3LSDQzdNwYBZWOOP
         SL4sB5pXpdMIrqRFmLQhyZfZxdbqyeHwNj+VSDCfFSRKK4i41TxHLcfncsAistSyRLjC
         CAbumayU/UQnmAtur2QS5sL3tSDe7yS7t1K07T3q4i3DPRzga/j17aZsSv8UIQbp/JQQ
         UZoQ==
X-Gm-Message-State: ANoB5pkcqZp4RSi5cVujc2KXhjYOsK7L3RMfZdd008q84kQIIuKgHw4Y
        QjoErgWHBmU6HtPyPaoYbAg=
X-Google-Smtp-Source: AA0mqf6IOsm1x+d+9JHFsfaOJNldbNQ5atFYHIoPKswFVa87oK26VKKFmgvywUz4QtBoyjB+LtpwcQ==
X-Received: by 2002:aa7:db13:0:b0:46b:aee1:3b46 with SMTP id t19-20020aa7db13000000b0046baee13b46mr4611443eds.44.1670340392963;
        Tue, 06 Dec 2022 07:26:32 -0800 (PST)
Received: from skbuf ([188.26.184.215])
        by smtp.gmail.com with ESMTPSA id g25-20020a056402115900b0046cbcc86bdesm1111496edw.7.2022.12.06.07.26.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 07:26:32 -0800 (PST)
Date:   Tue, 6 Dec 2022 17:26:30 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Radu Nicolae Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>
Cc:     gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, pabeni@redhat.com, kuba@kernel.org,
        edumazet@google.com, davem@davemloft.net, f.fainelli@gmail.com,
        Radu Pirea <radu-nicolae.pirea@nxp.com>
Subject: Re: [PATCH] net: dsa: sja1105: fix slab-out-of-bounds in
 sja1105_setup
Message-ID: <20221206152630.lypso2kbh6gwwlse@skbuf>
References: <20221206151136.802344-1-radu-nicolae.pirea@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206151136.802344-1-radu-nicolae.pirea@oss.nxp.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 05:11:36PM +0200, Radu Nicolae Pirea (OSS) wrote:
> From: Radu Pirea <radu-nicolae.pirea@nxp.com>
> 
> Fix slab-out-of-bounds in sja1105_setup.
> 
> Signed-off-by: Radu Pirea <radu-nicolae.pirea@nxp.com>
> ---
>  drivers/net/dsa/sja1105/sja1105_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Can be applied on top of 5.15.81 stable branch.

Here the backporting process has to work differently.

Since the fixed code is also present in the master branch of the tree
responsible with bug fixes for this code area
(https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git), you
have to base your patch on that tree, and send the patch to be applied
by the netdev maintainers, not by stable directly. You do that by using
git send-email --subject-prefix "PATCH v2 net". You also don't CC stable
and Greg, just the networking people from ./scripts/get_maintainer.pl.
After a while, the patch will land automatically in stable, through the
"net" tree.

You must also add this above your Signed-off-by tag:

Fixes: 38fbe91f2287 ("net: dsa: sja1105: configure the multicast policers, if present")
