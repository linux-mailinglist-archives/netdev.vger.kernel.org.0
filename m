Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 135A6493F99
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 19:04:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356633AbiASSEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 13:04:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356632AbiASSEZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 13:04:25 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB09C06161C
        for <netdev@vger.kernel.org>; Wed, 19 Jan 2022 10:04:25 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id l16so3155548pjl.4
        for <netdev@vger.kernel.org>; Wed, 19 Jan 2022 10:04:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=Gi0oK+fPiedFcLKwooWAnMK7r0Lqu+rB2qQcbSleGhs=;
        b=w+9b5KmJD/a+xfKIB+Y5jwntxsAjQel9/8AIlRQKmb6gfg0CyQNkl6RgIihWkmVAPw
         6dH59ZFdAaVoU5CSqESAtCth9hveeSbYp2LKQESSq/x/uiAnXGYtZv1vMs6r4lhwcY5i
         cqUrrmo83YbyhIZTq63FEvjsGTgqiNE0PFpVYPnqFSOYgFKkYNFRcIMyMZwax+yp2bKE
         RtB1wopnCsMkX3tBRZKDt+BgvxFE11ky7sHw3hlI1ybHbpt/GJ61NXlncUl6/+57z8OX
         CdO/F+tGEpsOtmkEUWKeEiBruYcqWbM0zzvmjWYEobnDlEjeMVJg+g0qGj+pfF/0Vg3I
         mtoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=Gi0oK+fPiedFcLKwooWAnMK7r0Lqu+rB2qQcbSleGhs=;
        b=iW9jq9y8rH+xZDJpNjA1jYv56W35+go0YruAqPQVcBELOp4uthf9p9nZrP8oooX8Mj
         zuwaimQuwgG8rPsNzzvY+TrBL/uRv6g1JX8J4d8NuHfaxTZJz6rKMJzN8xfuQsDoe4vk
         wSR9GL/SFdGeaPEy3v7+Jn3j4yIJSVVlcx+VLhehBU5XwQTw7nCl2Qmp8eyApCGo0mFJ
         y+SgHQ2kekHb4NwGM+b7RqE76XMf3/TLE9sFPP8rI9p9/MjGcf9ACEN2Y1/HGfqx9xx4
         rlQ7E+JMeXwBuxlLbT9os2bJKsOXNn06R0PpohQWuamHxCBYQjHDQkRn9hCuGzsA1V51
         uQ/A==
X-Gm-Message-State: AOAM533t1U5NFUi4BRAMx2uioZIEsQxSVLpKjj9BI9JSniia5c+Ij1gJ
        ABZoSkxtUIa+nf1wlaiPG6aptQ==
X-Google-Smtp-Source: ABdhPJyTs4le+F5zP1oVfHJ5eTadlQPGgFbplihq3u4uSSSzmdN/Ut9DNT5Q+29K6m2hzIGTzVDn9g==
X-Received: by 2002:a17:902:7d8f:b0:14a:b712:bbfb with SMTP id a15-20020a1709027d8f00b0014ab712bbfbmr17071277plm.63.1642615465039;
        Wed, 19 Jan 2022 10:04:25 -0800 (PST)
Received: from localhost ([12.3.194.138])
        by smtp.gmail.com with ESMTPSA id u35sm275750pfg.195.2022.01.19.10.04.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 10:04:24 -0800 (PST)
Date:   Wed, 19 Jan 2022 10:04:24 -0800 (PST)
X-Google-Original-Date: Wed, 19 Jan 2022 10:03:56 PST (-0800)
Subject:     Re: [PATCH riscv-next] riscv: bpf: Fix eBPF's exception tables
In-Reply-To: <CAJ+HfNikH3OMH_b3=uvfSqAJZkjJabn9yipbYdnTxsh_=VDHOQ@mail.gmail.com>
CC:     daniel@iogearbox.net, jszhang@kernel.org,
        Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, ast@kernel.org, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        tongtiangen@huawei.com
From:   Palmer Dabbelt <palmer@rivosinc.com>
To:     Bjorn Topel <bjorn.topel@gmail.com>
Message-ID: <mhng-db82dcc8-e5f7-4da5-9f5c-d7f6eb225735@palmer-ri-x1c9>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Jan 2022 07:59:40 PST (-0800), Bjorn Topel wrote:
> On Wed, 19 Jan 2022 at 16:42, Daniel Borkmann <daniel@iogearbox.net> wrote:
>>
> [...]
>> > AFAIK, Jisheng's extable work is still in Palmer's for-next tree.
>> >
>> > Daniel/Alexei: This eBPF must follow commit 1f77ed9422cb ("riscv:
>> > switch to relative extable and other improvements"), which is in
>> > Palmer's tree. It cannot go via bpf-next.
>>
>> Thanks for letting us know, then lets route this fix via Palmer. Maybe he could
>> also add Fixes tags when applying, so stable can pick it up later on.
>>
>
> It shouldn't have a fixes-tag, since it's a new feature for RV. This
> was adapting to that new feature. It hasn't made it upstream yet (I
> hope!).

That was actually just merged this morning into Linus' tree.  I'm still 
happy to take the fix via my tree, but you're welcome to take it via a 
BPF tree as well.  I'm juggling some other patches right now, just LMK 
what works on your end.

IMO it should have a fixes tag: it's a bit of a grey area, but one 
something's in I generally try and put those tags on it.  That way folks 
who try and backport features at least have a shot at finding the fix 
(or at least, finding the fix without chasing around the bug ;)).

I also tried poking you guys on the BPF Slack, but I don't really use it 
and I'm not sure if anyone else does either.
