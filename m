Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33F6219DA35
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 17:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404352AbgDCPcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 11:32:20 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:43383 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404212AbgDCPcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 11:32:20 -0400
Received: by mail-qt1-f193.google.com with SMTP id a5so6718726qtw.10;
        Fri, 03 Apr 2020 08:32:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=y7To2c0IPcP+NtVX1KTJaYfy+X+WHPG5TXUQtYJZhYg=;
        b=jgurJFufNjK8kU2P7yjDWN1ftchUwklQ+yP83wv8ISI/Oo1/tIcSRTj1zMPFOYzWZW
         WFU3Ckt1haCQbbVS9/7VT5HigWCXBMSOthcvYfRkN7eE9LI47BPxVy0JIo/GM+SQ7zBA
         4PrHyF1vTPpkVHWHhCLKPdHLallAUPhZb50VCwgIbYngvHEub9k1yyD3DiMoQzWDBfXa
         MUgQRDDH215ocTDvm0zw2XTzk5UPoEGrrDs6xz0Zwk11JxFwoCn7TeT3a/9jvKGrdxsa
         XRXJ+R3agLrDDNPAJ99z04uKCxlEwRUtl52Y3AYp+RdT+FmhP6P2HZ/YVNljDJZUhHGG
         NbjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=y7To2c0IPcP+NtVX1KTJaYfy+X+WHPG5TXUQtYJZhYg=;
        b=ZHEox8gjrlFY8yH9ZeEsKGYjr3E+CN6U8oSqOW8/bhG/TRv5Z0LTgkwm4lptLOxEm/
         zE3lMX+BLpVc3BxtgI+xqnLWR6HtK8crKyLaR+ZKaJrkdfxOOReyyNawWoBmespGBZf+
         MWhtpmRZwv5MJScjqa7R0H2OZr9NKd3NUCjiA+Xz6AwRkRQ42H+m+Dap3taIhWmPEnU/
         Ba5eBhHYlfQoxatbQac0GMVFB/04NNtzMnyqcPXM27268yQlMchk4zMMJO2LymgCne3l
         Qw5xGyQV+H5JmU2dCPFHxXFkMdZXmCaoXuCI0SRMikmxq7ZZRrREvU6E01yECQwROotb
         2XxA==
X-Gm-Message-State: AGi0PuauYMz1j0YA2+vSZP2b4W8m3IiXSW2A0PoGLD8NlT5y4VZxe+ac
        aBKCHsSsV00uHsZY4TRTsxHu1vevY1AaRQ==
X-Google-Smtp-Source: APiQypKiAYoUEbEGh58Gu2fYUDs6qwPuJ+EPNz6A9/uiOzNGa/Hr39a0CbUn2+a7sgbx7CbbdegyzA==
X-Received: by 2002:ac8:4e56:: with SMTP id e22mr3449753qtw.185.1585927937980;
        Fri, 03 Apr 2020 08:32:17 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([179.97.37.151])
        by smtp.gmail.com with ESMTPSA id o186sm6489184qke.39.2020.04.03.08.32.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2020 08:32:16 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id D3A57409A3; Fri,  3 Apr 2020 12:32:14 -0300 (-03)
Date:   Fri, 3 Apr 2020 12:32:14 -0300
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Song Liu <song@kernel.org>
Subject: Re: [PATCHv5 00/15] bpf: Add trampoline and dispatcher to
 /proc/kallsyms
Message-ID: <20200403153214.GA25386@kernel.org>
References: <20200312195610.346362-1-jolsa@kernel.org>
 <20200313023927.ejv6aubwzjht55cf@ast-mbp>
 <20200313083151.GA386262@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200313083151.GA386262@krava>
X-Url:  http://acmel.wordpress.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Fri, Mar 13, 2020 at 09:31:51AM +0100, Jiri Olsa escreveu:
> On Thu, Mar 12, 2020 at 07:39:27PM -0700, Alexei Starovoitov wrote:
> > On Thu, Mar 12, 2020 at 08:55:55PM +0100, Jiri Olsa wrote:
> > > hi,
> > > this patchset adds trampoline and dispatcher objects
> > > to be visible in /proc/kallsyms. The last patch also
> > > adds sorting for all bpf objects in /proc/kallsyms.
> > 
> > I removed second sentence from the cover letter and
> > applied the first 12 patches.
> > Thanks a lot!
> > 
> > > For perf tool to properly display trampoline/dispatcher you need
> > > also Arnaldo's perf/urgent branch changes. I merged everything
> > > into following branch:
> > > 
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git bpf/kallsyms
> > 
> > It sounds that you folks want to land the last three patches via Arnaldo's tree
> > to avoid conflicts?
> > Right?
> 
> right, thanks

Thanks, applied those 3 patches, will try and test this all when I get
my branch merged,

- Arnaldo
