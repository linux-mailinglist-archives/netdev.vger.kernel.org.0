Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1801DA5AF
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 01:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbgESXhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 19:37:18 -0400
Received: from mga18.intel.com ([134.134.136.126]:31177 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbgESXhS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 19:37:18 -0400
IronPort-SDR: BE+O8UpT331NylZepVOzFraLOwBoEbJBvaTaHGPFn6Xr69HAXZiZi1/ZCdWu2+LbPbwucrK39b
 /JQVbRG74tXA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2020 16:37:17 -0700
IronPort-SDR: efCpJZMQHt0EarEpHhcIdrY++jdSzf6UO8hAsrlDSoHhaJEIp/v3IWrIJ+4Hpf2pW9+ERbCb6z
 8uoY6XsoCpUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,411,1583222400"; 
   d="scan'208";a="466318416"
Received: from stputhen-mobl1.amr.corp.intel.com (HELO ellie) ([10.209.5.127])
  by fmsmga006.fm.intel.com with ESMTP; 19 May 2020 16:37:16 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Andre Guedes <andre.guedes@intel.com>,
        intel-wired-lan@lists.osuosl.org
Cc:     jeffrey.t.kirsher@intel.com, netdev@vger.kernel.org,
        vladimir.oltean@nxp.com, po.liu@nxp.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com
Subject: Re: [next-queue RFC 0/4] ethtool: Add support for frame preemption
In-Reply-To: <158992799425.36166.17850279656312622646@twxiong-mobl.amr.corp.intel.com>
References: <20200516012948.3173993-1-vinicius.gomes@intel.com> <158992799425.36166.17850279656312622646@twxiong-mobl.amr.corp.intel.com>
Date:   Tue, 19 May 2020 16:37:16 -0700
Message-ID: <87y2pnmr83.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andre Guedes <andre.guedes@intel.com> writes:

> Hi,
>
> Quoting Vinicius Costa Gomes (2020-05-15 18:29:44)
>> One example, for retrieving and setting the configuration:
>> 
>> $ ethtool $ sudo ./ethtool --show-frame-preemption enp3s0
>> Frame preemption settings for enp3s0:
>>         support: supported
>>         active: active
>
> IIUC the code in patch 2, 'active' is the actual configuration knob that
> enables or disables the FP functionality on the NIC.
>
> That sounded a bit confusing to me since the spec uses the term 'active' to
> indicate FP is currently enabled at both ends, and it is a read-only
> information (see 12.30.1.4 from IEEE 802.1Q-2018). Maybe if we called this
> 'enabled' it would be more clear.

Good point. Will rename this to "enabled".

>
>>         supported queues: 0xf
>>         supported queues: 0xe
>>         minimum fragment size: 68
>
> I'm assuming this is the configuration knob for the minimal non-final fragment
> defined in 802.3br.
>
> My understanding from the specs is that this value must be a multiple from 64
> and cannot assume arbitrary values like shown here. See 99.4.7.3 from IEEE
> 802.3 and Note 1 in S.2 from IEEE 802.1Q. In the previous discussion about FP,
> we had this as a multiplier factor, not absolute value.

I thought that exposing this as "(1 + N)*64" (with 0 <= N <= 3) that it
was more related to what's exposed via LLDP than the actual capabilities
of the hardware. And for the hardware I have actually the values
supported are: (1 + N)*64 + 4 (for N = 0, 1, 2, 3).

So I thought I was better to let the driver decide what values are
acceptable.

This is a good question for people working with other hardware.


-- 
Vinicius
