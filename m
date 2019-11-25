Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 498331093AB
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 19:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727182AbfKYSm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 13:42:57 -0500
Received: from mail-pj1-f50.google.com ([209.85.216.50]:37236 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727107AbfKYSm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 13:42:57 -0500
Received: by mail-pj1-f50.google.com with SMTP id bb19so3444074pjb.4;
        Mon, 25 Nov 2019 10:42:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=CzeLZZiVw9wDh6E2trLN9cc3AjbOc+kLmhayMA9tIkg=;
        b=P1oBV7rnuS2YLJiMId+q7QgD7ss3YinhQGS2G7sQFe/KZtSCcvg+JKAsqGn4TUYOJ0
         hyHBbi84eBVZfMM0lm79Jzfbsc4nO/CltofJ38suuXyHjuzaLSPyvW5HNVHcl09MKtAW
         jnzvDFa+2hK6HITiE4SfDtBRTk5fS3ePAhWmwDZVNjeACi20nX1sQcPGT/aIH/JyCUwB
         DEZBZDbHWxWDoITRwHv491clR5kPCGfyymBaPoxlKqY8fT5LC+UJyqlHCoYoUXU2S2Hy
         ddNyVPzGoI4PsixBseHvM9wf9gKY0wUrgErJZKQycUhNYci8VYpOO0xXSWdOHy/14f0T
         +nqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=CzeLZZiVw9wDh6E2trLN9cc3AjbOc+kLmhayMA9tIkg=;
        b=QQvF8zt4nAKL7JIyTpcC8s6KBRRW6IuhxXcoU1pUztN+p4z18BGK/2JAs18FZ/wKaq
         ylh9+9Aa3gNCyn52z0qCEMT19bHPEWar2LE0as/nmwawoS7gWoVPnZF8J+pEhmryzeKK
         nivFZoJQajcTriiYz8F7hPJCvnYSIkQlqqVqz8h/n5Rrt82LU5FX3TZpQmOgUk2SLXL+
         yJgyAUPMoLccJMYrNtDoarfSRVNA64dVEFtPeUBmOiJNQ6LEa69qTQfobN6kY9fsOtDv
         PrA6BuaSu2fl32lht9f2DdOqrmrPT8NKqE9V5vdWB5KwU3fIwkjkApF7rzjT7wxxvCSb
         12qQ==
X-Gm-Message-State: APjAAAX/3mw725o+T7/vdH9thCDaE386PvbHPMeblE8aXHv9K/RBVEvu
        FJ9L371T5dgB9Dh4ufZM7dU=
X-Google-Smtp-Source: APXvYqxxJxdZuGY2fsCgmx7nlvE0uuTkIG6EcmVe73k+OdQ6rPXUKtBByKDsC3WL6QibN1+wnYpShA==
X-Received: by 2002:a17:902:b612:: with SMTP id b18mr17760892pls.210.1574707376707;
        Mon, 25 Nov 2019 10:42:56 -0800 (PST)
Received: from localhost ([2600:100f:b115:c6e6:d9b0:4a90:59b9:2ea7])
        by smtp.gmail.com with ESMTPSA id z11sm9815012pfg.117.2019.11.25.10.42.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2019 10:42:56 -0800 (PST)
Date:   Mon, 25 Nov 2019 10:42:54 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     "Daniel T. Lee" <danieltimlee@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <5ddc20aedc82d_2b082aba75a825b4f4@john-XPS-13-9370.notmuch>
In-Reply-To: <20191123055151.9990-1-danieltimlee@gmail.com>
References: <20191123055151.9990-1-danieltimlee@gmail.com>
Subject: RE: [PATCH,bpf-next 0/2] Fix broken samples due to symbol mismatch
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel T. Lee wrote:
> Currently, there are broken samples due to symbol mismatch (missing or
> unused symbols). For example, the function open() calls the syscall 
> 'sys_openat' instead of 'sys_open'. And there are no exact symbols such
> as 'sys_read' or 'sys_write' under kallsyms, instead the symbols have
> prefixes. And these error leads to broke of samples.
> 
> This Patchset fixes the problem by changing the symbol match.
> 
> Daniel T. Lee (2):
>   samples: bpf: replace symbol compare of trace_event
>   samples: bpf: fix syscall_tp due to unused syscall
> 
>  samples/bpf/syscall_tp_kern.c  | 14 ++++++++++++++
>  samples/bpf/trace_event_user.c |  4 ++--
>  2 files changed, 16 insertions(+), 2 deletions(-)
> 
> -- 
> 2.24.0
> 

Patches look good, please reply to each with a "Fixes" tag
though so its easier to keep track of these things.

Thanks,
John
