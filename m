Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E24FA43CA28
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 14:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235978AbhJ0M5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 08:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231407AbhJ0M5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 08:57:13 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E759C061570;
        Wed, 27 Oct 2021 05:54:48 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id l16-20020a9d6a90000000b0054e7ab56f27so3394229otq.12;
        Wed, 27 Oct 2021 05:54:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LI9/FJwf63ZGEHsZdivTqqc370IQgSB/MIGubd/A6Jg=;
        b=Nsv8mdNdDBjJ9TOaSR+5ikceLEPD8OiqcEkp8iUixLKcwmaS6YKHjjQLufbXYj1G9E
         9RGfl3EY4ls0tj/uyx1UPfiHEQ5Z5VP3T54s9FrTzzeeb3X8amyHm1P7i5FXbFD0taJt
         BXces++agDw7xc5pC7IRQIUl9IKtTB5yhcVpABZbvYwPztLFZdVGri2cXTjEgbqrx4vt
         4geRj6H5zdPB47KbpArz8dexYDT2zl/YgEbQFUGVsu0ijEohiCtoctwc802qzHLkiNLl
         F8RAJd+m6HelySKojqRPT+EDI0ucF2lcqQvfYeva6fdxznUzZRx7yvluKVRErviqEsZD
         P8qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LI9/FJwf63ZGEHsZdivTqqc370IQgSB/MIGubd/A6Jg=;
        b=zSpGh3gZUsmtQjcwZx+NmzPDFP3T2u35k+fK6MPLfh+jQyLOtjN9CnS2dKZAAAxsRm
         K9o0pnDOsdROel61FmgcNhmEMoJttAFjfrXeYuFm1I4oJ0R/rxBCSPfpFxbw9CEZXZPH
         LmzFevkr67J6ipR/7WB2pKr7eIyi2qhZEUGKWWBtya2bdvGbr8fggpWTr/AguE9ctKKX
         eIM489XBnakxnlY4fXiC/VMcIFWaxhKnNIrjGh3fSNyGawArZ/Ea7ZOWBBxV0coVW46D
         76sMVPQNAlynhSax/uZx2qn/1fejSZ2hXY5vsEERvBGajdbkcoOepYsDDzyIOKgoASon
         5Lwg==
X-Gm-Message-State: AOAM530JgLESKcFHkFDfnM9zvRLxClUqMRpOyX62LooF9IfbQkx5RRW4
        4pJLUNtYLHk7IH1a+lwN2YjxeOL08/CjIImzkYs=
X-Google-Smtp-Source: ABdhPJx4iaDn92o1BXwlDl1T3ugDvg1j5Wt8kLDXf4agE4bkSB8g2TZz+XVW4toKVNkJ4UDI2m0SMw+co/mpu661x4I=
X-Received: by 2002:a05:6830:1f2a:: with SMTP id e10mr24159337oth.118.1635339287776;
 Wed, 27 Oct 2021 05:54:47 -0700 (PDT)
MIME-Version: 1.0
References: <20211026131859.59114-1-kerneljasonxing@gmail.com>
 <CAL+tcoC487AF=HAiNVhKO6kA0yhjT+hmp5DQSdaGBnJEtGgqPA@mail.gmail.com>
 <CAL+tcoAD+iiEFbvMnaHjg_-42_r7ukxDt8CveYW7pE4arcdKsg@mail.gmail.com>
 <CAL+tcoAUwEx3ZJ5ysu_+-1eYfuL82JoV0fk7305dSOSo6J80-w@mail.gmail.com> <31e181c7-7268-877a-f061-cdea06c0459e@huawei.com>
In-Reply-To: <31e181c7-7268-877a-f061-cdea06c0459e@huawei.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Wed, 27 Oct 2021 20:54:11 +0800
Message-ID: <CAL+tcoB=zxnZTSnF60vy=wp9YcVxVjshZ87HUZhR4vU_U6Vq7Q@mail.gmail.com>
Subject: Re: [PATCH net] net: gro: set the last skb->next to NULL when it get merged
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     David Miller <davem@davemloft.net>, kuba@kernel.org,
        alobakin@pm.me, jonathan.lemon@gmail.com,
        Willem de Bruijn <willemb@google.com>, pabeni@redhat.com,
        vvs@virtuozzo.com, cong.wang@bytedance.com,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jason Xing <xingwanli@kuaishou.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 8:40 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> On 2021/10/27 16:56, Jason Xing wrote:
> > On Wed, Oct 27, 2021 at 4:07 PM Jason Xing <kerneljasonxing@gmail.com> wrote:
> >>
> >> On Wed, Oct 27, 2021 at 3:23 PM Jason Xing <kerneljasonxing@gmail.com> wrote:
> >>>
> >>> On Tue, Oct 26, 2021 at 9:19 PM <kerneljasonxing@gmail.com> wrote:
> >>>>
> >>>> From: Jason Xing <xingwanli@kuaishou.com>
> >>>>
> >>>> Setting the @next of the last skb to NULL to prevent the panic in future
> >>>> when someone does something to the last of the gro list but its @next is
> >>>> invalid.
> >>>>
> >>>> For example, without the fix (commit: ece23711dd95), a panic could happen
> >>>> with the clsact loaded when skb is redirected and then validated in
> >>>> validate_xmit_skb_list() which could access the error addr of the @next
> >>>> of the last skb. Thus, "general protection fault" would appear after that.
> >>>>
> >>>> Signed-off-by: Jason Xing <xingwanli@kuaishou.com>
> >>>> ---
> >>>>  net/core/skbuff.c | 1 +
> >>>>  1 file changed, 1 insertion(+)
> >>>>
> >>>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> >>>> index 2170bea..7b248f1 100644
> >>>> --- a/net/core/skbuff.c
> >>>> +++ b/net/core/skbuff.c
> >>>> @@ -4396,6 +4396,7 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
> >>>>                 skb_shinfo(p)->frag_list = skb;
> >>>>         else
> >>>>                 NAPI_GRO_CB(p)->last->next = skb;
> >>>> +       skb->next = NULL;
> >>>>         NAPI_GRO_CB(p)->last = skb;
> >>>
> >>> Besides, I'm a little bit confused that this operation inserts the
> >>> newest skb into the tail of the flow, so the tail of flow is the
> >>> newest, head oldest. The patch (commit: 600adc18) introduces the flush
> >>> of the oldest when the flow is full to lower the latency, but actually
> >>> it fetches the tail of the flow. Do I get something wrong here? I feel
> >>
> >> I have to update this part. The commit 600adc18 evicts and flushes the
> >> oldest flow. But for the current kernel, when
> >> "napi->gro_hash[hash].count >= MAX_GRO_SKBS" happens, the
> >> gro_flush_oldest() flushes the oldest skb of one certain flow,
> >> actually it is the newest skb because it is at the end of the list.
>
> it seems the below is more matched with the gro_flush_oldest() instead
> of the above code block:
> https://elixir.bootlin.com/linux/v5.15-rc3/source/net/core/dev.c#L6118
>

What you said is the @skb->list but not the list between skbs which is
connected by skb->next when the new incoming skb needs to get merged.
The @skb->list->next/prev is not the same as @skb->next.

> >
> > I just submitted another patch to explain how it happens, please help
> > me review both patches.
> >
> > Link: https://lore.kernel.org/lkml/20211027084944.4508-1-kerneljasonxing@gmail.com/
> >
> > Thanks again,
> > Jason
> >
> >>
> >>> it is really odd.
> >>>
> >>> Thanks,
> >>> Jason
> >>>
> >>>>         __skb_header_release(skb);
> >>>>         lp = p;
> >>>> --
> >>>> 1.8.3.1
> >>>>
> > .
> >
