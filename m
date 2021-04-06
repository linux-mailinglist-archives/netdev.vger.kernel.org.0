Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 821CB355BF4
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 21:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235467AbhDFTFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 15:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbhDFTFu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 15:05:50 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D668C06174A;
        Tue,  6 Apr 2021 12:05:42 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id p10so2901350pld.0;
        Tue, 06 Apr 2021 12:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fR7uBE+KZgKRNGirNt0J9yqoqy113eytjrhGmdX8vhc=;
        b=TojC3B0s7I3+/nfSWs80/9xaTunkHwnkKDBu0qMg6TLU4XRxHMsgSdErm3Rmk3JsJU
         mryDZ+lYvgfSbnj2+2DV+tNy2hSnZzx9JSrwv05R4WdMAhs0ldJA89oJuEcMaEwRndqS
         MYny9f2VB0fXOvTK4N4sVcpxeE/Rj7Ws45TRD7hgPxX5eQIYECZ56yD1nAnqoFnWWeL1
         eGCWd7lCWR1nvBSe7EnoOCkg/OH0bhhpF9SykB/kkPf0+nJ7MSvuSYGOY7shixqk36UC
         Dj+tJMc9KRxOBwmpf6HwkJQicZBtHFvS1JDVL1le3a1DwLNXmIHGHzqKgTLlur+jthEJ
         5ZcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fR7uBE+KZgKRNGirNt0J9yqoqy113eytjrhGmdX8vhc=;
        b=aodHXExjcJa1UBJzDo74A5a/hp4E2KMQgyZEk3RbMjZY9B6LgkjAUEukUKobmzxN/W
         ts7IqeeqeV4WvyBEEG9UrJKjf7Z/V03Jc3z7CDokOkdq/BRfT4xpoD7D1g5P5Tz+Pz9Y
         ww0vLStlrsYKbr2nqPVFImX5PGYo4KAiGTdO6HdHwA0EcOyl1FdJWZzhTZUVfFuyT17S
         neLTCOuYKZaZp0Jm9kO5KIUF6hjs5o/zJYNNOoAubOsJIQswLsW9TTwqJQq+awStiSC5
         YPu91F1yu7UD6kIw3tqN5ODkkbJyUWyUTKlsl8U956lJHbB0QnPJ2UujkLgD/0heq6lK
         cuAw==
X-Gm-Message-State: AOAM530ZjUeiCZgK+I5WHVwkuvRvmoxzfiRc7XeJKwCmxBcWUNA+3VHZ
        WIyVoo12X0eUuunamjxouCE=
X-Google-Smtp-Source: ABdhPJwlP3QmABh4/nIwmiUI0ymstaWn3umCEZUef0OvuVGmL6HHCgt6yYD9gjyKppqKOMZS8rnNyw==
X-Received: by 2002:a17:90a:f2cc:: with SMTP id gt12mr5723370pjb.136.1617735941762;
        Tue, 06 Apr 2021 12:05:41 -0700 (PDT)
Received: from localhost ([47.9.169.206])
        by smtp.gmail.com with ESMTPSA id l10sm18453586pfc.125.2021.04.06.12.05.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 12:05:41 -0700 (PDT)
Date:   Wed, 7 Apr 2021 00:35:38 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, bpf <bpf@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH bpf-next 3/5] libbpf: add low level TC-BPF API
Message-ID: <20210406190538.fdqo7g2tzolgckpy@apollo>
References: <20210325120020.236504-1-memxor@gmail.com>
 <20210325120020.236504-4-memxor@gmail.com>
 <CAEf4Bzbz9OQ_vfqyenurPV7XRVpK=zcvktwH2Dvj-9kUGL1e7w@mail.gmail.com>
 <20210328080648.oorx2no2j6zslejk@apollo>
 <CAEf4BzaMsixmrrgGv6Qr68Ytq8k9W+WP6m4Vdb1wDhDFBKStgw@mail.gmail.com>
 <48b99ccc-8ef6-4ba9-00f9-d7e71ae4fb5d@iogearbox.net>
 <20210331094400.ldznoctli6fljz64@apollo>
 <5d59b5ee-a21e-1860-e2e5-d03f89306fd8@iogearbox.net>
 <20210402152743.dbadpgcmrgjt4eca@apollo>
 <CAEf4Bzbk9t9Cx4DONzNu8reP+Fkdq8WA90syqesgQYgAQyCaLw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzbk9t9Cx4DONzNu8reP+Fkdq8WA90syqesgQYgAQyCaLw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 05, 2021 at 10:51:09PM IST, Andrii Nakryiko wrote:
> > [...]
>
> if _block variant is just a special ifindex value, then it should be
> fine for users to know such a detail (we can leave a comment
> mentioning this specifically), especially given it's not a very
> popular thing. Almost doubling amount of APIs just for this doesn't
> make much sense, IMO.
>

Ok.

>
> If we know that we need variant with options, I'd vote for having just
> one bpf_tc_attach() API which always takes options. Passing NULL for
> opts is simple, no need for two APIs, I think.
>

Ack.

>
> Which parts of that id struct is the data that caller might not know
> or can't know? Is it handle and chain_index? Or just one of them?
> Or?... If there is something that has to be returned back, I'd keep
> only that, instead of returning 6+ fields, most of which user should
> already know.
>

The user will know ifindex and parent_id, and perhaps protocol (it would be
ETH_P_ALL if they don't supply one by default). Other fields like handle,
priority and chain_index can all be kernel assigned, so keeping those still
makes sense. I'll change this in v2.

--
Kartikeya
