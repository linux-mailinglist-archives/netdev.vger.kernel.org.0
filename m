Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 841093FE506
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 23:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344945AbhIAVlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 17:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231788AbhIAVlX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 17:41:23 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D187DC061575
        for <netdev@vger.kernel.org>; Wed,  1 Sep 2021 14:40:25 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id j13so958250edv.13
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 14:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U8R5nb1aeTJ3ns8dBCSRYtGDb21lrE9rr+79sQCQT80=;
        b=lceJUcTDFESBP3oN2FuTdNO5BP1gJaIGCWNaz9fEMs0L8lMoXCVbTnJyEwEJs6ic57
         yEJ65qmZXvZHGoFDjHNtcOA1VrcqwVCNg/njVRBwoLmg8yGQtGc6W7e7KgaKuiz87hgj
         sB7Wce70kR4SmBWKusaLfsjgROIXHWIQKRgSLZYB1kYG6yl0zdYXNydgiVaoLJZk7xXS
         PrT6bRapPF97P5XNoB//HYGu5A6ciTd3yGusZtL8IyjHVf/Kple/Hy3BgUvcv+a0xH95
         kThesPR2ygaY3ZRji1F0bfYDFQHnoHX6api6tGy0z5QqwYteeqbctiVcbXxoq0qzqwu/
         mwrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U8R5nb1aeTJ3ns8dBCSRYtGDb21lrE9rr+79sQCQT80=;
        b=bFUPBsKMTc1fspXG5AkT3eFY0Yv+oMX9GWO6LW1u6m6xRKwxNsSoRpF08CgjEMYtvX
         Hhn4IiGVmIzgnA2sBcliRxqrxOAjexMriUKVhnIIYBNuC5p3JvAUsiowoK1lT5sM3A/s
         ZpScRPSnowEYb0VfxK8JZwHMgMAXTiWGl5qZl/Yoo0e4SPEygXXPQgQ55oQs0hLfvSVc
         ckD3UGM1FtIcOffcFJRoVC1jAuytEg+b0Y90tILoepLt78AffbewPJMXlYfhPdt+oN2g
         fIBarxfhRtEN/0msfYTF2OONOG5yErEeYNvjHiWTY0cy6VELFX4KJ4/JWtWeO9ELv7Kd
         u9AQ==
X-Gm-Message-State: AOAM533oSHwz65dKgv3cj0H6dwIqczLDQxKpKc4BH1ZTQ4wz+Iev4EkA
        IK5vCAQ3r05njqaQzO52j9oqaQpxpRE/Zw==
X-Google-Smtp-Source: ABdhPJyKVndWby6BgAaXZVRcYua0QvaIrTpbleRNhqvLZaSnU8iK1eT2QgSD5gmorycfbm2470z0uA==
X-Received: by 2002:a05:6402:445:: with SMTP id p5mr19555edw.208.1630532424399;
        Wed, 01 Sep 2021 14:40:24 -0700 (PDT)
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com. [209.85.128.54])
        by smtp.gmail.com with ESMTPSA id i23sm448978edr.72.2021.09.01.14.40.23
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Sep 2021 14:40:23 -0700 (PDT)
Received: by mail-wm1-f54.google.com with SMTP id u15-20020a05600c19cf00b002f6445b8f55so2773wmq.0
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 14:40:23 -0700 (PDT)
X-Received: by 2002:a1c:2bc6:: with SMTP id r189mr1380207wmr.183.1630532422682;
 Wed, 01 Sep 2021 14:40:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210819100447.00201b26@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210821071425.512834-1-chouhan.shreyansh630@gmail.com> <CA+FuTSeWY-0+VtERqAxNwmHAwmarYh_HQUoF3b0wHiwAaL+h+A@mail.gmail.com>
 <YS9puVgl/exGgrr3@shredder> <CA+FuTSfTCufYmJg5Vum1Q-ndUYh+1P1hLecFht9Qd1-AdnHmaQ@mail.gmail.com>
 <YS+h/tqCJJiQei+W@shredder>
In-Reply-To: <YS+h/tqCJJiQei+W@shredder>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 1 Sep 2021 17:39:45 -0400
X-Gmail-Original-Message-ID: <CA+FuTScx8cCQEOqsmj1eazMkRPqfb-EaqrqH+kmS_sKCFfr7kg@mail.gmail.com>
Message-ID: <CA+FuTScx8cCQEOqsmj1eazMkRPqfb-EaqrqH+kmS_sKCFfr7kg@mail.gmail.com>
Subject: Re: [PATCH 1/2 net] ip_gre: add validation for csum_start
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pshelar@nicira.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+ff8e1b9f2f36481e2efc@syzkaller.appspotmail.com,
        Edward Cree <ecree@solarflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 1, 2021 at 11:53 AM Ido Schimmel <idosch@idosch.org> wrote:
>
> Thanks for the quick reply, Willem.
>
> On Wed, Sep 01, 2021 at 09:46:48AM -0400, Willem de Bruijn wrote:
> > Thanks for the detailed report, Ido.
> >
> > This is a gre tunnel device with csum/ocsum enabled, correct?
>
> Correct.
>
> >
> > How was this packet generated: does it come from the local stack or is
> > it a custom packet injected from userspace, e.g., with a packet socket
> > with vnet_hdr?
>
> The packet is received by a physical port and injected to the kernel's
> Rx path by mlxsw (which does not support checksumming). The IPv4 routing
> code then forwards the packet to the GRE tunnel.
>
> I was able to reproduce the issue using veth pairs and a packet socket
> [1]. Running the reproducer with the debug patch from before, I get the
> following output [2].

Thanks for that device independent repro.

As expected, the following fixes it for these packets:

-       if (csum && skb_checksum_start(skb) < skb->data)
+       if (csum && skb->ip_summed == CHECKSUM_PARTIAL &&
+           skb_checksum_start(skb) < skb->data)

The question is whether we're doing the right thing when CHECKSUM_PARTIAL
is set.

Local checksum offload allows for cheap calculation of outer checksums, by
relying on the fact that the inner packet with the checksum field filled in will
sum to zero. It relies on checksum offload to compute this inner checksum,
so expects csum_start and csum_off to point after the GRE header.

If so, then the existing fix won't break correctly configured skbs as it only
drops packets for which this does not hold.
