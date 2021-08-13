Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE103EBA11
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 18:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236319AbhHMQbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 12:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbhHMQbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 12:31:18 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5121AC061756;
        Fri, 13 Aug 2021 09:30:51 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id x10so7756244wrt.8;
        Fri, 13 Aug 2021 09:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mVNqgVlbGS9NU0K9x3GBaGLbaZEANL0O54jcZsZxY4Q=;
        b=JFzmTfa8AXexpsTp8hh2tSNw6pUiED1G4dARYVGFGrikIIO+FWJSlooonZIkTqkWKR
         xSCe68EwRMQLpCoBSsKDag/wB6qEmIL6ORXr3d1XU/ZOLiuZf4wX4Y14kG9GgJlGw2J6
         dMDalF9DjxYZ3hz7qZ6IZTbVJWQWRgs+eZcVmT+PqVGqcfeVj4Y6Nvqiq9Cc/ZLNXl+R
         p7Mkljqo9nK1G3mSzeGwos16NOCfWIK7A3BKf8HZpJGYonWJQWxQ/oykv3j+s72jLvHl
         S03R+/Y+8G1MXaAxraJ5ELDqqLbuf7UzNzlDMIF+V1Xq7mrxi7hutOnBPUuYsOCAxF2E
         MxrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mVNqgVlbGS9NU0K9x3GBaGLbaZEANL0O54jcZsZxY4Q=;
        b=UCOp2yy9A8VCkKbqxZzWP/88DrxhfN88x13RJimzWzGN2V1ViIXLx0f1gd1eW+cYz0
         Ql2spAD3PqxELt+xJevDK8zc9IEr5uWYtJLehBZWapdJ6Fw76Ku6NArLV42TLlylCq2J
         rj5ZOrEziN8hz8O+kVRDg/exHfspmJrXLt7uZuZOs0zbtO4OHi9r3fgimLlliOIg/mWR
         SWtZuKGBSkc5QU6yRSBv/LPob6aYFncXLv1+6mLIn7rjQQ/E2df0BAuFaguNu/rf+Sy+
         HY0wkWwPEGigBi3wP23ZUdruzQGbwhBTBoIJt1LDqfyb28Puf7SwnIq80R0uTfF9vGaX
         0odw==
X-Gm-Message-State: AOAM533qYrYcqZZHiJvB+IDAlnz1HTRh/a0kelSlkgDVRt6cow3kcf5m
        ntt2zrHXpCRkecyFAjzUnqV7nDmu5ww=
X-Google-Smtp-Source: ABdhPJxcLX55VEQ4CGCSLsQzBVxhqFV4yV95sZgJtD4wlIYGY9ww0s24jBDo6imidOXcbGD2SAacaQ==
X-Received: by 2002:adf:9084:: with SMTP id i4mr4254314wri.23.1628872249604;
        Fri, 13 Aug 2021 09:30:49 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.210])
        by smtp.gmail.com with ESMTPSA id q22sm2045295wmj.32.2021.08.13.09.30.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Aug 2021 09:30:49 -0700 (PDT)
Subject: Re: [RFC 0/4] open/accept directly into io_uring fixed file table
To:     Josh Triplett <josh@joshtriplett.org>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <cover.1625657451.git.asml.silence@gmail.com>
 <48bd91bc-ba1a-1e69-03a1-3d6f913f96c3@kernel.dk> <YOXCeNs0waut1Jh1@localhost>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <81438f45-ac1d-4244-8d56-dbb44bb6d8b1@gmail.com>
Date:   Fri, 13 Aug 2021 17:30:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YOXCeNs0waut1Jh1@localhost>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/7/21 4:04 PM, Josh Triplett wrote:
> On Wed, Jul 07, 2021 at 07:07:52AM -0600, Jens Axboe wrote:
>> On 7/7/21 5:39 AM, Pavel Begunkov wrote:
>>> Implement an old idea allowing open/accept io_uring requests to register
>>> a newly created file as a io_uring's fixed file instead of placing it
>>> into a task's file table. The switching is encoded in io_uring's SQEs
>>> by setting sqe->buf_index/file_index, so restricted to 2^16-1. Don't
>>> think we need more, but may be a good idea to scrap u32 somewhere
>>> instead.
>>>
>>> From the net side only needs a function doing __sys_accept4_file()
>>> but not installing fd, see 2/4.
>>>
>>> Only RFC for now, the new functionality is tested only for open yet.
>>> I hope we can remember the author of the idea to add attribution.
>>
>> Pretty sure the original suggester of this as Josh, CC'ed.
> 
> Thanks for working on this, Pavel!
> 
> Original thread at

Totally was thinking it was only a discussion but not an actual patch,
and I even did comment on it! Sorry Josh, would have persuaded you to
finish it, if I remembered that.

> https://lore.kernel.org/io-uring/20200715004209.GA334456@localhost/T/ in
> case that helps.
> 

-- 
Pavel Begunkov
