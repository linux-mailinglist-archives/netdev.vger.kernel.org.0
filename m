Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FEFD2F3D5B
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:44:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393343AbhALVg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 16:36:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:60346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406961AbhALUBG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 15:01:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93E982311C;
        Tue, 12 Jan 2021 20:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610481625;
        bh=oSXWqM1D2eRYg4ueUg5WNM0hB199/wDNu3IGldAIXDk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=NXtkBzhQRinCyiioArYcl1TAwWAzrOzavYC2L06G8o+LXFY7DqNN6dujwEAF9sXFY
         FNS5EzDt7hUC0t8pZEKgvpMPpb4GV+mJcdnsr34DQUo00rWP1ywYWNKrzNIJxL5DlH
         TrWr7yTxD/ACBSuI0UHebw1iE1cE06T+yMVCGiEbldZM8XVmdf6Ofqt3e6b+UhxzYe
         fUT63LcTqHIN2wpb+Lq+6wC+7MJ8eIIEANjtPBpLXI3+Z1fNfunVq+9f/vasC3YBDv
         W/U/IwcmwLaKdHMYpMyv97yxJcvupr8KrPlJMGvc0lIS/ohT9T9MZmK++PemDVt7Ir
         S9wW0fCiBkaUA==
Message-ID: <94dd5feed72c391b6204a11658c1bc8f0a8f8cd6.camel@kernel.org>
Subject: Re: [PATCH net-next v2 0/7] ibmvnic: Use more consistent locking
From:   Saeed Mahameed <saeed@kernel.org>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>, netdev@vger.kernel.org
Cc:     Dany Madden <drt@linux.ibm.com>, Lijun Pan <ljp@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
Date:   Tue, 12 Jan 2021 12:00:24 -0800
In-Reply-To: <20210112181441.206545-1-sukadev@linux.ibm.com>
References: <20210112181441.206545-1-sukadev@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-01-12 at 10:14 -0800, Sukadev Bhattiprolu wrote:
> Use more consistent locking when reading/writing the adapter->state
> field. This patch set fixes a race condition during ibmvnic_open()
> where the adapter could be left in the PROBED state if a reset occurs
> at the wrong time. This can cause networking to not come up during
> boot and potentially require manual intervention in bringing up
> applications that depend on the network.
> 
> Changelog[v2] [Address comments from Jakub Kicinski]
> 	- Fix up commit log for patch 5/7 and drop unnecessary variable
> 	- Format Fixes line properly (no wrapping, no blank lines)
> 
> Sukadev Bhattiprolu (7):
>   ibmvnic: restore state in change-param reset
>   ibmvnic: update reset function prototypes
>   ibmvnic: avoid allocating rwi entries
>   ibmvnic: switch order of checks in ibmvnic_reset
>   ibmvnic: serialize access to work queue
>   ibmvnic: check adapter->state under state_lock
>   ibmvnic: add comments about state_lock
> 
> 
Other than the two minor comments, 
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>

