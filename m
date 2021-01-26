Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9C43048FF
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 20:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387915AbhAZFe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:34:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731963AbhAZCDc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 21:03:32 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CCFFC0617AA
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 17:59:21 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id g3so20852676ejb.6
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 17:59:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=08iMGGpKuODrfWqFQKQRmo6F9SjaltCKrbo7GEjtWUE=;
        b=CZS664yGcMFKJ4sQ/9jCZdmE9DA8PtFUrH8oVdqjcTRLrPYn9qWTL26GOUA4KRLRJH
         1u8MEXIRpH+d9XJClK61W6pZU3Zq8qZR6cikweqVlynpcMPGBGjceai/HOLt9d/J3ErZ
         6jnQ6Wu6n03Sd7ulOUM8t8wracJN6q+4gD/NaLjXabo/GzMshjx+Q0OTY2viJpuwRUmZ
         oyB6nvrRW8GNr2Q59eD/jqIGO8XCEHmNDM5Dc9zMWUwgkqSPhHxAcVXDX8wxOypy9s5i
         Ddz/hktHinA6g5ut4Tail64pb2PvVGkYc6CyFAYEKZy96ue74q8fDE2wARMixtKEFRR/
         w1ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=08iMGGpKuODrfWqFQKQRmo6F9SjaltCKrbo7GEjtWUE=;
        b=ESLWDEu4NcrLXAs1Own/0X0NuWfJTb3WGdUEU8F80uvM+ys39iXFhjOza2HpBgqUfr
         d0ZWiuo5neEOU5yv2vQcNOaxkKTqGgjt5Rfi2Ow3T413Eq3EbCsXUVvT4nAMRSwT0WHv
         kogu6SKhpv4jvR/SlEXXrRQMRCRoSTgXCaTk8X3lHSIrfX0NkYELeNTuBYxBwomaFNAT
         XXtTHEjOlBElU5hsrL37ltIQZIRXvaKTQnTsPzUM0vHRv7yKOvs+hy6YkGAa2edPHZBo
         1wsn/41JdmTpDKgkcuAYRSyOD0XQNB/6Ycr6WmH6ppq2UynAAXjVWl4L1F0BogJk4G4S
         Oydw==
X-Gm-Message-State: AOAM530vQNEG+Ev6j3XhWBTU4WolCukVTh9QLRLJoy5zJTwUujQZwQ0c
        8AVxZAnNnImgdWaHTSB5HOzkcCVIx6zl32bJibE=
X-Google-Smtp-Source: ABdhPJwHKOOfVdZXE68csTknvspUQiRCEYTd90lJlDxUOD5yXswBqBkQHp/roFSRDK53YdcjdEhBO8dj+0kqhrenjtU=
X-Received: by 2002:a17:906:494c:: with SMTP id f12mr2115228ejt.56.1611626359786;
 Mon, 25 Jan 2021 17:59:19 -0800 (PST)
MIME-Version: 1.0
References: <cover.1611477858.git.lucien.xin@gmail.com> <100e0b32b0322e70127f415ea5b26afd26ac0fed.1611477858.git.lucien.xin@gmail.com>
In-Reply-To: <100e0b32b0322e70127f415ea5b26afd26ac0fed.1611477858.git.lucien.xin@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 25 Jan 2021 20:58:43 -0500
Message-ID: <CAF=yD-LPcS47BRbUXwyxipvbtGKB2bNmqZrQWGjYzjA4jptJKQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net: support ip generic csum processing in skb_csum_hwoffload_help
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Davide Caratti <dcaratti@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 24, 2021 at 3:47 AM Xin Long <lucien.xin@gmail.com> wrote:
>
> NETIF_F_IP|IPV6_CSUM feature flag indicates UDP and TCP csum offload
> while NETIF_F_HW_CSUM feature flag indicates ip generic csum offload
> for HW, which includes not only for TCP/UDP csum, but also for other
> protocols' csum like GRE's.
>
> However, in skb_csum_hwoffload_help() it only checks features against
> NETIF_F_CSUM_MASK(NETIF_F_HW|IP|IPV6_CSUM). So if it's a non TCP/UDP
> packet and the features doesn't support NETIF_F_HW_CSUM, but supports
> NETIF_F_IP|IPV6_CSUM only, it would still return 0 and leave the HW
> to do csum.
>
> This patch is to support ip generic csum processing by checking
> NETIF_F_HW_CSUM for all protocols, and check (NETIF_F_IP_CSUM |
> NETIF_F_IPV6_CSUM) only for TCP and UDP.
>
> v1->v2:
>   - not extend skb->csum_not_inet, but use skb->csum_offset to tell
>     if it's an UDP/TCP csum packet.
>
> Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/core/dev.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 6df3f1b..aae116d 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -3621,7 +3621,18 @@ int skb_csum_hwoffload_help(struct sk_buff *skb,
>                 return !!(features & NETIF_F_SCTP_CRC) ? 0 :
>                         skb_crc32c_csum_help(skb);
>
> -       return !!(features & NETIF_F_CSUM_MASK) ? 0 : skb_checksum_help(skb);
> +       if (features & NETIF_F_HW_CSUM)
> +               return 0;
> +
> +       if (features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM)) {
> +               switch (skb->csum_offset) {
> +               case offsetof(struct tcphdr, check):
> +               case offsetof(struct udphdr, check):

This relies on no other protocols requesting CHECKSUM_PARTIAL
with these csum_offset values.

That is a fragile assumption. It may well be correct, and Alex argues
that point in v1 of the patch. I think that argumentation at the least
should be captured as a comment or in the commit message.

Or perhaps limit this optimization over s/w checksumming to

  skb->sk &&
  (skb->sk->sk_family == AF_INET  || .. ) &&
  (skb->sk->sk_type == SOCK_STREAM || ..)

?
