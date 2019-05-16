Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AECAD20F12
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 21:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727184AbfEPTME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 15:12:04 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60074 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726317AbfEPTME (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 15:12:04 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 325AE133E977D;
        Thu, 16 May 2019 12:12:03 -0700 (PDT)
Date:   Thu, 16 May 2019 12:12:02 -0700 (PDT)
Message-Id: <20190516.121202.232705215173348273.davem@davemloft.net>
To:     sunilmut@microsoft.com
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        sashal@kernel.org, decui@microsoft.com, mikelley@microsoft.com,
        netdev@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] hv_sock: Add support for delayed close
From:   David Miller <davem@davemloft.net>
In-Reply-To: <BN6PR21MB0465043C08E519774EE73E99C0090@BN6PR21MB0465.namprd21.prod.outlook.com>
References: <BN6PR21MB0465043C08E519774EE73E99C0090@BN6PR21MB0465.namprd21.prod.outlook.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 16 May 2019 12:12:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Muthuswamy <sunilmut@microsoft.com>
Date: Wed, 15 May 2019 00:56:05 +0000

> Currently, hvsock does not implement any delayed or background close
> logic. Whenever the hvsock socket is closed, a FIN is sent to the peer, and
> the last reference to the socket is dropped, which leads to a call to
> .destruct where the socket can hang indefinitely waiting for the peer to
> close it's side. The can cause the user application to hang in the close()
> call.
> 
> This change implements proper STREAM(TCP) closing handshake mechanism by
> sending the FIN to the peer and the waiting for the peer's FIN to arrive
> for a given timeout. On timeout, it will try to terminate the connection
> (i.e. a RST). This is in-line with other socket providers such as virtio.
> 
> This change does not address the hang in the vmbus_hvsock_device_unregister
> where it waits indefinitely for the host to rescind the channel. That
> should be taken up as a separate fix.
> 
> Signed-off-by: Sunil Muthuswamy <sunilmut@microsoft.com>

Applied, thanks.
