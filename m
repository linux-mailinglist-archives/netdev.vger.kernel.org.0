Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46DB5233B70
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 00:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730270AbgG3WiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 18:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728785AbgG3WiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 18:38:09 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C57C061575
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 15:38:08 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id lx9so5916475pjb.2
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 15:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G/tH2obDhOAeb9AFFbuoPCMXYIQU9maJaUQmRmpTfUo=;
        b=AuWCFZU71DHpVB6oOERjqFXvHMISxWOrX2yzPAFFs6ziS2ntJAE/Iu9YXxg55HK8oC
         RCizC+p7A5NojVnmquEmDaZlPNaBrkJ7CPUV9eaU/qat7QwzJ3dhbMmHAwNr3ke0aCy3
         pl2eusHKTc3zUGL+bjJf65/Pay19Xu/+xjLIFpvj8yVtEPpsIsy9XqSpGHKG6OhDmr2Y
         SGGdjq/kN4HHGkyqBqRzJxpQWwTiLrosfMANiuBkGL79TvmttThwStt+sIPEiiuuU7+C
         DUyRWe4k0BCrcHMyskmOEWSNF06DcNgSzvYIZPi4CVfJ1P/3jWbnXCFCW3FZ4BW07YFa
         lUTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G/tH2obDhOAeb9AFFbuoPCMXYIQU9maJaUQmRmpTfUo=;
        b=HWJcw7nhMsyv2IPQtA5nAfVrawcW71moJoO501bsLI35I6VArKxyNEjiKdNrdUFZUP
         xx1tRdR9mxVdMkL5ppfOdkZinp9JILbjLt442XeJk14EF1rSzdUxzgx5YLxG1Hhojf0l
         ZuVdwCyoUiPTrCr+5t/yzhIZ/OEwBG4XQLMJJtpRXBKjYflCojZzfoVM3dSMYrCVmTVf
         Z39ljb7oYM4NZRB2bFYSdD99J4s/AHZM5N4GjYhmjdRaStuAU0iVvMXX4hjyVIxDQYm0
         7m0R59EGVqJMa1JgbJi/3Kz/bxRB94aUytREDFeUYqzy8KqXr0uboVTcO5/p+7A5xWWS
         wzvQ==
X-Gm-Message-State: AOAM530OymKL0mGyOF1U7Diz64Dn2j1XFSRTeToRdnLJFz1/MG6ZuE9y
        c77ARE4kAIpPantNTJ48MbB7Y9IYxnMqw6fODCh5RA==
X-Google-Smtp-Source: ABdhPJw1mdmYhTwcHCzcUrT7+xVlCTKS2/woVPdTE10B6OPbS3JXL0HHCdSgIH3aXAuwIpUTZgDHWSZliMRreSrTF+U=
X-Received: by 2002:a63:7d8:: with SMTP id 207mr999664pgh.263.1596148687990;
 Thu, 30 Jul 2020 15:38:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200708230402.1644819-1-ndesaulniers@google.com>
 <CAKwvOdmXtFo8YoNd7pgBnTQEwTZw0nGx-LypDiFKRR_HzZm9aA@mail.gmail.com>
 <CAKwvOdkGmgdh6-4VRUGkd1KRC-PgFcGwP5vKJvO9Oj3cB_Qh6Q@mail.gmail.com> <20200720.163458.475401930020484350.davem@davemloft.net>
In-Reply-To: <20200720.163458.475401930020484350.davem@davemloft.net>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 30 Jul 2020 15:37:56 -0700
Message-ID: <CAKwvOdmU+Eh0BF+o4yqSBFRXkokLOzvy-Qni27DcXOSKv5KOtQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/2 net] bitfield.h cleanups
To:     David Miller <davem@davemloft.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, oss-drivers@netronome.com,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Alex Elder <elder@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 20, 2020 at 4:35 PM David Miller <davem@davemloft.net> wrote:
>
> From: Nick Desaulniers <ndesaulniers@google.com>
> Date: Mon, 20 Jul 2020 12:48:38 -0700
>
> > Hi David, bumping for review.
>
> If it's not active in my networking patchwork you can't just bump your original
> submission like this.
>
> You have to submit your series entirely again.
>
> And if it is in patchwork, such "bumping" is %100 unnecessary.  It's
> in my queue, it is not lost, and I will process it when I have the
> time.
>
> Thank you.

Hi David,
Sorry, I'm not familiar with your workflow.  By patchwork, are you
referring to patchwork.ozlabs.org?  If so, I guess filtering on
Delegate=davem
(https://patchwork.ozlabs.org/project/netdev/list/?series=&submitter=&state=&q=&archive=&delegate=34)
is your queue?  I don't see my patches in the above query, but I do
see my series here:
https://patchwork.ozlabs.org/project/netdev/list/?series=188486&state=*
but they're marked "Not Applicable".  What does that mean?
-- 
Thanks,
~Nick Desaulniers
