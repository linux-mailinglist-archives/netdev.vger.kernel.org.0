Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6A91786C8
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 01:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728069AbgCCX7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 18:59:44 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:37278 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727707AbgCCX7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 18:59:43 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 46D8F15AAC888;
        Tue,  3 Mar 2020 15:59:43 -0800 (PST)
Date:   Tue, 03 Mar 2020 15:59:42 -0800 (PST)
Message-Id: <20200303.155942.1783778666891011268.davem@davemloft.net>
To:     tzhao@solarflare.com
Cc:     netdev@vger.kernel.org, scrum-linux@solarflare.com
Subject: Re: [PATCH net-next v2] sfc: complete the next packet when we
 receive a timestamp
From:   David Miller <davem@davemloft.net>
In-Reply-To: <be473840-506f-29f2-b373-a2aa829091c3@solarflare.com>
References: <be473840-506f-29f2-b373-a2aa829091c3@solarflare.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 03 Mar 2020 15:59:43 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Zhao <tzhao@solarflare.com>
Date: Tue, 3 Mar 2020 16:42:32 +0000

> @@ -3725,18 +3738,8 @@ static u32 efx_ef10_extract_event_ts(efx_qword_t *event)
>  
>  	switch (tx_ev_type) {
>  	case TX_TIMESTAMP_EVENT_TX_EV_COMPLETION:
 ...
> +		/* Ignore this event - see above. */
> +        break;
>  
>  	case TX_TIMESTAMP_EVENT_TX_EV_TSTAMP_LO:
>  		ts_part = efx_ef10_extract_event_ts(event);
> @@ -3747,9 +3750,8 @@ static u32 efx_ef10_extract_event_ts(efx_qword_t *event)
>  		ts_part = efx_ef10_extract_event_ts(event);
>  		tx_queue->completed_timestamp_major = ts_part;
>  
> -		efx_xmit_done(tx_queue, tx_queue->completed_desc_ptr);
> -		tx_queue->completed_desc_ptr = tx_queue->ptr_mask;
> -		break;
> +		efx_xmit_done_single(tx_queue);
> +        break;

Please correct the indentation of these two break; statements.  They should
use two TAB characters of indentation like the lines preceeding them.

Thank you.
