Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEC2F136199
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 21:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729117AbgAIUNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 15:13:24 -0500
Received: from mga18.intel.com ([134.134.136.126]:57830 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727945AbgAIUNY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 15:13:24 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jan 2020 12:13:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,414,1571727600"; 
   d="scan'208";a="223980505"
Received: from jekeller-mobl.amr.corp.intel.com (HELO [134.134.177.84]) ([134.134.177.84])
  by orsmga003.jf.intel.com with ESMTP; 09 Jan 2020 12:13:23 -0800
Subject: Re: [PATCH v2 0/3] devlink region trigger support
To:     netdev@vger.kernel.org
Cc:     valex@mellanox.com, jiri@resnulli.us
References: <20200109193311.1352330-1-jacob.e.keller@intel.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <3397d02d-5329-b63e-99b1-30a001929391@intel.com>
Date:   Thu, 9 Jan 2020 12:13:22 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200109193311.1352330-1-jacob.e.keller@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/9/2020 11:33 AM, Jacob Keller wrote:
> This series consists of patches to enable devlink to request a snapshot via
> a new DEVLINK_CMD_REGION_TRIGGER_SNAPSHOT.
> 
> A reviewer might notice that the devlink health API already has such support
> for handling a similar case. However, the health API does not make sense in
> cases where the data is not related to an error condition.
> 
> In this case, using the health API only for the dumping feels incorrect.
> Regions make sense when the addressable content is not captured
> automatically on error conditions, but only upon request by the devlink API.
> 
> The netdevsim driver is modified to support the new trigger_snapshot
> callback as an example of how this can be used.
> 

As mentioned by Jakub on an earlier comment, I wanted to clarify: I
implemented this in the netdevsim driver because I wanted to test that
the changes actually worked as expected.

I'm planning on making use of this in an Intel driver soon, but do not
yet have patches ready to send to the list.

Thanks,
Jake

> Jacob Keller (3):
>   devlink: add callback to trigger region snapshots
>   devlink: introduce command to trigger region snapshot
>   netdevsim: support triggering snapshot through devlink
> 
>  drivers/net/ethernet/mellanox/mlx4/crdump.c |  4 +-
>  drivers/net/netdevsim/dev.c                 | 37 ++++++++++++-----
>  include/net/devlink.h                       | 12 ++++--
>  include/uapi/linux/devlink.h                |  2 +
>  net/core/devlink.c                          | 45 +++++++++++++++++++--
>  5 files changed, 80 insertions(+), 20 deletions(-)
> 
