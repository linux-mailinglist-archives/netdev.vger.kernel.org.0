Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A56154FD73
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 20:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbfFWSHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 14:07:39 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43298 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726417AbfFWSHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 14:07:39 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 727E715310D39;
        Sun, 23 Jun 2019 11:07:38 -0700 (PDT)
Date:   Sun, 23 Jun 2019 11:07:37 -0700 (PDT)
Message-Id: <20190623.110737.1466794521532071350.davem@davemloft.net>
To:     ap420073@gmail.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] vxlan: do not destroy fdb if register_netdevice()
 is failed
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190620115108.5701-1-ap420073@gmail.com>
References: <20190620115108.5701-1-ap420073@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 23 Jun 2019 11:07:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>
Date: Thu, 20 Jun 2019 20:51:08 +0900

> __vxlan_dev_create() destroys FDB using specific pointer which indicates
> a fdb when error occurs.
> But that pointer should not be used when register_netdevice() fails because
> register_netdevice() internally destroys fdb when error occurs.
> 
> In order to avoid un-registered dev's notification, fdb destroying routine
> checks dev's register status before notification.

Simply pass do_notify as false in this failure code path of __vxlan_dev_create(),
thank you.
