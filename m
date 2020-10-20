Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8D732941EB
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 20:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437264AbgJTSIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 14:08:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33067 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387982AbgJTSI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 14:08:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603217306;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ylwd13Ov01mxhZUrqRrb1cyJib4LmTp4McUSypk4XCc=;
        b=WOZnbnTV7GwGCArtEgDvfFs0aBWxPz+G5FZg6YM0VOootZL9Y801WjEtFVT6gezkUWZfmR
        0oy9U/y79zX9zUQrBVfP4TbBG3kDk37KtJTU7Ekzy2Yf9tEakZvNWALP+tW5t0f/fnggfo
        VMuggUemZXflZOKSGTZG3qEK+lNJ8Fo=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-518-Ng2p0oalM-qJNO8ANm3F5A-1; Tue, 20 Oct 2020 14:08:22 -0400
X-MC-Unique: Ng2p0oalM-qJNO8ANm3F5A-1
Received: by mail-ej1-f72.google.com with SMTP id k13so1156866ejv.16
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 11:08:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=Ylwd13Ov01mxhZUrqRrb1cyJib4LmTp4McUSypk4XCc=;
        b=s242YlL8nRE8XhkRJgLp4mH56GcETPFpSOqEvcOdIt6hdwERoO3yAao/x9z9upg4+x
         jKG5t8BPtWCEeHGSkk2YDIoCo+6pySnMBo5HNp9MVgH5we7AnBQLXlsGfC8q4Re+gL3l
         ojgdh0D0cMHNlY3ATt9LPx9JG5AIpqOkLmXP2/IifqSyVJ6h5f4Up4ZNaOAS9dA6R9QJ
         nQJ/Z8McxR2esTuKM40nY9m2AYDjPqyH5KlOoVTeiykDjcbfN4Wa1PzQ8BpNvJPoy75F
         wuNNbnDghGs3aUUoC/+BJKX4EjnB8o3uBPRi/gEeHlEJccMqaofY/T5Q/4mJgHT4sXt3
         skVQ==
X-Gm-Message-State: AOAM531Bb9XkFvAeTW5CnEq8ZqaZaZDqJUm7vhrL+xQ3rYFEwgCGa0lP
        /dHmTJZ6790N30LdNK/PL5qYxgxtYVqggtfUtp/Z/D82sK7Jel7DBu+DQYqezRvOKJGpWWG7AEx
        N+jAsmCRmhi4D10sF
X-Received: by 2002:a05:6402:b0c:: with SMTP id bm12mr4090723edb.108.1603217300391;
        Tue, 20 Oct 2020 11:08:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwxt/YV0A5l1MfBGBIMlKh2H6ZQjvtnow2vOtzhLpMKD/Qh0Ky9srrl/ZHNYsU1pLH6RBLApA==
X-Received: by 2002:a05:6402:b0c:: with SMTP id bm12mr4090675edb.108.1603217299800;
        Tue, 20 Oct 2020 11:08:19 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id f23sm3487656ejd.5.2020.10.20.11.08.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2020 11:08:19 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D6F5D1838FA; Tue, 20 Oct 2020 20:08:18 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf v2 1/3] bpf_redirect_neigh: Support supplying the
 nexthop as a helper parameter
In-Reply-To: <20201020093003.6e1c7fdb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <160319106111.15822.18417665895694986295.stgit@toke.dk>
 <160319106221.15822.2629789706666194966.stgit@toke.dk>
 <20201020093003.6e1c7fdb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 20 Oct 2020 20:08:18 +0200
Message-ID: <87v9f422jx.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Tue, 20 Oct 2020 12:51:02 +0200 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> diff --git a/include/linux/filter.h b/include/linux/filter.h
>> index 20fc24c9779a..ba9de7188cd0 100644
>> --- a/include/linux/filter.h
>> +++ b/include/linux/filter.h
>> @@ -607,12 +607,21 @@ struct bpf_skb_data_end {
>>  	void *data_end;
>>  };
>>=20=20
>> +struct bpf_nh_params {
>> +	u8 nh_family;
>> +	union {
>> +		__u32 ipv4_nh;
>> +		struct in6_addr ipv6_nh;
>> +	};
>> +};
>
>> @@ -4906,6 +4910,18 @@ struct bpf_fib_lookup {
>>  	__u8	dmac[6];     /* ETH_ALEN */
>>  };
>>=20=20
>> +struct bpf_redir_neigh {
>> +	/* network family for lookup (AF_INET, AF_INET6) */
>> +	__u8 nh_family;
>> +	 /* avoid hole in struct - must be set to 0 */
>> +	__u8 unused[3];
>> +	/* network address of nexthop; skips fib lookup to find gateway */
>> +	union {
>> +		__be32		ipv4_nh;
>> +		__u32		ipv6_nh[4];  /* in6_addr; network order */
>> +	};
>> +};
>
> Isn't this backward? The hole could be named in the internal structure.
> This is a bit of a gray area, but if you name this hole in uAPI and
> programs start referring to it you will never be able to reuse it.
> So you may as well not require it to be zeroed..

Hmm, yeah, suppose you're right. Doesn't the verifier prevent any part
of the memory from being unitialised anyway? I seem to recall having run
into verifier complaints when I didn't initialise struct on the stack...

-Toke

