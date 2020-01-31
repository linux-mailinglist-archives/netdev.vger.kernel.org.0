Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A910914E96F
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 09:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728134AbgAaIMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 03:12:03 -0500
Received: from mail.katalix.com ([3.9.82.81]:35964 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728099AbgAaIMD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 03:12:03 -0500
Received: from [IPv6:2a02:8010:6359:1:f9de:51c5:a310:b61b] (unknown [IPv6:2a02:8010:6359:1:f9de:51c5:a310:b61b])
        (Authenticated sender: james)
        by mail.katalix.com (Postfix) with ESMTPSA id 56CE28F80B;
        Fri, 31 Jan 2020 08:12:01 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=katalix.com; s=mail;
        t=1580458321; bh=N+NztQWSEOPgX3hRcjNr52KbnmqYjqa+ofF1CiKnAi8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=u/6WTAUWtfMYDAXfNrWAcuvfi7wB7qcT8Osy/2r5tFjJGB1XIdDtuyE8foDg57Bk+
         ovIytkafBsM0bcm06bjy/Oa/fF/pBzD7G5FM0Rrnv6Amr7jLUCerSa3AhpxnRVKfpB
         RxJOhmyr//GxdfLoVZvdB4STcH9mYEYQ+PGTZyGbOqlTxqmkoN7hgjBR8kqb4rkr3M
         3Z7nqqfK6aws4F7HJTV8JAkEP1BicxKpTVSDfqlUwib/i1LwcuoBQBQmhb88QrwY8z
         7w60oRVk6anPhHSylWj5ebcvPIlcFNOpDAWBr4F8eiIcwuDi1v5hiOiXMnd7rh/lNa
         qR7fratMki/Kw==
Subject: Re: [PATCH net] l2tp: Allow duplicate session creation with UDP
To:     Guillaume Nault <gnault@redhat.com>
Cc:     Tom Parkin <tparkin@katalix.com>,
        Ridge Kennedy <ridgek@alliedtelesis.co.nz>,
        netdev <netdev@vger.kernel.org>
References: <20200117142558.GB2743@linux.home> <20200117191939.GB3405@jackdaw>
 <20200118191336.GC12036@linux.home> <20200120150946.GB4142@jackdaw>
 <20200121163531.GA6469@localhost.localdomain>
 <CAEwTi7Q4JzaCwug3M8Aa9y1yFXm1qBjQvKq3eiw=ekBft9wETw@mail.gmail.com>
 <20200125115702.GB4023@p271.fit.wifi.vutbr.cz>
 <72007ca8-3ad4-62db-1b38-1ecefb82cb20@katalix.com>
 <20200129114419.GA11337@pc-61.home>
 <0d7f9d7e-e13b-8254-6a90-fc08bade3e16@katalix.com>
 <20200130223440.GA28541@pc-61.home>
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
Message-ID: <95e86df4-0fff-5f41-8556-eeaede23340d@katalix.com>
Date:   Fri, 31 Jan 2020 08:12:01 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200130223440.GA28541@pc-61.home>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/01/2020 22:34, Guillaume Nault wrote:
> On Thu, Jan 30, 2020 at 10:28:23AM +0000, James Chapman wrote:
>> On 29/01/2020 11:44, Guillaume Nault wrote:
>>> Since userspace is in charge of selecting the session ID, I still can=
't
>>> see how having the kernel accept duplicate IDs goes against the RFC.
>>> The kernel doesn't assign duplicate IDs on its own. Userspace has ful=
l
>>> control on the IDs and can implement whatever constraint when assigni=
ng
>>> session IDs (even the DOCSIS DEPI way of partioning the session ID
>>> space).
>> Perhaps another example might help.
>>
>> Suppose there's an L2TPv3 app out there today that creates two tunnels=

>> to a peer, one of which is used as a hot-standby backup in case the ma=
in
>> tunnel fails. This system uses separate network interfaces for the
>> tunnels, e.g. a router using a mobile network as a backup. If the main=

>> tunnel fails, it switches traffic of sessions immediately into the
>> second tunnel. Userspace is deliberately using the same session IDs in=

>> both tunnels in this case. This would work today for IP-encap, but not=

>> for UDP. However, if the kernel treats session IDs as scoped by 3-tupl=
e,
>> the application would break. The app would need to be modified to add
>> each session ID into both tunnels to work again.
>>
> That's an interesting use case. I can imagine how this works on Rx, but=

> how can packets be transmitted on the new tunnel? The session will
> still send packets through the original tunnel with the original
> 3-tuple, and there's no way to reassign a session to a new tunnel. We
> could probably rebind/reconnect the tunnel socket, but then why
> creating the second tunnel in the kernel?

It might use some netfilter or BPF code to change the IPs and redirect
outbound packets. TBH, it's a hypothetical use case and probably easier
to implement using scoped session IDs. :-)


>>>>> I would have to read the RFC with scoped session IDs in mind, but, =
as
>>>>> far as I can see, the only things that global session IDs allow whi=
ch
>>>>> can't be done with scoped session IDs are:
>>>>>   * Accepting L2TPoIP sessions to receive L2TPoUDP packets and
>>>>>     vice-versa.
>>>>>   * Accepting L2TPv3 packets from peers we're not connected to.
>>>>>
>>>>> I don't find any of these to be desirable. Although Tom convinced m=
e
>>>>> that global session IDs are in the spirit of the RFC, I still don't=

>>>>> think that restricting their scope goes against it in any practical=

>>>>> way. The L2TPv3 control plane requires a two way communication, whi=
ch
>>>>> means that the session is bound to a given 3/5-tuple for control
>>>>> messages. Why would the data plane behave differently?
>>>> The Cable Labs / DOCSIS DEPI protocol is a good example. It is based=
 on
>>>> L2TPv3 and uses the L2TPv3 data plane. It treats the session ID as
>>>> unscoped and not associated with a given tunnel.
>>>>
>>> Fair enough. Then we could add a L2TP_ATTR_SCOPE netlink attribute to=

>>> sessions. A global scope would reject the session ID if another sessi=
on
>>> already exists with this ID in the same network namespace. Sessions w=
ith
>>> global scope would be looked up solely based on their ID. A non-globa=
l
>>> scope would allow a session ID to be duplicated as long as the 3/5-tu=
ple
>>> is different and no session uses this ID with global scope.
>>>
>>>>> I agree that it looks saner (and simpler) for a control plane to ne=
ver
>>>>> assign the same session ID to sessions running over different tunne=
ls,
>>>>> even if they have different 3/5-tuples. But that's the user space
>>>>> control plane implementation's responsability to select unique sess=
ion
>>>>> IDs in this case. The fact that the kernel uses scoped or global ID=
s is
>>>>> irrelevant. For unmanaged tunnels, the administrator has complete
>>>>> control over the local and remote session IDs and is free to assign=

>>>>> them globally if it wants to, even if the kernel would have accepte=
d
>>>>> reusing session IDs.
>>>> I disagree. Using scoped session IDs may break applications that ass=
ume
>>>> RFC behaviour. I mentioned one example where session IDs are used
>>>> unscoped above.
>>>>
>>> I'm sorry, but I still don't understand how could that break any
>>> existing application.
>> Does my example of the hot-standby backup tunnel help?
>>
> Yes, even though I'm not sure how it precisely translate in terms of
> userspace/kernel interraction. But anyway, with L2TP_ATTR_SCOPE, we'd
> have the possibility to keep session ID unscoped for l2tp_ip by
> default. That should be enough to keep any such scenario working
> without any modification.
>
>>> For L2TPoUDP, session IDs are always looked up in the context of the
>>> UDP socket. So even though the kernel has stopped accepting duplicate=

>>> IDs, the session IDs remain scoped in practice. And with the
>>> application being responsible for assigning IDs, I don't see how maki=
ng
>>> the kernel less restrictive could break any existing implementation.
>>> Again, userspace remains in full control for session ID assignment
>>> policy.
>>>
>>> Then we have L2TPoIP, which does the opposite, always looks up sessio=
ns
>>> globally and depends on session IDs being unique in the network
>>> namespace. But Ridge's patch does not change that. Also, by adding th=
e
>>> L2TP_ATTR_SCOPE attribute (as defined above), we could keep this
>>> behaviour (L2TPoIP session could have global scope by default).
>> I'm looking at this with an end goal of having the UDP rx path later
>> modified to work the same way as IP-encap currently does. I know Linux=

>> has never worked this way in the L2TPv3 UDP path and no-one has
>> requested that it does yet, but I think it would improve the
>> implementation if UDP and IP encap behaved similarly.
>>
> Yes, unifying UDP and IP encap would be really nice.
>
>> L2TP_ATTR_SCOPE would be a good way for the app to select which
>> behaviour it prefers.
>>
> Yes. But do we agree that it's also a way to keep the existing
> behaviour: unscoped for IP, scoped to the 5-tuple for UDP? That is, IP
> and UDP encap would use a different default value when user space
> doesn't request a specific behaviour.

Yes, that would be the safest approach.


>>>> However, there might be an alternative solution to fix this for Ridg=
e's
>>>> use case that doesn't involve adding 3/5-tuple session ID lookups in=
 the
>>>> receive path or adding a control knob...
>>>>
>>>> My understanding is that Ridge's application uses unmanaged tunnels
>>>> (like "ip l2tp" does). These use kernel sockets. The netlink tunnel
>>>> create request does not indicate a valid tunnel socket fd. So we cou=
ld
>>>> use scoped session IDs for unmanaged UDP tunnels only. If Ridge's pa=
tch
>>>> were tweaked to allow scoped IDs only for UDP unmanaged tunnels (add=
ing
>>>> a test for tunnel->fd < 0), managed tunnels would continue to work a=
s
>>>> they do now and any application that uses unmanaged tunnels would ge=
t
>>>> scoped session IDs. No control knob or 3/5-tuple session ID lookups
>>>> required.
>>>>
>>> Well, I'd prefer to not introduce another subtle behaviour change. Wh=
at
>>> does rejecting duplicate IDs bring us if the lookup is still done in
>>> the context of the socket? If the point is to have RFC compliance, th=
en
>>> we'd also need to modify the lookup functions.
>>>
>> I agree, it's not ideal. Rejecting duplicate IDs for UDP will allow th=
e
>> UDP rx path to be modified later to work the same way as IP. So my ide=
a
>> was to allow for that change to be made later but only for managed
>> tunnels (sockets created by userspace). My worry with the original pat=
ch
>> is that it suggests that session IDs for UDP are always scoped by the
>> tunnel so tweaking it to apply only for unmanaged tunnels was a way of=

>> showing this.
>>
>> However, you've convinced me now that scoping the session ID by
>> 3/5-tuple could work. As long as there's a mechanism that lets
>> applications choose whether the 3/5-tuple is ignored in the rx path, I=
'm
>> ok with it.
>>
> Do we agree that, with L2TP_ATTR_SCOPE being a long-term solution, we
> shouldn't need to reject duplicate session IDs for UDP tunnels?

Yes.


> To summarise my idea:
>
>   * Short term plan:
>     Integrate a variant of Ridge's patch, as it's simple, can easily be=

>     backported to -stable and doesn't prevent the future use of global
>     session IDs (as those will be specified with L2TP_ATTR_SCOPE).
>
>   * Long term plan:
>     Implement L2TP_ATTR_SCOPE, a session attribute defining if the
>     session ID is global or scoped to the X-tuple (3-tuple for IP,
>     5-tuple for UDP).
>     Original behaviour would be respected to avoid breaking existing
>     applications. So, by default, IP encapsulation would use global
>     scope and UDP encapsulation would use 5-tuple scope.
>
> Does that look like a good way forward?

Yes, it sounds good to me.

Your proposed approach of using only the session ID to do the session
lookup but then optionally using the 3/5-tuple to scope it resolves my
concerns.



