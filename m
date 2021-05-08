Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1578A376F24
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 05:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbhEHDgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 23:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbhEHDgG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 23:36:06 -0400
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7682EC061574;
        Fri,  7 May 2021 20:34:54 -0700 (PDT)
Received: by mail-oo1-xc32.google.com with SMTP id v13-20020a4aa40d0000b02902052145a469so765340ool.3;
        Fri, 07 May 2021 20:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JlWWLJu+SOU+OleF8b9iNUr3ONW3oZ22rK7JJmpNKGM=;
        b=m626vE1H+y7lCGKUvaStCwyNFCWbaoHpaaFnCRHEZz1ewCn8HHfZRPYdHGSnMOCmwP
         OuWtKYVL07svmyJqJez+afEJdQWf6Nnvpt1Qs37St+SuG978lK3nXC9heaT1AJLE5gLj
         C6XsPzR/NUSVqgA6CZU3yKKf6y4BAPJyekT9O/3k2Z3hmU8CNyQKvlgWhJJzO1ygPORs
         PfqP+qF0rf+hX4ox9MgAXnQC2qqqD7DDwNdsxgoYBnNMzNPdjhIyXDhxgtYixXT3Vr7K
         jSsnlsfXS66ccPPnBjhLh4YZu6hMiIqZTUYpXTa2QyeKehSdJEroZJ4/0K39kxa8dyh4
         rZnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JlWWLJu+SOU+OleF8b9iNUr3ONW3oZ22rK7JJmpNKGM=;
        b=WITWgsJhgZ7T5UDnAdglsj9vv56X3B1SlXGeXhYGR2H/qRvmmCLUg9rg4SFRPemjxn
         JogenqVXdYdPylTJW1E4Q9vSlVlWngP1BqAfpiSXmro+/e4yWgOkcKfL2VOt73QYpqss
         7UjQUem+bogPf6LYTB8nQMzIMW9GhwYIR2QEH77VmOBExi3UrzTcGKzFjjaAAUV+QX6U
         ko0sue9nZCBYrX6n9Y2LdxhyvF0O/h5Y3ybdXnD0AFxWbF0oG9PaQia7TODHJ3I6b2a2
         97ghmD2vvENJYYRg2S5Xaq/kj2dalR7qg5OQAaFZuFzUhWbsjhvdMkGIKWxPLxYg4nvs
         PhRg==
X-Gm-Message-State: AOAM5323PW33fkq0LglRaKQccM5SrEnQmydlk+UQ5P0R/lVUO0MPqCuP
        AAMpd4sc9vzn6Kn5mCalBjPprLf/ozQLJdLBMcb8gnjSNr7VJw==
X-Google-Smtp-Source: ABdhPJwiqnmWKQSmnAc6WoItAb8lMqqp5/2k0XyXd7j1CoRBFqqM3X9DRrw3NGEAWJ/ypZW3iq6dFYn8YIH/0lk/aaA=
X-Received: by 2002:a4a:d2cb:: with SMTP id j11mr10482767oos.87.1620444893917;
 Fri, 07 May 2021 20:34:53 -0700 (PDT)
MIME-Version: 1.0
References: <CAL+tcoDuY6D6j6zO9XSzkUCom9jdD4ydidUL5S8Pt-dqd69EGw@mail.gmail.com>
In-Reply-To: <CAL+tcoDuY6D6j6zO9XSzkUCom9jdD4ydidUL5S8Pt-dqd69EGw@mail.gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Sat, 8 May 2021 11:34:18 +0800
Message-ID: <CAL+tcoDAY=Q5pohEPgkBTNghxTb0AhmbQD58dPDghyxmrcWMRQ@mail.gmail.com>
Subject: Re: soft lockup in __inet_lookup_established() function
To:     David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        dsahern@kernel.org, kuba@kernel.org
Cc:     netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        liweishi <liweishi@kuaishou.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Does anyone have some suggestions? I've been haunted for a while.

thanks,
jason

On Thu, Apr 29, 2021 at 8:15 PM Jason Xing <kerneljasonxing@gmail.com> wrote:
>
> Hello,
>
> I've encountered one big issue which causes infinite loop in
> __inet_lookup_established() function until I reboot manually. it's
> happening randomly among thousands of machines with the 4.19 kernel
> running. Once the soft lockup issue is triggered, whatever I try I
> still cannot ping or ssh to the machine anymore until reboot.
>
> Does anyone have any clue on how to dig into this part of code?  I
> highly suspect that it has something to do with the corruption of
> nulls_list, so the lookup of sk could never break the infinite loop of
> hashinfo.
>
> These call traces are totally identical attached below:
> [1048271.465028] watchdog: BUG: soft lockup - CPU#20 stuck for 22s!
> [swapper/20:0]
> [1048271.473669] Modules linked in: vxlan ip6_udp_tunnel udp_tunnel
> udp_diag tcp_diag inet_diag nf_conntrack_netlink nfnetlink
> br_netfilter bridge stp llc xt_statistic xt_nat ipt_MASQUERADE
> ipt_REJECT nf_reject_ipv4 xt_mark xt_addrtype xt_comment xt_conntrack
> ...
> [1048271.553597] RIP: 0010:__inet_lookup_established+0x5a/0x190
> ...
> [1048271.660309] Call Trace:
> [1048271.663135]  <IRQ>
> [1048271.665432]  tcp_v4_early_demux+0xaa/0x150
> [1048271.669812]  ip_rcv_finish+0x171/0x410
> [1048271.673941]  ip_rcv+0x273/0x362
> [1048271.677360]  ? inet_add_protocol.cold.1+0x1e/0x1e
> [1048271.682354]  __netif_receive_skb_core+0xac2/0xbb0
> [1048271.687351]  ? inet_gro_receive+0x22a/0x2d0
> [1048271.692001]  ? ktime_get_with_offset+0x4d/0xc0
> [1048271.696725]  netif_receive_skb_internal+0x42/0xf0
> [1048271.701717]  napi_gro_receive+0xba/0xe0
> [1048271.705839]  receive_buf+0x165/0xa50 [virtio_net]
> [1048271.710839]  ? receive_buf+0x165/0xa50 [virtio_net]
> [1048271.716053]  ? vring_unmap_one+0x16/0x80
> [1048271.720308]  ? detach_buf+0x69/0x110
> [1048271.724218]  virtnet_poll+0xc0/0x2ea [virtio_net]
> [1048271.729202]  net_rx_action+0x149/0x3b0
> [1048271.733234]  __do_softirq+0xe3/0x30a
> [1048271.737095]  irq_exit+0x100/0x110
> [1048271.740882]  do_IRQ+0x85/0xd0
> [1048271.744143]  common_interrupt+0xf/0xf
> [1048271.748104]  </IRQ>
>
>
> thanks,
> jason
