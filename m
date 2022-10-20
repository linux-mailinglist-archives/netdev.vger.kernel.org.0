Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 207FB6067FB
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 20:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbiJTSMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 14:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbiJTSLs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 14:11:48 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82E3B202725
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 11:11:47 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id j130so516321ybj.9
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 11:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=oJJKHdCph79ekx0FQxWf6mcRM8elTZFVKG09Lqyve3E=;
        b=C0MZXSvfMEhfrc8pY4wdQo3q+9b5ow+Y5sgnWT2537ow1VUZSdgUsuRHscjf8bRj5c
         Ck8HrtlisALDolXOOV0YznDfnRZmO/IomABTdm3CAwQkE1SwKQEM8XtXBiQGUOIYEx5O
         RmHfnwsnjXOOVLKbTbfdZKoXVmBcbAxRG/ib+7vjSqidgzwkWoumy+prYC2u/MBbyV9q
         e2FNcOahwWfkDuP21DnQGLA/T/XxSDTrjsrPAyzc9tEalsvbEMmblKzhcAdJ/a0J30RH
         F4bT7fOa+sr9CCrKPpmiLXEaAg6KFkPKodoNX13Kx4msAJC933hB62qRpW4F6CRyRqXV
         NBOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oJJKHdCph79ekx0FQxWf6mcRM8elTZFVKG09Lqyve3E=;
        b=CzLHGx17gU1LSkPdhfPo7GfoY07qytgifMkJc8MRqATYUHOBfo+Y5yRLErID2gctKq
         qMLoveU6QfN4pI2uIaar8JbPsGVtqxY5JPg3txVjixlbs2uCjrtZJrEWVShaFmegmbBo
         cavxfD08dx/ft8yprZ77ePESmi1/nY834o+RNsGQ9IFGWb6di0jDgGBVWieC4Gr77LxO
         RVQehJ++HH/S9/QeFxMHp5cxE6HaMFPDSrfN5ZbgutoTZMpg843uiVBI56YflmbeLlpk
         b7C+trq9jPpPqAcM2bJ7SbHTsLj9xn955yja5KAKfXeURCaqf9okTD9NW9gV9D9Qs9Zc
         4WNQ==
X-Gm-Message-State: ACrzQf1GbW8ZrwCfMNuFpQFYq5+1boby9ZNeg+n30FrIKn1ddmPwuidX
        LPBnByUhyUX2CkjFVmt4y9evmkX924OZ7X9j4HTumUm2160=
X-Google-Smtp-Source: AMsMyM5qgEJXaKS7rT2ocfwhE7lTfIa8CcgthDfVlcgeYrrOVTV01h431iJ1dkXeEzgSNvEx5e9gFVyHw/93fdk1SYI=
X-Received: by 2002:a25:e207:0:b0:6ca:268b:10c3 with SMTP id
 h7-20020a25e207000000b006ca268b10c3mr4536388ybe.407.1666289505845; Thu, 20
 Oct 2022 11:11:45 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1666287924.git.pabeni@redhat.com> <dc549a4d5c1d2031c64794c8e12bed55afb85c3e.1666287924.git.pabeni@redhat.com>
In-Reply-To: <dc549a4d5c1d2031c64794c8e12bed55afb85c3e.1666287924.git.pabeni@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 20 Oct 2022 11:11:34 -0700
Message-ID: <CANn89iL4z2m5MAxVrd_tNfn9OcmgX5yGm3XyxoJrhEBu99YV6g@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/2] net: introduce and use custom sockopt
 socket flag
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.linux.dev,
        David Ahern <dsahern@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Kuniyuki Iwashima <kuniyu@amazon.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 20, 2022 at 10:49 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> We will soon introduce custom setsockopt for UDP sockets, too.
> Instead of doing even more complex arbitrary checks inside
> sock_use_custom_sol_socket(), add a new socket flag and set it
> for the relevant socket types (currently only MPTCP).
>
> Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
>

Reviewed-by: Eric Dumazet <edumazet@google.com>
