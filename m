Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A56811BD91
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 21:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729051AbfEMTEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 15:04:13 -0400
Received: from mail-io1-f52.google.com ([209.85.166.52]:42452 "EHLO
        mail-io1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728782AbfEMTEN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 15:04:13 -0400
Received: by mail-io1-f52.google.com with SMTP id g16so10945521iom.9;
        Mon, 13 May 2019 12:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pgG97KlWnDcvtxvcNNDePM+TJZw1dyL+Oz/TIGnZXN0=;
        b=hj74xYtQcRIjIb89jTbgmBaIlZ9CR0GhCe0XaBCJggVk922M1kGkymuPXb9je+tr8j
         DlksTj1AkG7lHoQEWqmza4hG91f4twrV13L/2kGtklQpuP07jlaqIp9vdrHB+xh/XB30
         FzWCkTHYc2yCpaNEhdyxNA7wImBPFQtvLIcJihv//WSl9uWCSWSTZKsDOBVenraau2Q4
         ofDkqWHtIOFIW6T62p1iKEOYRAL/oHQMenbodyyWakBYqIGsIk57i4cJTtz0mTnzEWhP
         KNtSyY23TokllmwZoLJeBiB9pD06zDi7PJ+rLt72saCd152JjUcSCoehttHxRbh9deiH
         6S+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pgG97KlWnDcvtxvcNNDePM+TJZw1dyL+Oz/TIGnZXN0=;
        b=S0EBi5jM0okCBmDLa47ADFXvYWXYmlWw60/+BmmjCBcumxVk5GIjBLV4EQcg3mwCAa
         a+GOiEE7IreE7yQw9lQFpeqcGfkw5M0BNjZP1afBxu5xRx1l/ZMAH74DV9eSZBv4H8iD
         25ejx5SCXDCw+/kdUdRXUf8v4e/UEy4HWsFA4EMxvy3EAxAivioF2yfhGDDJY/+PSiYn
         5EjOeq2iR7GbsyrsmbMvS2Dav5HvyURMDwV6QeJ1mHOxU0zRjgne4CIc0BNF9mUNr0C6
         J3jlXd8T5UgnkXu6kC/Fu8hsHVFl4EqythD/nEWZ/ZuMNYdVRdo3hxPDBEMB0c7AFEul
         TuDA==
X-Gm-Message-State: APjAAAWHW58+8Q4Z5FZ52Ah9/tTyuTFlezRm8BvzppZOM7Kx0HR17x97
        fsM4vy6brTCHsh6ae0d6hcMWoCF3zuAhuFjvMJSxldQf
X-Google-Smtp-Source: APXvYqypSONC498teybzV6ABcbxB/n9T6zhogDdfNEjzWpNVIiFwcDmCzmEfymbnDCmuVjZuSH+LOf6s1FBOvcvb6V4=
X-Received: by 2002:a5e:890f:: with SMTP id k15mr13441234ioj.68.1557774252211;
 Mon, 13 May 2019 12:04:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190502151140.gf5ugodqamtdd5tz@csclub.uwaterloo.ca>
 <CAKgT0Uc_OUAcPfRe6yCSwpYXCXomOXKG2Yvy9c1_1RJn-7Cb5g@mail.gmail.com>
 <20190502171636.3yquioe3gcwsxlus@csclub.uwaterloo.ca> <CAKgT0Ufk8LXMb9vVWfvgbjbQFKAuenncf95pfkA0P1t-3+Ni_g@mail.gmail.com>
 <20190502175513.ei7kjug3az6fe753@csclub.uwaterloo.ca> <20190502185250.vlsainugtn6zjd6p@csclub.uwaterloo.ca>
 <CAKgT0Uc_YVzns+26-TL+hhmErqG4_w4evRqLCaa=7nME7Zq+Vg@mail.gmail.com>
 <20190503151421.akvmu77lghxcouni@csclub.uwaterloo.ca> <CAKgT0UcV2wCr6iUYktZ+Bju_GNpXKzR=M+NLfKhUsw4bsJSiyA@mail.gmail.com>
 <20190503205935.bg45rsso5jjj3gnx@csclub.uwaterloo.ca> <20190513165547.alkkgcsdelaznw6v@csclub.uwaterloo.ca>
In-Reply-To: <20190513165547.alkkgcsdelaznw6v@csclub.uwaterloo.ca>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 13 May 2019 12:04:00 -0700
Message-ID: <CAKgT0Uf_nqZtCnHmC=-oDFz-3PuSM6=30BvJSDiAgzK062OY6w@mail.gmail.com>
Subject: Re: [Intel-wired-lan] i40e X722 RSS problem with NAT-Traversal IPsec packets
To:     Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 13, 2019 at 9:55 AM Lennart Sorensen
<lsorense@csclub.uwaterloo.ca> wrote:
>
> On Fri, May 03, 2019 at 04:59:35PM -0400, Lennart Sorensen wrote:
> > On Fri, May 03, 2019 at 10:19:47AM -0700, Alexander Duyck wrote:
> > > The TCP flow could be bypassing RSS and may be using ATR to decide
> > > where the Rx packets are processed. Now that I think about it there is
> > > a possibility that ATR could be interfering with the queue selection.
> > > You might try disabling it by running:
> > >     ethtool --set-priv-flags <iface> flow-director-atr off
> >
> > Hmm, I thought I had killed ATR (I certainly meant to), but it appears
> > I had not.  I will experiment to see if that makes a difference.
> >
> > > The problem is RSS can be bypassed for queue selection by things like
> > > ATR which I called out above. One possibility is that if the
> > > encryption you were using was leaving the skb->encapsulation flag set,
> > > and the NIC might have misidentified the packets as something it could
> > > parse and set up a bunch of rules that were rerouting incoming traffic
> > > based on outgoing traffic. Disabling the feature should switch off
> > > that behavior if that is in fact the case.
> > >
> > > You are probably fine using 40 queues. That isn't an even power of two
> > > so it would actually improve the entropy a bit since the lower bits
> > > don't have a many:1 mapping to queues.
> >
> > I will let you know Monday how my tests go with atr off.  I really
> > thought that was off already since it was supposed to be.  We always
> > try to turn that off because it does not work well.
>
> OK it took a while to try a bunch of stuff to make sure ATR really really
> was off.
>
> I still see the problem it seems.
>
> # ethtool --show-priv-flags eth2
> Private flags for eth2:
> MFP              : off
> LinkPolling      : off
> flow-director-atr: off
> veb-stats        : off
> hw-atr-eviction  : on
> legacy-rx        : off
>
> # ethtool -i eth2
> driver: i40e
> version: 2.1.7-k
> firmware-version: 4.00 0x80001577 1.1767.0
> expansion-rom-version:
> bus-info: 0000:3d:00.1
> supports-statistics: yes
> supports-test: yes
> supports-eeprom-access: yes
> supports-register-dump: yes
> supports-priv-flags: yes
>
>
> Here are two packets that for some reason both go to queue 0 which
> seems odd.  As far as I can tell all of the packets for UDP port 4500
> traffic from any IP is going to queue 0.
>
> UDP from 10.49.1.50:4500 to 10.49.1.1:4500 encapsulating ESP:
>
> a4bf 014e 0c88 001f 45ff f410 0800 45e0
> 0060 166e 4000 4011 0b1b 0af9 0132 0af9
> 0101 1194 1194 004c 0000 0000 0201 0000
> 0000 4eaf 2f76 58cd aae0 4d92 8cb7 0835
> 1141 7a23 9f06 f323 b816 1a2b c88d 322c
> 5f16 d4a6 ba72 7c89 2258 9d20 085e d6ed
> c7a4 5cc1 3ef2 0753 783d b691 e9d6
>
> UDP from 10.49.1.51:4500 to 10.49.1.1:4500 encapsulating ESP:
>
> a4bf 014e 0c88 20f3 99ae c688 0800 45e0
> 0060 1671 4000 4011 0b17 0af9 0133 0af9
> 0101 1194 1194 004c 0000 0000 0200 0000
> 0000 4ec5 253f 27f1 7fdd 4d82 0697 bef2
> 45bd 281f 8ecf ac4f 06ed 79ba 3cbb 5eaf
> 494b 146e a013 8b93 1c38 8aef da3f a73d
> 6f13 5f80 e946 82e2 7da7 21e8 9d03
>
>
> # ethtool -x eth2
> RX flow hash indirection table for eth2 with 12 RX ring(s):
>     0:      0     1     2     3     4     5     6     7
>     8:      8     9    10    11     0     1     2     3
>    16:      4     5     6     7     8     9    10    11
> ...
>   488:      8     9    10    11     0     1     2     3
>   496:      4     5     6     7     8     9    10    11
>   504:      0     1     2     3     4     5     6     7
> RSS hash key:
> 60:56:66:39:8e:70:46:02:5d:33:5e:9c:5f:f6:fa:9d:ac:50:63:7c:ca:01:23:22:07:a3:8a:23:98:fd:38:5b:74:96:7e:72:0c:aa:83:fc:10:aa:6d:35:bb:8c:4e:eb:46:03:07:6a
>
> Changing the key to:
>
> aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55
>
> makes no change in the queue the packets are going to.
>
> --
> Len Sorensen

So I recreated the first packet you listed via text2pcap, replayed it
on my test system via tcpreplay, updated my configuration to 12
queues, and used the 2 hash keys you listed. I ended up seeing the
traffic bounce between queues 4 and 8 with an X710 I had to test with
when I was changing the key value.

Unfortunately I don't have an X722 to test with. I'm suspecting that
there may be some difference in the RSS setup, specifically it seems
like values in the PFQF_HENA register were changed for the X722 part
that may be causing the issues we are seeing.

I will see if I can get someone from the networking division to take a
look at this since I don't have access to the part in question nor a
datasheet for it so I am not sure if I can help much more.

Thanks.

- Alex
