Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5032F72F7
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 07:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727526AbhAOGi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 01:38:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726702AbhAOGi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 01:38:26 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35E01C061575;
        Thu, 14 Jan 2021 22:37:46 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id b26so11645533lff.9;
        Thu, 14 Jan 2021 22:37:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s1mbu/iDvg0S/w5H3WYo563saE6wyNYHIXZ0CDDBwc4=;
        b=YNdT7A1J6LctPIu7wKlqAgDbAiqlbbkHjKP0/wUQ0AkBKiUv1yeI1dzvYjgM29Z9Xg
         FSqsz3Ictn35F3sdehAm4xX2q/7SM8mcSZbLPRW1ELAViV4PceHj60EfektVip8w7hBL
         SxOKGiy1VZRR639Xcq27MmmkhZkaKOG7d8137nTFp3OWq7cnvDrI03VyFifnO4Py2VK2
         BWyDYVUHMaV6EKw/6TJ/Qgf8EAKtc9IoKd4KMPU/y7qGy3iBD+K4OYg/F92SFqHDS04I
         PGxFxk/eZXbQ2+t2iYqTzwTNOVRK+nN1o0+t/TxWEC1hvJZ54xuNxPrv6zBWT8/TFQOz
         cKcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s1mbu/iDvg0S/w5H3WYo563saE6wyNYHIXZ0CDDBwc4=;
        b=IT7hvuID8XGuQwZthowYKygJqkaSOjCJ/XPQzb/tNMuqGysUv8TChLEI0qqc9j1/ZS
         qRZbNOtw2WWj/SD9zcgXyno/CtysbVRBQGuaGPnbE49cQpuW2Nni8BwBrSWf8JTG3538
         /80uOTHYNQMKBKkNjECHpMoqR+EXrCysOOVLchl2BRZq37ac+OKfxiDqbECBdxXO9vH0
         vaAKWForrymrjiQMqu0PqnPSrTxrFma5cAxbUany2Wf9cncX+x7ymSP/gbnS1t21aThL
         H9xOIQbW0oFwxWYaIcA+RYZ2yPCzqg+7MgMLl6r39A4NHLnEIM7jdqGp3mI+DMy4chk/
         B1pQ==
X-Gm-Message-State: AOAM532fO6bt0gBZOmREyPDWNxv9woKRIPcF403ns5o3MZq6a8hi72oO
        3qy/KdlOf+o3/WhW9M0FRP8wwdAY9B/m+EJhF8g=
X-Google-Smtp-Source: ABdhPJxQuDYFYDdckZMJ6RsjOaom8fTkJZ62NISStWOy2bu/+WLpAIiFVId8hBWU1hx6DeKRistOTXxeQOoQFJ2F3Mc=
X-Received: by 2002:a05:6512:34c5:: with SMTP id w5mr5061312lfr.214.1610692664735;
 Thu, 14 Jan 2021 22:37:44 -0800 (PST)
MIME-Version: 1.0
References: <20210114095411.20903-1-glin@suse.com> <20210114095411.20903-2-glin@suse.com>
In-Reply-To: <20210114095411.20903-2-glin@suse.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 14 Jan 2021 22:37:33 -0800
Message-ID: <CAADnVQJiK3BWLr5LRhThUySC=6VyiP=tt3ttiyZPHGLmoU4jDg@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] bpf,x64: pad NOPs to make images converge more easily
To:     Gary Lin <glin@suse.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        andreas.taschner@suse.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 1:54 AM Gary Lin <glin@suse.com> wrote:
>          * pass to emit the final image.
>          */
> -       for (pass = 0; pass < 20 || image; pass++) {
> -               proglen = do_jit(prog, addrs, image, oldproglen, &ctx);
> +       for (pass = 0; pass < MAX_PASSES || image; pass++) {
> +               if (!padding && pass >= PADDING_PASSES)
> +                       padding = true;
> +               proglen = do_jit(prog, addrs, image, oldproglen, &ctx, padding);

I'm struggling to reconcile the discussion we had before holidays with
the discussion you guys had in v2:

>> What is the rationale for the latter when JIT is called again for subprog to fill in relative
>> call locations?
>>
> Hmmmm, my thinking was that we only enable padding for those programs
> which are already padded before. But, you're right. For the programs
> converging without padding, enabling padding won't change the final
> image, so it's safe to always set "padding" to true for the extra pass.
>
> Will remove the "padded" flag in v3.

I'm not following why "enabling padding won't change the final image"
is correct.
Say the subprog image converges without padding.
Then for subprog we call JIT again.
Now extra_pass==true and padding==true.
The JITed image will be different.
The test in patch 3 should have caught it, but it didn't,
because it checks for a subprog that needed padding.
The extra_pass needs to emit insns exactly in the right spots.
Otherwise jump targets will be incorrect.
The saved addrs[] array is crucial.
If extra_pass emits different things the instruction starts won't align
to places where addrs[] expects them to be.

So I think the padded flag has to be part of x64_jit_data.
Please double check my analysis and see why your test keeps working.
And please add another test that crashes with this v3 and works when
'padding' is saved.
I expected at least some tests in test_progs to be crashing, but
I've applied patch 1 and run the tests manually and everything passed,
so I could be missing something or our test coverage for subprogs is too weak.
