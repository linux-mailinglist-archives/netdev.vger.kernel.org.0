Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDF11FBE71
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 20:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730054AbgFPSsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 14:48:11 -0400
Received: from foss.arm.com ([217.140.110.172]:44168 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729609AbgFPSsK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jun 2020 14:48:10 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2196E1FB;
        Tue, 16 Jun 2020 11:48:10 -0700 (PDT)
Received: from e107158-lin.cambridge.arm.com (e107158-lin.cambridge.arm.com [10.1.195.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3C4743F73C;
        Tue, 16 Jun 2020 11:48:09 -0700 (PDT)
Date:   Tue, 16 Jun 2020 19:48:06 +0100
From:   Qais Yousef <qais.yousef@arm.com>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] net: qrtr: Migrate nameservice to kernel from
 userspace
Message-ID: <20200616184805.k7eowfhdevasqite@e107158-lin.cambridge.arm.com>
References: <20200213091427.13435-1-manivannan.sadhasivam@linaro.org>
 <20200213091427.13435-2-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200213091427.13435-2-manivannan.sadhasivam@linaro.org>
User-Agent: NeoMutt/20171215
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Manivannan, David

On 02/13/20 14:44, Manivannan Sadhasivam wrote:

[...]

> +	trace_printk("advertising new server [%d:%x]@[%d:%d]\n",
> +		     srv->service, srv->instance, srv->node, srv->port);

I can't tell exactly from the discussion whether this is the version that got
merged into 5.7 or not, but it does match the commit message.

This patch introduces several trace_printk() which AFAIK is intended for
debugging only and shouldn't make it into mainline kernels.

It causes this big message to be printed to the log too

[    0.000000] **********************************************************
[    0.000000] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
[    0.000000] **                                                      **
[    0.000000] ** trace_printk() being used. Allocating extra memory.  **
[    0.000000] **                                                      **
[    0.000000] ** This means that this is a DEBUG kernel and it is     **
[    0.000000] ** unsafe for production use.                           **
[    0.000000] **                                                      **
[    0.000000] ** If you see this message and you are not debugging    **
[    0.000000] ** the kernel, report this immediately to your vendor!  **
[    0.000000] **                                                      **
[    0.000000] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
[    0.000000] **********************************************************

Shouldn't this be replaced with one of pr_*() variants instead?

Thanks

--
Qais Yousef
