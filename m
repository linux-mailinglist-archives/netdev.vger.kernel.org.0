Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42BA36C3B19
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 20:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbjCUT6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 15:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjCUT6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 15:58:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69F81302B9;
        Tue, 21 Mar 2023 12:57:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED058617EC;
        Tue, 21 Mar 2023 19:57:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 277C9C433D2;
        Tue, 21 Mar 2023 19:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679428667;
        bh=GKA4u3MPOorQTBHU2zQGSJnmsX+P8WaqFLKkzLHEvJE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H6lg/B/buJIb/LZoslCty46VUSmVDDjrCtozuQJtxilxcKJW1FN7HRJpPDnWFj5yI
         01gu4iqeKf0OiAbVO4b97AkVsovIiQvCBUhA2LAcMoNgdQ0KX0cJRLuu9R648kL+SV
         CYFx5jyb+Loasx8FS63wDUEWB8ZmI1TnP3XAvlvxTUd5O1vE285bIdDOS0E2jXNhXe
         9FCP12eCMaMlHJNZcVMWQ+DdLYPFgTMkiEmnh+LDd35E4OVLoxg7+aOiJPBWiwyzGg
         PVjfWnje6LJxZWNaLV9Y6yjE7ElgMnYqBhOgyQuDVQjgtZBeuGE2+4MoEulGMeaLVO
         c1PdDFK3fgddw==
Date:   Tue, 21 Mar 2023 20:57:42 +0100
From:   Christian Brauner <brauner@kernel.org>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     syzbot <syzbot+6b27b2d2aba1c80cc13b@syzkaller.appspotmail.com>,
        jasowang@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mst@redhat.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [syzbot] [kernel?] general protection fault in vhost_task_start
Message-ID: <20230321195742.6b46syklc34es4cx@wittgenstein>
References: <0000000000005a60a305f76c07dc@google.com>
 <2d976892-9914-5de0-62e0-c75f1c148259@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2d976892-9914-5de0-62e0-c75f1c148259@oracle.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 12:46:04PM -0500, Mike Christie wrote:
> On 3/21/23 12:03 PM, syzbot wrote:
> > RIP: 0010:vhost_task_start+0x22/0x40 kernel/vhost_task.c:115
> > Code: 00 00 00 00 00 0f 1f 00 f3 0f 1e fa 53 48 89 fb e8 c3 67 2c 00 48 8d 7b 70 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 75 0a 48 8b 7b 70 5b e9 fe bd 02 00 e8 79 ec 7e 00 eb
> > RSP: 0018:ffffc90003a9fc38 EFLAGS: 00010207
> > RAX: dffffc0000000000 RBX: fffffffffffffff4 RCX: 0000000000000000
> > RDX: 000000000000000c RSI: ffffffff81564c8d RDI: 0000000000000064
> > RBP: ffff88802b21dd40 R08: 0000000000000100 R09: ffffffff8c917cf3
> > R10: 00000000fffffff4 R11: 0000000000000000 R12: fffffffffffffff4
> > R13: ffff888075d000b0 R14: ffff888075d00000 R15: ffff888075d00008
> > FS:  0000555556247300(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00007ffe3d8e5ff8 CR3: 00000000215d4000 CR4: 00000000003506f0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> >  <TASK>
> >  vhost_worker_create drivers/vhost/vhost.c:580 [inline]
> 
> The return value from vhost_task_create is incorrect if the kzalloc fails.
> 
> Christian, here is a fix for what's in your tree. Do you want me to submit
> a follow up patch like this or a replacement patch for:
> 
> commit 77feab3c4156 ("vhost_task: Allow vhost layer to use copy_process")

Since this has been in linux-next my tendency is to just put this fix on
top. So please slap a Fixes: tag on it and a Link to the syzbot report.
I also tend to annotate such fixes with "# mainline only":

Fixes: 77feab3c4156 ("vhost_task: Allow vhost layer to use copy_process") # mainline only

to prevent AUTOSEL from picking this up.

Thanks for taking care of this so quickly!
Christian
