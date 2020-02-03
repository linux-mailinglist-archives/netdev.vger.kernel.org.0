Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFFCF1510C7
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 21:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbgBCUJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 15:09:50 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:26053 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726187AbgBCUJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 15:09:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580760588;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M66dZQr8zh54AKCTLeSIJcqSwqyDWpUuHrAy2IJifAE=;
        b=hd+nbKPQEcSPGBqt/GuoSP18K/U21HztaMz+z5zrAA7xOvXZ7hk0dimu0XrLzXcq+B9zqj
        njgDcPHel5PS39J02dKNTvnR0lR0W4OVq0jTrpnf9trwW2Gl9GvcKiDmOra/PMbD+1CqAV
        t9CXb3eVDZL+d0GLM7WIyTXJ4sMu1QQ=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-290-QF7NRFggNMmFeXfI_x48FA-1; Mon, 03 Feb 2020 15:09:45 -0500
X-MC-Unique: QF7NRFggNMmFeXfI_x48FA-1
Received: by mail-lj1-f199.google.com with SMTP id z11so2066168ljm.15
        for <netdev@vger.kernel.org>; Mon, 03 Feb 2020 12:09:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=M66dZQr8zh54AKCTLeSIJcqSwqyDWpUuHrAy2IJifAE=;
        b=T/PpR8bLqgF9k6bjudKLkM+WJcVfhii5TrpfrzZzqI1KuW5S2ri0zCGSFW/zYKpsOZ
         HPPv+9EfNyEVz6hAkZpegsR7t6xGdtiyGF/NVgDsTO6tinRSvfQxcmX+5CvUo0ISU4VU
         tIxcdBpvFn8NUQ1wFaBczdCaRs/vfsAxFm6Nk8SigyV0a5n1nwZ0Lg94g59Ho1OKEK5A
         v0iinR02qQBEH5syYj3KJ0Cvcs8jO+mFYqnoy2odHLrh6Ye7qqPJ6XlTbyWqiH7WFEya
         0R7bteh4LPu8+xD6eZH1h8vAQ8JaMgzdrlYQcvV/BLGXmEo+ZalYdWjjNGXIK1joG0Yq
         4a9g==
X-Gm-Message-State: APjAAAUOmRcyarHjZ0oodhdO+RiN7xUn9CDP7VQO0aY2lY8jEf7Jnl1W
        iXWkbZQpQk/urp2u8JObPkfAmApV2VxjUzS4qewn+aUySco8CSKCjUR0GtnsaQPQmsv+75Fn0m1
        /0+26uKjoFUgHdohi
X-Received: by 2002:a05:651c:321:: with SMTP id b1mr15086679ljp.62.1580760584378;
        Mon, 03 Feb 2020 12:09:44 -0800 (PST)
X-Google-Smtp-Source: APXvYqzDfSnl/NpysL+6czvAYRi+nPSatjeBEVwAm4EgTDSSxW0/eNuKi/M1FU9WeE0sVSlZkw9dNA==
X-Received: by 2002:a05:651c:321:: with SMTP id b1mr15086660ljp.62.1580760584131;
        Mon, 03 Feb 2020 12:09:44 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id p15sm9527706lfo.88.2020.02.03.12.09.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2020 12:09:43 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 55A7B1800A2; Mon,  3 Feb 2020 21:09:42 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@gmail.com>, Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        davem@davemloft.net, jbrouer@redhat.com, mst@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH bpf-next 03/12] net: Add IFLA_XDP_EGRESS for XDP programs in the egress path
In-Reply-To: <9779cff1-5117-41aa-968d-414867244f37@gmail.com>
References: <20200123014210.38412-1-dsahern@kernel.org> <20200123014210.38412-4-dsahern@kernel.org> <87tv4m9zio.fsf@toke.dk> <335b624a-655a-c0c6-ca27-102e6dac790b@gmail.com> <20200124072128.4fcb4bd1@cakuba> <87o8usg92d.fsf@toke.dk> <1d84d8be-6812-d63a-97ca-ebc68cc266b9@gmail.com> <87o8uie1t5.fsf@toke.dk> <9779cff1-5117-41aa-968d-414867244f37@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 03 Feb 2020 21:09:42 +0100
Message-ID: <875zgncu0p.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@gmail.com> writes:

> On 2/1/20 8:59 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>=20
>> In any case an egress program will differ in:
>>=20
>> - The context object (the RX-related fields will be invalid on egress,
>>   and we'll probably want to add new TX-related ones, such as HW
>>   TX-queue occupancy).
>
> Jakub has suggested that rx_queue_index can be a union with
> tx_queue_index; the former for the Rx path and the latter for the egress.
>
> The rest of the fields in xdp_md are legit for either direction.

Right, okay, ifindex and queue index could make sense in both
directions. But it would still mean that we would limit ourselves to
only adding new fields that would work on both RX and TX. Maybe that is
OK, though.

>> - The return code semantics (even if XDP_TX becomes equivalent to
>>   XDP_PASS, that is still a semantic difference from the RX side; and
>>   it's not necessarily clear whether we'll want to support REDIRECT on
>>   the egress side either, is it?)
>
> Why should REDIRECT not be allowed in the egress path? e.g., service
> chaining or capturing suspicious packets (e.g., encap with a header and
> redirect somewhere for analysis).

Implementation and deployment complexity, mostly (loops!)? I do agree
that it would be nice to allow it, I'm just not entirely convinced that
it's feasible...

>> So we'll have to disambiguate between the two different types of
>> programs. Which means that what we're discussing is really whether that
>> disambiguation should be encoded in the program type, or in the attach
>> type. IMO, making it a separate program type is a clearer and more
>> explicit UAPI. The verifier could still treat the two program types as
>> basically equivalent except for those cases where there has to be a
>> difference anyway. So it seems to me that all you are saving by using
>> attach_type instead of program type is the need for a new enum value and
>> a bunch of additions to switch statements? Or am I wildly
>> underestimating the effort to add a new program type?
>>=20
>
> IMHO that is duplicating code and APIs for no real reason. XDP refers to
> fast path processing, the only difference is where the program is
> attached - Rx side or Tx side.

Sure, if we can guarantee API and semantic equivalence. I.e., if any XDP
program really *can* be attached as both an RX and TX program, I have no
objections to re-using the program type. But if it turns out that there
*is* a difference, we're making implicit subtypes anyway, in which case
I think it's better to be explicit about the difference.

-Toke

