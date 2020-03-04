Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE0A61787B3
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 02:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbgCDBnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 20:43:06 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38170 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727865AbgCDBnG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 20:43:06 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BC85115AD8528;
        Tue,  3 Mar 2020 17:43:05 -0800 (PST)
Date:   Tue, 03 Mar 2020 17:43:05 -0800 (PST)
Message-Id: <20200303.174305.187736433958803345.davem@davemloft.net>
To:     lesliemonis@gmail.com
Cc:     netdev@vger.kernel.org, tahiliani@nitk.edu.in, gautamramk@gmail.com
Subject: Re: [PATCH net-next 3/4] pie: remove pie_vars->accu_prob_overflows
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200302151831.2811-4-lesliemonis@gmail.com>
References: <20200302151831.2811-1-lesliemonis@gmail.com>
        <20200302151831.2811-4-lesliemonis@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 03 Mar 2020 17:43:06 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leslie Monis <lesliemonis@gmail.com>
Date: Mon,  2 Mar 2020 20:48:30 +0530

> -	prandom_bytes(&rnd, 8);
> +	prandom_bytes(&rnd, 7);

This is undefined because it depends upon the endianness whether you
are initializing the more significant 7 bytes or the least significant
7 bytes of rnd.

I think you should just keep this at 8 and explicitly clear out the
top byte.

