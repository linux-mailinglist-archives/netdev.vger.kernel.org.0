Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31BBD313DF5
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 19:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234640AbhBHSqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 13:46:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234505AbhBHSoQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 13:44:16 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6562EC061786;
        Mon,  8 Feb 2021 10:43:30 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id j11so8288333plt.11;
        Mon, 08 Feb 2021 10:43:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Aq5eSvt4NqALvRk53zUWzyXHgyGsjEqoX/pbVrnQYsk=;
        b=kX09tx2Wy8hDdSd+50jwrO8WEcp3ACrqT9qBsWgCmNvvlzC980AYDHeTBbCsTu2LBu
         KOCO07A52tV9darQoQxh6ptf2dcGvK7Shr4X7SUNr6IQMpV0eeJtcwHGee1sPnRZjOl9
         W2Re35qcylzqGqPajUsJC8+CH9MQ3OaWQ//hggUw+aesSZ1w58vGxuT1LniwI/SclAWl
         5udOmXlGHoMpBL7V4BKYtc6BtUsnoED7onzmiFqWTXsIFV38M+gm+sfoR+XMv2dos6ga
         2fm9yn9sU8dRNQV9ss6b7DSTqFWrHBcMVAADkH59ySL6cMATU+KndIMnGe8A+F/vpdVf
         0TRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Aq5eSvt4NqALvRk53zUWzyXHgyGsjEqoX/pbVrnQYsk=;
        b=aG3Eo8B685YQ2S3qa7nwxqOfyychNjbr+4N+YLynkL4V4ysuI9KWKkTve+RrX1Ass5
         NpcX+nhyr/7AQgLSfQgOtdbwC/FHJL5GzzvMPFZl6LdgH6E6Uwc2HQvuRDd26PcK0mB3
         cmis76MWA6gvHimpzq5Mxfboj7timSN7MCUTlJsQctgSsYy+Pv0TL5AkNvcFEJ9Wcnw6
         qa1xbj0AIdsIyYjBflL7F7pK9sZfZARWXbgJfrrlAmEOq4bDe4oxu54UKCZ7/ALsaUkj
         TTVC94khfoQc1/wn9IiYNo523D4CnF7dilRHeDfzSFRJoxygFcPrd8l5P21OlGViFz9E
         AI0A==
X-Gm-Message-State: AOAM530uZwBf2aMZxfF729bcqPVH+cXK4S1i8nvtqeFSMrvGomlMNMBJ
        qlNtzXagBPmToq9T0HDsF0GIr85m/mD/AazdCbM=
X-Google-Smtp-Source: ABdhPJwnqpYU4pKzBy2plLMy/ED+gtM4p0Zjxy9FEVwjgib8q6tT1r22x9BlLKHiHVlnL5TiqzGUFKKvBjVmn8ABNHQ=
X-Received: by 2002:a17:90a:cf17:: with SMTP id h23mr110539pju.191.1612809809945;
 Mon, 08 Feb 2021 10:43:29 -0800 (PST)
MIME-Version: 1.0
References: <20210203041636.38555-1-xiyou.wangcong@gmail.com>
 <20210203041636.38555-19-xiyou.wangcong@gmail.com> <87h7mq4wh0.fsf@cloudflare.com>
In-Reply-To: <87h7mq4wh0.fsf@cloudflare.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 8 Feb 2021 10:43:19 -0800
Message-ID: <CAM_iQpUsOFEsSxeCTe5t1ZFdKZ+H1CfD7U=9c7QwdDiZZ_4pFg@mail.gmail.com>
Subject: Re: [Patch bpf-next 18/19] selftests/bpf: add test cases for unix and
 udp sockmap
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        jiang.wang@bytedance.com, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 5, 2021 at 2:53 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> On Wed, Feb 03, 2021 at 05:16 AM CET, Cong Wang wrote:
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > Add two test cases to ensure redirection between two
> > AF_UNIX sockets or two UDP sockets work.
> >
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > Cc: Lorenz Bauer <lmb@cloudflare.com>
> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > ---
>
> If you extract a helper for creating a pair of connected sockets that:
>
>  1) delegates to socketpair() for AF_UNIX,
>  2) emulates socketpair() for INET/DGRAM,
>
> then tests for INET and UNIX datagram sockets could share code.

Good idea. Will do it in the next update.

Thanks!
