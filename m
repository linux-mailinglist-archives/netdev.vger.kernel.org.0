Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E57975B7B69
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 21:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbiIMTdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 15:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiIMTct (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 15:32:49 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DCA97C1BF;
        Tue, 13 Sep 2022 12:30:56 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id 3so8845171qka.5;
        Tue, 13 Sep 2022 12:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=8mCig0Mupg7qS+i1o2Arj1m2waKc4y8IE9tk2WClB9w=;
        b=AHAmNNY8cFbrsdr6yE9NN9x0tFD3rP92OWG+WWqCyS+c5LE7r+SBN/CiMv2FT/C7xq
         oXs1a5Pan85I9AW7PGdIuQujIeLKJO8xGw0fu3VRWSF5J3RuaAERkvj1ANewPiMISiuC
         ExOFQefbsCk1NkomPnYBT6/CblXFWuhQVdRN9wiiSFr6RHitDFaA+uFb6BRftWXlJW5Q
         yrF7qnZedwZDq5/FeGrx2xIFDwBqmBeYbve1pMfrVTkbooQ7Dwe8/OXLt3A6eYqy639Q
         Yr0EXaUSb7R6BQf0+Au3cLt2jvNzH/N8iIQe5aVlQdYNHUmgnXHEKuC+Wnz6gY8+5f8v
         gWmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=8mCig0Mupg7qS+i1o2Arj1m2waKc4y8IE9tk2WClB9w=;
        b=Vdsu2h9nm5ivv3AMeu6klKc4pHZNBCXiix+/Aqx/kafSw1OIs8bRKQVC7F/3gQgPEO
         DTae9ZqwOe+b2dbGAkdTg6qL9ZkI75O+VWgqSVbNFmLSAXE6wtCeNGiNuaNqs1QTbYyd
         9J9TTOxHCF7qJf3ESB/wE1cZs3Nl7SBijrh3Ke8okeA2oLaR2Ngo0e9zFH9YAC/14NhD
         4O4AL5CBqFUFqZy6sO7lrZ60jYpFjBPohhmJNwifpWlUzPqBzGOurF8CJ1Y6PdBelPpB
         p/jVm8P5PkL+22Ui1CMzz3y12LyVOkjA70S+owIhfhUb+APsKzO5BlRKdDNPZ5o8avku
         Wxpw==
X-Gm-Message-State: ACgBeo2VVqqoLuqeBw95RmfdyNqzUZpgW6uKGr5dDHLB5C+0w3olYaNk
        LIlABgm6NkV5tYVl6HYzcThT1jQBQA==
X-Google-Smtp-Source: AA6agR5oFE2FBlG26ah09I3GsWlzVjfdKPCyFtsFP3jVKK1yxJezD14qUXxBKYVttrPKTZ3fmItX+Q==
X-Received: by 2002:a05:620a:2891:b0:6bc:5c73:9728 with SMTP id j17-20020a05620a289100b006bc5c739728mr23631600qkp.178.1663097454801;
        Tue, 13 Sep 2022 12:30:54 -0700 (PDT)
Received: from bytedance (ec2-52-52-7-82.us-west-1.compute.amazonaws.com. [52.52.7.82])
        by smtp.gmail.com with ESMTPSA id bs14-20020a05620a470e00b006b58d8f6181sm161763qkb.72.2022.09.13.12.30.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 12:30:54 -0700 (PDT)
Date:   Tue, 13 Sep 2022 12:30:50 -0700
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Peilin Ye <peilin.ye@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] net: Use WARN_ON_ONCE() in {tcp,udp}_read_skb()
Message-ID: <20220913193050.GA16391@bytedance>
References: <20220908231523.8977-1-yepeilin.cs@gmail.com>
 <20220913184016.16095-1-yepeilin.cs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220913184016.16095-1-yepeilin.cs@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 13, 2022 at 11:40:16AM -0700, Peilin Ye wrote:
> Suggested-by: Jakub Sitnicki <jakub@cloudflare.com>
> Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>

Sorry, I forgot to add Fixes: tag.

Those WARN_ON() come from different commits.  I will split this into two
in v3 to make it easier.

Thanks,
Peilin Ye

