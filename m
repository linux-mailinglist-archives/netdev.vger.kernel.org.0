Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB693121FE9
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 01:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727741AbfLQAm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 19:42:57 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57908 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726556AbfLQAm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 19:42:57 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 69398157B2DDE;
        Mon, 16 Dec 2019 16:42:56 -0800 (PST)
Date:   Mon, 16 Dec 2019 16:42:55 -0800 (PST)
Message-Id: <20191216.164255.98881482203698707.davem@davemloft.net>
To:     pakki001@umn.edu
Cc:     kjlu@umn.edu, r.baldyga@samsung.com, k.opasiak@samsung.com,
        linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nfc: s3fwrn5: replace the assertion with a WARN_ON
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191215190129.1587-1-pakki001@umn.edu>
References: <20191215190129.1587-1-pakki001@umn.edu>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Dec 2019 16:42:56 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aditya Pakki <pakki001@umn.edu>
Date: Sun, 15 Dec 2019 13:01:29 -0600

> @@ -507,7 +507,8 @@ int s3fwrn5_fw_recv_frame(struct nci_dev *ndev, struct sk_buff *skb)
>  	struct s3fwrn5_info *info = nci_get_drvdata(ndev);
>  	struct s3fwrn5_fw_info *fw_info = &info->fw_info;
>  
> -	BUG_ON(fw_info->rsp);
> +	if (WARN_ON(fw_info->rsp))
> +		return -EINVAL;
>  
>  	fw_info->rsp = skb;

This leaks "skb" and you can even see that this might be the case
purely by looking at the context of the patch.
