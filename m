Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29B4B365EE2
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 19:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233473AbhDTR7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 13:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231549AbhDTR7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 13:59:33 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3470FC06174A;
        Tue, 20 Apr 2021 10:59:00 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id v6so58309488ejo.6;
        Tue, 20 Apr 2021 10:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=f5aVc+Rvip+i9wMcJgMkN6n1iKUg3nhAfrxBMVSyMT4=;
        b=vRUxfANqM5gmEe+JEi/nYpjRog+dg4T69TNipoOZUaYkZAvwQmisFgJAtp0tFTn4bc
         nt0LT/W1FWHrlivE3I+Bs99iBJFEGeFI/2KwB3hwMI+4cr2ADax+gWvD5E0NjspkqUMY
         0fF1FhIoP0IIXzUJO/5ppHi/6U68dF9YuzyyA+A70jMPFOAW0loNsYb/ZBGjpYCztITq
         hH/1Xdqwswh/tTEwoT9iPrKLVvVBRtphbXq/2OjdKbdvTidWEZVprz5evxKQoQWT8koF
         3HmKDNxTcX6Dszyunwm8hJQmycfKQb1x1JnQXvbiqJbHNg6frX4iYM0D8ppgMRBwb5EC
         Hpig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=f5aVc+Rvip+i9wMcJgMkN6n1iKUg3nhAfrxBMVSyMT4=;
        b=T4rSOneaOFkeppqcf/TPQuqfMztHJ+aYcs9XvpfsNFd/Pmx0XJuwyCVVBvwzd3nY/9
         THr2OJ2FCEHkenZLTXKbqxMenXERKetBfDCBXaQo8IC214T4ZlAAaBEnGuHFVMa/gvYH
         EyMA2uX4LTNCrm/ElpxzN93p9FGMXcI6HSRljHmYkAif6HOvwbGzOGSAXm/7M/hSfuUx
         0Oz+noCANzmjeOIs6/jQN+gAI5fVwzQU5PPRNz7nIizcoI7zQKgkbCoEUyZ54IOOzs7g
         0hHJLzhfZVSFKb4lX7FVOWuCmTDvFizBpOMpL4TFlSfau1D23bPbrUXogpk5/eM9IFAc
         53AA==
X-Gm-Message-State: AOAM5304uiyxI8YtB2ogllnjHVKbP3bnc67fEcXsTAwwF+IMoufTA4ZU
        EGjvDeuXVnJ0TJye3XxWe4o1/6gruQ==
X-Google-Smtp-Source: ABdhPJzg3UQt5rHaAWRDbjaVURR4h5zvemaUui/0KjMvb56pW5ExH/QtQ/Ip8bFpXf7E2bMmRWcmIg==
X-Received: by 2002:a17:906:c787:: with SMTP id cw7mr23033729ejb.157.1618941538855;
        Tue, 20 Apr 2021 10:58:58 -0700 (PDT)
Received: from localhost.localdomain ([46.53.250.121])
        by smtp.gmail.com with ESMTPSA id z22sm13269026ejr.60.2021.04.20.10.58.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 10:58:58 -0700 (PDT)
Date:   Tue, 20 Apr 2021 20:58:56 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     Michal Hocko <mhocko@suse.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Mike Rapoport <rppt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mike Rapoport <rppt@linux.ibm.com>, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] docs: proc.rst: meminfo: briefly describe gaps in
 memory accounting
Message-ID: <YH8WYJU2Jk6S9YIJ@localhost.localdomain>
References: <20210420121354.1160437-1-rppt@kernel.org>
 <20210420132430.GB3596236@casper.infradead.org>
 <YH7ds1YOAOQt8Mpf@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YH7ds1YOAOQt8Mpf@dhcp22.suse.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 03:57:07PM +0200, Michal Hocko wrote:
> On Tue 20-04-21 14:24:30, Matthew Wilcox wrote:
> > On Tue, Apr 20, 2021 at 03:13:54PM +0300, Mike Rapoport wrote:
> > > Add a paragraph that explains that it may happen that the counters in
> > > /proc/meminfo do not add up to the overall memory usage.
> > 
> > ... that is, the sum may be lower because memory is allocated for other
> > purposes that is not reported here, right?
> 
> yes. Many direct page allocator users are not accounted in any of the
> existing counters.

Does virtio_balloon dereserve special mention?

From inside VM memory borrowing looks like one giant memory leak resulting
in support tickets (not that people who file them read internal kernel
documentation...)
