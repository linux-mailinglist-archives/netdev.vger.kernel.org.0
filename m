Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88FCE665F97
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 16:48:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239398AbjAKPsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 10:48:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239364AbjAKPrn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 10:47:43 -0500
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A58E392EC
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 07:44:32 -0800 (PST)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-4d0f843c417so86310507b3.7
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 07:44:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jab6oIU+d7nh/HCG7p9Q+mV4z+9I+vSbLspe/IwR6NQ=;
        b=TjXTbsX0RPFT5TKtVkfQVwXPGZ6XVErmSjqakRPrBadWJKp9lxPkTbM6HiJ5U1B9ki
         hoWDpgd7bsmahjPfPKynzrS2D9yrmJIypcrGc2cp2mIdMkqbrIRCqYrucYYuBj6jSYrh
         Onwguu+OFQfmhR8EclgcH2sDd3P57mkKXP5xxJqF+4QTP2oQzUzK+1DaCvnHA9yHtq2t
         8xZxU+OC5hNKwomy8iCsAW7zcFdUgNHsLEeUvlFIOhZ67LFcpHAc6SK59ja9mZEZl23X
         rF5F963wrFqUc660nKc8MjOcuYr1k3MgYf8uX3Vvflro2v08hJ6Z+iUpq6sNljR0Iqar
         eW7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jab6oIU+d7nh/HCG7p9Q+mV4z+9I+vSbLspe/IwR6NQ=;
        b=0pOnwMv4a/U4IRoZPQPHkRXB5XvaIa3TaE1Yt5Hdy6DLRRM3F890PZViLzf+WaFCOr
         y6mgk+Rg59dwKcm33D9WXDJZX/pkyHt7YG7Wq8wnfRjWzoH0Mzd6iFMvHSW1h46vjnhf
         YemKO7XfhGNmKoT7hyBqn/c5lWBl3CJJ/n2pGsY4/xQC/GXE5Lbwvpumv6ficey+l0rQ
         7qNgbxqOKgGJMAraiySKpO7XjEKJRJbi3WBX/MQWgUvFySGPW7stzUp6UMnoMfv+n+gk
         i8MvC8VaxKlcnwixnivGGfl0oBSgFyO/DWbvmM+vUDMcUSqRS48unLfUehFURgYH8ZOh
         fzKw==
X-Gm-Message-State: AFqh2kr2PgqPBgqFZ3UkeP+Mww6iE+wNXyOWkINFpj+4ZwzmnkZ6j9Nu
        JI+4IJRrMVsZplc7XfnAPOurHviuhQZUP3UGMhqY/b62aaMeLrX9
X-Google-Smtp-Source: AMrXdXs2Es6S5GRw4U9xcdK05+efdlU/UK9pFU+J5jTfzQO1VhLoQb0vK24TXage0QJs4W7ahnonnsGdiTTD88dml20=
X-Received: by 2002:a0d:f846:0:b0:3f6:489a:a06f with SMTP id
 i67-20020a0df846000000b003f6489aa06fmr15964ywf.470.1673451869354; Wed, 11 Jan
 2023 07:44:29 -0800 (PST)
MIME-Version: 1.0
References: <cover.1673423199.git.william.xuanziyang@huawei.com> <b231c7d0acacd702284158cd44734e72ef661a01.1673423199.git.william.xuanziyang@huawei.com>
In-Reply-To: <b231c7d0acacd702284158cd44734e72ef661a01.1673423199.git.william.xuanziyang@huawei.com>
From:   Willem de Bruijn <willemb@google.com>
Date:   Wed, 11 Jan 2023 10:43:52 -0500
Message-ID: <CA+FuTSfGDdXTGZsjK+NhZmzirawh+09HF4v-5Cr1+4boxfqnXQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/2] bpf: Add ipip6 and ip6ip decap support
 for bpf_skb_adjust_room()
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 11, 2023 at 3:01 AM Ziyang Xuan
<william.xuanziyang@huawei.com> wrote:
>
> Add ipip6 and ip6ip decap support for bpf_skb_adjust_room().
> Main use case is for using cls_bpf on ingress hook to decapsulate
> IPv4 over IPv6 and IPv6 over IPv4 tunnel packets.
>
> Add two new flags BPF_F_ADJ_ROOM_DECAP_L3_IPV{4,6} to indicate the
> new IP header version after decapsulating the outer IP header.
>
> Suggested-by: Willem de Bruijn <willemb@google.com>
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> ---
>  include/uapi/linux/bpf.h       |  8 ++++++++
>  net/core/filter.c              | 26 +++++++++++++++++++++++++-
>  tools/include/uapi/linux/bpf.h |  8 ++++++++
>  3 files changed, 41 insertions(+), 1 deletion(-)
>
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 464ca3f01fe7..dde1c2ea1c84 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -2644,6 +2644,12 @@ union bpf_attr {
>   *               Use with BPF_F_ADJ_ROOM_ENCAP_L2 flag to further specify the
>   *               L2 type as Ethernet.
>   *
> + *              * **BPF_F_ADJ_ROOM_DECAP_L3_IPV4**,
> + *                **BPF_F_ADJ_ROOM_DECAP_L3_IPV6**:
> + *                Indicate the new IP header version after decapsulating the
> + *                outer IP header. Mainly used in scenarios that the inner and
> + *                outer IP versions are different.
> + *

Nit (only since I have another comment below)

Indicate -> Set
[Mainly used .. that] -> [Used when]

>         if (skb_is_gso(skb)) {
>                 struct skb_shared_info *shinfo = skb_shinfo(skb);
>
> @@ -3596,6 +3609,10 @@ BPF_CALL_4(bpf_skb_adjust_room, struct sk_buff *, skb, s32, len_diff,
>         if (unlikely(proto != htons(ETH_P_IP) &&
>                      proto != htons(ETH_P_IPV6)))
>                 return -ENOTSUPP;
> +       if (unlikely((shrink && ((flags & BPF_F_ADJ_ROOM_DECAP_L3_MASK) ==
> +                     BPF_F_ADJ_ROOM_DECAP_L3_MASK)) || (!shrink &&
> +                     flags & BPF_F_ADJ_ROOM_DECAP_L3_MASK)))
> +               return -EINVAL;
>
>         off = skb_mac_header_len(skb);
>         switch (mode) {
> @@ -3608,6 +3625,13 @@ BPF_CALL_4(bpf_skb_adjust_room, struct sk_buff *, skb, s32, len_diff,
>                 return -ENOTSUPP;
>         }
>
> +       if (shrink) {
> +               if (flags & BPF_F_ADJ_ROOM_DECAP_L3_IPV6)
> +                       len_min = sizeof(struct ipv6hdr);
> +               else if (flags & BPF_F_ADJ_ROOM_DECAP_L3_IPV4)
> +                       len_min = sizeof(struct iphdr);
> +       }
> +

How about combining this branch with the above:

  if (flags & BPF_F_ADJ_ROOM_DECAP_L3_MASK) {
    if (!shrink)
      return -EINVAL;

    switch (flags & BPF_F_ADJ_ROOM_DECAP_L3_MASK) {
      case BPF_F_ADJ_ROOM_DECAP_L3_IPV4:
        len_min = sizeof(struct iphdr);
        break;
      case BPF_F_ADJ_ROOM_DECAP_L3_IPV6:
        len_min = sizeof(struct ipv6hdr);
        break;
      default:
        return -EINVAL;
    }
