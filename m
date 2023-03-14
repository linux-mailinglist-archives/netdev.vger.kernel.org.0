Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA57E6B8F86
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 11:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbjCNKQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 06:16:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230388AbjCNKQ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 06:16:27 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 723C325968
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 03:15:51 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 16so8552207pge.11
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 03:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678788949;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FDAb7nZpnW4TUy/jFjUYewom3uwx33tjkiX4uIYveAE=;
        b=Il1BCOQ9M3DmoRF6ztCzzUSWqV9ISR5hp/s9wKvwl7LD5Y5JbwNzkd1br0uXgnso6Z
         4rlHnlC5A4iuk5feIC3zQrDeJrNVPajqWW1xS3ZOHeFb+uf4NGIN042WPr0poaqlCVjj
         kqibfvq7NOU3eW1LoL9Pix+CvOCAHRvdYnNCGqz2lzLH9CpNhuVK/CIVEYPKqNF6LdtK
         2BJA+NRnohN0j/KTHS+h+cjAJC5COf8kZnuVXi19xUL0Po/L9JrfhG+ctZo1LppKPT++
         lvY5IczAGlWPnloxGh6gmT7gdq4oFZMsBJUmCpFiO6XKCePUNYYf6YXTqKrB/fbOxJRe
         DXkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678788949;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FDAb7nZpnW4TUy/jFjUYewom3uwx33tjkiX4uIYveAE=;
        b=DBe5IUAlGFOHhi+MocKpMKvQxwTl+xo883AbEfaL7BgR+HoUkE4A+oDS7OljFDsc7t
         0rRK0W7kLSW20JJmIzNmlvQxH3QZ0JeXT89cCbS3cV+NJpmb9hxr4BGRJtxGeRQ9HDjY
         TXxPUMzEo0rPOq5LI9NmUfe87qGa5K5vA+gr+GdkIABuO4o2pmtU1P+AI4W7jv/VAmgw
         Cstdb1+h/WAggbSKzqey43guC97NIGk90mt1lJ1CVY03bsmzrWxlogQGy0gNeyqVrZ/O
         jKHEKg6Hjj+NRVhMLhjs7EH9gWCX/Ilx38lSfXhgWqxuHJz9mYnRjIQiba1EJTa2buZk
         +SVw==
X-Gm-Message-State: AO0yUKXBhFuj3j5fa9++0TwKBKjmPjJveL6SO7kd/BJlMmLPJDmFmRXM
        jsxUtkfG0rujVQRGj+DHOlY=
X-Google-Smtp-Source: AK7set8Pz9Tp7Hseqj1dzG/Qx4wDLXhg9qvixiKG/qV5RnQUnhdkL403F/bVGDIJJnMYBzHF6nJE0Q==
X-Received: by 2002:a62:6542:0:b0:5a8:ad9d:83f with SMTP id z63-20020a626542000000b005a8ad9d083fmr27536324pfb.24.1678788949411;
        Tue, 14 Mar 2023 03:15:49 -0700 (PDT)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id x2-20020a62fb02000000b005a909290425sm1263783pfm.172.2023.03.14.03.15.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 03:15:48 -0700 (PDT)
Date:   Tue, 14 Mar 2023 18:15:43 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Marcelo Leitner <mleitner@redhat.com>,
        Phil Sutter <psutter@redhat.com>
Subject: Re: [PATCH net 0/2] net/sched: fix parsing of TCA_EXT_WARN_MSG for
 tc action
Message-ID: <ZBBJT5nRWbcusXBR@Laptop-X1>
References: <20230314065802.1532741-1-liuhangbin@gmail.com>
 <ZBA8WD1FBtT3mpRn@dcaratti.users.ipa.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBA8WD1FBtT3mpRn@dcaratti.users.ipa.redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 10:20:24AM +0100, Davide Caratti wrote:
> On Tue, Mar 14, 2023 at 02:58:00PM +0800, Hangbin Liu wrote:
> > In my previous commit 0349b8779cc9 ("sched: add new attr TCA_EXT_WARN_MSG
> > to report tc extact message") I didn't notice the tc action use different
> > enum with filter. So we can't use TCA_EXT_WARN_MSG directly for tc action.
> 
> Reported-and-tested-by: Davide Caratti <dcaratti@redhat.com>

Thanks Davide, I forgot to add the Reported-by flag.

Hangbin
