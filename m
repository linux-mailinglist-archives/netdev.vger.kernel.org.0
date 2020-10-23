Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9E6297833
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 22:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1756080AbgJWUZo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 16:25:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:53142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S465903AbgJWUZo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 16:25:44 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F283A20882;
        Fri, 23 Oct 2020 20:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603484743;
        bh=T14EamLujZdgpnJfLA1IJCQtYmY4KwmusF+w79AgWXU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dsqLLj6sZXoXhtkM/DAig175muzlTNsauY2Vhn92mDHwSpwhH2hzlElvH86eqSkPi
         /v7DSHmDGVeysqX2zmB10KdSkZuvgcHvkXpiNBmZFFiZf4AD2AOncGA21FJna8IKc8
         SahR7K+nUdLNrac7FkAkQT828UCAyr0orqYn1N8M=
Date:   Fri, 23 Oct 2020 13:25:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Colin King <colin.king@canonical.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vsock: ratelimit unknown ioctl error message
Message-ID: <20201023132542.4f151318@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201023140947.kurglnklaqteovkp@steredhat>
References: <20201023122113.35517-1-colin.king@canonical.com>
        <20201023140947.kurglnklaqteovkp@steredhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Oct 2020 16:09:47 +0200 Stefano Garzarella wrote:
> On Fri, Oct 23, 2020 at 01:21:13PM +0100, Colin King wrote:
> >From: Colin Ian King <colin.king@canonical.com>
> >
> >When exercising the kernel with stress-ng with some ioctl tests the
> >"Unknown ioctl" error message is spamming the kernel log at a high
> >rate. Rate limit this message to reduce the noise.
> >
> >Signed-off-by: Colin Ian King <colin.king@canonical.com>
> >---
> > net/vmw_vsock/af_vsock.c | 2 +-
> > 1 file changed, 1 insertion(+), 1 deletion(-)
> >
> >diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> >index 9e93bc201cc0..b8feb9223454 100644
> >--- a/net/vmw_vsock/af_vsock.c
> >+++ b/net/vmw_vsock/af_vsock.c
> >@@ -2072,7 +2072,7 @@ static long vsock_dev_do_ioctl(struct file *filp,
> > 		break;
> >
> > 	default:
> >-		pr_err("Unknown ioctl %d\n", cmd);
> >+		pr_err_ratelimited("Unknown ioctl %d\n", cmd);  
> 
> Make sense, or maybe can we remove the error message returning only the
> -EINVAL?

+1

> Both cases are fine for me:
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>


