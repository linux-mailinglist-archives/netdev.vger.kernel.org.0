Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91B6D83A57
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 22:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726602AbfHFUeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 16:34:05 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:33522 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbfHFUeF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 16:34:05 -0400
Received: by mail-qk1-f193.google.com with SMTP id r6so64067071qkc.0;
        Tue, 06 Aug 2019 13:34:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=vrBHbZVXUFJRRCwr71Kow/OPB2DnvvYiqNiVLPXlk+o=;
        b=FN6Bs8p2n0dGBeQOhFCuD0Tq1UGEcKRA+KYqKln93Pucplv+dijTtDVOtD2dIm/SK0
         eFPVEN3XwCmfiGy/QwrokCMc3neg5eDFukSTbU60ILR0cTqZC4/bCTdVas0HtE0DtAEC
         V43gL3KyRrNqXTrFArpV2eSHXbp0AT3vrG9v+yABaWkKxlcWjOafu0AvK2gcazg/XSf1
         kP1mXQBJ7+4BAl7XCEpcXAoU0GlzEQ5oE2hmPgv5SrEAURXx4EkSDJOVR+pdoPp1LnUe
         ATjzOcMdZODGn8YxARe/qFI46/KZfw9hJMZgtiWxwmVHbFc4o0xcXCmrcqXwUkU0qrRr
         haAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=vrBHbZVXUFJRRCwr71Kow/OPB2DnvvYiqNiVLPXlk+o=;
        b=kRiiklsrDPeE3SrEl0jvLEIQGdcks1oxHXbAgtjqMGooGk6S5W+hKJXzJQSiwujhT2
         inISLyCL8DBetMZeMN8WryfSAQy5CbGZsA73d3uinsqd06Mt6mKaEYDpZHpYF16+y1m1
         5CKOyyN0G/62TDQWdmYIfx/buVzgeE9Xif/RsmOdCr8Ejb9JxcZmORWezVHe4mLA0HK9
         KrTnQmVSXSEr+ucfLUyk5Hb8ZfEp0cfYCEJhsB9jQh2AKLDj4mmEUKA2h6yplVRkjuUB
         BkaCxSnVG21UpAD6TK1vdY2rAzjf7cvHeqRENMiNtCdOMypg07wl/ppyCFlUj3D9iQOf
         +dsA==
X-Gm-Message-State: APjAAAWcbBuEOUH2OiJlUOiEm0/iTD+HcuAaYJiOzG5kyzbosOu346RT
        hFmNFSuWNHzpxVMZoFZpyF4=
X-Google-Smtp-Source: APXvYqw8LVY7VU7VdbbwwNbsSfalElO+JZh0dtQYw7Lz3uCyElTm26iBASAeEy4stGY23J3kQDKDfg==
X-Received: by 2002:a37:7d02:: with SMTP id y2mr3000400qkc.419.1565123643708;
        Tue, 06 Aug 2019 13:34:03 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id g35sm47638049qtg.92.2019.08.06.13.34.02
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 13:34:02 -0700 (PDT)
Date:   Tue, 6 Aug 2019 16:34:02 -0400
Message-ID: <20190806163402.GB16656@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Chen-Yu Tsai <wens@kernel.org>
Cc:     Chen-Yu Tsai <wens@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v2] net: dsa: Check existence of .port_mdb_add
 callback before calling it
In-Reply-To: <CAGb2v67cZb_JKDHSb-9Tm1KnTxw5FOG3faZoQSGef_FzkdSszA@mail.gmail.com>
References: <20190806075325.9011-1-wens@kernel.org>
 <20190806131513.GB2822@t480s.localdomain>
 <CAGb2v67cZb_JKDHSb-9Tm1KnTxw5FOG3faZoQSGef_FzkdSszA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Chen-Yu,

On Wed, 7 Aug 2019 01:49:37 +0800, Chen-Yu Tsai <wens@kernel.org> wrote:
> On Wed, Aug 7, 2019 at 1:15 AM Vivien Didelot <vivien.didelot@gmail.com> wrote:
> >
> > Hi Chen-Yu,
> >
> > On Tue,  6 Aug 2019 15:53:25 +0800, Chen-Yu Tsai <wens@kernel.org> wrote:
> > > From: Chen-Yu Tsai <wens@csie.org>
> > >
> > > With the recent addition of commit 75dad2520fc3 ("net: dsa: b53: Disable
> > > all ports on setup"), users of b53 (BCM53125 on Lamobo R1 in my case)
> > > are forced to use the dsa subsystem to enable the switch, instead of
> > > having it in the default transparent "forward-to-all" mode.
> > >
> > > The b53 driver does not support mdb bitmap functions. However the dsa
> > > layer does not check for the existence of the .port_mdb_add callback
> > > before actually using it. This results in a NULL pointer dereference,
> > > as shown in the kernel oops below.
> > >
> > > The other functions seem to be properly guarded. Do the same for
> > > .port_mdb_add in dsa_switch_mdb_add_bitmap() as well.
> > >
> > > b53 is not the only driver that doesn't support mdb bitmap functions.
> > > Others include bcm_sf2, dsa_loop, lantiq_gswip, mt7530, mv88e6060,
> > > qca8k, realtek-smi, and vitesse-vsc73xx.
> >
> > I don't know what you mean by that, there's no "mdb bitmap function"
> > support for drivers, only the port_mdb_{prepare,add,del} callbacks...
> 
> The term was coined from commit e6db98db8a95 ("net: dsa: add switch mdb
> bitmap functions"). But yeah, .port_mdb_* ops/callbacks would be more
> appropriate.
> 
> > >     8<--- cut here ---
> > >     Unable to handle kernel NULL pointer dereference at virtual address 00000000
> > >     pgd = (ptrval)
> > >     [00000000] *pgd=00000000
> > >     Internal error: Oops: 80000005 [#1] SMP ARM
> > >     Modules linked in: rtl8xxxu rtl8192cu rtl_usb rtl8192c_common rtlwifi mac80211 cfg80211
> > >     CPU: 1 PID: 134 Comm: kworker/1:2 Not tainted 5.3.0-rc1-00247-gd3519030752a #1
> > >     Hardware name: Allwinner sun7i (A20) Family
> > >     Workqueue: events switchdev_deferred_process_work
> > >     PC is at 0x0
> > >     LR is at dsa_switch_event+0x570/0x620
> > >     pc : [<00000000>]    lr : [<c08533ec>]    psr: 80070013
> > >     sp : ee871db8  ip : 00000000  fp : ee98d0a4
> > >     r10: 0000000c  r9 : 00000008  r8 : ee89f710
> > >     r7 : ee98d040  r6 : ee98d088  r5 : c0f04c48  r4 : ee98d04c
> > >     r3 : 00000000  r2 : ee89f710  r1 : 00000008  r0 : ee98d040
> > >     Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
> > >     Control: 10c5387d  Table: 6deb406a  DAC: 00000051
> > >     Process kworker/1:2 (pid: 134, stack limit = 0x(ptrval))
> > >     Stack: (0xee871db8 to 0xee872000)
> > >     1da0:                                                       ee871e14 103ace2d
> > >     1dc0: 00000000 ffffffff 00000000 ee871e14 00000005 00000000 c08524a0 00000000
> > >     1de0: ffffe000 c014bdfc c0f04c48 ee871e98 c0f04c48 ee9e5000 c0851120 c014bef0
> > >     1e00: 00000000 b643aea2 ee9b4068 c08509a8 ee2bf940 ee89f710 ee871ecb 00000000
> > >     1e20: 00000008 103ace2d 00000000 c087e248 ee29c868 103ace2d 00000001 ffffffff
> > >     1e40: 00000000 ee871e98 00000006 00000000 c0fb2a50 c087e2d0 ffffffff c08523c4
> > >     1e60: ffffffff c014bdfc 00000006 c0fad2d0 ee871e98 ee89f710 00000000 c014c500
> > >     1e80: 00000000 ee89f3c0 c0f04c48 00000000 ee9e5000 c087dfb4 ee9e5000 00000000
> > >     1ea0: ee89f710 ee871ecb 00000001 103ace2d 00000000 c0f04c48 00000000 c087e0a8
> > >     1ec0: 00000000 efd9a3e0 0089f3c0 103ace2d ee89f700 ee89f710 ee9e5000 00000122
> > >     1ee0: 00000100 c087e130 ee89f700 c0fad2c8 c1003ef0 c087de4c 2e928000 c0fad2ec
> > >     1f00: c0fad2ec ee839580 ef7a62c0 ef7a9400 00000000 c087def8 c0fad2ec c01447dc
> > >     1f20: ef315640 ef7a62c0 00000008 ee839580 ee839594 ef7a62c0 00000008 c0f03d00
> > >     1f40: ef7a62d8 ef7a62c0 ffffe000 c0145b84 ffffe000 c0fb2420 c0bfaa8c 00000000
> > >     1f60: ffffe000 ee84b600 ee84b5c0 00000000 ee870000 ee839580 c0145b40 ef0e5ea4
> > >     1f80: ee84b61c c014a6f8 00000001 ee84b5c0 c014a5b0 00000000 00000000 00000000
> > >     1fa0: 00000000 00000000 00000000 c01010e8 00000000 00000000 00000000 00000000
> > >     1fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> > >     1fe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 00000000
> > >     [<c08533ec>] (dsa_switch_event) from [<c014bdfc>] (notifier_call_chain+0x48/0x84)
> > >     [<c014bdfc>] (notifier_call_chain) from [<c014bef0>] (raw_notifier_call_chain+0x18/0x20)
> > >     [<c014bef0>] (raw_notifier_call_chain) from [<c08509a8>] (dsa_port_mdb_add+0x48/0x74)
> > >     [<c08509a8>] (dsa_port_mdb_add) from [<c087e248>] (__switchdev_handle_port_obj_add+0x54/0xd4)
> > >     [<c087e248>] (__switchdev_handle_port_obj_add) from [<c087e2d0>] (switchdev_handle_port_obj_add+0x8/0x14)
> > >     [<c087e2d0>] (switchdev_handle_port_obj_add) from [<c08523c4>] (dsa_slave_switchdev_blocking_event+0x94/0xa4)
> > >     [<c08523c4>] (dsa_slave_switchdev_blocking_event) from [<c014bdfc>] (notifier_call_chain+0x48/0x84)
> > >     [<c014bdfc>] (notifier_call_chain) from [<c014c500>] (blocking_notifier_call_chain+0x50/0x68)
> > >     [<c014c500>] (blocking_notifier_call_chain) from [<c087dfb4>] (switchdev_port_obj_notify+0x44/0xa8)
> > >     [<c087dfb4>] (switchdev_port_obj_notify) from [<c087e0a8>] (switchdev_port_obj_add_now+0x90/0x104)
> > >     [<c087e0a8>] (switchdev_port_obj_add_now) from [<c087e130>] (switchdev_port_obj_add_deferred+0x14/0x5c)
> > >     [<c087e130>] (switchdev_port_obj_add_deferred) from [<c087de4c>] (switchdev_deferred_process+0x64/0x104)
> > >     [<c087de4c>] (switchdev_deferred_process) from [<c087def8>] (switchdev_deferred_process_work+0xc/0x14)
> > >     [<c087def8>] (switchdev_deferred_process_work) from [<c01447dc>] (process_one_work+0x218/0x50c)
> > >     [<c01447dc>] (process_one_work) from [<c0145b84>] (worker_thread+0x44/0x5bc)
> > >     [<c0145b84>] (worker_thread) from [<c014a6f8>] (kthread+0x148/0x150)
> > >     [<c014a6f8>] (kthread) from [<c01010e8>] (ret_from_fork+0x14/0x2c)
> > >     Exception stack(0xee871fb0 to 0xee871ff8)
> > >     1fa0:                                     00000000 00000000 00000000 00000000
> > >     1fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> > >     1fe0: 00000000 00000000 00000000 00000000 00000013 00000000
> > >     Code: bad PC value
> > >     ---[ end trace 1292c61abd17b130 ]---
> > >
> > >     [<c08533ec>] (dsa_switch_event) from [<c014bdfc>] (notifier_call_chain+0x48/0x84)
> > >     corresponds to
> > >
> > >       $ arm-linux-gnueabihf-addr2line -C -i -e vmlinux c08533ec
> > >
> > >       linux/net/dsa/switch.c:156
> > >       linux/net/dsa/switch.c:178
> > >       linux/net/dsa/switch.c:328
> > >
> > > Fixes: e6db98db8a95 ("net: dsa: add switch mdb bitmap functions")
> > > Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> > > ---
> > > Changes since v1:
> > >
> > >   - Moved the check to the beginning of dsa_switch_mdb_add()
> > >
> > > Looks like we could also move the ops check out of
> > > dsa_switch_mdb_prepare_bitmap(), though I suppose keeping the code the
> > > way it is now is clearer.
> > >
> > > ---
> > >  net/dsa/switch.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > >
> > > diff --git a/net/dsa/switch.c b/net/dsa/switch.c
> > > index 4ec5b7f85d51..231af5268656 100644
> > > --- a/net/dsa/switch.c
> > > +++ b/net/dsa/switch.c
> > > @@ -164,6 +164,9 @@ static int dsa_switch_mdb_add(struct dsa_switch *ds,
> > >       struct switchdev_trans *trans = info->trans;
> > >       int port;
> > >
> > > +     if (!ds->ops->port_mdb_add)
> > > +             return -EOPNOTSUPP;
> > > +
> > >       /* Build a mask of Multicast group members */
> > >       bitmap_zero(ds->bitmap, ds->num_ports);
> > >       if (ds->index == info->sw_index)
> > > --
> > > 2.20.1
> > >
> >
> > I don't understand the crash here, nor the fix. dsa_switch_mdb_add()
> > is supposed to be called through switchdev with a prepare phase,
> > which checks for ds->ops->port_mdb_add. Do you mean that a switchdev
> > MDB object is added somewhere without a prepare phase? If that's
> > the case, this is what the commit message must say. Then the
> 
> I had pretty much zero understanding of how switchdev and dsa work.
> The symptom is a NULL pointer reference, resulting from an unsupported
> callback that was not checked before being called, as described above.
> And that is what I mean. A NULL pointer reference happened when it
> should not have.
> 
> Based on what you just mentioned, yes it does look like an object was
> added without a prepare phase. Randomly looking through the net/dsa
> code, it seems only dsa_port_vid_add() does a prepare phase, judging
> by .ph_prepare being set. dsa_port_{vlan,mbd,fdb}_add directly call
> the add phase, without the prepare phase. So I'm guessing "supposed
> to be called with a prepare phase" is not quite accurate. This also
> exceeds the scope of the simple fix I had in mind.
> 
> > ds->ops->port_mdb_add check must go where it is used, that is to say
> > at the beginning of dsa_switch_mdb_add_bitmap() (similarly to what
> > dsa_switch_mdb_prepare_bitmap() does), not in dsa_switch_mdb_add.
> 
> Andrew asked me to move it to where it is now. Please take a look at
> v1 [2] if it's what you would like.
> 
> I'm ok either way.

I still cannot find in the code where a SWITCHDEV_OBJ_ID_PORT_MDB object
gets added without a prepare phase or a trans object, but it wouldn't hurt to
double check the presence of ds->ops->port_mdb_add before calling it anyway,
since a patch may actually bypass this prepare phase.

Your v1 patch was a bit confusing and changed the signature of the function
at the same time. Please check the callback where it is used, like this:

    diff --git a/net/dsa/switch.c b/net/dsa/switch.c
    index 4ec5b7f85d51..09d9286b27cc 100644
    --- a/net/dsa/switch.c
    +++ b/net/dsa/switch.c
    @@ -153,6 +153,9 @@ static void dsa_switch_mdb_add_bitmap(struct dsa_switch *ds,
     {
            int port;
     
    +       if (!ds->ops->port_mdb_add)
    +               return;
    +
            for_each_set_bit(port, bitmap, ds->num_ports)
                    ds->ops->port_mdb_add(ds, port, mdb);
     }


This will be easier to maintain. Please provide a simpler commit message,
this one is not relevant. Are you actually able to reproduce this stack
trace? If not, that is not necessary to add it to the commit message...


Thank you for your patience,

	Vivien
