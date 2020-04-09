Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80F951A3C6B
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 00:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbgDIWdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 18:33:41 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38644 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726679AbgDIWdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 18:33:41 -0400
Received: by mail-pf1-f196.google.com with SMTP id c21so203775pfo.5;
        Thu, 09 Apr 2020 15:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=h6CIWptWdgEYb7MN2wQY+7B3RiKrdcdmKs6r8jKHbUQ=;
        b=aFzSLMqXkYUkWTXZf/+hjn33ZQ+pGbjtq3DbLoRoUzO+mOIdinxzUpOdg9Bm4l55fY
         1eXpGvBqe+m/5dHjD/j6Yb2Lq+4eMXj7D7ZMxHC/gLmPV+tQiQp89Zji6AcxJ6MQS4Kp
         3GqAZAgxDKro7/TC0OHa5wIAmtn13WKqpIkuuvPFqj8+WDej/0XH7IH56DqYUPHcpLo6
         uWPeGitvXf/CBxkHl+YT/Y4IFvlAiJx/jfjarvUH6yZ4p7g+hi9hTICcNgZ2wggGaujt
         vL9W0pVDGgRjLq/fZFSU4ED0KUgsjQxky8FhSj7d7bfiCUkzSfLJ3AudquBUqBuHv6+g
         qPlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=h6CIWptWdgEYb7MN2wQY+7B3RiKrdcdmKs6r8jKHbUQ=;
        b=HOnBFvoLyjE5bVFkIVTd6JpKah5gaCenJi9tIQ0pAzh5ke6xB+rnbaVQ50uMNxUUMU
         8K4L79YGmX8bUyj/e6SgOHvZVSEtij9hdr/rIww2YABHt5U42vnC4LqaTnHEEuvTiiAo
         3aRvLDL5sZ1rXJK2ybT/PGgOS64/HrZx1XL+dCQv/qwDhILebB9EN6URuskQtYI6Rt3J
         pKfcJ38V8V0XAmFcu7cMuGmK/J8P+kna1pq31h+K4KG/3GsGFkrhstLxs/SpuUMwaPet
         YEDa3iH26jNZbUSCGARNe2ZAVosv8B03NJeaMqcDdnmOzg/Qfv9wDC0XspgC7BmYR4X+
         qxHg==
X-Gm-Message-State: AGi0PuZjabOhax1HVvppLDrwCAR+NEzx3XwabElFNdt7/5+3NTQiWtID
        SKMWR7pk0ZnR84ArXJc4TuI=
X-Google-Smtp-Source: APiQypJaBhU/00jWtLTIagZAShLNSuuZI+wxh6wVCmQrvZ4Kdyo8ltKirou0fEd/yrEm/fYRCULOdA==
X-Received: by 2002:a63:a601:: with SMTP id t1mr1618612pge.23.1586471618671;
        Thu, 09 Apr 2020 15:33:38 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:dc3d])
        by smtp.gmail.com with ESMTPSA id t23sm173152pjq.27.2020.04.09.15.33.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2020 15:33:37 -0700 (PDT)
Date:   Thu, 9 Apr 2020 15:33:35 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>, akpm@linux-foundation.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "K . Prasad" <prasad@linux.vnet.ibm.com>,
        Masami Hiramatsu <mhiramat@kernel.org>, rostedt@goodmis.org,
        Alexei Starovoitov <ast@kernel.org>,
        linux-kernel@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ingo Molnar <mingo@redhat.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH 3/9] writeback: tracing: pass global_wb_domain as
 tracepoint parameter
Message-ID: <20200409223335.ovetfovkm2d2ca36@ast-mbp.dhcp.thefacebook.com>
References: <20200409193543.18115-1-mathieu.desnoyers@efficios.com>
 <20200409193543.18115-4-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200409193543.18115-4-mathieu.desnoyers@efficios.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 09, 2020 at 03:35:37PM -0400, Mathieu Desnoyers wrote:
>  		if (pause < min_pause) {
> -			trace_balance_dirty_pages(wb,
> +			trace_balance_dirty_pages(&global_wb_domain,
> +						  wb,
>  						  sdtc->thresh,
>  						  sdtc->bg_thresh,
>  						  sdtc->dirty,

argh. 13 arguments to single function ?!
Currently the call site looks like:
                        trace_balance_dirty_pages(wb,
                                                  sdtc->thresh,
                                                  sdtc->bg_thresh,
                                                  sdtc->dirty,
                                                  sdtc->wb_thresh,
                                                  sdtc->wb_dirty,
                                                  dirty_ratelimit,
                                                  task_ratelimit,
                                                  pages_dirtied,
                                                  period,
                                                  min(pause, 0L),
                                                  start_time);
Just pass sdtc as a pointer instead.
Then another wb argument will be fine.
