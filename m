Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A580D4F8E7
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 01:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbfFVXSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jun 2019 19:18:31 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60762 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726468AbfFVXSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jun 2019 19:18:30 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 04821153A9D77;
        Sat, 22 Jun 2019 16:18:29 -0700 (PDT)
Date:   Sat, 22 Jun 2019 16:18:29 -0700 (PDT)
Message-Id: <20190622.161829.532888207521796213.davem@davemloft.net>
To:     weifeng.voon@intel.com
Cc:     mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, joabreu@synopsys.com,
        peppe.cavallaro@st.com, andrew@lunn.ch, f.fainelli@gmail.com,
        alexandre.torgue@st.com, boon.leong.ong@intel.com
Subject: Re: [net v1] net: stmmac: fixed new system time seconds value
 calculation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1560953628-3248-1-git-send-email-weifeng.voon@intel.com>
References: <1560953628-3248-1-git-send-email-weifeng.voon@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 22 Jun 2019 16:18:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Voon Weifeng <weifeng.voon@intel.com>
Date: Wed, 19 Jun 2019 22:13:48 +0800

> From: Roland Hii <roland.king.guan.hii@intel.com>
> 
> When ADDSUB bit is set, the system time seconds field is calculated as
> the complement of the seconds part of the update value.
> 
> For example, if 3.000000001 seconds need to be subtracted from the
> system time, this field is calculated as
> 2^32 - 3 = 4294967296 - 3 = 0x100000000 - 3 = 0xFFFFFFFD
> 
> Previously, the 0x100000000 is mistakenly written as 100000000.
> 
> This is further simplified from
>   sec = (0x100000000ULL - sec);
> to
>   sec = -sec;
> 
> Fixes: ba1ffd74df74 ("stmmac: fix PTP support for GMAC4")
> Signed-off-by: Roland Hii <roland.king.guan.hii@intel.com>
> Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
> Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>

Applied and queued up for -stable.
