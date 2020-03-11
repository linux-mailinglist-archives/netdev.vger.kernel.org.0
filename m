Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA3F18248B
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 23:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730094AbgCKWO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 18:14:27 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39380 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729590AbgCKWO1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 18:14:27 -0400
Received: by mail-pf1-f196.google.com with SMTP id w65so2134012pfb.6
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 15:14:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TRMbc2MT59fcHMzxfJmkV+RwRUiISDxKXrIl7C0tzJ8=;
        b=l6iSu1+QIjuheIWrgAg7mrwXqXl4LzW6ZTeMnsYUqW03Pd6q9qM1pVhqqIALR+rOPT
         7zVVFhKtL5CVS8e8dXYeyjEhvdQ3KFFaHY7mCAcnyi+KtqTVaFj8UAPfl0ftPKwf6C3P
         k0mqhnv01geSKL4uUnr3aOXOU6FKSrq6GznHHbMfav9qTnoGBT94VsY8iKyDL0g2NZEv
         h/VhhM+cTRmhrp+RZxhHKx+uODfewUFx7G8ueKdDL1NXLTf1zVRytgn4DILI9FzIWKRy
         vg42kxErzDyh1fzCAMTG2NW5FI1qc8LlfySoXMxArOFcw7NQd1PSuKNlJSGp4HtkdBom
         plSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=TRMbc2MT59fcHMzxfJmkV+RwRUiISDxKXrIl7C0tzJ8=;
        b=ntQz3l7QSWUip5r6Tq0pvVRP3gyQeqRqzkPyKjDrlbAEBzGZhNJx4qJnKKkxD/hV2L
         VPJMHvIRdHuKuQvZYxpNGHfdypfI2exNcAuUYLGBeoM52Wbw7KOwE9XGEyV2KQ3QdIg3
         CoS5+FUf0nbZoE/J4KhOIMBE12+G4mum9YaKhruxRJPoEdoV8oOVurhU76JPssXfmTWG
         +LLUvr5zrrd9VbCdfozqLOh/sd+PTdY5sAjsb87EhTM5dfDYWYLfobizLeAQzW834ogk
         EqsQA6MkoO+vCCbPJVG00FIIDuS5rGabQ1acjmgkrxJQlOMrKGVAhPDYOYs4mRQks/s5
         fkKw==
X-Gm-Message-State: ANhLgQ0ROZx1BhJVOuYlSEDWP1M9Fw9qBxD7W9vt93L99Rd9UJbPZwmq
        JDqf24mZ9a4Khz6aANX7Ro+GHg==
X-Google-Smtp-Source: ADFU+vvxWT/FHdVxFcVplZDdwO7f6/ZRxvRLLxHD0gNMNuvrQ2bmwbRKmm0zyI3X9jqYYREwWoXAYg==
X-Received: by 2002:a63:be09:: with SMTP id l9mr4659363pgf.439.1583964865600;
        Wed, 11 Mar 2020 15:14:25 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id v16sm6504587pjr.11.2020.03.11.15.14.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2020 15:14:25 -0700 (PDT)
Date:   Wed, 11 Mar 2020 15:14:24 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@google.com>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: make tcp_rtt test more robust to
 failures
Message-ID: <20200311221424.GB2125642@mini-arch.hsd1.ca.comcast.net>
References: <20200311191513.3954203-1-andriin@fb.com>
 <20200311204106.GA2125642@mini-arch.hsd1.ca.comcast.net>
 <CAEf4BzZpL83aAhDWTyNoXtJp5W8S4Q_=+2_0UNeY=eb14hS8aQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZpL83aAhDWTyNoXtJp5W8S4Q_=+2_0UNeY=eb14hS8aQ@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/11, Andrii Nakryiko wrote:
> On Wed, Mar 11, 2020 at 1:41 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
> >
> > On 03/11, Andrii Nakryiko wrote:
> > [..]
> > > +     pthread_join(tid, &server_res);
> > > +     CHECK_FAIL(IS_ERR(server_res));
> >
> > I wonder if we add (move) close(server_fd) before pthread_join(), can we
> > fix this issue without using non-blocking socket? The accept() should
> > return as soon as server_fd is closed so it's essentially your
> > 'server_done'.
> 
> That was my first attempt. Amazingly, closing listening socket FD
> doesn't unblock accept()...
Ugh :-(

In this case, feel free to slap:
Reviewed-by: Stanislav Fomichev <sdf@google.com>

My only other (minor) suggestion was to add a small delay in the first
loop:

	while (!server_done) {
		accept()
		if (!err) {
			udelay(50) <--
			continue
		}
	}

But I suppose that shouldn't be that big of a deal..
