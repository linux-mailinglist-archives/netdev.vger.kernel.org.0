Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACA92608D53
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 15:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiJVNGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 09:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiJVNGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 09:06:01 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B834D54C9B
        for <netdev@vger.kernel.org>; Sat, 22 Oct 2022 06:05:58 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id l6so3037307ilq.3
        for <netdev@vger.kernel.org>; Sat, 22 Oct 2022 06:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DirEIYhKHX7unSsOb6Xwy+qguUF2PFewZWGcxOFvURo=;
        b=BGmT5nwF09wDpXG73GWsTwskNMsyhDNEVsumVVDqAH61DaBflgzYSqCLNBK1ZtjuRF
         b+p6hahqT5gvB8rG/raRGvRTas/94eI5xBYn2FIujlQpKXlpIe5sXq0m5nPfidbDZArI
         drbasfYHFsxnvtBuAapoGDad2labdLJK64xJ+WPBPvBjmVhAa/gEqVSbebrCPstPNotN
         SWhhjWrHj0Xjso60GphK+QGQ92URuht1Is+NjidzirLdM3Urob8B6zt0WxupCnLqq6o1
         WCvLwpcbzMMcwjWoHkTw4UrltxE2jP3EbWQ6s6JhTMKZTqOgr7GGpPapzbewfaouEyA3
         3VwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DirEIYhKHX7unSsOb6Xwy+qguUF2PFewZWGcxOFvURo=;
        b=u+/lzLXVCEEXl9pgsBOqI1ArGhZZTmuYgChkYwuO7nU6auR6x3GrPdy+IV9V5IVKJL
         cVOMqXWM1uFLTnSKHkI7j8iIjPWNNeSo4erU1duAwN7wi0SWnxUc0bQbNARQZKJTj9D8
         AIRe55XVLR7kaE8EKA4rxBNU5OCVKn1ebEjdk6tz65vXqIq7Cuq+5sHcrGP4MrDs5dPK
         YBN+8kQG8UvpuwAP9rrS4RuyXoldzFhvTDB6RX+bqBtsQL0fgDaYgWXI+y0s7ria/j9t
         o1GNaaJk1qJ88HSm5+TywPLpFFuJd3zpBA9A9hfFvuiJ1lakb5/3yNuVOAHsugzC+ezo
         ujBw==
X-Gm-Message-State: ACrzQf0D4on4UQJ/ZJyMZGNvJHHJvRfIYJeC5kIZ8G95j4iNxNGtOYGF
        klBWCRtCMfmeDWAQQAUdqfqMi08XtGktA4je/eU=
X-Google-Smtp-Source: AMsMyM6dr5Iv9Xlf4fCPswMGBCAct1O6qfnsVI6eq6UggenR3MttcfbNpNpMls5mZ7V7Lw1ccZmgqZpY41f1xlLFjvo=
X-Received: by 2002:a05:6e02:16c8:b0:2ff:6bd9:6c11 with SMTP id
 8-20020a056e0216c800b002ff6bd96c11mr7245945ilx.85.1666443958218; Sat, 22 Oct
 2022 06:05:58 -0700 (PDT)
MIME-Version: 1.0
References: <20221021205900.1764650-1-m.chetan.kumar@linux.intel.com>
In-Reply-To: <20221021205900.1764650-1-m.chetan.kumar@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Sat, 22 Oct 2022 17:05:56 +0400
Message-ID: <CAHNKnsSJCPdv64q=1GBjcYmNSWtwN9P9tA8RyYuH+AqG8XV71w@mail.gmail.com>
Subject: Re: [PATCH V4 net-next 1/2] net: wwan: t7xx: use union to group port
 type specific data
To:     m.chetan.kumar@linux.intel.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, linuxwwan@intel.com,
        linuxwwan_5g@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 21, 2022 at 7:31 PM <m.chetan.kumar@linux.intel.com> wrote:
> Use union inside t7xx_port to group port type specific data members.
>
> Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>

Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
