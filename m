Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3D0546A44
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 18:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349490AbiFJQVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 12:21:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242991AbiFJQU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 12:20:59 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35EB3392A0B;
        Fri, 10 Jun 2022 09:20:58 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id z7so35938510edm.13;
        Fri, 10 Jun 2022 09:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L4it2eyJHyN8t1fOMqjVlgvqQJ+rz5N7UVDB3nB9u44=;
        b=K50pcIsA+qwcFU9iH9P9p8e1nglHZJAOqtEakftPNdwSO2KzgxX4z+gbz8vSQU9fV8
         vz3g/9+5n4Z+lo0PTGSRt063uif4BRt2/AnKW5/it3n0o7BX4lZDNSmGyvcMixu4bfLr
         CBmd+6daJMpQOWH3Hu+YbWkOIkRJGIHVy9nmvqtMoWNB/6iK4jHgeONxWrgzrTF0ZwSQ
         TCvd3QTJqsO/4/sZKzDMKfbUWZtM+ycNJQpz6FrdGnPdTahuTwi/DoeKGOwOoyT6HSOG
         ZCelkPytaS/Wrx8JN8FBd6/R4fZrkl5939p7y2eCRQWsuFWvawK3NrzaCJ5cnSoHRRZj
         pzSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L4it2eyJHyN8t1fOMqjVlgvqQJ+rz5N7UVDB3nB9u44=;
        b=tfO6CtXsiy9NnqS1rCagoa/M6SZFzPgMW3GEiBDkZY1v7pKtnU2c8UFfPMOJSgxSM1
         HqVFW38z+YRcvGfbbjtqDB3wu/k2FWBL8uTwSwLHHHOHpU0bxaE2UUpmVjPIcplBGW0U
         d9t+SHGRW5erESscC2kPQf7KQIEcp6k+HVonvCQ+nDduAWGBIdpOgswjEezKfAgisq0r
         vyG+NYrj7Z3lposFiESQ6UXXvSv+SQlk1KZKnCL2GKvNzvj8DBrq/PU65l20887l7Q78
         ohIxgigO7rINXnJKbjO0Y1SMYY/jB2+dMKxeC9IPDzLeXLMoOSMvt9muJc1VWXxHmCr+
         1ClQ==
X-Gm-Message-State: AOAM533IpZe5haL/OqPCJntgK2Weg9/2t69tvPTyR6vKxePReri0Axl9
        s0j6W6fiN9tSNbDBBO026Wk8Ww67wtfko2ZaF6VKjOnDFm8=
X-Google-Smtp-Source: ABdhPJyfLZAobuekWBFHlpOaOs5JxtoWWf3vcfvczaZsS7370i2OnQVyszhKYnZqfsdDp1FfbvC8KFe9Q/atGTNyjr4=
X-Received: by 2002:a05:6402:120b:b0:42f:aa44:4d85 with SMTP id
 c11-20020a056402120b00b0042faa444d85mr42817903edw.338.1654878056591; Fri, 10
 Jun 2022 09:20:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220610135916.1285509-1-roberto.sassu@huawei.com> <20220610135916.1285509-2-roberto.sassu@huawei.com>
In-Reply-To: <20220610135916.1285509-2-roberto.sassu@huawei.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 10 Jun 2022 09:20:44 -0700
Message-ID: <CAADnVQLOWsqs1=MS=k2uJu01vNJzd9EZxtEwHW24t4+myj5s0w@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] bpf: Add bpf_verify_signature() helper
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        KP Singh <kpsingh@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel test robot <lkp@intel.com>
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

On Fri, Jun 10, 2022 at 6:59 AM Roberto Sassu <roberto.sassu@huawei.com> wrote:
>
> Since the maximum number of parameters of an eBPF helper is 5, the keyring
> and signature types share one (keyring ID: low 16 bits, signature type:
> high 16 bits).
...
> + * long bpf_verify_signature(u8 *data, u32 datalen, u8 *sig, u32 siglen, u32 info)
> + *     Description
> + *             Verify a signature of length *siglen* against the supplied data
> + *             with length *datalen*. *info* contains the keyring identifier
> + *             (low 16 bits) and the signature type (high 16 bits). The keyring
> + *             identifier can have the following values (some defined in
> + *             verification.h): 0 for the primary keyring (immutable keyring of
> + *             system keys); 1 for both the primary and secondary keyring
> + *             (where keys can be added only if they are vouched for by
> + *             existing keys in those keyrings); 2 for the platform keyring
> + *             (primarily used by the integrity subsystem to verify a kexec'ed
> + *             kerned image and, possibly, the initramfs signature); 0xffff for
> + *             the session keyring (for testing purposes).

Muxing all kinds of info in the 5th arg isn't great.
It's better to use dynptr here for data and sig.
It will free up two extra arguments.
