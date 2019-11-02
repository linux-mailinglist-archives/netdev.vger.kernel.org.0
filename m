Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA44ECE2C
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 11:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbfKBK5B convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 2 Nov 2019 06:57:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52942 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726617AbfKBK5A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 2 Nov 2019 06:57:00 -0400
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com [209.85.167.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7171086663
        for <netdev@vger.kernel.org>; Sat,  2 Nov 2019 10:57:00 +0000 (UTC)
Received: by mail-lf1-f69.google.com with SMTP id t144so2381592lff.14
        for <netdev@vger.kernel.org>; Sat, 02 Nov 2019 03:57:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=1KqhehDOr4MW0YjZuVPaDPIwy6O6KgqpOuXWoiBx+bA=;
        b=FAXOShalIxceHuX+ayPmUd060sQ3c3ge8I0ZigwAfoZOB4+CebkF8sqrMaxjmQvJaG
         wV4sGfqtxAfOc2wETmrmJ5TwoSflloASVUszfSHSGISpsy6ygvDCX1xbSeev3ojBHeP0
         GUzv/ffQsbedCu0Q7s64F7zHeU7qVH3O+1r5u//pgHknBHOvfy4RQ5U2D0dtTjz24hFy
         P72H/qmonbVOxw2vRFgHIldyLQGNUnSi4zk3r5nYw9Q45ZZTzD6uQul3+yiEEghJeMU7
         dF48eTzhoPH2fkfXn6jiBWW/k07F4h85m9KRzy/QuGalCPugv6Nc/LfBhauSgq2i1YE/
         xGig==
X-Gm-Message-State: APjAAAUKfKShGUEd6qlJPl2RHH+lT/wbzd5NlKtcjeX92IZXFZgqkPAb
        SHBrD52zrf4jraKRIA4E/0NqJtOeqsPl9VVGyO2SLocYQxpJCR6YN6WJbivwaV06YTr5STnYyis
        +Rm3rjbYxEe864n/j
X-Received: by 2002:a2e:9814:: with SMTP id a20mr11860102ljj.37.1572692218991;
        Sat, 02 Nov 2019 03:56:58 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxdfa4ifDpWQEsMtioDqqC/7vZmOnsyaSwdtuRhKrbd43sKBBLnga5b5PHRwltOvrH8ZJ37hQ==
X-Received: by 2002:a2e:9814:: with SMTP id a20mr11860091ljj.37.1572692218803;
        Sat, 02 Nov 2019 03:56:58 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id r19sm3500667lfi.13.2019.11.02.03.56.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Nov 2019 03:56:58 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 9A63F1818B5; Sat,  2 Nov 2019 11:56:56 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v5 5/5] selftests: Add tests for automatic map pinning
In-Reply-To: <CAEf4BzYWgnek1QYyQm4U0qakP=Si0vEJ2bLKHeJhambyX7EnCQ@mail.gmail.com>
References: <157260197645.335202.2393286837980792460.stgit@toke.dk> <157260198209.335202.12139424443191715742.stgit@toke.dk> <CAEf4BzYWgnek1QYyQm4U0qakP=Si0vEJ2bLKHeJhambyX7EnCQ@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 02 Nov 2019 11:56:56 +0100
Message-ID: <875zk2mtqf.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Fri, Nov 1, 2019 at 2:53 AM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>>
>> From: Toke Høiland-Jørgensen <toke@redhat.com>
>>
>> This adds a new BPF selftest to exercise the new automatic map pinning
>> code.
>>
>> Acked-by: Andrii Nakryiko <andriin@fb.com>
>
> I don't believe I acked this patch before, must have been added by
> mistake.

No you didn't, sorry about that; I was adding in your ACKs to the other
patches and must have added this one as well by mistake.

> But either way thanks for improving tests and testing a good variety
> of scenarios, I appreciate the work. Please fix bpf_object leak below
> and keep my Acked-by :)

Will do, thanks!

-Toke
