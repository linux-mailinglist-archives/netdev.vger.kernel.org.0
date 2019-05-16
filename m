Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E99321110
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 01:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbfEPXcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 19:32:41 -0400
Received: from mail-it1-f176.google.com ([209.85.166.176]:50269 "EHLO
        mail-it1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726857AbfEPXck (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 19:32:40 -0400
Received: by mail-it1-f176.google.com with SMTP id i10so9086052ite.0;
        Thu, 16 May 2019 16:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EELhI/1e5V7Lj/m7+7oMKAGzKmAB6peQ8kc65u1SZho=;
        b=I+GUx0x1iqM3SWzh79YpHAqXOd8eK4Y/94PYf5n/KVbRWuPKdsI6KCcA9FKK0nNTiZ
         jalrCxeq7GM0htHcdDElsId5zkiOwVv2km4OkyOm7araqHoUXUjyH11jJKRrqFRjNH62
         jfURmRwNxtATEzdXW/7wOHkNiq6GlfGwvzH4BebQAFtclP3HxUXFW8QXFTi+AGWsDcD9
         3qCMiUBQ91xBxiHZU+LpKwHg3HJ6TUCrVxhV9yF2SvHjkm3Nj2h2TlAqSbkZs2lZG063
         fC2S/YREoKkVXz0lZzsr0qvTcj9Xq/mPLW6arzvYrio5ht4LBDVK+5JbSCmGCzf4YaSW
         rmsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EELhI/1e5V7Lj/m7+7oMKAGzKmAB6peQ8kc65u1SZho=;
        b=T7DnpkUe0VnSpE6X8a9b6Abm8mD47z7zDBzGiTtNmYuc3brNsGr1Py9UQ4vIbIEHps
         5Xp+mmzc5cls/AVsoCFlOfXPZkVFsSHTaQMiIntVyo/xzQjsGIbc1eGrevaFQIOcTl2y
         E2a+QWgRDHkiihXp/zkLhWnb8uNsqGVjIfdLX0l27WlCw4p6xPGZks1LbujUjmfM12M9
         kQADCAYqVZue1gVtrOGLFA1x+qigQt4qJ4XuNF5ST7gydsBSpOuxPs4gv2w6f3ODi11+
         MOxu+vIudOBVOJopb45Qhq7DH3RANukvXXNZM87w3SN5s68t24HF7Io3lZCRszArA22b
         ARAw==
X-Gm-Message-State: APjAAAVYa/mJz4XuzgNJyAbXP5vaGgT6c2YseNDkvgagGChGt6N6KyZo
        XBdNP2VH/bMSb0sOS07zXtGcBop9Jki7eo+OU1u/DAS4uHYoRg==
X-Google-Smtp-Source: APXvYqwG2UjxVhphwUAgvvwQPHGBy5z6HV26Jg2b6dtNXBPHQODn2jj7toenETQH2vJlci2kX4c7LljoPaDjps61mNE=
X-Received: by 2002:a24:d145:: with SMTP id w66mr258367itg.71.1558049559495;
 Thu, 16 May 2019 16:32:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190502185250.vlsainugtn6zjd6p@csclub.uwaterloo.ca>
 <CAKgT0Uc_YVzns+26-TL+hhmErqG4_w4evRqLCaa=7nME7Zq+Vg@mail.gmail.com>
 <20190503151421.akvmu77lghxcouni@csclub.uwaterloo.ca> <CAKgT0UcV2wCr6iUYktZ+Bju_GNpXKzR=M+NLfKhUsw4bsJSiyA@mail.gmail.com>
 <20190503205935.bg45rsso5jjj3gnx@csclub.uwaterloo.ca> <20190513165547.alkkgcsdelaznw6v@csclub.uwaterloo.ca>
 <CAKgT0Uf_nqZtCnHmC=-oDFz-3PuSM6=30BvJSDiAgzK062OY6w@mail.gmail.com>
 <20190514163443.glfjva3ofqcy7lbg@csclub.uwaterloo.ca> <CAKgT0UdPDyCBsShQVwwE5C8fBKkMcfS6_S5m3T7JP-So9fzVgA@mail.gmail.com>
 <20190516183407.qswotwyjwtjqfdqm@csclub.uwaterloo.ca> <20190516183705.e4zflbli7oujlbek@csclub.uwaterloo.ca>
In-Reply-To: <20190516183705.e4zflbli7oujlbek@csclub.uwaterloo.ca>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 16 May 2019 16:32:28 -0700
Message-ID: <CAKgT0UfSa-dM2+7xntK9tB7Zw5N8nDd3U1n4OSK0gbWbkNSKJQ@mail.gmail.com>
Subject: Re: [Intel-wired-lan] i40e X722 RSS problem with NAT-Traversal IPsec packets
To:     Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 16, 2019 at 11:37 AM Lennart Sorensen
<lsorense@csclub.uwaterloo.ca> wrote:
>
> On Thu, May 16, 2019 at 02:34:08PM -0400, Lennart Sorensen wrote:
> > Here is what I see:
> >
> > i40e: Intel(R) Ethernet Connection XL710 Network Driver - version 2.1.7-k
> > i40e: Copyright (c) 2013 - 2014 Intel Corporation.
> > i40e 0000:3d:00.0: fw 3.10.52896 api 1.6 nvm 4.00 0x80001577 1.1767.0
> > i40e 0000:3d:00.0: The driver for the device detected a newer version of the NVM image than expected. Please install the most recent version of the network driver.
> > i40e 0000:3d:00.0: MAC address: a4:bf:01:4e:0c:87
> > i40e 0000:3d:00.0: flow_type: 63 input_mask:0x0000000000004000
> > i40e 0000:3d:00.0: flow_type: 46 input_mask:0x0007fff800000000
> > i40e 0000:3d:00.0: flow_type: 45 input_mask:0x0007fff800000000
> > i40e 0000:3d:00.0: flow_type: 44 input_mask:0x0007ffff80000000
> > i40e 0000:3d:00.0: flow_type: 43 input_mask:0x0007fffe00000000
> > i40e 0000:3d:00.0: flow_type: 42 input_mask:0x0007fffe00000000
> > i40e 0000:3d:00.0: flow_type: 41 input_mask:0x0007fffe00000000
> > i40e 0000:3d:00.0: flow_type: 40 input_mask:0x0007fffe00000000
> > i40e 0000:3d:00.0: flow_type: 39 input_mask:0x0007fffe00000000
> > i40e 0000:3d:00.0: flow_type: 36 input_mask:0x0006060000000000
> > i40e 0000:3d:00.0: flow_type: 35 input_mask:0x0006060000000000
> > i40e 0000:3d:00.0: flow_type: 34 input_mask:0x0006060780000000
> > i40e 0000:3d:00.0: flow_type: 33 input_mask:0x0006060600000000
> > i40e 0000:3d:00.0: flow_type: 32 input_mask:0x0006060600000000
> > i40e 0000:3d:00.0: flow_type: 31 input_mask:0x0006060600000000
> > i40e 0000:3d:00.0: flow_type: 30 input_mask:0x0006060600000000
> > i40e 0000:3d:00.0: flow_type: 29 input_mask:0x0006060600000000
> > i40e 0000:3d:00.0: Features: PF-id[0] VSIs: 34 QP: 12 TXQ: 13 RSS VxLAN Geneve VEPA
> > i40e 0000:3d:00.1: fw 3.10.52896 api 1.6 nvm 4.00 0x80001577 1.1767.0
> > i40e 0000:3d:00.1: The driver for the device detected a newer version of the NVM image than expected. Please install the most recent version of the network driver.
> > i40e 0000:3d:00.1: MAC address: a4:bf:01:4e:0c:88
> > i40e 0000:3d:00.1: flow_type: 63 input_mask:0x0000000000004000
> > i40e 0000:3d:00.1: flow_type: 46 input_mask:0x0007fff800000000
> > i40e 0000:3d:00.1: flow_type: 45 input_mask:0x0007fff800000000
> > i40e 0000:3d:00.1: flow_type: 44 input_mask:0x0007ffff80000000
> > i40e 0000:3d:00.1: flow_type: 43 input_mask:0x0007fffe00000000
> > i40e 0000:3d:00.1: flow_type: 42 input_mask:0x0007fffe00000000
> > i40e 0000:3d:00.1: flow_type: 41 input_mask:0x0007fffe00000000
> > i40e 0000:3d:00.1: flow_type: 40 input_mask:0x0007fffe00000000
> > i40e 0000:3d:00.1: flow_type: 39 input_mask:0x0007fffe00000000
> > i40e 0000:3d:00.1: flow_type: 36 input_mask:0x0006060000000000
> > i40e 0000:3d:00.1: flow_type: 35 input_mask:0x0006060000000000
> > i40e 0000:3d:00.1: flow_type: 34 input_mask:0x0006060780000000
> > i40e 0000:3d:00.1: flow_type: 33 input_mask:0x0006060600000000
> > i40e 0000:3d:00.1: flow_type: 32 input_mask:0x0006060600000000
> > i40e 0000:3d:00.1: flow_type: 31 input_mask:0x0006060600000000
> > i40e 0000:3d:00.1: flow_type: 30 input_mask:0x0006060600000000
> > i40e 0000:3d:00.1: flow_type: 29 input_mask:0x0006060600000000
> > i40e 0000:3d:00.1: Features: PF-id[1] VSIs: 34 QP: 12 TXQ: 13 RSS VxLAN Geneve VEPA
> > i40e 0000:3d:00.1 eth2: NIC Link is Up, 1000 Mbps Full Duplex, Flow Control: None
> > i40e_ioctl: power down: eth1
> > i40e_ioctl: power down: eth2
>
> Those last two lines is something I added, so ignore those.

No problem.

So just looking at the data provided I am going to guess that IPv6 w/
UDP likely works without any issues and it is just going to be IPv4
that is the problem. When you compare the UDP setup from mine versus
yours it looks like for some reason somebody swapped around the input
bits for the L3 src and destination fields. I'm basing that on the
input set masks in the i40e_txrx.h header:
/* INPUT SET MASK for RSS, flow director, and flexible payload */
#define I40E_L3_SRC_SHIFT               47
#define I40E_L3_SRC_MASK                (0x3ULL << I40E_L3_SRC_SHIFT)
#define I40E_L3_V6_SRC_SHIFT            43
#define I40E_L3_V6_SRC_MASK             (0xFFULL << I40E_L3_V6_SRC_SHIFT)
#define I40E_L3_DST_SHIFT               35
#define I40E_L3_DST_MASK                (0x3ULL << I40E_L3_DST_SHIFT)
#define I40E_L3_V6_DST_SHIFT            35
#define I40E_L3_V6_DST_MASK             (0xFFULL << I40E_L3_V6_DST_SHIFT)
#define I40E_L4_SRC_SHIFT               34
#define I40E_L4_SRC_MASK                (0x1ULL << I40E_L4_SRC_SHIFT)
#define I40E_L4_DST_SHIFT               33
#define I40E_L4_DST_MASK                (0x1ULL << I40E_L4_DST_SHIFT)
#define I40E_VERIFY_TAG_SHIFT           31
#define I40E_VERIFY_TAG_MASK            (0x3ULL << I40E_VERIFY_TAG_SHIFT)

The easiest way to verify would be to rewrite the registers for
flow_type 29, 30, and 31 to match the value that I had shown earlier
from my dump:
[  294.687087] i40e 0000:81:00.1: flow_type: 31 input_mask:0x0001801e00000000

I will take a look at putting together a patch that can be tested to
verify if this is actually the issue tomorrow.

Thanks.

- Alex
