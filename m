Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3144A9F51
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 12:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732900AbfIEKNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 06:13:32 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44158 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbfIEKNc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 06:13:32 -0400
Received: from localhost (unknown [89.248.140.11])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DE683153878EF;
        Thu,  5 Sep 2019 03:13:30 -0700 (PDT)
Date:   Thu, 05 Sep 2019 12:13:29 +0200 (CEST)
Message-Id: <20190905.121329.764571693233274743.davem@davemloft.net>
To:     suyj.fnst@cn.fujitsu.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] ipv4: fix ifa_flags reuse problem in using
 ifconfig tool
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1567582667-56549-1-git-send-email-suyj.fnst@cn.fujitsu.com>
References: <1567582667-56549-1-git-send-email-suyj.fnst@cn.fujitsu.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 05 Sep 2019 03:13:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Su Yanjun <suyj.fnst@cn.fujitsu.com>
Date: Wed, 4 Sep 2019 15:37:47 +0800

> When NetworkManager has already set ipv4 address then uses
> ifconfig set another ipv4 address. It will use previous ifa_flags
> that will cause device route not be inserted.
> 
> As NetworkManager has already support IFA_F_NOPREFIXROUTE flag [1],
> but ifconfig will reuse the ifa_flags. It's weird especially
> some old scripts or program [2]  still  use ifconfig.
> 
> [1] https://gitlab.freedesktop.org/NetworkManager/NetworkManager/
> commit/fec80e7473ad16979af75ed299d68103e7aa3fe9
> 
> [2] LTP or TAHI
> 
> Signed-off-by: Su Yanjun <suyj.fnst@cn.fujitsu.com>

I don't know about this.

This will lose things like IFA_F_SECONDARY as well.

Sorry, I am not convinced that this change is correct nor safe.
