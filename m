Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28C441C5FD0
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 20:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730852AbgEESN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 14:13:58 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:34964 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730184AbgEESN5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 14:13:57 -0400
Received: by mail-pj1-f65.google.com with SMTP id ms17so1504886pjb.0;
        Tue, 05 May 2020 11:13:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Rx9dL5oa5s/IWarikU/6m95Ws4R/Z6DJqOhAk9cf0GY=;
        b=kQIpA2YBaMOtB6ta6bLZvjkXBLGM0M7dmqilAUDqjqr8PvKbHi4n+Qzqs5si5Q9tTr
         uuEk/zEo/J+/CerIeOMbWxQiqSpZgtNPjnbmDR7uYlSnCmpGRGrRV3WcHoIVAY87RvWL
         2EMd9FWoz2HB+5pFaKU2M+0DcCXj13tdY83n+a7tTIh3r8WqliCfW26v1MDQPpZ0vVV9
         sd0pHNIIJkeXQICVflNUv4xRAzK+wEDhVwUhqNJOkfgSwlstDKFwFN8ISpfNwawbb2qI
         ZnZ3Xth6QKCUgkKY4CJ2c/Ggvm4lgg8PEWbuYOcsMdRpKhJj1t1ru1QbBPXx4v+SZcw1
         K1Yw==
X-Gm-Message-State: AGi0PubOLNlyYduzyJ2tSJNcTldQHyC6OUpW09CzVOBn+JYcdq98MWmt
        Iz1J4/uR4OcrbR03XgdFlAk=
X-Google-Smtp-Source: APiQypImOVLkOUOTDok7p5dA4mGR36U7jY91wjj8nHDq58TvLlNEmXj6aAgniC7vxDKm0EoG2OVrTw==
X-Received: by 2002:a17:902:bc86:: with SMTP id bb6mr3908263plb.243.1588702436564;
        Tue, 05 May 2020 11:13:56 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id g74sm2543148pfb.69.2020.05.05.11.13.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 11:13:55 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 547C4403EA; Tue,  5 May 2020 18:13:54 +0000 (UTC)
Date:   Tue, 5 May 2020 18:13:54 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] sysctl: fix unused function warning
Message-ID: <20200505181354.GU11244@42.do-not-panic.com>
References: <20200505140734.503701-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505140734.503701-1-arnd@arndb.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 05, 2020 at 04:07:12PM +0200, Arnd Bergmann wrote:
> The newly added bpf_stats_handler function has the wrong #ifdef
> check around it, leading to an unused-function warning when
> CONFIG_SYSCTL is disabled:
> 
> kernel/sysctl.c:205:12: error: unused function 'bpf_stats_handler' [-Werror,-Wunused-function]
> static int bpf_stats_handler(struct ctl_table *table, int write,
> 
> Fix the check to match the reference.
> 
> Fixes: d46edd671a14 ("bpf: Sharing bpf runtime stats with BPF_ENABLE_STATS")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>

  Luis
