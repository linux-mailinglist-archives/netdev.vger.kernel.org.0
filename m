Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A338443CB57
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 15:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242334AbhJ0OAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 10:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242301AbhJ0OAm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 10:00:42 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA3BC061570;
        Wed, 27 Oct 2021 06:58:16 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id b4-20020a9d7544000000b00552ab826e3aso3714385otl.4;
        Wed, 27 Oct 2021 06:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NpjjYq+i+w+/T84lJ4rWde13BLSANx5QtAmlVDtp0/w=;
        b=KIk682iOWFIRhCa79fS/XyH1smXdI0tMrxiVQN4Px9VwDRFcNtUUaRyFtpkDRCmEfo
         WSeSUQ6aVN6gFYMefnH/LEA7iEhe7oDSKqGPc3+hDLDFmoSinKiExRGBpEuj/1VLblYK
         1m/Nx0wbttD1CfKAqtWpjg5Rt6/qngWG7aUaZLhvn3mvZ2/LQjYoeY7RiSZLuvyctPZs
         s/PgwWh5mNEbQ96pVd+Of/aw+FqYot+7CT8/Y7xCOwNQLwiN95n7pNRR7J3lb5eQNKu0
         rfj9YqDH6DNDAQPcztjy3bTQM6SV36+xUIJu0yLqUBUXgrUtkRYlIvK3hkfeGgbvk40L
         z+fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NpjjYq+i+w+/T84lJ4rWde13BLSANx5QtAmlVDtp0/w=;
        b=FMdvO9LhqQGkfRb1FUL7Z94Mc6fp8wLuJDLG79L33GpjetNHxfLmFaimXBOGTU90gf
         d9MXX6cTl0/ZG93I2/2oI0si1SsBsJOrzTP+qNjfAgvm5wpmc7eih/2p8wLxPGDJTxjb
         h8nQpzDTp2VKATmYjQmTnBbNC3qliPvWR2za6HnjwJSxpf312nW8sq947689Z/s515tT
         pfXxHPSINDPiUS9fl6MWu7KdRYq8tqPsogz5VYiaA77k1+YN/d8Ga1WVejwE67qVAdKr
         ik0MKGAAKPXDBkfnkqm7Yw0nda4TJ3sqQjZ6dsAK+kHiTjdNe28hJA1ithVPApQ/1UlQ
         UogA==
X-Gm-Message-State: AOAM532lK3d6iHATETF7eJjpvuznZWg6hMfE9DoMX+sA7snP4Ddyi6rQ
        1oPtNpI1lGTGJZrGfkGVbVGcoQsltJXeCs0nJlM=
X-Google-Smtp-Source: ABdhPJzPGTVxdzIIbjaUReyHnDqYO/motk05Esc1zeCYaQW5gaGbUsLX1BMaQFgaefnGFcRlr2Lsinx8x1kcNWmTALM=
X-Received: by 2002:a05:6830:2647:: with SMTP id f7mr24666156otu.124.1635343096198;
 Wed, 27 Oct 2021 06:58:16 -0700 (PDT)
MIME-Version: 1.0
References: <20211026131859.59114-1-kerneljasonxing@gmail.com>
 <CAL+tcoC487AF=HAiNVhKO6kA0yhjT+hmp5DQSdaGBnJEtGgqPA@mail.gmail.com>
 <CAL+tcoAD+iiEFbvMnaHjg_-42_r7ukxDt8CveYW7pE4arcdKsg@mail.gmail.com>
 <CAL+tcoAUwEx3ZJ5ysu_+-1eYfuL82JoV0fk7305dSOSo6J80-w@mail.gmail.com>
 <31e181c7-7268-877a-f061-cdea06c0459e@huawei.com> <CAL+tcoB=zxnZTSnF60vy=wp9YcVxVjshZ87HUZhR4vU_U6Vq7Q@mail.gmail.com>
In-Reply-To: <CAL+tcoB=zxnZTSnF60vy=wp9YcVxVjshZ87HUZhR4vU_U6Vq7Q@mail.gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Wed, 27 Oct 2021 21:57:40 +0800
Message-ID: <CAL+tcoBQJ=T7g7Z4j9a1OogonOjiyr_kik8SUwtAH7Gu=b0auQ@mail.gmail.com>
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

On Wed, Oct 27, 2021 at 8:54 PM Jason Xing <kerneljasonxing@gmail.com> wrote:
>
> On Wed, Oct 27, 2021 at 8:40 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
> >
> > On 2021/10/27 16:56, Jason Xing wrote:
> > > On Wed, Oct 27, 2021 at 4:07 PM Jason Xing <kerneljasonxing@gmail.com> wrote:
> > >>
> > >> On Wed, Oct 27, 2021 at 3:23 PM Jason Xing <kerneljasonxing@gmail.com> wrote:
> > >>>
> > >>> On Tue, Oct 26, 2021 at 9:19 PM <kerneljasonxing@gmail.com> wrote:
> > >>>>
> > >>>> From: Jason Xing <xingwanli@kuaishou.com>
> > >>>>
> > >>>> Setting the @next of the last skb to NULL to prevent the panic in future
> > >>>> when someone does something to the last of the gro list but its @next is
> > >>>> invalid.
> > >>>>
> > >>>> For example, without the fix (commit: ece23711dd95), a panic could happen
> > >>>> with the clsact loaded when skb is redirected and then validated in
> > >>>> validate_xmit_skb_list() which could access the error addr of the @next
> > >>>> of the last skb. Thus, "general protection fault" would appear after that.
> > >>>>
> > >>>> Signed-off-by: Jason Xing <xingwanli@kuaishou.com>
> > >>>> ---
> > >>>>  net/core/skbuff.c | 1 +
> > >>>>  1 file changed, 1 insertion(+)
> > >>>>
> > >>>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > >>>> index 2170bea..7b248f1 100644
> > >>>> --- a/net/core/skbuff.c
> > >>>> +++ b/net/core/skbuff.c
> > >>>> @@ -4396,6 +4396,7 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
> > >>>>                 skb_shinfo(p)->frag_list = skb;
> > >>>>         else
> > >>>>                 NAPI_GRO_CB(p)->last->next = skb;
> > >>>> +       skb->next = NULL;
> > >>>>         NAPI_GRO_CB(p)->last = skb;
> > >>>
> > >>> Besides, I'm a little bit confused that this operation inserts the
> > >>> newest skb into the tail of the flow, so the tail of flow is the
> > >>> newest, head oldest. The patch (commit: 600adc18) introduces the flush
> > >>> of the oldest when the flow is full to lower the latency, but actually
> > >>> it fetches the tail of the flow. Do I get something wrong here? I feel
> > >>
> > >> I have to update this part. The commit 600adc18 evicts and flushes the
> > >> oldest flow. But for the current kernel, when
> > >> "napi->gro_hash[hash].count >= MAX_GRO_SKBS" happens, the
> > >> gro_flush_oldest() flushes the oldest skb of one certain flow,
> > >> actually it is the newest skb because it is at the end of the list.
> >
> > it seems the below is more matched with the gro_flush_oldest() instead
> > of the above code block:
> > https://elixir.bootlin.com/linux/v5.15-rc3/source/net/core/dev.c#L6118
> >
>
> What you said is the @skb->list but not the list between skbs which is
> connected by skb->next when the new incoming skb needs to get merged.
> The @skb->list->next/prev is not the same as @skb->next.
>
> > >
> > > I just submitted another patch to explain how it happens, please help
> > > me review both patches.
> > >
> > > Link: https://lore.kernel.org/lkml/20211027084944.4508-1-kerneljasonxing@gmail.com/
> > >

Emm, I think you're right, Yunsheng. The gro_flush_oldest() fetches
the list of @skb->list.
Do you think the tail of skb's next pointer should be set to NULL?

Thanks,
Jason

> > > Thanks again,
> > > Jason
> > >
> > >>
> > >>> it is really odd.
> > >>>
> > >>> Thanks,
> > >>> Jason
> > >>>
> > >>>>         __skb_header_release(skb);
> > >>>>         lp = p;
> > >>>> --
> > >>>> 1.8.3.1
> > >>>>
> > > .
> > >
