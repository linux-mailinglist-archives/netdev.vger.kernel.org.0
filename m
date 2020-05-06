Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72D3B1C78FF
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 20:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730188AbgEFSJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 14:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729331AbgEFSJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 14:09:13 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE6BC061A0F
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 11:09:11 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id d206so3555681ybh.7
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 11:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=8rkuEK/M4k/6mBO+AczCR37g8EM1TmsE8zFkIPSGk+8=;
        b=AMYjxIXKJW/bAphWl99wnFxTJsi22v33F5RhKTheV6i9daqvgTogypva+jyGwL54d7
         dLI0ibNR42sF4kFvTMrC6EtLWduk8yAAc8AEACPAlyUPqcdhMREKzIg5AXd9hrPxwgbf
         QDI9e5m6eh6DI6ao4PVYNy2vwRNjQzHSFJh/oqF1cw3uRfN+mZLDw90SoyE9zkYs3/Fl
         4kfdPKdOw6gSBLqjCmFRI8Ms5VVDqVpPq/ToVl1v0C6x1/86yu+rzqWMGZ4ueeoBvaJN
         8JrWcExHxPMq+6i3rE87/dTS/ZDyI97tdOeURXt/cA7wRuwxHIAxBFBO5YPvTFBEWlQH
         2+eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=8rkuEK/M4k/6mBO+AczCR37g8EM1TmsE8zFkIPSGk+8=;
        b=QPvSu4ZJDM1bkpiuE6dRo5VHgrKcEJdrivz96mGi1gkRBAkL/t1nQYUeoRtx/KvTma
         X9DDg2obtle+m0HjWDAOxs6+cpgNrs4oKkEloGmHjFOXosXxl3VlTy7Ywy0SYJaqvA0C
         AOypS9gAdaEFf4nNjh99ec249xwrPsMyTzmbxRpOliMGVyte4hJDSlW0IHe15/6AM5Or
         ofX7Ogol5ls53JToXRLAr2Gtgc/z2cfOBD3GF8r3ILbY26EbTfk2vJ4Dj+JQ7B3cTAAo
         kKoNGra1xL5796mOsk+nCoipISl9w9Gs1JmI6vBR3ZbaVBr7EB6WL123B2Xqaxk3yeZO
         zPtg==
X-Gm-Message-State: AGi0PuYPKMY8TtVKqC9k3EJ8wjeQwDzhiN/dy4tqjXahyAbEM8SPnmZ4
        fkjqsxrG40gmKgONQ9c0YzCi9lg=
X-Google-Smtp-Source: APiQypKqLbs/RZosZRMJDPo72e/mYm7mF66WU6WRD+BwlY75AjEkSSlU7KGZAQsSqMkeBN5ZyF1fUwo=
X-Received: by 2002:a25:c08b:: with SMTP id c133mr15532456ybf.286.1588788550657;
 Wed, 06 May 2020 11:09:10 -0700 (PDT)
Date:   Wed, 6 May 2020 11:09:09 -0700
In-Reply-To: <20200506174844.pedoqguvunnwmnih@kafai-mbp>
Message-Id: <20200506180909.GI241848@google.com>
Mime-Version: 1.0
References: <20200505202730.70489-1-sdf@google.com> <20200505202730.70489-2-sdf@google.com>
 <20200506070025.kidlrs7ngtaue2nu@kafai-mbp> <20200506162802.GH241848@google.com>
 <20200506174844.pedoqguvunnwmnih@kafai-mbp>
Subject: Re: [PATCH bpf-next v2 1/5] selftests/bpf: generalize helpers to
 control background listener
From:   sdf@google.com
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net, Andrey Ignatov <rdna@fb.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/06, Martin KaFai Lau wrote:
> On Wed, May 06, 2020 at 09:28:02AM -0700, sdf@google.com wrote:
> > On 05/06, Martin KaFai Lau wrote:
> > > On Tue, May 05, 2020 at 01:27:26PM -0700, Stanislav Fomichev wrote:
> > > > Move the following routines that let us start a background listener
> > > > thread and connect to a server by fd to the test_prog:
> > > > * start_server_thread - start background INADDR_ANY thread
> > > > * stop_server_thread - stop the thread
> > > > * connect_to_fd - connect to the server identified by fd
> > > >
> > > > These will be used in the next commit.
> > > The refactoring itself looks fine.
> >
> > > If I read it correctly, it is a simple connect() test.
> > > I am not sure a thread is even needed.  accept() is also unnecessary.
> > > Can all be done in one thread?
> > I'm looking at the socket address after connection is established (to
> If I read it correctly, it is checking the local address (getsockname())
> of the client's connect-ed() fd instead of the server's accept-ed() fd.

> > verify that the port is the one we were supposed to be using), so
> > I fail to understand how accept() is unnecessary. Care to clarify?
> >
> > I thought about doing a "listen() > non-blocking connect() > accept()"
> It should not need non-blocking connect().
> The client connect() (3WHS) can still finish before the server side
> accept() is called.  If the test does not need the accept-ed() fd,
> then calling it or not is optional.
Ah, I see what you're saying, in this case I can expose extra
helper from network_helpers to do only socket+bind part for
the server. Thanks for the explanation!

> Just took a quick look, sk_assign.c and test_sock_addr.c could be
> good examples.  They use SO_RCVTIMEO/SO_SNDTIMEO for timeout also.

> > in a single thread instead of background thread, but then decided that
> > it's better to reuse existing helpers and do proper connection instead
> > of writing all this new code.
