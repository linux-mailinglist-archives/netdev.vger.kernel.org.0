Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32C2B10B2AE
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 16:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbfK0Psy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 10:48:54 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:35664 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726852AbfK0Psy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 10:48:54 -0500
Received: by mail-qk1-f194.google.com with SMTP id v23so12087612qkg.2;
        Wed, 27 Nov 2019 07:48:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4J4gsFOGRrpsPSqOPbv4wsUCG7tJIMG82XdZIms//v8=;
        b=QONFIjeTtTXkRHyAU5Lt60TaKCnlTyEcOnDXcxBWksuN3VsqMFSJ1Qk2/GElhag36Q
         jVM5mpJVASUeBHbmNUrQpMgSjUFYXvzK/AakrZHC0SgqsJZYNdjHWFfpJ4i5bntdezsX
         GuW6V6758Gy4JAdbIq6owUUueNfrIHWVa2b+flDwF4nh7OCrKAQk/Kmj4XcY7pU++aCc
         bVLkMN7eHbT9rhgTmVvCM9zjypp0/2HGSR7OHaORixQASE5MKGN6phghvfCSPtqtDJ9Q
         slvL2I2qTIR6UxTFfwBy1wVwxW70oP7k4u3mO9Ekk7mar2G+Xrfd6+J5dec+WHTLze4m
         8cTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4J4gsFOGRrpsPSqOPbv4wsUCG7tJIMG82XdZIms//v8=;
        b=DDW6JSI3uNYnKMWXqM6+vTDWltDVRqH4Z2ezPUrOEUWbsX8twOLhmk2WhCNUjIO4tp
         cd6rMnVrGPfMUQhTGqmunByK+WUo4e2qBvPIVwCuwXMK0jFM8tD3uspq8Wp4+DaFQPTV
         XEOH3fa5C1sKfxDgX5Vw4lDWQLMLahjtdLrc+5yT5B0gSxvwmCN5tNOGgMgwMI0jpBd4
         btv7S6rRUojtYNOMl9Kl60gIU2p4nFvYjug+86a3EtJhiGgyhA4i91q7l70CetBBJ/Tl
         txJmIAietzGhYR2y1D7aF8kyhZEJacVe+2yrHkAvZasVeWCxsYsIqodAEsTqLi/RPo8F
         1yZg==
X-Gm-Message-State: APjAAAXjHu7mTbpFAEy3XFV4eLieHYJdgoEfbkfjTDjmn8QI8ErCuqvA
        OWeOmUkkuUa1b6cX0N+9xkY=
X-Google-Smtp-Source: APXvYqz3pxKjKkK4XOiDWn4fQCuqSEIvBlvFpcSDtq8IRxtqPkXTfGsopYwZO0Y8jTtnUxvVtxW5/A==
X-Received: by 2002:a37:7443:: with SMTP id p64mr4994497qkc.460.1574869732704;
        Wed, 27 Nov 2019 07:48:52 -0800 (PST)
Received: from quaco.ghostprotocols.net ([179.97.35.50])
        by smtp.gmail.com with ESMTPSA id b35sm2489948qtc.9.2019.11.27.07.48.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 07:48:51 -0800 (PST)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 21E2240D3E; Wed, 27 Nov 2019 12:48:49 -0300 (-03)
Date:   Wed, 27 Nov 2019 12:48:49 -0300
To:     Quentin Monnet <quentin.monnet@netronome.com>
Cc:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Petlan <mpetlan@redhat.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH 3/3] bpftool: Allow to link libbpf dynamically
Message-ID: <20191127154849.GK22719@kernel.org>
References: <20191127094837.4045-1-jolsa@kernel.org>
 <20191127094837.4045-4-jolsa@kernel.org>
 <fd22660f-2f70-4ffa-b45f-bb417d006d0a@netronome.com>
 <20191127141520.GJ32367@krava>
 <20191127142449.GD22719@kernel.org>
 <d9bc04a6-0f72-9408-7c2e-2fb30e6a8f74@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9bc04a6-0f72-9408-7c2e-2fb30e6a8f74@netronome.com>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Wed, Nov 27, 2019 at 02:31:31PM +0000, Quentin Monnet escreveu:
> 2019-11-27 11:24 UTC-0300 ~ Arnaldo Carvalho de Melo
> <arnaldo.melo@gmail.com>
> > Em Wed, Nov 27, 2019 at 03:15:20PM +0100, Jiri Olsa escreveu:
> >> On Wed, Nov 27, 2019 at 01:38:55PM +0000, Quentin Monnet wrote:
> >>> 2019-11-27 10:48 UTC+0100 ~ Jiri Olsa <jolsa@kernel.org>
> >>> On the plus side, all build attempts from
> >>> tools/testing/selftests/bpf/test_bpftool_build.sh pass successfully on
> >>> my setup with dynamic linking from your branch.
> >>
> >> cool, had no idea there was such test ;-)
> > 
> > Should be the the equivalent to 'make -C tools/perf build-test' :-)
> > 
> > Perhaps we should make tools/testing/selftests/perf/ link to that?
> 
> It is already run as part of the bpf selftests, so probably no need.

You mean 'make -C tools/perf build-test' is run from the bpf selftests?
 
> Thanks,
> Quentin

-- 

- Arnaldo
