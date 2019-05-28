Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 286FD2D126
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 23:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbfE1Voj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 17:44:39 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:41514 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbfE1Voj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 17:44:39 -0400
Received: by mail-ed1-f68.google.com with SMTP id m4so183115edd.8;
        Tue, 28 May 2019 14:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3ccx/2mDpV9eWWMwVg+SGrf807l1VCHY5j13bUz46vU=;
        b=d9exG2Ya6ZrZQxB9PlYWUG19JVleB2q8xKQ7kXz6yJWz3mAgfpTwDyhKR4aCoNcA0a
         Qem34JLBY8BWw/tJFm5v2NBuu7aIoIq3w/VU8IWcKyszzyi/9X+gSB25Y/QwiLjLS8PP
         qFvOLitYsArkNVE7+HxSsVvrUhti3A7WMo2zyOOfiSTdlqidZJKTMx/dBh35XjU7atBb
         qUiaUtYxQT/jD/VybRL1dGocMBxHFA1uMYVOpepWQKNSdyEm9ukJja13eczY27cDDmtC
         R6tf9TSsfjAtlHzW8+GcSXhqbeSoZfq/zgUb/tZP6CMs8/eiwGMPOTqCD4/xgLggT45Y
         kElA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3ccx/2mDpV9eWWMwVg+SGrf807l1VCHY5j13bUz46vU=;
        b=Dh1bg5qnYklMp0+6z3+Fga1rWt+zCGV3MnID6Hg2i+mSVIJ4JEHi0cOixGbCSM+HV3
         CAaMUPVgG424Ddl9imIfSRfTIiWdheZ1IZlh3H1zJsl96E2Fp6iENcACwaSjx6JUr60g
         2g8l9qbTXdKMJZRwuDwfAoUHJJtKvX6i+4sXw64NIzEwaUHwAjmjcTOvMF1kI46O1S/+
         ESXi+gJRph4L2NtYJ1O9rydmitzRb3Cel8njmuz3fZ0obG4Qs6npPuqy74xUIpWR6LAx
         XV0JIK5wNhWo/6GHQX87DPx7IJagJ1KpFPKuDXVtGrXelhhXzO5DksF3cx2iuoOEW6/g
         n36w==
X-Gm-Message-State: APjAAAUenWmxVOrKqyQpHCFLSATBcWvQMEs1RbZtUbHRhIAUaAOfl68N
        sRKJN0/0a5j5brW66edgvOXWc/pYRZSBzFYRtCSh6g==
X-Google-Smtp-Source: APXvYqw1C0np1xDokVrH9pm/kPaWV5KeN9jgbuOF77Axq5+iwy+Lr5C1JFIpvGp7WIkD9DfzWrJiaNVJKsKSp3yR15k=
X-Received: by 2002:a17:906:aacb:: with SMTP id kt11mr90590173ejb.246.1559079877279;
 Tue, 28 May 2019 14:44:37 -0700 (PDT)
MIME-Version: 1.0
References: <20190528184415.16020-1-fklassen@appneta.com> <20190528184415.16020-2-fklassen@appneta.com>
In-Reply-To: <20190528184415.16020-2-fklassen@appneta.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 28 May 2019 17:44:01 -0400
Message-ID: <CAF=yD-JvNFdWCBJ6w1_XWSHu1CDiG_QimrUT8ZCxw=U+OVvBMA@mail.gmail.com>
Subject: Re: [PATCH net-next v3 1/1] net/udp_gso: Allow TX timestamp with UDP GSO
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

On Tue, May 28, 2019 at 3:10 PM Fred Klassen <fklassen@appneta.com> wrote:
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

See previous comment in v2

http://patchwork.ozlabs.org/patch/1105564/

>
>     ./udpgso_bench_tx -4ucPv -S 1472 -q 182 -l2 -D 172.16.120.18
>     poll timeout
>     udp tx:      0 MB/s        1 calls/s      1 msg/s
>
> This patch preserves tx_flags for the first UDP GSO segment.
>
> v2: Remove tests as noted by Willem de Bruijn <willemb@google.com>
>     Moving tests from net to net-next
>
> v3: Update only relevant tx_flag bits as per
>     Willem de Bruijn <willemb@google.com>
>
> Fixes: ee80d1ebe5ba ("udp: add udp gso")
> Signed-off-by: Fred Klassen <fklassen@appneta.com>

FYI, no need for a cover letter for a single patch. Also, I think the
cc list can be more concise. Mainly netdev.

> ---
>  net/ipv4/udp_offload.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
> index 065334b41d57..de8ecba42d55 100644
> --- a/net/ipv4/udp_offload.c
> +++ b/net/ipv4/udp_offload.c
> @@ -228,6 +228,11 @@ struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
>         seg = segs;
>         uh = udp_hdr(seg);
>
> +       /* preserve TX timestamp and zero-copy info for first segment */

Same as above. This is not about zerocopy.

> +       skb_shinfo(seg)->tskey = skb_shinfo(gso_skb)->tskey;
> +       skb_shinfo(seg)->tx_flags |=
> +                       (skb_shinfo(gso_skb)->tx_flags & SKBTX_ANY_TSTAMP);

Asked elsewhere, but best answered here: given that xmit_more delays
delivery to the NIC until the last segment in a train, is the first
segment in your opinion still the best to attach the timestamp request
to?

To reiterate, we do not want to need a follow-up patch to disable
xmit_more when timestamps are requested.


> +
>         /* compute checksum adjustment based on old length versus new */
>         newlen = htons(sizeof(*uh) + mss);
>         check = csum16_add(csum16_sub(uh->check, uh->len), newlen);
> --
> 2.11.0
>
