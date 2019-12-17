Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B61D4121FAE
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 01:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727572AbfLQA0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 19:26:17 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57742 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726734AbfLQA0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 19:26:17 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1AA1715572D44;
        Mon, 16 Dec 2019 16:26:17 -0800 (PST)
Date:   Mon, 16 Dec 2019 16:26:16 -0800 (PST)
Message-Id: <20191216.162616.2089849587478762136.davem@davemloft.net>
To:     alexchan@task.com.hk
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] llc2: Reverse the true/false statements of the
 condition operator in llc_stat_ev_rx_null_dsap_xid_c and
 llc_stat_ev_rx_null_dsap_test_c.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1576340820-4929-1-git-send-email-alexchan@task.com.hk>
References: <1576340820-4929-1-git-send-email-alexchan@task.com.hk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Dec 2019 16:26:17 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Chan Shu Tak, Alex" <alexchan@task.com.hk>
Date: Sun, 15 Dec 2019 00:26:58 +0800

> @@ -32,7 +32,7 @@ static int llc_stat_ev_rx_null_dsap_xid_c(struct sk_buff *skb)
>  	return LLC_PDU_IS_CMD(pdu) &&			/* command PDU */
>  	       LLC_PDU_TYPE_IS_U(pdu) &&		/* U type PDU */
>  	       LLC_U_PDU_CMD(pdu) == LLC_1_PDU_CMD_XID &&
> -	       !pdu->dsap ? 0 : 1;			/* NULL DSAP value */
> +	       !pdu->dsap ? 1 : 0;			/* NULL DSAP value */
>  }
>  
>  static int llc_stat_ev_rx_null_dsap_test_c(struct sk_buff *skb)
> @@ -42,7 +42,7 @@ static int llc_stat_ev_rx_null_dsap_test_c(struct sk_buff *skb)
>  	return LLC_PDU_IS_CMD(pdu) &&			/* command PDU */
>  	       LLC_PDU_TYPE_IS_U(pdu) &&		/* U type PDU */
>  	       LLC_U_PDU_CMD(pdu) == LLC_1_PDU_CMD_TEST &&
> -	       !pdu->dsap ? 0 : 1;			/* NULL DSAP */
> +	       !pdu->dsap ? 1 : 0;			/* NULL DSAP */
>  }
>  

These are both plain booleans now then.  Just plain "!pdu->dsap" is
therefore, sufficient.
