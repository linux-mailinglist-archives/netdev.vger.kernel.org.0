Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4AD1E3048
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 22:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403987AbgEZUvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 16:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403969AbgEZUvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 16:51:12 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA945C061A0F;
        Tue, 26 May 2020 13:51:10 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id j21so10633426pgb.7;
        Tue, 26 May 2020 13:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=JDCjEBwyvZfUeJw9bPCiqLmIBbR8GM0KiGn9Dhm2E+Y=;
        b=aQ7SPJ5pd+5QqzLEyNUBOJjOwEm2dmfdnfu4oQCvgC2ot2hbEecM29H60M1RTVdFUe
         MxgQAwRQ/JRpWsIc0VdCjxhpQLM5RIC1jStURaFo0V3J6Sz5jJUf3fZMZhKauV1z02B/
         QXd8+lWPz/And2hKcLG9vhsI0IRcC5nLQ7D+yXVMtEb4k6mp15zGhlxeXopoAgPsI4LZ
         978Hlxz4JGl5l7LDAFfr42VqhYCOiSrVDpHWgEtJHuySKWgz5ok7hx5Af7T1wQeYWGBa
         BQJJ+kOY7aXgXUX6uTibESbOQEECcgWJh9NBhqYPmt1HSZxkOBya5WmFKjkUE6WeiGIj
         f4eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=JDCjEBwyvZfUeJw9bPCiqLmIBbR8GM0KiGn9Dhm2E+Y=;
        b=dvBIG0hREFLJ9aK/xEaGpq5uvepBOdXxcviWVtt9wSuRuUeWPtK+vxxGDbWcTRA8ml
         1I/JPbvCUowlSVzITqMWuB+/b8VaY5/Dx5BAoOsjtC1bC1NQz4Gc612jzH29cvGDnENT
         ZpQefpWtNCqTAAtqySBVMgrHQd5x5wrh0LCTr7daxBawb5pplaoYrh3J8HT3LQW06hzM
         DJiIaEBesAcPiNM4h/TlbdC5rN1arxnlpWMD37zSSvGe4uJr6NZLeZb+Uo8QUzlDnO8M
         PQhsl9/cMH5eiRoU8ydIWpegpg7WhpDeVdDDOQ5M406aosiOZdOK84DIKEzGeXLx9DAD
         Trpw==
X-Gm-Message-State: AOAM533w+tPvY4z+ITbwVgQLG0Z+p5MP2PZM6vkKBPC2UQ17Oud/PAnl
        4qahFD+gM5BYvUtGp5BE8YAS+E6K
X-Google-Smtp-Source: ABdhPJyQvfzeo5P5wAZ8LZABsrKzt+50hYLz8ptDuLMDY73ETB5A+UJQM65GXgvz9B0GGY0vinNS2Q==
X-Received: by 2002:a63:5d55:: with SMTP id o21mr704726pgm.58.1590526270522;
        Tue, 26 May 2020 13:51:10 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id m12sm436597pgj.46.2020.05.26.13.51.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 13:51:09 -0700 (PDT)
Date:   Tue, 26 May 2020 13:51:01 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Message-ID: <5ecd8135d7ab4_35792ad4115a05b8d@john-XPS-13-9370.notmuch>
In-Reply-To: <CAEf4BzZ0b_UyxzyE-8+3oWSieutWov1UuVJ5Ugpn0yx8qeYNrA@mail.gmail.com>
References: <159033879471.12355.1236562159278890735.stgit@john-Precision-5820-Tower>
 <159033903373.12355.15489763099696629346.stgit@john-Precision-5820-Tower>
 <48c47712-bba1-3f53-bbeb-8a7403dab6db@iogearbox.net>
 <5ecc4d3c78c9e_718d2b15b962e5b845@john-XPS-13-9370.notmuch>
 <CAEf4BzZ0b_UyxzyE-8+3oWSieutWov1UuVJ5Ugpn0yx8qeYNrA@mail.gmail.com>
Subject: Re: [bpf-next PATCH v5 1/5] bpf, sk_msg: add some generic helpers
 that may be useful from sk_msg
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> On Mon, May 25, 2020 at 3:57 PM John Fastabend <john.fastabend@gmail.com> wrote:
> >
> > Daniel Borkmann wrote:
> > > On 5/24/20 6:50 PM, John Fastabend wrote:
> > > > Add these generic helpers that may be useful to use from sk_msg programs.
> > > > The helpers do not depend on ctx so we can simply add them here,
> > > >
> > > >   BPF_FUNC_perf_event_output
> > > >   BPF_FUNC_get_current_uid_gid
> > > >   BPF_FUNC_get_current_pid_tgid
> > > >   BPF_FUNC_get_current_comm
> > >
> > > Hmm, added helpers below are what you list here except get_current_comm.
> > > Was this forgotten to be added here?
> >
> > Forgot to update commit messages. I dropped it because it wasn't clear to
> > me it was very useful or how I would use it from this context. I figure we
> > can add it later if its needed.
> 
> But it's also not harmful in any way and is in a similar group as
> get_current_pid_tgid. So let's add it sooner rather than later. There
> is no cost in allowing this, right?
> 

It shouldn't cost anything only thing is I have code that runs the other
three that has been deployed, at least into a dev environment, so I know
its useful and works.

How about we push it as a follow up? I can add it and do some cleanups
on the CHECK_FAILs tonight.

Thanks,
John
