Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C89DA599289
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 03:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235656AbiHSB3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 21:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbiHSB3p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 21:29:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FFFE792DD;
        Thu, 18 Aug 2022 18:29:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3398E6131C;
        Fri, 19 Aug 2022 01:29:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4597FC433C1;
        Fri, 19 Aug 2022 01:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660872582;
        bh=frI2Q/zbG/L83BBppB9AO7i9l6epJV3xu5ZGGw2w4G0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=j94K3p2Kt//Y4i4AcLYWMMppHE2gmuLApUU/XDkdEpXGAB8evyllI/b2WHx1cSJUb
         PoqxqcFeZngsaRM5dGyaRYJ4W8OvEkXTfm5WCAEOtQ/ZF7XOw0pQAiFA0iPrMptuM5
         wIycyePu+yFJojb2wg+RXIgzuR3jHAve94SSHfv9nDzuI/6C7iNzgsF34qunpsjdta
         a5mr/F8dHDPVq7nNlEWGFL3y7Slj4lOWCEjmvjEjS7HuP4i6ky6bPjIfONtz1K5X8B
         5aoAySVsuYODUKYNb8SQd5c5Z+W5IwjGt29yfZDe2iMABZ0XH58qt91xpK8189gqAU
         xfDUNygKUI6bA==
Date:   Thu, 18 Aug 2022 18:29:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     syzbot <syzbot+7b9133d0ed61f27a4f7d@syzkaller.appspotmail.com>
Cc:     borisp@nvidia.com, davem@davemloft.net, edumazet@google.com,
        john.fastabend@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] general protection fault in
 tls_strp_load_anchor_with_queue
Message-ID: <20220818182941.5d78a7f8@kernel.org>
In-Reply-To: <000000000000077caa05e67e7461@google.com>
References: <000000000000077caa05e67e7461@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Aug 2022 23:54:30 -0700 syzbot wrote:
> syzbot found the following issue on:
> 
> HEAD commit:    7ebfc85e2cd7 Merge tag 'net-6.0-rc1' of git://git.kernel.o..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1750b16b080000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=924833c12349a8c0
> dashboard link: https://syzkaller.appspot.com/bug?extid=7b9133d0ed61f27a4f7d
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+7b9133d0ed61f27a4f7d@syzkaller.appspotmail.com

Must have gone thru init and failed to allocate the skb, so:

#syz dup: WARNING in tls_strp_done
