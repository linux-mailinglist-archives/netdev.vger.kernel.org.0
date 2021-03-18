Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4709E3407B6
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 15:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbhCROUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 10:20:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29421 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230269AbhCROTw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 10:19:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616077191;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HyS/wOCby9V1eK7ITvUfmwzDLjAaah1lpf8TDwH3Upg=;
        b=U5DgmCCWbL0MDBlwt/Ac6ZXCEvQ/BsHted/CyD7NJ9Wc5HYY/cQYiWIz/GlEB/njLnXNfn
        Fxjb7c6kc7/jAeDulkQvFIGdtaSuld1ROYk2qcbgugbzCCiF9NVkOO4vuhmwPyJLfgbIyr
        mAj2AZ+wrEXIcIbndXhxYYtjfotLFpQ=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-AYu5n5YHMcOCnBKtTdgtQA-1; Thu, 18 Mar 2021 10:19:50 -0400
X-MC-Unique: AYu5n5YHMcOCnBKtTdgtQA-1
Received: by mail-ej1-f70.google.com with SMTP id fy8so16704414ejb.19
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 07:19:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=HyS/wOCby9V1eK7ITvUfmwzDLjAaah1lpf8TDwH3Upg=;
        b=m5SBlt1soOLBXWiJFXjDqcTxT8/z5Qr8s8vcsMZZIoe8IWW9oB2gJ2idCP4IPJnX4r
         xl/a3vmTwSMrH/dFVSA1IEVTZLoe1z882xf+dhO1Id2yKhuOEYXHm9p5jwDNInF+zvZ2
         EXYCxHxZWwFW5aXw4BMs4xMDIt3VVf6X5JISs4xo9D3KmSZJZzuq+/ZTtHeBkz7ENEXg
         Ftsz5nxjebrdn1jhc/LOh11sV4tJZXhtUFYfDmljatwt0aYhOpCgADdkjoYaThj0ojH6
         MBEcq0vicJnyj2oFT596X2eJBpqTWLm+ZOnSEJw6OSefxH10bLZt0pp5n5AcRi0WWTMe
         fENw==
X-Gm-Message-State: AOAM533qmyT58HVXT8zm2JTHCEFt9tOrrLCCzjXDJs821/6RoXdOIKCv
        GL+Oc0Glt7+4+bun2mLvUw8XNryZS5aDOV9/ntaNhwt19+noilMfA8oF3zZrYl/8EibUpYjltdD
        BGSVvu01toMRhrqld
X-Received: by 2002:a05:6402:4245:: with SMTP id g5mr4013147edb.306.1616077189001;
        Thu, 18 Mar 2021 07:19:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxRI1rPWv8fl0rrhCiL99uDZU48QX8KglnOrp57iNLJlU7tgzOUkE6p1LdfAuqTLs578mJRfQ==
X-Received: by 2002:a05:6402:4245:: with SMTP id g5mr4013125edb.306.1616077188868;
        Thu, 18 Mar 2021 07:19:48 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id p9sm2218245eds.66.2021.03.18.07.19.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 07:19:48 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7B020181F54; Thu, 18 Mar 2021 15:19:47 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        bjorn@kernel.org
Subject: Re: [PATCHv2 bpf-next 2/4] xdp: extend xdp_redirect_map with
 broadcast support
In-Reply-To: <20210318035200.GB2900@Leo-laptop-t470s>
References: <20210309101321.2138655-1-liuhangbin@gmail.com>
 <20210309101321.2138655-3-liuhangbin@gmail.com> <87r1kec7ih.fsf@toke.dk>
 <20210318035200.GB2900@Leo-laptop-t470s>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 18 Mar 2021 15:19:47 +0100
Message-ID: <875z1oczng.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu <liuhangbin@gmail.com> writes:

> On Wed, Mar 17, 2021 at 01:03:02PM +0100, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> FYI, this no longer applies to bpf-next due to Bj=C3=B6rn's refactor in
>> commit: ee75aef23afe ("bpf, xdp: Restructure redirect actions")
>
> Thanks Toke, I need to see how to get the map via map_id, does
> bpf_map_get_curr_or_next() works? Should I call bpf_map_put() after
> using?

I would expect that to be terrible for performance; I think it would be
better to just add back the map pointer into struct bpf_redirect_info.
If you only set the map pointer when the multicast flag is set, you can
just check that pointer to disambiguate between when you need to call
dev_map_enqueue() and dev_map_enqueue_multi(), in which case you don't
need to add back the flags member...

-Toke

