Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 989F74BCA21
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 19:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236658AbiBSSpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 13:45:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232813AbiBSSo7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 13:44:59 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B253760ABB;
        Sat, 19 Feb 2022 10:44:40 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id p23so10691941pgj.2;
        Sat, 19 Feb 2022 10:44:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G+2MUlyds6L1UN+52LQNnBAdZGXp/gCp9l8pxjmr+mI=;
        b=ShVAMF61ljh/1Zzbcf6or7CFO4KMpDRmyOpkVk7PxjpbVKlG8ixWtyo9jwNqMMC871
         aa4yw+L9V1aJCmkfoCbMLS6f2wAG5YpsyxuaqfHBU3O5mNvDYU9TQXpmzXYGduC5xEuw
         yk9QpGwPe0UnQx4N/yxOWugHjr6S4pi/IDYVchkpwD96THVogTiHBhIZkcIeOmQ6FOD5
         fcfNK2Fn//Hlud8KREnTubatFtPUcXMC4qpl4R9gB8tnwtyfmilHYyvKD3t2+lHzNtXe
         UtUQATx0ukgr42zrelFM3ZhgtvL/klE2ERUAQvHUvZflO4vibZPf/3loo+yCDWqqtDyf
         lhbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G+2MUlyds6L1UN+52LQNnBAdZGXp/gCp9l8pxjmr+mI=;
        b=EyMzCibVb6iwwQxQKL2Or8g4CUar4r3rsRZhFACe4FBLYfAHWl4NOMNzrDx5XRInPJ
         5lTNvLs3UZb2H18Tf9NktPB4Q45yhvZywmoJB05WKBfi1/JruDBa2E5Gpv35w6L722iv
         DraKmWAI24gul7H9aAXS2zsg01BVuTz5NMUQn1Qzs+acMNFxuM64kUvvpniNRuar2jiX
         H1x8fcZ0qAN0N2hTrpOB6ml039JVhD70zcXHS1T5nUr1o0KFwz3yrJAbPUw25cDihnT/
         ShwgGsK8pKQ7IXPxAqW20R4KCzw7bGslN1BiJbz4zZ05aZtiy2ctAdzyJHF06+Sk/q0T
         sZMw==
X-Gm-Message-State: AOAM532MwH6kmcfpGRim35+HeFapCDJBdVtyzHijuf8WZdK9rafJcwdx
        si91fts+WdTk+2FEvxQRlc3mhkl3iHNcnZw/tG2v95rD
X-Google-Smtp-Source: ABdhPJxYTmlS9JDmd0to38011+Xkz4nm+eMj6CDnnt2Jf7hDO+3/Ik60sBAtjOdz4CwzJCWremeDu3uleKJiyXAvqX0=
X-Received: by 2002:a63:e657:0:b0:34b:e1da:c2c with SMTP id
 p23-20020a63e657000000b0034be1da0c2cmr10425961pgj.543.1645296280243; Sat, 19
 Feb 2022 10:44:40 -0800 (PST)
MIME-Version: 1.0
References: <20220214111337.3539-1-houtao1@huawei.com> <20220217035041.axk46atz7j4svi2k@ast-mbp.dhcp.thefacebook.com>
 <3b968224-c086-a8b6-159a-55db7ec46011@huawei.com>
In-Reply-To: <3b968224-c086-a8b6-159a-55db7ec46011@huawei.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 19 Feb 2022 10:44:29 -0800
Message-ID: <CAADnVQ+z75P0sryoGhgUwrHRMr2Jw=eFO4eCRe0Ume554si9Zg@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next v2 0/3] bpf: support string key in htab
To:     Hou Tao <houtao1@huawei.com>
Cc:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Joanne Koong <joannekoong@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 18, 2022 at 5:54 AM Hou Tao <houtao1@huawei.com> wrote:
>
> > We've been thinking about "dynamic pointer" concept where
> > pointer + length will be represented as an object.
> I have seen the proposal from Joanne Koong on "dynamic pointers".
> It can solve the storage problem of string, but the lookup of
> string is still a problem. Hash is a option but can we support
> two dynamic pointers points to the same internal object and use
> the id of the internal object to represent the string ?

Let's have a discussion about dynptr in that thread.

> > The program will be able to allocate it and persist into a map value
> > and potentially into a map key.
> > For storing a bunch of strings one can use a strong hash and store
> > that hash in the key while keeping full string as a variable sized
> > object inside the value.
> Will using a strong hash function impact the lookup performance because
> each lookup will need to calculate the hash ?
>
> > Another approach is to introduce a trie to store strings, or dfa,
> > or aho-corasick, etc. There are plenty of data structures that are
> > more suitable for storing and searching strings depending on the use case.
> > Using hash table for strings has its downsides.
> > .
> Before add support for string key in hash table, we had implement tries,
> ternary search tree and hash table in user-space for string lookup. hash
> table shows better performance and memory usage, so we decide to do string
> support in hash table. We will revisit our tests and investigate new string
> data structures.

What performance characteristics did you consider?
Just the speed of the lookup ?
How many elements are there in the map ?
Is it 80% or 10% full ?
Did you compare memory usage ?
Did you consider the speed of update/delete ?
preallocated or dynamic alloc ?

With dynamic pointers and further verifier improvements bpf programs
will be able to implement a hash table on their own.
