Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9604F248DD5
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 20:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbgHRSTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 14:19:39 -0400
Received: from mga07.intel.com ([134.134.136.100]:31400 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726435AbgHRSTg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 14:19:36 -0400
IronPort-SDR: OrVsVqwHwa2j9xNn5WfFsrkZ0tq7ZzBWCQjzunD86gq1bLjZC6xP4HuPySGtWCzlQB8YFNNNn/
 7/+usFcKTgRw==
X-IronPort-AV: E=McAfee;i="6000,8403,9717"; a="219283475"
X-IronPort-AV: E=Sophos;i="5.76,328,1592895600"; 
   d="scan'208";a="219283475"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 11:19:27 -0700
IronPort-SDR: APnWYWYVz59lmAcSlTdHQ8681VCYi07EVr2evcJG9SbYCNUOKNMFjB44fEa6sIVRqtYBdMJJ5L
 TrNByUh911FA==
X-IronPort-AV: E=Sophos;i="5.76,328,1592895600"; 
   d="scan'208";a="441316287"
Received: from jbrandeb-mobl3.amr.corp.intel.com (HELO localhost) ([10.212.158.55])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 11:19:27 -0700
Date:   Tue, 18 Aug 2020 11:19:26 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Li RongQing <lirongqing@baidu.com>
Cc:     <netdev@vger.kernel.org>, <intel-wired-lan@lists.osuosl.org>
Subject: Re: [PATCH][v3] i40e: optimise prefetch page refcount
Message-ID: <20200818111926.000028d9@intel.com>
In-Reply-To: <1597734477-27859-1-git-send-email-lirongqing@baidu.com>
References: <1597734477-27859-1-git-send-email-lirongqing@baidu.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Aug 2020 15:07:57 +0800
Li RongQing <lirongqing@baidu.com> wrote:

> refcount of rx_buffer page will be added here originally, so prefetchw
> is needed, but after commit 1793668c3b8c ("i40e/i40evf: Update code to
>  better handle incrementing page count"), and refcount is not added
> everytime, so change prefetchw as prefetch,
> 
> now it mainly services page_address(), but which accesses struct page
> only when WANT_PAGE_VIRTUAL or HASHED_PAGE_VIRTUAL is defined
> otherwise it returns address based on offset, so we prefetch it
> conditionally
> 
> Jakub suggested to define prefetch_page_address in a common header
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Li RongQing <lirongqing@baidu.com>

This change looks fine to me, hopefully the more heavyweight
prefetch instruction doesn't impact performance. Were you able to test
any performance?

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
