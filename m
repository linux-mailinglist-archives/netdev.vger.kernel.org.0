Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C665C3C66
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 18:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388981AbfJAQvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 12:51:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49762 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387911AbfJAQvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 12:51:14 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0C5C3154ECADD;
        Tue,  1 Oct 2019 09:51:14 -0700 (PDT)
Date:   Tue, 01 Oct 2019 09:51:13 -0700 (PDT)
Message-Id: <20191001.095113.383452363568954178.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     vinicius.gomes@intel.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net] net: sched: taprio: Avoid division by zero on
 invalid link speed
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190928233722.15054-1-olteanv@gmail.com>
References: <20190928233722.15054-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 01 Oct 2019 09:51:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Sun, 29 Sep 2019 02:37:22 +0300

> The check in taprio_set_picos_per_byte is currently not robust enough
> and will trigger this division by zero, due to e.g. PHYLINK not setting
> kset->base.speed when there is no PHY connected:
 ...
> Russell King points out that the ethtool API says zero is a valid return
> value of __ethtool_get_link_ksettings:
> 
>    * If it is enabled then they are read-only; if the link
>    * is up they represent the negotiated link mode; if the link is down,
>    * the speed is 0, %SPEED_UNKNOWN or the highest enabled speed and
>    * @duplex is %DUPLEX_UNKNOWN or the best enabled duplex mode.
> 
>   So, it seems that taprio is not following the API... I'd suggest either
>   fixing taprio, or getting agreement to change the ethtool API.
> 
> The chosen path was to fix taprio.
> 
> Fixes: 7b9eba7ba0c1 ("net/sched: taprio: fix picos_per_byte miscalculation")
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Applied and queued up for -stable.
