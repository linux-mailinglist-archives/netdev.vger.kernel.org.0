Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A28D1354BF
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 09:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728858AbgAIIu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 03:50:59 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59124 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728792AbgAIIu7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 03:50:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578559858;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VWr6CdwBjc2lm2GdlX+0ljF22j2ZghSQ3T2YFBFAWYY=;
        b=CBvHlDALjSgJKxM8VYM6l2pDZepoUdrnTMUt3akQfkETBOh/bw38yeS03cDqRP7ynZU0NI
        VPpKCGGzPg1jnVClvAS2NTcxQApBHHhTC+KQfhuvPgcF/AiuygCOM8dyL1CsqDHnYOkJ+V
        wapceAbDRm2BOJtmCa/ubJCwW9BblHI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-131-3B8BhinWO7WkB_Lus3zbVA-1; Thu, 09 Jan 2020 03:50:57 -0500
X-MC-Unique: 3B8BhinWO7WkB_Lus3zbVA-1
Received: by mail-wr1-f70.google.com with SMTP id f17so2610470wrt.19
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 00:50:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=VWr6CdwBjc2lm2GdlX+0ljF22j2ZghSQ3T2YFBFAWYY=;
        b=pBmCtvJbBf84aQmpNu+zm3qRnZrxn7StikwiKMNY46WQe9hXPAQJlCA0ZaeBOWOwO9
         ETWB6AMIeGuT18VXIPsxGYvxm/tFAbNKgEh4p9dQ8mXe0U4KkEB1p+sFqk6YmSWPY5Qs
         6DkhVGdn8lfpq2HDuWOCVLIQMGANBLiWxGZ41KkyZLKSijl3Nk4A287LJw4CIZn46COc
         vAdatDJRPwXP7bLN9KxH5tgvA3JFYuJYSnirbWq7U+BvsJVkxXIxWv9u01es2xrUuV7u
         CyhY+yXAjJt/x6Dp01gOYg3IHQ/md2yoBpAHAeIq66D5ni0rI8n6k1b4vhSCCMjZwWLU
         x0wA==
X-Gm-Message-State: APjAAAVxYQZ7s+85Kh91DWbPYzGipZcEo4tH0bxUhJit/Av7ZYnSGTZm
        /YLbtNlEJeR0fd4J9doNy9k8TOxrL9mWjiV5hvJNmQQj1NYuJYAtg2Vg/m7YNJiWUpeGjbqqCOV
        sbSkcj2IGjy28+ESz
X-Received: by 2002:a5d:5592:: with SMTP id i18mr9035946wrv.55.1578559856504;
        Thu, 09 Jan 2020 00:50:56 -0800 (PST)
X-Google-Smtp-Source: APXvYqyxi5Tx492/FZYofU8nhhT4P9n695WfkmFFPCfYFdpSpaHcxjbpxoCHChTdCbVojEn19L5fHA==
X-Received: by 2002:a5d:5592:: with SMTP id i18mr9035923wrv.55.1578559856254;
        Thu, 09 Jan 2020 00:50:56 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id l3sm7251246wrt.29.2020.01.09.00.50.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 00:50:55 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 9D9F8180ADD; Thu,  9 Jan 2020 09:50:53 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        "davem\@davemloft.net" <davem@davemloft.net>
Cc:     "daniel\@iogearbox.net" <daniel@iogearbox.net>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf\@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Tom Stellard <tstellar@redhat.com>
Subject: Re: [PATCH bpf-next 2/6] libbpf: Collect static vs global info about functions
In-Reply-To: <89249a19-5fb9-86e3-925b-dbb03427f718@fb.com>
References: <20200108072538.3359838-1-ast@kernel.org> <20200108072538.3359838-3-ast@kernel.org> <871rsai6td.fsf@toke.dk> <89249a19-5fb9-86e3-925b-dbb03427f718@fb.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 09 Jan 2020 09:50:53 +0100
Message-ID: <87imllggia.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yonghong Song <yhs@fb.com> writes:

> On 1/8/20 2:25 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Alexei Starovoitov <ast@kernel.org> writes:
>>=20
>>> Collect static vs global information about BPF functions from ELF file =
and
>>> improve BTF with this additional info if llvm is too old and doesn't em=
it it on
>>> its own.
>>=20
>> Has the support for this actually landed in LLVM yet? I tried grep'ing
>> in the commit log and couldn't find anything...
>
> It has not landed yet. The commit link is:
>     https://reviews.llvm.org/D71638
>
> I will try to land the patch in the next couple of days once this series
> of patch is merged or the principle of the patch is accepted.

OK. My next question was going to be whether you're planning to get this
into LLVM master before the cutoff date for LLVM10, but I see Alexei
already answered that in the other reply, so great!

-Toke

