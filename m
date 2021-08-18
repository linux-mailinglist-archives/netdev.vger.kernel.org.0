Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7F9C3F0E74
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 01:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233928AbhHRXDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 19:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbhHRXDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 19:03:01 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E55C061764
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 16:02:25 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id b9-20020a05620a1269b02903b8bd5c7d95so2849884qkl.12
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 16:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=/7TluQMoJ3vTyeYEuTo4wm9S7xTDUmeWrX51W0M8264=;
        b=j8SnEOXarJdCLut5JASqHQYaXjCSq4Xpvj7fR+e3bFOYQ4/L04w95tixCMXaOwfRJI
         viXLtpz/WtqX+jsz1+2de771gsGwgbJcUCpflvWh7Wms3SuGn7CxKtwSiZkZFFzJ2v+0
         WT1quWbT9vdff8Lu4CvVQH32LIPVSTwCtOvh8ZTnB2k9UIeuVgu+XCgvZmPaG1ZCxfUi
         oMdN9tU12EcloJQ97ZFiBtye6K4SdIZPwh2g8jdQSAzfeQ3sKoHg79Guk99XjFXLAfT6
         XbFlsu0eDvmErA0E/2ioaS8RINH98xQGUp4X3iIOHIbuJOzbcq2RjPX2tuFstBZ5n/ME
         3AnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=/7TluQMoJ3vTyeYEuTo4wm9S7xTDUmeWrX51W0M8264=;
        b=qNQDol7O5tXbdqeUUmNovsYQX98fpAw470zcY8cjFH3gFQIfc2XV1829HPxc+BJ5Kx
         Hr5zKnZuFJDfQ0scz5qF6mBf0IV2zabXgXpKqoOpUQ7W9XWFTc/zXcrvWWP3isL1Ffc7
         NvwhNYj9QbMvlsgbVQDpgZOwdsedDkP3nO+zuKtoXHGlNc4u2yo3xjzU1WO0t5Aue6CD
         6JxiRbKAHzklXbJSDRb9Cz9Ogh5VEd+tRfKziu6hk9LENXHZKG/sTdONFNPErRqeYDG8
         ye2BmAw1u8zDKEPaivj3SwG+pMgmNejTOENdZknZOyJTLTscQ3NS9cACoWfFP0BwqZQ9
         LzIw==
X-Gm-Message-State: AOAM531u+JTwZfNIFePCYt+zbuqDurMZpatHkJzWV48bWIYWiSfDJ7mK
        TWLRkTdkLJ8k66n0R943uJ4uGeA=
X-Google-Smtp-Source: ABdhPJyVCCRKSBZOA3rU4Z0S2QKPXCSEFhEFj+QNGPCvZfkOlme0SR/cGNyw8UvuAIb8uV9hXKOHk0E=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:7401:ef23:e119:5cbc])
 (user=sdf job=sendgmr) by 2002:ad4:4bb1:: with SMTP id i17mr11830661qvw.12.1629327744663;
 Wed, 18 Aug 2021 16:02:24 -0700 (PDT)
Date:   Wed, 18 Aug 2021 16:02:22 -0700
In-Reply-To: <afd42427-f424-5f0d-360c-5fcdfc078704@iogearbox.net>
Message-Id: <YR2RfkFHtUoO5Kx9@google.com>
Mime-Version: 1.0
References: <20210817154556.92901-1-sdf@google.com> <20210817154556.92901-2-sdf@google.com>
 <afd42427-f424-5f0d-360c-5fcdfc078704@iogearbox.net>
Subject: Re: [PATCH bpf-next v2 2/2] bpf: use kvmalloc for map keys in syscalls
From:   sdf@google.com
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        andrii@kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/19, Daniel Borkmann wrote:
> On 8/17/21 5:45 PM, Stanislav Fomichev wrote:
> > Same as previous patch but for the keys. memdup_bpfptr is renamed
> > to vmemdup_bpfptr (and converted to kvmalloc).
> >
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >   include/linux/bpfptr.h | 12 ++++++++++--
> >   kernel/bpf/syscall.c   | 34 +++++++++++++++++-----------------
> >   2 files changed, 27 insertions(+), 19 deletions(-)
> >
> > diff --git a/include/linux/bpfptr.h b/include/linux/bpfptr.h
> > index 5cdeab497cb3..84eeffb4316a 100644
> > --- a/include/linux/bpfptr.h
> > +++ b/include/linux/bpfptr.h
> > @@ -62,9 +62,17 @@ static inline int copy_to_bpfptr_offset(bpfptr_t  
> dst, size_t offset,
> >   	return copy_to_sockptr_offset((sockptr_t) dst, offset, src, size);
> >   }
> > -static inline void *memdup_bpfptr(bpfptr_t src, size_t len)
> > +static inline void *vmemdup_bpfptr(bpfptr_t src, size_t len)

> nit: should we just name it kvmemdup_bpfptr() in that case?
Sounds good!

> >   {
> > -	return memdup_sockptr((sockptr_t) src, len);
> > +	void *p = kvmalloc(len, GFP_USER | __GFP_NOWARN);
> > +
> > +	if (!p)
> > +		return ERR_PTR(-ENOMEM);
> > +	if (copy_from_sockptr(p, (sockptr_t) src, len)) {

> Also, I think this one should rather use copy_from_bpfptr() here.
Ah, missed that one, thanks!

> > +		kvfree(p);
> > +		return ERR_PTR(-EFAULT);
> > +	}
> > +	return p;
> >   }

> Rest lgtm, thanks!
