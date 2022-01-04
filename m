Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63BB34849B0
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 22:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233251AbiADVHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 16:07:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232036AbiADVHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 16:07:19 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEB23C061761;
        Tue,  4 Jan 2022 13:07:19 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id f8so23676816pgf.8;
        Tue, 04 Jan 2022 13:07:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=NqAX5/tw/9C2zZTK3Zdf7y1bK2GJX0urbVV5qty1VLg=;
        b=W91s6n9gifWi1Jj3NZTwfgnNbhYH+Siu050QEbDAERnOLKqeclm9AVDl6PtOTnyfIN
         Gr30Kxl8rVyo44FzihgdxhDUO6lazOhpwGscRk7mWx5I6Ce4SCGyNXzAM0blE2Cg+5aq
         j+kXMvzVq8crgHXtUd0Jhr/c1vb6sbGKpe+6073zSXKcR5B3UxAXXT0ws3ITUIODQ1zi
         /BuVCRuYCbR4VHmVVx5P/zjOUxWHM0FunHbI7km0dXneI7j/9MIy0A/Mxb8epvqisFLt
         Et8iU5DjlbQV3+NHpfgjcdsBl//W7/Ek7Cfe9+nCKRIUbYlldjYWp1dfMBvzlAupvZxi
         H80w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=NqAX5/tw/9C2zZTK3Zdf7y1bK2GJX0urbVV5qty1VLg=;
        b=TGZ759CDy9tTPY/R96zME3jaQ3e7zUfi78zXzNNGju4pyfpba2FvWLcxe47+yzjm9l
         c4QpCEuCzoGv4zmC9CGnIJptg3UFKywqZM1T1oPLMMnvys/MvzknLor5UIxEx3vJ09RQ
         xIj/x8J9BPAo7K82EOK8nS/lduX5OIAqsuRVQkdJQj26FwF4iUH4vLhYwIN+QsAXMZ2z
         krKnmINL8ATFnLf4fzt23nQzmqWGgJEd8vgtaRfG9Dcd2tCTA3hXieIm+m08YR1TTycg
         Uy/i0frsH2hOsbqoFfVzYeCwgHzcN5xMPQy9awAYPSuDxy1mYLcggOSPrEMdLmFq+cIL
         X61g==
X-Gm-Message-State: AOAM531xXJOuT7yk9HkYRxL0UdROy98JjzZ0b7FOc8p/KaMj8931z9pe
        1IBHyzXtA9ACu58w84eUEJWU6BFXqSw=
X-Google-Smtp-Source: ABdhPJx55x/puk6tzVTzPVRfNUjELTch+HYnX1EaYgdgAwoVVQXLGCGH2eV/idtcP/JMymMZrpyX4g==
X-Received: by 2002:a63:6687:: with SMTP id a129mr44889876pgc.477.1641330439212;
        Tue, 04 Jan 2022 13:07:19 -0800 (PST)
Received: from localhost ([71.236.223.183])
        by smtp.gmail.com with ESMTPSA id s192sm36331841pgc.7.2022.01.04.13.07.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 13:07:18 -0800 (PST)
Date:   Tue, 04 Jan 2022 13:07:17 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>, ast@kernel.org,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, joamaki@gmail.com,
        john.fastabend@gmail.com
Message-ID: <61d4b705a0c3f_4607920892@john.notmuch>
In-Reply-To: <20220104205918.286416-1-john.fastabend@gmail.com>
References: <20220104205918.286416-1-john.fastabend@gmail.com>
Subject: RE: [PATCH bpf-next] bpf, sockmap: fix return codes from
 tcp_bpf_recvmsg_parser()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend wrote:
> Applications can be confused slightly because we do not always return the
> same error code as expected, e.g. what the TCP stack normally returns. For
> example on a sock err sk->sk_err instead of returning the sock_error we
> return EAGAIN. This usually means the application will 'try again'
> instead of aborting immediately. Another example, when a shutdown event
> is received we should immediately abort instead of waiting for data when
> the user provides a timeout.
> 
> These tend to not be fatal, applications usually recover, but introduces
> bogus errors to the user or introduces unexpected latency. Before
> 'c5d2177a72a16' we fell back to the TCP stack when no data was available
> so we managed to catch many of the cases here, although with the extra
> latency cost of calling tcp_msg_wait_data() first.
> 
> To fix lets duplicate the error handling in TCP stack into tcp_bpf so
> that we get the same error codes.
> 
> These were found in our CI tests that run applications against sockmap
> and do longer lived testing, at least compared to test_sockmap that
> does short-lived ping/pong tests, and in some of our test clusters
> we deploy.
> 
> Its non-trivial to do these in a shorter form CI tests that would be
> appropriate for BPF selftests, but we are looking into it so we can
> ensure this keeps working going forward. As a preview one idea is to
> pull in the packetdrill testing which catches some of this.
> 
> Fixes: c5d2177a72a16 ("bpf, sockmap: Fix race in ingress receive verdict with redirect to self")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---

Forgot to add a note, I marked this for bpf-next given we are in rc8. It
is a fix though, but assume we only want critical things at this point.
Anyways it applies against bpf and bpf-next so can be applied in either
place.

Thanks,
John
