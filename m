Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 879ABF18AB
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 15:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731665AbfKFObz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 09:31:55 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:38085 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbfKFObz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 09:31:55 -0500
Received: by mail-qt1-f193.google.com with SMTP id p20so15626913qtq.5;
        Wed, 06 Nov 2019 06:31:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=JggrbZPVaiVzXbq+DGZI87bNjE++01il9vOKZ8JWpJ0=;
        b=mkpwWNqzhlZS6hEDUW2cRoKy8gXQaSXb0ZEvpvwsJlvIWIDp1fEO2jz3i/QDYfDnHR
         hNsv1i5w+vZkxgzFPhzmJANIi0boBmJHSYCpJsJlu4RfzwpDddihPJTZhRxAhJqY7g36
         gAlgjzF6ZcayNgnWh63vGga2AydTPtV+LeSmkiV2dqLtlJCqwn+QDFVhbMjmbeh2nBEi
         1QTpyLearIkUtV+7MXe3MJRj81MWAwio55NhIBjM/XFqSTWs3GrZz1R3cghFtbBBbmgI
         iKrlgJ4ASUseX8mLn3oxtX1hQD82MMM+Q+SwfNhJhPr9EipPfqc2e5uthJF+54AbgL5N
         OAeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JggrbZPVaiVzXbq+DGZI87bNjE++01il9vOKZ8JWpJ0=;
        b=OuEvwrk6YyGES3kiHjkyth04FjtS5/ORJyuxxw7v7mhF8UfrRznB50aKnzNyA50h2b
         TcKw+ZfnSuyV+DjFwBkGcYngBaM7ndvIjP6jCZSElya488NV0mAc8R20v7HEOqsYHb4S
         6W2wfcf7WV/Vc/Jai6SqnN5yniAbTkcsrkjMni0HMFLgDD4b6Us6Z2ThNOL5UZRdwX1G
         wcB1TbzFoRg6VyRNs0/N9SDfaTGF4oiO6Chgw3vGoklGhx+CIZxUno8dQHblX935jUJe
         xmGvHjn/RladI5F0JeUJczbeEySUf1MGwsTRsdyIO4nW9lZSwa98PRuMACP4pOq4/CGw
         duGQ==
X-Gm-Message-State: APjAAAU48/W8KpnYtWkvTh3P7BqFv0p55oKUxQNWgbj68fNGKlZKHh2U
        2SG/OZYCZ6O2DMQ9IzVPKPU=
X-Google-Smtp-Source: APXvYqyQlQQstY6ckpzdxTq3eqyaTVMV1RbzAKXFHZ0p2+80Z3cUQ2hw1PgqERO7Z2iHF/jYWW8cTQ==
X-Received: by 2002:ac8:31c1:: with SMTP id i1mr2652197qte.197.1573050713934;
        Wed, 06 Nov 2019 06:31:53 -0800 (PST)
Received: from quaco.ghostprotocols.net ([179.97.35.50])
        by smtp.gmail.com with ESMTPSA id q3sm12827090qkf.18.2019.11.06.06.31.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 06:31:53 -0800 (PST)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 5EB2940B1D; Wed,  6 Nov 2019 11:31:51 -0300 (-03)
Date:   Wed, 6 Nov 2019 11:31:51 -0300
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
Subject: Re: [PATCH v5 05/10] perf tools: ensure config and str in terms are
 unique
Message-ID: <20191106143151.GC6259@kernel.org>
References: <20191025180827.191916-1-irogers@google.com>
 <20191030223448.12930-1-irogers@google.com>
 <20191030223448.12930-6-irogers@google.com>
 <20191106142503.GK30214@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191106142503.GK30214@krava>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Wed, Nov 06, 2019 at 03:25:03PM +0100, Jiri Olsa escreveu:
> On Wed, Oct 30, 2019 at 03:34:43PM -0700, Ian Rogers wrote:
> > Make it easier to release memory associated with parse event terms by
> > duplicating the string for the config name and ensuring the val string
> > is a duplicate.
> > 
> > Currently the parser may memory leak terms and this is addressed in a
> > later patch.
> > 
> > Signed-off-by: Ian Rogers <irogers@google.com>
> 
> Acked-by: Jiri Olsa <jolsa@kernel.org>

Thanks, applied.

- Arnaldo
