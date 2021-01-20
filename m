Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 898DA2FD745
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 18:42:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731759AbhATRgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 12:36:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51963 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387459AbhATRbK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 12:31:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611163784;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ib3A1b3X/veF7PE4d9KVB5tdoRYIUP6N9GcGtTCFbLs=;
        b=V3FrxwJF0tO3DlLugCVrz7+G0KWA5K5OC6SEtIPhNDcOy7GLHq5NO8pBc3EHYqDQSoQTRA
        7xYKnvVPWgpV87CJLnJlv4+/6bXgBNkdMyXg04UX7tu7sCEDNAvzWOQfuVlLnngSlBTd7M
        y19EvJ/xN69KtcbkM99v5/+/XkfhsNs=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-55-GraMCBE3NwiMBQJ-IP0QQg-1; Wed, 20 Jan 2021 12:29:41 -0500
X-MC-Unique: GraMCBE3NwiMBQJ-IP0QQg-1
Received: by mail-ej1-f72.google.com with SMTP id x22so7732218ejb.10
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 09:29:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=Ib3A1b3X/veF7PE4d9KVB5tdoRYIUP6N9GcGtTCFbLs=;
        b=cio5W+0hz1a+deUmsZZAusBKkcOTzOluo3eNvxggySRvb2b/t2YVK0JPf7HexDGqkt
         46FtBAPJgNjPNtfiMLHREdsjs2zQwCm6JQQjg+ttGnCMkF8QnjAMODepIqUZyr/kjSP/
         jKVJ0HK5OP3h52kd7WZPY16RNgAZL7nJ7Z56EGU+OBGHl2qUsx1lNahspr/60v3B4LT8
         6J1+/zhVc6CCUtvzANKFyYASmYwpQ3hbHqzvrNnx1C7vjBGXgFecxLi69pnjTsfz4pY+
         fjbsJ3/OLxTg+q4zQWAT6oU7VDc3RsOdAyoafRgEEQkN/O47MR2LuVgt15fvJYuCRA4x
         pkBw==
X-Gm-Message-State: AOAM533iSTLjpeaWKoyK3CoX5luTp6rhX+DtE3k6iVeoSi1OZCUzKdaD
        PW7PCzbS8GUpbC9nbv7KDN4Ia0dcMaqE/FcHRq2dkG+GHTquz8bejwtVGCVuVsKelKZcv2w3rvc
        LQQWY/42MRazyeWr6
X-Received: by 2002:a17:906:1348:: with SMTP id x8mr6613715ejb.81.1611163780320;
        Wed, 20 Jan 2021 09:29:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyO+bRzvpM47Of011EuhJYdd3Cu5d6G2A7lU2oCiieRE4GNhhH/x1NjaLAjpqBLB+PUpSPLYw==
X-Received: by 2002:a17:906:1348:: with SMTP id x8mr6613689ejb.81.1611163779990;
        Wed, 20 Jan 2021 09:29:39 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id k22sm1135282eji.101.2021.01.20.09.29.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 09:29:39 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E025C180331; Wed, 20 Jan 2021 18:29:38 +0100 (CET)
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
In-Reply-To: <3c6feb0d-6a64-2251-3cac-c79cff29d85c@intel.com>
References: <20210119155013.154808-1-bjorn.topel@gmail.com>
 <20210119155013.154808-5-bjorn.topel@gmail.com> <878s8neprj.fsf@toke.dk>
 <46162f5f-5b3c-903b-8b8d-7c1afc74cb05@intel.com> <87k0s74q1a.fsf@toke.dk>
 <3c6feb0d-6a64-2251-3cac-c79cff29d85c@intel.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 20 Jan 2021 18:29:38 +0100
Message-ID: <8735yv4iv1.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com> writes:

> On 2021-01-20 15:54, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com> writes:
>>=20
>>> On 2021-01-20 13:50, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>>> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:
>>>>
>>>>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>>>>> index c001766adcbc..bbc7d9a57262 100644
>>>>> --- a/include/uapi/linux/bpf.h
>>>>> +++ b/include/uapi/linux/bpf.h
>>>>> @@ -3836,6 +3836,12 @@ union bpf_attr {
>>>>>     *	Return
>>>>>     *		A pointer to a struct socket on success or NULL if the file is
>>>>>     *		not a socket.
>>>>> + *
>>>>> + * long bpf_redirect_xsk(struct xdp_buff *xdp_md, u64 action)
>>>>> + *	Description
>>>>> + *		Redirect to the registered AF_XDP socket.
>>>>> + *	Return
>>>>> + *		**XDP_REDIRECT** on success, otherwise the action parameter is r=
eturned.
>>>>>     */
>>>>
>>>> I think it would be better to make the second argument a 'flags'
>>>> argument and make values > XDP_TX invalid (like we do in
>>>> bpf_xdp_redirect_map() now). By allowing any value as return you lose
>>>> the ability to turn it into a flags argument later...
>>>>
>>>
>>> Yes, but that adds a run-time check. I prefer this non-checked version,
>>> even though it is a bit less futureproof.
>>=20
>> That...seems a bit short-sighted? :)
>> Can you actually see a difference in your performance numbers?
>>
>
> I would rather add an additional helper *if* we see the need for flags,
> instead of paying for that upfront. For me, BPF is about being able to
> specialize, and not having one call with tons of checks.

I get that, I'm just pushing back because omitting a 'flags' argument is
literally among the most frequent reasons for having to replace a
syscall (see e.g., [0]) instead of extending it. And yeah, I do realise
that the performance implications are different for XDP than for
syscalls, but maintainability of the API is also important; it's all a
tradeoff. This will be the third redirect helper variant for XDP and I'd
hate for the fourth one to have to be bpf_redirect_xsk_flags() because
it did turn out to be needed...

(One potential concrete reason for this: I believe Magnus was talking
about an API that would allow a BPF program to redirect a packet into
more than one socket (cloning it in the process), or to redirect to a
socket+another target. How would you do that with this new helper?)

[0] https://lwn.net/Articles/585415/

> (Related; Going forward, the growing switch() for redirect targets in
> xdp_do_redirect() is a concern for me...)
>
> And yes, even with all those fancy branch predictors, less instructions
> is still less. :-) (It shows in my ubenchs.)

Right, I do agree that the run-time performance hit of checking the flag
sucks (along with being hard to check for, cf. our parallel discussion
about version checks). So ideally this would be fixed by having the
verifier enforce the argument ranges instead; but if we merge this
without the runtime check now we can't add that later without
potentially breaking programs... :(

-Toke

