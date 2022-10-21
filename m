Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 837B4607C34
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 18:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbiJUQ2c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 12:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiJUQ2b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 12:28:31 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B825285293
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 09:28:29 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-368edbc2c18so28189827b3.13
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 09:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7YjWeeaWgFLjAUGfmbgfIRsxpgHwo4UFKZK7Wbeepqc=;
        b=nhtvYWkC/E6D/cIGPS18+wj1i0pHBYcpmU0hy9O0Pp5A+fU1yw4uOqmMducUyy3f61
         U5PsWm9tGudNevxozXKS0i/TJEq4h0eCCyumGVqYt3buxcvadP5BtyOLjw5O+qkq3wMF
         befLRzDim+g6by/CrI4F8pTKUjKxX59Ew0RUfG75dSJFy2Kk8D5Z+feSTy5egaXSkwc+
         tZhZJT8vgxej1wTeLMjHsHsxe5f170hJuhFhG9GfgIdlPdYmBLiFnCraha/n+SShSMHK
         Coe2ZbUe84V9YSL/8Y7w/g48SawI//8r3wAT+/R1JG6FNilju3K69fXmUUaCJ3ib1d6t
         rCLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7YjWeeaWgFLjAUGfmbgfIRsxpgHwo4UFKZK7Wbeepqc=;
        b=DFSJ7AHC1CAtueawEDWo3CXDj0k4qyhIj27dN7nBl8nYgk3eHpfd809IBFQmZArPdI
         SENWmyJg4LkO7iaBOEI9ma31cPoq54HuIoba8xlMJrxSBnnMifts/NKtB8yJ4vIfXjER
         ttABsxvzT2BCoYYTsFys8w4BM30RokUPajPdiRXjt0DmEjPtO89MLgNIAV7fQrDXaUNY
         fMGO+mib1zBsdwKdUXb21XBTVPnSfPFMbX0mTyfOQjlPDXy6wUZyu+ucAIZJJ9Bzeqtr
         PBEs8rrfbCK11WhSoicgQV4sG06TZRNw4+cCzF4lZCv4HXyv8E7ATijlW6H7Sgfox4Ql
         RDjA==
X-Gm-Message-State: ACrzQf0Pxzi5gpmYaAQGMmxno2zt43+E8qrI8eK5CYGNgfo8uoxjOkFK
        cUrxc2uYwZ75MO9XUqwaKDsQfdZosIpWrX9b/6PG5w==
X-Google-Smtp-Source: AMsMyM5BPYhFsJ7XN3l6u0oynLw4fYrlmXlh6G3bLfZSHVfmcYU1qXJLOB8EYfHky+HF8CuJv0XQ9G2cy3oGJ12Xj3g=
X-Received: by 2002:a81:1c07:0:b0:358:6e7d:5118 with SMTP id
 c7-20020a811c07000000b003586e7d5118mr18638001ywc.255.1666369707746; Fri, 21
 Oct 2022 09:28:27 -0700 (PDT)
MIME-Version: 1.0
References: <20221021160304.1362511-1-kuba@kernel.org> <CALvZod4eezAXpehT4jMiQry4JQ5igJs7Nwi1Q+YhVpDcQ8BMRA@mail.gmail.com>
In-Reply-To: <CALvZod4eezAXpehT4jMiQry4JQ5igJs7Nwi1Q+YhVpDcQ8BMRA@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 21 Oct 2022 09:28:16 -0700
Message-ID: <CANn89iKTi5TYyFOOpgw3P0eTi1Gqn4k-eX+xRTX78Q4sAunm2Q@mail.gmail.com>
Subject: Re: [PATCH net] net-memcg: avoid stalls when under memory pressure
To:     Shakeel Butt <shakeelb@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, pabeni@redhat.com, cgroups@vger.kernel.org,
        roman.gushchin@linux.dev, weiwan@google.com, ncardwell@google.com,
        ycheng@google.com
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

On Fri, Oct 21, 2022 at 9:26 AM Shakeel Butt <shakeelb@google.com> wrote:
>
> On Fri, Oct 21, 2022 at 9:03 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > As Shakeel explains the commit under Fixes had the unintended
> > side-effect of no longer pre-loading the cached memory allowance.
> > Even tho we previously dropped the first packet received when
> > over memory limit - the consecutive ones would get thru by using
> > the cache. The charging was happening in batches of 128kB, so
> > we'd let in 128kB (truesize) worth of packets per one drop.
> >
> > After the change we no longer force charge, there will be no
> > cache filling side effects. This causes significant drops and
> > connection stalls for workloads which use a lot of page cache,
> > since we can't reclaim page cache under GFP_NOWAIT.
> >
> > Some of the latency can be recovered by improving SACK reneg
> > handling but nowhere near enough to get back to the pre-5.15
> > performance (the application I'm experimenting with still
> > sees 5-10x worst latency).
> >
> > Apply the suggested workaround of using GFP_ATOMIC. We will now
> > be more permissive than previously as we'll drop _no_ packets
> > in softirq when under pressure. But I can't think of any good
> > and simple way to address that within networking.
> >
> > Link: https://lore.kernel.org/all/20221012163300.795e7b86@kernel.org/
> > Suggested-by: Shakeel Butt <shakeelb@google.com>
> > Fixes: 4b1327be9fe5 ("net-memcg: pass in gfp_t mask to mem_cgroup_charge_skmem()")
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > ---
> > CC: weiwan@google.com
> > CC: shakeelb@google.com
> > CC: ncardwell@google.com
> > CC: ycheng@google.com
> > ---
> >  include/net/sock.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/include/net/sock.h b/include/net/sock.h
> > index 9e464f6409a7..22f8bab583dd 100644
> > --- a/include/net/sock.h
> > +++ b/include/net/sock.h
> > @@ -2585,7 +2585,7 @@ static inline gfp_t gfp_any(void)
> >
> >  static inline gfp_t gfp_memcg_charge(void)
> >  {
> > -       return in_softirq() ? GFP_NOWAIT : GFP_KERNEL;
> > +       return in_softirq() ? GFP_ATOMIC : GFP_KERNEL;
> >  }
> >
>
> How about just using gfp_any() and we can remove gfp_memcg_charge()?

How about keeping gfp_memcg_charge() and adding a comment on its intent ?

gfp_any() is very generic :/
