Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1371D57E15E
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 14:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234717AbiGVMUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 08:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231902AbiGVMUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 08:20:17 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E15413F1F
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 05:20:15 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id u12so3371681qtk.0
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 05:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:date:message-id:in-reply-to:references:user-agent
         :subject:mime-version:content-transfer-encoding;
        bh=kIKMl7lknNmrR7/g3+eBdSau4//c4Zzr0QaeUiEir7A=;
        b=cHhHjmlahYQ+EmtKYhfCB8KTNgvpM7+cBXuWAwrqR7qvzNU8+HhLRnTdPxxvFVeHh3
         1nUaRHsHw8NQy+w+KEbL1WitYxDtz85JVMIVI6ao9QwCutRBsbMgBOX4RICVcuV9E3oe
         AWc4nmne8ushnOtD6AFil/8ViyNXbqrdkinYxQ3k4aucoZdSrbdYliPQjWq0MBJj/Bn8
         JL9k1d5L3NzOCtYoIbyj6v7UD2hB1lFi0USJqy10hnlWJwfYP2r/1IG2soYO4rnBxTgq
         H4IMse2/xdiaEKZwKqcUw9ZoKLvnfHoeFJLzprkjkdjavu6OyvtAFHUEfzaDx+u7Zpd5
         vOhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:subject:mime-version
         :content-transfer-encoding;
        bh=kIKMl7lknNmrR7/g3+eBdSau4//c4Zzr0QaeUiEir7A=;
        b=PxaRNsZLl0JL1ekAaGm03JMiFBbaQSfW3H31HeCcKBU1MtpOK62WKjDRuBxwB8cDlO
         vZ48JK3g80rEopo8iBJze2bPJahjV1xkpqz/8LFvZzh+V64XJ3WNmU0xKnpBMnwFCH75
         gBeixIxqEwJsm5xPX2blpGNmBkG16rqthZ46Xr1R15xZJ3jCclLVF1nbkTkzrvF7F90+
         Wz+eVf89NQJ4snuSIv+jNFSZ14DvVPO3WKe+H6bO5aEVwuIlPZRccRvRscnrXFRaE+Os
         7zb+H7GbtnQzr0oSU8CsqrzW/8xNs+bxe6ih1GPQSH0I8cvtDDYyLBmpgf9wuv9rlxTS
         kyJQ==
X-Gm-Message-State: AJIora+i1zNQ5JxATQ61wOIPPJwqswN6h5LiEYHPCJRDr4j67ato2qqk
        vNH2izA6nWp/LDOucbR5qILP
X-Google-Smtp-Source: AGRyM1vRv8Pg5YMxgoX//w7Bar4An6ugLUhEpTDVLqgE1K9tMb0kLUN+xQP5nT2rrJ4QhsOwsmCzBg==
X-Received: by 2002:ac8:7f8e:0:b0:31f:10bc:f5d7 with SMTP id z14-20020ac87f8e000000b0031f10bcf5d7mr140040qtj.561.1658492414525;
        Fri, 22 Jul 2022 05:20:14 -0700 (PDT)
Received: from [10.130.209.145] (mobile-166-170-54-234.mycingular.net. [166.170.54.234])
        by smtp.gmail.com with ESMTPSA id m1-20020a05620a24c100b006b259b5dd12sm3456272qkn.53.2022.07.22.05.20.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 22 Jul 2022 05:20:13 -0700 (PDT)
From:   Paul Moore <paul@paul-moore.com>
To:     Martin KaFai Lau <kafai@fb.com>,
        Frederick Lawler <fred@cloudflare.com>
CC:     <kpsingh@kernel.org>, <revest@chromium.org>,
        <jackmanb@chromium.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <andrii@kernel.org>, <songliubraving@fb.com>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <jmorris@namei.org>,
        <serge@hallyn.com>, <stephen.smalley.work@gmail.com>,
        <eparis@parisplace.org>, <shuah@kernel.org>, <brauner@kernel.org>,
        <casey@schaufler-ca.com>, <ebiederm@xmission.com>,
        <bpf@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
        <selinux@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-team@cloudflare.com>, <cgzones@googlemail.com>,
        <karl@bigbadwolfsecurity.com>
Date:   Fri, 22 Jul 2022 08:20:10 -0400
Message-ID: <18225d94bf0.28e3.85c95baa4474aabc7814e68940a78392@paul-moore.com>
In-Reply-To: <20220722061137.jahbjeucrljn2y45@kafai-mbp.dhcp.thefacebook.com>
References: <20220721172808.585539-1-fred@cloudflare.com>
 <20220722061137.jahbjeucrljn2y45@kafai-mbp.dhcp.thefacebook.com>
User-Agent: AquaMail/1.37.0 (build: 103700163)
Subject: Re: [PATCH v3 0/4] Introduce security_create_user_ns()
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On July 22, 2022 2:12:03 AM Martin KaFai Lau <kafai@fb.com> wrote:

> On Thu, Jul 21, 2022 at 12:28:04PM -0500, Frederick Lawler wrote:
>> While creating a LSM BPF MAC policy to block user namespace creation, we
>> used the LSM cred_prepare hook because that is the closest hook to preve=
nt
>> a call to create_user_ns().
>>
>> The calls look something like this:
>>
>> cred =3D prepare_creds()
>> security_prepare_creds()
>> call_int_hook(cred_prepare, ...
>> if (cred)
>> create_user_ns(cred)
>>
>> We noticed that error codes were not propagated from this hook and
>> introduced a patch [1] to propagate those errors.
>>
>> The discussion notes that security_prepare_creds()
>> is not appropriate for MAC policies, and instead the hook is
>> meant for LSM authors to prepare credentials for mutation. [2]
>>
>> Ultimately, we concluded that a better course of action is to introduce
>> a new security hook for LSM authors. [3]
>>
>> This patch set first introduces a new security_create_user_ns() function
>> and userns_create LSM hook, then marks the hook as sleepable in BPF.
> Patch 1 and 4 still need review from the lsm/security side.


This patchset is in my review queue and assuming everything checks out, I e=
xpect to merge it after the upcoming merge window closes.

I would also need an ACK from the BPF LSM folks, but they're CC'd on this p=
atchset.

--
paul-moore.com


