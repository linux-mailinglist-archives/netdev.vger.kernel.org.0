Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDBD48C096
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 20:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728678AbfHMSaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 14:30:30 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:36682 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728585AbfHMSaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 14:30:30 -0400
Received: by mail-lj1-f196.google.com with SMTP id u15so7491592ljl.3
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 11:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rtRu+AHbgd2oDIZ4fv3PIz1vAPG+fow/j/w+4mpzcFg=;
        b=IaANP5+KspJJFWsb5bWsuSkvcMhbvzuLXra8gL0lKvm1pqefJe5qb2eLggCiPCR4/4
         dcEEh3+zOvs+4p1rdV5MN1a+yCTjjC5mZ3HWuq1mOz0Zs9tqBUcB9x6oe2YcuF4BEWjd
         NcvlzK8JWXjn7Ay7MkFs3tffPt27XNUsLIjv0s58nzR9pnJespQYACFdAQCqa8mXo+75
         FtIYx+iPkjlX00wBWMu7nLOPwBvbRvKBLA1oN+yvQtleGKYJrIsXZPP7as4CzmMsfHhr
         KQvwAtiuVaTLMzK2FTDzFvL6UeWkdIzkP1hSuKEdDEM11jrsTlhRt7OJCx+LNOTIzDst
         QqQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=rtRu+AHbgd2oDIZ4fv3PIz1vAPG+fow/j/w+4mpzcFg=;
        b=Fq/v24GKq8/qlg77S3dzRPk4DYnXrIM1pDO00E1Rfq2hBkl2NT41U7mBQbbSZ5BQ2J
         LwQvEU+me79xUG7b8S37KCWZTL9yY06TaEbe9UwOWOEO2mmQ3fKUc0W+smCMPraGWzfF
         29Uzn33rdpyKoKDd1VXICMgLbmS0nCrLVRCYDPXKcXbTk2W7+BUry0bksO4P1k5quOQR
         OhnI4IFcvgrVDk5gb8KJNhxBiXVgC9ewg9qL23+LH9mzHNC2gW+5triBMC4fdo1ZZQD3
         M1lsS6v+poKsk24wkAqHF9FqyupHhwWb9vBRjiVOhuACnUSkSRM59mDaT875EoezdfAp
         vQdQ==
X-Gm-Message-State: APjAAAW7K5/UThv5jKfnHjVACzCpdeFXtnJdBJRxnuqQIsP97qnxYzYr
        VEr0f4Aw+rqqGlkFuOVQWLR4mQ==
X-Google-Smtp-Source: APXvYqxCUBcggszopW1oRCo3h3gsHx2oBziXy+XIXVG5aCOra+tLdVa9D1L0DDmJpqZd0cMMSZaDYA==
X-Received: by 2002:a2e:81c3:: with SMTP id s3mr13176302ljg.70.1565721027639;
        Tue, 13 Aug 2019 11:30:27 -0700 (PDT)
Received: from khorivan (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id k82sm21735636lje.30.2019.08.13.11.30.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 13 Aug 2019 11:30:27 -0700 (PDT)
Date:   Tue, 13 Aug 2019 21:30:24 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Jonathan Lemon <jlemon@flugsvamp.com>
Cc:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        jakub.kicinski@netronome.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        xdp-newbies@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next 2/3] xdp: xdp_umem: replace kmap on vmap for
 umem map
Message-ID: <20190813183023.GA2856@khorivan>
Mail-Followup-To: Jonathan Lemon <jlemon@flugsvamp.com>,
        magnus.karlsson@intel.com, bjorn.topel@intel.com,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        jakub.kicinski@netronome.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        xdp-newbies@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190813102318.5521-1-ivan.khoronzhuk@linaro.org>
 <20190813102318.5521-3-ivan.khoronzhuk@linaro.org>
 <9F98648A-8654-4767-97B5-CF4BC939393C@flugsvamp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <9F98648A-8654-4767-97B5-CF4BC939393C@flugsvamp.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 13, 2019 at 10:42:18AM -0700, Jonathan Lemon wrote:
>
>
>On 13 Aug 2019, at 3:23, Ivan Khoronzhuk wrote:
>
>>For 64-bit there is no reason to use vmap/vunmap, so use page_address
>>as it was initially. For 32 bits, in some apps, like in samples
>>xdpsock_user.c when number of pgs in use is quite big, the kmap
>>memory can be not enough, despite on this, kmap looks like is
>>deprecated in such cases as it can block and should be used rather
>>for dynamic mm.
>>
>>Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
>
>Seems a bit overkill - if not high memory, kmap() falls back
>to just page_address(), unlike vmap().

>-- Jonathan

So, as kmap has limitation... if I correctly understood, you propose
to avoid macros and do smth like kmap:

	void *addr;
	if (!PageHighMem(&umem->pgs[i]))
		addr =  page_address(page);
	else
		addr = vmap(&umem->pgs[i], 1, VM_MAP, PAGE_KERNEL);

	umem->pages[i].addr = addr;

and while unmap

	if (!PageHighMem(&umem->pgs[i]))
		vunmap(umem->pages[i].addr);

I can try it, and add this in v2 if no objection.

>
>>---
>> net/xdp/xdp_umem.c | 16 ++++++++++++----
>> 1 file changed, 12 insertions(+), 4 deletions(-)
>>
>>diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
>>index a0607969f8c0..907c9019fe21 100644
>>--- a/net/xdp/xdp_umem.c
>>+++ b/net/xdp/xdp_umem.c
>>@@ -14,7 +14,7 @@
>> #include <linux/netdevice.h>
>> #include <linux/rtnetlink.h>
>> #include <linux/idr.h>
>>-#include <linux/highmem.h>
>>+#include <linux/vmalloc.h>
>>
>> #include "xdp_umem.h"
>> #include "xsk_queue.h"
>>@@ -167,10 +167,12 @@ void xdp_umem_clear_dev(struct xdp_umem *umem)
>>
>> static void xdp_umem_unmap_pages(struct xdp_umem *umem)
>> {
>>+#if BITS_PER_LONG == 32
>> 	unsigned int i;
>>
>> 	for (i = 0; i < umem->npgs; i++)
>>-		kunmap(umem->pgs[i]);
>>+		vunmap(umem->pages[i].addr);
>>+#endif
>> }
>>
>> static void xdp_umem_unpin_pages(struct xdp_umem *umem)
>>@@ -378,8 +380,14 @@ static int xdp_umem_reg(struct xdp_umem *umem, 
>>struct xdp_umem_reg *mr)
>> 		goto out_account;
>> 	}
>>
>>-	for (i = 0; i < umem->npgs; i++)
>>-		umem->pages[i].addr = kmap(umem->pgs[i]);
>>+	for (i = 0; i < umem->npgs; i++) {
>>+#if BITS_PER_LONG == 32
>>+		umem->pages[i].addr = vmap(&umem->pgs[i], 1, VM_MAP,
>>+					   PAGE_KERNEL);
>>+#else
>>+		umem->pages[i].addr = page_address(umem->pgs[i]);
>>+#endif
>>+	}
>>
>> 	return 0;
>>
>>-- 
>>2.17.1

-- 
Regards,
Ivan Khoronzhuk
