Return-Path: <netdev+bounces-1194-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FDF56FC90C
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 16:31:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9C0061C20BD8
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 14:31:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A95A317ADB;
	Tue,  9 May 2023 14:31:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D98B19506
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 14:31:41 +0000 (UTC)
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 417031BF
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 07:31:40 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id d75a77b69052e-3f38824a025so201031cf.0
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 07:31:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683642699; x=1686234699;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UVfjjlZkJp0IYfrXhtcCeEFdqQLI9OZif8q75MPv2cU=;
        b=olalahCXesiGetwDI0UJCDouvP+4kEGEnF+/v6CftgPAUla/oSp/Ta+Szf/a5A6wGC
         DFl4OdFka/jmQB/Hi9FG7FMCbpMyWWuBUOGT3olzwl1Uo88DG/d60LfCDYaD/ofRMhgM
         pqMzt0UfxfHLIPSKcwKRGXl3hpFO5CMcSW7Hfw7vji/ON8lLH43XJuNJ34n27qYKtCVw
         HNYeIAKDFK8CxxNOVJh39aw1Kth55rvRcesDX9IUUwMkHjSpxgxjgrOi/radMW+1pBGX
         Yz0+42hs0VjgghezD2Aru09jLJE0C55OKl0aHHI67Ai1aOV1sNQQU6KNavwLJMX5IUg2
         uJqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683642699; x=1686234699;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UVfjjlZkJp0IYfrXhtcCeEFdqQLI9OZif8q75MPv2cU=;
        b=kVPaxo7Cu+IFIQqTmiATMluTDzsuvJ3hT6DivOmqlrmoc0jmQhAbvR3dyLT/ZelpDM
         9HJ5TlzOmZHnUes1qov5f2aJahgUIQofwY9mLcXy5Jy/WrB8Uas1P4vhdGPEeN+jg53c
         xBfs87/u0V2p6skmsCVBxDm2v/uQAyXE/KAJog4hgwEvBiRYPMpnSs/lcuubrWPwFjGY
         5ec6Ryc9CUpUKD3UQY9Rwy0RcS81pVXwRYGHxtn9R0t+IRUIu27Sr61FmI+5pTZitOJa
         C0HlZsEGnyvRsK6xFe8plC8bDY9MF6kMrPfO+v4LKhP0i/Al2s3pSTzgdZvS747DESFw
         kZSA==
X-Gm-Message-State: AC+VfDwt/L65EbbzKc0EZ/wDnNa94gl8vCpnYjHUkAIgT2XnDTMJkiOd
	w4DI3EZX+r4HPrCURCjlJUC4o/x38WrME82hzhj7LA==
X-Google-Smtp-Source: ACHHUZ7dN/s0ctIZYprNETPi3u5BlxsS06tHXNKXEuu1OHxZqCi0W2hgAXXsyJZc/Lcj7URgbmO0HNEK4GP2jG0Hj14=
X-Received: by 2002:ac8:5982:0:b0:3db:1c01:9d95 with SMTP id
 e2-20020ac85982000000b003db1c019d95mr470317qte.4.1683642699179; Tue, 09 May
 2023 07:31:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230509135546.580158-1-dongchenchen2@huawei.com>
In-Reply-To: <20230509135546.580158-1-dongchenchen2@huawei.com>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 9 May 2023 16:31:26 +0200
Message-ID: <CANn89iJRe1-EXa8soRORCKSkQG+mK1MNYfR8B=VPbCrSJ5NpOA@mail.gmail.com>
Subject: Re: [PATCH net, v3] net: nsh: Use correct mac_offset to unwind gso
 skb in nsh_gso_segment()
To: Dong Chenchen <dongchenchen2@huawei.com>
Cc: kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com, 
	simon.horman@corigine.com, jbenc@redhat.com, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, yuehaibing@huawei.com, weiyongjun1@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 9, 2023 at 3:55=E2=80=AFPM Dong Chenchen <dongchenchen2@huawei.=
com> wrote:
>
> As the call trace shows, skb_panic was caused by wrong skb->mac_header
> in nsh_gso_segment():
>
> invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
> CPU: 3 PID: 2737 Comm: syz Not tainted 6.3.0-next-20230505 #1
> RIP: 0010:skb_panic+0xda/0xe0
> call Trace:
>  skb_push+0x91/0xa0
>  nsh_gso_segment+0x4f3/0x570
>  skb_mac_gso_segment+0x19e/0x270
>  __skb_gso_segment+0x1e8/0x3c0
>  validate_xmit_skb+0x452/0x890
>  validate_xmit_skb_list+0x99/0xd0
>  sch_direct_xmit+0x294/0x7c0
>  __dev_queue_xmit+0x16f0/0x1d70
>  packet_xmit+0x185/0x210
>  packet_snd+0xc15/0x1170
>  packet_sendmsg+0x7b/0xa0
>  sock_sendmsg+0x14f/0x160
>
> The root cause is:
> nsh_gso_segment() use skb->network_header - nhoff to reset mac_header
> in skb_gso_error_unwind() if inner-layer protocol gso fails.
> However, skb->network_header may be reset by inner-layer protocol
> gso function e.g. mpls_gso_segment. skb->mac_header reset by the
> inaccurate network_header will be larger than skb headroom.
>
> nsh_gso_segment
>     nhoff =3D skb->network_header - skb->mac_header;
>     __skb_pull(skb,nsh_len)
>     skb_mac_gso_segment
>         mpls_gso_segment
>             skb_reset_network_header(skb);//skb->network_header+=3Dnsh_le=
n
>             return -EINVAL;
>     skb_gso_error_unwind
>         skb_push(skb, nsh_len);
>         skb->mac_header =3D skb->network_header - nhoff;
>         // skb->mac_header > skb->headroom, cause skb_push panic
>
> Use correct mac_offset to restore mac_header to fix it.
>
> Fixes: c411ed854584 ("nsh: add GSO support")
> Signed-off-by: Dong Chenchen <dongchenchen2@huawei.com>
>
> ---
> v2:
>   - Use skb->mac_header not skb->network_header-nhoff for mac_offset.
>
> v3:
>   - 'net' is noted in the subject.
>   - arrange local variable following reverse xmas tree order
> ---
>  net/nsh/nsh.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/nsh/nsh.c b/net/nsh/nsh.c
> index e9ca007718b7..793e0bd94558 100644
> --- a/net/nsh/nsh.c
> +++ b/net/nsh/nsh.c
> @@ -77,6 +77,7 @@ static struct sk_buff *nsh_gso_segment(struct sk_buff *=
skb,
>                                        netdev_features_t features)
>  {
>         struct sk_buff *segs =3D ERR_PTR(-EINVAL);
> +       u16 mac_offset =3D skb->mac_header;
>         unsigned int nsh_len, mac_len;
>         __be16 proto;
>         int nhoff;
> @@ -108,8 +109,7 @@ static struct sk_buff *nsh_gso_segment(struct sk_buff=
 *skb,
>         segs =3D skb_mac_gso_segment(skb, features);
>         if (IS_ERR_OR_NULL(segs)) {
>                 skb_gso_error_unwind(skb, htons(ETH_P_NSH), nsh_len,
> -                                    skb->network_header - nhoff,
> -                                    mac_len);
> +                                    mac_offset, mac_len);
>                 goto out;
>         }
>

I do not think this patch is enough ?

This is still not nice, because mac_header =3D=3D 0xFFFF

nhoff =3D skb->network_header - skb->mac_header;
...
skb_set_mac_header(skb, -nhoff);

I would simply restore mac_header with "skb->mac_header =3D  mac_offset"
and get rid of nhoff.

(Accept the fact that GSO layer should not rely on skb mac_header being set=
)

In the future, we might be able to rewrite GSO without any assumptions
on skb->mac_header.

