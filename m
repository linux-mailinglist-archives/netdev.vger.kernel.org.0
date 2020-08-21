Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B245624DEF2
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 19:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgHURy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 13:54:57 -0400
Received: from mga04.intel.com ([192.55.52.120]:30317 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725873AbgHURyx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Aug 2020 13:54:53 -0400
IronPort-SDR: 8gdcvXBrW5+syIDwbeAIsLnVQ+Ejd+AGgEqlomeqcLBusvv2LrzbLTlqYNk1R/vAIkiJkUBRwH
 8awdV8flmnwQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9720"; a="153012900"
X-IronPort-AV: E=Sophos;i="5.76,338,1592895600"; 
   d="scan'208";a="153012900"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2020 10:54:53 -0700
IronPort-SDR: JSp9H2urWgKZ2YFICDT9QLf8jbPuKyP2LWQ1QeJzvMJr42Gm4PbQ91c1g+lx7OsnUzX/CF/fiq
 BU81TfhgKcDA==
X-IronPort-AV: E=Sophos;i="5.76,338,1592895600"; 
   d="scan'208";a="293900425"
Received: from jbrandeb-mobl3.amr.corp.intel.com (HELO localhost) ([10.212.38.54])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2020 10:54:52 -0700
Date:   Fri, 21 Aug 2020 10:54:51 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>
Subject: Re: [PATCH net-next 00/11] qed: introduce devlink health support
Message-ID: <20200821105451.000052b9@intel.com>
In-Reply-To: <20200727184310.462-1-irusskikh@marvell.com>
References: <20200727184310.462-1-irusskikh@marvell.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Igor Russkikh wrote:

> This is a followup implementation after series
> 
> https://patchwork.ozlabs.org/project/netdev/cover/20200514095727.1361-1-irusskikh@marvell.com/
> 
> This is an implementation of devlink health infrastructure.
> 
> With this we are now able to report HW errors to devlink, and it'll take
> its own actions depending on user configuration to capture and store the dump
> at the bad moment, and to request the driver to recover the device.
> 
> So far we do not differentiate global device failures or specific PCI function
> failures. This means that some errors specific to one physical function will
> affect an entire device. This is not yet fully designed and verified, will
> followup in future.
> 
> Solution was verified with artificial HW errors generated, existing tools
> for dump analysis could be used.
> 
> Igor Russkikh (11):
>   qed: move out devlink logic into a new file
>   qed/qede: make devlink survive recovery
>   qed: swap param init and publish
>   qed: fix kconfig help entries
>   qed: implement devlink info request
>   qed: health reporter init deinit seq
>   qed: use devlink logic to report errors
>   qed*: make use of devlink recovery infrastructure
>   qed: implement devlink dump
>   qed: align adjacent indent
>   qede: make driver reliable on unload after failures
> 
>  drivers/net/ethernet/qlogic/Kconfig           |   5 +-
>  drivers/net/ethernet/qlogic/qed/Makefile      |   1 +
>  drivers/net/ethernet/qlogic/qed/qed.h         |   3 +-
>  drivers/net/ethernet/qlogic/qed/qed_dev.c     |  10 +
>  drivers/net/ethernet/qlogic/qed/qed_devlink.c | 255 ++++++++++++++++++
>  drivers/net/ethernet/qlogic/qed/qed_devlink.h |  20 ++
>  drivers/net/ethernet/qlogic/qed/qed_main.c    | 116 +-------
>  drivers/net/ethernet/qlogic/qede/qede.h       |   2 +
>  drivers/net/ethernet/qlogic/qede/qede_main.c  |  35 ++-
>  include/linux/qed/qed_if.h                    |  23 +-
>  10 files changed, 341 insertions(+), 129 deletions(-)
>  create mode 100644 drivers/net/ethernet/qlogic/qed/qed_devlink.c
>  create mode 100644 drivers/net/ethernet/qlogic/qed/qed_devlink.h

I just realized I was reviewing this old set (somehow my mailer put this
one after the v6 in the message order) #reviewfail

I'll move over to v6 now, sorry for the thrash.
