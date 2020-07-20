Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFD39227302
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 01:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbgGTXhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 19:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726383AbgGTXhA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 19:37:00 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A87C061794;
        Mon, 20 Jul 2020 16:37:00 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A004511E8EC0A;
        Mon, 20 Jul 2020 16:36:59 -0700 (PDT)
Date:   Mon, 20 Jul 2020 16:36:58 -0700 (PDT)
Message-Id: <20200720.163658.560155959996455439.davem@davemloft.net>
To:     stephen@networkplumber.org
Cc:     willemdebruijn.kernel@gmail.com, srirakr2@cisco.com,
        akpm@linux-foundation.org, xe-linux-external@cisco.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sthemmin@microsoft.com,
        mbumgard@cisco.com
Subject: Re: [PATCH v2] AF_PACKET doesnt strip VLAN information
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200720135650.1939665b@hermes.lan>
References: <CY4PR1101MB21013DCD55B754E29AF4A838907B0@CY4PR1101MB2101.namprd11.prod.outlook.com>
        <CAF=yD-+gCkPVkXwcH6KiKYGV77TvpZiDo=3YyXeuGFk=TR2dcw@mail.gmail.com>
        <20200720135650.1939665b@hermes.lan>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Jul 2020 16:37:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Hemminger <stephen@networkplumber.org>
Date: Mon, 20 Jul 2020 13:56:50 -0700

> It matters because the problem is generic, not just to the netvsc driver.
> For example, BPF programs and netfilter rules will see different packets
> when send is through AF_PACKET than they would see for sends from the
> kernel stack.
> 
> Presenting uniform data to the lower layers makes sense.

The issue here is that for hyperv, vlan offloading is not a "may" but
a "must" and I've never understood it to have that meaning.

And I still haven't heard what is going to happen in Q-in-Q situations
even with the ugly hyperv driver hack that is currently under review.
