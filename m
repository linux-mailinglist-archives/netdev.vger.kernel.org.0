Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3925149C0E
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 18:17:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbgAZRRF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 12:17:05 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:38149 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbgAZRRE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 12:17:04 -0500
Received: by mail-pl1-f195.google.com with SMTP id t6so2893602plj.5
        for <netdev@vger.kernel.org>; Sun, 26 Jan 2020 09:17:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sNV793+0cycsAhcHF8cv23AfCjhutUJI8XZukCzTbCU=;
        b=FVvWfp/tztsdAQcRG5Rci1crrbXT9URtlcwg6BhUmCDHI+CavYwe6NHJ9YM+MznIfl
         /XIh0QRjO+cbnuSns6vKfAVEDox0PQfiv39oXoObL2MfiPpTM6CPOuRCOsFRC9UEVRvq
         trJi7lec3gmRIEB+p61X6QvoI0T+C5A/nkBh0lIOBt6eZl7NCshifRrgA2eNKwPJP14e
         ulyZcaUJWVhhdlnGN/znFtqvF8FPsTOxbb8I14rOP94PexGv6Lvf6GSoiAHGCCLcFipc
         Ak2UeHO2QQUYuJL3yQqiymuQFb+4oobskgEvI8Il7b8or2XmJrFAwnWN0bLwAKaiqWfg
         31Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sNV793+0cycsAhcHF8cv23AfCjhutUJI8XZukCzTbCU=;
        b=IwXuBstSJIc3d6PYkgISO6SmFS5VCZhhtHRcKamEKA2M7xC1Wj/6wGw9DbMx9Y78g3
         BvBG4Y1kX6rwFBHicRcjhOIYJRwZR/t5DCFi3QrT08b8zcWHAmxl5kYrQqPLNUOvQA1P
         f90LIAREe8eP7A8s0QGtEERS4waLZ4hJWDQTw4n2riHyaUycXjZwjj6P+juu37bDxbTi
         k40cSETl2H/MPSIM+4HqmeVyVAU0Z7wx4s8CIenPp7udO9J4xfbqYL1xLMinJ3F9v9z7
         4cIh66O2HxrKKkw562O1TJkimfavpUARTmjr6DsSUlPSLGgkWjjvqH+HTld3xcFNFcXx
         3/wA==
X-Gm-Message-State: APjAAAUolz8g9FWpJeC43oFooFIy/4dmvye0r7+pygUSG+DRapc+VpaL
        7Sit2xIatygvQfY2FP31BkLZuw==
X-Google-Smtp-Source: APXvYqy9zSy9tuxtT+VumjEcIX7MmU599ZVrh6QD7SfB4UlILYyVD2HalIFSX4f3cwZ8f+FBpkvF9A==
X-Received: by 2002:a17:90a:a10c:: with SMTP id s12mr10139586pjp.47.1580059022601;
        Sun, 26 Jan 2020 09:17:02 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id m22sm13634498pgn.8.2020.01.26.09.17.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jan 2020 09:17:02 -0800 (PST)
Subject: Re: [PATCH 2/4] io_uring: io_uring: add support for async work
 inheriting files
From:   Jens Axboe <axboe@kernel.dk>
To:     Andres Freund <andres@anarazel.de>
Cc:     linux-block@vger.kernel.org, io-uring <io-uring@vger.kernel.org>,
        davem@davemloft.net, netdev@vger.kernel.org, jannh@google.com
References: <20191025173037.13486-1-axboe@kernel.dk>
 <20191025173037.13486-3-axboe@kernel.dk>
 <20200126101207.oqovstqfr4iddc3p@alap3.anarazel.de>
 <1f9a5869-845a-f7ca-7530-49e407602023@kernel.dk>
Message-ID: <e9e79b75-9e0f-1a36-5618-e8d27e995cc1@kernel.dk>
Date:   Sun, 26 Jan 2020 10:17:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <1f9a5869-845a-f7ca-7530-49e407602023@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/26/20 10:10 AM, Jens Axboe wrote:
> On 1/26/20 3:12 AM, Andres Freund wrote:
>> Hi,
>>
>> On 2019-10-25 11:30:35 -0600, Jens Axboe wrote:
>>> This is in preparation for adding opcodes that need to add new files
>>> in a process file table, system calls like open(2) or accept4(2).
>>>
>>> If an opcode needs this, it must set IO_WQ_WORK_NEEDS_FILES in the work
>>> item. If work that needs to get punted to async context have this
>>> set, the async worker will assume the original task file table before
>>> executing the work.
>>>
>>> Note that opcodes that need access to the current files of an
>>> application cannot be done through IORING_SETUP_SQPOLL.
>>
>>
>> Unfortunately this partially breaks sharing a uring across with forked
>> off processes, even though it initially appears to work:
>>
>>
>>> +static int io_uring_flush(struct file *file, void *data)
>>> +{
>>> +	struct io_ring_ctx *ctx = file->private_data;
>>> +
>>> +	io_uring_cancel_files(ctx, data);
>>> +	if (fatal_signal_pending(current) || (current->flags & PF_EXITING))
>>> +		io_wq_cancel_all(ctx->io_wq);
>>> +	return 0;
>>> +}
>>
>> Once one process having the uring fd open (even if it were just a fork
>> never touching the uring, I believe) exits, this prevents the uring from
>> being usable for any async tasks. The process exiting closes the fd,
>> which triggers flush. io_wq_cancel_all() sets IO_WQ_BIT_CANCEL, which
>> never gets unset, which causes all future async sqes to be be
>> immediately returned as -ECANCELLED by the worker, via io_req_cancelled.
>>
>> It's not clear to me why a close() should cancel the the wq (nor clear
>> the entire backlog, after 1d7bb1d50fb4)? Couldn't that even just be a
>> dup()ed fd? Or a fork that immediately exec()s?
>>
>> After rudely ifdefing out the above if, and reverting 44d282796f81, my
>> WIP io_uring using version of postgres appears to pass its tests - which
>> are very sparse at this point - again with 5.5-rc7.
> 
> We need to cancel work items using the files from this process if it
> exits, but I think we should be fine not canceling all work. Especially
> since thet setting of IO_WQ_BIT_CANCEL is a one way street...  I'm assuming
> the below works for you?

Could be even simpler, for shared ring setup, it also doesn't make any sense
to flush the cq ring on exit.

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e5b502091804..e54556b0fcc6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5044,10 +5044,6 @@ static int io_uring_flush(struct file *file, void *data)
 	struct io_ring_ctx *ctx = file->private_data;
 
 	io_uring_cancel_files(ctx, data);
-	if (fatal_signal_pending(current) || (current->flags & PF_EXITING)) {
-		io_cqring_overflow_flush(ctx, true);
-		io_wq_cancel_all(ctx->io_wq);
-	}
 	return 0;
 }
 

-- 
Jens Axboe

