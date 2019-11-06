Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4CEF18A4
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 15:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731652AbfKFO3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 09:29:23 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:42739 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbfKFO3W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 09:29:22 -0500
Received: by mail-qk1-f195.google.com with SMTP id m4so24701479qke.9;
        Wed, 06 Nov 2019 06:29:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2GATQh9QnxiyjasbxBbsJNEOf41Ei8mi8CHA7O3/c2M=;
        b=gXrtET1TQdYdGeYUHKyCiAW1aHbOJIExWToekZIopdIRKTWSZ/sChvwjtxbVxiTEHA
         9aqRM4J42ciVboxTVwxGbW7vkYweZm7pSkuz0mXRk4pmOBIBk0x3c4lHcFIVAXcn5T3V
         Of91FI1+2TCV7oKDgjxbYgxSpqZLB0mXLkHnUjOQ7klHRpQQ9FrSksZjYB9mD5CaEb6p
         uvZsAG4fZtYZn+f6jyUkko5kmH+qorMN89LXVyu0QCtEyRc5nCdpPmp5CZ4ecF+kPrCa
         YtY6+yB65k/Rb/wuti9fDKyeTA22V7W+npbHn130f3bqXF6mhh0CmtNO4/3Y57hWwZB5
         GnOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2GATQh9QnxiyjasbxBbsJNEOf41Ei8mi8CHA7O3/c2M=;
        b=Hkay5Zgutahyvr6zeNOOlAwZ06x8UuOISvEdfZzNuKEJFkaeLLb+2cfzfKiC6mtCTJ
         bQnnbOZdnHD0AyzRkTWne/n0mulKIaLklk5/u8+1LYu+dgdauLZOI/uUY3p70qysq5iu
         2ZKSDRQYLuRRV9nA+M9Q/qMHSbDmvCl41/5vwyRYdKqfXs2wNCHE+HhYd4DAyZbZcV3h
         W1TKylg5wN9aomlvFeGjGDvwa6/K/un2sHRr0EYm+g6/Ic5IyRNkSjFuJ7829DnHkibY
         UpgXPE48JMY/rooa6Lt2o7f+DMEdbrSPRq0M+0xISeoQjLP+ZVOqcxEPJwM1lRwSD3w2
         dFCQ==
X-Gm-Message-State: APjAAAULdSC6cHMVHgJLQedkr4QsfYk+IT1TeQL65mMwApK0/NHUIpO/
        mXOQ3ZLkfx+UfqH81D52wNk=
X-Google-Smtp-Source: APXvYqwAqxBqGM/vQADqcaKE0erkVy1+wvQqoxgECbpMO9KBeJif8pH6jIiMULlswQxhYCvXOyZefA==
X-Received: by 2002:a37:de13:: with SMTP id h19mr2179065qkj.193.1573050561658;
        Wed, 06 Nov 2019 06:29:21 -0800 (PST)
Received: from quaco.ghostprotocols.net ([179.97.35.50])
        by smtp.gmail.com with ESMTPSA id x133sm11773819qka.44.2019.11.06.06.29.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 06:29:20 -0800 (PST)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id B0CBA40B1D; Wed,  6 Nov 2019 11:29:18 -0300 (-03)
Date:   Wed, 6 Nov 2019 11:29:18 -0300
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Ian Rogers <irogers@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andi Kleen <ak@linux.intel.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v5 01/10] perf tools: add parse events handle error
Message-ID: <20191106142918.GB6259@kernel.org>
References: <20191025180827.191916-1-irogers@google.com>
 <20191030223448.12930-1-irogers@google.com>
 <20191030223448.12930-2-irogers@google.com>
 <20191106140650.GE30214@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191106140650.GE30214@krava>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Wed, Nov 06, 2019 at 03:06:50PM +0100, Jiri Olsa escreveu:
> On Wed, Oct 30, 2019 at 03:34:39PM -0700, Ian Rogers wrote:
> > Parse event error handling may overwrite one error string with another
> > creating memory leaks. Introduce a helper routine that warns about
> > multiple error messages as well as avoiding the memory leak.
> > 
> > A reproduction of this problem can be seen with:
> >   perf stat -e c/c/
> > After this change this produces:
> > WARNING: multiple event parsing errors
> > event syntax error: 'c/c/'
> >                        \___ unknown term
> > 
> > valid terms: event,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_state,filter_nm,config,config1,config2,name,period,percore
> > Run 'perf list' for a list of valid events
> > 
> >  Usage: perf stat [<options>] [<command>]
> > 
> >     -e, --event <event>   event selector. use 'perf list' to list available events
> > 
> > Signed-off-by: Ian Rogers <irogers@google.com>
> 
> Acked-by: Jiri Olsa <jolsa@kernel.org>

Thanks, applied.

- Arnaldo
