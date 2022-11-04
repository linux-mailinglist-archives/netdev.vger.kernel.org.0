Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 776A161A4FA
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 23:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbiKDW7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 18:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiKDW66 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 18:58:58 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F89C2ED77;
        Fri,  4 Nov 2022 15:58:57 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id 21so9714815edv.3;
        Fri, 04 Nov 2022 15:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=M4zXUdcVCX3c23AicDOLlGTR/ORxR8Jao2PW3uoSzvs=;
        b=joyYSaSkOzgLUqD8oCmjd1bqKOhWeMIFy8SjMP4jr+7RxZRTkAexZmqY8JX7GRZ6ZR
         B6FG21OUGJkRrqfCvYO8M52jgqqRZA5vKrdGOzffKeDuPdRCmtUAB0YJSm/KgVDrH5Ch
         B9e3SXrh3Xd46V/aRq0vMSDSf4aYqa1lyTORaPaItPThrsmwjgRhDU/3AhjFrn6HnDvU
         jXs88GCamZKWtg97NeDQQ/EdKfqQ7+eQUXB22ZbAmeH80m81k7UunEyaVP0xf5K7LAU4
         /qmqgLo2e0h4dermmuacKWbWL+r6aHuLVgox1z90xhXBUM43ZGHzZdD0i06+MKkUqhQ+
         taXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M4zXUdcVCX3c23AicDOLlGTR/ORxR8Jao2PW3uoSzvs=;
        b=G5ufcIeXZ9TtlPHXc+Sd3GwXK5qCBTIInUiHI8qc740GyHg6mUkMyea/mkkH+XQEiw
         MrivVu6BJN6xHdv21MjdZVNUaEce28O2HnX3GvsaDe98DTTMCBVCgvU8/Fox9rXBZrj2
         C7FtB3+GfDxND5iAMRcoOFjxS1UaM/tiN84NgpR4zoEuDhcF+w41A4U+PJzcmRPMIiTu
         doalCJeNcmtHTqZe0l70wSEiiV4wsXtvbLvnxPwClYlsCXCz6l+f3udRlVKqY6FQF4Wy
         kieTpkUCOi2SrIKv1SwpUAQDM/2I+kaVRI9mQv9G1qqYouX1Q4J/VCnsL4aygG0KC1Rq
         59jQ==
X-Gm-Message-State: ACrzQf0ORc4AsTVYO4Xy3dKxoedNfPSxycROTEAGdunykGshjHmw7v3G
        IDYvuUeTHLcm4vbE0/xatoAAGhwr2ZsITZkkN8vtiI5YOuI=
X-Google-Smtp-Source: AMsMyM4252Wv0qS7bkwVSMftE60NOVkz2p8f1GS/al25RmX59Rdy7FYtodBbhhBqnPtlpZbhOtnWDxNULmEJz/rg3wY=
X-Received: by 2002:aa7:c504:0:b0:461:122b:882b with SMTP id
 o4-20020aa7c504000000b00461122b882bmr38785966edq.14.1667602735596; Fri, 04
 Nov 2022 15:58:55 -0700 (PDT)
MIME-Version: 1.0
References: <20221104094016.102049-1-asavkov@redhat.com> <CACYkzJ4E37F9iyPU0Qux4ZazHMxz0oV=dANOaDNZ4O8cuWVYhg@mail.gmail.com>
 <5e6b5345-fc44-b577-e379-cedfe3263066@iogearbox.net>
In-Reply-To: <5e6b5345-fc44-b577-e379-cedfe3263066@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 4 Nov 2022 15:58:43 -0700
Message-ID: <CAEf4BzZO+4znx4VzQ9LwzFXv0=NfQL4DKBZCGB36ojYNbRoCzQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: fix build-id for liburandom_read.so
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     KP Singh <kpsingh@kernel.org>, Artem Savkov <asavkov@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ykaliuta@redhat.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 4, 2022 at 10:38 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Hi Artem,
>
> On 11/4/22 2:29 PM, KP Singh wrote:
> > On Fri, Nov 4, 2022 at 10:41 AM Artem Savkov <asavkov@redhat.com> wrote:
> >>
> >> lld produces "fast" style build-ids by default, which is inconsistent
> >> with ld's "sha1" style. Explicitly specify build-id style to be "sha1"
> >> when linking liburandom_read.so the same way it is already done for
> >> urandom_read.
> >>
> >> Signed-off-by: Artem Savkov <asavkov@redhat.com>
> >
> > Acked-by: KP Singh <kpsingh@kernel.org>
> >
> > This was done in
> > https://lore.kernel.org/bpf/20200922232140.1994390-1-morbo@google.com
>
> When you say "fix", does it actually fix a failing test case or is it more
> of a cleanup to align liburandom_read build with urandom_read? From glancing
> at the code, we only check build id for urandom_read.

I reworded the subject to "selftests/bpf: Use consistent build-id type
for liburandom_read.so" and pushed. Thanks!

>
> Cheers,
> Daniel
