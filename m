Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C417E1D87CB
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 21:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbgERTFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 15:05:08 -0400
Received: from mga03.intel.com ([134.134.136.65]:12203 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726249AbgERTFF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 15:05:05 -0400
IronPort-SDR: rnkoKu9WqUS21oue+MrIaEPJhn3CFtmaqAeeFRpSuLfqSBoIPct8rOSsuSQ81l7LPSgbSVcvIE
 YnhZOeTT9EbA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2020 12:05:05 -0700
IronPort-SDR: CKN7mrYhZdBl5EPysAv1eSPnvqpEUHmG2tRwwcNDEXqUnA6luRwh3AceAMODl0bsmfhMqWfOVl
 tBDotq4nNZwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,407,1583222400"; 
   d="scan'208";a="465863900"
Received: from melassa-mobl1.amr.corp.intel.com (HELO ellie) ([10.212.228.130])
  by fmsmga006.fm.intel.com with ESMTP; 18 May 2020 12:05:04 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     David Miller <davem@davemloft.net>, olteanv@gmail.com
Cc:     intel-wired-lan@lists.osuosl.org, jeffrey.t.kirsher@intel.com,
        netdev@vger.kernel.org, vladimir.oltean@nxp.com, po.liu@nxp.com,
        m-karicheri2@ti.com, Jose.Abreu@synopsys.com
Subject: Re: [next-queue RFC 0/4] ethtool: Add support for frame preemption
In-Reply-To: <20200516.151932.575795129235955389.davem@davemloft.net>
References: <20200516012948.3173993-1-vinicius.gomes@intel.com> <20200516.133739.285740119627243211.davem@davemloft.net> <CA+h21hoNW_++QHRob+NbWC2k7y7sFec3kotSjTL6s8eZGGT+2Q@mail.gmail.com> <20200516.151932.575795129235955389.davem@davemloft.net>
Date:   Mon, 18 May 2020 12:05:04 -0700
Message-ID: <87wo59oyhr.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

David Miller <davem@davemloft.net> writes:

> From: Vladimir Oltean <olteanv@gmail.com>
> Date: Sun, 17 May 2020 00:03:39 +0300
>
>> As to why this doesn't go to tc but to ethtool: why would it go to tc?
>
> Maybe you can't %100 duplicate the on-the-wire special format and
> whatever, but the queueing behavior ABSOLUTELY you can emulate in
> software.

Just saying what Vladimir said in different words: the queueing behavior
is already implemented in software, by mqprio or taprio, for example.

That is to say, if we add frame preemption support to those qdiscs all
they will do is pass the information to the driver, and that's it. They
won't be able to use that information at all.

The mental model I have for this feature is that is more similar to the
segmentation offloads, energy efficient ethernet or auto-negotiation
than it is to a traffic shaper like CBS.

>
> And then you have the proper hooks added for HW offload which can
> do the on-the-wire stuff.
>
> That's how we do these things, not with bolted on ethtool stuff.


Cheers,
-- 
Vinicius
