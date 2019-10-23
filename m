Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 527EDE1AD2
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 14:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390314AbfJWMiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 08:38:06 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:42452 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732361AbfJWMiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 08:38:05 -0400
Received: by mail-qt1-f195.google.com with SMTP id w14so31972806qto.9;
        Wed, 23 Oct 2019 05:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TTxfg8uYCGG6i9hFGyJ0oHAZKHi72jFC6jG4zn1k97Q=;
        b=XFffVwVqJgOaIQp+xpGltzSaVRG+X5kt3ObAyXI3K5+lughh1ATjfvD5NBAAsJODbg
         HsjXmpYjQXMwiTmn+kQwGO7Zh+MnJbsPc3PZ0ETxzY49ibWz8LJaEka/WhGxHsZBW3jw
         KEQ07OaCHixpqhZsL87owKp3ce9pEaiwtTkRkWRZBHa1VJtHMsB8Kp2APGLarSCNs4Pb
         DgQTb3rzxRhW8bxN8jIe6kirZ6yD2aAvcIr69f1khmiiRMygKHbT4kGeOBUdU33i6x72
         oLriPVYKYapGah8V3QQ9/XlTr2cpq7r2dO+CKqg4uG75XMKzjvbWQqg8DyBvzRl9HE7y
         UWGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=TTxfg8uYCGG6i9hFGyJ0oHAZKHi72jFC6jG4zn1k97Q=;
        b=mjDRZv4TAKFAIfcPUwQrPZ2zBw02kkYsunsNurS4XaDrHpNnLWjrhqJIWnDjVlSbka
         IjLtzXov5arywOF6dia/HXOPedLmGtt9EMfbfauD9EYnw9siluxW3Mm+WJp4AWMuA9EV
         9N1+GCRR09o+8qQyXQ4quhN7S5jTmcrERImpZvQc8PiFNUM/dYXrgypK9aKLVZWSJUpr
         YO4RV3gNHLUsEPrt6lfONnH5th2IHV1NyIpKAAVbr1o3OwR/eTxTC/DQo3XnYZ3HJNtU
         yPMhuEnU79jQUY/J0ikOG1dbHrowOFe2FL3yLPVcJBLfJXwGW+Dxh+09QZpHtkcGFIDw
         w3xg==
X-Gm-Message-State: APjAAAVA2iU9H01zY5FW0fdy9lsAh2NbHwaWQXdiySfxz0dlxQpbaMSz
        3U58E0vNw3cLbFoqCMM2aI8=
X-Google-Smtp-Source: APXvYqy5SFIZq5y+J9shsYPIP3Rc3PCvPhXKek+NFYEwkCT27cfLiqu5oPR8Dlza+24DhsBZV56BwQ==
X-Received: by 2002:ac8:2c1a:: with SMTP id d26mr3448187qta.287.1571834284717;
        Wed, 23 Oct 2019 05:38:04 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([179.97.35.50])
        by smtp.gmail.com with ESMTPSA id x13sm10000312qki.9.2019.10.23.05.38.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 05:38:04 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 463884DDC9; Wed, 23 Oct 2019 09:38:02 -0300 (-03)
Date:   Wed, 23 Oct 2019 09:38:02 -0300
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
Subject: Re: [PATCH v2 5/9] perf tools: avoid a malloc for array events
Message-ID: <20191023123802.GB15998@kernel.org>
References: <20191017170531.171244-1-irogers@google.com>
 <20191023005337.196160-1-irogers@google.com>
 <20191023005337.196160-6-irogers@google.com>
 <20191023085830.GG22919@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191023085830.GG22919@krava>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Wed, Oct 23, 2019 at 10:58:30AM +0200, Jiri Olsa escreveu:
> On Tue, Oct 22, 2019 at 05:53:33PM -0700, Ian Rogers wrote:
> > Use realloc rather than malloc+memcpy to possibly avoid a memory
> > allocation when appending array elements.
> > 
> > Signed-off-by: Ian Rogers <irogers@google.com>
> 
> Acked-by: Jiri Olsa <jolsa@kernel.org>

Thanks, applied,

- Arnaldo
