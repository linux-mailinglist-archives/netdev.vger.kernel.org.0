Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44DB6AE158
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 01:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730276AbfIIXGI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 9 Sep 2019 19:06:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55892 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728358AbfIIXGI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Sep 2019 19:06:08 -0400
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 96BF22DD3B
        for <netdev@vger.kernel.org>; Mon,  9 Sep 2019 23:06:07 +0000 (UTC)
Received: by mail-ed1-f72.google.com with SMTP id y66so9050409ede.16
        for <netdev@vger.kernel.org>; Mon, 09 Sep 2019 16:06:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=0Vcc/CpcwFDnggZF+bM9tipKpM2+G5aqH/4y5fHGma8=;
        b=InTmkxJVMw1OdxNPYjRpKLC8jbF9Xq032vzpkmiMKmrZ9dp/AlUNTd4e/hF9BxAazs
         X1369oClyYPLeLbxIZoIyCRy8mpnQqWwBYvTDWea/iSdHekd2s9Y56JCZHR3mgV3dcgF
         t/oVaBSqcOWihOYVlzmNX+gcl7ds2jCZ0ZOkdAKdTZuO3OpXNa+fbcG3b+62xb8PRmdY
         dsTGzvXIwyyBLwnIM2u7SZJLJbrQJxLNWwmeZaZPbQA9j4+cxmW6qH9JxU2JEPQh/cCF
         4WfF3xW5tpYBe0C5bwzwJuN55K2CH/bu+ZsrtrXpAegFtGDZpCaTH0YjEi+vj1S/IXVz
         zeyQ==
X-Gm-Message-State: APjAAAUke5KQaocPo/bOEYnM1FDL+7fLFj2lwEThGkhespzMxE5oFVae
        NqgkyJo3Ptw2pTvt4UVvOnJcPCrWdCsHZ2K2D8wZvhlyzDlQlxR/CtjV8JHgBx7c1T2C9YlVHg3
        8Qg2VjUSN1UO/CcYE
X-Received: by 2002:aa7:d607:: with SMTP id c7mr27677928edr.286.1568070366399;
        Mon, 09 Sep 2019 16:06:06 -0700 (PDT)
X-Google-Smtp-Source: APXvYqx9yil8yRFH/A/aSwo0G1O5W8PW+3q4yyXMIw5BEUHsXmvyGp6uXBi9Oh49SGSYrSfiUFy48g==
X-Received: by 2002:aa7:d607:: with SMTP id c7mr27677910edr.286.1568070366180;
        Mon, 09 Sep 2019 16:06:06 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id w11sm1869129eju.9.2019.09.09.16.06.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Sep 2019 16:06:05 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 1EEDD1804C5; Tue, 10 Sep 2019 00:06:04 +0100 (WEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf\@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH] libbpf: Don't error out if getsockopt() fails for XDP_OPTIONS
In-Reply-To: <8e909219-a225-b242-aaa5-bee1180aed48@fb.com>
References: <20190909174619.1735-1-toke@redhat.com> <8e909219-a225-b242-aaa5-bee1180aed48@fb.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 10 Sep 2019 00:06:04 +0100
Message-ID: <87lfuxul2b.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yonghong Song <yhs@fb.com> writes:

> On 9/9/19 10:46 AM, Toke Høiland-Jørgensen wrote:
>> The xsk_socket__create() function fails and returns an error if it cannot
>> get the XDP_OPTIONS through getsockopt(). However, support for XDP_OPTIONS
>> was not added until kernel 5.3, so this means that creating XSK sockets
>> always fails on older kernels.
>> 
>> Since the option is just used to set the zero-copy flag in the xsk struct,
>> there really is no need to error out if the getsockopt() call fails.
>> 
>> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>> ---
>>   tools/lib/bpf/xsk.c | 8 ++------
>>   1 file changed, 2 insertions(+), 6 deletions(-)
>> 
>> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
>> index 680e63066cf3..598e487d9ce8 100644
>> --- a/tools/lib/bpf/xsk.c
>> +++ b/tools/lib/bpf/xsk.c
>> @@ -603,12 +603,8 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
>>   
>>   	optlen = sizeof(opts);
>>   	err = getsockopt(xsk->fd, SOL_XDP, XDP_OPTIONS, &opts, &optlen);
>> -	if (err) {
>> -		err = -errno;
>> -		goto out_mmap_tx;
>> -	}
>> -
>> -	xsk->zc = opts.flags & XDP_OPTIONS_ZEROCOPY;
>> +	if (!err)
>> +		xsk->zc = opts.flags & XDP_OPTIONS_ZEROCOPY;
>>   
>>   	if (!(xsk->config.libbpf_flags & XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD)) {
>>   		err = xsk_setup_xdp_prog(xsk);
>
> Since 'zc' is not used by anybody, maybe all codes 'zc' related can be 
> removed? It can be added back back once there is an interface to use
> 'zc'?

Fine with me; up to the maintainers what they prefer, I guess? :)

-Toke
