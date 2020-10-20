Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9209D293239
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 02:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389222AbgJTALz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 20:11:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:59848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726792AbgJTALz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 20:11:55 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E991D223FD;
        Tue, 20 Oct 2020 00:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603152715;
        bh=ZFrirEygTdd/Sz05M2uEowNYPhMVNPcknm4rjGTEoVM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=susuo3o11PCT6Wa1giUNX2tEomp323r+no3uS/F/g4l0mg8/gdEUL6YV+eneyGBuK
         q32+5t8DJwAzo9+wIqEXeh8xzolVhAJNOoRq/FH4plycGyBzM0KN/GVQcW9VgCej26
         tKMbS20eucpQ9qMrkYYAvbd8Z9nPRzpQjtza1jS8=
Date:   Mon, 19 Oct 2020 17:11:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lijun Pan <ljp@linux.ibm.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] ibmvnic: save changed mac address to
 adapter->mac_addr
Message-ID: <20201019171152.6592e0c7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201016045715.26768-1-ljp@linux.ibm.com>
References: <20201016045715.26768-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Oct 2020 23:57:15 -0500 Lijun Pan wrote:
> After mac address change request completes successfully, the new mac
> address need to be saved to adapter->mac_addr as well as
> netdev->dev_addr. Otherwise, adapter->mac_addr still holds old
> data.

Do you observe this in practice? Can you show us which path in
particular you see this happen on?

AFAICS ibmvnic_set_mac() copies the new MAC addr into adapter->mac_addr
before making a request.

If anything is wrong here is that it does so regardless if MAC addr 
is valid.

> Fixes: 62740e97881c("net/ibmvnic: Update MAC address settings after adapter reset")
                     ^
                      missing space here 

> Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
