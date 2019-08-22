Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91D7F998CF
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 18:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389763AbfHVQIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 12:08:31 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:45298 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733155AbfHVQIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 12:08:30 -0400
Received: by mail-qk1-f196.google.com with SMTP id m2so5596757qki.12;
        Thu, 22 Aug 2019 09:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TMaoiNeDTQTd0JYgJVXpjjLos7pKWO83AVF6+JcNwlg=;
        b=LCrFl0JE5Ih0OQX6yFnKtnAzFMDwIlQbdd8oMlBLpHTr3iOphhqUs6bxk4lw1E6tQg
         yUnVimyWbghFyo4vEmHr0lTeCr+Y+J6Q339QNW2bt0ViAmrAaoqTGUZ5DtsNWbB8Xbke
         QN+k0VH+SKQUrPAZik6dx48a2ilmSu3ET1n6TEEZtIqenA+jtt58fGIPTC7qmcN0+eQI
         yjXWVGi8mGnCtUQeSu3yz+E1YeHFpYsNboWGhWJ+g6tuXPXWxQTIOmqbB0BnnPQCrRg8
         OrhWesFAWbw2kd5I/pIxHPwBTTFZMKOl4NSODYghIRuaPYk1qwQqxHWbOPMyjLzIfZd6
         tKqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TMaoiNeDTQTd0JYgJVXpjjLos7pKWO83AVF6+JcNwlg=;
        b=oS7/gL2uB2qXpQqd4g5yOPcH8mjyEElSSoxA5DZi905xe0O/69J5DH+xflfSGIzwOC
         AN4rUzCVXPUG5yFRixk3zjOm1dUQPMLxTAmnB+UL6NtfRWoioPTXPTk4W6OTF6ccvlK0
         +/0KKrx2D/B3I2AlFyWBDm052gjfEuWp6HQDGwdE/NMdQ7HSmkiKf1VWuObPVdHnTs33
         vYgm//JB4+wbpVYcXUGbFGt68Qfkrlu5DCLO71ZiiKBJOWtdA3KeLCSospCtCQ4jd7pB
         rg3ItZ3kuday1f2tm6JSR5rCCsgMCX39EGie9SV7sbDbSAlT25m4Wt/yXTGEXbZKG7oe
         NRbg==
X-Gm-Message-State: APjAAAW9TQ0SDgmff432I3B2t2DTsMg3govUPeb4UIPIzr6CZmLQ8LKF
        qVcsj4ryDYfr4POtp21L+6ECOp8kZ3fJNbU9i3w=
X-Google-Smtp-Source: APXvYqyCrSAgGlsFqxSWHd6YgBn0GV2mCyO/I4opzz6lmW8S0os/wBWQjd/DM0YKQq39kgSaWUmQ3HoT+mZamtpuq3E=
X-Received: by 2002:a37:690:: with SMTP id 138mr36902439qkg.184.1566490108954;
 Thu, 22 Aug 2019 09:08:28 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20190820151644eucas1p179d6d1da42bb6be0aad8f58ac46624ce@eucas1p1.samsung.com>
 <20190820151611.10727-1-i.maximets@samsung.com> <CAKgT0Udn0D0_f=SOH2wpBRWV_u4rb1Qe2h7gguXnRNzJ_VkRzg@mail.gmail.com>
 <625791af-c656-1e42-b60e-b3a5cedcb4c4@samsung.com> <CAKgT0Uc27+ucd=a_sgTmv5g7_+ZTg1zK4isYJ0H7YWQj3d=Ejg@mail.gmail.com>
 <f7d0f7a5-e664-8b72-99c7-63275aff4c18@samsung.com> <CAKgT0UcCKiM1Ys=vWxctprN7fzWcBCk-PCuKB-8=RThM=CqLSQ@mail.gmail.com>
 <CALDO+SZCbxEEwCS6MyHk-Cp_LJ33N=QFqwZ8uRm0e-PBRgxRYw@mail.gmail.com> <cbf7c51b-9ce7-6ef6-32c4-981258d4af4c@samsung.com>
In-Reply-To: <cbf7c51b-9ce7-6ef6-32c4-981258d4af4c@samsung.com>
From:   William Tu <u9012063@gmail.com>
Date:   Thu, 22 Aug 2019 09:07:50 -0700
Message-ID: <CALDO+SaRNMvmXrQqOtNiRsOkgfOQAW4EA2yVgmeoGQto2zvfMQ@mail.gmail.com>
Subject: Re: [PATCH net] ixgbe: fix double clean of tx descriptors with xdp
To:     Ilya Maximets <i.maximets@samsung.com>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Eelco Chaudron <echaudro@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 22, 2019 at 1:17 AM Ilya Maximets <i.maximets@samsung.com> wrot=
e:
>
> On 22.08.2019 0:38, William Tu wrote:
> > On Wed, Aug 21, 2019 at 9:57 AM Alexander Duyck
> > <alexander.duyck@gmail.com> wrote:
> >>
> >> On Wed, Aug 21, 2019 at 9:22 AM Ilya Maximets <i.maximets@samsung.com>=
 wrote:
> >>>
> >>> On 21.08.2019 4:17, Alexander Duyck wrote:
> >>>> On Tue, Aug 20, 2019 at 8:58 AM Ilya Maximets <i.maximets@samsung.co=
m> wrote:
> >>>>>
> >>>>> On 20.08.2019 18:35, Alexander Duyck wrote:
> >>>>>> On Tue, Aug 20, 2019 at 8:18 AM Ilya Maximets <i.maximets@samsung.=
com> wrote:
> >>>>>>>
> >>>>>>> Tx code doesn't clear the descriptor status after cleaning.
> >>>>>>> So, if the budget is larger than number of used elems in a ring, =
some
> >>>>>>> descriptors will be accounted twice and xsk_umem_complete_tx will=
 move
> >>>>>>> prod_tail far beyond the prod_head breaking the comletion queue r=
ing.
> >>>>>>>
> >>>>>>> Fix that by limiting the number of descriptors to clean by the nu=
mber
> >>>>>>> of used descriptors in the tx ring.
> >>>>>>>
> >>>>>>> Fixes: 8221c5eba8c1 ("ixgbe: add AF_XDP zero-copy Tx support")
> >>>>>>> Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
> >>>>>>
> >>>>>> I'm not sure this is the best way to go. My preference would be to
> >>>>>> have something in the ring that would prevent us from racing which=
 I
> >>>>>> don't think this really addresses. I am pretty sure this code is s=
afe
> >>>>>> on x86 but I would be worried about weak ordered systems such as
> >>>>>> PowerPC.
> >>>>>>
> >>>>>> It might make sense to look at adding the eop_desc logic like we h=
ave
> >>>>>> in the regular path with a proper barrier before we write it and a=
fter
> >>>>>> we read it. So for example we could hold of on writing the bytecou=
nt
> >>>>>> value until the end of an iteration and call smp_wmb before we wri=
te
> >>>>>> it. Then on the cleanup we could read it and if it is non-zero we =
take
> >>>>>> an smp_rmb before proceeding further to process the Tx descriptor =
and
> >>>>>> clearing the value. Otherwise this code is going to just keep popp=
ing
> >>>>>> up with issues.
> >>>>>
> >>>>> But, unlike regular case, xdp zero-copy xmit and clean for particul=
ar
> >>>>> tx ring always happens in the same NAPI context and even on the sam=
e
> >>>>> CPU core.
> >>>>>
> >>>>> I saw the 'eop_desc' manipulations in regular case and yes, we coul=
d
> >>>>> use 'next_to_watch' field just as a flag of descriptor existence,
> >>>>> but it seems unnecessarily complicated. Am I missing something?
> >>>>>
> >>>>
> >>>> So is it always in the same NAPI context?. I forgot, I was thinking
> >>>> that somehow the socket could possibly make use of XDP for transmit.
> >>>
> >>> AF_XDP socket only triggers tx interrupt on ndo_xsk_async_xmit() whic=
h
> >>> is used in zero-copy mode. Real xmit happens inside
> >>> ixgbe_poll()
> >>>  -> ixgbe_clean_xdp_tx_irq()
> >>>     -> ixgbe_xmit_zc()
> >>>
> >>> This should be not possible to bound another XDP socket to the same n=
etdev
> >>> queue.
> >>>
> >>> It also possible to xmit frames in xdp_ring while performing XDP_TX/R=
EDIRECT
> >>> actions. REDIRECT could happen from different netdev with different N=
API
> >>> context, but this operation is bound to specific CPU core and each co=
re has
> >>> its own xdp_ring.
> >>>
> >>> However, I'm not an expert here.
> >>> Bj=C3=B6rn, maybe you could comment on this?
> >>>
> >>>>
> >>>> As far as the logic to use I would be good with just using a value y=
ou
> >>>> are already setting such as the bytecount value. All that would need
> >>>> to happen is to guarantee that the value is cleared in the Tx path. =
So
> >>>> if you clear the bytecount in ixgbe_clean_xdp_tx_irq you could
> >>>> theoretically just use that as well to flag that a descriptor has be=
en
> >>>> populated and is ready to be cleaned. Assuming the logic about this
> >>>> all being in the same NAPI context anyway you wouldn't need to mess
> >>>> with the barrier stuff I mentioned before.
> >>>
> >>> Checking the number of used descs, i.e. next_to_use - next_to_clean,
> >>> makes iteration in this function logically equal to the iteration ins=
ide
> >>> 'ixgbe_xsk_clean_tx_ring()'. Do you think we need to change the later
> >>> function too to follow same 'bytecount' approach? I don't like having
> >>> two different ways to determine number of used descriptors in the sam=
e file.
> >>>
> >>> Best regards, Ilya Maximets.
> >>
> >> As far as ixgbe_clean_xdp_tx_irq() vs ixgbe_xsk_clean_tx_ring(), I
> >> would say that if you got rid of budget and framed things more like
> >> how ixgbe_xsk_clean_tx_ring was framed with the ntc !=3D ntu being
> >> obvious I would prefer to see us go that route.
> >>
> >> Really there is no need for budget in ixgbe_clean_xdp_tx_irq() if you
> >> are going to be working with a static ntu value since you will only
> >> ever process one iteration through the ring anyway. It might make more
> >> sense if you just went through and got rid of budget and i, and
> >> instead used ntc and ntu like what was done in
> >> ixgbe_xsk_clean_tx_ring().
> >>
> >> Thanks.
> >>
> >> - Alex
> >
> > Not familiar with the driver details.
> > I tested this patch and the issue mentioned in OVS mailing list.
> > https://www.mail-archive.com/ovs-dev@openvswitch.org/msg35362.html
> > and indeed the problem goes away.
>
> Good. Thanks for testing!
>
> > But I saw a huge performance drop,
> > my AF_XDP tx performance drops from >9Mpps to <5Mpps.
>
> I didn't expect so big performance difference with this change.
> What is your test scenario?

I was using OVS with dual port NIC, setting one OpenFlow rule
in_port=3Deth2 actions=3Doutput:eth3
and eth2 for rx and measure eth3 tx
'sar -n DEV 1'  shows pretty huge drop on eth3 tx.

> Is it possible that you're accounting same
> packet several times due to broken completion queue?

That's possible.
Let me double check on your v2 patch.

@Eelco: do you also see some performance difference?

Regards,
William

>
> Looking at samples/bpf/xdpsock_user.c:complete_tx_only(), it accounts
> sent packets (tx_npkts) by accumulating results of xsk_ring_cons__peek()
> for completion queue, so it's not a trusted source of pps information.
>
> Best regards, Ilya Maximets.
>
> >
> > Tested using kernel 5.3.0-rc3+
> > 03:00.0 Ethernet controller: Intel Corporation Ethernet Controller
> > 10-Gigabit X540-AT2 (rev 01)
> > Subsystem: Intel Corporation Ethernet 10G 2P X540-t Adapter
> > Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> > Stepping- SERR- FastB2B- DisINTx+
> >
> > Regards,
> > William
