Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A981287229
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 12:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729375AbgJHKBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 06:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbgJHKBu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 06:01:50 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0AAAC061755;
        Thu,  8 Oct 2020 03:01:49 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id t10so5924969wrv.1;
        Thu, 08 Oct 2020 03:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Rf6hiQq+XBy2aIipkF7GA9xgrKFGeu4n6llBz8tM80k=;
        b=ZenBlSGf+xFYPaVH5003iGdKWDY4VZXYfyw76/ODWleKqt7E8Hug2ThaSA4ix++uBn
         Ln0vCsWyQDR6otvyx5s3A6okVexkKGFrd/oYp92WqN8RtsHgO8xpHTuMwI4mkbe2aGyL
         03pA4lL5ay0Kc4wmBDRxa+224OF00fVupcYetDzM2nSeg6Iz/69PmLbb4GESoiXftX0c
         R7zHPqTMrxbRomaLRQc5cOITUyU/KdtQf4Z0/k/1bW101Ad21deDi1h9O5lNocDpfZjH
         8vcCSD3vqeobGTWZIttPFOGzKMTHwDBG1l97TDzX7pPue01pt+2xcVcSImfPQMRoabcW
         N+XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Rf6hiQq+XBy2aIipkF7GA9xgrKFGeu4n6llBz8tM80k=;
        b=cK9ZsqLYSPriijChyf6fRvwtu91ivfm3FbZt0sCKTL7e+cC9OGQZ3W99DoFDGjrFiS
         9fsHUnZFkwmVWOTUBTcTEXMG3cpq94QQW9inUOT/ebBW30fn/ofsuW+G3jgdmBwnDlI9
         Mkovdb6nY31hz2lCYhEKmyVQSvLZf2TO6DyumnUJQMVqgnGsevACx1Kxi9MU8LWHxjwt
         cRuCJ/tC4vhrYTwrj6EtHafiObE/OvNnTRJ4o+6cWdydkh3l8iKm9joGx3FC+qd4wHlD
         vsW++I1u5V0m9jJaQ+mvNFRYZpppSH7aEHDJiEzQlPv4k1n8sp59L0aMofQeetViZ2JZ
         jMug==
X-Gm-Message-State: AOAM5310psPGiHzKBiS78j8QkxOXFxAjVdP/F9s/iDrKbPRTa+J+aUhz
        K5WbHaSRV65ScFKuoWImIrsl4IbV1vUJZbwj32IjTYbGFkY=
X-Google-Smtp-Source: ABdhPJzMPMlDeIJOEW9USMHoIeZyo1tJ42VGz/tB+idvlesq+cP1PfP15ef3PFt+rGHisW4hPtPM8iPvWk4JoetE6rI=
X-Received: by 2002:a5d:5748:: with SMTP id q8mr8315185wrw.299.1602151308309;
 Thu, 08 Oct 2020 03:01:48 -0700 (PDT)
MIME-Version: 1.0
References: <052acb63198c44df41c5db17f8397eeb7c8bacfe.1602150362.git.lucien.xin@gmail.com>
 <c36b016ee429980b9585144f4f9af31bcda467ee.1602150362.git.lucien.xin@gmail.com>
 <cover.1602150362.git.lucien.xin@gmail.com> <483d9eec159b22172fe04dacd58d7f88dfc2f301.1602150362.git.lucien.xin@gmail.com>
 <17cab00046ea7fe36c8383925a4fc3fbc028c511.1602150362.git.lucien.xin@gmail.com>
In-Reply-To: <17cab00046ea7fe36c8383925a4fc3fbc028c511.1602150362.git.lucien.xin@gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 8 Oct 2020 18:01:35 +0800
Message-ID: <CADvbK_c7Ez6jzLpo5TgKL1r6ebcthU+jztw1oDP9h0xbcAx1Cg@mail.gmail.com>
Subject: Re: [PATCHv2 net-next 04/17] udp: support sctp over udp in skb_udp_tunnel_segment
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
> To call sctp_gso_segment() properly in skb_udp_tunnel_segment() for sctp
> over udp packets, we need to set transport_header to sctp header. When
> skb->ip_summed == CHECKSUM_PARTIAL, skb_crc32c_csum_help() should be
> called for the inner sctp packet.
>
> Cc: Tom Herbert <tom@herbertland.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/ipv4/udp_offload.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
> index c0b010b..a484405 100644
> --- a/net/ipv4/udp_offload.c
> +++ b/net/ipv4/udp_offload.c
> @@ -49,6 +49,7 @@ static struct sk_buff *__skb_udp_tunnel_segment(struct sk_buff *skb,
>         __skb_pull(skb, tnl_hlen);
>         skb_reset_mac_header(skb);
>         skb_set_network_header(skb, skb_inner_network_offset(skb));
> +       skb_set_transport_header(skb, skb_inner_transport_offset(skb));
>         skb->mac_len = skb_inner_network_offset(skb);
>         skb->protocol = new_protocol;
>
> @@ -131,8 +132,12 @@ static struct sk_buff *__skb_udp_tunnel_segment(struct sk_buff *skb,
>                 uh->check = ~csum_fold(csum_add(partial,
>                                        (__force __wsum)htonl(len)));
>
> -               if (skb->encapsulation)
> -                       skb_checksum_help(skb);
> +               if (skb->encapsulation) {
> +                       if (skb->csum_not_inet)
> +                               skb_crc32c_csum_help(skb);
> +                       else
> +                               skb_checksum_help(skb);
> +               }
>
>                 if (offload_csum) {
>                         skb->ip_summed = CHECKSUM_PARTIAL;
> --
> 2.1.0
>
