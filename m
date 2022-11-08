Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45B09620B4E
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 09:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233295AbiKHIgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 03:36:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbiKHIgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 03:36:31 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7DF562C3
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 00:36:30 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id 131so12164598ybl.3
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 00:36:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lA2oJkdjTCsoevm73jZOVIjH0fV00QfdtRkqj2W8k+Q=;
        b=hX+WJBcOgeXm37B89NGFF2CqrOzV5oL+Tyk2cFgV2bPSSlQ5G2PMgF7P7pIKPEVjkq
         sqm5+8AautDcnDCyreQaiz2ddFFr2jYPB8cokKqJMdQuZgIXjsGMluSuOSpnt2OJpm6x
         mtj6gKfOFoqeTz1MTjfSVvFLOgy6C2+dJseuPYtRjZirdQM5wn23m99drEvB0A/0OfJj
         7jm56BNsqi04ukd4Eb71G4MYQTEcC6Zl64a1sEhUWPUB1jECzGjkv+E86Le9oATS/+cK
         qkEU8khj8I3Nzp7jabRV2QHoqIjAYXlm1j9f9iYggQip2AwFh01LeV/uN1a4RriDSQKi
         qx6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lA2oJkdjTCsoevm73jZOVIjH0fV00QfdtRkqj2W8k+Q=;
        b=Ij+ocFgOEqZPKL8wBDW7OGAkpgrv4Us95gnxfGZttXVGfNd03ETsI5jMuw//zRLywq
         TzppKMCaqxslI2HnxQa9vxSWUnNmgBBgUMiDVQC6HZh2eO0/vfJQUUCEnf1HWhsibOru
         BKHufvS4kHleNwqttLIGPlMsY1aD63Ua06Zr8qPdnToM+6ACV/VW/dczypMkSemrEenc
         kgILYWFaSJs+j8YSZ2FQnpihCDb1itWOcGK9oqQJxOEoWiClOezBNRWAWUcJiP1pb5NF
         ShRV8yc4tJmipxGiWqjcfmd6O+VoWHxl+6ZxbkBgvLGm2xlfgt0rlnyeuZnvJFZeBlnX
         9Uog==
X-Gm-Message-State: ANoB5pktsHP8eHQ4Gj64hx7C6JjmEBYqzuqZnVhC5tX65F5Oj25TVCF9
        q365ukaO+E3I2EzgjF7EOsirYFmd3UyXWueZNrdJFCsk
X-Google-Smtp-Source: AA0mqf4hIRUI8JNXBTIoMMGkPd5jFdhWD5rRt9YzkJtLZoYQe/vuqpc93WqxfEGqaTp7jeXeNstPsrhF0TGW8mkvfoQ=
X-Received: by 2002:a25:748f:0:b0:6d4:f634:3be8 with SMTP id
 p137-20020a25748f000000b006d4f6343be8mr15910535ybc.235.1667896589637; Tue, 08
 Nov 2022 00:36:29 -0800 (PST)
MIME-Version: 1.0
References: <20221108014332.206517-1-benedictwong@google.com>
In-Reply-To: <20221108014332.206517-1-benedictwong@google.com>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Tue, 8 Nov 2022 10:36:18 +0200
Message-ID: <CAHsH6GubMoLBzDz=-0d5t9=HkU_iGHmH_gGNj4p4y+JzddcyVw@mail.gmail.com>
Subject: Re: [PATCH ipsec] Fix XFRM-I support for nested ESP tunnels
To:     Benedict Wong <benedictwong@google.com>
Cc:     netdev@vger.kernel.org, nharold@google.com, lorenzo@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Nov 8, 2022 at 4:31 AM Benedict Wong <benedictwong@google.com> wrote:
>
> This change adds support for nested IPsec tunnels by ensuring that
> XFRM-I verifies existing policies before decapsulating a subsequent
> policies. Addtionally, this clears the secpath entries after policies
> are verified, ensuring that previous tunnels with no-longer-valid
> do not pollute subsequent policy checks.
>
> This is necessary especially for nested tunnels, as the IP addresses,
> protocol and ports may all change, thus not matching the previous
> policies. In order to ensure that packets match the relevant inbound
> templates, the xfrm_policy_check should be done before handing off to
> the inner XFRM protocol to decrypt and decapsulate.
>
> Notably, raw ESP/AH packets did not perform policy checks inherently,
> whereas all other encapsulated packets (UDP, TCP encapsulated) do policy
> checks after calling xfrm_input handling in the respective encapsulation
> layer.
>
> Test: Verified with additional Android Kernel Unit tests
> Signed-off-by: Benedict Wong <benedictwong@google.com>
> ---
>  net/xfrm/xfrm_interface.c | 54 ++++++++++++++++++++++++++++++++++++---
>  net/xfrm/xfrm_policy.c    |  5 +++-
>  2 files changed, 54 insertions(+), 5 deletions(-)
>
> diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
> index 5113fa0fbcee..0c41ed112081 100644
> --- a/net/xfrm/xfrm_interface.c
> +++ b/net/xfrm/xfrm_interface.c
> @@ -207,6 +207,52 @@ static void xfrmi_scrub_packet(struct sk_buff *skb, bool xnet)
>         skb->mark = 0;
>  }
>
> +static int xfrmi_input(struct sk_buff *skb, int nexthdr, __be32 spi,
> +                      int encap_type, unsigned short family)
> +{
> +       struct sec_path *sp;
> +
> +       sp = skb_sec_path(skb);
> +       if (sp && (sp->len || sp->olen) &&
> +           !xfrm_policy_check(NULL, XFRM_POLICY_IN, skb, family))
> +               goto discard;
> +
> +       XFRM_SPI_SKB_CB(skb)->family = family;
> +       if (family == AF_INET) {
> +               XFRM_SPI_SKB_CB(skb)->daddroff = offsetof(struct iphdr, daddr);
> +               XFRM_TUNNEL_SKB_CB(skb)->tunnel.ip4 = NULL;
> +       } else {
> +               XFRM_SPI_SKB_CB(skb)->daddroff = offsetof(struct ipv6hdr, daddr);
> +               XFRM_TUNNEL_SKB_CB(skb)->tunnel.ip6 = NULL;
> +       }
> +
> +       return xfrm_input(skb, nexthdr, spi, encap_type);
> +discard:
> +       kfree_skb(skb);
> +       return 0;
> +}
> +
> +static int xfrmi4_rcv(struct sk_buff *skb)
> +{
> +       return xfrmi_input(skb, ip_hdr(skb)->protocol, 0, 0, AF_INET);
> +}
> +
> +static int xfrmi6_rcv(struct sk_buff *skb)
> +{
> +       return xfrmi_input(skb, skb_network_header(skb)[IP6CB(skb)->nhoff],
> +                          0, 0, AF_INET6);
> +}
> +
> +static int xfrmi4_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
> +{
> +       return xfrmi_input(skb, nexthdr, spi, encap_type, AF_INET);
> +}
> +
> +static int xfrmi6_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
> +{
> +       return xfrmi_input(skb, nexthdr, spi, encap_type, AF_INET6);
> +}
> +
>  static int xfrmi_rcv_cb(struct sk_buff *skb, int err)
>  {
>         const struct xfrm_mode *inner_mode;
> @@ -774,8 +820,8 @@ static struct pernet_operations xfrmi_net_ops = {
>  };
>
>  static struct xfrm6_protocol xfrmi_esp6_protocol __read_mostly = {
> -       .handler        =       xfrm6_rcv,
> -       .input_handler  =       xfrm_input,
> +       .handler        =       xfrmi6_rcv,
> +       .input_handler  =       xfrmi6_input,
>         .cb_handler     =       xfrmi_rcv_cb,
>         .err_handler    =       xfrmi6_err,
>         .priority       =       10,
> @@ -825,8 +871,8 @@ static struct xfrm6_tunnel xfrmi_ip6ip_handler __read_mostly = {
>  #endif
>
>  static struct xfrm4_protocol xfrmi_esp4_protocol __read_mostly = {
> -       .handler        =       xfrm4_rcv,
> -       .input_handler  =       xfrm_input,
> +       .handler        =       xfrmi4_rcv,
> +       .input_handler  =       xfrmi4_input,
>         .cb_handler     =       xfrmi_rcv_cb,
>         .err_handler    =       xfrmi4_err,
>         .priority       =       10,
> diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
> index f1a0bab920a5..04f66f6d5729 100644
> --- a/net/xfrm/xfrm_policy.c
> +++ b/net/xfrm/xfrm_policy.c
> @@ -3516,7 +3516,7 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
>         int xerr_idx = -1;
>         const struct xfrm_if_cb *ifcb;
>         struct sec_path *sp;
> -       struct xfrm_if *xi;
> +       struct xfrm_if *xi = NULL;
>         u32 if_id = 0;
>
>         rcu_read_lock();
> @@ -3667,6 +3667,9 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
>                         goto reject;
>                 }
>
> +               if (xi)
> +                       secpath_reset(skb);
> +

This is different in the current kernel. "xi" no longer exists here.
I think the equivalent check would be to see if if_id isn't zero.

Eyal.


>                 xfrm_pols_put(pols, npols);
>                 return 1;
>         }
> --
> 2.38.1.431.g37b22c650d-goog
>
