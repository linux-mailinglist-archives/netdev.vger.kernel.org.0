Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA1573A1ACB
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 18:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233163AbhFIQUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 12:20:48 -0400
Received: from mail-il1-f179.google.com ([209.85.166.179]:38573 "EHLO
        mail-il1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbhFIQUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 12:20:47 -0400
Received: by mail-il1-f179.google.com with SMTP id d1so24043898ils.5;
        Wed, 09 Jun 2021 09:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=j3p+5VJ1d2gl2kt6X6tDU7XdZVaL9ybD/hRYi8R8WOw=;
        b=iEtOK9IvhBhlYSwdMM06sv05I5YnqdiWf+et7E56BvnsH6gdYF9yg8WEXcLpxXgx8i
         9BEpMwY2sUmR7IYxn0TcE9PpciRODsuzEdHqnVv50R7P9awARSzUAfJU156lDWBW6d72
         8qDM7X5TC9fTqaCZ4feUVH5EKQV5Fa6FZ3aLNOmHoT94vbG6jTotZVGSrqWk3mITl0Ph
         Pv6mhvpfsFFPWirmrahe8dRo60A5IaoyhTAZIhzEnZ4NEwB7Vqt6rNKEOmQmZqDJfG3d
         b2gv40Z+aEQJdplf001JvaI0Z67C4YqbitiaSTOAJwS20+6gl7/0u53l9tKbQFo869um
         q+1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=j3p+5VJ1d2gl2kt6X6tDU7XdZVaL9ybD/hRYi8R8WOw=;
        b=nHlgUzYef46qxwDx55PC6sFnZAYTRl0sy6V8M3F0ERcwtvlL+qjSfPDn/h0OaRJb6J
         C2bhKH/Y3te34i2OAu3XHhpbV0WZC5QgGlP6n7QmwiobZ0Ln4wR/XcRrC57fG+wDojIf
         KnORFe1QaGIq6ov6ypyFPxj8NRplnGZQvFYolBvSpmxBdG4RGsmjk2rNI4Enr+dxJf6/
         HiKOeYdxWL916kseTobgj4OAEgBgadxxo8VJmpUezPq6fRK7iLYvbytddaNKZEDct1ap
         yXiN4BjDitYfgORGnjixjBmHetHwKCx4Zx4w2JOIt4eqq0ILqV3jIRd6f41kedgNYFHL
         HTAg==
X-Gm-Message-State: AOAM533b7kxOG3fGUzEK9X9+8ipozcSjNVwEWa5zlbUyUi4y7gIHRTld
        jiz7NwEUNw+1tHqQZefc9xs=
X-Google-Smtp-Source: ABdhPJwgZa++VW/bv3YLGBU0fzluOrW2Qa9jN+0PkShqgU2pltxYYM2xVufLCIWn6u8pjzoyFMmISw==
X-Received: by 2002:a92:c792:: with SMTP id c18mr373615ilk.103.1623255457809;
        Wed, 09 Jun 2021 09:17:37 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id u5sm161027iob.44.2021.06.09.09.17.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 09:17:37 -0700 (PDT)
Date:   Wed, 09 Jun 2021 09:17:29 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>, ast@kernel.org,
        daniel@iogearbox.net, andriin@fb.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        maciej.fijalkowski@intel.com
Message-ID: <60c0e99991232_986212085a@john-XPS-13-9370.notmuch>
In-Reply-To: <588e062e-f1aa-6bc5-8011-380be7bf1176@fb.com>
References: <162318053542.323820.3719766457956848570.stgit@john-XPS-13-9370>
 <588e062e-f1aa-6bc5-8011-380be7bf1176@fb.com>
Subject: Re: [PATCH bpf 0/2] bpf fix for mixed tail calls and subprograms
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yonghong Song wrote:
> 
> 
> On 6/8/21 12:29 PM, John Fastabend wrote:
> > We recently tried to use mixed programs that have both tail calls and
> > subprograms, but it needs the attached fix. Also added a small test
> > addition that will cause the failure without the fix.
> > 
> > Thanks,
> > John
> > 
> > ---
> > 
> > John Fastabend (2):
> >        bpf: Fix null ptr deref with mixed tail calls and subprogs
> >        bpf: selftest to verify mixing bpf2bpf calls and tailcalls with insn patch
> > 
> > 
> >   .../selftests/bpf/progs/tailcall_bpf2bpf4.c     | 17 +++++++++++++++++
> >   1 file changed, 17 insertions(+)
> 
> Don't know what happens. Apparently, the first patch made changes
> in kernel/bpf/verifier.c, but it didn't show up in the above.

Agh its how I applied the patches and cover-letter :/ I moved them between
trees (bpf-next -> bpf) and lost the diff. I can resubmit if anyone
cares.
