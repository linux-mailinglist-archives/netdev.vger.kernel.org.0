Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0F614BAC63
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 23:13:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243494AbiBQWNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 17:13:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236932AbiBQWNY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 17:13:24 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C248163D6C;
        Thu, 17 Feb 2022 14:13:08 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id p11so3338371ils.1;
        Thu, 17 Feb 2022 14:13:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=oW3oacCSolQicKseeAG5PkN02cvbzOPFXjUjp8Wdp08=;
        b=gsbEfSWkkdwCuYgy8kOkju7Ab3XBYjM67zpBHKcKhVlFPVjglfwUGd8MmRtjvyTvPq
         zbt0EuGUaJMTZ056UtatCNKEn82bBWSEVVAdjFfVzK40AYeBqz7GTHpUw6Iqw2MMSsH2
         KedRrbXV6t087LkcuYtp+YFIJM4HW9pKKSeK7812ZYFPWd1ns2esUkerTl6gvmz2w7RA
         EB6r2xWPA7zL+pwdSccQC4lq39o0lbLDExEfzg0hHJFQ4r8FdcycK1/fbM5WOml9MNw/
         YpcERk/GXo6Vkb/EIj2u/szaAM1tP7XEi8XEkPmSlOf7hh8uokY99O8oPcJ89+AIDSnu
         O03g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=oW3oacCSolQicKseeAG5PkN02cvbzOPFXjUjp8Wdp08=;
        b=LV/0yVu2xXAIC/qD9OGFwh8phfLG7nBVK406TJAQl9gxR8MAIrqhzQdrZMTKil1tZd
         +Cry5CdWADe0D00qA0hIC9Gg0ohBUV94zobOmLBjcXpGRxJ/8Bxv41nNRNuE75ColIDw
         p35XNpHpPUjfzfjRuZ92TFvG7dp2YUdZg7BQWR+Obo23Eq8yM2z1lp4CBjm11cQ0V3w5
         14kwyxbkEKNdSlesdXq5P/8eLT/1hkvDLSu303SB6KPoLV0Ov5vS1/gxdvLaqd9vgTqn
         JVoVw0mSOk9mBbXpTjmEivuyGZFBAbwI52xWZ6EElsDXlNVkOBE3piFjQDP+tLpGxWCt
         eZ8w==
X-Gm-Message-State: AOAM530EBKzdtpq5Iqo4Lfjyb/emAYDPt1tmbgquYsQJvWO9fDTMZrN4
        t4vf9RQDg17crh7mDBEYomgAORJgc7LqEhzmvyA=
X-Google-Smtp-Source: ABdhPJyTMky6ClBhpQWEJePhwkeD9uDP0ye6F1NXQvUH7XGAIYLOnf//5a7DUlT+U3oVK+gVp0R2CPN5Fsi6BA5HQA0=
X-Received: by 2002:a05:6e02:1a88:b0:2be:a472:90d9 with SMTP id
 k8-20020a056e021a8800b002bea47290d9mr3412199ilv.239.1645135986775; Thu, 17
 Feb 2022 14:13:06 -0800 (PST)
MIME-Version: 1.0
References: <20220215225856.671072-1-mauricio@kinvolk.io> <CAEf4BzbxcoP8hoHM_1+QX4Nx=F0NPkc-CXDq=H_JkQfc9PAzLQ@mail.gmail.com>
 <CAHap4zuD4ei9XT-+L0tjah_nG0n1o+wAkdV_HMBM23SErg8CWA@mail.gmail.com>
In-Reply-To: <CAHap4zuD4ei9XT-+L0tjah_nG0n1o+wAkdV_HMBM23SErg8CWA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 17 Feb 2022 14:12:55 -0800
Message-ID: <CAEf4BzamC_ybxPUfeGkksTwamDvNVg6xZLHNXx68k+P5oZ1tEQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 0/7] libbpf: Implement BTFGen
To:     =?UTF-8?Q?Mauricio_V=C3=A1squez_Bernal?= <mauricio@kinvolk.io>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 17, 2022 at 2:07 PM Mauricio V=C3=A1squez Bernal
<mauricio@kinvolk.io> wrote:
>
> >
> > Fixed up few things I pointed out in respective patches. Applied to
> > bpf-next. Great work, congrats!
>
> Thanks a lot for all your patience and helpful reviews!
>
> >
> > It would be great as a next step to add this as (probably optional at
> > first) step for libbpf-tools in BCC repo, so that those CO-RE-based
> > tools can be used much more widely than today.
>
> I like this idea. It'll also help us to understand and improve the way
> to ship those files within the application.
>
> > How much work that
> > would be, do you think?
>
> Probably the most difficult part is to embed the generated files into
> the executable. I think generating a header file with the BTF info for
> each tool and some helpers to extract it at runtime according to the
> kernel version should work.

It probably would be one header file reused by all tools and then a
set of helpers to fetch those BTFs based on host distro/kernel combo.

>
> > And how slow would it be to download all those
> > BTFs and run min_core_btf on all of them?
>
> The whole thing takes like 5 minutes on my system (AMD Ryzen 7 3700X
> with 60mbps connection), given that almost 3 minutes are spent
> downloading the files I'd say that with a fast connection and some
> performance improvements (multicore?) it could take around 2~3
> minutes.
>
> Let me think better about this integration and will be back with some ide=
as.

Sounds good, thanks!
