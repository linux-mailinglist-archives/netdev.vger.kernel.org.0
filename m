Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 881C52DDBF0
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 00:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732161AbgLQXiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 18:38:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726789AbgLQXiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 18:38:09 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2BFBC061794;
        Thu, 17 Dec 2020 15:37:28 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id a6so145518qtw.6;
        Thu, 17 Dec 2020 15:37:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kD1MCPsoar6G9vdvcEBH5KP4RAgDclspZS+ZkNc4Ibw=;
        b=vF1XpAg3XI4izQ9RMo3HIqPyUz+/ETJm89Xj86uC113NDLGEhaO0joAeBhgp1fZ3Du
         rNVPb8S2hZecAOpE2YsGcafHsDWtyXjI01SgtBra1oQbjY6nDfBzzFMPhsidwZ9o1ZQm
         kCVZSO1smvTI9+tYfEC9A3JGkmA5gHniIbefKqv0Qo6LHVB2znzwx/Aob970XlUClcce
         /HLH2bnFpNFIx8Z4ovAIU30r/uGnZ266YC+rScWuKg5Qm2pquEW7PU0fvvLuTcJ/AFmC
         hAco2pfmL97oiHf1D9kgKxKxF2PMv5d2F3sWwNgv7ERM2/r+TUGaUYfhN0ocCUUquNWk
         TRWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kD1MCPsoar6G9vdvcEBH5KP4RAgDclspZS+ZkNc4Ibw=;
        b=pTONdIMn81O6o89g3/12xl//LNOD9NvFYDOkDmci6hqqzRCV2oREWHidDX+x+bSe69
         d7Q0KbU83HmYjTufKFoN1soylD5j8zwJV0zZSaJCCK+E8XNUByLgmpE3sVMfVtC8XQ2L
         Zyjx/7qn8agq68oAPQqpK3I/MebU4X18S56z+qVIg5w5wSHejtsjLGTndG6Kjxlf6H3x
         UfCoCI2Hz4jEbjhq31ENYaFVJKp7hA6Xq5n14tiaCaY8gzD7Ib1uWEKVUCecJJgbwVHc
         CUVHdmomO6G9KAQ9NuVbNdfCvO41EY4zs6+jhuqX+WzfXnM4bQXK+LYuTylMUx/C3WLb
         nmPQ==
X-Gm-Message-State: AOAM532bl4kBEaG45DninfPPXprJ7Xgy5xtZ/PnjjVGra7Fcv8HFA/Qb
        OuCg2uL98HaUbiCUXeWnaGI//qyhzrmSbsAtIyw=
X-Google-Smtp-Source: ABdhPJxTAw/uYHDkTUNNqfptLLfb2aLcIaqUznoO4lkmP/y4u+xIxscOz0xMEGy3En40Zo/6ZZjRIsbVCe9ALFWfGks=
X-Received: by 2002:ac8:4e47:: with SMTP id e7mr1374898qtw.262.1608248247634;
 Thu, 17 Dec 2020 15:37:27 -0800 (PST)
MIME-Version: 1.0
References: <CAA85sZsiuE9rN7uVCuhgiki-rffo4mYbh6BKvuGaJAK5CsPgKw@mail.gmail.com>
 <20201216232103.GA368161@bjorn-Precision-5520>
In-Reply-To: <20201216232103.GA368161@bjorn-Precision-5520>
From:   Ian Kumlien <ian.kumlien@gmail.com>
Date:   Fri, 18 Dec 2020 00:37:16 +0100
Message-ID: <CAA85sZtez59wrAr8AVdbaZWvkPhVeurcznQ0kbL3UVx2FqLJ7w@mail.gmail.com>
Subject: Re: [PATCH 1/3] PCI/ASPM: Use the path max in L1 ASPM latency check
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        "Saheed O. Bolarinwa" <refactormyself@gmail.com>,
        Puranjay Mohan <puranjay12@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 17, 2020 at 12:21 AM Bjorn Helgaas <helgaas@kernel.org> wrote:
>
> On Wed, Dec 16, 2020 at 12:20:53PM +0100, Ian Kumlien wrote:
> > On Wed, Dec 16, 2020 at 1:08 AM Bjorn Helgaas <helgaas@kernel.org> wrote:
> > > On Tue, Dec 15, 2020 at 02:09:12PM +0100, Ian Kumlien wrote:
> > > > On Tue, Dec 15, 2020 at 1:40 AM Bjorn Helgaas <helgaas@kernel.org> wrote:
> > > > > On Mon, Dec 14, 2020 at 11:56:31PM +0100, Ian Kumlien wrote:
> > > > > > On Mon, Dec 14, 2020 at 8:19 PM Bjorn Helgaas <helgaas@kernel.org> wrote:
> > > > >
> > > > > > > If you're interested, you could probably unload the Realtek drivers,
> > > > > > > remove the devices, and set the PCI_EXP_LNKCTL_LD (Link Disable) bit
> > > > > > > in 02:04.0, e.g.,
> > > > > > >
> > > > > > >   # RT=/sys/devices/pci0000:00/0000:00:01.2/0000:01:00.0/0000:02:04.0
> > > > > > >   # echo 1 > $RT/0000:04:00.0/remove
> > > > > > >   # echo 1 > $RT/0000:04:00.1/remove
> > > > > > >   # echo 1 > $RT/0000:04:00.2/remove
> > > > > > >   # echo 1 > $RT/0000:04:00.4/remove
> > > > > > >   # echo 1 > $RT/0000:04:00.7/remove
> > > > > > >   # setpci -s02:04.0 CAP_EXP+0x10.w=0x0010
> > > > > > >
> > > > > > > That should take 04:00.x out of the picture.
> > > > > >
> > > > > > Didn't actually change the behaviour, I'm suspecting an errata for AMD pcie...
> > > > > >
> > > > > > So did this, with unpatched kernel:
> > > > > > [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
> > > > > > [  5]   0.00-1.00   sec  4.56 MBytes  38.2 Mbits/sec    0   67.9 KBytes
> > > > > > [  5]   1.00-2.00   sec  4.47 MBytes  37.5 Mbits/sec    0   96.2 KBytes
> > > > > > [  5]   2.00-3.00   sec  4.85 MBytes  40.7 Mbits/sec    0   50.9 KBytes
> > > > > > [  5]   3.00-4.00   sec  4.23 MBytes  35.4 Mbits/sec    0   70.7 KBytes
> > > > > > [  5]   4.00-5.00   sec  4.23 MBytes  35.4 Mbits/sec    0   48.1 KBytes
> > > > > > [  5]   5.00-6.00   sec  4.23 MBytes  35.4 Mbits/sec    0   45.2 KBytes
> > > > > > [  5]   6.00-7.00   sec  4.23 MBytes  35.4 Mbits/sec    0   36.8 KBytes
> > > > > > [  5]   7.00-8.00   sec  3.98 MBytes  33.4 Mbits/sec    0   36.8 KBytes
> > > > > > [  5]   8.00-9.00   sec  4.23 MBytes  35.4 Mbits/sec    0   36.8 KBytes
> > > > > > [  5]   9.00-10.00  sec  4.23 MBytes  35.4 Mbits/sec    0   48.1 KBytes
> > > > > > - - - - - - - - - - - - - - - - - - - - - - - - -
> > > > > > [ ID] Interval           Transfer     Bitrate         Retr
> > > > > > [  5]   0.00-10.00  sec  43.2 MBytes  36.2 Mbits/sec    0             sender
> > > > > > [  5]   0.00-10.00  sec  42.7 MBytes  35.8 Mbits/sec                  receiver
> > > > > >
> > > > > > and:
> > > > > > echo 0 > /sys/devices/pci0000:00/0000:00:01.2/0000:01:00.0/link/l1_aspm
> > > > >
> > > > > BTW, thanks a lot for testing out the "l1_aspm" sysfs file.  I'm very
> > > > > pleased that it seems to be working as intended.
> > > >
> > > > It was nice to find it for easy disabling :)
> > > >
> > > > > > and:
> > > > > > [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
> > > > > > [  5]   0.00-1.00   sec   113 MBytes   951 Mbits/sec  153    772 KBytes
> > > > > > [  5]   1.00-2.00   sec   109 MBytes   912 Mbits/sec  276    550 KBytes
> > > > > > [  5]   2.00-3.00   sec   111 MBytes   933 Mbits/sec  123    625 KBytes
> > > > > > [  5]   3.00-4.00   sec   111 MBytes   933 Mbits/sec   31    687 KBytes
> > > > > > [  5]   4.00-5.00   sec   110 MBytes   923 Mbits/sec    0    679 KBytes
> > > > > > [  5]   5.00-6.00   sec   110 MBytes   923 Mbits/sec  136    577 KBytes
> > > > > > [  5]   6.00-7.00   sec   110 MBytes   923 Mbits/sec  214    645 KBytes
> > > > > > [  5]   7.00-8.00   sec   110 MBytes   923 Mbits/sec   32    628 KBytes
> > > > > > [  5]   8.00-9.00   sec   110 MBytes   923 Mbits/sec   81    537 KBytes
> > > > > > [  5]   9.00-10.00  sec   110 MBytes   923 Mbits/sec   10    577 KBytes
> > > > > > - - - - - - - - - - - - - - - - - - - - - - - - -
> > > > > > [ ID] Interval           Transfer     Bitrate         Retr
> > > > > > [  5]   0.00-10.00  sec  1.08 GBytes   927 Mbits/sec  1056             sender
> > > > > > [  5]   0.00-10.00  sec  1.07 GBytes   923 Mbits/sec                  receiver
> > > > > >
> > > > > > But this only confirms that the fix i experience is a side effect.
> > > > > >
> > > > > > The original code is still wrong :)
> > > > >
> > > > > What exactly is this machine?  Brand, model, config?  Maybe you could
> > > > > add this and a dmesg log to the buzilla?  It seems like other people
> > > > > should be seeing the same problem, so I'm hoping to grub around on the
> > > > > web to see if there are similar reports involving these devices.
> > > >
> > > > ASUS Pro WS X570-ACE with AMD Ryzen 9 3900X
> > >
> > > Possible similar issues:
> > >
> > >   https://forums.unraid.net/topic/94274-hardware-upgrade-woes/
> > >   https://forums.servethehome.com/index.php?threads/upgraded-my-home-server-from-intel-to-amd-virtual-disk-stuck-in-degraded-unhealty-state.25535/ (Windows)
> >
> > Could be, I suspect that we need a workaround (is there a quirk for
> > "reporting wrong latency"?) and the patches.
>
> I don't think there's currently a quirk mechanism that would work for
> correcting latencies, but there should be, and we could add one if we
> can figure out for sure what's wrong.
>
> I found this:
>
>   https://www.reddit.com/r/VFIO/comments/hgk3cz/x570_pcieclassic_pci_bridge_woes/
>
> which looks like it should be the same hardware (if you can collect a
> dmesg log or "lspci -nnvv" output we could tell for sure) and is
> interesting because it includes some lspci output that shows different
> L1 exit latencies than what you see.

I'll send both of them separately to you, no reason to push that to
everyone i assume.. =)

> > > > > https://bugzilla.kernel.org/show_bug.cgi?id=209725
> > > > >
> > > > > Here's one that is superficially similar:
> > > > > https://linux-hardware.org/index.php?probe=e5f24075e5&log=lspci_all
> > > > > in that it has a RP -- switch -- I211 path.  Interestingly, the switch
> > > > > here advertises <64us L1 exit latency instead of the <32us latency
> > > > > your switch advertises.  Of course, I can't tell if it's exactly the
> > > > > same switch.
> > > >
> > > > Same chipset it seems
> > > >
> > > > I'm running bios version:
> > > >         Version: 2206
> > > >         Release Date: 08/13/2020
> > > >
> > > > ANd latest is:
> > > > Version 3003
> > > > 2020/12/07
> > > >
> > > > Will test upgrading that as well, but it could be that they report the
> > > > incorrect latency of the switch - I don't know how many things AGESA
> > > > changes but... It's been updated twice since my upgrade.
> > >
> > > I wouldn't be surprised if the advertised exit latencies are writable
> > > by the BIOS because it probably depends on electrical characteristics
> > > outside the switch.  If so, it's possible ASUS just screwed it up.
> >
> > Not surprisingly, nothing changed.
> > (There was a lot of "stability improvements")
>
> I wouldn't be totally surprised if ASUS didn't test that I211 NIC
> under Linux, but I'm sure it must work well under Windows.  If you
> happen to have Windows, a free trial version of AIDA64 should be able
> to give us the equivalent of "lspci -vv".

I don't have windows, haven't had windows at home since '98 ;)

I'll check with some friends that dualboot om systems that might be
similar - will see what i can get


> Bjorn
