Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8FE24C9F3D
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 09:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240178AbiCBIag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 03:30:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240152AbiCBIaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 03:30:30 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7E05B8B5D
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 00:29:45 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id r187-20020a1c2bc4000000b003810e6b192aso753758wmr.1
        for <netdev@vger.kernel.org>; Wed, 02 Mar 2022 00:29:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=anfYM1xs0NBMLGEeqezGOYJl+MN+3QcGgOkQ0d7W1KU=;
        b=T250LPSLKUXQUaclMSeK0mZPrWImkaAZdf7+pxpZvYBVIjiMfRgaCAywrd9G1ZgB/0
         RPeRZER9ugo42HQs7vOFLBMSQPAOYqXg/oajPZgQ5ONy0UZDqxelCW0yWfe1ksHhPrcL
         P/a98j6H0buLuTut7KDXTAftRVTqbi5jMarQoWo0xKWi9Z3HP4a7XxZrRZ0rOP/uX4Az
         LLIvmIk/579eXMZTSFWGq2fEQFgW+uDPuDijzIupYzselXw2nRaSOd5AugqhhPqSZ3gc
         FEmfiAKLSrRBVcbA2KYP4MfAaSSA9cu4RGT+7dOnfaFc9d8vJLURer8fML3X+2CR2b/7
         ze5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=anfYM1xs0NBMLGEeqezGOYJl+MN+3QcGgOkQ0d7W1KU=;
        b=43uOOQJGsDfZ8v5UkXhmuPzOVxtLiMm2k7E0k9mH/UHXYzmu1F5QIJIWdmKpHWFIVX
         wmBnqsc+iPCEVORme0A7zYIzFpAA/99R7sBtgMQmpFbOAPKwroPMAkuOIXnVIPOEN9i8
         IAylCURmbx3u1o81iCKYT+UVC+DrpKVL0zud2uBF5AN59YzNPRTTUGpo0459BqC0tnqc
         ErfL7er5ZDZ+AuYld8WGE65GSkoko+bu96tFYhlm7cHGm8MKTJjy++zuQmZiNgPiBGH1
         rDyjvT9o5h3m+nEESA8NU+qjFC2nw8JQ04x6NHZ0LK/uSeEqqpCQifP2rUEvL4bE5wdS
         1POg==
X-Gm-Message-State: AOAM533YcKl/6+qD92bLu0K916ywsad6Y/deIVicS9SkqJ5/h13BpNW6
        UK4gEzYWECFWX+xj1KTohvxV6YbPREJBNJLn
X-Google-Smtp-Source: ABdhPJyejoqO4Ua2lw3doPCMFKI7AoknOX/n2Hq9a7QihlNIy2VB0jsIjJbRKAzoK9Beq8n1Bceu5Q==
X-Received: by 2002:a1c:a915:0:b0:380:e3de:b78f with SMTP id s21-20020a1ca915000000b00380e3deb78fmr20356178wme.19.1646209784264;
        Wed, 02 Mar 2022 00:29:44 -0800 (PST)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id z16-20020a7bc7d0000000b00381004c643asm4689971wmk.30.2022.03.02.00.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 00:29:43 -0800 (PST)
Date:   Wed, 2 Mar 2022 08:29:41 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     syzbot <syzbot+3140b17cb44a7b174008@syzkaller.appspotmail.com>,
        jasowang@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [syzbot] kernel BUG in vhost_get_vq_desc
Message-ID: <Yh8q9fzCQHW2qtIG@google.com>
References: <00000000000070ac6505d7d9f7a8@google.com>
 <0000000000003b07b305d840b30f@google.com>
 <20220218063352-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220218063352-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Feb 2022, Michael S. Tsirkin wrote:

> On Thu, Feb 17, 2022 at 05:21:20PM -0800, syzbot wrote:
> > syzbot has found a reproducer for the following issue on:
> > 
> > HEAD commit:    f71077a4d84b Merge tag 'mmc-v5.17-rc1-2' of git://git.kern..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=104c04ca700000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=a78b064590b9f912
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3140b17cb44a7b174008
> > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1362e232700000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11373a6c700000
> > 
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+3140b17cb44a7b174008@syzkaller.appspotmail.com
> > 
> > ------------[ cut here ]------------
> > kernel BUG at drivers/vhost/vhost.c:2335!
> > invalid opcode: 0000 [#1] PREEMPT SMP KASAN
> > CPU: 1 PID: 3597 Comm: vhost-3596 Not tainted 5.17.0-rc4-syzkaller-00054-gf71077a4d84b #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > RIP: 0010:vhost_get_vq_desc+0x1d43/0x22c0 drivers/vhost/vhost.c:2335
> > Code: 00 00 00 48 c7 c6 20 2c 9d 8a 48 c7 c7 98 a6 8e 8d 48 89 ca 48 c1 e1 04 48 01 d9 e8 b7 59 28 fd e9 74 ff ff ff e8 5d c8 a1 fa <0f> 0b e8 56 c8 a1 fa 48 8b 54 24 18 48 b8 00 00 00 00 00 fc ff df
> > RSP: 0018:ffffc90001d1fb88 EFLAGS: 00010293
> > RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
> > RDX: ffff8880234b0000 RSI: ffffffff86d715c3 RDI: 0000000000000003
> > RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000001
> > R10: ffffffff86d706bc R11: 0000000000000000 R12: ffff888072c24d68
> > R13: 0000000000000000 R14: dffffc0000000000 R15: ffff888072c24bb0
> > FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000000000000002 CR3: 000000007902c000 CR4: 00000000003506e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> >  <TASK>
> >  vhost_vsock_handle_tx_kick+0x277/0xa20 drivers/vhost/vsock.c:522
> >  vhost_worker+0x23d/0x3d0 drivers/vhost/vhost.c:372
> >  kthread+0x2e9/0x3a0 kernel/kthread.c:377
> >  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> 
> I don't see how this can trigger normally so I'm assuming
> another case of use after free.

Yes, exactly.

I patched it.  Please see:

https://lore.kernel.org/all/20220302075421.2131221-1-lee.jones@linaro.org/T/#t

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
