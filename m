Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B07220EC9
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 20:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729045AbfEPShI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 14:37:08 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:33179 "EHLO
        caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727097AbfEPShI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 14:37:08 -0400
Received: by caffeine.csclub.uwaterloo.ca (Postfix, from userid 20367)
        id D08D646380B; Thu, 16 May 2019 14:37:05 -0400 (EDT)
Date:   Thu, 16 May 2019 14:37:05 -0400
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
Subject: Re: [Intel-wired-lan] i40e X722 RSS problem with NAT-Traversal IPsec
 packets
Message-ID: <20190516183705.e4zflbli7oujlbek@csclub.uwaterloo.ca>
References: <20190502185250.vlsainugtn6zjd6p@csclub.uwaterloo.ca>
 <CAKgT0Uc_YVzns+26-TL+hhmErqG4_w4evRqLCaa=7nME7Zq+Vg@mail.gmail.com>
 <20190503151421.akvmu77lghxcouni@csclub.uwaterloo.ca>
 <CAKgT0UcV2wCr6iUYktZ+Bju_GNpXKzR=M+NLfKhUsw4bsJSiyA@mail.gmail.com>
 <20190503205935.bg45rsso5jjj3gnx@csclub.uwaterloo.ca>
 <20190513165547.alkkgcsdelaznw6v@csclub.uwaterloo.ca>
 <CAKgT0Uf_nqZtCnHmC=-oDFz-3PuSM6=30BvJSDiAgzK062OY6w@mail.gmail.com>
 <20190514163443.glfjva3ofqcy7lbg@csclub.uwaterloo.ca>
 <CAKgT0UdPDyCBsShQVwwE5C8fBKkMcfS6_S5m3T7JP-So9fzVgA@mail.gmail.com>
 <20190516183407.qswotwyjwtjqfdqm@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190516183407.qswotwyjwtjqfdqm@csclub.uwaterloo.ca>
User-Agent: NeoMutt/20170113 (1.7.2)
From:   lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 16, 2019 at 02:34:08PM -0400, Lennart Sorensen wrote:
> Here is what I see:
> 
> i40e: Intel(R) Ethernet Connection XL710 Network Driver - version 2.1.7-k
> i40e: Copyright (c) 2013 - 2014 Intel Corporation.
> i40e 0000:3d:00.0: fw 3.10.52896 api 1.6 nvm 4.00 0x80001577 1.1767.0
> i40e 0000:3d:00.0: The driver for the device detected a newer version of the NVM image than expected. Please install the most recent version of the network driver.
> i40e 0000:3d:00.0: MAC address: a4:bf:01:4e:0c:87
> i40e 0000:3d:00.0: flow_type: 63 input_mask:0x0000000000004000
> i40e 0000:3d:00.0: flow_type: 46 input_mask:0x0007fff800000000
> i40e 0000:3d:00.0: flow_type: 45 input_mask:0x0007fff800000000
> i40e 0000:3d:00.0: flow_type: 44 input_mask:0x0007ffff80000000
> i40e 0000:3d:00.0: flow_type: 43 input_mask:0x0007fffe00000000
> i40e 0000:3d:00.0: flow_type: 42 input_mask:0x0007fffe00000000
> i40e 0000:3d:00.0: flow_type: 41 input_mask:0x0007fffe00000000
> i40e 0000:3d:00.0: flow_type: 40 input_mask:0x0007fffe00000000
> i40e 0000:3d:00.0: flow_type: 39 input_mask:0x0007fffe00000000
> i40e 0000:3d:00.0: flow_type: 36 input_mask:0x0006060000000000
> i40e 0000:3d:00.0: flow_type: 35 input_mask:0x0006060000000000
> i40e 0000:3d:00.0: flow_type: 34 input_mask:0x0006060780000000
> i40e 0000:3d:00.0: flow_type: 33 input_mask:0x0006060600000000
> i40e 0000:3d:00.0: flow_type: 32 input_mask:0x0006060600000000
> i40e 0000:3d:00.0: flow_type: 31 input_mask:0x0006060600000000
> i40e 0000:3d:00.0: flow_type: 30 input_mask:0x0006060600000000
> i40e 0000:3d:00.0: flow_type: 29 input_mask:0x0006060600000000
> i40e 0000:3d:00.0: Features: PF-id[0] VSIs: 34 QP: 12 TXQ: 13 RSS VxLAN Geneve VEPA
> i40e 0000:3d:00.1: fw 3.10.52896 api 1.6 nvm 4.00 0x80001577 1.1767.0
> i40e 0000:3d:00.1: The driver for the device detected a newer version of the NVM image than expected. Please install the most recent version of the network driver.
> i40e 0000:3d:00.1: MAC address: a4:bf:01:4e:0c:88
> i40e 0000:3d:00.1: flow_type: 63 input_mask:0x0000000000004000
> i40e 0000:3d:00.1: flow_type: 46 input_mask:0x0007fff800000000
> i40e 0000:3d:00.1: flow_type: 45 input_mask:0x0007fff800000000
> i40e 0000:3d:00.1: flow_type: 44 input_mask:0x0007ffff80000000
> i40e 0000:3d:00.1: flow_type: 43 input_mask:0x0007fffe00000000
> i40e 0000:3d:00.1: flow_type: 42 input_mask:0x0007fffe00000000
> i40e 0000:3d:00.1: flow_type: 41 input_mask:0x0007fffe00000000
> i40e 0000:3d:00.1: flow_type: 40 input_mask:0x0007fffe00000000
> i40e 0000:3d:00.1: flow_type: 39 input_mask:0x0007fffe00000000
> i40e 0000:3d:00.1: flow_type: 36 input_mask:0x0006060000000000
> i40e 0000:3d:00.1: flow_type: 35 input_mask:0x0006060000000000
> i40e 0000:3d:00.1: flow_type: 34 input_mask:0x0006060780000000
> i40e 0000:3d:00.1: flow_type: 33 input_mask:0x0006060600000000
> i40e 0000:3d:00.1: flow_type: 32 input_mask:0x0006060600000000
> i40e 0000:3d:00.1: flow_type: 31 input_mask:0x0006060600000000
> i40e 0000:3d:00.1: flow_type: 30 input_mask:0x0006060600000000
> i40e 0000:3d:00.1: flow_type: 29 input_mask:0x0006060600000000
> i40e 0000:3d:00.1: Features: PF-id[1] VSIs: 34 QP: 12 TXQ: 13 RSS VxLAN Geneve VEPA
> i40e 0000:3d:00.1 eth2: NIC Link is Up, 1000 Mbps Full Duplex, Flow Control: None
> i40e_ioctl: power down: eth1
> i40e_ioctl: power down: eth2

Those last two lines is something I added, so ignore those.

-- 
Len Sorensen
