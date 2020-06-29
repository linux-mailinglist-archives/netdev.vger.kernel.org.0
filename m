Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B18320D3F7
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 21:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730603AbgF2TDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:03:36 -0400
Received: from mga12.intel.com ([192.55.52.136]:9632 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730590AbgF2TDb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 15:03:31 -0400
IronPort-SDR: LwE34Gs+AV+xokjb3JndDrLgxWFdQYFDnQfGmEkhIUuDm+zdREct9rAW8Pew3uqAO3uU/20UGf
 dW/vm24w2Ufw==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="125593307"
X-IronPort-AV: E=Sophos;i="5.75,294,1589266800"; 
   d="scan'208";a="125593307"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 06:39:04 -0700
IronPort-SDR: GOBMqQlGojLcDdG+5mlKFZRG9gJ8QV2ZkbkGgaSD2pc2JsK2FTpzVwlf29Xfp9W1iEJ4QONxVB
 TPoq3jVsldWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,294,1589266800"; 
   d="scan'208";a="313048269"
Received: from unknown (HELO btopel-mobl.ger.intel.com) ([10.252.54.90])
  by fmsmga002.fm.intel.com with ESMTP; 29 Jun 2020 06:39:02 -0700
Subject: Re: add an API to check if a streamming mapping needs sync calls
To:     Christoph Hellwig <hch@lst.de>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        iommu@lists.linux-foundation.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200629130359.2690853-1-hch@lst.de>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <b97104e1-433c-8e35-59c6-b4dad047464c@intel.com>
Date:   Mon, 29 Jun 2020 15:39:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200629130359.2690853-1-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-06-29 15:03, Christoph Hellwig wrote:
> Hi all,
> 
> this series lifts the somewhat hacky checks in the XSK code if a DMA
> streaming mapping needs dma_sync_single_for_{device,cpu} calls to the
> DMA API.
>

Thanks a lot for working on, and fixing this, Christoph!

I took the series for a spin, and there are (obviously) no performance
regressions.

Would the patches go through the net/bpf trees or somewhere else?

For the series:
Tested-by: Björn Töpel <bjorn.topel@intel.com>
Acked-by: Björn Töpel <bjorn.topel@intel.com>


Björn

> 
> Diffstat:
>   Documentation/core-api/dma-api.rst |    8 +++++
>   include/linux/dma-direct.h         |    1
>   include/linux/dma-mapping.h        |    5 +++
>   include/net/xsk_buff_pool.h        |    6 ++--
>   kernel/dma/direct.c                |    6 ++++
>   kernel/dma/mapping.c               |   10 ++++++
>   net/xdp/xsk_buff_pool.c            |   54 ++-----------------------------------
>   7 files changed, 37 insertions(+), 53 deletions(-)
> 
