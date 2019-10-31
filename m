Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C630EB7D9
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 20:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729508AbfJaTO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 15:14:28 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59554 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729296AbfJaTO2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 15:14:28 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 036A314FC9299;
        Thu, 31 Oct 2019 12:14:27 -0700 (PDT)
Date:   Thu, 31 Oct 2019 12:14:27 -0700 (PDT)
Message-Id: <20191031.121427.1511041978214447127.davem@davemloft.net>
To:     madalin.bucur@nxp.com
Cc:     netdev@vger.kernel.org, roy.pledge@nxp.com,
        jakub.kicinski@netronome.com, joe@perches.com
Subject: Re: [net-next v2 01/13] dpaa_eth: use only one buffer pool per
 interface
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1572532679-472-2-git-send-email-madalin.bucur@nxp.com>
References: <1572532679-472-1-git-send-email-madalin.bucur@nxp.com>
        <1572532679-472-2-git-send-email-madalin.bucur@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 31 Oct 2019 12:14:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madalin Bucur <madalin.bucur@nxp.com>
Date: Thu, 31 Oct 2019 16:37:47 +0200

> @@ -2761,13 +2738,13 @@ static inline u16 dpaa_get_headroom(struct dpaa_buffer_layout *bl)
>  
>  static int dpaa_eth_probe(struct platform_device *pdev)
>  {
> -	struct dpaa_bp *dpaa_bps[DPAA_BPS_NUM] = {NULL};
> +	struct dpaa_bp *dpaa_bp = NULL;
>  	struct net_device *net_dev = NULL;
>  	struct dpaa_fq *dpaa_fq, *tmp;

Just a note that I fixed the reverse christmas tree ordering violation
created by this hunk while applying this series to net-next.
