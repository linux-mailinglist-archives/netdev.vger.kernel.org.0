Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E15013FDD6E
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 15:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244612AbhIANs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 09:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242520AbhIANs2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 09:48:28 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3AA9C061575
        for <netdev@vger.kernel.org>; Wed,  1 Sep 2021 06:47:31 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id dm15so3861672edb.10
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 06:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HL4OFA3MyulAMIPvUGUruLFHSETz0LT5eYnBY3Ay/NM=;
        b=YGoyvPfWEPkcokSRUq9/Ce2UMqBBVIxzDxm0VYFQlh5lnjxKa88Q9qURiP0cjP++09
         3gZXusOpVVJKre2GyckEhrjAZRp553y/VbLDiLGdzz5TTvRpgUXPgq0jY9ax6u8vCLlV
         e+tBudED9RsukU8XE4kG9fPbEbaTKaOE1blMTLQZIE3CYGu2ZMiyk+tmaCF88EkIAAol
         os0HlbNWchqmFPI32Kmg0A/+/HZiT5H2AqvJAm1q+LJEGIA1oWv00BW3aNYvDcGb3lCN
         PmNurFVlFpm7obL1RWPFfJ1su8/sPkn7PabA0uaTQi/t0n1w8nWeE4ekVdnWEVJrYs7+
         9fKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HL4OFA3MyulAMIPvUGUruLFHSETz0LT5eYnBY3Ay/NM=;
        b=C0Umi8LvaRsFLs6E+6AOmGZ6lBzOKPGJt5pNFCezBfpNRSI9cUNAKIy+Dex6rPu+me
         UXInZTaUyYwPfQK+gQg2PcYfV50LLcSwsfkNGW57uxAzHFy8skr/2AlRgVtI9PRA9aoi
         HT1+2FBZ+6qqANpc/NDBdm6N1AVlqGpZ4A2MI3XLG7z8byStTWTw9Jf5v2xGcoxrY44P
         NA09eBA/yerwGrHvJMeZXVFaLiiodx2yx/kldVsuRV6HtS6nhKWOqtXTZ//KWc6gctwm
         R9MiitYSd8OwYXeFIIifyFgOyFm2VD7/EF5MARWoxyw6ieN7xiXecQrBG9WikA8oWKQw
         XJ8Q==
X-Gm-Message-State: AOAM533KWUgCkqoyzDpfrkGAARuvmKCZsREwjwCVG2Ot296tE8RIN3Ve
        Myz14yqfYAfb/d1SCf0h+PoL4ALPBmWzAA==
X-Google-Smtp-Source: ABdhPJysq4HsPmMqz1Iz+wLKPweAwO4fYf3HiPg41EtSdgCrInRjZsglJPD0aOD7EqAsV7g3/hAp7A==
X-Received: by 2002:a05:6402:5108:: with SMTP id m8mr36064399edd.367.1630504050372;
        Wed, 01 Sep 2021 06:47:30 -0700 (PDT)
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com. [209.85.221.41])
        by smtp.gmail.com with ESMTPSA id y23sm721ejp.115.2021.09.01.06.47.26
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Sep 2021 06:47:27 -0700 (PDT)
Received: by mail-wr1-f41.google.com with SMTP id d26so4734137wrc.0
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 06:47:26 -0700 (PDT)
X-Received: by 2002:a5d:6cae:: with SMTP id a14mr36496238wra.275.1630504045833;
 Wed, 01 Sep 2021 06:47:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210819100447.00201b26@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210821071425.512834-1-chouhan.shreyansh630@gmail.com> <CA+FuTSeWY-0+VtERqAxNwmHAwmarYh_HQUoF3b0wHiwAaL+h+A@mail.gmail.com>
 <YS9puVgl/exGgrr3@shredder>
In-Reply-To: <YS9puVgl/exGgrr3@shredder>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 1 Sep 2021 09:46:48 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfTCufYmJg5Vum1Q-ndUYh+1P1hLecFht9Qd1-AdnHmaQ@mail.gmail.com>
Message-ID: <CA+FuTSfTCufYmJg5Vum1Q-ndUYh+1P1hLecFht9Qd1-AdnHmaQ@mail.gmail.com>
Subject: Re: [PATCH 1/2 net] ip_gre: add validation for csum_start
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pshelar@nicira.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+ff8e1b9f2f36481e2efc@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 1, 2021 at 7:53 AM Ido Schimmel <idosch@idosch.org> wrote:
>
> On Sat, Aug 21, 2021 at 09:41:14AM -0400, Willem de Bruijn wrote:
> > On Sat, Aug 21, 2021 at 3:14 AM Shreyansh Chouhan
> > <chouhan.shreyansh630@gmail.com> wrote:
> > >
> > > Validate csum_start in gre_handle_offloads before we call _gre_xmit so
> > > that we do not crash later when the csum_start value is used in the
> > > lco_csum function call.
> > >
> > > This patch deals with ipv4 code.
> > >
> > > Fixes: c54419321455 ("GRE: Refactor GRE tunneling code.")
> > > Reported-by: syzbot+ff8e1b9f2f36481e2efc@syzkaller.appspotmail.com
> > > Signed-off-by: Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>
> >
> > Reviewed-by: Willem de Bruijn <willemb@google.com>
>
> Hi Shreyansh, Willem,
>
> I bisected packet drops with a GRE tunnel to this patch. With the
> following debug patch [1], I'm getting this output [2].
>
> Tested with IPv4 underlay only, but I assume problem exists with ip6gre
> as well.
>
> Thanks
>
> [1]
> diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
> index 177d26d8fb9c..cf4e13db030b 100644
> --- a/net/ipv4/ip_gre.c
> +++ b/net/ipv4/ip_gre.c
> @@ -473,8 +473,11 @@ static void __gre_xmit(struct sk_buff *skb, struct net_device *dev,
>
>  static int gre_handle_offloads(struct sk_buff *skb, bool csum)
>  {
> -       if (csum && skb_checksum_start(skb) < skb->data)
> +       if (csum && skb_checksum_start(skb) < skb->data) {
> +               if (net_ratelimit())
> +                       skb_dump(KERN_WARNING, skb, false);
>                 return -EINVAL;
> +       }
>         return iptunnel_handle_offloads(skb, csum ? SKB_GSO_GRE_CSUM : SKB_GSO_GRE);
>  }
>
> [2]
> skb len=84 headroom=78 headlen=84 tailroom=15902
> mac=(78,0) net=(78,20) trans=98
> shinfo(txflags=0 nr_frags=0 gso(size=0 type=0 segs=0))
> csum(0x0 ip_summed=0 complete_sw=0 valid=0 level=0)
> hash(0x0 sw=0 l4=0) proto=0x0800 pkttype=0 iif=32
> dev name=g1a feat=0x0x00000006401d5869
> skb linear:   00000000: 45 00 00 54 be 12 40 00 3f 01 f9 82 c0 00 02 01
> skb linear:   00000010: c0 00 02 12 08 00 fe ad 8c 39 00 01 7c 65 2f 61
> skb linear:   00000020: 00 00 00 00 f8 7d 0a 00 00 00 00 00 10 11 12 13
> skb linear:   00000030: 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f 20 21 22 23
> skb linear:   00000040: 24 25 26 27 28 29 2a 2b 2c 2d 2e 2f 30 31 32 33
> skb linear:   00000050: 34 35 36 37

Thanks for the detailed report, Ido.

This is a gre tunnel device with csum/ocsum enabled, correct?

How was this packet generated: does it come from the local stack or is
it a custom packet injected from userspace, e.g., with a packet socket
with vnet_hdr?

The bug that this patch intended to protect against only occurs with
ip_summed == CHECKSUM_PARTIAL (3):

                        if (skb->ip_summed == CHECKSUM_PARTIAL) {
                                *(__sum16 *)ptr = csum_fold(lco_csum(skb));
                        } else {
                                skb->ip_summed = CHECKSUM_PARTIAL;
                                skb->csum_start =
skb_transport_header(skb) - skb->head;
                                skb->csum_offset = sizeof(*greh);
                        }

 So this packet would not hit that code anyway, as it has ip_summed
CHECKSUM_NONE (0), which computes the offsets manually.

Perhaps the check needs to be refined. But I'd like to also understand
how to reproduce this / how common this false positive is.
