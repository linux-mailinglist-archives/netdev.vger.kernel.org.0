Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97F5662892E
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 20:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236888AbiKNTUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 14:20:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237013AbiKNTUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 14:20:11 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F252275CF;
        Mon, 14 Nov 2022 11:20:10 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id d13-20020a17090a3b0d00b00213519dfe4aso11676302pjc.2;
        Mon, 14 Nov 2022 11:20:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZPWs3D/76vIKz8bAxu2rCoaZvjSSlJwTVNgfHpAhTT4=;
        b=qNnu4W+xb31rg0kUgUPs9GlsQPVNjh2HtjMw9yggvLLnSr6FxqNKZvpLfpvpuM0JXI
         43eBvgICAeTv7WNPk0Wag/ew2ILscm+nQUrJ8UKyZ/vSEyKtIQ2R6ypNqlEkU/n49gtj
         I+hD7O3frVCdf3c/tHxxgf9nn3F9b5lYBLVQ3emJrtueXvLGoeOynbtCoX8eMcFp0cia
         PIgKb9kuSbG6CJasI8nvz4czIkPDwSmf7Dh8vql96REUjWAJ1fdDJiJ04hmoDUf2Lmt8
         b1e98z2Fc7Wj1VXAFKjlMf7Vgx2cnoZS0EtNMgEJjbor7ue5YugyzHGgtz3SC3v3/tTI
         1XGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZPWs3D/76vIKz8bAxu2rCoaZvjSSlJwTVNgfHpAhTT4=;
        b=KWy4ur3bLAhz4663eQKUAyh3e6soJ3d+DzeqwkVFScwErQwzGj64uZfA7rL3PxBi/m
         Pp5MTHqdAqa90NP70nCdCoB+YY1z/CS/n8uWZanR2lcGI2VX7MhTCFvsKPudMA+5bz2l
         CKz64C6JTzNsCROD4pWoPPUCOXian36xw4iiGFWsswTyDSdugEsGqNoATbwk19lnCBVV
         BEPE2qD12o0GvgCgDuWUgMfUexLE6j5eRUn7rfyd4jzTrbFR9LBXqx0+KYAYMvHjzpmM
         t0hpwhcSqRq2pWFMk+SicFBRIGELN7Js1mkR6mfKtYX1kaozaApDT6kOG9Vucu5j+8Nn
         +QIw==
X-Gm-Message-State: ANoB5pmla0PMaxXIwaj6wmc7C4NzzI23s/BO9qbzCmAySAb+/FgnpsvI
        3k2uKfQtW73NxvnuLYWHWVj9etonhPA=
X-Google-Smtp-Source: AA0mqf6SoFAMfweIoqSjN/T+2+Hr9p4QgyHXW57Yz+BaE1TqT1yme/iss5Fkp69nxaA7qUzAbslJxg==
X-Received: by 2002:a17:903:264c:b0:188:a51c:b581 with SMTP id je12-20020a170903264c00b00188a51cb581mr672495plb.55.1668453609453;
        Mon, 14 Nov 2022 11:20:09 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id y15-20020a17090322cf00b0018658badef3sm8006881plg.232.2022.11.14.11.20.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 11:20:08 -0800 (PST)
Date:   Mon, 14 Nov 2022 11:20:06 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     syzbot <syzbot+0f89bd13eaceccc0e126@syzkaller.appspotmail.com>
Cc:     casey@schaufler-ca.com, jmorris@namei.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        paul@paul-moore.com, serge@hallyn.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] BUG: unable to handle kernel NULL pointer dereference
 in smack_inode_permission
Message-ID: <Y3KU5kwa2XGS9gyy@hoboy.vegasvil.org>
References: <00000000000061fe2205ed6300fa@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000000000061fe2205ed6300fa@google.com>
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 13, 2022 at 04:05:47PM -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    56751c56c2a2 Merge branch 'for-next/fixes' into for-kernelci
> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
> console output: https://syzkaller.appspot.com/x/log.txt?x=11fc8b0e880000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=606e57fd25c5c6cc
> dashboard link: https://syzkaller.appspot.com/bug?extid=0f89bd13eaceccc0e126
> compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
> userspace arch: arm64
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10a691fa880000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1733c5b9880000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/cf4668c75dea/disk-56751c56.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/e1ef82e91ef7/vmlinux-56751c56.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/3dabe076170f/Image-56751c56.gz.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+0f89bd13eaceccc0e126@syzkaller.appspotmail.com

Why was this email addressed to me?

Thanks,
Richard
