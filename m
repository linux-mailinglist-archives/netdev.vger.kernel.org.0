Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4409B509D74
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 12:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388327AbiDUKV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 06:21:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50030 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238429AbiDUKVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 06:21:03 -0400
Received: from localhost (cpc147930-brnt3-2-0-cust60.4-2.cable.virginm.net [86.15.196.61])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 1CD0B83F382C;
        Thu, 21 Apr 2022 03:18:12 -0700 (PDT)
Date:   Thu, 21 Apr 2022 11:18:07 +0100 (BST)
Message-Id: <20220421.111807.1804226251338066304.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        kuba@kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com
Subject: Re: [PATCH net] sctp: check asoc strreset_chunk in
 sctp_generate_reconf_event
From:   David Miller <davem@davemloft.net>
In-Reply-To: <3000f8b12920ae81b84dceead6dcc90bb00c0403.1650487961.git.lucien.xin@gmail.com>
References: <3000f8b12920ae81b84dceead6dcc90bb00c0403.1650487961.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Thu, 21 Apr 2022 03:18:14 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 20 Apr 2022 16:52:41 -0400

> diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
> index b3815b568e8e..463c4a58d2c3 100644
> --- a/net/sctp/sm_sideeffect.c
> +++ b/net/sctp/sm_sideeffect.c
> @@ -458,6 +458,10 @@ void sctp_generate_reconf_event(struct timer_list *t)
>  		goto out_unlock;
>  	}
>  
> +	/* This happens when the response arrives after the timer is triggered. */
> +	if (!asoc->strreset_chunk)
> +		goto out_unlock;
> +
This will return 0 because that is error's value right there, intentional?

Thanks.

