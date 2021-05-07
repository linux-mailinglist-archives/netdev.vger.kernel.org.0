Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA6DD375E1E
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 02:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233638AbhEGA5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 20:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbhEGA5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 20:57:08 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB325C061574;
        Thu,  6 May 2021 17:56:09 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id m124so5928723pgm.13;
        Thu, 06 May 2021 17:56:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eiiCTLBNGzLRswAdPwMX6fL/gq+Y+ZACW6akpcYV5kI=;
        b=E3BKBScA5g+gJGlPlx0bd6Ze9xav/sG22OYgxSX7OVdiw+IJi9vQd0cwCd9xXCiIRJ
         icasbylYWd91ux4hGwDSPjkaGdnzEv/pCE0rLIvvxk9mI5Vj3tAB4IHPhskRCtps/GxB
         RzQJDFDv98GjyNqffNNzQQzjXJbohKhgpSX4n4xwDYEIWN0I0MMx/yBlfF7Pzg/+AY3a
         4dpNnivxUSWlZPiFSKzfkDYMG7VzZkeO5OnAIgw5/S/8gi3/AObgLr9MRUGR7EGO0ux3
         iZltmGdrFJbAkoe+pL+mhBfGoIjHAF6ZPgC0TKjue8Do2rWiQmY2I4hel/rXOFzje7ls
         3IYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eiiCTLBNGzLRswAdPwMX6fL/gq+Y+ZACW6akpcYV5kI=;
        b=INAfS//ad/M9udgO3qK9V4/gFxouag8+A7+AoZAUmY7pLQD/GVZZpQ43Pvp3chbJk8
         zLmSJ/XGcIL0Hh34x/i+PRZ74YZf9ipaHfSp+cPeqvOsC4pSkZvyqKsovs31F9CoF3NZ
         okQuBOTxE5kk6neXd9cGl+anEdznd2Yy65aZWT50G4vQTS0xu+RLa4gMKujXOKfJEiO1
         CVEp1KkIb3SPrsMd4D0CPrRpEytCazmBOwQ7VzZ17/MlVyeTTM+mtybfsD7k2SSltwL1
         8KIn+X0HTTX+rGwD/NdhttbE5CqUx6JOL8wJ4PZUFoDDn5yeQYYIyOiaoxPlaXr2LgqV
         l7tA==
X-Gm-Message-State: AOAM530qvuD1fYm3VUrwcUHTeOpXoygL2vfKIX7xIT88IgjUfLqP9h4N
        CxFXmaXjYSE8KlcMDlA7Jqt/T2RrGAnZ9rSMNOU=
X-Google-Smtp-Source: ABdhPJzBVaoST0gIuvWIRWALeAurd9wqrXOwkpAqTj5u4z6JA+ZJNkS6N0Qv6lL7hQcNWAA57RoXY69FPBL4ItujmGw=
X-Received: by 2002:a63:d014:: with SMTP id z20mr6899440pgf.428.1620348969065;
 Thu, 06 May 2021 17:56:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210426025001.7899-1-xiyou.wangcong@gmail.com>
 <20210426025001.7899-4-xiyou.wangcong@gmail.com> <87o8doui7s.fsf@cloudflare.com>
In-Reply-To: <87o8doui7s.fsf@cloudflare.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 6 May 2021 17:55:58 -0700
Message-ID: <CAM_iQpXVKNZE=P06s1C2tWHPuDoecRTqauo1xKchwxWO5YBcUg@mail.gmail.com>
Subject: Re: [Patch bpf-next v3 03/10] af_unix: implement ->psock_update_sk_prot()
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Jiang Wang <jiang.wang@bytedance.com>,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 6, 2021 at 6:04 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
> I think we also need unhash so that socket gets removed from sockmap
> on disconnect, that is connect(fd, {sa_family=AF_UNSPEC, ...}, ...).

Excellent catch! I thought disconnect is not supported for AF_UNIX
as there is not ->disconnect() in af_unix.c, but after reading
unix_dgram_connect() again, it is actually supported. Let me think
about how to handle this properly here.

Thanks.
