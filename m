Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3D7C14CE9A
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 17:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbgA2Qnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 11:43:31 -0500
Received: from gentwo.org ([3.19.106.255]:40906 "EHLO gentwo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726671AbgA2Qnb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jan 2020 11:43:31 -0500
Received: by gentwo.org (Postfix, from userid 1002)
        id 275353FFFA; Wed, 29 Jan 2020 16:43:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
        by gentwo.org (Postfix) with ESMTP id 254433F070;
        Wed, 29 Jan 2020 16:43:30 +0000 (UTC)
Date:   Wed, 29 Jan 2020 16:43:30 +0000 (UTC)
From:   Christopher Lameter <cl@linux.com>
X-X-Sender: cl@www.lameter.com
To:     Kees Cook <keescook@chromium.org>
cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, David Windsor <dave@nullcore.net>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
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
        linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
        netdev@vger.kernel.org, kernel-hardening@lists.openwall.com,
        Vlastimil Babka <vbabka@suse.cz>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [kernel-hardening] [PATCH 09/38] usercopy: Mark kmalloc caches
 as usercopy caches
In-Reply-To: <202001281457.FA11CC313A@keescook>
Message-ID: <alpine.DEB.2.21.2001291640350.1546@www.lameter.com>
References: <1515636190-24061-1-git-send-email-keescook@chromium.org> <1515636190-24061-10-git-send-email-keescook@chromium.org> <9519edb7-456a-a2fa-659e-3e5a1ff89466@suse.cz> <201911121313.1097D6EE@keescook> <201911141327.4DE6510@keescook>
 <bfca96db-bbd0-d958-7732-76e36c667c68@suse.cz> <202001271519.AA6ADEACF0@keescook> <5861936c-1fe1-4c44-d012-26efa0c8b6e7@de.ibm.com> <202001281457.FA11CC313A@keescook>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Jan 2020, Kees Cook wrote:

> > On the other hand not marking the DMA caches still seems questionable.
>
> My understanding is that exposing DMA memory to userspace copies can
> lead to unexpected results, especially for misbehaving hardware, so I'm
> not convinced this is a generically bad hardening choice.

"DMA" memory (and thus DMA caches) have nothing to do with DMA. Its a
legacy term. "DMA Memory" is memory limited to a certain
physical address boundary (old restrictions on certain devices only
supporting a limited number of address bits).

DMA can be done to NORMAL memory as well.

