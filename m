Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7E903F3D1B
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 04:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbhHVCS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 22:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231414AbhHVCSy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Aug 2021 22:18:54 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 807CDC061575
        for <netdev@vger.kernel.org>; Sat, 21 Aug 2021 19:18:14 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id x5so13608492ill.3
        for <netdev@vger.kernel.org>; Sat, 21 Aug 2021 19:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3f1402yNnR5XHhynZNjdZxQF7CwaoEz9EzTU8SvpoEI=;
        b=1ooHuaepzTBUq1/UuK7KBZTJQ3nqI7H2HMnXqTC17jGqlVd8d7q2Bpqylh2DeuaBEd
         0vLn54AF3cJ9bbb6g7DG1AsrtX899daKSmF5hOqAj7sPdh8zFe1JQHoGa5znTznIEV0P
         UewesmAzOQiREHh71RUJ6j45nGyidReqz+uW+3rkk7fg6lqjZb+WoBw4MATJvzMKiqFJ
         HC8K52JpuuUFI0+gKoNcZFBiL8z0e6psdK1czYV8m1sKbUpBFXfFH4yttvisLsgP2HkB
         ynnush+uj6Uh3dWf4A8DdVT07IlYPwDi1Ll4gMByceiEiCIrZ2+PvWfYmHoMZiU5M4DD
         5nkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3f1402yNnR5XHhynZNjdZxQF7CwaoEz9EzTU8SvpoEI=;
        b=RXSXLjGt71t7YsYJdj+8qxMiNTF0LReOKxU3aFmgUEF2+uMAErftCu47Cp4w1bvriT
         9erqYdggTRTuT2mIfKkZ3XCGL1RGtft7uNNoXi0GIFncml6HEsiKjQ7wZWrESYAnDrN9
         VbF1NtjAFrmxmF+SkLIfsEBe1LNgiBwAhjW+22zotXXbK7Oh//7MUCOLwq6SkFihEn1p
         tcsTcm8q5SYqE4BjOp3o7obEJJDLa3Hi3DVVMGMcmJhzMNS8OJ+nt4xl2ANPZjTD36Xd
         QOaHTYO/7jBV1uQLczLQHxIA/O4Gut6u4Jxfc/s3TpAkviL7b+VXzT/6r42ngWvmLL2Y
         BNvQ==
X-Gm-Message-State: AOAM532IHngH2Dc0xOCQx7N50C66gFznuKnXaXgB4lufJZ2aoulx3byV
        aKPqr3uQQJUJz4G5hGKE6VeH2g==
X-Google-Smtp-Source: ABdhPJykFZZ6+4oaXXLliFJmzbiSWZ9UKVeN3xoFTI/aTUiVN3h+eTp5d5OMjBHW4b03KO4HzksQEg==
X-Received: by 2002:a92:6a05:: with SMTP id f5mr11831470ilc.140.1629598693927;
        Sat, 21 Aug 2021 19:18:13 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id d14sm3988124iod.18.2021.08.21.19.18.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Aug 2021 19:18:13 -0700 (PDT)
Subject: Re: [PATCH v3 0/4] open/accept directly into io_uring fixed file
 table
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Stefan Metzmacher <metze@samba.org>
References: <cover.1629559905.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7fa72eec-9222-60eb-9ec6-e4b6efbfc5fb@kernel.dk>
Date:   Sat, 21 Aug 2021 20:18:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1629559905.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/21/21 9:52 AM, Pavel Begunkov wrote:
> Add an optional feature to open/accept directly into io_uring's fixed
> file table bypassing the normal file table. Same behaviour if as the
> snippet below, but in one operation:
> 
> sqe = prep_[open,accept](...);
> cqe = submit_and_wait(sqe);
> io_uring_register_files_update(uring_idx, (fd = cqe->res));
> close((fd = cqe->res));
> 
> The idea in pretty old, and was brough up and implemented a year ago
> by Josh Triplett, though haven't sought the light for some reasons.
> 
> The behaviour is controlled by setting sqe->file_index, where 0 implies
> the old behaviour. If non-zero value is specified, then it will behave
> as described and place the file into a fixed file slot
> sqe->file_index - 1. A file table should be already created, the slot
> should be valid and empty, otherwise the operation will fail.
> 
> we can't use IOSQE_FIXED_FILE to switch between modes, because accept
> takes a file, and it already uses the flag with a different meaning.
> 
> since RFC:
>  - added attribution
>  - updated descriptions
>  - rebased
> 
> since v1:
>  - EBADF if slot is already used (Josh Triplett)
>  - alias index with splice_fd_in (Josh Triplett)
>  - fix a bound check bug

With the prep series, this looks good to me now. Josh, what do you
think?

And we need the net folks to sign off on the first patch, of course.

-- 
Jens Axboe

