Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC7EC39C4D1
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 03:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbhFEBap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 21:30:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbhFEBao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 21:30:44 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19771C061766;
        Fri,  4 Jun 2021 18:28:57 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id n12so9707487lft.10;
        Fri, 04 Jun 2021 18:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dntjrco9OnVCH86IjJWSNolUZv51raocOyAp4mrzblc=;
        b=a4VBGmzg1WfpImzkML1MfKmrW1hkwTeZRACM7WrlosfcQQAw6yX3qBQl3jNBJR7T8K
         snZjJMXjvodHFiB+gl/JHS+Flq50upKnvekb0xPRATVQDNCbnfIjBCrxgnjihqSirs7e
         Ti3LceOvVjm0F39i4Io7e0VxkM3PLugHcLt2DKk3YdAOy+9cn/RZgB/1kSfPCnADt3cG
         LApCWh7+QWamIRvxGQRWCUqjtEx4MsPSsSi8qp0btnHhJOdZKID0MR617XQPeBlfV19I
         fsdkU7+dT+klp7MhFwQ9cPfa6VCO3fKUm7og93Ha4I00d0Lk9WDNvjnXBcrdxCsi4qsb
         B9fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dntjrco9OnVCH86IjJWSNolUZv51raocOyAp4mrzblc=;
        b=CftrDuSe29ifeR2T70ZPP9rnHhq7d+duo6JeX8d2BLjpyyYpSzVgEFs4UOf44sThRu
         NUGiBLKTmgMXglXbqoxOEJbuQeDdUeN2ovLhZCj1WfVajAHxwk74TpC/WiOY6RktB5LR
         VixF5f2bis/cSUePdLExhs7umi692bGs72OqFh9U0qhs59FvJdGRd++o7oKdfR0OLVjL
         dxDTgSaAgoWPbzHnu9eS8wpIW1MSa7vGIPSP1PCj18bhxHKm9RR83kvBFFJtd6A7/4gW
         6/jBgddQcF7U3HxI+KhnoGohYOS7Qtrek2uuEPTOJPqAvdOfRCRcY4qnK0YbX3HQNFHL
         OK3Q==
X-Gm-Message-State: AOAM530pUIHeAnjLQugmFLBxMFUgjs0IixWblgv4/hN/rXiqfXPwC0ae
        cgfAZiUzFtWeryjgfDOC8hLe8p+sVLOcDpxezn8=
X-Google-Smtp-Source: ABdhPJz3Zy9ZDfxjNVHWKqoALQrPMbeX+Gf+OFsPyZN/uoBZe2Ps6CH4tRWqj15pM6eMlfMaJ44nb0E3xcxLspRB6wU=
X-Received: by 2002:ac2:548d:: with SMTP id t13mr4412882lfk.568.1622856535401;
 Fri, 04 Jun 2021 18:28:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210604074419.53956-1-dong.menglong@zte.com.cn> <e997a058-9f6e-86a0-8591-56b0b89441aa@redhat.com>
In-Reply-To: <e997a058-9f6e-86a0-8591-56b0b89441aa@redhat.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Sat, 5 Jun 2021 09:28:44 +0800
Message-ID: <CADxym3ZostCAY0GwUpTxEHcOPyOj5Lmv4F7xP-Q4=AEAVaEAxw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: tipc: fix FB_MTU eat two pages
To:     Jon Maloy <jmaloy@redhat.com>
Cc:     ying.xue@windriver.com, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        tipc-discussion@lists.sourceforge.net,
        Menglong Dong <dong.menglong@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Maloy,

On Sat, Jun 5, 2021 at 3:20 AM Jon Maloy <jmaloy@redhat.com> wrote:
>
>
[...]
> Please don't add any extra file just for this little fix. We have enough
> files.
> Keep the macros in msg.h/c where they used to be.  You can still add
> your copyright line to those files.
> Regarding the macros kept inside msg.c, they are there because we design
> by the principle of minimal exposure, even among our module internal files.
> Otherwise it is ok.
>

I don't want to add a new file too, but I found it's hard to define FB_MTU. I
tried to define it in msg.h, and 'crypto.h' should be included, which
'BUF_HEADROOM' is defined in. However, 'msg.h' is already included in
'crypto.h', so it doesn't work.

I tried to define FB_MTU in 'crypto.h', but it feels weird to define
it here. And
FB_MTU is also used in 'bcast.c', so it can't be defined in 'msg.c'.

I will see if there is a better solution.

Thanks!
Menglong Dong

> > @@ -0,0 +1,55 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/*
> > + * Copyright 2021 ZTE Corporation.
> > + * All rights reserved.
> > + *
> > + * Redistribution and use in source and binary forms, with or without
> > + * modification, are permitted provided that the following conditions are met:
> > + *
> > + * 1. Redistributions of source code must retain the above copyright
> > + *    notice, this list of conditions and the following disclaimer.
> > + * 2. Redistributions in binary form must reproduce the above copyright
> > + *    notice, this list of conditions and the following disclaimer in the
> > + *    documentation and/or other materials provided with the distribution.
> > + * 3. Neither the names of the copyright holders nor the names of its
> > + *    contributors may be used to endorse or promote products derived from
> > + *    this software without specific prior written permission.
> > + *
> > + * Alternatively, this software may be distributed under the terms of the
> > + * GNU General Public License ("GPL") version 2 as published by the Free
> > + * Software Foundation.
> > + *
> > + * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
> > + * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
> > + * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
> > + * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
> > + * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
> > + * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
> > + * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
> > + * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
> > + * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
> > + * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
> > + * POSSIBILITY OF SUCH DAMAGE.
> > + */
> > +
> > +#ifndef _TIPC_MTU_H
> > +#define _TIPC_MTU_H
> > +
> > +#include <linux/tipc.h>
> > +#include "crypto.h"
> > +
> > +#ifdef CONFIG_TIPC_CRYPTO
> > +#define BUF_HEADROOM ALIGN(((LL_MAX_HEADER + 48) + EHDR_MAX_SIZE), 16)
> > +#define BUF_TAILROOM (TIPC_AES_GCM_TAG_SIZE)
> > +#define FB_MTU       (PAGE_SIZE - \
> > +              SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) - \
> > +              SKB_DATA_ALIGN(BUF_HEADROOM + BUF_TAILROOM + 3))
> > +#else
> > +#define BUF_HEADROOM (LL_MAX_HEADER + 48)
> > +#define BUF_TAILROOM 16
> > +#define FB_MTU       (PAGE_SIZE - \
> > +              SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) - \
> > +              SKB_DATA_ALIGN(BUF_HEADROOM + 3))
> > +#endif
> > +
> > +#endif
>
