Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A82CE149BFD
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 18:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgAZRKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 12:10:24 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37170 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbgAZRKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 12:10:24 -0500
Received: by mail-pg1-f193.google.com with SMTP id q127so3956450pga.4
        for <netdev@vger.kernel.org>; Sun, 26 Jan 2020 09:10:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ISotJI3izVmXl3fjfB5uTrAYmwdgYfTOknESvfHgtZk=;
        b=N8yflsFSMo7z3TohnJaUL9dTQK5ay/N2VmQ0cVC2L7uONXQVzN+hmbOTVywede6zNY
         ZMD6X5Ibh0fD4PTewZdSnz7d14c0IgLWlieRNDowPssmahpv2H/Cb4q+YAwJxjQv9Qdp
         w5UN134ifB0I5pKbdveIYAuMJmwQh+eEqNSE2IPwtieN+lKQm14zneSQwH7fOUHTNHvr
         gAOpToN/GVumKmK0euYBifaZPS3y718ISGXiGDIDIQn0dQSxmJz4c7pzbioJ8zp/+T0L
         nDlDrwsTqKRQO/g1U5+LL7MbQ3TPgyTpUE+XSfwRMbfDL+d5CAA26B8+zL6Z6SvkyobK
         u/AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ISotJI3izVmXl3fjfB5uTrAYmwdgYfTOknESvfHgtZk=;
        b=JX43gkSaC5m+qol1+V2gVYAuKgzVbjVUua8wFbGzd9ga4V7t6O046yu4t/px1w5YwU
         JDfjOlsNFZHuY1mwm8dEtICcZ1VQRe30HtaZY361xrgkPrR/oF43ZUB/SMKeV/gDydxt
         5eBhjteN+7YvYZG8TkptQixLVhcGGSG5SCbnoKM8yGZDlg1dET9mcuTxvPT9AJA/L7pA
         cWRTJWRGOIlNB1UwRQvBKYmdY+s6KpSpNERiR/l+Z8zSC2AqV2IU5IhpPduhbwB3YKT7
         IaAxacns+d99sDYdQUINHRUinsMVnWaRzepju4zXKdUue1LYONjr/g8c5TmsodQsaaYX
         Zu3g==
X-Gm-Message-State: APjAAAVhiQcJtcqKTCdh/Wt/MCn1/WnPIkvxZuwQqGxwmxgaD/lly0un
        y6soAqyfUfx5DJtRy1iNPvIQfbKihK4=
X-Google-Smtp-Source: APXvYqym3vadWUhjWT7Te3HkaNqzI77r+VUVo4DIV3gy9ebln2NudM/oNPXUBmetPULNnbzrzAJowA==
X-Received: by 2002:a63:211f:: with SMTP id h31mr14427070pgh.299.1580058623198;
        Sun, 26 Jan 2020 09:10:23 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id 11sm13232933pfz.25.2020.01.26.09.10.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jan 2020 09:10:22 -0800 (PST)
Subject: Re: [PATCH 2/4] io_uring: io_uring: add support for async work
 inheriting files
To:     Andres Freund <andres@anarazel.de>
Cc:     linux-block@vger.kernel.org, io-uring <io-uring@vger.kernel.org>,
        davem@davemloft.net, netdev@vger.kernel.org, jannh@google.com
References: <20191025173037.13486-1-axboe@kernel.dk>
 <20191025173037.13486-3-axboe@kernel.dk>
 <20200126101207.oqovstqfr4iddc3p@alap3.anarazel.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1f9a5869-845a-f7ca-7530-49e407602023@kernel.dk>
Date:   Sun, 26 Jan 2020 10:10:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200126101207.oqovstqfr4iddc3p@alap3.anarazel.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/26/20 3:12 AM, Andres Freund wrote:
> Hi,
> 
> On 2019-10-25 11:30:35 -0600, Jens Axboe wrote:
>> This is in preparation for adding opcodes that need to add new files
>> in a process file table, system calls like open(2) or accept4(2).
>>
>> If an opcode needs this, it must set IO_WQ_WORK_NEEDS_FILES in the work
>> item. If work that needs to get punted to async context have this
>> set, the async worker will assume the original task file table before
>> executing the work.
>>
>> Note that opcodes that need access to the current files of an
>> application cannot be done through IORING_SETUP_SQPOLL.
> 
> 
> Unfortunately this partially breaks sharing a uring across with forked
> off processes, even though it initially appears to work:
> 
> 
>> +static int io_uring_flush(struct file *file, void *data)
>> +{
>> +	struct io_ring_ctx *ctx = file->private_data;
>> +
>> +	io_uring_cancel_files(ctx, data);
>> +	if (fatal_signal_pending(current) || (current->flags & PF_EXITING))
>> +		io_wq_cancel_all(ctx->io_wq);
>> +	return 0;
>> +}
> 
> Once one process having the uring fd open (even if it were just a fork
> never touching the uring, I believe) exits, this prevents the uring from
> being usable for any async tasks. The process exiting closes the fd,
> which triggers flush. io_wq_cancel_all() sets IO_WQ_BIT_CANCEL, which
> never gets unset, which causes all future async sqes to be be
> immediately returned as -ECANCELLED by the worker, via io_req_cancelled.
> 
> It's not clear to me why a close() should cancel the the wq (nor clear
> the entire backlog, after 1d7bb1d50fb4)? Couldn't that even just be a
> dup()ed fd? Or a fork that immediately exec()s?
> 
> After rudely ifdefing out the above if, and reverting 44d282796f81, my
> WIP io_uring using version of postgres appears to pass its tests - which
> are very sparse at this point - again with 5.5-rc7.

We need to cancel work items using the files from this process if it
exits, but I think we should be fine not canceling all work. Especially
since thet setting of IO_WQ_BIT_CANCEL is a one way street...  I'm assuming
the below works for you?

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e5b502091804..e3ac2a6ff195 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5044,10 +5044,8 @@ static int io_uring_flush(struct file *file, void *data)
 	struct io_ring_ctx *ctx = file->private_data;
 
 	io_uring_cancel_files(ctx, data);
-	if (fatal_signal_pending(current) || (current->flags & PF_EXITING)) {
+	if (fatal_signal_pending(current) || (current->flags & PF_EXITING))
 		io_cqring_overflow_flush(ctx, true);
-		io_wq_cancel_all(ctx->io_wq);
-	}
 	return 0;
 }
 
-- 
Jens Axboe

