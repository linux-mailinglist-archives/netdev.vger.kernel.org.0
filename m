Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8F814416D
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 17:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729401AbgAUQDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 11:03:00 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:41852 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729108AbgAUQC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 11:02:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579622577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pvLMcX87nNXcIHIosOHPLdMsc+VCUVWgqOIanxRYoc8=;
        b=Cq9ih83IcL8UVReWI7GvlPDJhMtjsuB3ccVWgXdVzA4jHjCjNfNFFhjErd2tE2MmrVmtsH
        qH1zT4usxS1fjXbnchHd0WJ0Nza1iKUvdjUJ13pvyN9uTwwHFm9YvHVv0i3Fdd3BI87Hv5
        U0nkPHu1pYbQBfJULVECNS1zRHj977Y=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-163-1qNdlKEcOXCKiC_wU5Ro-w-1; Tue, 21 Jan 2020 11:02:53 -0500
X-MC-Unique: 1qNdlKEcOXCKiC_wU5Ro-w-1
Received: by mail-lf1-f70.google.com with SMTP id t8so992260lfc.21
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 08:02:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=pvLMcX87nNXcIHIosOHPLdMsc+VCUVWgqOIanxRYoc8=;
        b=N6SxaLPvlnQfP3KTEEr+f8qe6yc689pvonkPiBcTgwQhA2y5KCa6Ml6eFo87tpQp6J
         2oFxTiygjDKtoKE588pIAqyFwEfoIrYM1DN++k67hhtI7SBDSq3TSSP2TG2BH8kJp9mm
         ikRqk3m2MKd2hSuGHePydLQtapRCEjv+81bTefT0fIeGKXFArwV668uf2aYVh2oj4G8U
         2F+aTxj+g0pBxmBIqlt8b7lVkw1W0ITKqKH7ea9UtjjBynYcBa4SRktFHKYnUX6XGkxn
         W1Yp11vPPriyz7vLjsHhYZPnU6ddXLiWyT1zkY2obQ7ltWmrmGzcb7xLx+LG2hwXH1xx
         b/eA==
X-Gm-Message-State: APjAAAVgj8CrtZ7R7ejDMFvGmYqUguZr/NKwDUgeNwwcM4wZrKOMk0/I
        tML8KXA9r7vAZ4LJ2Ia1qL4GiFoJFQ4jqasqHXhfas2nG4f7jXdY3eXineiu+0N85JBI5apLw9Y
        E7Pgxy/oO6mbTEDxp
X-Received: by 2002:a2e:9ad0:: with SMTP id p16mr17420867ljj.111.1579622571876;
        Tue, 21 Jan 2020 08:02:51 -0800 (PST)
X-Google-Smtp-Source: APXvYqwcb2IG3VK4lqVUTU3D62aynf/9UnEw85nVi7PkLMNR3i8Lv2ZDTx6IUsam0e569+bUirYxxw==
X-Received: by 2002:a2e:9ad0:: with SMTP id p16mr17420851ljj.111.1579622571578;
        Tue, 21 Jan 2020 08:02:51 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([85.204.121.218])
        by smtp.gmail.com with ESMTPSA id u15sm1482121lfl.87.2020.01.21.08.02.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2020 08:02:50 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id AA76818006B; Tue, 21 Jan 2020 17:02:49 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Gautam Ramakrishnan <gautamramk@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Dave Taht <dave.taht@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Leslie Monis <lesliemonis@gmail.com>
Subject: Re: [PATCH net-next v4 05/10] pie: rearrange structure members and their initializations
In-Reply-To: <CADAms0zvGp4ffqmvZV6RVOTfrosjt6Ht6EkyQ594yJYQFTJBXA@mail.gmail.com>
References: <20200121141250.26989-1-gautamramk@gmail.com> <20200121141250.26989-6-gautamramk@gmail.com> <20200121.153522.1248409324581446114.davem@davemloft.net> <CADAms0zvGp4ffqmvZV6RVOTfrosjt6Ht6EkyQ594yJYQFTJBXA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 21 Jan 2020 17:02:49 +0100
Message-ID: <87ftg8bxw6.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Gautam Ramakrishnan <gautamramk@gmail.com> writes:

> On Tue, Jan 21, 2020 at 8:05 PM David Miller <davem@davemloft.net> wrote:
>>
>> From: gautamramk@gmail.com
>> Date: Tue, 21 Jan 2020 19:42:44 +0530
>>
>> > From: "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>
>> >
>> > Rearrange the members of the structures such that they appear in
>> > order of their types. Also, change the order of their
>> > initializations to match the order in which they appear in the
>> > structures. This improves the code's readability and consistency.
>> >
>> > Signed-off-by: Mohit P. Tahiliani <tahiliani@nitk.edu.in>
>> > Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
>> > Signed-off-by: Gautam Ramakrishnan <gautamramk@gmail.com>
>>
>> What matters for structure member ordering is dense packing and
>> grouping commonly-used-together elements for performance.
>>
> We shall reorder the variables as per their appearance in the
> structure and re-submit. Could you elaborate a bit on dense packing?

The compiler will align struct member offsets according to their size,
adding padding as necessary to achieve this.
So this struct:

struct s1 {
       u32 mem32_1;
       u64 mem64_1;
       u32 mem32_2;
       u64 mem64_2;
};

will have 4 bytes of padding after both mem32_1 and mem32_2, whereas
this struct:

struct s2 {
       u64 mem64_1;
       u32 mem32_1;
       u32 mem32_2;
       u64 mem64_2;
};

won't. So sizeof(struct s1) == 32, and sizeof(struct s2) == 24, and we
say that s2 is densely packed, whereas s1 has holes in it.

The pahole tool is useful to see the layout of compiled structures
(pahole -C). It will also point out any holes.

-Toke

