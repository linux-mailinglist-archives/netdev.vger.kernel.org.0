Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCC914F940
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 18:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbgBAR4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 12:56:46 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:54378 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726731AbgBAR4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Feb 2020 12:56:45 -0500
Received: by mail-pj1-f66.google.com with SMTP id dw13so4387318pjb.4
        for <netdev@vger.kernel.org>; Sat, 01 Feb 2020 09:56:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1rxiDiiWyy+RaaD0YllXb5sVbRbHdZvAaLoyASC1RHA=;
        b=UbIWczwiQvzV+o1/R62NbaP1lFCIW4J4I1Znu2jtuEVKVBfSBP0kAK6LdTGJ1ujZps
         /G0uyRiL+3/xM2Hvkwz1ZQhXsnR97q5ZnjDFj6XXbM/7HbkX4QGvl8Ij1VWRDdoVEVqI
         D9Ks/1wEw6tLdPvSdLg1Vw6B3NocqQ1gDZwAk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1rxiDiiWyy+RaaD0YllXb5sVbRbHdZvAaLoyASC1RHA=;
        b=VYtCVwfVk+wrVZw+Wa/g/ySt3s87XgZgMsh9uz+Adk8Ech2yD/h3Zr98DYfMb61nTh
         gSXlfmAUVArgocQ0fni58jNjznCV6ryEw0VcAz6XLU0+2dOI1Crb4bvDuWeMY/eTC84Z
         mmGai8/dMZhaeVQYyYJm3Ct7AtAByyvPoUQ3rNumglcrSS+UvtZmSbyrdgOGmIP1k7Lp
         0kFkCmo1QFT4kJIfoPqNQsERd3BKL8DIpfTqryugjdFOnAJLp4x32ZAWsZpwBoaU26js
         QdNkGOztgbP3ulweZWVM8n+BQxRurWhx5DD9flO0KLmxwM6rEwfcur08E8e3+jqpFkP1
         gMKA==
X-Gm-Message-State: APjAAAW2QQsgQz3FcZ7677gi8fFwz/++gyJUNwEqbZyzWxs9DljnNcYp
        efqNb1daqssZKJTpcn/OgN+bxw==
X-Google-Smtp-Source: APXvYqxT3vOizdt1K5+VTatra4+LXkGQ2fpy4tPPX6L9duoaO3re51J2wolPrp+nN4BPCFA89zymvQ==
X-Received: by 2002:a17:902:9b93:: with SMTP id y19mr15780032plp.89.1580579803746;
        Sat, 01 Feb 2020 09:56:43 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id gc1sm14073972pjb.20.2020.02.01.09.56.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Feb 2020 09:56:42 -0800 (PST)
Date:   Sat, 1 Feb 2020 09:56:41 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Jann Horn <jannh@google.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christopher Lameter <cl@linux.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        kernel list <linux-kernel@vger.kernel.org>,
        David Windsor <dave@nullcore.net>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, linux-xfs@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Laura Abbott <labbott@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Jan Kara <jack@suse.cz>,
        Luis de Bethencourt <luisbg@kernel.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Rik van Riel <riel@redhat.com>,
        Matthew Garrett <mjg59@google.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [kernel-hardening] [PATCH 09/38] usercopy: Mark kmalloc caches
 as usercopy caches
Message-ID: <202002010952.ACDA7A81@keescook>
References: <bfca96db-bbd0-d958-7732-76e36c667c68@suse.cz>
 <202001271519.AA6ADEACF0@keescook>
 <5861936c-1fe1-4c44-d012-26efa0c8b6e7@de.ibm.com>
 <202001281457.FA11CC313A@keescook>
 <alpine.DEB.2.21.2001291640350.1546@www.lameter.com>
 <6844ea47-8e0e-4fb7-d86f-68046995a749@de.ibm.com>
 <20200129170939.GA4277@infradead.org>
 <771c5511-c5ab-3dd1-d938-5dbc40396daa@de.ibm.com>
 <202001300945.7D465B5F5@keescook>
 <CAG48ez1a4waGk9kB0WLaSbs4muSoK0AYAVk8=XYaKj4_+6e6Hg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez1a4waGk9kB0WLaSbs4muSoK0AYAVk8=XYaKj4_+6e6Hg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 31, 2020 at 01:03:40PM +0100, Jann Horn wrote:
> I think dma-kmalloc slabs should be handled the same way as normal
> kmalloc slabs. When a dma-kmalloc allocation is freshly created, it is
> just normal kernel memory - even if it might later be used for DMA -,
> and it should be perfectly fine to copy_from_user() into such
> allocations at that point, and to copy_to_user() out of them at the
> end. If you look at the places where such allocations are created, you
> can see things like kmemdup(), memcpy() and so on - all normal
> operations that shouldn't conceptually be different from usercopy in
> any relevant way.

I can't find where the address limit for dma-kmalloc is implemented.

As to whitelisting all of dma-kmalloc -- I guess I can be talked into
it. It still seems like the memory used for direct hardware
communication shouldn't be exposed to userspace, but it we're dealing
with packet data, etc, then it makes sense not to have to have bounce
buffers, etc.

-- 
Kees Cook
