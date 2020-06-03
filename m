Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB99D1ED173
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 15:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbgFCNvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 09:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbgFCNvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 09:51:47 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4789DC08C5C0;
        Wed,  3 Jun 2020 06:51:47 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id w15so1349124lfe.11;
        Wed, 03 Jun 2020 06:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ynGubvv1lmJWgKvcuVKEC2BlJOItbIGYAHQ5FZLJdXc=;
        b=nv7BQ7nd558gTRBx1gpQtkB4AASf1WpGTDlSi+XRqpqBiWXAdWx7PXZNXp0mAOV7L1
         IlrO3mgTvKSCwQfsG2jePNFIP3YK/VGecuiVhlhsWPxY008GW5d6vHeCp/1RXbiOAC7h
         Vk6aI9eBA5aepCJSq4vXw0d7crfqDwVKipz/CIp33JuUqPCKLSi7H7mRT6KMO7Dtzl58
         foMgeePlRhYWQUZqzW0yjoFvPBO6UyxOXtiR6fqVb1KCckfomW83DxFV4Jo3jmbUthLU
         YMSikTOTJIkhvjFKesHqmlqBjlMEFRE7qNeSRorEE7CqL5BkTq3QV49RMdPpn0B+qBbj
         ZuMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ynGubvv1lmJWgKvcuVKEC2BlJOItbIGYAHQ5FZLJdXc=;
        b=sx4EldfJ+Khp7HpPMt3PLbOc0ibmf45Cv064KyTFRpqD2XRv4yNkktc6vimwWZulie
         tydZfKbNAPJ04Y9g13bn77UPAJoFbLYKQClq10CJTZDWKoaWvpA2dBrzBKjEz9j3hIfW
         tFVGEMQ/w7Iuz+t3cmJsrceg0ozw3Sd+wb++Th5n+QEjMCgRgeIyLbxrRsxFswILhAtU
         d1Lxi/lD+7lUfioWB/0K5dsdEC3LszF8/qWBVa/w3N+Wccg8OnQquBHn9jXOSEWJf2Z3
         rH+lf5Phh1m1m4JcFWVTl1dNIOwUule4wsO4jVhBtjw6tgbR8Z0hQUPtuZNy1TY+tGwM
         ZMcg==
X-Gm-Message-State: AOAM533pcaMRRw4pca3OQ3+ZCvlHPWr5GDABsQ/UcME3SOwq27HBGc0s
        qZrLRml2j67dGqEfrhtGTEGkcHl9nDUWora4fiC7hOxLtrA=
X-Google-Smtp-Source: ABdhPJzwXeSetxU7Ts8RRJiSyxD/Af2iDDUT+Ltxy+kX+GR+P7ziqOKvTXQCW/Fn/KOe+KEQ5e82p437f1NO7Cqi1u0=
X-Received: by 2002:ac2:5197:: with SMTP id u23mr2534893lfi.109.1591192305763;
 Wed, 03 Jun 2020 06:51:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200602080425.93712-1-kerneljasonxing@gmail.com>
 <CANn89iLNCDuXAhj4By0PDKbuFvneVfwmwkLbRCEKLBF+pmNEPg@mail.gmail.com>
 <CAL+tcoBjjwrkE5QbXDFADRGJfPoniLL1rMFNUkAKBN9L57UGHA@mail.gmail.com>
 <CANn89iKDKnnW1na_F0ngGh3EEc0quuBB2XWo21oAKaHckdPK4w@mail.gmail.com>
 <CAL+tcoDn_=T--uB0CRymfTGvD022PPDk5Yw2yCxvqOOpZ4G_dQ@mail.gmail.com>
 <CANn89i+dPu9=qJowhRVm9d3CesY4p+zzJ0HGiCMc_yJxux6pow@mail.gmail.com>
 <CAL+tcoC2+vYoFbujkLCF7P3evfirNSBQtJ9bPFHiU2FGOnBo+A@mail.gmail.com>
 <CANn89iJfLM2Hz69d9qOZoRKwzzCCpgVRZ1zbTTbg4vGvSAEZ-w@mail.gmail.com> <CADVnQy=RJfmzHR15DyWdydFAqSqVmFhaW4_cgYYAgnixEa5DNQ@mail.gmail.com>
In-Reply-To: <CADVnQy=RJfmzHR15DyWdydFAqSqVmFhaW4_cgYYAgnixEa5DNQ@mail.gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Wed, 3 Jun 2020 21:51:09 +0800
Message-ID: <CAL+tcoCnsEi8KahgbhrVDawdhsjnAS4X8je0oCE-KZoCyf1Gcg@mail.gmail.com>
Subject: Re: [PATCH] tcp: fix TCP socks unreleased in BBR mode
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        liweishi <liweishi@kuaishou.com>,
        Shujin Li <lishujin@kuaishou.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 3, 2020 at 8:02 PM Neal Cardwell <ncardwell@google.com> wrote:
>
> On Wed, Jun 3, 2020 at 1:44 AM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Tue, Jun 2, 2020 at 10:05 PM Jason Xing <kerneljasonxing@gmail.com> wrote:
> > >
> > > Hi Eric,
> > >
> > > I'm still trying to understand what you're saying before. Would this
> > > be better as following:
> > > 1) discard the tcp_internal_pacing() function.
> > > 2) remove where the tcp_internal_pacing() is called in the
> > > __tcp_transmit_skb() function.
> > >
> > > If we do so, we could avoid 'too late to give up pacing'. Meanwhile,
> > > should we introduce the tcp_wstamp_ns socket field as commit
> > > (864e5c090749) does?
> > >
> >
> > Please do not top-post on netdev mailing list.
> >
> >
> > I basically suggested double-checking which point in TCP could end up
> > calling tcp_internal_pacing()
> > while the timer was already armed.
> >
> > I guess this is mtu probing.

I tested the patch Eric suggested and the system display the stack
trace which means there's one more exception we have to take into
consideration. The call trace is listed as following:
 Call Trace:
  <IRQ>
  __tcp_retransmit_skb+0x188/0x7f0
  ? bbr_set_state+0x7f/0x90 [tcp_bbr]
  tcp_retransmit_skb+0x14/0xc0
  tcp_retransmit_timer+0x313/0xa10
  ? native_sched_clock+0x37/0x90
  ? tcp_write_timer_handler+0x210/0x210
  tcp_write_timer_handler+0xb1/0x210
  tcp_write_timer+0x6d/0x80
  call_timer_fn+0x29/0x110
  run_timer_softirq+0x3cb/0x400
  ? native_sched_clock+0x37/0x90
  __do_softirq+0xdf/0x2ed
  irq_exit+0xf7/0x100
  smp_apic_timer_interrupt+0x68/0x120
  apic_timer_interrupt+0xf/0x20
  </IRQ>

I admitted that this case is not that easily triggered, but it is the
one that avoids the check during tcp_mtu_probe() period. The first skb
is sent out without being checked by tcp_pacing_check  when RTO comes.

>
> Perhaps this could also happen from some of the retransmission code
> paths that don't use tcp_xmit_retransmit_queue()? Perhaps
> tcp_retransmit_timer() (RTO) and  tcp_send_loss_probe() TLP? It seems
> they could indirectly cause a call to __tcp_transmit_skb() and thus
> tcp_internal_pacing() without first checking if the pacing timer was
> already armed?
>

Point taken. There are indeed several places using __tcp_transmit_skb
where could cause such an issue, that is to say, slab increasing. All
these particular cases, I think, should all be taken into account.

Thanks,
Jason

> neal
