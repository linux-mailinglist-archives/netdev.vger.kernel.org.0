Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DDED1EC937
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 08:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725854AbgFCGCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 02:02:06 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:38640 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725823AbgFCGCG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 02:02:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591164124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=o6jcKEk2mcNih81oO7ze2OIDsY31roMJVUEa+DK3JW4=;
        b=gbL7Iaq5pz/KcAfBNuZ7ldjX5EfevpL2ik2+8U6fQO6MOO7SMS4HmJsPbAEH/E7ORjfIar
        fQEgJmuj8xrtKL525eaY8RCnz/epNGwpbGq76CuZrx8OA30PcKG6RyRglb6DNwV8JN6v+6
        riQtdijerG+oU5Or+QrkTbtLHuzROlU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-472-a6LgIqA-PsSJNbNP1_tVzQ-1; Wed, 03 Jun 2020 02:02:02 -0400
X-MC-Unique: a6LgIqA-PsSJNbNP1_tVzQ-1
Received: by mail-wm1-f70.google.com with SMTP id s15so448702wmc.8
        for <netdev@vger.kernel.org>; Tue, 02 Jun 2020 23:02:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=o6jcKEk2mcNih81oO7ze2OIDsY31roMJVUEa+DK3JW4=;
        b=VppR/pG46aga3D4B6dPsTY9t0rt+a6zibX7bkwyxVeQCv967IavwzIMCpbpZ55/YCh
         G9lIyLHNrc9nc2jGHOUvmlUyX2Q5fW11+O9u1Y775p4hK8HJQzYyotsviUp0hAZPVGCR
         FhAEm8i5ATmwdQzL93fXmkIyu96a+YWMAi79H9afk8EOsfUa6RF0BxvCE4INRXupeRlO
         DZajmB70I0d+t47G+quiyhLQHa3u1drBPrHNs4PKjDceaGtClCdnTw6lMCW+Vkk9fK3r
         izLplZoh9KLSgj4cbc4pY3+TobI6EKaj7CBmqwoqLs99g/OK/x8Eu80RgQ1xBRgyfYP/
         EvYQ==
X-Gm-Message-State: AOAM531/i7eTgS9u3cKdlaTutbi2yfypXNmSDkS5rkVJAFYLPHwl6G+d
        1KUHESbuKvGDOZ1Z5qOIaxEBsrCmF/q6hxgFoXi2Zm3NW3GTQCKhYWTL0PHC0FR5avT2rQw4PfK
        hyfUATYAT7sTp+vrs
X-Received: by 2002:a1c:f003:: with SMTP id a3mr7045178wmb.119.1591164121051;
        Tue, 02 Jun 2020 23:02:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxXl+sofUHZk+VbvLWmhyqHx7h7DWb02lQ/P8NQ7EV8iW/Kg++HMCXfoH3XtMI929I9Wym9Mw==
X-Received: by 2002:a1c:f003:: with SMTP id a3mr7045163wmb.119.1591164120841;
        Tue, 02 Jun 2020 23:02:00 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id k16sm1608442wrp.66.2020.06.02.23.01.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 23:02:00 -0700 (PDT)
Date:   Wed, 3 Jun 2020 02:01:58 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Jason Wang <jasowang@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH RFC] uaccess: user_access_begin_after_access_ok()
Message-ID: <20200603014944-mutt-send-email-mst@kernel.org>
References: <20200602084257.134555-1-mst@redhat.com>
 <fc204429-7a6e-8214-a66f-bf2676018aae@redhat.com>
 <20200602163306.GM23230@ZenIV.linux.org.uk>
 <CAHk-=wjgg0bpD0qjYF=twJNXmRXYPjXqO1EFLL-mS8qUphe0AQ@mail.gmail.com>
 <20200602162931-mutt-send-email-mst@kernel.org>
 <CAHk-=wgYu+qk15_NpUZXwbetEU5eiWppJ=Z_A6dCSCWKxCfDfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgYu+qk15_NpUZXwbetEU5eiWppJ=Z_A6dCSCWKxCfDfw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 02, 2020 at 01:43:20PM -0700, Linus Torvalds wrote:
> On Tue, Jun 2, 2020 at 1:33 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > Hmm are you sure we can drop it? access_ok is done in the context
> > of the process. Access itself in the context of a kernel thread
> > that borrows the same mm. IIUC if the process can be 32 bit
> > while the kernel is 64 bit, access_ok in the context of the
> > kernel thread will not DTRT.
> 
> You're historically expected to just "set_fs()" when you do use_mm().

Right and we do that, but that still sets the segment according to the
current thread's flags, right?

E.g. I see:

#define USER_DS         MAKE_MM_SEG(TASK_SIZE_MAX)

and

#define TASK_SIZE               (test_thread_flag(TIF_ADDR32) ? \
                                        IA32_PAGE_OFFSET : TASK_SIZE_MAX)


so if this is run from a kernel thread on a 64 bit kernel, we get
TASK_SIZE_MAX even if we got the pointer from a 32 bit userspace
address.



> Then we fixed it in commit...
> 
> Oh, when I look for it, I notice that it still hasn't gotten merged.
> It's still pending, see
> 
>   https://lore.kernel.org/lkml/20200416053158.586887-4-hch@lst.de/
> 
> for the current thing.
> 
>               Linus


Maybe kthread_use_mm should also get the fs, not just mm.
Then we can just use access_ok directly before the access.


-- 
MST

