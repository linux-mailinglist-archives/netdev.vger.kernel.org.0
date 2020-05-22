Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89E131DF0E5
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 23:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731025AbgEVVFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 17:05:22 -0400
Received: from mga03.intel.com ([134.134.136.65]:46714 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730963AbgEVVFW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 17:05:22 -0400
IronPort-SDR: xa6Bo1/UjcXo8vl5m09+Pl1CVwMCeg9UxvRct6zGwrfZyImwsJaMowrHE7cI8EvMiE7tRZEcqT
 wX7anlN1FTkg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2020 14:05:21 -0700
IronPort-SDR: p94qfZKb7NGYzw+ifnqFW4s8L1Lfiqj81JWSepbNUHygjbzPZa9MUitpFpZXWkl6lpc2xRpAnS
 WCST8ZIcInBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,423,1583222400"; 
   d="scan'208";a="301215554"
Received: from hthaniga-mobl.amr.corp.intel.com (HELO [10.255.231.169]) ([10.255.231.169])
  by orsmga008.jf.intel.com with ESMTP; 22 May 2020 14:05:21 -0700
Subject: Re: [net-next v4 10/12] ASoC: SOF: Introduce descriptors for SOF
 client
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Fred Oh <fred.oh@linux.intel.com>
References: <20200520125437.GH31189@ziepe.ca>
 <08fa562783e8a47f857d7f96859ab3617c47e81c.camel@linux.intel.com>
 <20200521233437.GF17583@ziepe.ca>
 <7abfbda8-2b4b-5301-6a86-1696d4898525@linux.intel.com>
 <20200522145542.GI17583@ziepe.ca>
 <6e129db7-2a76-bc67-0e56-2abb4d9761a3@linux.intel.com>
 <20200522171055.GK17583@ziepe.ca>
 <01efd24a-edb6-3d0c-d7fa-a602ecd381d1@linux.intel.com>
 <20200522184035.GL17583@ziepe.ca>
 <b680a7f2-5dc1-00d6-dcff-b7c71d09b535@linux.intel.com>
 <20200522194418.GM17583@ziepe.ca>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Message-ID: <aace4c95-fe72-1fd8-f768-3a0e5a160292@linux.intel.com>
Date:   Fri, 22 May 2020 16:05:20 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200522194418.GM17583@ziepe.ca>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> Maybe if you can present some diagram or something, because I really
> can't understand why asoc is trying to do with virtual bus here.

instead of having a 1:1 mapping between PCI device and a monolithic 
card, we want to split the sound card in multiple orthogonal parts such as:

PCI device
   - local devices (mic/speakers)
   - hdmi devices
   - presence detection/sensing
   - probe/tuning interfaces
   - debug/tests

Initially we wanted to use platform devices but Greg suggested this API 
is abused. We don't have a platform/firmware based enumeration, nor a 
physical bus for each of these subparts, so the virtual bus was suggested.

Does this help?
