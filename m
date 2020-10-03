Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1593328205B
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 04:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725881AbgJCCGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 22:06:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbgJCCGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 22:06:43 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC6B5C0613D0;
        Fri,  2 Oct 2020 19:06:42 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 947C91260D092;
        Fri,  2 Oct 2020 18:49:53 -0700 (PDT)
Date:   Fri, 02 Oct 2020 19:06:38 -0700 (PDT)
Message-Id: <20201002.190638.1090456279017490485.davem@davemloft.net>
To:     anant.thazhemadam@gmail.com
Cc:     mst@redhat.com, jasowang@redhat.com, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [Linux-kernel-mentees][PATCH 0/2] reorder members of
 structures in virtio_net for optimization
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200930051722.389587-1-anant.thazhemadam@gmail.com>
References: <20200930051722.389587-1-anant.thazhemadam@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 02 Oct 2020 18:49:54 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anant Thazhemadam <anant.thazhemadam@gmail.com>
Date: Wed, 30 Sep 2020 10:47:20 +0530

> The structures virtnet_info and receive_queue have byte holes in 
> middle, and their members could do with some rearranging 
> (order-of-declaration wise) in order to overcome this.
> 
> Rearranging the members helps in:
>   * elimination the byte holes in the middle of the structures
>   * reduce the size of the structure (virtnet_info)
>   * have more members stored in one cache line (as opposed to 
>     unnecessarily crossing the cacheline boundary and spanning
>     different cachelines)
> 
> The analysis was performed using pahole.
> 
> These patches may be applied in any order.

What effects do these changes have on performance?

The cache locality for various TX and RX paths could be effected.

I'm not applying these patches without some data on the performance
impact.

Thank you.

