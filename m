Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C15025B6C6
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 00:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbgIBWzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 18:55:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726247AbgIBWzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 18:55:15 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E544C061244
        for <netdev@vger.kernel.org>; Wed,  2 Sep 2020 15:55:15 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 42A19157460D3;
        Wed,  2 Sep 2020 15:38:28 -0700 (PDT)
Date:   Wed, 02 Sep 2020 15:55:13 -0700 (PDT)
Message-Id: <20200902.155513.2158302550582662254.davem@davemloft.net>
To:     ecree@solarflare.com
Cc:     linux-net-drivers@solarflare.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/5] sfc: add and use efx_tx_send_pending in
 tx.c
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1edd44e5-a73a-149f-fe0c-96969627d211@solarflare.com>
References: <d3c81ab7-6d2e-326f-e25e-e42095ce9e66@solarflare.com>
        <1edd44e5-a73a-149f-fe0c-96969627d211@solarflare.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 02 Sep 2020 15:38:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree@solarflare.com>
Date: Wed, 2 Sep 2020 15:35:53 +0100

> +	tx_queue->xmit_more_available = true;

I don't understand why you're setting xmit_more_available
unconditionally to true now instead of setting it to 'xmit_more' as
seen by this transmit attempt.  Why would you want to signal
that xmit_more handling might be necessary when you haven't been
given an xmit_more tx request?

If this change is in fact correct, it's something you need to explain
in the commit message.
