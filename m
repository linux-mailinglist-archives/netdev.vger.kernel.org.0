Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 042204ED40D
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 08:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbiCaGoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 02:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbiCaGoI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 02:44:08 -0400
Received: from out30-54.freemail.mail.aliyun.com (out30-54.freemail.mail.aliyun.com [115.124.30.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC14316A6BF;
        Wed, 30 Mar 2022 23:42:19 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R851e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0V8hnGI3_1648708936;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V8hnGI3_1648708936)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 31 Mar 2022 14:42:17 +0800
Date:   Thu, 31 Mar 2022 14:42:15 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     syzbot <syzbot+6e29a053eb165bd50de5@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, kgraul@linux.ibm.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] memory leak in smc_create (2)
Message-ID: <YkVNR/dKuTh9wYq4@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <00000000000070bc9405db4d96b8@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000000000070bc9405db4d96b8@google.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 28, 2022 at 01:59:26PM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    ed4643521e6a Merge tag 'arm-dt-5.18' of git://git.kernel.o..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=14d17b99700000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=8414405fa34d7154
> dashboard link: https://syzkaller.appspot.com/bug?extid=6e29a053eb165bd50de5
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16431151700000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15f44cdb700000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+6e29a053eb165bd50de5@syzkaller.appspotmail.com
 
__smc_release() does not handle it properly when it falls back and
sk_state is SMC_CLOSED but not calls sock_put(). This makes sk leaks.

I will fix it soon.

Tony Lu
