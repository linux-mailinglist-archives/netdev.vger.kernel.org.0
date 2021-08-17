Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1993B3EE9F7
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 11:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235649AbhHQJeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 05:34:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235005AbhHQJeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 05:34:09 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29DD8C061764;
        Tue, 17 Aug 2021 02:33:36 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id w21-20020a7bc1150000b02902e69ba66ce6so1689418wmi.1;
        Tue, 17 Aug 2021 02:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iRnPw75pIfAeUsFqijtuEEG0yjtu25CSmo0vBZOgYeg=;
        b=sFOaC6ZrYaUezaiuEOmtghXAaz36dJduJ+84EIUbJoJtIWqifZUNK8fzk/vqjkzBq0
         1sq4nEVCPo3X7y6aQADD3WnPRRX+syU9JMXY/Azi3ZMfw2wi02mDcfUSryiN+FPc3CKT
         Q7zWShFzESyI6Mrsxz898qAtYA2VgdnnODSMyx4TkgYwPj+AiStTEw9p+zHRm/oCbrfP
         n6UyoVGID22cBgx7XDGArr3JKuygYVfp/4r3PgAzTbsRNydacJqmJmwL7MpwRhLHtHjF
         6Ul92p/LlK7pCs/ZQq+67XrkEmHmvhAgyRoSUia6GV6qH0zEZJQ0PJJmBCG/wXcy+AA3
         OREw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iRnPw75pIfAeUsFqijtuEEG0yjtu25CSmo0vBZOgYeg=;
        b=Er/OGikEDTE2sCZ91Mw/YajdLJ1/eEB7JgLLbyqj56Mm5RAvNSeNZblDJvWk+0ZYB0
         uBCUDC215uNb/RtSNwbx3QA/CKWRDilICAI4PEmMsncMp8ehv2USixYNy3GNof3Q7JtW
         v2wvG42HWDWnh10nxUWCd43sXdevzosT7bM4TER29VGE2/pVxuNy+YLFwTXxyGmPHFtI
         KCKpKrJL/ZWWin4Ay6o/aJbzRsoGBGVs/ePNqcvby5uvO6ltykU2t5lM4YuR52pGOAXI
         0DkDPMBX/tC6nyiC3KZeUbZyxlAU6dJ/ih0of4MDVWiBuTRK1tYuHq4A1T4mvYe0k1n2
         xq0g==
X-Gm-Message-State: AOAM530ri8VHo4S60YMMFj7FrFN5FEZ4IPaYH328NbEG+sXTKSTS17aO
        h7elyRAZFHnmK6vCpVOI5barUZQ2jZA=
X-Google-Smtp-Source: ABdhPJyHAiUHvwGKu1jZ/kKDWjRpLUuWkvsCMUJdc7c5eaOnVNIVQyHtu/BQr6QyictO5jTFgA4qyg==
X-Received: by 2002:a05:600c:4e87:: with SMTP id f7mr2283057wmq.121.1629192814642;
        Tue, 17 Aug 2021 02:33:34 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.233.12])
        by smtp.gmail.com with ESMTPSA id x18sm1718578wrw.19.2021.08.17.02.33.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Aug 2021 02:33:34 -0700 (PDT)
To:     Stefan Metzmacher <metze@samba.org>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <cover.1628871893.git.asml.silence@gmail.com>
 <17841c48-093e-af1c-c7c9-aa00859eb1b9@samba.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH v2 0/4] open/accept directly into io_uring fixed file
 table
Message-ID: <78e2d63a-5d3a-6334-8177-11646d4ec261@gmail.com>
Date:   Tue, 17 Aug 2021 10:33:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <17841c48-093e-af1c-c7c9-aa00859eb1b9@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/16/21 4:45 PM, Stefan Metzmacher wrote:
> Hi Pavel,
> 
>> The behaviour is controlled by setting sqe->file_index, where 0 implies
>> the old behaviour. If non-zero value is specified, then it will behave
>> as described and place the file into a fixed file slot
>> sqe->file_index - 1. A file table should be already created, the slot
>> should be valid and empty, otherwise the operation will fail.
>>
>> Note 1: we can't use IOSQE_FIXED_FILE to switch between modes, because
>> accept takes a file, and it already uses the flag with a different
>> meaning.
> 
> Would it be hard to support IOSQE_FIXED_FILE for the dirfd of openat*, renameat, unlinkat, statx?
> (And mkdirat, linkat, symlinkat when they arrive)
> renameat and linkat might be trickier as they take two dirfds, but it
> would make the feature more complete and useful.

Good idea. There is nothing blocking on the io_uring side, but
the fs part may get ugly, e.g. too intrusive. We definitely need
to take a look

-- 
Pavel Begunkov
