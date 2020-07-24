Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E61BE22C4A2
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 14:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbgGXMBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 08:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbgGXMBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 08:01:20 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E9EDC0619D3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 05:01:20 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id e12so6647711qtr.9
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 05:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B/TJIf1eabTNfmjH3Yjf0fPYQgsIOsfcyTkHNZ/tdow=;
        b=XkgtFKjnPJ9tcX/iOQWsjkmNh+TRbfDVTq/5qmItPQ4i+Nwnae2lRn4xeMGVZSGoxg
         borSfj/6y+ISS4zYuBbqHxumXCCA+istxcitnu+HSXJx4DeBnbPhe/n6Gy2M37ud1g/A
         jo2pELG+q6cT7tcIITKaamS5h2k3CLbCMrd1t6TI6qzZgs4uHm/t+pST2OTTXNUNk1u6
         ZYfyNNFsxdud7DdR/uFFIhgbtuZ8WuhVONa5Jut8BzDb4PpojAOLaiM53GSZlvwmzLbN
         8fhPyc5jNISPP2dWph6SpRPyfgrwczBe6XkUmYy9Hr5Ha2rstYVnmOYbu1SmI5vRsLbo
         DgxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B/TJIf1eabTNfmjH3Yjf0fPYQgsIOsfcyTkHNZ/tdow=;
        b=rE4HO4NYSQeKRaIME6I6gCdp0WErZ0qXXXMxIm/gKRiWgCivI5hWvXJCqx7B8zQshA
         xM4jWP8JyFsGJCL3amleod5u0ch198V3o1U1HSwqTiEg+RxqZEHa5RrLkmAaYGc+CsAu
         UThTvbNBOeZfRYWsCiGQYp1ud8SBsORTMbyMpnu+PqnrZ6P4AVwsUPF/83A8qMlcwU5W
         BOMv7jz3iI2Nmv025VLF1lsA3mayLRjQS69cUjNK+aUF+5ttoR9PcL8v1KGlJi/m7tv/
         QeNmFwMq42hm4vWyj4W1EYE6djvBVm52DadqnkCz5MVFgcfsL8HEL7FxpX5/bXLtH327
         YJmA==
X-Gm-Message-State: AOAM530oWnHJ9se+1Z5LBT/eN/tpfeMZCbfQkys8OSNnHYTj5ICG+Kp5
        WYHXMkA4znauPy/sqkj+SXoKIOPeoHc/PwCe7Ao=
X-Google-Smtp-Source: ABdhPJzgJ6gU0M1Qump2Tlb9FxSdzq3JYm6R5eiE+TT8bceDsOORhHLK3Lw3+UUSZl0BXtu3yLgo/rNXyORzbvNzH3U=
X-Received: by 2002:aed:2569:: with SMTP id w38mr8900527qtc.3.1595592078668;
 Fri, 24 Jul 2020 05:01:18 -0700 (PDT)
MIME-Version: 1.0
References: <CAA85sZvKNXCo5bB5a6kKmsOUAiw+_daAVaSYqNW6QbSBJ0TcyQ@mail.gmail.com>
 <CAA85sZua6Q8UR7TfCGO0bV=VU0gKtqj-8o_mqH38RpKrwYZGtg@mail.gmail.com>
 <20200715133136.5f63360c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAA85sZu09Z4gydJ8rAO_Ey0zqx-8Lg28=fBJ=FxFnp6cetNd3g@mail.gmail.com>
 <CAA85sZtjCW2Yg+tXPgYyoFA5BKAVZC8kVKG=6SiR64c8ur8UcQ@mail.gmail.com>
 <20200715144017.47d06941@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAA85sZvnytPzpia_ROnkmJoZC8n4vUsrwTQh2UBs6u6g2Fgqxw@mail.gmail.com>
 <CAKgT0UdwsmE=ygE2KObzM0z-0KgrPcr59JZzVk41F6-iqsSL+Q@mail.gmail.com>
 <CAA85sZturDN7uOHMDhUnntM43PHjop=TNDb4qvEA2L=jdRa1MA@mail.gmail.com>
 <CAKgT0Uf42EhnM+zPSb-oL1R8hmo0vEdssGztptbkWKoHXS7ygw@mail.gmail.com>
 <CAA85sZtHNkocj840i0ohMVekh0B4byuojU02UunK_bR+LB1WiQ@mail.gmail.com>
 <CAKgT0UdDjabvShwDv0qiume=Q2RKGkm3JhPMZ+f8v5yO37ZLxA@mail.gmail.com>
 <CAA85sZt6B+rG8pUfRoNVOH=VqHn=rT-+2kHpFDzW+eBwvODxJA@mail.gmail.com>
 <CAKgT0UfhMjZ6kZSkfpEVHBbQ+4eHQqWRbXk5Sm4nLQD6sSrj0A@mail.gmail.com> <CAA85sZs5D_ReOhsEv1SVbE5D8q77utNBZ=Uv34PVof9gHs9QWw@mail.gmail.com>
In-Reply-To: <CAA85sZs5D_ReOhsEv1SVbE5D8q77utNBZ=Uv34PVof9gHs9QWw@mail.gmail.com>
From:   Ian Kumlien <ian.kumlien@gmail.com>
Date:   Fri, 24 Jul 2020 14:01:07 +0200
Message-ID: <CAA85sZvi4x1zc_21a6zPJw0rELOY=RCV4W7Fi4fvcSXfy-6m4g@mail.gmail.com>
Subject: Re: [Intel-wired-lan] NAT performance issue 944mbit -> ~40mbit
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 3:45 PM Ian Kumlien <ian.kumlien@gmail.com> wrote:
>
> On Fri, Jul 17, 2020 at 2:09 AM Alexander Duyck
> <alexander.duyck@gmail.com> wrote:
> > On Thu, Jul 16, 2020 at 12:47 PM Ian Kumlien <ian.kumlien@gmail.com> wrote:
>
> > > Sorry, tried to respond via the phone, used the webbrowser version but
> > > still html mails... :/
>
> > > On Thu, Jul 16, 2020 at 5:18 PM Alexander Duyck
> > > <alexander.duyck@gmail.com> wrote:
> > > > On Wed, Jul 15, 2020 at 5:00 PM Ian Kumlien <ian.kumlien@gmail.com> wrote:
>
> [--8<--]
>
> > > > > Well... I'll be damned... I used to force enable ASPM... this must be
> > > > > related to the change in PCIe bus ASPM
> > > > > Perhaps disable ASPM if there is only one link?
> > > >
> > > > Is there any specific reason why you are enabling ASPM? Is this system
> > > > a laptop where you are trying to conserve power when on battery? If
> > > > not disabling it probably won't hurt things too much since the power
> > > > consumption for a 2.5GT/s link operating in a width of one shouldn't
> > > > bee too high. Otherwise you are likely going to end up paying the
> > > > price for getting the interface out of L1 when the traffic goes idle
> > > > so you are going to see flows that get bursty paying a heavy penalty
> > > > when they start dropping packets.
> > >
> > > Ah, you misunderstand, I used to do this and everything worked - now
> > > Linux enables ASPM by default on all pcie controllers,
> > > so imho this should be a quirk, if there is only one lane, don't do
> > > ASPM due to latency and timing issues...
> > >
> > > > It is also possible this could be something that changed with the
> > > > physical PCIe link. Basically L1 works by powering down the link when
> > > > idle, and then powering it back up when there is activity. The problem
> > > > is bringing it back up can sometimes be a challenge when the physical
> > > > link starts to go faulty. I know I have seen that in some cases it can
> > > > even result in the device falling off of the PCIe bus if the link
> > > > training fails.
> > >
> > > It works fine without ASPM (and the machine is pretty new)
> > >
> > > I suspect we hit some timing race with aggressive ASPM (assumed as
> > > such since it works on local links but doesn't on ~3 ms Links)
> >
> > Agreed. What is probably happening if you are using a NAT is that it
> > may be seeing some burstiness being introduced and as a result the
> > part is going to sleep and then being overrun when the traffic does
> > arrive.
>
> Weird though, seems to be very aggressive timings =)
>
> [--8<--]
>
> > > > > ethtool -S enp3s0 |grep -v ": 0"
> > > > > NIC statistics:
> > > > >      rx_packets: 16303520
> > > > >      tx_packets: 21602840
> > > > >      rx_bytes: 15711958157
> > > > >      tx_bytes: 25599009212
> > > > >      rx_broadcast: 122212
> > > > >      tx_broadcast: 530
> > > > >      rx_multicast: 333489
> > > > >      tx_multicast: 18446
> > > > >      multicast: 333489
> > > > >      rx_missed_errors: 270143
> > > > >      rx_long_length_errors: 6
> > > > >      tx_tcp_seg_good: 1342561
> > > > >      rx_long_byte_count: 15711958157
> > > > >      rx_errors: 6
> > > > >      rx_length_errors: 6
> > > > >      rx_fifo_errors: 270143
> > > > >      tx_queue_0_packets: 8963830
> > > > >      tx_queue_0_bytes: 9803196683
> > > > >      tx_queue_0_restart: 4920
> > > > >      tx_queue_1_packets: 12639010
> > > > >      tx_queue_1_bytes: 15706576814
> > > > >      tx_queue_1_restart: 12718
> > > > >      rx_queue_0_packets: 16303520
> > > > >      rx_queue_0_bytes: 15646744077
> > > > >      rx_queue_0_csum_err: 76
> > > >
> > > > Okay, so this result still has the same length and checksum errors,
> > > > were you resetting the system/statistics between runs?
> > >
> > > Ah, no.... Will reset and do more tests when I'm back home
> > >
> > > Am I blind or is this part missing from ethtools man page?
> >
> > There isn't a reset that will reset the stats via ethtool. The device
> > stats will be persistent until the driver is unloaded and reloaded or
> > the system is reset. You can reset the queue stats by changing the
> > number of queues. So for example using "ethtool -L enp3s0 1;  ethtool
> > -L enp3s0 2".

As a side note, would something like this fix it - not even compile tested


diff --git a/drivers/net/ethernet/intel/igb/igb_main.c
b/drivers/net/ethernet/intel/igb/igb_main.c
index 8bb3db2cbd41..1a7240aae85c 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -3396,6 +3396,13 @@ static int igb_probe(struct pci_dev *pdev,
const struct pci_device_id *ent)
                          "Width x2" :
                          (hw->bus.width == e1000_bus_width_pcie_x1) ?
                          "Width x1" : "unknown"), netdev->dev_addr);
+               /* quirk */
+#ifdef CONFIG_PCIEASPM
+               if (hw->bus.width == e1000_bus_width_pcie_x1) {
+                       /* single lane pcie causes problems with ASPM */
+                       pdev->pcie_link_state->aspm_enabled = 0;
+               }
+#endif
        }

        if ((hw->mac.type >= e1000_i210 ||

I don't know where the right place to put a quirk would be...
