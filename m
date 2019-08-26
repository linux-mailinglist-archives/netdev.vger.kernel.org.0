Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0C5E9D542
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 19:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387557AbfHZR54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 13:57:56 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:36607 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728280AbfHZR54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 13:57:56 -0400
Received: by mail-pl1-f196.google.com with SMTP id f19so10396085plr.3;
        Mon, 26 Aug 2019 10:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=77MKV+MJ6zyFv67aHlgM/8m5X/mM7/TRqBSqvmlPQ9E=;
        b=Y4LKMB58TZntJjF5waqJp99gc/Rrj1YMoljV8x/GPkoGUPWWGy7MNl/75XFg70JRnJ
         1EIJKSBZQBFMWwT7zg50Y184kStpCGluR9PQ39mpDSSSPqRGwhj29M0IRlTgjxEHfaja
         rV+/QCbFOsrKZsz6fQXF6rlQXYnoleOfejCb8ITVunH7tRXm8Aq9Ertfdk1jT3R2jr29
         wAg3CcYAdztk8isu4TQM9WQ69AKUxQmUuTz5nuy+KwgzBCmppJI2q3+bem8wq8Rlp7OX
         vyrmoh2bcvklCwB/EVzfxNaXnrcvff5hcMmmxX1eNbe42rGuDrm58p3wR4CYI7oHSUjl
         /xaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=77MKV+MJ6zyFv67aHlgM/8m5X/mM7/TRqBSqvmlPQ9E=;
        b=OvfoGTdgb7gVOVm5JpFiOCrqmNU2/JQT22KsRFc121FVdWjxzlu98+UIJD3X+ltD9n
         lAkg7gnOCy6TUjIQDIFVoQipwu0SwKqNt5hxgnu2iMKTlbN8OAFkRuWZyD/gIkTK+TcP
         7CCqWvUmqln6q4YD9sFJ40EU112PYK8hqC5vE1FsabYQD3jslRc2cBzQhUoC7UUg/mo1
         v30toYU9U5+tnq/JIAJp97FsUZm1uydVSJz9AMmyEbj0PxvuiA1hZuXvHOV9FPgqMBzm
         bHV9Jx5eOlTn4o4vF9dKz3vN+3kl5I10OfUUwP/Bk4vZIKiRPieOEV5C/MZl87CCX6Dr
         vsYA==
X-Gm-Message-State: APjAAAUSLcG20duji/kHd+htMlk+GBITZ4xC4ZaxEfrilG7gNOFNwnFw
        YtZnBt8GXRxizyhOwtFsU9U=
X-Google-Smtp-Source: APXvYqz/wQlGKHGkT3JOvNWRfTMmGAHixD/68vdDO+oS2Lw+jc4kYYu2NfkV4Tx3YqVDRBHBQkbnww==
X-Received: by 2002:a17:902:b40c:: with SMTP id x12mr20189459plr.81.1566842275349;
        Mon, 26 Aug 2019 10:57:55 -0700 (PDT)
Received: from [172.20.53.188] ([2620:10d:c090:200::3:2982])
        by smtp.gmail.com with ESMTPSA id q13sm20741362pfl.124.2019.08.26.10.57.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Aug 2019 10:57:54 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "=?utf-8?b?QmrDtnJuIFTDtnBlbA==?=" <bjorn.topel@intel.com>
Cc:     "Ilya Maximets" <i.maximets@samsung.com>,
        "=?utf-8?b?QmrDtnJuIFTDtnBlbA==?=" <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        bpf@vger.kernel.org,
        syzbot+c82697e3043781e08802@syzkaller.appspotmail.com,
        hdanton@sina.com
Subject: Re: [PATCH bpf-next v2 2/4] xsk: add proper barriers and {READ,
 WRITE}_ONCE-correctness for state
Date:   Mon, 26 Aug 2019 10:57:53 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <3F33CA61-D000-4318-958D-90F5A3CCAD60@gmail.com>
In-Reply-To: <1b780dd4-227f-64c4-260d-9e819ba7081f@intel.com>
References: <20190826061053.15996-1-bjorn.topel@gmail.com>
 <CGME20190826061127epcas5p21bb790365a436ff234d77786f03729f8@epcas5p2.samsung.com>
 <20190826061053.15996-3-bjorn.topel@gmail.com>
 <14576fd3-69ce-6493-5a38-c47566851d4e@samsung.com>
 <1b780dd4-227f-64c4-260d-9e819ba7081f@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 26 Aug 2019, at 9:34, Björn Töpel wrote:

> On 2019-08-26 17:24, Ilya Maximets wrote:
>> This changes the error code a bit.
>> Previously:
>>     umem exists + xs unbound    --> EINVAL
>>     no umem     + xs unbound    --> EBADF
>>     xs bound to different dev/q --> EINVAL
>>
>> With this change:
>>     umem exists + xs unbound    --> EBADF
>>     no umem     + xs unbound    --> EBADF
>>     xs bound to different dev/q --> EINVAL
>>
>> Just a note. Not sure if this is important.
>>
>
> Note that this is for *shared* umem, so it's very seldom used. Still,
> you're right, that strictly this is an uapi break, but I'd vote for the
> change still. I find it hard to see that anyone relies on EINVAL/EBADF
> for shared umem bind.
>
> Opinions? :-)

I'd agree - if it isn't documented somewhere, it's not an API break. :)
-- 
Jonathan
