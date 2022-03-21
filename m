Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 742DF4E3086
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 20:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352461AbiCUTKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 15:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352455AbiCUTKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 15:10:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF2EF25C54;
        Mon, 21 Mar 2022 12:08:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84449B819B9;
        Mon, 21 Mar 2022 19:08:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BD61C340F0;
        Mon, 21 Mar 2022 19:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647889732;
        bh=I2M4YjizpXTdiWneY92Z9cdijcfZVcivnq2uZ24KyhI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=s5M57ekAJJ6Oq6F15/Y0+83Lr4ZlkLddf3WbAoCJkZXm3FwY+sBrFJsgo2l6NRqlH
         3ZgYOTfC2EHlKEkw17cVQ7EjokQsATI8DNfYjDo48nEEwK1ET2lHmdL13kkJiDhuHo
         BGM8O00J+sjRswjU6kDFllQiD3Oib4JJu7sU8WPjj9ENO++MmPhJEN+DkbncHXHwaR
         QmdGbZo3a4l4i/OJb/RpEGUQd5iCwBrRhMvChx9MihpDnkFr7DoZV3yLuhWwO7ObtN
         k9Sf3GRqK5Oi6Zq1dLqiDwoKjfiOQU2wzqfRdjDROJT6vpVclx3B6wEy2uJvAyJrHc
         5U9KLy2j0CKlQ==
Date:   Mon, 21 Mar 2022 12:08:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     syzbot <syzbot+6f21ac9e27fca7e97623@syzkaller.appspotmail.com>
Cc:     Jason@zx2c4.com, davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, sfr@canb.auug.org.au,
        syzkaller-bugs@googlegroups.com, wireguard@lists.zx2c4.com
Subject: Re: [syzbot] linux-next test error: WARNING in __napi_schedule
Message-ID: <20220321120849.1c87c4a4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <000000000000110dee05da8de18a@google.com>
References: <000000000000110dee05da8de18a@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 19 Mar 2022 01:16:24 -0700 syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    6d72dda014a4 Add linux-next specific files for 20220318
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=124f5589700000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=5907d82c35688f04
> dashboard link: https://syzkaller.appspot.com/bug?extid=6f21ac9e27fca7e97623
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

#syz fix: net: Revert the softirq will run annotation in ____napi_schedule().
