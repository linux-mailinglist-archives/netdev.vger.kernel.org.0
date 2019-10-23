Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFA31E1ACB
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 14:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390248AbfJWMhh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 08:37:37 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:36922 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389224AbfJWMhg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 08:37:36 -0400
Received: by mail-qk1-f193.google.com with SMTP id u184so19581808qkd.4;
        Wed, 23 Oct 2019 05:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qUcU8tYS8AaPxbMdH2brsHpiQ65c4Xn61wez29PlY7w=;
        b=a1zbOdUzyDkz1r/Z8QKDQd6doLVOv25lwRWV2KL3H3Iifhgsq8JC4A/JvxADFOS+2T
         ESN7+yx4dqRy7d98KiLWdUDp1c9MLOfX67Z2PODH3qpn5SlcM804otdmXcEqJnFz3fan
         x7wTIuDO0MEgLnIbJ7iQODrlMA/iNNzDInWatOfffN6y1AP0X4AKc21isQcWiaUf4MND
         PeNWPr6oAZmMoZ54movCMHLJ6dOn55HXSCISbCTeMSr1D2/T2sBBKxeGj2DUQiOOodED
         1LC62UX9y+Iyc9ALDWnpOFl0ZJFVxX15ZNAY9/4q1YbESOj/5mTDBj9LwTVXJGLKVDf3
         Stgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=qUcU8tYS8AaPxbMdH2brsHpiQ65c4Xn61wez29PlY7w=;
        b=DB52R3VvdO0gO4+IYoeizcQNL+ajyk1GXxU2KjXHmYERbnrZsk9BF+A8+nmqjWjR6b
         D9cmqKu32pPPqeEHbRoFY5eBuW5ar0ykzfyE8nXULJ2PMfZpUJ1Z9kTlLdQV1ZOvZYGM
         C2JsS6JI5cS+82JGUd8XYT7jXo2UhialRw8qJnRXuUfUtm+Tw6ozC6za+DnbIexnzXiL
         9x2fjI3EhqqL6Kc2jjt3w6tEixMCoKfILO536p8hz/wPr4UT4qTSCoEGXTQbuXjDi9vR
         mfpGxJDjL9IhYk8UxcvNNHg+jbcaxq0VwGo4cfI6Ran0FrraMrNkIlPJByFbIf2ZnAvj
         3fRA==
X-Gm-Message-State: APjAAAWjjTMCISmXsFrT72UAvemyYuOuRH6zK7lKvuJrP2EVQvlDlHsU
        WO1tDgx213ugXeWNM7Rtz3g=
X-Google-Smtp-Source: APXvYqwb4Gxxg0bNqt0B8QNBEa3brTRep/8MetjOjp/uOjvmNW6Hp5pfihBsy/Tb0A6fY+H2Ch0fCQ==
X-Received: by 2002:a05:620a:a53:: with SMTP id j19mr8350870qka.11.1571834255264;
        Wed, 23 Oct 2019 05:37:35 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([179.97.35.50])
        by smtp.gmail.com with ESMTPSA id g8sm16132987qta.67.2019.10.23.05.37.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 05:37:34 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 2EC364DDC9; Wed, 23 Oct 2019 09:37:32 -0300 (-03)
Date:   Wed, 23 Oct 2019 09:37:32 -0300
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
Subject: Re: [PATCH v2 4/9] perf tools: move ALLOC_LIST into a function
Message-ID: <20191023123732.GA15998@kernel.org>
References: <20191017170531.171244-1-irogers@google.com>
 <20191023005337.196160-1-irogers@google.com>
 <20191023005337.196160-5-irogers@google.com>
 <20191023085559.GF22919@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191023085559.GF22919@krava>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Wed, Oct 23, 2019 at 10:55:59AM +0200, Jiri Olsa escreveu:
> On Tue, Oct 22, 2019 at 05:53:32PM -0700, Ian Rogers wrote:
> > Having a YYABORT in a macro makes it hard to free memory for components
> > of a rule. Separate the logic out.
> 
> Acked-by: Jiri Olsa <jolsa@kernel.org>

Thanks, applied.

- Arnaldo
