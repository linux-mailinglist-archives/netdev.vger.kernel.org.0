Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2E59466B0B
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 21:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348980AbhLBUsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 15:48:10 -0500
Received: from mga18.intel.com ([134.134.136.126]:38920 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348949AbhLBUsI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Dec 2021 15:48:08 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10185"; a="223698848"
X-IronPort-AV: E=Sophos;i="5.87,282,1631602800"; 
   d="scan'208";a="223698848"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2021 12:44:45 -0800
X-IronPort-AV: E=Sophos;i="5.87,282,1631602800"; 
   d="scan'208";a="541371774"
Received: from rmarti10-mobl2.amr.corp.intel.com (HELO [10.209.114.198]) ([10.209.114.198])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2021 12:44:44 -0800
Message-ID: <46938937-0c73-6249-45f8-b0f65bfaf971@linux.intel.com>
Date:   Thu, 2 Dec 2021 12:44:31 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v2 09/14] net: wwan: t7xx: Add WWAN network interface
Content-Language: en-US
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        chandrashekar.devegowda@intel.com,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        mika.westerberg@linux.intel.com, moises.veleta@intel.com,
        pierre-louis.bossart@intel.com, muralidharan.sethuraman@intel.com,
        Soumya.Prakash.Mishra@intel.com, sreehari.kancharla@intel.com,
        suresh.nagaraj@intel.com
References: <20211101035635.26999-1-ricardo.martinez@linux.intel.com>
 <20211101035635.26999-10-ricardo.martinez@linux.intel.com>
 <CAHNKnsTAj8OHzoyK3SHhA_yXJrqc38bYmY6pYZf9fwUemcK7iQ@mail.gmail.com>
 <5755abe9-7b3c-0361-4eea-e0c125811eae@linux.intel.com>
 <CAHNKnsTARNNeiCBtDxmiMx2gUkKDb-V3e+xtfgsc-imeWv0CLA@mail.gmail.com>
From:   "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
In-Reply-To: <CAHNKnsTARNNeiCBtDxmiMx2gUkKDb-V3e+xtfgsc-imeWv0CLA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Sergey,

On 12/1/2021 1:09 PM, Sergey Ryazanov wrote:
> On Wed, Dec 1, 2021 at 9:06 AM Martinez, Ricardo
> <ricardo.martinez@linux.intel.com> wrote:
>> On 11/6/2021 11:08 AM, Sergey Ryazanov wrote:
>>> On Mon, Nov 1, 2021 at 6:57 AM Ricardo Martinez wrote:
>>>> +#define IPV4_VERSION           0x40
>>>> +#define IPV6_VERSION           0x60
>>> Just curious why the _VERSION suffix? Why not, for example, PKT_TYPE_ prefix?
>> Nothing special about _VERSION, but it does look a bit weird, will use
>> PKT_TYPE_  as suggested
> I checked the driver code again and found that these constants are
> really used to distinguish between IPv4 and IPv6 packets by checking
> the first byte of the data packet (IP header version field).
>
> Now I am wondering, does the modem firmware report a packet type in
> one of the BAT or PIT headers? If the modem is already reporting a
> packet type, then it is better to use the provided information instead
> of touching the packet data. Otherwise, if the modem does not
> explicitly report a packet type, and you have to check the version
> field of the IP header, then it seems Ok to keep the names of these
> constants as they are (with the _VERSION suffix).

Actually, there is a bit in the PIT header for the packet type, I'll 
make the driver

use it instead of looking at the data packet.

