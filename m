Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26BE81F77AC
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 14:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbgFLMG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 08:06:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39566 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725791AbgFLMG5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 08:06:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591963615;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=naLbiu6HsX+Z2d/q/OU86dDzWk8INFro9FYGhNZfqd8=;
        b=RpGWd/R4wLRqm1iI8F+ZCgH+pvbw7UVzn+xCjaPYmg37dFx3tT6yhXoc7n0W6IUVqKo6Zu
        ATOgVAVMA3G/bGONmrefAAotqPkEwBoNp2nLKiSeTc1Nyvct2OaXpz9UWrutZKUEGCD/VL
        F/VwdovOq9JtbXMXGHH9SCDm3Tk/aEQ=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-202-1Do1NPjpOJSipkwBaGvJ1w-1; Fri, 12 Jun 2020 08:06:54 -0400
X-MC-Unique: 1Do1NPjpOJSipkwBaGvJ1w-1
Received: by mail-ej1-f72.google.com with SMTP id i17so4107512ejb.9
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 05:06:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=naLbiu6HsX+Z2d/q/OU86dDzWk8INFro9FYGhNZfqd8=;
        b=I1k2BxjZ+sK+89fmOpNDIc50HLuf5Ptbc/Fw5dwtb6rSZYb7U8JEX2KL21MSEYcF4J
         eIK+lwi+Kd5z01F8kvAosy8BD38PKTccLh7Z+dinb9extExy4RLqa0ynyOIrgs+CmPKB
         CsOPsK0HC1NEKeTYvohyF0rrmn1AEqLFweDQNYfC/cIAPbXanmN+5m4Ff59nKnzP2gyN
         TZ/MPQjQPKtCjXSBiDVU+FdKnksiCItw89vEOiOzxR3elmAJ2EKmR04akvre0d8opvpe
         hVvpDreUQWpI8a/2fwvZgYzCPIezRXe51SbVhFa7zcYEtmqgIP5bkmqxD8qHumrWJjM5
         T7lw==
X-Gm-Message-State: AOAM530yvc2m6XLUQKaphFNTx+Arn4PP016Z7X3rnDFIitkRCDPot1JJ
        cDzx1Blat9uboIs48vdDd4YBKi8Co38U7jcbueuzDIewm+tYDxvhLVrJo6eTuA7wslzt1Mh941N
        ltezNGsg5M5GThSPU
X-Received: by 2002:aa7:dad6:: with SMTP id x22mr11558448eds.265.1591963612912;
        Fri, 12 Jun 2020 05:06:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx4lVEfRjPxrT+5Z6RjJUpxaAxzdwF0uc8y38f8DYIg6oQjP4TWeq6YjE5s/j2es2+1PRLT3Q==
X-Received: by 2002:aa7:dad6:: with SMTP id x22mr11558414eds.265.1591963612639;
        Fri, 12 Jun 2020 05:06:52 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id o90sm634231edb.60.2020.06.12.05.06.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2020 05:06:51 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 69A291804F0; Fri, 12 Jun 2020 14:06:50 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Joe Perches <joe@perches.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Gaurav Singh <gaurav1086@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        "open list\:XDP \(eXpress Data Path\)" <netdev@vger.kernel.org>,
        "open list\:XDP \(eXpress Data Path\)" <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xdp_rxq_info_user: Replace malloc/memset w/calloc
In-Reply-To: <427be84b1154978342ef861f1f4634c914d03a94.camel@perches.com>
References: <20200611150221.15665-1-gaurav1086@gmail.com> <20200612003640.16248-1-gaurav1086@gmail.com> <20200612084244.4ab4f6c6@carbon> <427be84b1154978342ef861f1f4634c914d03a94.camel@perches.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 12 Jun 2020 14:06:50 +0200
Message-ID: <8736705vz9.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Joe Perches <joe@perches.com> writes:

> On Fri, 2020-06-12 at 08:42 +0200, Jesper Dangaard Brouer wrote:
>> On Thu, 11 Jun 2020 20:36:40 -0400
>> Gaurav Singh <gaurav1086@gmail.com> wrote:
>> 
>> > Replace malloc/memset with calloc
>> > 
>> > Fixes: 0fca931a6f21 ("samples/bpf: program demonstrating access to xdp_rxq_info")
>> > Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>
>> 
>> Above is the correct use of Fixes + Signed-off-by.
>> 
>> Now you need to update/improve the description, to also
>> mention/describe that this also solves the bug you found.
>
> This is not a fix, it's a conversion of one
> correct code to a shorter one.

No it isn't - the original code memset()s before it checks the return
from malloc(), so it's a potential NULL-pointer reference... Which the
commit message should explain, obviously :)

-Toke

