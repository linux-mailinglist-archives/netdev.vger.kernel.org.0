Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33F482ACD2
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 03:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbfE0BkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 May 2019 21:40:15 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:46400 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725864AbfE0BkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 May 2019 21:40:14 -0400
Received: by mail-ed1-f66.google.com with SMTP id f37so24145224edb.13;
        Sun, 26 May 2019 18:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NO8U8m5CSzAayh5gOP2uD7+woZxUgAgpDSZBOZBWMII=;
        b=TT0SSFfJ9XyvcbkKVpLMR68wDPQAajZCyQneV7tN9UXeOca3yslwQH/BD3wZq4OoMt
         8ZZryAzzeNXUI+cc99TbEbTqng3q/gzDkbdo7yx/ba+shW4zCoSABRLwLiXK/9TAjfut
         BGnzDPVOQ2ZDKbiNt/9QSOZakC0Y5X2S6aT7xyxcIYXf6VvGTEcYN5SiwgC/6sHZ1mGh
         nllh2/RJahrdF7+zoG+zfxAJOg9LXTnfPukY2soQvpNWx5K4RPR8WfAv5qcli3Vj7sms
         r6CtY3jx1C5VnFXBIEOMEjZ/PkXtuY4ed5lDdxzfCRmafG2g/g3vtSb6Qa1jV7au0oDi
         QxcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NO8U8m5CSzAayh5gOP2uD7+woZxUgAgpDSZBOZBWMII=;
        b=D4B0wFoFlChYB58lj/LcztYdrXL/H5kDeyYGsGZMqL1WYPm+cRCXYPLTUTG+fYSbTn
         R45fHU2frDeLE0KCQFzIj7mOe9OBNOvq5S4LNATcoYknu7vbzeZoe5s1oOcpEu7uHmbQ
         t1HhfWsMLo2YmPcDquCXEo2rHXLfHH19BPSjszVuCPh8woN1MfP5Yphim0x2EyCEDtTX
         Hf/HtOvErZO/WxLLfQ8Wgt/dhf8WPnErRNHIdTwwLySOOXlXzPJpEjt+8aSyN3lvgK6p
         cDqv29tu73rzv9dXbJY6hoRnZJaXOVaIHWo3qpPKQ8Yy1X8xb2EUouk95g9/UTTRi696
         ssNw==
X-Gm-Message-State: APjAAAXSxXbSjMSSK81+wHk+2OYBI2U5us0m4i6nSKKtNDxg6nUjnv0B
        XkU4M9mqdSwqyyX8TFDxH50fgDVSCeSQL8Benu8=
X-Google-Smtp-Source: APXvYqygJgX+1+G9LnBUoEvC9NE4hIGyhnnxSNmA5vxJcY7JHoHKjOJUMtHe+V1DM18JWSsTJCvJ36wMlERBO/LdBw4=
X-Received: by 2002:a17:906:2acf:: with SMTP id m15mr78048074eje.31.1558921212695;
 Sun, 26 May 2019 18:40:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190526153357.82293-1-fklassen@appneta.com> <20190526153357.82293-2-fklassen@appneta.com>
In-Reply-To: <20190526153357.82293-2-fklassen@appneta.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 26 May 2019 20:39:36 -0500
Message-ID: <CAF=yD-KyJC0ErdyNRtiw5VPhQY+i__sDG5oh0LzWJ4RMYe1zCQ@mail.gmail.com>
Subject: Re: [PATCH net v2 1/1] net/udp_gso: Allow TX timestamp with UDP GSO
To:     Fred Klassen <fklassen@appneta.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 26, 2019 at 10:37 AM Fred Klassen <fklassen@appneta.com> wrote:
>
> Fixes an issue where TX Timestamps are not arriving on the error queue
> when UDP_SEGMENT CMSG type is combined with CMSG type SO_TIMESTAMPING.
> This can be illustrated with an updated updgso_bench_tx program which
> includes the '-T' option to test for this condition.
>
>     ./udpgso_bench_tx -4ucTPv -S 1472 -l2 -D 172.16.120.18
>     poll timeout
>     udp tx:      0 MB/s        1 calls/s      1 msg/s
>
> The "poll timeout" message above indicates that TX timestamp never
> arrived.
>
> It also appears that other TX CMSG types cause similar issues, for
> example trying to set SOL_IP/IP_TOS.

If correct we need to find the root cause. Without that, this is not
very informative. And likely the fix is not related, as that does not
involve tx_flags or tskey.

What exact behavior do you observe: tx timestamp notifications go
missing when enabling IP_TOS?

>
>     ./udpgso_bench_tx -4ucPv -S 1472 -q 182 -l2 -D 172.16.120.18
>     poll timeout
>     udp tx:      0 MB/s        1 calls/s      1 msg/s
>
> This patch preserves tx_flags for the first UDP GSO segment. This
> mirrors the stack's behaviour for IPv4 fragments.

But deviates from the established behavior of other transport protocol TCP.

I think it's a bit premature to resubmit as is while still discussing
the original patch.

>
> Fixes: ee80d1ebe5ba ("udp: add udp gso")
> Signed-off-by: Fred Klassen <fklassen@appneta.com>
> ---
>  net/ipv4/udp_offload.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
> index 065334b41d57..33de347695ae 100644
> --- a/net/ipv4/udp_offload.c
> +++ b/net/ipv4/udp_offload.c
> @@ -228,6 +228,10 @@ struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
>         seg = segs;
>         uh = udp_hdr(seg);
>
> +       /* preserve TX timestamp and zero-copy info for first segment */

As pointed out in v1, zerocopy flags are handled by protocol
independent skb_segment. It calls skb_zerocopy_clone.



> +       skb_shinfo(seg)->tskey = skb_shinfo(gso_skb)->tskey;
> +       skb_shinfo(seg)->tx_flags = skb_shinfo(gso_skb)->tx_flags;
> +
>         /* compute checksum adjustment based on old length versus new */
>         newlen = htons(sizeof(*uh) + mss);
>         check = csum16_add(csum16_sub(uh->check, uh->len), newlen);
> --
> 2.11.0
>
