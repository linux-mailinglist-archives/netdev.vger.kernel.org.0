Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73A8B15513
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 22:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbfEFUv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 16:51:29 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:35847 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbfEFUv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 16:51:29 -0400
Received: by mail-ed1-f68.google.com with SMTP id a8so16677617edx.3;
        Mon, 06 May 2019 13:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Bsvy77V2BabW+yLUp1HGYQuE0fTStgpoE1+/qytzq1s=;
        b=Gdi526GL5SLBSrFzSNH2cZhQTQcqkwWSKruwyg5I24oUNCSjXjBGiy1p6rR8+LPVQ3
         rC5k6Wo1AdZuWVwM20IdXb14YnLjmupTiDHkVm1xvHWfxPMjU7xtBLSchLh8nuaJ21NA
         hAwp5a4GEi5DCM3dDH4T0xhvnK56aTDxCotMzqJtFLaCXHfAoxuALyJ0o3qjfotXsseE
         SPUJ5no8Gr+bxmmICEuehz6GZLeio5Kb1yB+fzMSBBFls8dCUoig1omE51fIJeFrhnyC
         d7LjP/FupmguhcJBCiaTksw0tTedrkeAGbketDuNB6PxWc//3NJi6CjHTAjMAKgndZkz
         aVUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Bsvy77V2BabW+yLUp1HGYQuE0fTStgpoE1+/qytzq1s=;
        b=AllwfkREJlW5rkrTdrOe2a3qq3ArCbkq3J1LYpYgVgOYkttDMg9cHc8KXVvv9/1ZVw
         /F2emcHzVNdPF8dRPpQdbCX1Oj/KacFruIyTPpcVPaSVxOT9WI5dfA3Rxaebs7cn2fgb
         b4Vr8jQFXMehAvlLAOMpGfH/Nnd+NcFyx1OWf8Qak4iY0CZ+PIAR3mXOhcymXxo7w0Wz
         NXsVjFbX2K3pUPqdtAp4UNZWxeE2wzwJSJiyQBF8ORq0bYmBHORYwVS/+beJkpwvHybZ
         LaqtLC/XF76EN9dpA8KOKFMYoJalLPHfN2p9xbD9mQjTVONaboHYMvY/KO1EyK4kjzu0
         Dk/w==
X-Gm-Message-State: APjAAAUiDonDb1YN1dLZHOQM07uhUFp8TfQFxBq0k8A2hKTAM8083B1n
        LNhfvma2Fp3dJG0HMeDlyCI=
X-Google-Smtp-Source: APXvYqx792ZxnRPmeKSlVuPcmkI5N4D9ONfjaQkrJxkqIgpWXAAKDFTpL6xQkKVarA5y32JLLzeE/Q==
X-Received: by 2002:a50:dece:: with SMTP id d14mr28348575edl.97.1557175886802;
        Mon, 06 May 2019 13:51:26 -0700 (PDT)
Received: from archlinux-i9 ([2a01:4f9:2b:2b84::2])
        by smtp.gmail.com with ESMTPSA id n7sm1761506ejk.72.2019.05.06.13.51.25
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 06 May 2019 13:51:26 -0700 (PDT)
Date:   Mon, 6 May 2019 13:51:24 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Subject: Re: [PATCH] rsi: Properly initialize data in rsi_sdio_ta_reset
Message-ID: <20190506205124.GA23683@archlinux-i9>
References: <20190502151548.11143-1-natechancellor@gmail.com>
 <CAKwvOd=nvKGGW5jvN+WFUXzOm9xeiNNUD0F9--9YcpuRmnWWhA@mail.gmail.com>
 <87h8ackv8j.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h8ackv8j.fsf@kamboji.qca.qualcomm.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 03, 2019 at 07:38:52AM +0300, Kalle Valo wrote:
> Nick Desaulniers <ndesaulniers@google.com> writes:
> 
> > On Thu, May 2, 2019 at 8:16 AM Nathan Chancellor
> > <natechancellor@gmail.com> wrote:
> >>
> >> When building with -Wuninitialized, Clang warns:
> >>
> >> drivers/net/wireless/rsi/rsi_91x_sdio.c:940:43: warning: variable 'data'
> >> is uninitialized when used here [-Wuninitialized]
> >>         put_unaligned_le32(TA_HOLD_THREAD_VALUE, data);
> >>                                                  ^~~~
> >> drivers/net/wireless/rsi/rsi_91x_sdio.c:930:10: note: initialize the
> >> variable 'data' to silence this warning
> >>         u8 *data;
> >>                 ^
> >>                  = NULL
> >> 1 warning generated.
> >>
> >> Using Clang's suggestion of initializing data to NULL wouldn't work out
> >> because data will be dereferenced by put_unaligned_le32. Use kzalloc to
> >> properly initialize data, which matches a couple of other places in this
> >> driver.
> >>
> >> Fixes: e5a1ecc97e5f ("rsi: add firmware loading for 9116 device")
> >> Link: https://github.com/ClangBuiltLinux/linux/issues/464
> >> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> >> ---
> >>  drivers/net/wireless/rsi/rsi_91x_sdio.c | 21 ++++++++++++++-------
> >>  1 file changed, 14 insertions(+), 7 deletions(-)
> >>
> >> diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
> >> index f9c67ed473d1..b35728564c7b 100644
> >> --- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
> >> +++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
> >> @@ -929,11 +929,15 @@ static int rsi_sdio_ta_reset(struct rsi_hw *adapter)
> >>         u32 addr;
> >>         u8 *data;
> >>
> >> +       data = kzalloc(sizeof(u32), GFP_KERNEL);
> >
> > Something fishy is going on here.  We allocate 4 B but declare data as
> > a u8* (pointer to individual bytes)?  In general, dynamically
> > allocating that few bytes is a code smell; either you meant to just
> > use the stack, or this memory's lifetime extends past the lifetime of
> > this stackframe, at which point you probably just meant to stack
> > allocate space in a higher parent frame and pass this preallocated
> > memory down to the child frame to get filled in.
> >
> > Reading through this code, I don't think that the memory is meant to
> > outlive the stack frame.  Is there a reason why we can't just declare
> > data as:
> >
> > u8 data [4];
> >
> > then use ARRAY_SIZE(data) or RSI_9116_REG_SIZE in rsi_reset_chip(),
> > getting rid of the kzalloc/kfree?
> 
> I haven't checked the details but AFAIK stack variables are not supposed
> to be used with DMA. So in that case I think it's ok alloc four bytes,
> unless the DMA rules have changed of course. But I didn't check if rsi
> is using DMA here, just a general comment.
> 
> -- 
> Kalle Valo

I don't think it is using the DMA API but it might be the same thing for
SDIO. If passing that around on the stack is okay, great but we don't
want what commit f700546682a6 ("rsi: fix nommu_map_sg overflow kernel
panic") fixes to happen here.

I can't answer that for sure though since I am not at all familiar with
this driver or the SDIO APIs.

Cheers,
Nathan
