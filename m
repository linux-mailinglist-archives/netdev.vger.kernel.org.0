Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE9960183A
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 21:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbiJQT5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 15:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbiJQT5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 15:57:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A37EC1A3B9;
        Mon, 17 Oct 2022 12:57:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65F02B81A0D;
        Mon, 17 Oct 2022 19:57:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A99D6C433D6;
        Mon, 17 Oct 2022 19:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666036628;
        bh=tGax2dP7DaCPd5NhbqpBKZoulXuDlVfRY+gbijvj8ow=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hfhgKFUEcICKXMmZh4W66V0Oy5O5d2giZUmiVQPHNf8mcl+ptukWXl7/fVKKoC2mY
         wUMq8hIuEB8JGotF4MKlfugqy/QtvIAdM3HQvf6lfkHWklPHlzRTcCSbwqF6zwGHac
         dlJb+CefRMG0gid+msC9ZVt25asoP5tNWHe6LNPoAZig8W3f06Pr1Miz6jEazXtlmQ
         mQT5BSaFy0CoA/71OYU5DCD4VEq0wCnGvpObrmnV4LW+tZoyjtGR4C10Pgqu+4cg0Q
         aL6l9gEQGCI3DCqd6+UfBSquuh2nJyM2lcJfWtIgTIX+ZWZcveO9i2o07+gcoXTX/1
         wGKwYtgqMVfcw==
Date:   Mon, 17 Oct 2022 12:57:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     syzbot <syzbot+a30f71cf20b71d5950e7@syzkaller.appspotmail.com>
Cc:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, edumazet@google.com, hawk@kernel.org,
        jasowang@redhat.com, john.fastabend@gmail.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        mst@redhat.com, netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [syzbot] usb-testing boot error: WARNING in
 __netif_set_xps_queue
Message-ID: <20221017125706.79da00e0@kernel.org>
In-Reply-To: <000000000000f80cbd05eb361e8e@google.com>
References: <000000000000f80cbd05eb361e8e@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Oct 2022 00:42:43 -0700 syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    9abf2313adc1 Linux 6.1-rc1
> git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
> console output: https://syzkaller.appspot.com/x/log.txt?x=15c16c3c880000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c62bac73287f46bf
> dashboard link: https://syzkaller.appspot.com/bug?extid=a30f71cf20b71d5950e7
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

#syz fix: Revert "net: fix cpu_max_bits_warn() usage in netif_attrmask_next{,_and}"
