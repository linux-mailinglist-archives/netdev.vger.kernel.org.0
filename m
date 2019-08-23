Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B88EA9B844
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 23:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436965AbfHWVlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 17:41:47 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38218 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436959AbfHWVlq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 17:41:46 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 523501543B3FE;
        Fri, 23 Aug 2019 14:41:46 -0700 (PDT)
Date:   Fri, 23 Aug 2019 14:41:45 -0700 (PDT)
Message-Id: <20190823.144145.340164012400486097.davem@davemloft.net>
To:     jeffv@google.com
Cc:     netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org
Subject: Re: [PATCH 1/2] rtnetlink: gate MAC address with an LSM hook
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CABXk95BF=RfqFSHU_---DRHDoKyFON5kS_vYJbc4ns2OS=_t0w@mail.gmail.com>
References: <20190821134547.96929-1-jeffv@google.com>
        <20190822.161913.326746900077543343.davem@davemloft.net>
        <CABXk95BF=RfqFSHU_---DRHDoKyFON5kS_vYJbc4ns2OS=_t0w@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 23 Aug 2019 14:41:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeffrey Vander Stoep <jeffv@google.com>
Date: Fri, 23 Aug 2019 13:41:38 +0200

> I could make this really generic by adding a single hook to the end of
> sock_msgrecv() which would allow an LSM to modify the message to omit
> the MAC address and any other information that we deem as sensitive in the
> future. Basically what Casey was suggesting. Thoughts on that approach?

Editing the SKB in place is generally frowned upon, and it could be cloned
and in used by other code paths even, so would need to be copied or COW'd.
