Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 140D944B296
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 19:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242187AbhKIST7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 13:19:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242160AbhKIST6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 13:19:58 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B457FC061764
        for <netdev@vger.kernel.org>; Tue,  9 Nov 2021 10:17:12 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id g18so115317pfk.5
        for <netdev@vger.kernel.org>; Tue, 09 Nov 2021 10:17:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YOqlZrA3M1NbCnfldZU6DBKVKCYvlENSsVuwD1wea5I=;
        b=PrwFZacaTHainZ0qaAJV/zGD84dkGdMP8wEbnN7L/byt2i65mFA4DL8wDIaDA2pijb
         EYto4KmnQvazARA+jFcSeg4gqw+SoCMbY+BNStbubXZIVdonzY8uuiHYm0OCOnU6fCa7
         WqWrWZcODnRH9XLy9J6OKpT4D2b2E0tOCqlwgLozReAYbmZULzJBD8uoMd+qTgx7Q7RV
         rpiAupfnbd9bvCephkTGO3XgK5alwjY9cC9BptnwVVwJVErwNoAfdSoJlJ+SoNzw0QSh
         pXAVkpVngZtCTnpp6Gj9xy6YOs0lEK5oZcXYWNr4Ztu0xSb9Kaxyso8k+LcXjBVLXuvg
         LIGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YOqlZrA3M1NbCnfldZU6DBKVKCYvlENSsVuwD1wea5I=;
        b=pKpWfNW/8r/ElsBCoVqkrNiliCjHMcQ0z5s3PuWQGDqz4teIexLcy0hPXZL//u25zS
         z4+IF9/Zttq45NtqtmQrPf+INtI8br8QAtQAoxfmmSVSahONmTFJfueKZcLWQZ295cza
         EHqZMUwtcQim785qkD7mUnEAi0MjQPOkYgp1UYlE/MLUqZ/zlGB8QNdDmMce+maQ8y1Z
         IxVhplw+7pQ3ncRbl2fDPgFSpP9hl4vT5uonySdH3lfYy53TbFTusBIxLkUI3oyhCKsr
         jePTZ/PucaRjhtOApG/ZOCqIQW6f2ASmOdHSIGWDN5PWV/NnrQT07RL67BpPbJ7srwDI
         Ji9w==
X-Gm-Message-State: AOAM5312RYICS1WTMFE2tYTMdPdu4+FfEnIIIjt6aQ10vkXEdT6EXiNb
        US9vtI2xXpIYRC31K6mWTP1i6w==
X-Google-Smtp-Source: ABdhPJzXPKln9Vs5wQ4NRjyaxaIz3t4F1JVcwtodx5Uka/2wN4nWHcbBXb871xxDR6EuplXpiPb8Rg==
X-Received: by 2002:a05:6a00:1946:b0:492:64f1:61b5 with SMTP id s6-20020a056a00194600b0049264f161b5mr10239921pfk.52.1636481832009;
        Tue, 09 Nov 2021 10:17:12 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id gv23sm3281540pjb.17.2021.11.09.10.17.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 10:17:11 -0800 (PST)
Date:   Tue, 9 Nov 2021 18:17:08 +0000
From:   Joe Burton <jevburton@google.com>
To:     Hou Tao <houtao1@huawei.com>
Cc:     Joe Burton <jevburton.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Petar Penkov <ppenkov@google.com>,
        Stanislav Fomichev <sdf@google.com>
Subject: Re: [RFC PATCH v3 2/3] bpf: Add selftests
Message-ID: <YYq7JHdIAdc2bU55@google.com>
References: <20211102021432.2807760-1-jevburton.kernel@gmail.com>
 <20211102021432.2807760-3-jevburton.kernel@gmail.com>
 <98178f0f-ff43-b996-f78b-778f74b44a6b@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <98178f0f-ff43-b996-f78b-778f74b44a6b@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Nov 04, 2021 at 02:32:37PM +0800, Hou Tao wrote:

> In fentry__x64_sys_write(), you just do trigger updates to maps, so for the
> portability of the test
> (e.g. run-able for arm64)

Agreed that the test should be runnable on arm64. I haven't tested there
yet but I'll do that before sending out v4.

> and minimal dependency (e.g. don't depends on /tmp),
> why do you
> using nanosleep() and replacing fentry_x64_sys_write by
> tp/syscalls/sys_enter_nanosleep instead.

As written, the example actually modifies the return of write(), so I
don't think I can switch to tp/syscalls/* without significantly
reworking the example. To minimize the amount of reworking while
improving compatibility, how does this sound:

1. Add #ifdefs to support arm64
2. Instead of opening /tmp/map_trace_test_file, open /dev/null

Of course this isn't as portable as your proposal but I think it might
be an acceptable compromise.

Best,
Joe

