Return-Path: <netdev+bounces-6834-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A4537185E5
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 17:16:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3507E28152A
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 15:16:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3432B1643D;
	Wed, 31 May 2023 15:16:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219EA168B9
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 15:16:14 +0000 (UTC)
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E11121
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 08:16:11 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3f606e111d3so69415e9.1
        for <netdev@vger.kernel.org>; Wed, 31 May 2023 08:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685546170; x=1688138170;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N64Q/VUbZVHU/BdraFfatItxNmGHzWS6PqcB2/r+gbo=;
        b=SfTf9BYd/Guck+VWTRE6qOyBtBVBHUArnLqb83mMhTitmlM3UxcXA1oIGtYjM2gVpq
         1YvqvoowYEAwJEzaM9ETAxH28UVXwrxKOhI9P2SRPJYd6IA5hLza18YSHHwTeM6W4m4n
         aqVGPmoW3NRMXaD0FrIAsywMHwe/DezRFE48LbD8xoAWlJCfUMCXkkCabC8bh2iwWk/I
         uCHiQH1jH8SYXlOy7lKg7U5b+MWoe5FyAQW9SFuTaFmAyGXYwxgg3Px+ztEXbJARxa+A
         zAHBrV3ycBP+Ocz8zzP4YyXYlxYBtAe4F8YDTvDZbNaEFQAUZnYoxuyLaNtfYyTR5ApY
         o9NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685546170; x=1688138170;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N64Q/VUbZVHU/BdraFfatItxNmGHzWS6PqcB2/r+gbo=;
        b=KdMlqhHsZ0G7i2d6hll3Ws8u9Gj5iwRN0IT8dAc35IIyCQl2ULZU4/azO9FF+OMyIA
         Zn74vUA1nbiCqnlyvs7b9HA05/DsyJFrBQYZpWdS8J2FT0yt5VeW6xEiHyb4CzoPmdsg
         wiO4/qmADqhJU3vTrX01MXBhwvNWSQkW8idcAaDDj1ORSuIy1ZUBw+NpJ1R2mt2/NUMo
         1pME1h07qLc9u9U4wXipOekTO2A3Rb8k9FYaCA13AIqYLUGIFZpCJaBXodUcEBzyTAwp
         SCzGHcsDFF8RJbnJg6Xw3hXN+zwW4B+yjqUHDzNTVJuFyv4sy37UgdMAgVRtWxyYyS0w
         OXCg==
X-Gm-Message-State: AC+VfDzSNwD/MOj3VGIr5NiuzjZG3yzKJQPHgwnCL5M9ie/Hj17uROrp
	Hn6zJCpF0EnCLhJv3VIkZEqwosVBpH9J02rG535aRg==
X-Google-Smtp-Source: ACHHUZ7VA6ZvNMktrE4vyBWM5ejkC8Yd9NmNEDk/+h1w/GcS8ddDQ/Uehb4NVeuuJ/gjWOHmda2vvu9H1/QgDjVEk24=
X-Received: by 2002:a05:600c:82c8:b0:3f3:3855:c5d8 with SMTP id
 eo8-20020a05600c82c800b003f33855c5d8mr214987wmb.6.1685546169790; Wed, 31 May
 2023 08:16:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230531141825.GA8095@debian> <20230531143010.GA8221@debian>
In-Reply-To: <20230531143010.GA8221@debian>
From: Eric Dumazet <edumazet@google.com>
Date: Wed, 31 May 2023 17:15:58 +0200
Message-ID: <CANn89iJme7C4p1v6fnhUdXccgXQ3-9tUqFHbfjGMbGVqUtyT=Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] gro: decrease size of CB
To: Richard Gobert <richardbgobert@gmail.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com, 
	lixiaoyan@google.com, alexanderduyck@fb.com, lucien.xin@gmail.com, 
	linyunsheng@huawei.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 31, 2023 at 4:30=E2=80=AFPM Richard Gobert <richardbgobert@gmai=
l.com> wrote:
>
> The GRO control block (NAPI_GRO_CB) is currently at its maximum size.
> This commit reduces its size by putting two groups of fields that are
> used only at different times into a union.
>
> Specifically, the fields frag0 and frag0_len are the fields that make up
> the frag0 optimisation mechanism, which is used during the initial
> parsing of the SKB.
>
> The fields last and age are used after the initial parsing, while the
> SKB is stored in the GRO list, waiting for other packets to arrive.
>
> There was one location in dev_gro_receive that modified the frag0 fields
> after setting last and age. I changed this accordingly without altering
> the code behaviour.
>
> Signed-off-by: Richard Gobert <richardbgobert@gmail.com>
> ---
>  include/net/gro.h | 26 ++++++++++++++++----------
>  net/core/gro.c    | 18 +++++++++++-------
>  2 files changed, 27 insertions(+), 17 deletions(-)
>
> diff --git a/include/net/gro.h b/include/net/gro.h
> index a4fab706240d..7b47dd6ce94f 100644
> --- a/include/net/gro.h
> +++ b/include/net/gro.h
> @@ -11,11 +11,23 @@
>  #include <net/udp.h>
>
>  struct napi_gro_cb {
> -       /* Virtual address of skb_shinfo(skb)->frags[0].page + offset. */
> -       void    *frag0;
> +       union {
> +               struct {
> +                       /* Virtual address of skb_shinfo(skb)->frags[0].p=
age + offset. */
> +                       void    *frag0;
>
> -       /* Length of frag0. */
> -       unsigned int frag0_len;
> +                       /* Length of frag0. */
> +                       unsigned int frag0_len;
> +               };
> +
> +               struct {
> +                       /* used in skb_gro_receive() slow path */
> +                       struct sk_buff *last;
> +
> +                       /* jiffies when first packet was created/queued *=
/
> +                       unsigned long age;
> +               };
> +       };
>
>         /* This indicates where we are processing relative to skb->data. =
*/
>         int     data_offset;
> @@ -32,9 +44,6 @@ struct napi_gro_cb {
>         /* Used in ipv6_gro_receive() and foo-over-udp */
>         u16     proto;
>
> -       /* jiffies when first packet was created/queued */
> -       unsigned long age;
> -
>  /* Used in napi_gro_cb::free */
>  #define NAPI_GRO_FREE             1
>  #define NAPI_GRO_FREE_STOLEN_HEAD 2
> @@ -77,9 +86,6 @@ struct napi_gro_cb {
>
>         /* used to support CHECKSUM_COMPLETE for tunneling protocols */
>         __wsum  csum;
> -
> -       /* used in skb_gro_receive() slow path */
> -       struct sk_buff *last;
>  };
>
>  #define NAPI_GRO_CB(skb) ((struct napi_gro_cb *)(skb)->cb)
> diff --git a/net/core/gro.c b/net/core/gro.c
> index 2d84165cb4f1..c6955ef9ca99 100644
> --- a/net/core/gro.c
> +++ b/net/core/gro.c
> @@ -460,6 +460,14 @@ static void gro_pull_from_frag0(struct sk_buff *skb,=
 int grow)
>         }
>  }
>
> +static void gro_try_pull_from_frag0(struct sk_buff *skb)
> +{
> +       int grow =3D skb_gro_offset(skb) - skb_headlen(skb);
> +
> +       if (grow > 0)
> +               gro_pull_from_frag0(skb, grow);
> +}
> +
>  static void gro_flush_oldest(struct napi_struct *napi, struct list_head =
*head)
>  {
>         struct sk_buff *oldest;
> @@ -489,7 +497,6 @@ static enum gro_result dev_gro_receive(struct napi_st=
ruct *napi, struct sk_buff
>         struct sk_buff *pp =3D NULL;
>         enum gro_result ret;
>         int same_flow;
> -       int grow;
>
>         if (netif_elide_gro(skb->dev))
>                 goto normal;
> @@ -564,17 +571,13 @@ static enum gro_result dev_gro_receive(struct napi_=
struct *napi, struct sk_buff
>         else
>                 gro_list->count++;
>

Could you add a comment here or in front of gro_try_pull_from_frag0() ?

/* Must be called before setting NAPI_GRO_CB(skb)->{age|last} (/

> +       gro_try_pull_from_frag0(skb);
>         NAPI_GRO_CB(skb)->age =3D jiffies;
>         NAPI_GRO_CB(skb)->last =3D skb;
>         if (!skb_is_gso(skb))
>                 skb_shinfo(skb)->gso_size =3D skb_gro_len(skb);
>         list_add(&skb->list, &gro_list->list);
>         ret =3D GRO_HELD;

Thanks.

