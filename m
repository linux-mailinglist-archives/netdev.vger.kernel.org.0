Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23F8A233C97
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 02:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730905AbgGaAgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 20:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728086AbgGaAgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 20:36:15 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E95AEC061574;
        Thu, 30 Jul 2020 17:36:14 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477:9e51:a893:b0fe:602a])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CBEA9126C4857;
        Thu, 30 Jul 2020 17:19:27 -0700 (PDT)
Date:   Thu, 30 Jul 2020 17:36:10 -0700 (PDT)
Message-Id: <20200730.173610.1651631339985656912.davem@davemloft.net>
To:     xiongx18@fudan.edu.cn
Cc:     3chas3@gmail.com, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xiyuyang19@fudan.edu.cn, tanxin.ctf@gmail.com,
        yuanxzhang@fudan.edu.cn
Subject: Re: [PATCH] atm: fix atm_dev refcnt leaks in
 atmtcp_remove_persistent
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200729130659.GA7712@xin-virtual-machine>
References: <20200729130659.GA7712@xin-virtual-machine>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Jul 2020 17:19:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Xiong <xiongx18@fudan.edu.cn>
Date: Wed, 29 Jul 2020 21:06:59 +0800

> atmtcp_remove_persistent() invokes atm_dev_lookup(), which returns a
> reference of atm_dev with increased refcount or NULL if fails.
> 
> The refcount leaks issues occur in two error handling paths. If
> dev_data->persist is zero or PRIV(dev)->vcc isn't NULL, the function
> returns 0 without decreasing the refcount kept by a local variable,
> resulting in refcount leaks.
> 
> Fix the issue by adding atm_dev_put() before returning 0 both when
> dev_data->persist is zero or PRIV(dev)->vcc isn't NULL.
> 
> Signed-off-by: Xin Xiong <xiongx18@fudan.edu.cn>
> Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
> Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>

Applied, thank you.
