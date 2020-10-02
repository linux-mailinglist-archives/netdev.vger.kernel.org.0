Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39D55281C3F
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 21:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388459AbgJBTqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 15:46:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:7799 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387768AbgJBTqI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 15:46:08 -0400
IronPort-SDR: V+3nBrR/3obB6h4JCpe4mqzTu9iGGD8f0mtjSAELoXM0S3PsgbS5xkCLpqW0P8EJ/5sd8+gvGi
 2TiUrFsYi1JA==
X-IronPort-AV: E=McAfee;i="6000,8403,9762"; a="160385404"
X-IronPort-AV: E=Sophos;i="5.77,328,1596524400"; 
   d="scan'208";a="160385404"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2020 12:46:06 -0700
IronPort-SDR: AbMRmWB5KjFD0LhfyDUyVkjeXMVhzrfDHZiXS8OQYkMHX+xZ2Cy/bO4gq3okhbhWvCtH4X9fQG
 Y0BBfG5axUkQ==
X-IronPort-AV: E=Sophos;i="5.77,328,1596524400"; 
   d="scan'208";a="458727838"
Received: from ssing11-mobl.amr.corp.intel.com (HELO ellie) ([10.209.68.166])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2020 12:46:05 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        =?utf-8?B?5Y+25bCP6b6Z?= <muryo.ye@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Why ping latency is smaller with shorter send interval?
In-Reply-To: <0d8f732d-03e1-75f0-09fd-520911088c0d@gmail.com>
References: <CAP0D=1X946M=yy=hMBvXuT11paPqxMi_xens-R4m7vyCnkUQzw@mail.gmail.com>
 <0d8f732d-03e1-75f0-09fd-520911088c0d@gmail.com>
Date:   Fri, 02 Oct 2020 12:46:04 -0700
Message-ID: <87zh544dj7.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Eric Dumazet <eric.dumazet@gmail.com> writes:

>
> Many factors in play here.
>
> 1) if you keep cpus busy enough, they tend to keep in their caches
> the data needed to serve your requests. In your case, time taken to
> process an ICMP packet can be very different depending on how hot
> cpu caches are.
>
> 2) Idle cpus can be put in a power conserving state.
>   It takes time to exit from these states, as you noticed.
>   These delays can typically be around 50 usec, or more.

Still on the power management theme, in my experience, in addition to
the CPU power states, the PCIe and NIC power management settings also
effect latency on the order of 10-100s usecs when the system is allowed
to go idle, some things that have helped:

 - setting CONFIG_PCIEASPM to performance;
 - disabling EEE (energy efficient ethernet) in your NIC;

>
> Search for cpu C-states , and powertop program.
>


Cheers,
-- 
Vinicius
