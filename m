Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9A59511DDC
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244523AbiD0SDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 14:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244519AbiD0SDS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 14:03:18 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74061352535
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 11:00:02 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id w187so4831313ybe.2
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 11:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M+wovo/NwNgVYOR7JPm/bpHPN2PsMa55qznmDxDeQwU=;
        b=LFgigD2lRSZRjMrNuI4vj7Y2uRF4WqKc4vsoJOI8FiCPWmKCdyFs7t6HOOKEBrYg5W
         VST1ZaNq1T8eO+OLGUwqFZBM9jBkUPtmLq+vv+1aMyRCYTKbZBiQjwWgVfBQILVEIQtq
         X7a2FiIY0tb41Z4mI0joeHQ3cBiYiWECObAiEEFIbAk57IsjkNhS5NBwH/D7HqMlLcRr
         ZJhe98XncJevTJzzK8dOGlSL+G2dkk27bB964ABiRmGiVeIinYUtLmgpj9FYmRqPNkb6
         wTAPYaQAfYe0AJtTX2Fy6DNGUc58LMGS/JxEAUUd7nJL8RrhCZckBI+pm4b0H3uVkhEx
         /ADw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M+wovo/NwNgVYOR7JPm/bpHPN2PsMa55qznmDxDeQwU=;
        b=b/PP1WIY3quYBttqdUGCkZsQs4/8dLIcmR2zHNWOm8RCdakUwtVr0ScrktrfC9azhb
         XdrxMSG7U5JVMXSmIctXtYnlFjFH5GIxiRg8IvsACAuEkd9F04oBQt49ZSO/MPdrUIzV
         ogh6/t6gXsV+/qFcAG0xFPHyEEtTARnE+y69cuhZArFek+1MpHMsHdqE66rasoz8XKEA
         PQbWwf0pt95oLR1ZtDWBlnumlG/A5nGUVC6QGd8edMldr6ei/3xyWziD3QskPV3QVTFi
         jw9pb057SFtiwFfZzYbY7cj2JsesbUpbu7bF2pwJ2hlmNXM3OPHN35WlHcURyvkL4O7O
         uJ7g==
X-Gm-Message-State: AOAM533fwGL9KaX2VkWw5BJePYS6Bap8/t0ul0mRwKI1zYbazgn9iFZI
        vf0ejrdu9YAefHgCNNP4G+fGh1IO4jEWWnGLiWu06UWNlXaIug==
X-Google-Smtp-Source: ABdhPJyzZ5cY45/dZ3GAgLUHbl59GCRGzxCCGpa1HTHkY0QWhWZicGvRx/BdHajmS6cl37Eg0RcRt/Tzjt1wlr/I7t0=
X-Received: by 2002:a25:2a49:0:b0:648:f2b4:cd3d with SMTP id
 q70-20020a252a49000000b00648f2b4cd3dmr754538ybq.231.1651082401338; Wed, 27
 Apr 2022 11:00:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220422201237.416238-1-eric.dumazet@gmail.com>
 <YmlilMi5MmApVqTX@shredder> <CANn89i+x44iM97YmGa6phMMUx6L5a3Cn86aNwq3OsbQf3iVgWA@mail.gmail.com>
 <CANn89iLue8fy-6TTEsTwzWAog-KnAcsG19up34621W8Bp+0=NQ@mail.gmail.com>
In-Reply-To: <CANn89iLue8fy-6TTEsTwzWAog-KnAcsG19up34621W8Bp+0=NQ@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 27 Apr 2022 10:59:50 -0700
Message-ID: <CANn89iK3uzj4MzAyPrjQVR+5fZQaBdopuMEAZGP6QmWeXZj19Q@mail.gmail.com>
Subject: Re: [PATCH v2 net-next] net: generalize skb freeing deferral to
 per-cpu lists
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>
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

On Wed, Apr 27, 2022 at 10:11 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Wed, Apr 27, 2022 at 9:53 AM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Wed, Apr 27, 2022 at 8:34 AM Ido Schimmel <idosch@idosch.org> wrote:
> > >
> >
> > >
> > > Eric, with this patch I'm seeing memory leaks such as these [1][2] after
> > > boot. The system is using the igb driver for its management interface
> > > [3]. The leaks disappear after reverting the patch.
> > >
> > > Any ideas?
> > >
> >
> > No idea, skbs allocated to send an ACK can not be stored in receive
> > queue, I guess this is a kmemleak false positive.
> >
> > Stress your host for hours, and check if there are real kmemleaks, as
> > in memory being depleted.
>
> AT first when I saw your report I wondered if the following was needed,
> but I do not think so. Nothing in __kfree_skb(skb) cares about skb->next.
>
> But you might give it a try, maybe I am wrong.
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 611bd719706412723561c27753150b27e1dc4e7a..9dc3443649b962586cc059899ac3d71e9c7a3559
> 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -6594,6 +6594,7 @@ static void skb_defer_free_flush(struct softnet_data *sd)
>
>         while (skb != NULL) {
>                 next = skb->next;
> +               skb_mark_not_on_list(skb);
>                 __kfree_skb(skb);
>                 skb = next;
>         }

Oh well, there is definitely a leak, sorry for that.
