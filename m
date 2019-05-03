Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA2F612671
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 05:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbfECDRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 23:17:24 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:35742 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbfECDRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 23:17:23 -0400
Received: by mail-ed1-f67.google.com with SMTP id p26so4345835edr.2;
        Thu, 02 May 2019 20:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=exm4N7u1IvYx+pAgkJoEgIpNRAWHACWM3KM/oLglz1E=;
        b=L52EIfbjMFkrvpnCBpB2Ic0diQIMkhnGNXTc8F8TeXGqPFqcwI8pM9IPnseH7Zjue/
         XZdgY1E0k1acaDyfNbPrzRP4Ic5q8ShLFqqBHZXowhrwMosClo76xtBRkNEXBlDwJ3ro
         bnJ2XHdXT51FPoGHvuq4W1Mrbb/C+bPUfcjziK0GlpY4jA1sC0UAI8vxy3QEbzOhr1gv
         bSD244mwxge46W1PyQU6p1l2xvf6kaxb4+U/b49sQNYi5qpRHQzH08L+RdRR7sH45DvU
         upQoiiAyGgS8WUBOg9jizo9pWj3R25tO0UlqTCgO6IUZ1A6bD7OalKmRwQKikHj0kuVJ
         1RnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=exm4N7u1IvYx+pAgkJoEgIpNRAWHACWM3KM/oLglz1E=;
        b=k+oobnOqqz1eSvBiLinAiaMiF8Mq907Zq2C0fk+FyhD3U0W05CFD6k0MVq6/91mc7h
         H99A2E5b3RUe4d0m1+zPx4qjlWf3ysT/aw+hzAyd/HoX9W/ww3kOrGyZN9ZnFIxQf+0S
         hmTEOmcR2IqW7FbukkxiyRp20wg65BHK5RniOKM8Rmx/h/Rp+tlp6qvyM9Oxkxcnicz7
         mQUzizgk95yK1JLC7mpOcsTOutQBBWvb2aw3xVsba59fGmxpJnHoTJ8LPw8jufxHBss1
         /TGkU4BwEf10DUT0RjeyaW/7naodhm3o39U6euM/37meU8IE2pqEsotNVeyGvzGts172
         gQFw==
X-Gm-Message-State: APjAAAXwF57GGTG2FfLXWFFe7iztmNx3kzuw57nZfSZzblOKvIcJEPHQ
        P/tIVeZu5Nzw5ePTnMmJ0vY=
X-Google-Smtp-Source: APXvYqzgq+VHW0yGO5hJ1ZnRyxSpb3YrJW9d7xNPwzFkJDfP4QdW501wWw7j5Td6gr8cNm5bLafnAg==
X-Received: by 2002:a17:906:9519:: with SMTP id u25mr4120326ejx.34.1556853441256;
        Thu, 02 May 2019 20:17:21 -0700 (PDT)
Received: from archlinux-i9 ([2a01:4f9:2b:2b84::2])
        by smtp.gmail.com with ESMTPSA id o9sm243533edh.95.2019.05.02.20.17.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 02 May 2019 20:17:20 -0700 (PDT)
Date:   Thu, 2 May 2019 20:17:18 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Subject: Re: [PATCH] rsi: Properly initialize data in rsi_sdio_ta_reset
Message-ID: <20190503031718.GB6969@archlinux-i9>
References: <20190502151548.11143-1-natechancellor@gmail.com>
 <CAKwvOd=nvKGGW5jvN+WFUXzOm9xeiNNUD0F9--9YcpuRmnWWhA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOd=nvKGGW5jvN+WFUXzOm9xeiNNUD0F9--9YcpuRmnWWhA@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 02, 2019 at 11:18:01AM -0700, Nick Desaulniers wrote:
> On Thu, May 2, 2019 at 8:16 AM Nathan Chancellor
> <natechancellor@gmail.com> wrote:
> >
> > When building with -Wuninitialized, Clang warns:
> >
> > drivers/net/wireless/rsi/rsi_91x_sdio.c:940:43: warning: variable 'data'
> > is uninitialized when used here [-Wuninitialized]
> >         put_unaligned_le32(TA_HOLD_THREAD_VALUE, data);
> >                                                  ^~~~
> > drivers/net/wireless/rsi/rsi_91x_sdio.c:930:10: note: initialize the
> > variable 'data' to silence this warning
> >         u8 *data;
> >                 ^
> >                  = NULL
> > 1 warning generated.
> >
> > Using Clang's suggestion of initializing data to NULL wouldn't work out
> > because data will be dereferenced by put_unaligned_le32. Use kzalloc to
> > properly initialize data, which matches a couple of other places in this
> > driver.
> >
> > Fixes: e5a1ecc97e5f ("rsi: add firmware loading for 9116 device")
> > Link: https://github.com/ClangBuiltLinux/linux/issues/464
> > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> > ---
> >  drivers/net/wireless/rsi/rsi_91x_sdio.c | 21 ++++++++++++++-------
> >  1 file changed, 14 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
> > index f9c67ed473d1..b35728564c7b 100644
> > --- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
> > +++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
> > @@ -929,11 +929,15 @@ static int rsi_sdio_ta_reset(struct rsi_hw *adapter)
> >         u32 addr;
> >         u8 *data;
> >
> > +       data = kzalloc(sizeof(u32), GFP_KERNEL);
> 
> Something fishy is going on here.  We allocate 4 B but declare data as
> a u8* (pointer to individual bytes)?  In general, dynamically
> allocating that few bytes is a code smell; either you meant to just
> use the stack, or this memory's lifetime extends past the lifetime of
> this stackframe, at which point you probably just meant to stack
> allocate space in a higher parent frame and pass this preallocated
> memory down to the child frame to get filled in.
> 
> Reading through this code, I don't think that the memory is meant to
> outlive the stack frame.  Is there a reason why we can't just declare
> data as:
> 
> u8 data [4];

data was __le32 in rsi_reset_chip() before commit f700546682a6 ("rsi:
fix nommu_map_sg overflow kernel panic").

I wonder if this would be okay for this function:

-------------------------------------------------

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index f9c67ed473d1..0330c50ab99c 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -927,7 +927,7 @@ static int rsi_sdio_ta_reset(struct rsi_hw *adapter)
 {
        int status;
        u32 addr;
-       u8 *data;
+       u8 data;
 
        status = rsi_sdio_master_access_msword(adapter, TA_BASE_ADDR);
        if (status < 0) {
@@ -937,7 +937,7 @@ static int rsi_sdio_ta_reset(struct rsi_hw *adapter)
        }
 
        rsi_dbg(INIT_ZONE, "%s: Bring TA out of reset\n", __func__);
-       put_unaligned_le32(TA_HOLD_THREAD_VALUE, data);
+       put_unaligned_le32(TA_HOLD_THREAD_VALUE, &data);
        addr = TA_HOLD_THREAD_REG | RSI_SD_REQUEST_MASTER;
        status = rsi_sdio_write_register_multiple(adapter, addr,
                                                  (u8 *)&data,
@@ -947,7 +947,7 @@ static int rsi_sdio_ta_reset(struct rsi_hw *adapter)
                return status;
        }
 
-       put_unaligned_le32(TA_SOFT_RST_CLR, data);
+       put_unaligned_le32(TA_SOFT_RST_CLR, &data);
        addr = TA_SOFT_RESET_REG | RSI_SD_REQUEST_MASTER;
        status = rsi_sdio_write_register_multiple(adapter, addr,
                                                  (u8 *)&data,
@@ -957,7 +957,7 @@ static int rsi_sdio_ta_reset(struct rsi_hw *adapter)
                return status;
        }
 
-       put_unaligned_le32(TA_PC_ZERO, data);
+       put_unaligned_le32(TA_PC_ZERO, &data);
        addr = TA_TH0_PC_REG | RSI_SD_REQUEST_MASTER;
        status = rsi_sdio_write_register_multiple(adapter, addr,
                                                  (u8 *)&data,
@@ -967,7 +967,7 @@ static int rsi_sdio_ta_reset(struct rsi_hw *adapter)
                return -EINVAL;
        }
 
-       put_unaligned_le32(TA_RELEASE_THREAD_VALUE, data);
+       put_unaligned_le32(TA_RELEASE_THREAD_VALUE, &data);
        addr = TA_RELEASE_THREAD_REG | RSI_SD_REQUEST_MASTER;
        status = rsi_sdio_write_register_multiple(adapter, addr,
                                                  (u8 *)&data,


> 
> then use ARRAY_SIZE(data) or RSI_9116_REG_SIZE in rsi_reset_chip(),
> getting rid of the kzalloc/kfree?
> 
> (Sorry, I hate when a simple fixup becomes a "hey let's rewrite all
> this code" thus becoming "that guy.")

If we aren't actually improving the code, then why bother? :)

Thank you for the review!
Nathan

> -- 
> Thanks,
> ~Nick Desaulniers
