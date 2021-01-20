Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0432FD428
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 16:37:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390464AbhATPeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 10:34:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35064 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390327AbhATO4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 09:56:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611154486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X49NCmr4OtIJ2Tlhjkaw9vv7Dceo8nUFaTM3w1LgmjA=;
        b=RACtSkthlv6w4Z1W2uHq0phDU/VW04fjQOtvX5pKIAoybxlIoPrQOjU2xA5dHOzVic6CmZ
        f48e2AbeYXmlI9+KAadAcB3HfJIm3NxGQFal6Bv4xhk3WtHSi0SPmWHeHKiDvXAPCWmJHe
        wp3P6YkNCoxUtDWahMYgvaM7ny8BP0o=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-xa4rLaVuP5eAfmuOqRFtCw-1; Wed, 20 Jan 2021 09:54:44 -0500
X-MC-Unique: xa4rLaVuP5eAfmuOqRFtCw-1
Received: by mail-ed1-f70.google.com with SMTP id o19so4520777edq.9
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 06:54:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=X49NCmr4OtIJ2Tlhjkaw9vv7Dceo8nUFaTM3w1LgmjA=;
        b=N2G7hIAbu6HogblIqHl0fiex5O/XkATulcKrlAYmdmQl2vK8jYe1eMH58axUGzW8EA
         BfFj/SIR6oJw8mI0WT6NhbyFfq4VTW1lpcw5xpIJ5zAMaeeqHSCKK7abOc2pXm7GVVHG
         WT7lAhgI5cYgUJL9hi+rQ14EKN7O+tEX+I9xMtZIDxrdtWKuZaua01SGXJ3AQagp/pch
         l74IOHO3DXAemKUBfoFKhpSot18z4i3hvbTSd9ojubcMa4T1l5BE8GoyE7hR3t5qcLu+
         VIT8UG5OvLJmoAmQq8DffwlT7gKWFb7PoUCbC0nn7l0fUresMifu3QaVOM5GIcIawPZ3
         wjgA==
X-Gm-Message-State: AOAM533zSh3yscdGZzrx6mql6/iTmccsBYJseVSWe9+SPK5Qen1Ohho9
        cGNyo3U1HJs7Oasa9agXAFY+aMcS7VXsSrGeoW/HDfzxXvj+itv9dkCV8tzXW0y4uuuBj/Oop2C
        R28hszdZ5VT1R2L4V
X-Received: by 2002:a17:906:4bc1:: with SMTP id x1mr6408414ejv.509.1611154483104;
        Wed, 20 Jan 2021 06:54:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJznxKp8R07OXJgtMpuBX1xmrWJ/UPYE/s1NRu+fNuUBSpMWC5OFnQe2n1P4DF+kdpbQsAkp/w==
X-Received: by 2002:a17:906:4bc1:: with SMTP id x1mr6408406ejv.509.1611154482966;
        Wed, 20 Jan 2021 06:54:42 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id q2sm1196924edv.93.2021.01.20.06.54.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 06:54:42 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E1E58180331; Wed, 20 Jan 2021 15:54:41 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org, jonathan.lemon@gmail.com, maximmi@nvidia.com,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        ciara.loftus@intel.com, weqaar.a.janjua@intel.com
Subject: Re: [PATCH bpf-next v2 4/8] xsk: register XDP sockets at bind(),
 and add new AF_XDP BPF helper
In-Reply-To: <46162f5f-5b3c-903b-8b8d-7c1afc74cb05@intel.com>
References: <20210119155013.154808-1-bjorn.topel@gmail.com>
 <20210119155013.154808-5-bjorn.topel@gmail.com> <878s8neprj.fsf@toke.dk>
 <46162f5f-5b3c-903b-8b8d-7c1afc74cb05@intel.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 20 Jan 2021 15:54:41 +0100
Message-ID: <87k0s74q1a.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com> writes:

> On 2021-01-20 13:50, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:
>>=20
>>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>>> index c001766adcbc..bbc7d9a57262 100644
>>> --- a/include/uapi/linux/bpf.h
>>> +++ b/include/uapi/linux/bpf.h
>>> @@ -3836,6 +3836,12 @@ union bpf_attr {
>>>    *	Return
>>>    *		A pointer to a struct socket on success or NULL if the file is
>>>    *		not a socket.
>>> + *
>>> + * long bpf_redirect_xsk(struct xdp_buff *xdp_md, u64 action)
>>> + *	Description
>>> + *		Redirect to the registered AF_XDP socket.
>>> + *	Return
>>> + *		**XDP_REDIRECT** on success, otherwise the action parameter is ret=
urned.
>>>    */
>>=20
>> I think it would be better to make the second argument a 'flags'
>> argument and make values > XDP_TX invalid (like we do in
>> bpf_xdp_redirect_map() now). By allowing any value as return you lose
>> the ability to turn it into a flags argument later...
>>
>
> Yes, but that adds a run-time check. I prefer this non-checked version,
> even though it is a bit less futureproof.

That...seems a bit short-sighted? :)
Can you actually see a difference in your performance numbers?

-Toke

