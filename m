Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9718E4C10E3
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 12:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239734AbiBWLCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 06:02:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231893AbiBWLCJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 06:02:09 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89F6D4ECFA;
        Wed, 23 Feb 2022 03:01:41 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id f37so30271641lfv.8;
        Wed, 23 Feb 2022 03:01:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=+6HvF8y2PGVk9Cp71pan23gGDAsMn7xOJMniykYsMVA=;
        b=Qvth+Tj2xbGcQg4RffH5sEinkDzGrnbW9pCaQa4jWglF4sdA4hPhKi7DtMWo57bgz8
         9hFCJB69KFDdvjE8q/jhOqIuPt8Th5XTsWhwPqqPRMDcLs98NQsUXMNPzD2OZqqlx6Po
         U+77Svrcs72qGs9zUJuQJZxhS2CU8QiXS/7ZsXp0elymrRt8KF+Kf664r+2BfJDnfr6+
         +lKfkyMyz33U4PT5Gu63ihQB3tcw58x10rFH5YaF5XSh12vnKAy4CNdLaRlqR5NNFOxq
         7Zj3GVDOk4XiVsjO4MMSAgkj3lntscPlMCh/+M9plcJqKpPtmVhPKjYPDpDmlh8wQo9x
         4GPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+6HvF8y2PGVk9Cp71pan23gGDAsMn7xOJMniykYsMVA=;
        b=GnzF6MtIIPvjTBQZrGIvq8Aglsf1ImSpeLBHOxbFayflMlJThkUNQ7zQKdzBFdWRre
         uTjazrZEFVgqEzmaUrkbEJRrwVdVrja77DqALCIzxQiiIfw4VMu2eRLy/u8seHmCzFj+
         z/sgp6eP6dhwZ/Fkb2oyGk6HTk7AlpemuiDs/pNstYnURUp4h05TJpDKWxinBBZ+1Yof
         WVvuSNLP3SrL8brVO8No+bPxPxASzl9a6oQ9EgzWyjduHygT0uvb3BXtahryNau9pW0h
         wzvtr78b+O/X45reluSs72L8jdGRuhegvA67hVxNiXwR4xlRIQAbn8QDFLzBsMnlEJQm
         PVAQ==
X-Gm-Message-State: AOAM530KPiGqJTImD+2STVXxYzRqxSKSEusK5ZeH/4BSaL8ZYeiRpw5T
        cSseoyOPwhYTcUpsu46h4UE=
X-Google-Smtp-Source: ABdhPJyYPQd0BZZ7UK2cpCj+4TmBKQFxMfhKv4evp6r/guXztVb/QWuz3VsvagLyRfYJF3mMCyZGkg==
X-Received: by 2002:ac2:522d:0:b0:43e:64b4:639c with SMTP id i13-20020ac2522d000000b0043e64b4639cmr19377732lfl.272.1645614099700;
        Wed, 23 Feb 2022 03:01:39 -0800 (PST)
Received: from [192.168.1.11] ([94.103.229.64])
        by smtp.gmail.com with ESMTPSA id o19sm1619357lfl.259.2022.02.23.03.01.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Feb 2022 03:01:39 -0800 (PST)
Message-ID: <2c775ec8-6fcb-cdeb-9b7c-35822c74bbde@gmail.com>
Date:   Wed, 23 Feb 2022 14:01:33 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [syzbot] KMSAN: uninit-value in asix_check_host_enable
Content-Language: en-US
To:     syzbot <syzbot+8f5f07bb9d6935e2f8d9@syzkaller.appspotmail.com>,
        andrew@lunn.ch, davem@davemloft.net, glider@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux@rempel-privat.de,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <00000000000024a1f805d8ac1da3@google.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <00000000000024a1f805d8ac1da3@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/23/22 12:30, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    724946410067 x86: kmsan: enable KMSAN builds for x86
> git tree:       https://github.com/google/kmsan.git master
> console output: https://syzkaller.appspot.com/x/log.txt?x=11c85246700000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=76f99026248b24e4
> dashboard link: https://syzkaller.appspot.com/bug?extid=8f5f07bb9d6935e2f8d9
> compiler:       clang version 14.0.0 (/usr/local/google/src/llvm-git-monorepo 2b554920f11c8b763cd9ed9003f4e19b919b8e1f), GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11674fe2700000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1497324c700000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+8f5f07bb9d6935e2f8d9@syzkaller.appspotmail.com
> 

Should be fixed by [1], but it's only in next for now.

[1] 
https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=920a9fa27e7805499cfe78491b36fed2322c02ec




With regards,
Pavel Skripkin
