Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52BAC1DBC81
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 20:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbgETSRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 14:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726650AbgETSRV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 14:17:21 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADB18C061A0E
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 11:17:19 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8029D12995B49;
        Wed, 20 May 2020 11:17:18 -0700 (PDT)
Date:   Wed, 20 May 2020 11:17:17 -0700 (PDT)
Message-Id: <20200520.111717.835995575109387492.davem@davemloft.net>
To:     a@unstable.cc
Cc:     netdev@vger.kernel.org, cake@lists.bufferbloat.net, toke@toke.dk,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        stephen@networkplumber.org
Subject: Re: [PATCH] net/sch_generic.h: use sizeof_member() and get rid of
 unused variable
From:   David Miller <davem@davemloft.net>
In-Reply-To: <2a6a8d4b-cb78-f717-5ede-29a921c5cb05@unstable.cc>
References: <20200519091333.20923-1-a@unstable.cc>
        <20200519.154019.1247104207621510920.davem@davemloft.net>
        <2a6a8d4b-cb78-f717-5ede-29a921c5cb05@unstable.cc>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 20 May 2020 11:17:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antonio Quartulli <a@unstable.cc>
Date: Wed, 20 May 2020 10:39:33 +0200

> I don't think it's BUILD_BUG_ON()'s fault, because qcb->data is passed
> to sizeof() first.
> 
> My best guess is that gcc is somewhat optimizing the sizeof(gcb->data)
> and thus leaving the gcb variable unused.

If you remove the argument from the function but leave the BUILD_BUG_ON()
calls the same, the compilation will fail.

Any such optimization is therefore unreasonable.

The variable is used otherwise compilation would not fail when you
remove it right?
