Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC75052FEB9
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 20:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243614AbiEUSMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 14:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbiEUSMr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 14:12:47 -0400
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F1D27FD6
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 11:12:46 -0700 (PDT)
Received: by mail-vs1-xe2f.google.com with SMTP id h4so152563vsr.13
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 11:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X9F2Zh2kPVzGsSYPfh/Zuzq+VRCqFv1ebTg4BX2XwII=;
        b=pFbt99PjcRgwVOYi2DaV0/HV6BS5jp56J45Sv5tllxMPhy0DHEuE50ATDL1YNwoZSs
         6dY6rAZyEPFy1VMFWckYXaKymvu+ZRkwxIKT3t/Fpk8dOmmN2E7yimu9wRN06D0J0zln
         EpI8W1y59z1mXHhZmclv+cXvCZ3Vfd1ycmvlr6e/TTSjpwlpGohplXm+5uMEP91JTA7Q
         LMjDRSDh45F8NLTpsmUpmFuyboBugUkpObTuZUgyd8c80btxKJ7LJWX3LIXTrrQUzvHs
         k1hb5RlpRPlswN4gwZdNQIRpr0DIo42Veea5mcqtpp2ZwRJuSBJe58+D23aTqwZIzJ5e
         jP+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X9F2Zh2kPVzGsSYPfh/Zuzq+VRCqFv1ebTg4BX2XwII=;
        b=LJa+hLzEWgT8SmT9OGLBXCU1nsN0hueVQ5UaT5Rs5Uq3h7Ia+e6Qd130hk4eBHwpHn
         G/CkZcYZkppi5itn459HKhH3Y1QpzKGieq0ZPuyb/UyQPaAGVJTtAWeKHchCy8R77rcC
         yYsa8quPjjad8hW1gTsiiCTDYq1ZVtr33FMYfCsG2xcw7sgiHs/8D4GJwx4iLD568aop
         YkhPPCw3aoxhNEmbj5WK8w8WEZFrCx4vqA/L5s8qN49F90nLLXkxrXnnuTktFMzFcjyi
         KS/ppv9l3uBX0k8TFEPGbiFSJukzjFU+BpPZI/JcDkjv/LNaidOOQp/QIJ5u57R/pQoa
         yzTg==
X-Gm-Message-State: AOAM532KQWI1AANN2bMW98JZdDmaukE8WoSWj3zWliQ4PKdaKn4ouq6V
        BrKV163qvZJToNjXcZttXknmmwFvecJM2CZk0K0=
X-Google-Smtp-Source: ABdhPJwGqWGDcHt5aNKETRAR1mGWE4FtEP2gq8LBeNuBRXmtSW+LwK1dvOu3jHAI4oi0rpyB60+AXEqpAG/h5NK1BDE=
X-Received: by 2002:a67:c118:0:b0:337:96d2:d624 with SMTP id
 d24-20020a67c118000000b0033796d2d624mr1857174vsj.26.1653156765985; Sat, 21
 May 2022 11:12:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220520055104.1528845-1-wangyuweihx@gmail.com> <20220520175601.630bde21@kernel.org>
In-Reply-To: <20220520175601.630bde21@kernel.org>
From:   =?UTF-8?B?546L56a55oOf?= <wangyuweihx@gmail.com>
Date:   Sun, 22 May 2022 02:12:35 +0800
Message-ID: <CANmJ_FOkC=YZhex+fGyVsP_1bUBU3MsHMLbPzdixgU5PUGpONQ@mail.gmail.com>
Subject: Re: [PATCH] net, neigh: introduce interval_probe_time for periodic probe
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, Eric Dumazet <edumazet@google.com>,
        daniel@iogearbox.net, roopa@nvidia.com, dsahern@kernel.org,
        =?UTF-8?B?56em6L+q?= <qindi@staff.weibo.com>,
        netdev@vger.kernel.org, wangyuweihx <wangyuweihx@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 21, 2022 at 8:56 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 20 May 2022 05:51:04 +0000 Yuwei Wang wrote:
> > commit 7482e3841d52 ("net, neigh: Add NTF_MANAGED flag for managed neighbor entries")
> > neighbor entries which with NTF_EXT_MANAGED flags will periodically call neigh_event_send()
> > for performing the resolution. and the interval was set to DELAY_PROBE_TIME
> >
> > DELAY_PROBE_TIME was configured as the first probe time delay, and it makes sense to set it to `0`.
> >
> > when DELAY_PROBE_TIME is `0`, the resolution of neighbor entries with NTF_EXT_MANAGED will
> > trap in an infinity recursion.
>
> Recursion or will constantly get re-resolved?

Recursive call `neigh_event_send_probe` with no interval,
which means threads of `system_power_efficient_wq` will consume 100% cpu.
Re-resolved or not depend on `neigh->nud_state`, if `neigh->nud_state`
is NUD_REACHABLE,
`neigh_event_send_probe` will return immediately with no action
>
> > as commit messages mentioned in the above commit, we should introduce a new option which means resolution interval.
> >
> > Signed-off-by: Yuwei Wang <wangyuweihx@gmail.com>
>
> > diff --git a/include/uapi/linux/neighbour.h b/include/uapi/linux/neighbour.h
> > index 39c565e460c7..5ae538be64b9 100644
> > --- a/include/uapi/linux/neighbour.h
> > +++ b/include/uapi/linux/neighbour.h
> > @@ -143,6 +143,7 @@ enum {
> >       NDTPA_RETRANS_TIME,             /* u64, msecs */
> >       NDTPA_GC_STALETIME,             /* u64, msecs */
> >       NDTPA_DELAY_PROBE_TIME,         /* u64, msecs */
> > +     NDTPA_INTERVAL_PROBE_TIME,      /* u64, msecs */
> >       NDTPA_QUEUE_LEN,                /* u32 */
> >       NDTPA_APP_PROBES,               /* u32 */
> >       NDTPA_UCAST_PROBES,             /* u32 */
>
> You can't insert values in the middle of a uAPI enum,
> you'll break binary compatibility with older kernels.

Thanks, I will move it to the tail in patch v2
