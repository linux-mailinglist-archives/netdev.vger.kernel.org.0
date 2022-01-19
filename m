Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20365494298
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 22:46:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbiASVqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 16:46:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343544AbiASVqT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 16:46:19 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 332C4C06161C
        for <netdev@vger.kernel.org>; Wed, 19 Jan 2022 13:46:19 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id t18so3427890plg.9
        for <netdev@vger.kernel.org>; Wed, 19 Jan 2022 13:46:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20210112.gappssmtp.com; s=20210112;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=jZ6lVTSSFLFuFM/L+SjIupfkrZNssGv8z3Ianidrykk=;
        b=T5Ut7gDpIfiZ5vSn4GajrcdCDWzj3ncSvpr6z6u/ZHn+J7ACma+MqlbYIBGh6deKu+
         AGSqX//MqiJnhFlcxxPXGhsyfGy4OUZt5/o8LkpVe126EQuZ1otC9ZvfvCSyaq5xOigZ
         5cNXaMKmqRIOE+fQIwzIpvPLiavpe7QZVSlv401/WOfqOnxY6I+NazU64BPtwtOsDxpj
         3H0Hao4uRWffQHJ212dZlw4d92bI0U2aaqU8cd3Uwsx+gcdBJxwzsRw/pjJjrr+qXPez
         ixx7wBTUnNLEC1vtxF5KOL4CEnwnE3Jpirk2c7r96x4GdSWtrM5oroLNP+PoZb4BHjIP
         FSSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=jZ6lVTSSFLFuFM/L+SjIupfkrZNssGv8z3Ianidrykk=;
        b=LXwE0Au6hRbHS9eXYWeiEatRXa4MzwO6sKPmEhnb+PaYvcdlZMKun0h2omDWc91Jyg
         Mdf8nqsSSiENfspEEHCr+xyt2ew4IbIVHnN7foB/GvVJG7+vDR+yBPquSqH0ceO650o1
         sy4uK4MGMCP7If9Zj2RUnKQ59nEhov0kyC0gSBrUsUNjQHjBKDUJLoWkDImvLvW2C1Hw
         9cU33ANKnXNOTU2XxjyA311BBqWrSRAw9oxUMusV/xcO6kpYmwhHNuffm45jQFi3inhB
         jOWi1N9KxhlXkrxszl8SEZOt01H8gxK+7rrZGgmlpFjCB1emBS7ZvYA0NnBVv3Z4k5Ok
         mLqg==
X-Gm-Message-State: AOAM531IEVu/X4la4b+NCOiJVH8K0iaiMxvoem9oppUaC0uaxx/1B5ZV
        13Y+6Zu3L+99kQ9lBsccK/upMA==
X-Google-Smtp-Source: ABdhPJyOycOjSe9Y3DxhPWvgMrJUgy5U1hJ1ti7S8lIPGcJ4Ev3rPpSEkhI1yF9/JudNuJm4lJE5Sg==
X-Received: by 2002:a17:90b:1bcc:: with SMTP id oa12mr6853102pjb.4.1642628778470;
        Wed, 19 Jan 2022 13:46:18 -0800 (PST)
Received: from localhost ([12.3.194.138])
        by smtp.gmail.com with ESMTPSA id j4sm635045pfc.125.2022.01.19.13.46.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 13:46:17 -0800 (PST)
Date:   Wed, 19 Jan 2022 13:46:17 -0800 (PST)
X-Google-Original-Date: Wed, 19 Jan 2022 13:45:49 PST (-0800)
Subject:     Re: [PATCH riscv-next] riscv: bpf: Fix eBPF's exception tables
In-Reply-To: <mhng-db82dcc8-e5f7-4da5-9f5c-d7f6eb225735@palmer-ri-x1c9>
CC:     Bjorn Topel <bjorn.topel@gmail.com>, jszhang@kernel.org,
        Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, ast@kernel.org, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        tongtiangen@huawei.com
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     daniel@iogearbox.net
Message-ID: <mhng-5a4269e6-dca2-4a28-b9c8-336c023b8450@palmer-ri-x1c9>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Jan 2022 10:04:24 PST (-0800), Palmer Dabbelt wrote:
> On Wed, 19 Jan 2022 07:59:40 PST (-0800), Bjorn Topel wrote:
>> On Wed, 19 Jan 2022 at 16:42, Daniel Borkmann <daniel@iogearbox.net> wrote:
>>>
>> [...]
>>> > AFAIK, Jisheng's extable work is still in Palmer's for-next tree.
>>> >
>>> > Daniel/Alexei: This eBPF must follow commit 1f77ed9422cb ("riscv:
>>> > switch to relative extable and other improvements"), which is in
>>> > Palmer's tree. It cannot go via bpf-next.
>>>
>>> Thanks for letting us know, then lets route this fix via Palmer. Maybe he could
>>> also add Fixes tags when applying, so stable can pick it up later on.
>>>
>>
>> It shouldn't have a fixes-tag, since it's a new feature for RV. This
>> was adapting to that new feature. It hasn't made it upstream yet (I
>> hope!).
>
> That was actually just merged this morning into Linus' tree.  I'm still
> happy to take the fix via my tree, but you're welcome to take it via a
> BPF tree as well.  I'm juggling some other patches right now, just LMK
> what works on your end.
>
> IMO it should have a fixes tag: it's a bit of a grey area, but one
> something's in I generally try and put those tags on it.  That way folks
> who try and backport features at least have a shot at finding the fix
> (or at least, finding the fix without chasing around the bug ;)).
>
> I also tried poking you guys on the BPF Slack, but I don't really use it
> and I'm not sure if anyone else does either.

As per the slack discussion with Daniel, I've put this into the RISC-V 
for-next tree.

Thanks!
