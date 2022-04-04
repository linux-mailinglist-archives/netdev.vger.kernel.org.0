Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F05084F103B
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 09:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377785AbiDDHrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 03:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353876AbiDDHrX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 03:47:23 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F2223B014;
        Mon,  4 Apr 2022 00:45:27 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id f18so4902612edc.5;
        Mon, 04 Apr 2022 00:45:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Tlai9C8cCZiFfKZnTMXZTtbcv2bOhWWExoRE23jJ3PQ=;
        b=hnpZqkQvRmhcgBpVq1K7rI1j3GvBGkZU/uMd3O9XQIvlRWmpAJ2xY9AdPT9g4u3G+A
         P7lEhSmfAdelj8ntCpmVIrCXpgVb/lguNVtMkyfAVq8btERTg+bgi7ZDBwKqJydzyvHE
         Y2qfyNt09y62V9e5Ouh5e5pKEC/gUUZc5b8W9ti8xscMHRMXyl/olrhO5ZlNyKfQrEZq
         Y/A0VvvlA0cR1O5pCB1k3dJUbPWEIHrUwNA/TqaAeN03DUwjmKKg+cRDsxls+RSL0bEy
         7aYIkTUGW7LgBiFNcNAPPU38W7jJq4lJZlBg/O7ztgO0XNlbCYMFvZtEeV74dvMrlXJt
         ynMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Tlai9C8cCZiFfKZnTMXZTtbcv2bOhWWExoRE23jJ3PQ=;
        b=DsW58/rgbf/tzW7ik879+qiq6eowzupckGfP2t03DVJMQuB8yHWeRMM++I5IG3a2C1
         Xl98NLGEbGoB1CkM/c72rQkn5jEfGet4F/HeK43T/neOkR3b8kZiMIMeFVja3FZzyAkq
         L04WSDVMj0CMFGVvuP7ST1OLW0kSFqzMioQ1KD2mGwP5sRai6K0pkV6kanrg6eM+dTez
         YN4fOCRgXK/Y9Mg8NBvF4u90U1LJmaJwzuJlraPDq4COdmprNuXeWONK5GREeNWT6OSd
         DdVePLh24k5Rtzu5U5c48NtIu1fsNs48HlrfKc6ybI2dhV4lJRtWjtJkOVMbpbwslYFG
         VYNQ==
X-Gm-Message-State: AOAM531Ng2kBrvzReepCWMVC1Y2FjsJUs22z3FhknmueVZ31Xu06jXjA
        4g7BPurIQfXse1H5iDfrknEAS1n/p1AqDgzLoPc=
X-Google-Smtp-Source: ABdhPJyWJ0a9eaELFNxUdBnwfDWskCppbdAyhqtxj0984BUGh7eK26sPOBWWPUumUd+bfO25fkAYIOEIoHyeCUw06E8=
X-Received: by 2002:aa7:c98c:0:b0:41c:bfbd:380 with SMTP id
 c12-20020aa7c98c000000b0041cbfbd0380mr6001495edt.313.1649058325913; Mon, 04
 Apr 2022 00:45:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220328175033.2437312-1-roberto.sassu@huawei.com>
 <20220331022727.ybj4rui4raxmsdpu@MBP-98dd607d3435.dhcp.thefacebook.com>
 <b9f5995f96da447c851f7c9db8232a9b@huawei.com> <20220401235537.mwziwuo4n53m5cxp@MBP-98dd607d3435.dhcp.thefacebook.com>
 <CACYkzJ5QgkucL3HZ4bY5Rcme4ey6U3FW4w2Gz-9rdWq0_RHvgA@mail.gmail.com>
In-Reply-To: <CACYkzJ5QgkucL3HZ4bY5Rcme4ey6U3FW4w2Gz-9rdWq0_RHvgA@mail.gmail.com>
From:   Djalal Harouni <tixxdz@gmail.com>
Date:   Mon, 4 Apr 2022 09:44:59 +0200
Message-ID: <CAEiveUcx1KHoJ421Cv+52t=0U+Uy2VF51VC_zfTSftQ4wVYOPw@mail.gmail.com>
Subject: Re: [PATCH 00/18] bpf: Secure and authenticated preloading of eBPF programs
To:     KP Singh <kpsingh@kernel.org>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
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

On Sun, Apr 3, 2022 at 5:42 PM KP Singh <kpsingh@kernel.org> wrote:
>
> On Sat, Apr 2, 2022 at 1:55 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
...
> >
> > > Pinning
> > > them to unreachable inodes intuitively looked the
> > > way to go for achieving the stated goal.
> >
> > We can consider inodes in bpffs that are not unlinkable by root
> > in the future, but certainly not for this use case.
>
> Can this not be already done by adding a BPF_LSM program to the
> inode_unlink LSM hook?
>

Also, beside of the inode_unlink... and out of curiosity: making sysfs/bpffs/
readonly after pinning, then using bpf LSM hooks sb_mount|remount|unmount...
family combining bpf() LSM hook... isn't this enough to:
1. Restrict who can pin to bpffs without using a full MAC
2. Restrict who can delete or unmount bpf filesystem

?

-- 
https://djalal.opendz.org/
