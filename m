Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2706E22D25E
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 01:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbgGXXow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 19:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726736AbgGXXow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 19:44:52 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ABB4C0619D3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 16:44:52 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DC02512755D05;
        Fri, 24 Jul 2020 16:28:06 -0700 (PDT)
Date:   Fri, 24 Jul 2020 16:44:51 -0700 (PDT)
Message-Id: <20200724.164451.1866334580838953417.davem@davemloft.net>
To:     geffrey.guo@huawei.com
Cc:     edumazet@google.com, kuba@kernel.org, maheshb@google.com,
        netdev@vger.kernel.org
Subject: Re: =?utf-8?B?562U5aSNOg==?= [PATCH,v2] ipvlan: add the check of
 ip header checksum
From:   David Miller <davem@davemloft.net>
In-Reply-To: <7bb7522a2bda40b8b4a9aac54ea1098b@huawei.com>
References: <6c050a3a1111445287edc52ca6cb056d@huawei.com>
        <CANn89i+OyQcZvAHi5ScehV2fyDyS0KsOpigU-KUokbD0z-NkmA@mail.gmail.com>
        <7bb7522a2bda40b8b4a9aac54ea1098b@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 Jul 2020 16:28:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Guodeqing (A)" <geffrey.guo@huawei.com>
Date: Fri, 24 Jul 2020 03:35:02 +0000

> The ihl check maybe not suitable in ip_fast_csum, the correct of the
> ihl value can be checked before calling the ip_fast_csum.

ip_fast_csum() must be able to handle any value that could fit in the
ihl field of the ip protocol header.  That's not only the most correct
logic, but also the most robust.

> The implementation of ip_fast_csum is different in different cpu
> architecture. the IP packet will do ip forward in the ipvlan l3/l3s
> mode and the corrupted ip packet

As Eric explained, several times, ip_fast_csum on arm64 has a bug and that
is where the fix belongs.

Please fix this bug in the proper place.

Thank you.
