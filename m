Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D91FCA159
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 17:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729763AbfJCPuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 11:50:06 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45214 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727024AbfJCPuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 11:50:05 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:b5c5:ae11:3e54:6a07])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 403881433FC59;
        Thu,  3 Oct 2019 08:50:05 -0700 (PDT)
Date:   Thu, 03 Oct 2019 11:50:04 -0400 (EDT)
Message-Id: <20191003.115004.60330572167098261.davem@davemloft.net>
To:     johunt@akamai.com
Cc:     netdev@vger.kernel.org, edumazet@google.com, willemb@google.com,
        alexander.h.duyck@intel.com
Subject: Re: [PATCH net v2 2/2] udp: only do GSO if # of segs > 1
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1570037363-12485-2-git-send-email-johunt@akamai.com>
References: <1570037363-12485-1-git-send-email-johunt@akamai.com>
        <1570037363-12485-2-git-send-email-johunt@akamai.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 03 Oct 2019 08:50:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Josh Hunt <johunt@akamai.com>
Date: Wed,  2 Oct 2019 13:29:23 -0400

> Prior to this change an application sending <= 1MSS worth of data and
> enabling UDP GSO would fail if the system had SW GSO enabled, but the
> same send would succeed if HW GSO offload is enabled. In addition to this
> inconsistency the error in the SW GSO case does not get back to the
> application if sending out of a real device so the user is unaware of this
> failure.
> 
> With this change we only perform GSO if the # of segments is > 1 even
> if the application has enabled segmentation. I've also updated the
> relevant udpgso selftests.
> 
> Fixes: bec1f6f69736 ("udp: generate gso with UDP_SEGMENT")
> Signed-off-by: Josh Hunt <johunt@akamai.com>

Applied and queued up for -stable.
