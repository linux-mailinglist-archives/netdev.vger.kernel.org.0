Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 066B830199C
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 06:12:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbhAXFKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 00:10:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:48794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726475AbhAXFKK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Jan 2021 00:10:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C389A224F9;
        Sun, 24 Jan 2021 05:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611464968;
        bh=MIfIAijMBVBS/dkQ7/+YXVwsxvtliRHfWu9t7r3ppyg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hidJ0o8kAIWSgmyTXA/KklVyw9YEJ9Kk4f3/wWSyqpBNH8n+ZXxgfdUQr4d8HRy+G
         +t/aWzzg3mKe/WySs6JMTIkg1KrpsPNYp5yEOqbB03QhvhIiPpeepjRhGJMztYxnZm
         uMKN/azPQRuWLhvYc0fde1wXTYPjYfKqg4rSEpM0S4CV2cOvkEp25BVvIHmiEaRmPI
         hbHYrASRLK7krUFKbISFmkLdh8JAV2zt3xSSHG36Tn1twP1bt17nKDOI2/70wkBsVP
         IM50EW1s/JvlybJZ/LK9H/Uq0aNtSlwsQ9vSxT7eVWKgES5E88xidYRHN8c3T2ipCr
         08B6wWW28so4A==
Date:   Sat, 23 Jan 2021 21:09:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lijun Pan <ljp@linux.ibm.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net 2/3] ibmvnic: remove unnecessary rmb() inside
 ibmvnic_poll
Message-ID: <20210123210928.30d79969@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210121061710.53217-3-ljp@linux.ibm.com>
References: <20210121061710.53217-1-ljp@linux.ibm.com>
        <20210121061710.53217-3-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Jan 2021 00:17:09 -0600 Lijun Pan wrote:
> rmb() was introduced to load rx_scrq->msgs after calling
> pending_scrq(). Now since pending_scrq() itself already
> has dma_rmb() at the end of the function, rmb() is
> duplicated and can be removed.
> 
> Fixes: ec20f36bb41a ("ibmvnic: Correctly re-enable interrupts in NAPI polling routine")
> Signed-off-by: Lijun Pan <ljp@linux.ibm.com>

rmb() is a stronger barrier than dma_rmb()

also again, I don't see how this fixes any bugs
