Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A12B401E9F
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 18:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244298AbhIFQlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 12:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244198AbhIFQlP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Sep 2021 12:41:15 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86519C061575
        for <netdev@vger.kernel.org>; Mon,  6 Sep 2021 09:40:10 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id y6so12215275lje.2
        for <netdev@vger.kernel.org>; Mon, 06 Sep 2021 09:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kLGf+W5qZqIzs5xlBDQY6TASgcg+cDCU3+/hIp0WRSQ=;
        b=ZCv1Na58AgWFZ2iFATqhgehgaulyIV7J7ag0K8Y9oyChAGugX3AoStVPklc7w2OhPg
         W03/VpXx+xSMtO3MUalYb4qSLNbZUwmaR3J8n/O/fkWtK7HCB3hzAJVF5L9bMY1r5a5N
         giv5P0l+F0rwry5bA3jbyOOZV7JY1km7V1UkI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kLGf+W5qZqIzs5xlBDQY6TASgcg+cDCU3+/hIp0WRSQ=;
        b=CWyjoQVx/s+Gs4Ia3A/j6YIaWkAbyV0vWYgKFHkiqm3ew00yu+djvWakY0S0LFHfCt
         H96XCXI9kfayNCCHBNyrqbet89VVNlXWyZF4zXOnPXvg7HSAjTdjBrK5B0dMRUTEQYZl
         rnnpum3Bj2+sJe0p5BF/jwdoEPtPHBae/DHzH70CAttRsIr+bF2llcrwpk4BXfFZzrgS
         WX49Z6VtEqddY1YiLPIJdjsir5FnIZiTz1ybSMHx5TNrR0bpSsI8lQI6K2KNxWWvW9X0
         aGBS3bUOCpCYh5ZwfKnuhDqnXGTy2dy3CKYGcDFSIf2RN9gsMOqKqpxHnYYG8tJYzbfS
         qNaw==
X-Gm-Message-State: AOAM5314moJPNNRWikXbAXQBawzos2W0ABG6v6KeXlvaZBGaF4eevEIr
        +NVs2VM4qr9acCKomJn9TK4wEfDI5QEgnt6qH8o=
X-Google-Smtp-Source: ABdhPJyR7C8hBIjdBOPkGWq3klHyVzuIBTHagMx2yd4FZO2jGA09DT+2wgS30zazKoRaAYW8Gr2gUA==
X-Received: by 2002:a2e:8109:: with SMTP id d9mr11270415ljg.495.1630946408734;
        Mon, 06 Sep 2021 09:40:08 -0700 (PDT)
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com. [209.85.208.169])
        by smtp.gmail.com with ESMTPSA id d8sm784526lfm.67.2021.09.06.09.40.07
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Sep 2021 09:40:07 -0700 (PDT)
Received: by mail-lj1-f169.google.com with SMTP id j12so12170515ljg.10
        for <netdev@vger.kernel.org>; Mon, 06 Sep 2021 09:40:07 -0700 (PDT)
X-Received: by 2002:a2e:a7d0:: with SMTP id x16mr11178044ljp.494.1630946407467;
 Mon, 06 Sep 2021 09:40:07 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYsV7sTfaefGj3bpkvVdRQUeiWCVRiu6ovjtM=qri-HJ8g@mail.gmail.com>
In-Reply-To: <CA+G9fYsV7sTfaefGj3bpkvVdRQUeiWCVRiu6ovjtM=qri-HJ8g@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 6 Sep 2021 09:39:51 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjJ-nr87H_o8y=Gx=DJYPTkxtXz_c=pj_GNdL+XRUMNgQ@mail.gmail.com>
Message-ID: <CAHk-=wjJ-nr87H_o8y=Gx=DJYPTkxtXz_c=pj_GNdL+XRUMNgQ@mail.gmail.com>
Subject: Re: bridge.c:157:11: error: variable 'err' is used uninitialized
 whenever 'if' condition is false
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Vlad Buslov <vladbu@nvidia.com>
Cc:     open list <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        lkft-triage@lists.linaro.org, Netdev <netdev@vger.kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 6, 2021 at 2:11 AM Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c:157:11: error:
> variable 'err' is used uninitialized whenever 'if' condition is false

That compiler warning (now error) seems to be entirely valid.

That's a

    if (..)
    else if (..)

and if neither are valid then the code will return an uninitialized 'err'.

It's possible the two conditionals are guaranteed to cover all cases,
but as the compiler says, in that case the "if" in the else clause is
pointless and should be removed.

But it does look like 'ret' should probably just be initialized to 0.

              Linus
