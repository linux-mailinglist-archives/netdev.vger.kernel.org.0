Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB3DC1C1FB6
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 23:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbgEAVgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 17:36:42 -0400
Received: from mga06.intel.com ([134.134.136.31]:7319 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbgEAVgl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 17:36:41 -0400
IronPort-SDR: qILp6ynDiaVrRCnTaXWH2i0HGaMBPii3RrGEd3YiBvRlxkT2pC3jhipjGYWt5JtdFW4ZQVjc+p
 RjgErnoEDbkQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2020 14:36:41 -0700
IronPort-SDR: kUNzzpYaU/GFttYyDOTScysRTtOJazSAfRnulPhY3cfZ26eK/nrh3rRvqu/ih1bxzAUonj/Oln
 WrrztPbgul2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,341,1583222400"; 
   d="scan'208";a="248645776"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.209.101.237]) ([10.209.101.237])
  by fmsmga007.fm.intel.com with ESMTP; 01 May 2020 14:36:40 -0700
Subject: Re: [PATCH net-next v4 2/3] devlink: let kernel allocate region
 snapshot id
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        jiri@resnulli.us
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
References: <20200501164042.1430604-1-kuba@kernel.org>
 <20200501164042.1430604-3-kuba@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <29924c8d-933d-17ec-a6ee-7feb54c68b89@intel.com>
Date:   Fri, 1 May 2020 14:36:40 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200501164042.1430604-3-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/1/2020 9:40 AM, Jakub Kicinski wrote:
> Currently users have to choose a free snapshot id before
> calling DEVLINK_CMD_REGION_NEW. This is potentially racy
> and inconvenient.
> 
> Make the DEVLINK_ATTR_REGION_SNAPSHOT_ID optional and try
> to allocate id automatically. Send a message back to the
> caller with the snapshot info.
> 
> Example use:
> $ devlink region new netdevsim/netdevsim1/dummy
> netdevsim/netdevsim1/dummy: snapshot 1
> 
> $ id=$(devlink -j region new netdevsim/netdevsim1/dummy | \
>        jq '.[][][][]')
> $ devlink region dump netdevsim/netdevsim1/dummy snapshot $id
> [...]
> $ devlink region del netdevsim/netdevsim1/dummy snapshot $id
> 
> v4:
>  - inline the notification code
> v3:
>  - send the notification only once snapshot creation completed.
> v2:
>  - don't wrap the line containing extack;
>  - add a few sentences to the docs.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
