Return-Path: <netdev+bounces-1186-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 38BF36FC84C
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 15:58:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 646171C20B98
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 13:58:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5572A19508;
	Tue,  9 May 2023 13:58:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A1F36116
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 13:58:14 +0000 (UTC)
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80C702D58
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 06:58:12 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id d75a77b69052e-3f38a9918d1so147781cf.1
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 06:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683640691; x=1686232691;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DSqntl2LwDgOi2CCdpxO/7xZ2YXwZ5Dx9RPSAsCTISo=;
        b=vKPIcx6ZkKkiLbCYPEDzkTCNBTwfk6x2XuEnmTTUegweL6A4DJ5ktTO3tspG7YUMtq
         3QNebSFIb3FUJvdcoIadOz9cCBEXRfwE4qmDt3OTY2dtMWGApM/33X0Av+edIQ4IN6IP
         3SSseJi+xy+iOWj5nCb4D9NHkQlOUl+UHCSE6d3xpjcz4qVesRUryIGULaLV9XhRUUG6
         Ja2Vft65Q5MDynFkf/0gx2GRYMFvX3hGKHCpW38aZpVNIjmuYtn0h3WrEHlaUGW9zLP3
         ipfSX0rMKT7oGMWEVWzBjDRb5G8ETKrDWUVQx9yRRghTmHl9JpgQ3sFpn8Cs0FGd3EWb
         jzoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683640691; x=1686232691;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DSqntl2LwDgOi2CCdpxO/7xZ2YXwZ5Dx9RPSAsCTISo=;
        b=GipEIiATjwJ6RQ+o+NnSp7xkSyXxK64jY6tST88jPvIB/HqG1VJFCq9owZkVds1vHq
         45LXIRbWGjBTCRvMaSJueyXA1+xztYZ2dK9cWHu4q+cWSNrm1l3pV1JGSXWMkkuHF6o+
         w5zeJTuzdiEXak4zX6ea63B108TiuAEN6zx4FTBluOg5c/sfm/TfKRoiDzO8td7xPoZf
         7ihLVb1e0TaTeJDtLNYm1xNqvHi5gsyM4aeXjtEPp/U0ztjddSbCutUUJF6Vw8OlgEn/
         CvcrSdT03Ma8S7YKQf6clI/7SEHGeXVfJmIMQjzf81eDLYjjEene5qvp7598OSHaA74r
         IhXg==
X-Gm-Message-State: AC+VfDw0IWEFRhj/01yhB7xTAbPm4NII8ZAGzCH3EnvlAwYg1M7DSWz/
	5qunVQNHx2HvvfEMwLutEmnxT15K6WQkej9xuG94XQ==
X-Google-Smtp-Source: ACHHUZ5abdauklrITK6bwGvP8T+6hrrpobSuHK87seRgis2rZzB2m1SpfEUSSNSfkBh1ZdhPohQ5FZcMV0OLEYUmwHA=
X-Received: by 2002:a05:622a:178e:b0:3ef:2f55:2204 with SMTP id
 s14-20020a05622a178e00b003ef2f552204mr452047qtk.6.1683640691222; Tue, 09 May
 2023 06:58:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230509135546.580158-1-dongchenchen2@huawei.com>
In-Reply-To: <20230509135546.580158-1-dongchenchen2@huawei.com>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 9 May 2023 15:57:58 +0200
Message-ID: <CANn89iLq7Mh6p=F=ygGa0=J=R6gDq4HDFYnLatdhgM_FEveFnQ@mail.gmail.com>
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
	autolearn=unavailable autolearn_force=no version=3.4.6
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
> --
> 2.25.1
>

