Return-Path: <netdev+bounces-11318-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CFC10732977
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 10:05:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D05C1C20F75
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 08:05:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FC8A944E;
	Fri, 16 Jun 2023 08:05:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 251789447
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 08:05:20 +0000 (UTC)
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 551AE1FD7
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 01:05:19 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id d75a77b69052e-3f9a81da5d7so179521cf.0
        for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 01:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686902718; x=1689494718;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+VBs79S5XhvqTccO5asG7ouD0KNVEVNizCE/FIq5fIM=;
        b=JZ1/SjUJukpvr6CnbyfWMdNkqyNbU0UvQJzQEeKCNsp/uAwET4AYMQab1M+1c6Zhlb
         nOJGBhU4/hbb/xt8pLbV9bbDdZ9ZBRMwXz5E8LTn5YarGwILMyUa199PTYe/eF+N5CNb
         c2C9zS9cuygKX5VP7k/hYi1EMAi7I0FnnY3guRpF9h73naQYQCxeJ4YheEfzAke2ZU5N
         ue7OMBLRIkfALbrZ3eeWkOCwv8uY53hpLGJ4T1p2sDAr4j/Ui43BhH25MG8XVB2lp8EF
         YvxHE1cu9ymzZHeDkQYp88Oa+/2NWrLdASonVYvf4s/fs/v3CmAYR0Nqx6uzdeOWVMln
         9cZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686902718; x=1689494718;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+VBs79S5XhvqTccO5asG7ouD0KNVEVNizCE/FIq5fIM=;
        b=Seoqq5SFoy+xURQaMdgQHZUSaBVdzo/Yg4XDwelzZscFTGLRGxrwZ2VSvZP0rSjeVi
         629nDaETA1djqdrGW8cvnOoGo78KpBxiINBIuSe2me+/GPQktKgoCXZRGmN/hTV85g0s
         NJy/QsrrlNI5A3moAky7QFK0CZhXBT7Wuy2HWGaI4YN/ugZWy2EfrmI9UnSOb8KskpwQ
         m1I2EmOR+t6QGCdEYRiZg3+b5fJ0m4LOp5DO5vkpn7oHSySzOw8BrO4IJK7nrE2F3B1A
         9nJMiAtOIwCbMs2QryqPDa5noPs/WdrBzNQ4Z+plSHkFasmi4F/Aaq672hIDTylxbS7b
         BQig==
X-Gm-Message-State: AC+VfDz/cqjSpXumYiYjr8naKA+1oiu7AmRytDekYE686V/49m3wu1Xl
	D9ojp0yDY4GpyBm5fmRXcYOORHqzRr8+TfD2b1ITUg==
X-Google-Smtp-Source: ACHHUZ5kuLFmP5diobN5fMUgS3Pm9XtJCm3BafgEfBUBpys7dMe/vfPYHRl/SDOM/i6JSKukXt6eFWFBmcL1zvW7Xjw=
X-Received: by 2002:a05:622a:196:b0:3fa:45ab:22a5 with SMTP id
 s22-20020a05622a019600b003fa45ab22a5mr450244qtw.27.1686902718255; Fri, 16 Jun
 2023 01:05:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230616033317.26635-1-cambda@linux.alibaba.com>
In-Reply-To: <20230616033317.26635-1-cambda@linux.alibaba.com>
From: Eric Dumazet <edumazet@google.com>
Date: Fri, 16 Jun 2023 10:05:07 +0200
Message-ID: <CANn89iKDceTf_fgpmyv9Dq+1_kVb3zAnSdmnRxZ_5E+xjkjJCQ@mail.gmail.com>
Subject: Re: [PATCH net] ipvlan: Fix return value of ipvlan_queue_xmit()
To: Cambda Zhu <cambda@linux.alibaba.com>, Mahesh Bandewar <maheshb@google.com>
Cc: netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, David Ahern <dsahern@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Dust Li <dust.li@linux.alibaba.com>, Tony Lu <tonylu@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 16, 2023 at 5:34=E2=80=AFAM Cambda Zhu <cambda@linux.alibaba.co=
m> wrote:
>
> The ipvlan_queue_xmit() should return NET_XMIT_XXX,
> but ipvlan_xmit_mode_l2/l3() returns rx_handler_result_t or NET_RX_XXX
> in some cases. The skb to forward could be treated as xmitted
> successfully.
>
> Signed-off-by: Cambda Zhu <cambda@linux.alibaba.com>

Please make sure to CC ipvlan author ?

CC Mahesh

> ---
>  drivers/net/ipvlan/ipvlan_core.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/ipvlan/ipvlan_core.c b/drivers/net/ipvlan/ipvlan=
_core.c
> index ab5133eb1d51..e45817caaee8 100644
> --- a/drivers/net/ipvlan/ipvlan_core.c
> +++ b/drivers/net/ipvlan/ipvlan_core.c
> @@ -585,7 +585,8 @@ static int ipvlan_xmit_mode_l3(struct sk_buff *skb, s=
truct net_device *dev)
>                                 consume_skb(skb);
>                                 return NET_XMIT_DROP;
>                         }
> -                       return ipvlan_rcv_frame(addr, &skb, true);
> +                       ipvlan_rcv_frame(addr, &skb, true);
> +                       return NET_XMIT_SUCCESS;
>                 }
>         }
>  out:
> @@ -611,7 +612,8 @@ static int ipvlan_xmit_mode_l2(struct sk_buff *skb, s=
truct net_device *dev)
>                                         consume_skb(skb);
>                                         return NET_XMIT_DROP;
>                                 }
> -                               return ipvlan_rcv_frame(addr, &skb, true)=
;
> +                               ipvlan_rcv_frame(addr, &skb, true);
> +                               return NET_XMIT_SUCCESS;
>                         }
>                 }
>                 skb =3D skb_share_check(skb, GFP_ATOMIC);
> @@ -623,7 +625,8 @@ static int ipvlan_xmit_mode_l2(struct sk_buff *skb, s=
truct net_device *dev)
>                  * the skb for the main-dev. At the RX side we just retur=
n
>                  * RX_PASS for it to be processed further on the stack.
>                  */
> -               return dev_forward_skb(ipvlan->phy_dev, skb);
> +               dev_forward_skb(ipvlan->phy_dev, skb);
> +               return NET_XMIT_SUCCESS;
>
>         } else if (is_multicast_ether_addr(eth->h_dest)) {
>                 skb_reset_mac_header(skb);
> --
> 2.16.6
>

