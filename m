Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 800F26A20AC
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 18:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjBXRqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 12:46:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjBXRqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 12:46:42 -0500
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92AA81630D
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 09:46:38 -0800 (PST)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-536af432ee5so619697b3.0
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 09:46:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hT/9+aMDCfMLQGWze/VWjqd6BMZs0JH+5E/UJ6lCarU=;
        b=FsvQDJEQ9CcbIHcSzX7802Zi/v8SnNBViQwWUhbHkrcCtv06zUGJ0gE2KVXEwxGeSC
         EnKpWdbk9j7AaNiGqGx15/md2hsXdD6+dH9/J3Rvjuo5ufHt/LWF9St8Z2d/shoeK0uJ
         yD0H6q75ZK7OszHkMQjoQCuyGYocdbFSGuNgI5CDldGwJwoFVVtPnEr5xsmFgWSFiKjx
         Vib9NVBXrmK+SqhPgVOz/5Ygl5+2c/l6sNeE4junq9RbWVOpZ+KdOm+jUgYmK3RQ38A+
         QDdT6M7Dr3cCVLoA8E4NO+VVrxiKbg09SH/mnfdh4Cur2ykLSYmAvykciVyQbkNYIjsS
         onjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hT/9+aMDCfMLQGWze/VWjqd6BMZs0JH+5E/UJ6lCarU=;
        b=l85EfSLGsv+LNSA9rLZ6HinDr77NtZmdNduZZCSWImDfkyjfHsx4TJijUbvJOjSgR1
         fTsxM0PW/1ag3jFbf6ooTOkoB9rFfBdTjAYGUNTvNjUWE0NHHb2zKrXwEmAamtgHkCFH
         KnLgz3fEytPw8tJYqX0STaiv/c3iTn3A34txnKH5Sb//0u9CpPRobmj5sq0Lw8BIqs+9
         4JDXi4Oq6j9RB+nAzK4y1TLNP7QcAIeYwONp6anl8lq+o2Z/A7ht/WUH+F2FyX6tfWGr
         U9G8WwwYTX5mdZTLWSYm9nzssSZB4kzNXMfGxcknpUagdnXyyw/7CLn1Kbp09V8jdCfp
         UhVg==
X-Gm-Message-State: AO0yUKVFrq2dThbJMPUqHHS0ktUeYwSGw3MlU+LAKihkW8MjdIWlrDK/
        pdlaveyqQO8SOTsP4+YSDUg1uqVHZRTnMvGpxFSz/w==
X-Google-Smtp-Source: AK7set8p4ifCqDQRr6cb8gTKagt5PMNoLJCp92RpjvXQF2CF+/6P+k59k8CUYLXmUECdfxgVa9ErWnwhleeNe/VSu4M=
X-Received: by 2002:a81:ad22:0:b0:52e:fb7a:94b7 with SMTP id
 l34-20020a81ad22000000b0052efb7a94b7mr5014854ywh.7.1677260797856; Fri, 24 Feb
 2023 09:46:37 -0800 (PST)
MIME-Version: 1.0
References: <20230224015234.1626025-1-kuba@kernel.org> <20230223175708.51e593f0@kernel.org>
 <0ae995dd47329e1422cb0e99b7960615c58d37fe.camel@sipsolutions.net>
 <CAM0EoMnfDhAXsZKY7UqwCxgeXGH1Q-pQdqSycMHw+MSRZSABVA@mail.gmail.com>
 <CAM0EoMm9NyE7nJZ4ktntNMUsCQkyEuVyR5f_E7TgiKNCo15a3A@mail.gmail.com> <20230224091055.1a63e08e@kernel.org>
In-Reply-To: <20230224091055.1a63e08e@kernel.org>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Fri, 24 Feb 2023 12:46:26 -0500
Message-ID: <CAM0EoMk1esVFzY5fsGLxqhTU=OsDqHSLuKEqiFLJFB_mCmeC7w@mail.gmail.com>
Subject: Re: [PATCH iproute2] genl: print caps for all families
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        stephen@networkplumber.org, dsahern@gmail.com,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 24, 2023 at 12:10 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 24 Feb 2023 10:22:56 -0500 Jamal Hadi Salim wrote:
> > After a couple of sips of some unknown drink: I think we can get rid
> > of ctrl_v altogether as a param to the printers and we should be good
> > (it would work for events as well).
>
> Do you mean to always interpret the flags? FWIW I think that should
> be fine, old kernels just don't set those flags so I'm not sure why
> we're gating interpreting them with the version.

I think it was leftover cruft from when the capabilities were being
sent as attributes. Old kernels
should work fine AFAIK.

cheers,
jamal
