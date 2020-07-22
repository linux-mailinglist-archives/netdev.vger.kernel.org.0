Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF80322988A
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 14:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732390AbgGVMu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 08:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732250AbgGVMu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 08:50:28 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35F6BC0619DE
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 05:50:28 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id s16so1674587qtn.7
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 05:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V+el/4IjxY5c/A2Xkjehcvj/Zw3lDkjmnm4fPzj7FEY=;
        b=K5CLDhMO8VOhCWsQmJTWzgBr8pNoz9/g9XoMr2GBxhc4faqvibRjSC7ijhfd0rj4Or
         EAh4KUB+a8SDhfvg2DstycRIHsTbwwOUwrLyIwBC77KG0mWVNaca++DEe3Do+NQS9tAK
         rJh4ulyrFi3MypW6toTUSRapLAxXFRZVnfbivL42DORirSSCTkq8ztYBSa9mwppHubMx
         uasntbPhG1oeuxsz4lYhUVcTP3gvoH1kWTz4h6ozQDe6asb7eC//LcxUvXVwRSZtxfoA
         BkEWy3oWL114hJC06FQLhFbRuMtBkc1lBfEiihWT1tMOAdE+6JtzE6qLS49NkhBjmJ4t
         oh/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V+el/4IjxY5c/A2Xkjehcvj/Zw3lDkjmnm4fPzj7FEY=;
        b=eKu/T9QRRtQlX/o0FwY+87O/uqueaWiQ8ayGNpdP0KaPlmzl6ZCRALxDl+U1/Wy10R
         FjTliak0XuQunEtbufa65cQw7xTFXnRtoZRbUFhHwRm1FW2GuMD04AUSZ/ZC37+PJtXk
         JeK6mSW1qgGDLPS4HGUh/+/aOvdCMyHR0ko11hLhXSLKF0JQEjqxh5BmYU3ETcNf0HWm
         TdG6v3q4MijA3mDn19ZNTsuzDqGu4pCRZCe0fT6VJ9xX/XmdaQSBUafph42xC2Jf8aK8
         5lOcWgEQD85nCtw5hK0z6ZapBX5G+iayStWx4oJAIl9wi4DV6OMmYDCFOe7s9yjJUFAu
         t8Dg==
X-Gm-Message-State: AOAM530eDsZAZV0FZTgfYKchwvkip3WSDg8/HbRE5+cUkik7MMxLid+x
        J1ksclAovlkCWpdp505BLgOLU8bn
X-Google-Smtp-Source: ABdhPJz1AHiaHOu5BNj0eGGi7sQDgEscJYlGBDmmtAZptdgjXltBTilQAllEOaBe5AxqcI89/vcnNw==
X-Received: by 2002:ac8:197b:: with SMTP id g56mr33699398qtk.105.1595422226314;
        Wed, 22 Jul 2020 05:50:26 -0700 (PDT)
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com. [209.85.219.170])
        by smtp.gmail.com with ESMTPSA id x3sm5360250qkd.62.2020.07.22.05.50.24
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2020 05:50:25 -0700 (PDT)
Received: by mail-yb1-f170.google.com with SMTP id x9so960862ybd.4
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 05:50:24 -0700 (PDT)
X-Received: by 2002:a25:cc4e:: with SMTP id l75mr50937615ybf.165.1595422224171;
 Wed, 22 Jul 2020 05:50:24 -0700 (PDT)
MIME-Version: 1.0
References: <CA+FuTSeN8SONXySGys8b2EtTqJmHDKw1XVoDte0vzUPg=yuH5g@mail.gmail.com>
 <20200721161710.80797-1-paolo.pisati@canonical.com> <CA+FuTSe1-ZEC5xEXXbT=cbN6eAK1NXXKJ3f2Gz_v3gQyh2SkjA@mail.gmail.com>
 <CAMsH0TTQnPGrXci3WvjM+8sdJdxOjR9MnwFvv4DS6=crMCAt4A@mail.gmail.com>
In-Reply-To: <CAMsH0TTQnPGrXci3WvjM+8sdJdxOjR9MnwFvv4DS6=crMCAt4A@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 22 Jul 2020 08:49:47 -0400
X-Gmail-Original-Message-ID: <CA+FuTSc0V4TGMF6KhZVkLfv1=OXXdV+J3ufKuXd0GhrHb2hjbw@mail.gmail.com>
Message-ID: <CA+FuTSc0V4TGMF6KhZVkLfv1=OXXdV+J3ufKuXd0GhrHb2hjbw@mail.gmail.com>
Subject: Re: [PATCH v2] selftest: txtimestamp: fix net ns entry logic
To:     Paolo Pisati <paolo.pisati@canonical.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, Jian Yang <jianyang@google.com>,
        Network Development <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 22, 2020 at 4:37 AM Paolo Pisati <paolo.pisati@canonical.com> wrote:
>
> On Tue, Jul 21, 2020 at 6:26 PM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > Fixes: cda261f421ba ("selftests: add txtimestamp kselftest")
> >
> > Acked-by: Willem de Bruijn <willemb@google.com>
>
> Besides, is it just me or this test fails frequently? I've been
> running it on 5.4.x, 5.7.x and 5.8-rcX and it often fails:
>
> ...
>     USR: 1595405084 s 947366 us (seq=0, len=0)
>     SND: 1595405084 s 948686 us (seq=9, len=10)  (USR +1319 us)
> ERROR: 6542 us expected between 6000 and 6500
>     ACK: 1595405084 s 953908 us (seq=9, len=10)  (USR +6541 us)
>     USR: 1595405084 s 997979 us (seq=0, len=0)
>     SND: 1595405084 s 999101 us (seq=19, len=10)  (USR +1121 us)
>     ACK: 1595405085 s 4438 us (seq=19, len=10)  (USR +6458 us)
>     USR: 1595405085 s 49317 us (seq=0, len=0)
>     SND: 1595405085 s 50680 us (seq=29, len=10)  (USR +1363 us)
> ERROR: 6661 us expected between 6000 and 6500
>     ACK: 1595405085 s 55978 us (seq=29, len=10)  (USR +6661 us)
>     USR: 1595405085 s 101049 us (seq=0, len=0)
>     SND: 1595405085 s 102342 us (seq=39, len=10)  (USR +1293 us)
> ERROR: 6578 us expected between 6000 and 6500
>     ACK: 1595405085 s 107627 us (seq=39, len=10)  (USR +6577 us)
>     USR-SND: count=4, avg=1274 us, min=1121 us, max=1363 us
>     USR-ACK: count=4, avg=6559 us, min=6458 us, max=6661 us
>
>
> In particular, "run_test_v4v6 ${args}       # tcp" is the most
> susceptible to failures (though i've seen the udp variant fail too).

Not for me. The interval bounds have been set as is based on previous
experience.

Are you running it inside a VM? Especially qemu without kvm
acceleration could increase jitter.

The reports are not far outside the bounds. They can be extended a bit
if that considerably reduces flakiness.
