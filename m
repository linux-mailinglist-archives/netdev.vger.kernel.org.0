Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00FEC179AC6
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 22:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728482AbgCDVUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 16:20:01 -0500
Received: from mga12.intel.com ([192.55.52.136]:9464 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726440AbgCDVUB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 16:20:01 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Mar 2020 13:20:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,515,1574150400"; 
   d="scan'208";a="244066631"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [134.134.177.106]) ([134.134.177.106])
  by orsmga006.jf.intel.com with ESMTP; 04 Mar 2020 13:20:00 -0800
Subject: Re: [PATCH net-next v2 08/12] ice: let core reject the unsupported
 coalescing parameters
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     mkubecek@suse.cz, thomas.lendacky@amd.com, benve@cisco.com,
        _govind@gmx.com, pkaustub@cisco.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com, snelson@pensando.io,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, alexander.h.duyck@linux.intel.com,
        michael.chan@broadcom.com, saeedm@mellanox.com, leon@kernel.org,
        netdev@vger.kernel.org
References: <20200304043354.716290-1-kuba@kernel.org>
 <20200304043354.716290-9-kuba@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <b2fccc27-36da-1637-b217-7bdd81207a99@intel.com>
Date:   Wed, 4 Mar 2020 13:20:00 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200304043354.716290-9-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/3/2020 8:33 PM, Jakub Kicinski wrote:
> Set ethtool_ops->coalesce_types to let the core reject
> unsupported coalescing parameters.
> 
> This driver correctly rejects all unsupported parameters.
> As a side effect of these changes the info message about
> the bad parameter will no longer be printed. We also
> always reject the tx_coalesce_usecs_high param, even
> if the target queue pair does not have a TX queue.
> 

Sure. The extra messaging isn't really helpful, and we could make it
part of the extended ack message in ethtool core later for callers who
use the ethlink interface.

Always rejecting tx_coalesce_usecs_high makes sense to me, we don't
support it at all.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
