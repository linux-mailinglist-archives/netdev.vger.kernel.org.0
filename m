Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB11E1398B1
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 19:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728967AbgAMSRF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 13:17:05 -0500
Received: from mga14.intel.com ([192.55.52.115]:12309 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728714AbgAMSQw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 13:16:52 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jan 2020 10:16:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,429,1571727600"; 
   d="scan'208";a="273096072"
Received: from jekeller-mobl.amr.corp.intel.com (HELO [134.134.177.84]) ([134.134.177.84])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Jan 2020 10:16:51 -0800
Subject: Re: [PATCH v2 0/3] devlink region trigger support
To:     Jakub Kicinski <kubakici@wp.pl>,
        Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Alex Vesker <valex@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jiri@resnulli.us" <jiri@resnulli.us>
References: <20200109193311.1352330-1-jacob.e.keller@intel.com>
 <4d8fe881-8d36-06dd-667a-276a717a0d89@huawei.com>
 <1d00deb9-16fc-b2a5-f8f7-5bb8316dbac2@intel.com>
 <fe6c0d5e-5705-1118-1a71-80bd0e26a97e@huawei.com>
 <20200112124521.467fa06a@cakuba>
 <DB6PR0501MB224859D8DC219E81D4CFB17CC33A0@DB6PR0501MB2248.eurprd05.prod.outlook.com>
 <421f78c2-7713-b931-779e-dfe675fe5f53@huawei.com>
 <20200113033431.1d32dcbe@cakuba>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <28bc8945-6c55-2ad3-963a-156efe616038@intel.com>
Date:   Mon, 13 Jan 2020 10:16:51 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200113033431.1d32dcbe@cakuba>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/13/2020 3:34 AM, Jakub Kicinski wrote:
> On Mon, 13 Jan 2020 09:39:50 +0800, Yunsheng Lin wrote:
>> I am not sure I understand "live region" here, what is the usecase of live
>> region?
> 
> Reading registers of a live system without copying them to a snapshot
> first. Some chips have so many registers it's impractical to group them
> beyond "registers of IP block X", if that. IMHO that fits nicely with
> regions, health is grouped by event, so we'd likely want to dump for
> example one or two registers from the MAC there, while the entire set
> of MAC registers can be exposed as a region.
> 

Right. I'm actually wondering about this as well. Region snapshots are
captured in whole and stored and then returned through the devlink
region commands.

This could be problematic if you wanted to expose a larger chunk of
registers or addressable sections of flash contents, as the size of the
contents goes beyond a single page.

If we instead focus regions onto the live-read aspect, the API can
simply be a request to read a segment of the region. Then, the driver
could perform the read of that chunk and report it back.
