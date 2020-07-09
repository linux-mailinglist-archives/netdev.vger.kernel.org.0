Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5458C21AB85
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 01:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbgGIX0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 19:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726222AbgGIX0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 19:26:12 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E3A7C08C5CE
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 16:26:12 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BB51E120F941D;
        Thu,  9 Jul 2020 16:26:09 -0700 (PDT)
Date:   Thu, 09 Jul 2020 16:26:06 -0700 (PDT)
Message-Id: <20200709.162606.1568687795941901793.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     linux@roeck-us.net, netdev@vger.kernel.org, cam@neo-zeon.de,
        pgwipeout@gmail.com, lufq.fnst@cn.fujitsu.com, dsonck92@gmail.com,
        qiang.zhang@windriver.com, t.lamprecht@proxmox.com,
        daniel@iogearbox.net, lizefan@huawei.com, tj@kernel.org,
        guro@fb.com
Subject: Re: [Patch net v2] cgroup: fix cgroup_sk_alloc() for
 sk_clone_lock()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAM_iQpW6dW0avuhKhifuvHYYzsoC7Na6JA4UPzjnPGqSDgzE3w@mail.gmail.com>
References: <CAM_iQpVk=54omCG8rrDn7GDg9KxKATT4fufRHbn=BSDKWyTu7w@mail.gmail.com>
        <e0387ee2-56b8-c780-8d33-c477a875e2df@roeck-us.net>
        <CAM_iQpW6dW0avuhKhifuvHYYzsoC7Na6JA4UPzjnPGqSDgzE3w@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 Jul 2020 16:26:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Thu, 9 Jul 2020 12:19:40 -0700

> Make sure you test the second patch I sent, not the first one. The
> first one is still incomplete and ugly too. The two bits must be the
> last two, so correcting the if test is not sufficient, we have to
> fix the whole bitfield packing.

That is definitely the correct thing to do, I'm going to apply that
bitfield packing patch as-is because I have to get a pull request to
Linus and I don't want to break big endian like this.
