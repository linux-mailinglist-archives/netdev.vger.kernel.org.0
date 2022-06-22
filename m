Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B35A9554F11
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 17:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358901AbiFVPYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 11:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236696AbiFVPYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 11:24:41 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E61AF3915D
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 08:24:40 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id c189so17958706iof.3
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 08:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=0fVCA0pz/WLkVyLNBIdPSpeoAyauWPxpLZPJbNmQOyo=;
        b=r1s/I24OD3avJwOJM5SsgMPe+XybOubVTSup1JMpjmhDTg3XHbLTUJdwlr3jdnYZQg
         tdo3VmV7pt/7RdJ8pPmVnI76iG3n8N2YHdpDy50MfCNlRnG30Dh5lg0Z+hxqa76wbypg
         n6S3a4oJbkH3sz2WDMdYOflp3VefvJfgMCAz7Wqa3rpPwkQWH5zXdf7HDDENr8MEI0yk
         5pS/keF9OV/o/pd1rQCaczOKADV0jqjdlVfGUyjPJ3oBPD9n7Ty31PbqKVs8o/ujH00N
         7PpquHamBJsOCMNb7rnvg+DxDcVJrg9mcMiYTtTxJS5VWjSD0anmjWXzJNveOfrEbzRc
         3phg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0fVCA0pz/WLkVyLNBIdPSpeoAyauWPxpLZPJbNmQOyo=;
        b=Ifud0HbYBYAOWF6ulcrQOQbCV4ukcPBweYaf3oV+4//whO2focBihLW3uL83g1OFxC
         4RvKJ95ahe94AKtIBb9rVk+Ch7C20UWeZCQ0RMUyqx9JPlpJyBiHlgNZfmdBqXgnhIQc
         BBg27wnm2fwBiQpNirXOmtdXO/YyueEmoI8AuLsxpTIbMXLpy1fwR9HfZSVueeLjbNZs
         g6Z9DUnRQRXHBtmg6eA4Vuh86yir5JAu/vcAfh3eRFClWmeVfFX3fpjuMYlh2BKfoDlp
         AvQiaH0G83G9FtglyyIwDTu855+aLUlbZPRyq5YM/YtHCBoGoWnueT8cUJah4txoU+aU
         n+cA==
X-Gm-Message-State: AJIora9MWOY6wUu+DUJQZSRu4ZFRTa9SLgTnuBliMFj7jXth1+6bwyCc
        SqRy9HmSAEOfmqrVYX7JTYYdNQ==
X-Google-Smtp-Source: AGRyM1tRVbDlR3wd4cGCtlpTGOYEQJAxAWwn6repXkykRxCJmHyjbGBAXVlPTKqj42pZj++JDJizVg==
X-Received: by 2002:a05:6638:3490:b0:331:be16:7ab0 with SMTP id t16-20020a056638349000b00331be167ab0mr2466150jal.243.1655911480293;
        Wed, 22 Jun 2022 08:24:40 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id i3-20020a026003000000b00335c432c4b9sm8590255jac.136.2022.06.22.08.24.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jun 2022 08:24:39 -0700 (PDT)
Message-ID: <4d281429-8ac0-c85b-5f8d-3f6fc925d9b7@kernel.dk>
Date:   Wed, 22 Jun 2022 09:24:38 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net] net: clear msg_get_inq in __sys_recvfrom() and
 __copy_msghdr_from_user()
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzbot <syzkaller@googlegroups.com>
References: <20220622150220.1091182-1-edumazet@google.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220622150220.1091182-1-edumazet@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/22/22 9:02 AM, Eric Dumazet wrote:
> syzbot reported uninit-value in tcp_recvmsg() [1]
> 
> Issue here is that msg->msg_get_inq should have been cleared,
> otherwise tcp_recvmsg() might read garbage and perform
> more work than needed, or have undefined behavior.
> 
> Given CONFIG_INIT_STACK_ALL_ZERO=y is probably going to be
> the default soon, I chose to change __sys_recvfrom() to clear
> all fields but msghdr.addr which might be not NULL.
> 
> For __copy_msghdr_from_user(), I added an explicit clear
> of kmsg->msg_get_inq.
> 
> [1]
> BUG: KMSAN: uninit-value in tcp_recvmsg+0x6cf/0xb60 net/ipv4/tcp.c:2557
> tcp_recvmsg+0x6cf/0xb60 net/ipv4/tcp.c:2557
> inet_recvmsg+0x13a/0x5a0 net/ipv4/af_inet.c:850
> sock_recvmsg_nosec net/socket.c:995 [inline]
> sock_recvmsg net/socket.c:1013 [inline]
> __sys_recvfrom+0x696/0x900 net/socket.c:2176
> __do_sys_recvfrom net/socket.c:2194 [inline]
> __se_sys_recvfrom net/socket.c:2190 [inline]
> __x64_sys_recvfrom+0x122/0x1c0 net/socket.c:2190
> do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
> entry_SYSCALL_64_after_hwframe+0x46/0xb0
> 
> Local variable msg created at:
> __sys_recvfrom+0x81/0x900 net/socket.c:2154
> __do_sys_recvfrom net/socket.c:2194 [inline]
> __se_sys_recvfrom net/socket.c:2190 [inline]
> __x64_sys_recvfrom+0x122/0x1c0 net/socket.c:2190
> 
> CPU: 0 PID: 3493 Comm: syz-executor170 Not tainted 5.19.0-rc3-syzkaller-30868-g4b28366af7d9 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Thanks Eric, looks good to me:

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

