Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F109287225
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 12:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729369AbgJHKBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 06:01:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbgJHKBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 06:01:40 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E7B7C061755;
        Thu,  8 Oct 2020 03:01:39 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id j136so5875752wmj.2;
        Thu, 08 Oct 2020 03:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5FMwqEysj71xGZc3vvhV5fgnvajcS5sw4lmVrAr2enY=;
        b=uqSgo9yIzV1QwZLucpJE/Lobd+a4bUm9KbsD0UJ8CQgBOyOmJ9ME8ZrMmwZq5u1oV2
         t2s3oXfGf5V4mgJsA8IZXvXWc0HvzQkz26cMJR7v+S6knxUGSG3ZgA0TcmPL8e9efBKN
         AB+jb/KTclcVAGmYgkocuHlW/EhC6kXa1ijGvRPK10UoATAAqVMm6iFkiNo3NGFOJRpN
         RoEr5ww9DYQKrOX5fLn5JmytBzlWof8a8WclYO7ZvhURBlcJ86rnrwAg8MEnWhliEF7d
         Rc4ciRyQWmwSLWqk7jCkOP9qN1Dqy3myMAtyvRh9qNzWmPF3UmzKDJUo56rCas8beTTb
         CCjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5FMwqEysj71xGZc3vvhV5fgnvajcS5sw4lmVrAr2enY=;
        b=ngSD2YbAxijH40ghruvWHWihvk8WX2qyfppA5EY8hACcXHBuG8N87fzuF0XNgjgRWy
         MgQU/9nqyndT8t6ZlwWrQWkKBZLdkutIKkfNYUORDbcL5pG2UMTpdcjbtxb/CxGu8TtN
         vgqAEed1MfnSlRXaI87Vp+wIYwezsGBekGFhWn6FVptrR7NMw4y09C3VzcXKhb6Ye6W1
         QzkB5XfSJ8wfRfsPaDT44mFrtlX+E1NbqR/s+d6XF02YB4xARCUoKhuwq16ve17QhrKS
         29zO6Z3EgFwhfBLY1OLAmES5LhMe4MkpUQKtbiTpni0Llpde8GNhleFUdA/P183qGqAn
         bZGQ==
X-Gm-Message-State: AOAM533qSnVRoR02DlByrvcnrf/d5fJQ3+kVLqD/sgdvFWBaO7Dpv6yY
        pFWS7JbJboxLp5RGrNd5DMyQ6XKQs0li5+cMAS1BGSIFFPE=
X-Google-Smtp-Source: ABdhPJxKHT7mecyhrjG8S633VieOm3I6adQoltxR4KiOmPyLb2uwCtfDzbfFZXzvK6A+1FCj90BBZllhcr6YxrcOfTY=
X-Received: by 2002:a1c:4683:: with SMTP id t125mr8119995wma.110.1602151298123;
 Thu, 08 Oct 2020 03:01:38 -0700 (PDT)
MIME-Version: 1.0
References: <052acb63198c44df41c5db17f8397eeb7c8bacfe.1602150362.git.lucien.xin@gmail.com>
 <cover.1602150362.git.lucien.xin@gmail.com> <c36b016ee429980b9585144f4f9af31bcda467ee.1602150362.git.lucien.xin@gmail.com>
 <483d9eec159b22172fe04dacd58d7f88dfc2f301.1602150362.git.lucien.xin@gmail.com>
In-Reply-To: <483d9eec159b22172fe04dacd58d7f88dfc2f301.1602150362.git.lucien.xin@gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 8 Oct 2020 18:01:06 +0800
Message-ID: <CADvbK_fwrM627cxt59SDkS5uuaRsDhpZ2X_BZsqdHJ9D8t+H+A@mail.gmail.com>
Subject: Re: [PATCHv2 net-next 03/17] udp: do checksum properly in skb_udp_tunnel_segment
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>,
        davem <davem@davemloft.net>, Tom Herbert <tom@herbertland.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CCing Tom Herbert

On Thu, Oct 8, 2020 at 5:48 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> This patch fixes two things:
>
>   When skb->ip_summed == CHECKSUM_PARTIAL, skb_checksum_help() should be
>   called do the checksum, instead of gso_make_checksum(), which is used
>   to do the checksum for current proto after calling skb_segment(), not
>   after the inner proto's gso_segment().
>
>   When offload_csum is disabled, the hardware will not do the checksum
>   for the current proto, udp. So instead of calling gso_make_checksum(),
>   it should calculate checksum for udp itself.
>
> Cc: Tom Herbert <tom@herbertland.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/ipv4/udp_offload.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
> index e67a66f..c0b010b 100644
> --- a/net/ipv4/udp_offload.c
> +++ b/net/ipv4/udp_offload.c
> @@ -131,14 +131,15 @@ static struct sk_buff *__skb_udp_tunnel_segment(struct sk_buff *skb,
>                 uh->check = ~csum_fold(csum_add(partial,
>                                        (__force __wsum)htonl(len)));
>
> -               if (skb->encapsulation || !offload_csum) {
> -                       uh->check = gso_make_checksum(skb, ~uh->check);
> -                       if (uh->check == 0)
> -                               uh->check = CSUM_MANGLED_0;
> -               } else {
> +               if (skb->encapsulation)
> +                       skb_checksum_help(skb);
> +
> +               if (offload_csum) {
>                         skb->ip_summed = CHECKSUM_PARTIAL;
>                         skb->csum_start = skb_transport_header(skb) - skb->head;
>                         skb->csum_offset = offsetof(struct udphdr, check);
> +               } else {
> +                       uh->check = csum_fold(skb_checksum(skb, udp_offset, len, 0));
>                 }
>         } while ((skb = skb->next));
>  out:
> --
> 2.1.0
>
