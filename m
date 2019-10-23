Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84114E1DC0
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 16:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404300AbfJWOLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 10:11:35 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:40731 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732167AbfJWOLf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 10:11:35 -0400
Received: by mail-io1-f68.google.com with SMTP id p6so16872110iod.7
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 07:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ms4xJUd0YoyuB/IKqDpHAlyQHa/acS6m9rir4YmxrOw=;
        b=bRhmx0T0ovlPciYOaEc5l3aygoNIWUpK6p+OopcegRmQs9jqca2ol2W/QkCGp5b6Ef
         tazdqhVXDDWDahbZ8685aesbuP+oEhJetIirLUu8u+BT7xTIASzuqFk60H/uS+c6Kw7N
         Wswh486+4SJ7RF8v/VBT2LIZCxcMbzZybyplf50IehsBvCGtoo+AuiGJroH42fzAosz9
         5sB8iTLvQ0auObjWtxnCnXRMU3PfdC3VofsFwKoYE9R/WbzB0PeMjMXlel+xmirXm6gj
         0bHE3wzdFTX+W3LgVPGqnuOlikkwsthcTBS5WWplPyvWzlrO0XcIEQqHqWlnjATlbLgw
         2tYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ms4xJUd0YoyuB/IKqDpHAlyQHa/acS6m9rir4YmxrOw=;
        b=V8MOMoHk7FltNX4BFMDy7j776BoRwI/yRUrx2VB1H1iTEcM4//sLpmqaNn98JStPug
         H5T/Vajk5pcevxLNRfLdB0pdhG9p4StfRX+kvgRMEwtVDzZAg6hsAslDbf4+Sx1IgS6f
         DI9xB481fmm5bDXOjmTFmPsx/FZbAnUFrPNWIh3/DBDOOzFy+8wS2WUTjZiBS0RzvW9C
         TV3/qvRtDMipkBb7WTFd55/inFyqgySspZ6/jE8ktEO7Z52pqbESihX70qFCg+KphZMb
         +IKypGpM1XekdEVURp9Da9JXYbxeaAUwW+pGrS3oqewdhdVHhgFGlD5TgD2Z0bVfvNuj
         VESQ==
X-Gm-Message-State: APjAAAVDo8T/x5gBuMC76crCbB/cMl6LIW4xBgCw/aSFtgU1D40flISS
        Nlt2EYcq4swzqrgyTnZW4kSG5jvEEV1/lA==
X-Google-Smtp-Source: APXvYqy3P9pZCyajDkOFnT7a7dJLo3Bro5PeZIlLjcn+zegPQHMAfLuBH7vjSPH1p2LPuQBHPznBUw==
X-Received: by 2002:a5e:9807:: with SMTP id s7mr1158946ioj.215.1571839891865;
        Wed, 23 Oct 2019 07:11:31 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id c17sm8651919ild.31.2019.10.23.07.11.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Oct 2019 07:11:30 -0700 (PDT)
Subject: Re: [PATCH 1/3] io_uring: add support for async work inheriting files
 table
To:     Wolfgang Bumiller <w.bumiller@proxmox.com>
Cc:     linux-block@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
References: <20191017212858.13230-1-axboe@kernel.dk>
 <20191017212858.13230-2-axboe@kernel.dk>
 <20191023120446.75oxdwom34nhe3l5@olga.proxmox.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3b97233b-5d05-5efc-4173-e3a1ef177cbc@kernel.dk>
Date:   Wed, 23 Oct 2019 08:11:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191023120446.75oxdwom34nhe3l5@olga.proxmox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/23/19 6:04 AM, Wolfgang Bumiller wrote:
> On Thu, Oct 17, 2019 at 03:28:56PM -0600, Jens Axboe wrote:
>> This is in preparation for adding opcodes that need to modify files
>> in a process file table, either adding new ones or closing old ones.
>>
>> If an opcode needs this, it must set REQ_F_NEED_FILES in the request
>> structure. If work that needs to get punted to async context have this
>> set, they will grab a reference to the process file table. When the
>> work is completed, the reference is dropped again.
> 
> I think IORING_OP_SENDMSG and _RECVMSG need to set this flag due to
> SCM_RIGHTS control messages.
> Thought I'd reply here since I just now ran into the issue that I was
> getting ever-increasing wrong file descriptor numbers on pretty much
> ever "other" async recvmsg() call I did via io-uring while receiving
> file descriptors from lxc for the seccomp-notify proxy. (I'm currently
> running an ubuntu based 5.3.1 kernel)
> I ended up finding them in /proc - they show up in all kernel threads,
> eg.:
> 
> root:/root # grep Name /proc/9/status
> Name:   mm_percpu_wq
> root:/root # ls -l /proc/9/fd
> total 0
> lr-x------ 1 root root 64 Oct 23 12:00 0 -> '/proc/512 (deleted)'
> lrwx------ 1 root root 64 Oct 23 12:00 1 -> /proc/512/mem
> lr-x------ 1 root root 64 Oct 23 12:00 10 -> '/proc/11782 (deleted)'
> lrwx------ 1 root root 64 Oct 23 12:00 11 -> /proc/11782/mem
> lr-x------ 1 root root 64 Oct 23 12:00 12 -> '/proc/12210 (deleted)'
> lrwx------ 1 root root 64 Oct 23 12:00 13 -> /proc/12210/mem
> lr-x------ 1 root root 64 Oct 23 12:00 14 -> '/proc/12298 (deleted)'
> lrwx------ 1 root root 64 Oct 23 12:00 15 -> /proc/12298/mem
> lr-x------ 1 root root 64 Oct 23 12:00 16 -> '/proc/13955 (deleted)'
> lrwx------ 1 root root 64 Oct 23 12:00 17 -> /proc/13955/mem
> lr-x------ 1 root root 64 Oct 23 12:00 18 -> '/proc/13989 (deleted)'
> lrwx------ 1 root root 64 Oct 23 12:00 19 -> /proc/13989/mem
> lr-x------ 1 root root 64 Oct 23 12:00 2 -> '/proc/584 (deleted)'
> lr-x------ 1 root root 64 Oct 23 12:00 20 -> '/proc/15502 (deleted)'
> lrwx------ 1 root root 64 Oct 23 12:00 21 -> /proc/15502/mem
> lr-x------ 1 root root 64 Oct 23 12:00 22 -> '/proc/15510 (deleted)'
> lrwx------ 1 root root 64 Oct 23 12:00 23 -> /proc/15510/mem
> lr-x------ 1 root root 64 Oct 23 12:00 24 -> '/proc/17833 (deleted)'
> lrwx------ 1 root root 64 Oct 23 12:00 25 -> /proc/17833/mem
> lr-x------ 1 root root 64 Oct 23 12:00 26 -> '/proc/17836 (deleted)'
> lrwx------ 1 root root 64 Oct 23 12:00 27 -> /proc/17836/mem
> lr-x------ 1 root root 64 Oct 23 12:00 28 -> '/proc/21929 (deleted)'
> lrwx------ 1 root root 64 Oct 23 12:00 29 -> /proc/21929/mem
> lrwx------ 1 root root 64 Oct 23 12:00 3 -> /proc/584/mem
> lr-x------ 1 root root 64 Oct 23 12:00 30 -> '/proc/22214 (deleted)'
> lrwx------ 1 root root 64 Oct 23 12:00 31 -> /proc/22214/mem
> lr-x------ 1 root root 64 Oct 23 12:00 32 -> '/proc/22283 (deleted)'
> lrwx------ 1 root root 64 Oct 23 12:00 33 -> /proc/22283/mem
> lr-x------ 1 root root 64 Oct 23 12:00 34 -> '/proc/29795 (deleted)'
> lrwx------ 1 root root 64 Oct 23 12:00 35 -> /proc/29795/mem
> lr-x------ 1 root root 64 Oct 23 12:00 36 -> '/proc/30124 (deleted)'
> lrwx------ 1 root root 64 Oct 23 12:00 37 -> /proc/30124/mem
> lr-x------ 1 root root 64 Oct 23 12:00 38 -> '/proc/31016 (deleted)'
> lrwx------ 1 root root 64 Oct 23 12:00 39 -> /proc/31016/mem
> lr-x------ 1 root root 64 Oct 23 12:00 4 -> '/proc/1632 (deleted)'
> lr-x------ 1 root root 64 Oct 23 12:00 40 -> '/proc/4137 (deleted)'
> lrwx------ 1 root root 64 Oct 23 12:00 41 -> /proc/4137/mem
> lrwx------ 1 root root 64 Oct 23 12:00 5 -> /proc/1632/mem
> lr-x------ 1 root root 64 Oct 23 12:00 6 -> '/proc/3655 (deleted)'
> lrwx------ 1 root root 64 Oct 23 12:00 7 -> /proc/3655/mem
> lr-x------ 1 root root 64 Oct 23 12:00 8 -> '/proc/7075 (deleted)'
> lrwx------ 1 root root 64 Oct 23 12:00 9 -> /proc/7075/mem
> root:/root #
> 
> Those are the fds I expected to receive, and I get fd numbers
> consistently increasing with them.
> lxc sends the syscall-executing process' pidfd and its 'mem' fd via a
> socket, but instead of making it to the receiver, they end up there...
> 
> I suspect that an async sendmsg() call could potentially end up
> accessing those instead of the ones from the sender process, but I
> haven't tested it...

Might "just" be a case of the sendmsg() being stuck, we can't currently
cancel work. So if they never complete, the ring won't go away.

Actually working on a small workqueue replacement for io_uring which
allow us to cancel things like that. It's a requirement for accept() as
well, but also for basic read/write send/recv on sockets. So used to
storage IO operations that complete in a finite amount of time...

But yes, I hope with that, and the flush trick that Jann suggested, that
we can make this 100% reliable for any type of operation.

-- 
Jens Axboe

