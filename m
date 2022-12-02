Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F44D640476
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 11:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233325AbiLBKUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 05:20:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233311AbiLBKUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 05:20:49 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04F94CCFE7;
        Fri,  2 Dec 2022 02:20:48 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id o7-20020a05600c510700b003cffc0b3374so3920962wms.0;
        Fri, 02 Dec 2022 02:20:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=p6dyIRGKkenZuKAINhAGNO77xEpLnPrYIwb9Q02NvIA=;
        b=B/nAOmgOONNgs8ZuxTFGjlAAvNS9u/x6HN2unp1OEEjs2XWWtmxqS13rOghKfV9F3m
         NiVMoAkn6tg0493G19w6tQCYqlkAWKlTXDERT9E1C1fp9x9cJy+g4Ru3e+r48DqYvapR
         t6tmk5o+zYhhAHwWZUQ5MhXmPfAVpHWYOwfcB5vt2MwjwHSadjJO5j4xRtRVx2jR/f6R
         Jis9RtSlh0o3dqwlPiBlkf6ZunO3ov1LeKJr1izbF4wR0vm/eGiNgd0vpKMyM7j95V7i
         2vhcxnUlPBHLhoMkXBQPb4OSUzkRk9vzCig+4ciRzW5CyIHzucBID1pxaEun7GhwdwYH
         Y/YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p6dyIRGKkenZuKAINhAGNO77xEpLnPrYIwb9Q02NvIA=;
        b=Z4MJiXWfGnk2PcMxhBPXf/mJZNiqYJnxdc/fK/ZmStkeXMmO+cWLnwXJMYihTJr0+k
         UeoesyrKGSVr+1Y08tDXm4csKEwfrNv0+RwYiX6l9RAEhBqphz9R8gQOKYRolFn4tevV
         OzNI9cb9JHk4SqW8dqQE4uBY+EXTQV3J+RLa3M85Acq3KmdVekm+kpTUhIl1d3pFM9F2
         x89aOA5JFHuAc3dwdQ+fnSuLphKvsi1AApkqK2bbfjRmX+OQqcS855VYauSRTR0B2bdh
         8p8YNS4H3cNZXeghTYdASmLxAPQNPRNxtDPNJLQHnidLYeDOVmRHdPcAcgEft96L3UVd
         CbBw==
X-Gm-Message-State: ANoB5pmTpyGTcB1/f9ndbSMPy8a1MwI3U40bPrin34qSGdFhQuI5KAL/
        +PMjN/xfHe9hozqD2m7QwzA=
X-Google-Smtp-Source: AA0mqf4dmSYvXYaUuRUfAU1cEB8QM7s5FEQkGIg4nzKQn/yalySX+CnYQUePDkL1Q5iLh01p68eLjg==
X-Received: by 2002:a05:600c:1d24:b0:3cf:6fd0:8168 with SMTP id l36-20020a05600c1d2400b003cf6fd08168mr37678986wms.206.1669976446617;
        Fri, 02 Dec 2022 02:20:46 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id i2-20020adff302000000b002421a8f4fa6sm6516740wro.92.2022.12.02.02.20.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 02:20:45 -0800 (PST)
Date:   Fri, 2 Dec 2022 13:20:35 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Li Qiong <liqiong@nfschina.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, coreteam@netfilter.org,
        Yu Zhe <yuzhe@nfschina.com>
Subject: Re: [PATCH] netfilter: nfnetlink: check 'skb->dev' pointer in
 nfulnl_log_packet()
Message-ID: <Y4nRc3fIxQDzADyV@kadam>
References: <20221202083304.9005-1-liqiong@nfschina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221202083304.9005-1-liqiong@nfschina.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 02, 2022 at 04:33:04PM +0800, Li Qiong wrote:
> The 'skb->dev' may be NULL, it should be better to check it.
> 
> Signed-off-by: Li Qiong <liqiong@nfschina.com>
> ---

This needs a Fixes tag as well.

Here my records show that I looked at this in 2018 but I probably
ignored it based on that the code was introduced in 2012.  When warnings
are really ancient sometimes I just assume they must be false positives
or someone would have hit it in testing.

Also for really ancient bugs, it's hard to contact the original author
or they have forgotten the details of the code.

regards,
dan carpenter

