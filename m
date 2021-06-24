Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15BBA3B3906
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 00:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232684AbhFXWEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 18:04:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232582AbhFXWE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 18:04:28 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A9F1C061574
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 15:02:08 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id df12so10707020edb.2
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 15:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PsZE8mD9zSPdZNd+K5jCsTbgOhuxBwJ3RN5cShql5N0=;
        b=TZBE930uiHwjwH1dh6ACupdXB0NxYA+LWFCm4akgMiTj8cY/zoT9kFO/53Gzrm1mX9
         mA5E5In3JEJlltQXmNA1XKYEojZpUIuD6kbwAHFFtWsDdjvis8J2ao56zHy3P74Kl5Hj
         DQnteEyUPPfb7fH7TwvMkZm1OKAeqLLB1gqgEvoAvqlEtmcAERh7Z0TKj84OUxPzrtcp
         KubfwZ2oBahNYOoAV9FJsrtTSQq5dNMaN/ltWL1i8imuzLEvj6XRYXDX47zV4d8S8ypZ
         WOvKwKWjM2pYmxmFJueLFlBsrALYQGS6LL8GrTaqDoZE7i4X6Qlb5PDMVXwxVtfFKEg9
         oY/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PsZE8mD9zSPdZNd+K5jCsTbgOhuxBwJ3RN5cShql5N0=;
        b=UbKb5RcM3pHv0XybsPkJXTxfJbJHIFd3n/ez+nJR9sUpUJ9I+JNDUMln35KI8ka6U+
         LSuCfuc5FUrbUOcyR+7QqnFsF6cmPvWzGajTk4Bu2A93cR0ViZ+zXa7qOxDbzpE5TklJ
         XcgP4NDVvL23a9Ujvi88yz4UtVQU3lgXtEO4iqw5by/1a1al+xPF77JukaDwGz++2Ycr
         LG5i/3Dz1DnHqhMg4ZqT+ZCADC86mp64bQktdPKmv99VDPVuB/KcJ91UVTchcr7oUaKi
         ZHww0AsoQPLnlYiSjVx0QbWmCbER38COMl/LNoKwMmI/SfqheAXnveYCZIS4fE8KZrKN
         jn2g==
X-Gm-Message-State: AOAM533BO+YLlnBsosp4zW5X57+Tz1XeqjgkoisvEKGpwglyzb9rCgS7
        pVYys9ES7fidl/x0d5OOM5EEEnWr7niASQ==
X-Google-Smtp-Source: ABdhPJyR3t/vP+QZtJvMnH4o8npSib6kzSU6B9XhYGaDpOA6MLo77/k2KYJeVKu9sjQAo85w4OUE1A==
X-Received: by 2002:a05:6402:406:: with SMTP id q6mr10100529edv.149.1624572126609;
        Thu, 24 Jun 2021 15:02:06 -0700 (PDT)
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com. [209.85.221.47])
        by smtp.gmail.com with ESMTPSA id u21sm941410edv.20.2021.06.24.15.02.05
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jun 2021 15:02:05 -0700 (PDT)
Received: by mail-wr1-f47.google.com with SMTP id e22so8346131wrc.1
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 15:02:05 -0700 (PDT)
X-Received: by 2002:a5d:6209:: with SMTP id y9mr7196340wru.50.1624572124555;
 Thu, 24 Jun 2021 15:02:04 -0700 (PDT)
MIME-Version: 1.0
References: <4971c41fb298b1f7c7b72fb5d8863502319e3fcb.1624560898.git.andreas.a.roeseler@gmail.com>
In-Reply-To: <4971c41fb298b1f7c7b72fb5d8863502319e3fcb.1624560898.git.andreas.a.roeseler@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 24 Jun 2021 18:01:27 -0400
X-Gmail-Original-Message-ID: <CA+FuTScQW+1JyN0ROjgY+QWAw-ZWg0iztt5s2S6-Sqtj6XSqQQ@mail.gmail.com>
Message-ID: <CA+FuTScQW+1JyN0ROjgY+QWAw-ZWg0iztt5s2S6-Sqtj6XSqQQ@mail.gmail.com>
Subject: Re: [PATCH net-next V2 1/1] ipv6: ICMPV6: add response to ICMPV6 RFC
 8335 PROBE messages
To:     Andreas Roeseler <andreas.a.roeseler@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        willemdebruijn.kernel@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 24, 2021 at 3:04 PM Andreas Roeseler
<andreas.a.roeseler@gmail.com> wrote:
>
> This patch builds off of commit 2b246b2569cd2ac6ff700d0dce56b8bae29b1842
> and adds functionality to respond to ICMPV6 PROBE requests.

No need to structure as a series (1/1) if a single patch, btw.

> Add icmp_build_probe function to construct PROBE requests for both
> ICMPV4 and ICMPV6.
>
> Modify icmpv6_rcv to detect ICMPV6 PROBE messages and call the
> icmpv6_echo_reply handler.
>
> Modify icmpv6_echo_reply to build a PROBE response message based on the
> queried interface.
>
> This patch has been tested using a branch of the iputils git repo which can
> be found here: https://github.com/Juniper-Clinic-2020/iputils/tree/probe-request
>
> Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
> ---
> Changes:
> v1 -> v2:
> Suggested by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> - Do not add sysctl for ICMPV6 PROBE control and instead use existing
>   ICMPV4 sysctl.
> - Add icmp_build_probe function to construct PROBE responses for both
>   ICMPV4 and ICMPV6.
> ---
>  include/net/icmp.h |   1 +
>  net/ipv4/icmp.c    | 101 +++++++++++++++++++++++++++------------------
>  net/ipv6/icmp.c    |  24 +++++++++--
>  3 files changed, 83 insertions(+), 43 deletions(-)
>
> diff --git a/include/net/icmp.h b/include/net/icmp.h
> index fd84adc47963..caddf4a59ad1 100644
> --- a/include/net/icmp.h
> +++ b/include/net/icmp.h
> @@ -57,5 +57,6 @@ int icmp_rcv(struct sk_buff *skb);
>  int icmp_err(struct sk_buff *skb, u32 info);
>  int icmp_init(void);
>  void icmp_out_count(struct net *net, unsigned char type);
> +bool icmp_build_probe(struct sk_buff *skb, struct icmphdr *icmphdr);
>
>  #endif /* _ICMP_H */
> diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
> index 0a57f1892e7e..27a6fa29e2d3 100644
> --- a/net/ipv4/icmp.c
> +++ b/net/ipv4/icmp.c
> @@ -977,56 +977,37 @@ static bool icmp_redirect(struct sk_buff *skb)
>         return true;
>  }
>
> -/*
> - *     Handle ICMP_ECHO ("ping") and ICMP_EXT_ECHO ("PROBE") requests.
> +/*     Helper for icmp_echo and icmpv6_echo_reply.
> + *     Searches for net_device that matches PROBE interface identifier
> + *             and builds PROBE reply message in icmphdr.
>   *
> - *     RFC 1122: 3.2.2.6 MUST have an echo server that answers ICMP echo
> - *               requests.
> - *     RFC 1122: 3.2.2.6 Data received in the ICMP_ECHO request MUST be
> - *               included in the reply.
> - *     RFC 1812: 4.3.3.6 SHOULD have a config option for silently ignoring
> - *               echo requests, MUST have default=NOT.
> - *     RFC 8335: 8 MUST have a config option to enable/disable ICMP
> - *               Extended Echo Functionality, MUST be disabled by default
> - *     See also WRT handling of options once they are done and working.
> + *     Returns false if PROBE responses are disabled via sysctl
>   */
>
> -static bool icmp_echo(struct sk_buff *skb)
> +bool icmp_build_probe(struct sk_buff *skb, struct icmphdr *icmphdr)

It's a bit unusual, but I suggest moving this helper below icmp_echo,
to reduce patch size and make the patch a bit more readable:

$ git show --stat | grep changed
 3 files changed, 83 insertions(+), 43 deletions(-)

After move:

$ git diff HEAD~1 --stat | grep changed
 3 files changed, 61 insertions(+), 22 deletions(-)


>  {
>         struct icmp_ext_hdr *ext_hdr, _ext_hdr;
>         struct icmp_ext_echo_iio *iio, _iio;
> -       struct icmp_bxm icmp_param;
> +       struct net *net = dev_net(skb->dev);
>         struct net_device *dev;
>         char buff[IFNAMSIZ];
> -       struct net *net;
>         u16 ident_len;
>         u8 status;
>
> -       net = dev_net(skb_dst(skb)->dev);
> -       /* should there be an ICMP stat for ignored echos? */
> -       if (net->ipv4.sysctl_icmp_echo_ignore_all)
> -               return true;
> -
> -       icmp_param.data.icmph      = *icmp_hdr(skb);
> -       icmp_param.skb             = skb;
> -       icmp_param.offset          = 0;
> -       icmp_param.data_len        = skb->len;
> -       icmp_param.head_len        = sizeof(struct icmphdr);
> -
> -       if (icmp_param.data.icmph.type == ICMP_ECHO) {
> -               icmp_param.data.icmph.type = ICMP_ECHOREPLY;
> -               goto send_reply;
> -       }
>         if (!net->ipv4.sysctl_icmp_echo_enable_probe)
> -               return true;
> +               return false;
> +
>         /* We currently only support probing interfaces on the proxy node
>          * Check to ensure L-bit is set
>          */
> -       if (!(ntohs(icmp_param.data.icmph.un.echo.sequence) & 1))
> -               return true;
> +       if (!(ntohs(icmphdr->un.echo.sequence) & 1))
> +               return false;
>         /* Clear status bits in reply message */
> -       icmp_param.data.icmph.un.echo.sequence &= htons(0xFF00);
> -       icmp_param.data.icmph.type = ICMP_EXT_ECHOREPLY;
> +       icmphdr->un.echo.sequence &= htons(0xFF00);
> +       if (icmphdr->type == ICMP_EXT_ECHO)
> +               icmphdr->type = ICMP_EXT_ECHOREPLY;
> +       else
> +               icmphdr->type = ICMPV6_EXT_ECHO_REPLY;
>         ext_hdr = skb_header_pointer(skb, 0, sizeof(_ext_hdr), &_ext_hdr);
>         /* Size of iio is class_type dependent.
>          * Only check header here and assign length based on ctype in the switch statement
> @@ -1087,8 +1068,8 @@ static bool icmp_echo(struct sk_buff *skb)
>                 goto send_mal_query;
>         }
>         if (!dev) {
> -               icmp_param.data.icmph.code = ICMP_EXT_CODE_NO_IF;
> -               goto send_reply;
> +               icmphdr->code = ICMP_EXT_CODE_NO_IF;
> +               return true;
>         }
>         /* Fill bits in reply message */
>         if (dev->flags & IFF_UP)
> @@ -1098,13 +1079,53 @@ static bool icmp_echo(struct sk_buff *skb)
>         if (!list_empty(&rcu_dereference(dev->ip6_ptr)->addr_list))
>                 status |= ICMP_EXT_ECHOREPLY_IPV6;
>         dev_put(dev);
> -       icmp_param.data.icmph.un.echo.sequence |= htons(status);
> +       icmphdr->un.echo.sequence |= htons(status);
> +       return true;
> +send_mal_query:
> +       icmphdr->code = ICMP_EXT_CODE_MAL_QUERY;
> +       return true;
> +}

Needs EXPORT_SYMBOL_GPL to use it from IPv6 when compiled as a module.

> +
> +/*
> + *     Handle ICMP_ECHO ("ping") and ICMP_EXT_ECHO ("PROBE") requests.
> + *
> + *     RFC 1122: 3.2.2.6 MUST have an echo server that answers ICMP echo
> + *               requests.
> + *     RFC 1122: 3.2.2.6 Data received in the ICMP_ECHO request MUST be
> + *               included in the reply.
> + *     RFC 1812: 4.3.3.6 SHOULD have a config option for silently ignoring
> + *               echo requests, MUST have default=NOT.
> + *     RFC 8335: 8 MUST have a config option to enable/disable ICMP
> + *               Extended Echo Functionality, MUST be disabled by default
> + *     See also WRT handling of options once they are done and working.
> + */
> +
> +static bool icmp_echo(struct sk_buff *skb)
> +{
> +       struct icmp_bxm icmp_param;
> +       struct net *net;
> +
> +       net = dev_net(skb_dst(skb)->dev);
> +       /* should there be an ICMP stat for ignored echos? */
> +       if (net->ipv4.sysctl_icmp_echo_ignore_all)
> +               return true;
> +
> +       icmp_param.data.icmph      = *icmp_hdr(skb);
> +       icmp_param.skb             = skb;
> +       icmp_param.offset          = 0;
> +       icmp_param.data_len        = skb->len;
> +       icmp_param.head_len        = sizeof(struct icmphdr);
> +
> +       if (icmp_param.data.icmph.type == ICMP_ECHO) {
> +               icmp_param.data.icmph.type = ICMP_ECHOREPLY;
> +               goto send_reply;
> +       }
> +
> +       if (!icmp_build_probe(skb, &icmp_param.data.icmph))
> +               return true;

This control flow can now be simplified:

  if (icmp_param.data.icmph.type == ICMP_ECHO)
               icmp_param.data.icmph.type = ICMP_ECHOREPLY;
  else if !icmp_build_probe(skb, &icmp_param.data.icmph))
               return true;

and can remove the send_reply label

>  send_reply:
>         icmp_reply(&icmp_param, skb);
>                 return true;
> -send_mal_query:
> -       icmp_param.data.icmph.code = ICMP_EXT_CODE_MAL_QUERY;
> -       goto send_reply;
>  }
>
>  /*
> diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
> index e8398ffb5e35..d32a387b36e7 100644
> --- a/net/ipv6/icmp.c
> +++ b/net/ipv6/icmp.c
> @@ -725,6 +725,7 @@ static void icmpv6_echo_reply(struct sk_buff *skb)
>         struct ipcm6_cookie ipc6;
>         u32 mark = IP6_REPLY_MARK(net, skb->mark);
>         bool acast;
> +       u8 type;
>
>         if (ipv6_addr_is_multicast(&ipv6_hdr(skb)->daddr) &&
>             net->ipv6.sysctl.icmpv6_echo_ignore_multicast)
> @@ -740,8 +741,16 @@ static void icmpv6_echo_reply(struct sk_buff *skb)
>             !(net->ipv6.sysctl.anycast_src_echo_reply && acast))
>                 saddr = NULL;
>
> +       if (icmph->icmp6_type == ICMPV6_EXT_ECHO_REQUEST) {
> +               if (!net->ipv4.sysctl_icmp_echo_enable_probe)
> +                       return;
> +               type = ICMPV6_EXT_ECHO_REPLY;
> +       } else {
> +               type = ICMPV6_ECHO_REPLY;
> +       }
> +
>         memcpy(&tmp_hdr, icmph, sizeof(tmp_hdr));
> -       tmp_hdr.icmp6_type = ICMPV6_ECHO_REPLY;
> +       tmp_hdr.icmp6_type = type;
>
>         memset(&fl6, 0, sizeof(fl6));
>         if (net->ipv6.sysctl.flowlabel_reflect & FLOWLABEL_REFLECT_ICMPV6_ECHO_REPLIES)
> @@ -752,7 +761,7 @@ static void icmpv6_echo_reply(struct sk_buff *skb)
>         if (saddr)
>                 fl6.saddr = *saddr;
>         fl6.flowi6_oif = icmp6_iif(skb);
> -       fl6.fl6_icmp_type = ICMPV6_ECHO_REPLY;
> +       fl6.fl6_icmp_type = type;
>         fl6.flowi6_mark = mark;
>         fl6.flowi6_uid = sock_net_uid(net, NULL);
>         security_skb_classify_flow(skb, flowi6_to_flowi_common(&fl6));
> @@ -783,13 +792,17 @@ static void icmpv6_echo_reply(struct sk_buff *skb)
>
>         msg.skb = skb;
>         msg.offset = 0;
> -       msg.type = ICMPV6_ECHO_REPLY;
> +       msg.type = type;
>
>         ipcm6_init_sk(&ipc6, np);
>         ipc6.hlimit = ip6_sk_dst_hoplimit(np, &fl6, dst);
>         ipc6.tclass = ipv6_get_dsfield(ipv6_hdr(skb));
>         ipc6.sockc.mark = mark;
>
> +       if (icmph->icmp6_type == ICMPV6_EXT_ECHO_REQUEST)
> +               if (!icmp_build_probe(skb, (struct icmphdr *)&tmp_hdr))
> +                       goto out_dst_release;
> +
>         if (ip6_append_data(sk, icmpv6_getfrag, &msg,
>                             skb->len + sizeof(struct icmp6hdr),
>                             sizeof(struct icmp6hdr), &ipc6, &fl6,
> @@ -912,6 +925,11 @@ static int icmpv6_rcv(struct sk_buff *skb)
>                         icmpv6_echo_reply(skb);
>                 break;
>
> +       case ICMPV6_EXT_ECHO_REQUEST:
> +               if (!net->ipv6.sysctl.icmpv6_echo_ignore_all)
> +                       icmpv6_echo_reply(skb);
> +               break;
> +

This can be a one line change to add the case to the existing case above.

But either way, you might prefer this.

>         case ICMPV6_ECHO_REPLY:
>                 success = ping_rcv(skb);
>                 break;
> --
> 2.32.0
>
