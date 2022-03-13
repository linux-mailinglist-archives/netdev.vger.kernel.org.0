Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0C3D4D776B
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 18:58:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235241AbiCMR7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 13:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235245AbiCMR7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 13:59:15 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA42A25EA0;
        Sun, 13 Mar 2022 10:58:05 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id b28so11670359lfc.4;
        Sun, 13 Mar 2022 10:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=rS9E+l0t1qeR/q2Nej9jwr575vUVg/ygf4pM8R2kiL8=;
        b=b3LIAWv8MZtR31aLx2W8cpmAyGNVI1VP6ckHdlGTXUpQ1fKdi0uSs7VHElRTy0VKl0
         cOFQQVMiWf4U3FMcUrL50hrsqKqUoCz1MEkZBrvhrHgHHk+zx1VaLXsQ/Uhy6zerLeKN
         7JggvH+N+bB8T+a1H1lMvez+VctNRwmHVGkVNyj/nWon56psS0pAykz4JZxP1Mo8/qAU
         GtUNqUVLAUEI3UFGuBxkyDrCATjVp6Puy8ciO6uMqNGLE+gI89L/NaCgabz8IH0tM7PX
         tFrFxjTPNymX0tWu4KfEWpGFr8K+Cug6tMYVOESPp+OAYT7bJE9QHoyMEEKWGhQy8iA3
         Eheg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rS9E+l0t1qeR/q2Nej9jwr575vUVg/ygf4pM8R2kiL8=;
        b=7Fh/cwemaLfQ4ANNF7p7J/6J6I+i33PB/o2FdKtxNrwY2KeNEwDOwSpw8BiD0l4mnS
         ejiF9cx3fs5hWMMfXtlaABuzdWpKEa+jiFPrp0qbC5fljWBn3+JeiRlPj0ElY0vhV/18
         S7ceJCphrMK4msSNquTsXxtIFdE7cYwlMUAWJPuvInY1U8Eo9F3Ey40wch2Aepr+GbyR
         /7rj+bphf+U6g2QoQGegRbvYY/pjPlD6tFPPTTlBbfiwcloXll2US/Os7JonuuQL+gKL
         3qpnAwrAxiwuT7Ou7HoSATuzLkwh+wtpg4GxUa0fO42ctfDEw0oHM63vNjdn7Ox+i1LO
         iEMg==
X-Gm-Message-State: AOAM530WhJBxP4v9KohJxHoylfV303YBQEijyrJzmfSnb6EMG070ZqaX
        ED8sAG+No/66re87HVqjwYk=
X-Google-Smtp-Source: ABdhPJxb0HLjVZOVRwe2MlV2I025fTveSXJ+KOnQNM83lrVa7y4d5E5nRZQkUEozn1cUVElkGLQEMg==
X-Received: by 2002:a05:6512:3e19:b0:448:23de:5b18 with SMTP id i25-20020a0565123e1900b0044823de5b18mr12012632lfv.554.1647194284133;
        Sun, 13 Mar 2022 10:58:04 -0700 (PDT)
Received: from [192.168.1.11] ([94.103.229.107])
        by smtp.gmail.com with ESMTPSA id k11-20020ac2456b000000b004482043aac1sm2815737lfm.263.2022.03.13.10.58.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Mar 2022 10:58:03 -0700 (PDT)
Message-ID: <d979796e-d991-4ffd-7668-d1f7baee3f51@gmail.com>
Date:   Sun, 13 Mar 2022 20:58:02 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [syzbot] KMSAN: uninit-value in asix_mdio_read (3)
Content-Language: en-US
To:     syzbot <syzbot+9ed16c369e0f40e366b2@syzkaller.appspotmail.com>,
        andrew@lunn.ch, davem@davemloft.net, glider@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux@rempel-privat.de,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000176d6705da1d4bd3@google.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <000000000000176d6705da1d4bd3@google.com>
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

On 3/13/22 20:57, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch and the reproducer did not trigger any issue:
> 
> Reported-and-tested-by: syzbot+9ed16c369e0f40e366b2@syzkaller.appspotmail.com
> 
> Tested on:
> 
> commit:         72494641 x86: kmsan: enable KMSAN builds for x86
> git tree:       https://github.com/google/kmsan.git master
> kernel config:  https://syzkaller.appspot.com/x/.config?x=28718f555f258365
> dashboard link: https://syzkaller.appspot.com/bug?extid=9ed16c369e0f40e366b2
> compiler:       clang version 14.0.0 (/usr/local/google/src/llvm-git-monorepo 2b554920f11c8b763cd9ed9003f4e19b919b8e1f), GNU ld (GNU Binutils for Debian) 2.35.2
> patch:          https://syzkaller.appspot.com/x/patch.diff?x=11ccaa41700000
> 
> Note: testing is done by a robot and is best-effort only.

#syz fix: net: asix: add proper error handling of usb read errors




With regards,
Pavel Skripkin
