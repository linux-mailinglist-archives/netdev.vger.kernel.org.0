Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2B15E3C32
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 21:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437113AbfJXTmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 15:42:01 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:36935 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390785AbfJXTmA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 15:42:00 -0400
Received: by mail-io1-f68.google.com with SMTP id 1so19625883iou.4
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 12:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=B1mVjLx4z1iUoxHpJmVnLp3Anve8esI4cKpDRSB58AM=;
        b=1EQaIYAjfwV0JsSn39OhqkCMs1VH19iQ05Tg7903Qqlck1pp+i7HjDcH8/gj+DfpFV
         IYEGrQCRwpPEv6Qg/n9cZ4AGxFOIlibiPOJEj4mRvHSFDf/zyDjOMBqiaznPEX808QVe
         86V2pS8n8JzqQE3tX+pn2BTjXt9pfG5YOY0OptHCNQB+KNqDxXXV4/a2esvMKsUOIPft
         SF7Mq5Px8i2W2Nd1vY025Eh+SqmOgTvXutlDfpzUrSyPAk3irSDDHBIzCbAtV3S7tLwZ
         eqweHuKWkVklGY67oWBfoo/Ml0V2fa6uDXdA6vSCXdCwyY9sPF44/iQjvDQdOycBaTt3
         04HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=B1mVjLx4z1iUoxHpJmVnLp3Anve8esI4cKpDRSB58AM=;
        b=iWoq/4DUxCRnHdQwTf39aHgCrj6z0t+LIOy/HDBDLKb9c57GfONYU+vg3+O6K0Ssh7
         jdXMweRUlyoJgyKNmmuEfQna9hqSCdR73QezLBSHwgRpLHe2W810rZEF0jPT1WUM5shl
         cTUGkBBnMr0szFOMYyfl9d5pchN9pVazab5jM0CA5CzlWjdaqUh+FhIfrBzYePElQMru
         1zfFEtRZmyLFm+66n2PBeEOFZBeyJH827WvON0tVHc432oogWKGH3a9ha6J7zRhB2DgH
         NXgIBSQY7Foq17pDmBWA3TqB30ziLof5WYnubWhUtlfE7g3pOfGDtriZBpbVA149pXqu
         KfOQ==
X-Gm-Message-State: APjAAAUQUoIv7IcM6zvQMW5mSPSPPsQkwrkCep31b41VpildwZJOYlDH
        7K+sc6tH7YEX469sUEDDxpewlK2Y8WDQbg==
X-Google-Smtp-Source: APXvYqxbifdUq54QoqYM6By7hU/92u2Ii9VwTzWQYl4b7rkos79pw9QhC35RIfG2zE3VSmPj6RnHFw==
X-Received: by 2002:a6b:6b0a:: with SMTP id g10mr10503193ioc.248.1571946117366;
        Thu, 24 Oct 2019 12:41:57 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id k17sm4870854ioh.49.2019.10.24.12.41.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Oct 2019 12:41:55 -0700 (PDT)
Subject: Re: [PATCH 1/3] io_uring: add support for async work inheriting files
 table
To:     Jann Horn <jannh@google.com>
Cc:     linux-block@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
References: <20191017212858.13230-1-axboe@kernel.dk>
 <20191017212858.13230-2-axboe@kernel.dk>
 <CAG48ez0G2y0JS9=S2KmePO3xq-5DuzgovrLFiX4TJL-G897LCA@mail.gmail.com>
 <0fb9d9a0-6251-c4bd-71b0-6e34c6a1aab8@kernel.dk>
 <CAG48ez181=JoYudXee0KbU0vDZ=EbxmgB7q0mmjaA0gyp6MFBQ@mail.gmail.com>
 <a54329d5-a128-3ccd-7a12-f6cadaa20dbf@kernel.dk>
 <CAG48ez1SDQNHjgFku4ft4qw9hdv1g6-sf7-dxuU_tJSx+ofV-w@mail.gmail.com>
 <dbcf874d-8484-9c27-157a-c2752181acb5@kernel.dk>
 <CAG48ez3KwaQ3DVH1VoWxFWTG2ZfCQ6M0oyv5vZqkLgY0QDEdiw@mail.gmail.com>
 <a8fb7a1f-69c7-bf2a-b3dd-7886077d234b@kernel.dk>
 <572f40fb-201c-99ce-b3f5-05ff9369b895@kernel.dk>
 <CAG48ez12pteHyZasU8Smup-0Mn3BWNMCVjybd1jvXsPrJ7OmYg@mail.gmail.com>
 <20b44cc0-87b1-7bf8-d20e-f6131da9d130@kernel.dk>
 <2d208fc8-7c24-bca5-3d4a-796a5a8267eb@kernel.dk>
 <CAG48ez2ZQBVEe8yYRwWX2=TMYWsJ=tK44NM+wqiLW2AmfYEcHw@mail.gmail.com>
 <0a3de9b2-3d3a-07b5-0e1c-515f610fbf75@kernel.dk>
 <CAG48ez1akvnVpK3dMH4H=C2CsNGDZkDaxZEF2stGAPCnUcaa+g@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c3fb07d4-223c-8835-5c22-68367e957a4f@kernel.dk>
Date:   Thu, 24 Oct 2019 13:41:54 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAG48ez1akvnVpK3dMH4H=C2CsNGDZkDaxZEF2stGAPCnUcaa+g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/18/19 12:50 PM, Jann Horn wrote:
> On Fri, Oct 18, 2019 at 8:16 PM Jens Axboe <axboe@kernel.dk> wrote:
>> On 10/18/19 12:06 PM, Jann Horn wrote:
>>> But actually, by the way: Is this whole files_struct thing creating a
>>> reference loop? The files_struct has a reference to the uring file,
>>> and the uring file has ACCEPT work that has a reference to the
>>> files_struct. If the task gets killed and the accept work blocks, the
>>> entire files_struct will stay alive, right?
>>
>> Yes, for the lifetime of the request, it does create a loop. So if the
>> application goes away, I think you're right, the files_struct will stay.
>> And so will the io_uring, for that matter, as we depend on the closing
>> of the files to do the final reap.
>>
>> Hmm, not sure how best to handle that, to be honest. We need some way to
>> break the loop, if the request never finishes.
> 
> A wacky and dubious approach would be to, instead of taking a
> reference to the files_struct, abuse f_op->flush() to synchronously
> flush out pending requests with references to the files_struct... But
> it's probably a bad idea, given that in f_op->flush(), you can't
> easily tell which files_struct the close is coming from. I suppose you
> could keep a list of (fdtable, fd) pairs through which ACCEPT requests
> have come in and then let f_op->flush() probe whether the file
> pointers are gone from them...

Got back to this after finishing the io-wq stuff, which we need for the
cancel.

Here's an updated patch:

http://git.kernel.dk/cgit/linux-block/commit/?h=for-5.5/io_uring-test&id=1ea847edc58d6a54ca53001ad0c656da57257570

that seems to work for me (lightly tested), we correctly find and cancel
work that is holding on to the file table.

The full series sits on top of my for-5.5/io_uring-wq branch, and can be
viewed here:

http://git.kernel.dk/cgit/linux-block/log/?h=for-5.5/io_uring-test

Let me know what you think!

-- 
Jens Axboe

