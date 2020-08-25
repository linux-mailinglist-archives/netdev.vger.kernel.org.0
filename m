Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE372515E2
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 12:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729720AbgHYKAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 06:00:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:60522 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729635AbgHYKAg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 06:00:36 -0400
IronPort-SDR: ek2rWHEkh12T5GQNQACU8+COUZKfqtGFZ1wbQe200joVDXcoI5d6FJCDTcaO6xoOLkd7tLP0YK
 1E6+YrhNY8XQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9723"; a="174116881"
X-IronPort-AV: E=Sophos;i="5.76,352,1592895600"; 
   d="scan'208";a="174116881"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2020 03:00:35 -0700
IronPort-SDR: rmCS+IO+rzIF5+XaxL7hi7XQ6WJHcd2MLKNILaBSE/S82lcaxaU5zRxsqqW5s67Q20UjmpsP6P
 6E6o0sXJ4B1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,352,1592895600"; 
   d="scan'208";a="279941503"
Received: from zzombora-mobl1.ti.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.53.19])
  by fmsmga007.fm.intel.com with ESMTP; 25 Aug 2020 03:00:33 -0700
Subject: Re: [PATCH net 2/3] ixgbe: avoid premature Rx buffer reuse
To:     "Li,Rongqing" <lirongqing@baidu.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Cc:     "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>,
        "magnus.karlsson@gmail.com" <magnus.karlsson@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "maciej.fijalkowski@intel.com" <maciej.fijalkowski@intel.com>,
        "piotr.raczynski@intel.com" <piotr.raczynski@intel.com>,
        "maciej.machnikowski@intel.com" <maciej.machnikowski@intel.com>
References: <20200825091629.12949-1-bjorn.topel@gmail.com>
 <20200825091629.12949-3-bjorn.topel@gmail.com>
 <6356c0ddbdbd4f8fb4927f3ee96c4c33@baidu.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <43f838aa-b12b-63d3-400b-ef92081b355d@intel.com>
Date:   Tue, 25 Aug 2020 12:00:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <6356c0ddbdbd4f8fb4927f3ee96c4c33@baidu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-08-25 11:55, Li,Rongqing wrote:
> 
> 
>> -----Original Message-----
>> From: Björn Töpel [mailto:bjorn.topel@gmail.com]
>> Sent: Tuesday, August 25, 2020 5:16 PM
>> To: jeffrey.t.kirsher@intel.com; intel-wired-lan@lists.osuosl.org
>> Cc: Björn Töpel <bjorn.topel@intel.com>; magnus.karlsson@intel.com;
>> magnus.karlsson@gmail.com; netdev@vger.kernel.org;
>> maciej.fijalkowski@intel.com; piotr.raczynski@intel.com;
>> maciej.machnikowski@intel.com; Li,Rongqing <lirongqing@baidu.com>
>> Subject: [PATCH net 2/3] ixgbe: avoid premature Rx buffer reuse
>>
>> From: Björn Töpel <bjorn.topel@intel.com>
>>
>> The page recycle code, incorrectly, relied on that a page fragment could not be
>> freed inside xdp_do_redirect(). This assumption leads to that page fragments
>> that are used by the stack/XDP redirect can be reused and overwritten.
>>
>> To avoid this, store the page count prior invoking xdp_do_redirect().
>>
>> Fixes: 6453073987ba ("ixgbe: add initial support for xdp redirect")
>> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
> 
> Reported-and-analyzed-by: Li RongQing <lirongqing@baidu.com>
>

Thanks Li! I should have added that. Intel-folks, please make sure Li's 
tags for ixgbe/ice are added.


Björn


> Thanks
> 
> -Li
> 
