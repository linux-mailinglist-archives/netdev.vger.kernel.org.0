Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0696E6DD78C
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 12:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbjDKKKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 06:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbjDKKKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 06:10:02 -0400
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A0F40DD
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 03:09:48 -0700 (PDT)
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-54f21cdfadbso97678047b3.7
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 03:09:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681207788; x=1683799788;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BKkkTWdmqnDeL3trplGIfOBh7GtVSi++2YpMkx96S/g=;
        b=xlJF0FdzQCBwia4tWBebhrvr8TqsZccEb6RzigOjOK8vf7rCp2L/Bi+e6u4krHyXgi
         1X/x9EI2Ak6QEHOp8I3jpevNdN1Kb2pDJ79N0rI2z6nUhnwJF4jznkKTS2DqmzeANmCm
         yE0dh/m29qX+mL5q6Im4eVevPAnqgNu11USIt1QwqakJGnjB7x1AxXvbt6oYGWE/Avkk
         nM1fwwtsrHvjJWjiAKSRorzjyOETMAF689ZjOIfL57pOKhXlCS6jHC/fb3klZyGHQBJC
         UQXPeI+cebeankE3ADeT9pMxZWwc6BToaUyszFx2ZMmbI4I2AfP03rvwA5Q8zB1B0PBW
         W7ng==
X-Gm-Message-State: AAQBX9eQ0zqDtC4mPu+D61cn5Wb3cm5bsWiSSELqSCGWuRHcyaZRpD9/
        VuKkEVcRcAoNAnd2somkm1WAGska0Nv7qw==
X-Google-Smtp-Source: AKy350bS0SNovVEzxgTeV9WuYgLu58M1MSzm9lc1Nv3gImUPRjHdFyNo2H3mu1Uk4O8ndMCup4JZXg==
X-Received: by 2002:a0d:d8d1:0:b0:54d:c121:6c88 with SMTP id a200-20020a0dd8d1000000b0054dc1216c88mr1865228ywe.20.1681207787760;
        Tue, 11 Apr 2023 03:09:47 -0700 (PDT)
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com. [209.85.128.171])
        by smtp.gmail.com with ESMTPSA id x206-20020a0dd5d7000000b00545a08184d6sm3355243ywd.102.2023.04.11.03.09.46
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Apr 2023 03:09:46 -0700 (PDT)
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-54bfa5e698eso302115367b3.13
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 03:09:46 -0700 (PDT)
X-Received: by 2002:a81:ae57:0:b0:54e:dbe5:933b with SMTP id
 g23-20020a81ae57000000b0054edbe5933bmr5537987ywk.8.1681207786343; Tue, 11 Apr
 2023 03:09:46 -0700 (PDT)
MIME-Version: 1.0
References: <20230410233509.7616-1-stephen@networkplumber.org>
In-Reply-To: <20230410233509.7616-1-stephen@networkplumber.org>
From:   Luca Boccassi <bluca@debian.org>
Date:   Tue, 11 Apr 2023 11:09:35 +0100
X-Gmail-Original-Message-ID: <CAMw=ZnSzun2idW4LTozFPbAzU_vK=Lg1WN4tYTf2B2HsSDzB4g@mail.gmail.com>
Message-ID: <CAMw=ZnSzun2idW4LTozFPbAzU_vK=Lg1WN4tYTf2B2HsSDzB4g@mail.gmail.com>
Subject: Re: [PATCH iproute2] iptunnel: detect protocol mismatch on tunnel change
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.5 required=5.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 11 Apr 2023 at 00:35, Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> If attempt is made to change an IPv6 tunnel by using IPv4
> parameters, a stack overflow would happen and garbage request
> would be passed to kernel.
>
> Example:
> ip tunnel add gre1 mode ip6gre local 2001:db8::1 remote 2001:db8::2 ttl 255
> ip tunnel change gre1 mode gre local 192.168.0.0 remote 192.168.0.1 ttl 255
>
> The second command should fail because it attempting set IPv4 addresses
> on a GRE tunnel that is IPv6.
>
> Do best effort detection of this mismatch by giving a bigger buffer to get
> tunnel request, and checking that the IP header is IPv4. It is still possible
> but unlikely that byte would match in IPv6 tunnel paramater, but good enough
> to catch the obvious cases.
>
> Bug-Debian: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1032642
> Reported-by: Robin <imer@imer.cc>
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
> ---
>  ip/iptunnel.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/ip/iptunnel.c b/ip/iptunnel.c
> index 02c3670b469d..b6da145913d6 100644
> --- a/ip/iptunnel.c
> +++ b/ip/iptunnel.c
> @@ -17,6 +17,7 @@
>  #include <net/if_arp.h>
>  #include <linux/ip.h>
>  #include <linux/if_tunnel.h>
> +#include <linux/ip6_tunnel.h>
>
>  #include "rt_names.h"
>  #include "utils.h"
> @@ -172,11 +173,20 @@ static int parse_args(int argc, char **argv, int cmd, struct ip_tunnel_parm *p)
>                         if (get_ifname(p->name, *argv))
>                                 invarg("\"name\" not a valid ifname", *argv);
>                         if (cmd == SIOCCHGTUNNEL && count == 0) {
> -                               struct ip_tunnel_parm old_p = {};
> +                               union {
> +                                       struct ip_tunnel_parm ip_tnl;
> +                                       struct ip6_tnl_parm2 ip6_tnl;
> +                               } old_p = {};
>
>                                 if (tnl_get_ioctl(*argv, &old_p))
>                                         return -1;
> -                               *p = old_p;
> +
> +                               if (old_p.ip_tnl.iph.version != 4 ||
> +                                   old_p.ip_tnl.iph.ihl != 5)
> +                                       invarg("\"name\" is not an ip tunnel",
> +                                              *argv);
> +
> +                               *p = old_p.ip_tnl;
>                         }
>                 }
>                 count++;

Tested-by: Luca Boccassi <bluca@debian.org>

Can confirm it doesn't crash anymore, thanks.
