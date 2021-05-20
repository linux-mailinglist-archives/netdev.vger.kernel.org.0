Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B15538B572
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 19:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234626AbhETRtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 13:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233568AbhETRtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 13:49:19 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61849C061574;
        Thu, 20 May 2021 10:47:57 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id e10so14354554ilu.11;
        Thu, 20 May 2021 10:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=go1y6jUWBARYGjwtBV946Tv9pbSGpO6SGDDo1V0Opyg=;
        b=g41QkPBPvk+p3ZSi2bw2n2XTl4nfagWJ/jzHyjHUqKnpOoOGkaE3CRgm01rBmmOEDk
         Y81u2JSZLeTJwMHp5eLsAaMOmvZuZ1O2A8hR7Z3thqMv22yo1wI2ebb2ZLnrbaOMkxcN
         xusob9leHUtiVgGnoas2gzzIdRRTXZILVmrvMUlOYzYXYVsDJlOxpN+0Hfls9b2fsFHm
         3udun+LotfF4jxQFR0zcbqtzJX09mapHa9uXVF/+qOhxnuvMRG9q6/yRLds2AkwD4H8V
         5/shpEVigqrMlg8NeciU1iud0gzoIlCBqxYolxLlw4SpURSyeqs4EMxEKGSF9nJScKq7
         6rKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=go1y6jUWBARYGjwtBV946Tv9pbSGpO6SGDDo1V0Opyg=;
        b=nJY13/pQpSNmcG1oMzgADbejhuOD+OGWBNkgw1ZKaT7Am7titPuzlPSyVVUZr6BTGR
         +dlzgTqIfDSerQF8eHX6HxLaZxRsoYIlS5p/cj1i9fRu/4mu/y6yxKEHq6L+ROUqbsdo
         5B+OYEoy1uPDM9iolD+mRe2DOSQs71sWqp9bEJZg9r6U7CIUslmTX+OCoOAwLSo4Xmjq
         EmPUNhfBWjC2HU/9QfCpIS6Fee7iCuACRvNVY8aZP3MYJzbRM9MIcU03fjLrniZJwAiQ
         M6u4KkalNEQ8t1SJMdd6y098j15QsquG8wzvFtk5oZzSf+1WAIL+gjqAXjVszbyuHurW
         mDfw==
X-Gm-Message-State: AOAM533poX/CM6HqazICUksk9VPtj9JpmQBXXz1ZacpCWTPZNhsac+wr
        JFJ97sUyyhHRQm29YjAHxj4=
X-Google-Smtp-Source: ABdhPJxndfGHwrSe3BFCu47sqIK+RqSY1HQsTiOqecmvBOsQgQjeGW5geSuDeTP+cSSKloXegCXeOg==
X-Received: by 2002:a92:d844:: with SMTP id h4mr5986292ilq.215.1621532876761;
        Thu, 20 May 2021 10:47:56 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id l19sm3671031ioj.11.2021.05.20.10.47.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 10:47:56 -0700 (PDT)
Date:   Thu, 20 May 2021 10:47:50 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <60a6a0c61358a_4ea08208c4@john-XPS-13-9370.notmuch>
In-Reply-To: <CAM_iQpUC6ZOiH=ifUe1+cdXtTgiBMwPVLSsWB9zwBA7gWh8mgA@mail.gmail.com>
References: <20210519204132.107247-1-xiyou.wangcong@gmail.com>
 <60a5896ca080d_2aaa720821@john-XPS-13-9370.notmuch>
 <CAM_iQpUC6ZOiH=ifUe1+cdXtTgiBMwPVLSsWB9zwBA7gWh8mgA@mail.gmail.com>
Subject: Re: [Patch bpf] selftests/bpf: Retry for EAGAIN in
 udp_redir_to_connected()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> On Wed, May 19, 2021 at 2:56 PM John Fastabend <john.fastabend@gmail.com> wrote:
> >
> > Cong Wang wrote:
> > > From: Cong Wang <cong.wang@bytedance.com>
> > >
> > > We use non-blocking sockets for testing sockmap redirections,
> > > and got some random EAGAIN errors from UDP tests.
> > >
> > > There is no guarantee the packet would be immediately available
> > > to receive as soon as it is sent out, even on the local host.
> > > For UDP, this is especially true because it does not lock the
> > > sock during BH (unlike the TCP path). This is probably why we
> > > only saw this error in UDP cases.
> > >
> > > No matter how hard we try to make the queue empty check accurate,
> > > it is always possible for recvmsg() to beat ->sk_data_ready().
> > > Therefore, we should just retry in case of EAGAIN.
> > >
> > > Fixes: d6378af615275 ("selftests/bpf: Add a test case for udp sockmap")
> > > Reported-by: Jiang Wang <jiang.wang@bytedance.com>
> > > Cc: John Fastabend <john.fastabend@gmail.com>
> > > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > > Cc: Lorenz Bauer <lmb@cloudflare.com>
> > > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > > ---
> > >  tools/testing/selftests/bpf/prog_tests/sockmap_listen.c | 6 +++++-
> > >  1 file changed, 5 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
> > > index 648d9ae898d2..b1ed182c4720 100644
> > > --- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
> > > +++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
> > > @@ -1686,9 +1686,13 @@ static void udp_redir_to_connected(int family, int sotype, int sock_mapfd,
> > >       if (pass != 1)
> > >               FAIL("%s: want pass count 1, have %d", log_prefix, pass);
> > >
> > > +again:
> > >       n = read(mode == REDIR_INGRESS ? p0 : c0, &b, 1);
> > > -     if (n < 0)
> > > +     if (n < 0) {
> > > +             if (errno == EAGAIN)
> > > +                     goto again;
> > >               FAIL_ERRNO("%s: read", log_prefix);
> >
> > Needs a counter and abort logic we don't want to loop forever in the
> > case the packet is lost.
> 
> It should not be lost because selftests must be self-contained,
> if the selftests could not even predict whether its own packet is
> lost or not, we would have a much bigger trouble than just this
> infinite loop.
> 
> Thanks.

Add the retry counter its maybe 4 lines of code. When I run this in a container
and my memcg kicks in for some unknown reason I don't want it to loop
forever I want it to fail gracefully. Plus it just looks bad to encode
a non-terminating loop, in my opinion, so I want the counter.

.John
