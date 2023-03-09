Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9826B2823
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 16:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232231AbjCIPDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 10:03:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231985AbjCIPDL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 10:03:11 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9439EF4009
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 07:00:05 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id bg16-20020a05600c3c9000b003eb34e21bdfso3832965wmb.0
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 07:00:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678374004;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GuhiEyg3TRhHUVkG+NKXf46bKixySUYoSTIqBrMpU+M=;
        b=lX1PlFkAngKb7MFgPhVXevH8/WdulpngrDR+sczcPwIuo8+D3sbohyinmYLT+cI86F
         4DWd99PrTP7htcM5EsY4XhiJZaSpu5wZwinvhebXGHlZCmogZziTchD8C/EK5C6Zjv2+
         Gdo9rxnwwtsEYQCVAlFkBAutS+vKHjn8dxd3czJUvvcV9mz5ljBxRzbUm4PkmPqurjZm
         yKrRnk7I2VANZMHH96OnRvMG8jFE1rOop5Hn6UswGgB5N+A6ExyAuxKgx67OXs/UggIF
         aZcnD6H+ayT/2uiQKjIpm1xNN6gEr0LvARCpO+krOPhbXxHpdNOoZCke+Y5L2ubUtUBY
         8NpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678374004;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GuhiEyg3TRhHUVkG+NKXf46bKixySUYoSTIqBrMpU+M=;
        b=Cmvt6O+QRj+YbwtPJ9ScTAYr4CwiieVkNbvxDh3AYauVvHOmPq+6Rh8si285TlnMxK
         aYpJ/k9twkY+IzmlcIMfcttppsOMviZzVzXx3gzZwuPGxBdThvfnEZ/oQbHerT8ZXfNr
         6unRSy99BIerHP/d/vnCazJ8VFpm2fIDKLNkgxWgjsNiCR/jxMitR0/PlhdMuy/b+NOB
         BTJj9fEeylsJRLTiaNYl2+mFmRfH5Ci2aQDSKBDt+v7ic3SuclhQiyEl2P/t4q4Kfyik
         01R6oRjurZCPjcOs1rkCkfeOsaZdAe5j74IzJmf+CYIxKrNLEXCmVCC1ltH6e/BdEyx7
         N4tg==
X-Gm-Message-State: AO0yUKXONK0f9cyFZYdK0jCZUwD3xnPWznSpLp8Bjfdx3S0Wznj7v/Dc
        2KUTgSRzHEsnhaOhr9uWx68/h7fwo3iBnglFwIFPrQ==
X-Google-Smtp-Source: AK7set+YsrtV4FrTEitgWrBNKT+JMiShWnzq7diqZJ4gTWES+NP51LT+UJhZ6HLLRBytcazxtIeiB0JIjWMOe3NtAwI=
X-Received: by 2002:a05:600c:1:b0:3eb:5824:f0ec with SMTP id
 g1-20020a05600c000100b003eb5824f0ecmr5183814wmc.2.1678374003898; Thu, 09 Mar
 2023 07:00:03 -0800 (PST)
MIME-Version: 1.0
References: <20230309134718.306570-1-gavinl@nvidia.com> <20230309134718.306570-5-gavinl@nvidia.com>
In-Reply-To: <20230309134718.306570-5-gavinl@nvidia.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 9 Mar 2023 15:59:51 +0100
Message-ID: <CANn89i+k3fcSw58owpr70eM_uSM5QUqEb_4y5wpXOKEz30+vvg@mail.gmail.com>
Subject: Re: [PATCH net-next v6 4/5] ip_tunnel: Preserve pointer const in ip_tunnel_info_opts
To:     Gavin Li <gavinl@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        roopa@nvidia.com, eng.alaamohamedsoliman.am@gmail.com,
        bigeasy@linutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gavi@nvidia.com, roid@nvidia.com,
        maord@nvidia.com, saeedm@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 9, 2023 at 2:48=E2=80=AFPM Gavin Li <gavinl@nvidia.com> wrote:
>
> Change ip_tunnel_info_opts( ) from static function to macro to cast retur=
n
> value and preserve the const-ness of the pointer.
>
> Signed-off-by: Gavin Li <gavinl@nvidia.com>
> ---
>  include/net/ip_tunnels.h | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
> index fca357679816..3e5c102b841f 100644
> --- a/include/net/ip_tunnels.h
> +++ b/include/net/ip_tunnels.h
> @@ -67,6 +67,12 @@ struct ip_tunnel_key {
>         GENMASK((sizeof_field(struct ip_tunnel_info,            \
>                               options_len) * BITS_PER_BYTE) - 1, 0)
>
> +#define ip_tunnel_info_opts(info)                              \
> +       _Generic(info,                                          \
> +               const typeof(*(info)) * : ((const void *)((info) + 1)),\
> +               default : ((void *)((info) + 1))                \
> +       )
> +

Hmm...

This looks quite dangerous, we lost type safety with the 'default'
case, with all these casts.

What about using something cleaner instead ?

(Not sure why we do not have an available generic helper for this kind
of repetitive things)

diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index fca3576798166416982ee6a9100b003810c49830..7f26e07c5f3059d426b31529e4d=
1c3adec23d70f
100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -485,10 +485,11 @@ static inline void iptunnel_xmit_stats(struct
net_device *dev, int pkt_len)
        }
 }

-static inline void *ip_tunnel_info_opts(struct ip_tunnel_info *info)
-{
-       return info + 1;
-}
+#define ip_tunnel_info_opts(info)                              \
+       (_Generic(info,                                         \
+                const struct ip_tunnel_info * : ((info) + 1),  \
+                struct ip_tunnel_info * : ((info) + 1))        \
+       )

 static inline void ip_tunnel_info_opts_get(void *to,
                                           const struct ip_tunnel_info *inf=
o)
