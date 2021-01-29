Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA1D309077
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 00:16:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbhA2XLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 18:11:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbhA2XLp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 18:11:45 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BC58C061573;
        Fri, 29 Jan 2021 15:11:05 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id c4so7700363wru.9;
        Fri, 29 Jan 2021 15:11:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7bo5/yH1rA/wIoSilYgaODeN+ji5a8p7X+2AkN2Fzg8=;
        b=JLkP136iKIXJN3ASX2RQcjejkXZYumYfa4HfVk8ZMUqwovL6J6g3Txp+gd7/5ki8l9
         SK6uW48f2TLPdE7sCuzggo5/QKi+ryAzeXsdX7keF2j/+krf2T8CfsOBxs2vyPTCCuSC
         /rPxekPWOnYSnPhJ7uCKA1t8BVqzJBuDL8NBthSsaAZ5euqF2xO3zfZrgNb0vu68IK+/
         dsgsQGViLnwGx5vn6TRrOM3XUONymgPAHQqbuoEmbF6ojMQJ8SQUbAd4BmjNaKa6UFkv
         ubcenlX/WmTHT/ZQY/IRQUAA/f2azannozoJ9Ov7UwKgxfYcKtPJ8tyWOqZm8bshSEDV
         6oiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7bo5/yH1rA/wIoSilYgaODeN+ji5a8p7X+2AkN2Fzg8=;
        b=i77WvbFRPSchmFZJClQQPMnXYiICBKssLs0Grr+PdWzaFEDd0Xh8ySuvAjBDE0Zw8r
         lw/mH3jwsj9v7xUjYxJzeL0dhQYB+J/v3nUDKBvBdA6G5S1jTVjf5VkepXIeYwMusX6o
         eGJOR9cyc9RPVnzuUuTCCsr2x4GtZYxV1QNUE03FQWNnnGnCft6rJk/Fbsgoe/O0UqdW
         rCHp5r5kNXS96PVXVa7H8g66Ag5HnG2fOskIwjubyMRTx0f7LXZ1PMhlzypJX/aVcgXA
         Ye3aG9PuqgGIQ4i1k9FZ0MzKtTNr0vQkTW90lmYHMt2ViLmA10XrELLVh/ER5mN9FkN9
         waMg==
X-Gm-Message-State: AOAM532M2ucnCGrVu/sqRqSP0MXHg17x8fBwGfLGvmH2LEq1ZmQzyD/Y
        SmfsVlQ/rVqCSKGZt/Lzc7jPyTu3yyKgvOl9BsM=
X-Google-Smtp-Source: ABdhPJxBDa376aaGpTbqxAgeNkFQMKvxGK45sOXO6S8pPM4LKOc2jxyK2p5rbm0rgdax0i6McKKSTu+1fLY0Iy9hrGY=
X-Received: by 2002:a5d:60c6:: with SMTP id x6mr6799669wrt.85.1611961864151;
 Fri, 29 Jan 2021 15:11:04 -0800 (PST)
MIME-Version: 1.0
References: <20210129195240.31871-1-TheSven73@gmail.com> <20210129195240.31871-3-TheSven73@gmail.com>
 <CAF=yD-KBc=1SvpLET_NKjdaCTUP4r6P9hRU8QteBkw6W3qeP_A@mail.gmail.com>
 <CAGngYiW-omAi4cpXExX5aRNGTO-LX4kb6bnS7Q=JfBvYV55QCQ@mail.gmail.com> <CAF=yD-JaD3oO6r0sGp7t5t3TLxUpi8a4jzX04MSfxrPBWuj0gA@mail.gmail.com>
In-Reply-To: <CAF=yD-JaD3oO6r0sGp7t5t3TLxUpi8a4jzX04MSfxrPBWuj0gA@mail.gmail.com>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Fri, 29 Jan 2021 18:10:53 -0500
Message-ID: <CAGngYiVRTj4i=2LcQZPutZkFsEgd6Y-YYe9ggMw2pPOTxRBUEQ@mail.gmail.com>
Subject: Re: [PATCH net-next v1 2/6] lan743x: support rx multi-buffer packets
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Alexey Denisov <rtgbnm@gmail.com>,
        Sergej Bauer <sbauer@blackbox.su>,
        Tim Harvey <tharvey@gateworks.com>,
        =?UTF-8?Q?Anders_R=C3=B8nningen?= <anders@ronningen.priv.no>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 29, 2021 at 6:08 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> Okay. I found it a bit hard to parse how much true code change was
> mixed in with just reindenting existing code. If a lot, then no need
> to split of the code refactor.

Thank you. The code is quite hard to review in patch format.
Probably easier to apply the patch first, then read the replaced
function.
