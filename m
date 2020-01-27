Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC8714A0A5
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 10:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729371AbgA0JZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 04:25:33 -0500
Received: from mail.katalix.com ([3.9.82.81]:42022 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729213AbgA0JZd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jan 2020 04:25:33 -0500
Received: from [IPv6:2a02:8010:6359:1:f9de:51c5:a310:b61b] (unknown [IPv6:2a02:8010:6359:1:f9de:51c5:a310:b61b])
        (Authenticated sender: james)
        by mail.katalix.com (Postfix) with ESMTPSA id 0B2B18CBBC;
        Mon, 27 Jan 2020 09:25:31 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=katalix.com; s=mail;
        t=1580117131; bh=PkyoiNwpKQHvwLIL56aEQ3nYdgdfvVeKXFDZ5Our4IA=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=WVYEgmwXneFNLJ0kwCLkDmtj/Nm1iF33gve7AMUD8W2XMt2q9KH+fOYQqRmZf/Amp
         +/xQ227XAZO8Ss/hbaVqEjtEG2xEYZ7iLgLJ2PD+J8uIdjrZKzg3d0CMfhOEgbEwDg
         B2hFDObcXTxs7f0nbMyeZTNB5fUpNmUhrCmSdRZrWTYh+S+tioGjk6CWqWs6D78V3r
         TZ+SYo3qo7bCaXJHPToyWkmvI0n+jzUdWr6aXw9k687iT2GSjJgECQAtc09AHZXsrs
         ZeWuSgD2CRC9zzsJlukJVW8Bdt1QiC943RKt/FqdAouMVphCPz8/MUjhanYtkYhXRT
         JzP38vbP2j1gQ==
Subject: Re: [PATCH net] l2tp: Allow duplicate session creation with UDP
To:     Guillaume Nault <gnault@redhat.com>
Cc:     Tom Parkin <tparkin@katalix.com>,
        Ridge Kennedy <ridgek@alliedtelesis.co.nz>,
        netdev <netdev@vger.kernel.org>
References: <20200116190556.GA25654@linux.home>
 <20200116212332.GD4028@jackdaw>
 <alpine.DEB.2.21.2001171027090.9038@ridgek-dl.ws.atlnz.lc>
 <20200117131848.GA3405@jackdaw> <20200117142558.GB2743@linux.home>
 <20200117191939.GB3405@jackdaw> <20200118191336.GC12036@linux.home>
 <20200120150946.GB4142@jackdaw> <20200121163531.GA6469@localhost.localdomain>
 <CAEwTi7Q4JzaCwug3M8Aa9y1yFXm1qBjQvKq3eiw=ekBft9wETw@mail.gmail.com>
 <20200125115702.GB4023@p271.fit.wifi.vutbr.cz>
From:   James Chapman <jchapman@katalix.com>
Autocrypt: addr=jchapman@katalix.com; prefer-encrypt=mutual; keydata=
 xsBNBFDmvq0BCACizu6XvQjeWZ1Mnal/oG9AkCs5Rl3GULpnH0mLvPZhU7oKbgx5MHaFDKVJ
 rQTbNEchbLDN6e5+UD98qa4ebvNx1ZkoOoNxxiuMQGWaLojDKBc9x+baW1CPtX55ikq2LwGr
 0glmtUF6Aolpw6GzDrzZEqH+Nb+L3hNTLBfVP+D1scd4R7w2Nw+BSQXPQYjnOEBDDq4fSWoI
 Cm2E18s3bOHDT9a4ZuB9xLS8ZuYGW6p2SMPFHQb09G82yidgxRIbKsJuOdRTIrQD/Z3mEuT/
 3iZsUFEcUN0T/YBN3a3i0P1uIad7XfdHy95oJTAMyrxnJlnAX3F7YGs80rnrKBLZ8rFfABEB
 AAHNJEphbWVzIENoYXBtYW4gPGpjaGFwbWFuQGthdGFsaXguY29tPsLAeAQTAQIAIgUCUOa+
 rQIbIwYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQINzVgFp/OkBr2gf7BA4jmtvUOGOO
 JFsj1fDmbAzyE6Q79H6qnkgYm7QNEw7o+5r7EjaUwsh0w13lNtKNS8g7ZWkiBmSOguJueKph
 GCdyY/KOHZ7NoJw39dTGVZrvJmyLDn/CQN0saRSJZXWtV31ccjfpJGQEn9Gb0Xci0KjrlH1A
 cqxzjwTmBUr4S2EHIzCcini1KTtjbtsE+dKP4zqR/T52SXVoYvqMmJOhUhXh62C0mu8FoDM0
 iFDEy4B0LcGAJt6zXy+YCqz7dOwhZBB4QX4F1N2BLF3Yd1pv8wBBZE7w70ds7rD7pnIaxXEK
 D6yCGrsZrdqAJfAgYL1lqkNffZ6uOSQPFOPod9UiZM7ATQRQ5r6tAQgAyROh3s0PyPx2L2Fb
 jC1mMi4cZSCpeX3zM9aM4aU8P16EDfzBgGv/Sme3JcrYSzIAJqxCvKpR+HoKhPk34HUR/AOk
 16pP3lU0rt6lKel2spD1gpMuCWjAaFs+dPyUAw13py4Y5Ej2ww38iKujHyT586U6skk9xixK
 1aHmGJx7IqqRXHgjb6ikUlx4PJdAUn2duqasQ8axjykIVK5xGwXnva/pnVprPSIKrydNmXUq
 BIDtFQ4Qz1PQVvK93KeCVQpxxisYNFRQ5TL6PtgVtK8uunABFdsRqlsw1Ob0+mD5fidITCIJ
 mYOL8K74RYU4LfhspS4JwT8nmKuJmJVZ5DjY2wARAQABwsBfBBgBAgAJBQJQ5r6tAhsMAAoJ
 ECDc1YBafzpA9CEH/jJ8Ye73Vgm38iMsxNYJ9Do9JvVJzq7TEduqWzAFew8Ft0F9tZAiY0J3
 U2i4vlVWK8Kbnh+44VAKXYzaddLXAxOcZ8YYy+sVfeVoJs3lAH+SuRwt0EplHWvCK5AkUhUN
 jjIvsQoNBVUP3AcswIqNOrtSkbuUkevNMyPtd0GLS9HVOW0e+7nFce7Ow9ahKA3iGg5Re9rD
 UlDluVylCCNnUD8Wxgve4K+thRL9T7kxkr7aX7WJ7A4a8ky+r3Daf7OhGN9S/Z/GMSs0E+1P
 Qm7kZ2e0J6PSfzy9xDtoRXRNigtN2o8DHf/quwckT5T6Z6WiKEaIKdgaXZVhphENThl7lp8=
Organization: Katalix Systems Ltd
Message-ID: <72007ca8-3ad4-62db-1b38-1ecefb82cb20@katalix.com>
Date:   Mon, 27 Jan 2020 09:25:30 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200125115702.GB4023@p271.fit.wifi.vutbr.cz>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/01/2020 11:57, Guillaume Nault wrote:
> On Wed, Jan 22, 2020 at 11:55:35AM +0000, James Chapman wrote:
>> On Tue, 21 Jan 2020 at 16:35, Guillaume Nault <gnault@redhat.com> wrot=
e:
>>> On Mon, Jan 20, 2020 at 03:09:46PM +0000, Tom Parkin wrote:
>>>> I'm struggling with it a bit though.  Wouldn't extending the hash ke=
y
>>>> like this get expensive, especially for IPv6 addresses?
>>>>
>>> From what I recall, L2TP performances are already quite low. That's
>>> certainly not a reason for making things worse, but I believe that
>>> computing a 3 or 5 tuple hash should be low overhead in comparison.
>>> But checking with real numbers would be interesting.
>>>
>> In my experience, poor L2TP data performance is usually the result of
>> MTU config issues causing IP fragmentation in the tunnel. L2TPv3
>> ethernet throughput is similar to ethernet bridge throughput in the
>> setups that I know of.
>>
> I said that because I remember I had tested L2TPv3 and VXLAN a few
> years ago and I was surprised by the performance gap. I certainly can't=

> remember the details of the setup, but I'd be very surprised if I had
> misconfigured the MTU.


Fair enough. I'd be interested in your observations and ideas regarding
improving performance at some point. But I suggest keep this thread
focused on the session ID scope issue.


>> Like my colleague, Tom, I'm also struggling with this approach.
>>
> I don't pretend that implementing scoped sessions IDs is trivial. It
> just looks like the best way to solve the compatibility problem (IMHO).=


>> I can't see how replacing a lookup using a 32-bit hash key with one
>> using a 260-bit or more key (128+128+4 for two IPv[46] addresses and
>> the session ID) isn't going to hurt performance, let alone the
>> per-session memory footprint. In addition, it is changing the scope of=

>> the session ID away from what is defined in the RFC.
>>
> I don't see why we'd need to increase the l2tp_session's structure size=
=2E
> We can already get the 3/5-tuple from the parent's tunnel socket. And
> there are some low hanging fruits to pick if one wants to reduce L2TP's=

> memory footprint.
>
> From a performance point of view, 3/5-tuple matches are quite common
> operations in the networking stack. I don't expect that to be costly
> compared to the rest of the L2TP Rx operations. And we certainly have
> room to streamline the datapath if necessary.


I was assuming the key used for the session ID lookup would be stored
with the session so that we wouldn't have to prepare it for each and
every packet receive.


>> I think Linux shouldn't diverge from the spirit of the L2TPv3 RFC
>> since the RFC is what implementors code against. Ridge's application
>> relies on duplicated L2TPv3 session IDs which are scoped by the UDP
>> 5-tuple address. But equally, there may be existing applications out
>> there which rely on Linux performing L2TPv3 session lookup by session
>> ID alone, as per the RFC. For IP-encap, Linux already does this, but
>> not for UDP. What if we get a request to do so for UDP, for
>> RFC-compliance? It would be straightforward to do as long as the
>> session ID scope isn't restricted by the proposed patch.
>>
> As long as the external behavior conforms to the RFC, I don't see any
> problem. Local applications are still responsible for selecting
> session-IDs. I don't see how they could be confused if the kernel
> accepted more IDs, especially since that was the original behaviour.

But it wouldn't conform with the RFC.

RFC3931 says:

=C2=A0The Session ID alone provides the necessary context for all further=

=C2=A0packet processing, including the presence, size, and value of the
=C2=A0Cookie, the type of L2-Specific Sublayer, and the type of payload
=C2=A0being tunneled.

and also

=C2=A0The data message format for tunneling data packets may be utilized
=C2=A0with or without the L2TP control channel, either via manual
=C2=A0configuration or via other signaling methods to pre-configure or
=C2=A0distribute L2TP session information.

>> I'm not aware
>> that such an application exists, but my point is that the RFC is a key=

>> document that implementors use when implementing applications so
>> diverging from it seems more likely to result in unforseen problems
>> later.
>>
> I would have to read the RFC with scoped session IDs in mind, but, as
> far as I can see, the only things that global session IDs allow which
> can't be done with scoped session IDs are:
>   * Accepting L2TPoIP sessions to receive L2TPoUDP packets and
>     vice-versa.
>   * Accepting L2TPv3 packets from peers we're not connected to.
>
> I don't find any of these to be desirable. Although Tom convinced me
> that global session IDs are in the spirit of the RFC, I still don't
> think that restricting their scope goes against it in any practical
> way. The L2TPv3 control plane requires a two way communication, which
> means that the session is bound to a given 3/5-tuple for control
> messages. Why would the data plane behave differently?


The Cable Labs / DOCSIS DEPI protocol is a good example. It is based on
L2TPv3 and uses the L2TPv3 data plane. It treats the session ID as
unscoped and not associated with a given tunnel.


> I agree that it looks saner (and simpler) for a control plane to never
> assign the same session ID to sessions running over different tunnels,
> even if they have different 3/5-tuples. But that's the user space
> control plane implementation's responsability to select unique session
> IDs in this case. The fact that the kernel uses scoped or global IDs is=

> irrelevant. For unmanaged tunnels, the administrator has complete
> control over the local and remote session IDs and is free to assign
> them globally if it wants to, even if the kernel would have accepted
> reusing session IDs.


I disagree. Using scoped session IDs may break applications that assume
RFC behaviour. I mentioned one example where session IDs are used
unscoped above.


>> It's unfortunate that Linux previously unintentionally allowed L2TPv3
>> session ID clashes and an application is in the field that relies on
>> this behaviour. However, the change that fixed this (and introduced
>> the reported regression) was back in March 2017 and the problem is
>> only coming to light now. Of the options we have available, a knob to
>> re-enable the old behaviour may be the best compromise after all.
>>
>> Could we ask Ridge to submit a new version of his patch which includes=

>> a knob to enable it?
>>
> But what would be the default behaviour? If it's "use global IDs", then=

> we'll keep breaking applications that used to work with older kernels.
> Ridge would know how to revert to the ancient behaviour, but other
> users would probably never know about the knob. And if we set the
> default behaviour to "allow duplicate IDs for L2TPv3oUDP", then the
> knob doesn't need to be implemented as part of Ridge's fix. It can
> always be added later, if we ever decide to unify session lookups
> accross L2TPoUDP and L2TPoIP and that extending the session hash key
> proves not to be a practical solution.


The default would be the current behaviour: "global IDs". We'll be
breaking applications that assume scoped session IDs, yes. But I think
the number of these applications will be minimal given the RFC is clear
that session IDs are unscoped and the kernel has worked this way for
almost 3 years.

I think it's important that the kernel continues to treat the L2TPv3
session ID as "global".

However, there might be an alternative solution to fix this for Ridge's
use case that doesn't involve adding 3/5-tuple session ID lookups in the
receive path or adding a control knob...

My understanding is that Ridge's application uses unmanaged tunnels
(like "ip l2tp" does). These use kernel sockets. The netlink tunnel
create request does not indicate a valid tunnel socket fd. So we could
use scoped session IDs for unmanaged UDP tunnels only. If Ridge's patch
were tweaked to allow scoped IDs only for UDP unmanaged tunnels (adding
a test for tunnel->fd < 0), managed tunnels would continue to work as
they do now and any application that uses unmanaged tunnels would get
scoped session IDs. No control knob or 3/5-tuple session ID lookups
required.


> Sorry for replying late. It's been a busy week.


No problem at all.



