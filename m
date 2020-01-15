Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B073B13CF46
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 22:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729976AbgAOVip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 16:38:45 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:60420 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbgAOVio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 16:38:44 -0500
Received: from localhost (unknown [62.21.130.100])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6CE2315A0E3F0;
        Wed, 15 Jan 2020 13:38:42 -0800 (PST)
Date:   Wed, 15 Jan 2020 13:38:41 -0800 (PST)
Message-Id: <20200115.133841.500823231264389395.davem@davemloft.net>
To:     mgamal@redhat.com
Cc:     linux-hyperv@vger.kernel.org, sthemmin@microsoft.com,
        haiyangz@microsoft.com, netdev@vger.kernel.org, kys@microsoft.com,
        sashal@kernel.org, vkuznets@redhat.com, cavery@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] hv_netvsc: Fix memory leak when removing rndis
 device
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200114130950.6962-1-mgamal@redhat.com>
References: <20200114130950.6962-1-mgamal@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 15 Jan 2020 13:38:44 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mohammed Gamal <mgamal@redhat.com>
Date: Tue, 14 Jan 2020 15:09:50 +0200

> kmemleak detects the following memory leak when hot removing
> a network device:
> 
> unreferenced object 0xffff888083f63600 (size 256):
 ...
> 
> rndis_filter_device_add() allocates an instance of struct rndis_device
> which never gets deallocated as rndis_filter_device_remove() sets
> net_device->extension which points to the rndis_device struct to NULL,
> leaving the rndis_device dangling.
> 
> Since net_device->extension is eventually freed in free_netvsc_device(),
> we refrain from setting it to NULL inside rndis_filter_device_remove()
> 
> Signed-off-by: Mohammed Gamal <mgamal@redhat.com>

Applied, thanks.
