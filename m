Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4E98F454
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 21:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731973AbfHOTTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 15:19:44 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:47042 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731405AbfHOTTn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 15:19:43 -0400
Received: by mail-lj1-f194.google.com with SMTP id f9so3148130ljc.13
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 12:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=NlktoYn7GnTL4hkv6fSDP6jxnFjODJIzhQlYIZg0bd4=;
        b=zzAlynUlgH4+MpPOfOGtgNMRwPO9tIdY8wRShreA86Rcm9/7IFvuxexRtod4QEP/Bp
         sLRcgzClT+ibagHjOgfPZuYWt7DYsM/Zf+6xtzSyIhMWJ86DbS5j9QME74ROJlEY021S
         9ggqchyWDKwqYdP7WSeOepcHDpOtmetmrLFPEBkKaVUnKDu0x15Z0XZ74NOQVP0semMX
         ObxZJUDlBib6mrqTxp1Tg8dEs7KxmPPR2pVmURGfWjLHjY0+thU2HVhRBgB7emeyxsbp
         eZCxEOClxXGDGMHyKZdtjxS1sRMunzwWOlIQ2HJ1B3gnU0C6JOzatDild3hGQ4XSgdwy
         JMgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=NlktoYn7GnTL4hkv6fSDP6jxnFjODJIzhQlYIZg0bd4=;
        b=QV1Bt3S3Y/mY1JZArY6G0y8TV1CitM9Tx6yVHgVcWwYCBGPPiqyOHC5rEmQ3g4tRD/
         /Ttf8Tq0cQMexNOoVZsSAObW5WYXQOzTXhy1lWOsCYUa/UVUT98kqy6GoYVkI3zE+IoT
         uQwSvtb74aAK9xB5NBViwmEGbT3acN03DnAWiS40VYCm6+XXgq5N2Y6mdO1rY8oOkOMQ
         7dl/y0SaD8eRXHzBwYGLieT4YUi+gzZX1faDSIr2C30z9JUFwSB99s0ey7VQHlPmO+4a
         m1ASke2SvsTtR9K2obsVCfnukF3cIhJUnhNl0L76Uivv4DDIHImK/QO+N6BcOCPaTqQz
         Pcng==
X-Gm-Message-State: APjAAAXMDi25EB4OwD4Nx5c5v3KD3wzYqxJekFqxRuPLe/RfBzA+rLCI
        qr7xXeEWk0cJZWtMa0FByhofYw==
X-Google-Smtp-Source: APXvYqycN5rMbTje+rC1m6zgeRUvUyN3KKS8p+Tml9G5gJbp+bE3P5wUL9Bg8nVCsjBr2Do9LNSWAQ==
X-Received: by 2002:a2e:82c7:: with SMTP id n7mr2384989ljh.131.1565896780983;
        Thu, 15 Aug 2019 12:19:40 -0700 (PDT)
Received: from khorivan (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id a15sm577425lfl.44.2019.08.15.12.19.39
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 15 Aug 2019 12:19:40 -0700 (PDT)
Date:   Thu, 15 Aug 2019 22:19:38 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        jakub.kicinski@netronome.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        xdp-newbies@vger.kernel.org, linux-kernel@vger.kernel.org,
        yhs@fb.com, andrii.nakryiko@gmail.com
Subject: Re: [PATCH bpf-next v2 2/3] xdp: xdp_umem: replace kmap on vmap for
 umem map
Message-ID: <20190815191456.GA11699@khorivan>
Mail-Followup-To: Jonathan Lemon <jonathan.lemon@gmail.com>,
        magnus.karlsson@intel.com, bjorn.topel@intel.com,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        jakub.kicinski@netronome.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        xdp-newbies@vger.kernel.org, linux-kernel@vger.kernel.org,
        yhs@fb.com, andrii.nakryiko@gmail.com
References: <20190815121356.8848-1-ivan.khoronzhuk@linaro.org>
 <20190815121356.8848-3-ivan.khoronzhuk@linaro.org>
 <5B58D364-609F-498E-B7DF-4457D454A14D@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <5B58D364-609F-498E-B7DF-4457D454A14D@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 15, 2019 at 11:23:16AM -0700, Jonathan Lemon wrote:
>On 15 Aug 2019, at 5:13, Ivan Khoronzhuk wrote:
>
>>For 64-bit there is no reason to use vmap/vunmap, so use page_address
>>as it was initially. For 32 bits, in some apps, like in samples
>>xdpsock_user.c when number of pgs in use is quite big, the kmap
>>memory can be not enough, despite on this, kmap looks like is
>>deprecated in such cases as it can block and should be used rather
>>for dynamic mm.
>>
>>Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
>>---
>> net/xdp/xdp_umem.c | 36 ++++++++++++++++++++++++++++++------
>> 1 file changed, 30 insertions(+), 6 deletions(-)
>>
>>diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
>>index a0607969f8c0..d740c4f8810c 100644
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
>>@@ -170,7 +170,30 @@ static void xdp_umem_unmap_pages(struct 
>>xdp_umem *umem)
>> 	unsigned int i;
>>
>> 	for (i = 0; i < umem->npgs; i++)
>>-		kunmap(umem->pgs[i]);
>>+		if (PageHighMem(umem->pgs[i]))
>>+			vunmap(umem->pages[i].addr);
>>+}
>>+
>>+static int xdp_umem_map_pages(struct xdp_umem *umem)
>>+{
>>+	unsigned int i;
>>+	void *addr;
>>+
>>+	for (i = 0; i < umem->npgs; i++) {
>>+		if (PageHighMem(umem->pgs[i]))
>>+			addr = vmap(&umem->pgs[i], 1, VM_MAP, PAGE_KERNEL);
>>+		else
>>+			addr = page_address(umem->pgs[i]);
>>+
>>+		if (!addr) {
>>+			xdp_umem_unmap_pages(umem);
>>+			return -ENOMEM;
>>+		}
>>+
>>+		umem->pages[i].addr = addr;
>>+	}
>>+
>>+	return 0;
>> }
>
>You'll want a __xdp_umem_unmap_pages() helper here that takes an
>count of the number of pages to unmap, so it can be called from
>xdp_umem_unmap_pages() in the normal case, and xdp_umem_map_pages()
>in the error case.  Otherwise the error case ends up calling
>PageHighMem on a null page.
>-- 
>Jonathan

Do you mean null address?
If so, then vunmap do nothing if it's null, and addr is null if it's not
assigned... and it's not assigned w/o correct mapping...

If you mean null page, then it is not possible after all they are
pinned above, here: xdp_umem_pin_pages(), thus assigned.

Or I missed smth?

Despite of this, seems like here should be one more patch, adding unpinning page
in error path, but this not related to this change. Will do this in follow up
fix patch, if no objection to my explanation, ofc.

-- 
Regards,
Ivan Khoronzhuk
