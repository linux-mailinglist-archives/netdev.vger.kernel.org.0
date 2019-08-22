Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED979A211
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 23:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390541AbfHVVRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 17:17:21 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48964 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390383AbfHVVRU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 17:17:20 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 30F2A15363D76;
        Thu, 22 Aug 2019 14:17:19 -0700 (PDT)
Date:   Thu, 22 Aug 2019 14:17:16 -0700 (PDT)
Message-Id: <20190822.141716.31265124292191524.davem@davemloft.net>
To:     casey@schaufler-ca.com
Cc:     paul@paul-moore.com, fw@strlen.de, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Subject: Re: New skb extension for use by LSMs (skb "security blob")?
From:   David Miller <davem@davemloft.net>
In-Reply-To: <00ab1a3e-fd57-fe42-04fa-d82c1585b360@schaufler-ca.com>
References: <20190822070358.GE20113@breakpoint.cc>
        <CAHC9VhQ_+3ywPu0QRzP3cSgPH2i9Br994wJttp-yXy2GA4FrNg@mail.gmail.com>
        <00ab1a3e-fd57-fe42-04fa-d82c1585b360@schaufler-ca.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 22 Aug 2019 14:17:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Casey Schaufler <casey@schaufler-ca.com>
Date: Thu, 22 Aug 2019 13:10:43 -0700

> Given that the original objection to using a skb extension for a
> security blob was that an extension is dynamic, and that the ubiquitous
> nature of LSM use makes that unreasonable, it would seem that supporting
> the security blob as a basic part if the skb would be the obvious and
> correct solution. If the normal case is that there is an LSM that would
> befit from the native (unextended) support of a blob, it would seem
> that that is the case that should be optimized.

The objection is the cost, either in terms of dynamic allocation or in
terms of fixed space allocated inside of the SKB.

If you are given a u32 (which you already have) it can be used as an
IDR-like space to look up pointers if necessary.
