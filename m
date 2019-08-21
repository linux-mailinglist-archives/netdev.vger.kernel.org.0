Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C381F986B4
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 23:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730913AbfHUVjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 17:39:06 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:32872 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbfHUVjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 17:39:06 -0400
Received: by mail-qt1-f195.google.com with SMTP id v38so5015311qtb.0;
        Wed, 21 Aug 2019 14:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DUnGPgYSlYELq8snkCH3/ogLmFH6bABIvcNtaNXTSVc=;
        b=AXDHQob5IyMllJJoCx7ZMR8TK3SJN0l7qIATQtWf6ngixz26/p+Sey60awnPqojOTU
         ECTbzza4sfLN2MZNGWAPC5aO0a/n+iDaEPCfzPGJF911kaP0oySCyhDQenhRqoGE/46f
         SNLMK3otufWhvREna0kxOFS7STmbaaVnCSswUJsIxkc+s50sZi3CxY3Se6mco3tFynew
         5pFuHfoV0v9VCYiMjGnz4d3zyUnuTg5tAPIb9HAxcnHQZxyrEQekItEFl8cKP3TY0Kh0
         uleYqDjSSbn/nF5glEFEJye/1xrV8Du+6FWcXn0h5IoikXVIaQ5kMZ2Ddrb6jckdzwUU
         iJ3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DUnGPgYSlYELq8snkCH3/ogLmFH6bABIvcNtaNXTSVc=;
        b=Nhvd27PLar3qiTcmnUV55G66hokheTyCtPnAPpxZWHjrZJtI3CnI2aqwsBQGoHgEGV
         W75XpnLFHNWtdAUWSCO0CIX5cDsrJ5y60LGl2ADwh0vV+DmtX/Vx0FifiwKwI/fEN3bo
         tty/OL4jSMKrOzEsCV/z/Oe+CMZc2itxQoETWEoMoBYBIDBvsUWbGCKGxDAXIKrjIQbw
         wFK0WClotKIRntIYn+pd4FK7RdsY5wVDsC0H6atv1VQt7tLVEFRJ3Gaf77M5zKAj0v5K
         v9hLB+ZHkdTf9npLJeBTCc82lO0ITkanO7gAvYhp0eEi01SCWcOtpPeBWokrRx3f7YI1
         wZeQ==
X-Gm-Message-State: APjAAAVNgMitA3NrhhnsHdQvmOBNuAdIkT98yPPPVASydcYDu+BjVR8x
        PxyI73/9DJiRl3Mxu7zPyptR1GEjg+QlVwHvO84=
X-Google-Smtp-Source: APXvYqyy0hvvRHykzg7i0XuhNgycH/ll14e3xUl/E4u+m0BQJBHvXmJ9XL1xul4O3FjgxkcePIYvjvZNX2y+J4rwF4w=
X-Received: by 2002:a0c:db12:: with SMTP id d18mr19832519qvk.199.1566423544935;
 Wed, 21 Aug 2019 14:39:04 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20190820151644eucas1p179d6d1da42bb6be0aad8f58ac46624ce@eucas1p1.samsung.com>
 <20190820151611.10727-1-i.maximets@samsung.com> <CAKgT0Udn0D0_f=SOH2wpBRWV_u4rb1Qe2h7gguXnRNzJ_VkRzg@mail.gmail.com>
 <625791af-c656-1e42-b60e-b3a5cedcb4c4@samsung.com> <CAKgT0Uc27+ucd=a_sgTmv5g7_+ZTg1zK4isYJ0H7YWQj3d=Ejg@mail.gmail.com>
 <f7d0f7a5-e664-8b72-99c7-63275aff4c18@samsung.com> <CAKgT0UcCKiM1Ys=vWxctprN7fzWcBCk-PCuKB-8=RThM=CqLSQ@mail.gmail.com>
In-Reply-To: <CAKgT0UcCKiM1Ys=vWxctprN7fzWcBCk-PCuKB-8=RThM=CqLSQ@mail.gmail.com>
From:   William Tu <u9012063@gmail.com>
Date:   Wed, 21 Aug 2019 14:38:28 -0700
Message-ID: <CALDO+SZCbxEEwCS6MyHk-Cp_LJ33N=QFqwZ8uRm0e-PBRgxRYw@mail.gmail.com>
Subject: Re: [PATCH net] ixgbe: fix double clean of tx descriptors with xdp
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Ilya Maximets <i.maximets@samsung.com>,
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

On Wed, Aug 21, 2019 at 9:57 AM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Wed, Aug 21, 2019 at 9:22 AM Ilya Maximets <i.maximets@samsung.com> wr=
ote:
> >
> > On 21.08.2019 4:17, Alexander Duyck wrote:
> > > On Tue, Aug 20, 2019 at 8:58 AM Ilya Maximets <i.maximets@samsung.com=
> wrote:
> > >>
> > >> On 20.08.2019 18:35, Alexander Duyck wrote:
> > >>> On Tue, Aug 20, 2019 at 8:18 AM Ilya Maximets <i.maximets@samsung.c=
om> wrote:
> > >>>>
> > >>>> Tx code doesn't clear the descriptor status after cleaning.
> > >>>> So, if the budget is larger than number of used elems in a ring, s=
ome
> > >>>> descriptors will be accounted twice and xsk_umem_complete_tx will =
move
> > >>>> prod_tail far beyond the prod_head breaking the comletion queue ri=
ng.
> > >>>>
> > >>>> Fix that by limiting the number of descriptors to clean by the num=
ber
> > >>>> of used descriptors in the tx ring.
> > >>>>
> > >>>> Fixes: 8221c5eba8c1 ("ixgbe: add AF_XDP zero-copy Tx support")
> > >>>> Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
> > >>>
> > >>> I'm not sure this is the best way to go. My preference would be to
> > >>> have something in the ring that would prevent us from racing which =
I
> > >>> don't think this really addresses. I am pretty sure this code is sa=
fe
> > >>> on x86 but I would be worried about weak ordered systems such as
> > >>> PowerPC.
> > >>>
> > >>> It might make sense to look at adding the eop_desc logic like we ha=
ve
> > >>> in the regular path with a proper barrier before we write it and af=
ter
> > >>> we read it. So for example we could hold of on writing the bytecoun=
t
> > >>> value until the end of an iteration and call smp_wmb before we writ=
e
> > >>> it. Then on the cleanup we could read it and if it is non-zero we t=
ake
> > >>> an smp_rmb before proceeding further to process the Tx descriptor a=
nd
> > >>> clearing the value. Otherwise this code is going to just keep poppi=
ng
> > >>> up with issues.
> > >>
> > >> But, unlike regular case, xdp zero-copy xmit and clean for particula=
r
> > >> tx ring always happens in the same NAPI context and even on the same
> > >> CPU core.
> > >>
> > >> I saw the 'eop_desc' manipulations in regular case and yes, we could
> > >> use 'next_to_watch' field just as a flag of descriptor existence,
> > >> but it seems unnecessarily complicated. Am I missing something?
> > >>
> > >
> > > So is it always in the same NAPI context?. I forgot, I was thinking
> > > that somehow the socket could possibly make use of XDP for transmit.
> >
> > AF_XDP socket only triggers tx interrupt on ndo_xsk_async_xmit() which
> > is used in zero-copy mode. Real xmit happens inside
> > ixgbe_poll()
> >  -> ixgbe_clean_xdp_tx_irq()
> >     -> ixgbe_xmit_zc()
> >
> > This should be not possible to bound another XDP socket to the same net=
dev
> > queue.
> >
> > It also possible to xmit frames in xdp_ring while performing XDP_TX/RED=
IRECT
> > actions. REDIRECT could happen from different netdev with different NAP=
I
> > context, but this operation is bound to specific CPU core and each core=
 has
> > its own xdp_ring.
> >
> > However, I'm not an expert here.
> > Bj=C3=B6rn, maybe you could comment on this?
> >
> > >
> > > As far as the logic to use I would be good with just using a value yo=
u
> > > are already setting such as the bytecount value. All that would need
> > > to happen is to guarantee that the value is cleared in the Tx path. S=
o
> > > if you clear the bytecount in ixgbe_clean_xdp_tx_irq you could
> > > theoretically just use that as well to flag that a descriptor has bee=
n
> > > populated and is ready to be cleaned. Assuming the logic about this
> > > all being in the same NAPI context anyway you wouldn't need to mess
> > > with the barrier stuff I mentioned before.
> >
> > Checking the number of used descs, i.e. next_to_use - next_to_clean,
> > makes iteration in this function logically equal to the iteration insid=
e
> > 'ixgbe_xsk_clean_tx_ring()'. Do you think we need to change the later
> > function too to follow same 'bytecount' approach? I don't like having
> > two different ways to determine number of used descriptors in the same =
file.
> >
> > Best regards, Ilya Maximets.
>
> As far as ixgbe_clean_xdp_tx_irq() vs ixgbe_xsk_clean_tx_ring(), I
> would say that if you got rid of budget and framed things more like
> how ixgbe_xsk_clean_tx_ring was framed with the ntc !=3D ntu being
> obvious I would prefer to see us go that route.
>
> Really there is no need for budget in ixgbe_clean_xdp_tx_irq() if you
> are going to be working with a static ntu value since you will only
> ever process one iteration through the ring anyway. It might make more
> sense if you just went through and got rid of budget and i, and
> instead used ntc and ntu like what was done in
> ixgbe_xsk_clean_tx_ring().
>
> Thanks.
>
> - Alex

Not familiar with the driver details.
I tested this patch and the issue mentioned in OVS mailing list.
https://www.mail-archive.com/ovs-dev@openvswitch.org/msg35362.html
and indeed the problem goes away. But I saw a huge performance drop,
my AF_XDP tx performance drops from >9Mpps to <5Mpps.

Tested using kernel 5.3.0-rc3+
03:00.0 Ethernet controller: Intel Corporation Ethernet Controller
10-Gigabit X540-AT2 (rev 01)
Subsystem: Intel Corporation Ethernet 10G 2P X540-t Adapter
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+

Regards,
William
