Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D59E54FBE1
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 19:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382923AbiFQRHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 13:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382891AbiFQRHE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 13:07:04 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17DFA24BFF;
        Fri, 17 Jun 2022 10:07:03 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id u12so9907088eja.8;
        Fri, 17 Jun 2022 10:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Kzy5eGCbr6f18ypDB7MvrF9DPS0nn/SHTUhj0XAiEdI=;
        b=LSa+fMtdQerlOGeqtUY3stk0s2SQSieL6Szi8MmoJdPq13rupg8ol8Cba7pLgldSxp
         tae4DBuz9BsuR9agzR0JIewsq+x9udV/JlzCZf80eZgJCj8uViDYNdrtwoR1xYkyBznO
         p5qsXER5s0XMtBv52ZlD4gzmv7DXDifUBswmiPYNKSadIVZNbsyxhRUBU6VTJlk8fht5
         NrPCL4Gobfx6lm7rlQTbK0U93jA4XqfEn31N+ueP05Ajm6NvFD5n8mW23bvdGy3mm6hl
         BnaTcMZUusUa7osm21PAamjUY4EKj+YGbkGe/rMxVD7U1V6yPZDayx3fpbbNVkcMezf9
         1l+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kzy5eGCbr6f18ypDB7MvrF9DPS0nn/SHTUhj0XAiEdI=;
        b=UYsD2CqUvTzYW8HCn0LBAlCX0qlTXOloniy3aGtS2o7tqrbRsJYmjo6J9CzrHQqMgZ
         66wdAZq3I2KjOPTN12RWKETlASAdn6AbjAiiWbnBxjBMYX3dcJyz3yuv+O/MFnAOBNDO
         6kAZ0lQJ/cfq9JmB9gThrMewh0YSvd9L0vajof3DxYVujqxkV5+yeNdtuSH5sriZIF+A
         T8yYbYEgt9wrpZgqjrzpo+20Mk7CY5oNuYUK2ac8n33lPZOEo+guflDeUQ9pQWB+8nL0
         9KwmPD7nyHguLX6Ly3iRs3fynAvAtyR25mbkZjbsTHWDtPHD8cLNiC1m9LVdCDOR90+q
         8gfg==
X-Gm-Message-State: AJIora9Es2bF8UrMnv0+dP/x1jm+yDsrXqnWoB/rSUPqc8YfB95tvSWK
        V6geVPZBR5weam4/jp2B3tBGtxAOvz9U2rPMFvY=
X-Google-Smtp-Source: AGRyM1sr0V5BczPcq0Mm9GUKXXFAWmbSI5HBGzSLNTHSR9s3tMADbaw5NkB97OiUiay/4nTE4h0NG4rIRVOKD6pNBdw=
X-Received: by 2002:a17:906:449:b0:711:c975:cfb8 with SMTP id
 e9-20020a170906044900b00711c975cfb8mr10460835eja.58.1655485621509; Fri, 17
 Jun 2022 10:07:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220614130621.1976089-1-roberto.sassu@huawei.com>
 <20220614130621.1976089-3-roberto.sassu@huawei.com> <20220617034617.db23phfavuhqx4vi@MacBook-Pro-3.local>
 <b146ee9242cb4c128e56bc9cb3b20b26@huawei.com>
In-Reply-To: <b146ee9242cb4c128e56bc9cb3b20b26@huawei.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 17 Jun 2022 10:06:49 -0700
Message-ID: <CAADnVQL+hBsWaKJAVYT0OX4SZtVDO+rRZ-0OLq+3SaPQsGqLBg@mail.gmail.com>
Subject: Re: [RESEND][PATCH v4 2/4] bpf: Add bpf_request_key_by_id() helper
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "kafai@fb.com" <kafai@fb.com>, "yhs@fb.com" <yhs@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "dhowells@redhat.com" <dhowells@redhat.com>
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

On Fri, Jun 17, 2022 at 2:11 AM Roberto Sassu <roberto.sassu@huawei.com> wrote:
>
> > From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> > Sent: Friday, June 17, 2022 5:46 AM
>
> Adding in CC the keyring mailing list and David.
>
> Sort summary: we are adding an eBPF helper, to let eBPF programs
> verify PKCS#7 signatures. The helper simply calls verify_pkcs7_signature().
>
> The problem is how to pass the key for verification.
>
> For hardcoded keyring IDs, it is easy, pass 0, 1 or 2 for respectively
> the built-in, secondary and platform keyring.
>
> If you want to pass another keyring, you need to do a lookup,
> which returns a key with reference count increased.
>
> While in the kernel you can call key_put() to decrease the
> reference count, that is not guaranteed with an eBPF program,
> if the developer forgets about it. What probably is necessary,
> is to add the capability to the verifier to check whether the
> reference count is decreased, or adding a callback mechanism
> to call automatically key_put() when the eBPF program is
> terminated.

Nothing special here.
See acquire/release logic in the verifier and relevant helpers.
Like bpf_sk_lookup_tcp and others.

> Is there an alternative solution?
>
> Thanks
>
> Roberto
>
> HUAWEI TECHNOLOGIES Duesseldorf GmbH,
> HRB 56063 Managing Director: Li Peng, Yang Xi, Li He

Please remove this footer from your emails.
