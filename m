Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 447FA3EC2BA
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 14:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238457AbhHNMv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 08:51:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233664AbhHNMvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 08:51:25 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63006C061764;
        Sat, 14 Aug 2021 05:50:57 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id k4so8572927wms.3;
        Sat, 14 Aug 2021 05:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=soZxiF/fS/bDbNIY5Pv+IiDOKKvkkGO1ADByBRpWDy8=;
        b=HcJ7wj/lPNp3DOnCJLsFHUL9NnsHMAlUw11LCm/YBqGHkMN1ZPhNy7j10qcaFXFYwY
         acM1IXXv9ynptXepwBRH93Nwvs5//OEvrtnTcR6lPlCpTSbaoZ0Fsq/H5U9QGDq+VMFl
         aHTdPvSYn3lsvzy8Z0r9ET3txH0zBZ1dpjlcvnK2O4MnCXEfK4qBfLGxfz8eux0Zddhu
         QvaYX0HLGDq1Ui2Lo8akYKl31hwuGDJbbrAZVRJfongyhSSciXbfvdBI9ZJzYAq9O4IA
         7kSOqHm4uWfrp7sJgb/83Kua3vCyJGh5ZXc4WADqtOt7vwFtCtQKSC4WFeR6iAVDtqJM
         IsSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=soZxiF/fS/bDbNIY5Pv+IiDOKKvkkGO1ADByBRpWDy8=;
        b=atrVQivpBpdhqCesxY6DdTgC70Mkx96H0ltnrha9S7CWmb6AqB0YKnwJEzXPz8vCf6
         /dQIj/4a/yPQgX6qg3tQ5CjB5f4yjqhTbczR/7KUo+5akcN6T/kR2Cx2/+mj7Akd9zn0
         6H9URTRgl27/EtfXLWlPXXkWsQEKnc1HcOx/TwahSVVS8fvXTdhynIP7s93P6L7nwLw1
         Kjjapm7ziJrvzgQa3F3BhaPIfu+j81eXjnU3EblsGSlVmd8gL2Ko6UoWkUY3JN5MuHw7
         C17SIVzHGPhVtDZR9qq0dK1roTxkhLpfr584KV9yfDVfC/95ji39J5TyepQBIrisiDKl
         phfg==
X-Gm-Message-State: AOAM532QSKlIK1ot2LmXNTl3iOVArHzzo5iqMIfwzC/IMTJuF7ytxMtM
        JIlgILa+4bo5PWQMpN1qkFs=
X-Google-Smtp-Source: ABdhPJydnkBamMX2SjiEWQZK3lfNfaRkXU+iudNL9RKS/t2j5+yfZJC5sGrwEPyIl0vsFOm/dAqVXw==
X-Received: by 2002:a7b:cd10:: with SMTP id f16mr6957016wmj.104.1628945456055;
        Sat, 14 Aug 2021 05:50:56 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.133.97])
        by smtp.gmail.com with ESMTPSA id u23sm4223047wmc.24.2021.08.14.05.50.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Aug 2021 05:50:55 -0700 (PDT)
To:     Josh Triplett <josh@joshtriplett.org>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Stefan Metzmacher <metze@samba.org>
References: <cover.1628871893.git.asml.silence@gmail.com>
 <YRbBYCn29B+kgZcy@localhost>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH v2 0/4] open/accept directly into io_uring fixed file
 table
Message-ID: <bcb6f253-41d6-6e0f-5b4b-ea1e02a105bc@gmail.com>
Date:   Sat, 14 Aug 2021 13:50:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YRbBYCn29B+kgZcy@localhost>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/13/21 8:00 PM, Josh Triplett wrote:
> On Fri, Aug 13, 2021 at 05:43:09PM +0100, Pavel Begunkov wrote:
>> Add an optional feature to open/accept directly into io_uring's fixed
>> file table bypassing the normal file table. Same behaviour if as the
>> snippet below, but in one operation:
>>
>> sqe = prep_[open,accept](...);
>> cqe = submit_and_wait(sqe);
>> // error handling
>> io_uring_register_files_update(uring_idx, (fd = cqe->res));
>> // optionally
>> close((fd = cqe->res));
>>
>> The idea in pretty old, and was brough up and implemented a year ago
>> by Josh Triplett, though haven't sought the light for some reasons.
> 
> Thank you for working to get this over the finish line!
> 
>> Tested on basic cases, will be sent out as liburing patches later.
>>
>> A copy paste from 2/2 describing user API and some notes:
>>
>> The behaviour is controlled by setting sqe->file_index, where 0 implies
>> the old behaviour. If non-zero value is specified, then it will behave
>> as described and place the file into a fixed file slot
>> sqe->file_index - 1. A file table should be already created, the slot
>> should be valid and empty, otherwise the operation will fail.
>>
>> Note 1: we can't use IOSQE_FIXED_FILE to switch between modes, because
>> accept takes a file, and it already uses the flag with a different
>> meaning.
>>
>> Note 2: it's u16, where in theory the limit for fixed file tables might
>> get increased in the future. If would ever happen so, we'll better
>> workaround later, e.g. by making ioprio to represent upper bits 16 bits.
>> The layout for open is tight already enough.
> 
> Rather than using sqe->file_index - 1, which feels like an error-prone
> interface, I think it makes sense to use a dedicated flag for this, like
> IOSQE_OPEN_FIXED. That flag could work for any open-like operation,
> including open, accept, and in the future many other operations such as
> memfd_create. (Imagine using a single ring submission to open a memfd,
> write a buffer into it, seal it, send it over a UNIX socket, and then
> close it.)
> 
> The only downside is that you'll need to reject that flag in all
> non-open operations. One way to unify that code might be to add a flag
> in io_op_def for open-like operations, and then check in common code for
> the case of non-open-like operations passing IOSQE_OPEN_FIXED.

io_uring is really thin, and so I absolutely don't want any extra
overhead in the generic path, IOW anything affecting
reads/writes/sends/recvs.

The other reason is that there are only 2 bits left in sqe->flags,
and we may use them for something better, considering that it's
only open/accept and not much as this.

I agree that it feels error-prone, but at least it can be wrapped
nicely enough in liburing, e.g.

void io_uring_prep_openat_direct(struct io_uring_sqe *sqe, int dfd,
				 const char *path, int flags,
				 mode_t mode, int slot_idx);


> Also, rather than using a 16-bit index for the fixed file table and
> potentially requiring expansion into a different field in the future,
> what about overlapping it with the nofile field in the open and accept
> requests? If they're not opening a normal file descriptor, they don't
> need nofile. And in the original sqe, you can then overlap it with a
> 32-bit field like splice_fd_in.

There is no nofile in SQEs, though

req->open.nofile = rlimit(RLIMIT_NOFILE);
 
> EEXIST seems like the wrong error-code to use if the index is already in
> use; open can already return EEXIST if you pass O_EXCL. How about EBADF,
> or better yet EBADSLT which is unlikely to be returned for any other
> reason?

Sure, sounds better indeed!

-- 
Pavel Begunkov
