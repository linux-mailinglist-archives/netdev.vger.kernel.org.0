Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17835280C0D
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 03:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387495AbgJBBmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 21:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727780AbgJBBmT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 21:42:19 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1982BC0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 18:42:19 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3E91A1285CF6B;
        Thu,  1 Oct 2020 18:25:31 -0700 (PDT)
Date:   Thu, 01 Oct 2020 18:42:18 -0700 (PDT)
Message-Id: <20201001.184218.21920326424555147.davem@davemloft.net>
To:     petko.manolov@konsulko.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] net: usb: pegasus: Proper error handing when setting
 pegasus' MAC address
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200929114039.26866-1-petko.manolov@konsulko.com>
References: <20200929114039.26866-1-petko.manolov@konsulko.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 01 Oct 2020 18:25:31 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petko Manolov <petko.manolov@konsulko.com>
Date: Tue, 29 Sep 2020 14:40:39 +0300

> -static void set_ethernet_addr(pegasus_t *pegasus)
> +static int set_ethernet_addr(pegasus_t *pegasus)
>  {

You change this to return an 'int' but no callers were updated to check it.

Furthermore, failure to probe a MAC address can be resolved by
choosing a random MAC address.  This handling is preferrable because
it allows the interface to still come up successfully.
