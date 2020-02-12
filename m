Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3522815AA0B
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 14:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728009AbgBLNbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 08:31:33 -0500
Received: from mail-qv1-f66.google.com ([209.85.219.66]:42875 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgBLNbd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 08:31:33 -0500
Received: by mail-qv1-f66.google.com with SMTP id dc14so890112qvb.9;
        Wed, 12 Feb 2020 05:31:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=myZUd9/EmvSZIipj4aycXbLr16w30buYk0xA+FZcMZU=;
        b=cTKJfozoaBYtXHn0s+YZrxbQ5Q62gzDLv9rd50YJ0haP8AcvNBIUZ69Ck4GUzesGfz
         sqEVGTkAMMoKN+sVP+yOiF3WjE+ttFF5VWIimqt0qNo+sJF7glJZcQlAuhtDUUywFhMf
         1D5Md8cAOE2iCOnq75X47ajgDrxxbt9DLSXwrVzW8wCJtZwuHH8wBNta6imu1UnWupRw
         UPSwtvYyDdFJdzGi+ljhloCjVmI3PvKKRsTYR/Hj52/hQQZmj9b2tZ7F7JaPJR/9TxYy
         1xaHywEvVCWUeqMW1/aj0udI92kfP8NTdabgLyTc+LyHQrIPbIZQdaD1s9lp1y6WeAjO
         qCTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=myZUd9/EmvSZIipj4aycXbLr16w30buYk0xA+FZcMZU=;
        b=G7W2TJNbhQ5+m5pSnZ8AQ6nnBUVrQ2BsRTvr8UGkvoPQzcRfPRPt2XrJDJGb3Oj+nM
         AIUpRHS4cK1/jMGnasmFEY/vS/Z0g/lpe+ey+IqT6C9moMkjpOm8owDHf7vPi7F+vm4I
         UQoOcUAdmDG4dJI5azm2VxZZKh/wIjvPnkQ1CY/RtPVgvv4OBn0/jw90iOw9GZIy5gLw
         hGUx/VWg95fTyPFXImN+J7Kwrr6uP/q5bX2l9x1ipfHVX0WsCSbygPJ28W59SSmGrNvo
         vBKb62clv9Q47EtAIWwYM/jbSfNKhGz4Nvnnaf5/zYqbS7yggaKIgyprnrJQsZRAW1qR
         +46A==
X-Gm-Message-State: APjAAAVxPRZCcXXBUdOm/3C7WEm1HkRrNiJPtW8XR6tCeP8rCRJ6tgs6
        jNI8WcMF5L/lz7wcxkixPc4=
X-Google-Smtp-Source: APXvYqzpkZnamk4UBoQA1UDxWfKB08dA8uiLqvcrWLWGIIuI2v01Q/QkJB6psL0bbS6jrec2cfK/mg==
X-Received: by 2002:a0c:edc3:: with SMTP id i3mr7257890qvr.29.1581514292041;
        Wed, 12 Feb 2020 05:31:32 -0800 (PST)
Received: from quaco.ghostprotocols.net ([179.97.37.151])
        by smtp.gmail.com with ESMTPSA id t16sm170213qkg.96.2020.02.12.05.31.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2020 05:31:27 -0800 (PST)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 9E60740A7D; Wed, 12 Feb 2020 10:31:25 -0300 (-03)
Date:   Wed, 12 Feb 2020 10:31:25 -0300
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Subject: Re: [PATCH 00/14] bpf: Add trampoline and dispatcher to
 /proc/kallsyms
Message-ID: <20200212133125.GA22501@kernel.org>
References: <20200208154209.1797988-1-jolsa@kernel.org>
 <CAJ+HfNhBDU9c4-0D5RiHFZBq_LN7E=k8=rhL+VbmxJU7rdDBxQ@mail.gmail.com>
 <20200210161751.GC28110@krava>
 <20200211193223.GI3416@kernel.org>
 <20200212111346.GF183981@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200212111346.GF183981@krava>
X-Url:  http://acmel.wordpress.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Wed, Feb 12, 2020 at 12:13:46PM +0100, Jiri Olsa escreveu:
> On Tue, Feb 11, 2020 at 04:32:23PM -0300, Arnaldo Carvalho de Melo wrote:
> > Historically vmlinux was preferred because it contains function sizes,
> > but with all these out of the blue symbols, we need to prefer starting
> > with /proc/kallsyms and, as we do now, continue getting updates via
> > PERF_RECORD_KSYMBOL.

> > Humm, but then trampolines don't generate that, right? Or does it? If it
> > doesn't, then we will know about just the trampolines in place when the
> > record/top session starts, reparsing /proc/kallsyms periodically seems
> > excessive?

> I plan to extend the KSYMBOL interface to contain trampolines/dispatcher
> data,

That seems like the sensible, without looking too much at all the
details, to do, yes.

> plus we could do some inteligent fallback to /proc/kallsyms in case
> vmlinux won't have anything

At this point what would be the good reason to prefer vmlinux instead of
going straight to using /proc/kallsyms?

We have support for taking a snapshot of it at 'perf top' start, i.e.
right at the point we need to resolve a kernel symbol, then we get
PERF_RECORD_KSYMBOL for things that gets in place after that.

And as well we save it to the build-id cache so that later, at 'perf
report/script' time we can resolve kernel symbols, etc.

vmlinux is just what is in there right before boot, after that, for
quite some time, _lots_ of stuff happens :-)

- Arnaldo
