Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5F85149648
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 16:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbgAYPfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 10:35:34 -0500
Received: from mail-wr1-f54.google.com ([209.85.221.54]:45204 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgAYPfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 10:35:34 -0500
Received: by mail-wr1-f54.google.com with SMTP id j42so5596844wrj.12;
        Sat, 25 Jan 2020 07:35:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xyw3kGR8+Lt40R7yTJnWVGBIalxxmzFG4sCrf0fRpdk=;
        b=ExnzLl6hwfYK4ikbGFBXhgOCY0XHCsYn9z4SRQg/A+5FF2hjZpyEiXcTrmfzV2L48x
         tT9MyEdGAsbQDNIeCAyjhy5OggIDg7J8MAN8j64PKZx5FQiq5tlJ99a0cJeha2sU+6ya
         VxC/qfidvLYeVFipWXAmYzIwsgjAuo+FmddR7U1i2avSvcmw1Wa1cj9sxtdhQemFDSMD
         cEmiFB55NR12lIHfw6/nN0qvKgqCSaxpOjutAFqfstvZtDaODInNaXqwJLlk8ypFdRYT
         NBhAfIn6qv+PJonm0JGo0FEPfz3LVU2+iMspAbHx5QTQvUWrVUldmyvdkoiLr8mMOPvm
         Y7Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xyw3kGR8+Lt40R7yTJnWVGBIalxxmzFG4sCrf0fRpdk=;
        b=bK3TU5zI05eCkzRkWIWriGofi18vUqigkQDHPw2X4laAnrhflrAA3/ZrN8eDgipOd4
         FkGro4i272fbq0u99pKg54pAuUEfZdrX4+FGQgZhf+xGDUxUC3+Y12hcM/Y1NtKGh2sH
         SvsD4G0wAGcp4NmNNBRA/zL0RQNEgBXSAkPgA2JQGIuUQz0LmRixmwacEuIlCw0jTCtz
         2LVi3pnGe7Q3OOl8pGq4PV/ciC6fcpzmgD3bOMgU9D7tqq1p7IJ7RcP5LEcL9Caq71Qz
         SiMZ0zc6bY2C5+UtgOVlb6tKSzvglYNY8a7C2LQjXlkaF3WYnEor3FiKCzfdkp8nmplY
         jvTw==
X-Gm-Message-State: APjAAAWEJKv3rqNp2PgnXWhe/dcM8FFUeM/qRgLRIAlNCOScEuCNrluk
        cQZUxPMTliHLYSFX84PvKGo=
X-Google-Smtp-Source: APXvYqzEY5ESYqOPkjKCdDdQEMJsBA9eWajCieXqf4Y1E0tZrHcyQBjLplbv6eP7JgL2k52vbQU1wA==
X-Received: by 2002:a5d:5091:: with SMTP id a17mr10749475wrt.362.1579966532031;
        Sat, 25 Jan 2020 07:35:32 -0800 (PST)
Received: from quaco.ghostprotocols.net ([147.229.117.36])
        by smtp.gmail.com with ESMTPSA id r68sm10751950wmr.43.2020.01.25.07.35.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jan 2020 07:35:31 -0800 (PST)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 8B89840DFD; Sat, 25 Jan 2020 16:35:30 +0100 (CET)
Date:   Sat, 25 Jan 2020 16:35:30 +0100
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Miller <davem@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCHv4 0/3] bpf: trampoline fixes
Message-ID: <20200125153530.GC26877@kernel.org>
References: <20200123161508.915203-1-jolsa@kernel.org>
 <CAADnVQLBQ2t30BwqBb9wJc5rM5M9URvKk25HUBa94PuL8tYcDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQLBQ2t30BwqBb9wJc5rM5M9URvKk25HUBa94PuL8tYcDw@mail.gmail.com>
X-Url:  http://acmel.wordpress.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Sat, Jan 25, 2020 at 07:23:21AM -0800, Alexei Starovoitov escreveu:
> On Thu, Jan 23, 2020 at 8:15 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > v4 changes:
> >   - rebased on latest bpf-next/master
> >   - removed image tree mutex and use trampoline_mutex instead
> >   - checking directly for string pointer in patch 1 [Alexei]
> >   - skipped helpers patches, as they are no longer needed [Alexei]
> 
> Applied. Thanks

While watching Jiri's talk about bpftrace, cool.

- Arnaldo
