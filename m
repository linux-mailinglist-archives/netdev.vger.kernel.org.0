Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A173421402F
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 22:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgGCUDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 16:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbgGCUDK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 16:03:10 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C91C061794
        for <netdev@vger.kernel.org>; Fri,  3 Jul 2020 13:03:08 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2734A152F67B7;
        Fri,  3 Jul 2020 13:03:08 -0700 (PDT)
Date:   Fri, 03 Jul 2020 13:03:07 -0700 (PDT)
Message-Id: <20200703.130307.571238079367654965.davem@davemloft.net>
To:     skalluru@marvell.com
Cc:     netdev@vger.kernel.org, aelior@marvell.com, irusskikh@marvell.com,
        mkalderon@marvell.com
Subject: Re: [PATCH net-next v2 2/4] bnx2x: Populate database for Idlechk
 tests.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1593778190-1818-3-git-send-email-skalluru@marvell.com>
References: <1593778190-1818-1-git-send-email-skalluru@marvell.com>
        <1593778190-1818-3-git-send-email-skalluru@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 Jul 2020 13:03:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Date: Fri, 3 Jul 2020 17:39:48 +0530

> +/* struct holding the database of self test checks (registers and predicates) */
> +/* lines start from 2 since line 1 is heading in csv */
> +#define ST_DB_LINES 468
> +struct st_record st_database[ST_DB_LINES] = {

This will introduce a build warning because there is no external declaration for
this global variable.

A patch series must be fully bisectable, meaning that you can't just
add this declaration in a future patch in the series.  It has to be
added in the same patch where the symbol is defined.

