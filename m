Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB82276051
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 20:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgIWSqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 14:46:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726720AbgIWSqF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 14:46:05 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E689C0613CE;
        Wed, 23 Sep 2020 11:46:04 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id u126so861060oif.13;
        Wed, 23 Sep 2020 11:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Qeu6diIvIGDQEtJHRT7NOmhkxnH5ZSau7zHTeoPUrmE=;
        b=TfVuiEs8CMG4jbaIJSsYs0qvkPFH2Piqa82M3zA7oS/BhFDKP9AvfgVQ0CfVVsmOY/
         /rnOKzHo1kVjc1AKpBhpMe2WLy4kzs1ejL6nK+4Afw9x3P18DEUdWpasBDYVY9tFrdE9
         Y03JOhjbdxUp4ekyBzzFW7JRAYML+74EMmV80kekfYrc3rfwkEAyUbOEM5O91Fe+y5ro
         8yYjkR/olyVrHQ7wFomP31xvkjKVR6INX1cWLMORbH+oBSbP5ojRtDHSLU37N3pcflJ+
         eKB5ODvgz1ch3WnuTqkn+4Nc4CRnLzwYZ2TRceZB56JHLroJctJF8qm7cAua3wRMOu3P
         H49w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Qeu6diIvIGDQEtJHRT7NOmhkxnH5ZSau7zHTeoPUrmE=;
        b=AXMznvHgn1BFzYEoEMmoIESysE5NPqzMP94fIggq8szJPX+rbIEg6Q7mMXzB/zWzK3
         TFmiFGLDgilkOcl1mWVY/v1JHSt3aH6nvfMYxdfS9bro49G6V7HFhn69AcFJtm7d223B
         N3Tq/wVHaODO7phnX0GHj5H08ITBX561wj9AFVHxR0YdmmPUMLOCKAuVOj7XqzYiitUj
         6vJ2ZwdweugCkPitlEk7qsqg4BcLx8Ywur1c8kkG5EdBEn/H8qY38O79z2SJ/IncnGkN
         qkX2dsJzbx5/+dtCi0/JKeqXyo/lIyY2qmgZKGMfLlHoaUzJ5wAOk/deBJWAu5wMUQ7h
         TIQg==
X-Gm-Message-State: AOAM53241JScHgzp+sLiWAuVROZbXoQSghz+Aju2LD6HK+WDFko6IBRq
        Mtpcgt3dndslapmDfEAZ3Al7VaNGTFifWw==
X-Google-Smtp-Source: ABdhPJzbkkC1hWeuXeuFYozqqiBH9Ss5TMRiTXN4dEHuXZOzXaDifiJwL0OZgmT8lPs7DFxZwNfEiQ==
X-Received: by 2002:aca:8cb:: with SMTP id 194mr472350oii.37.1600886763650;
        Wed, 23 Sep 2020 11:46:03 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:79d5:cf3d:ad8a:c85b])
        by smtp.googlemail.com with ESMTPSA id d17sm197681oth.73.2020.09.23.11.46.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2020 11:46:02 -0700 (PDT)
Subject: Re: [RFC PATCH v2 0/3] l3mdev icmp error route lookup fixes
To:     Michael Jeanson <mjeanson@efficios.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     David <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20200918181801.2571-1-mathieu.desnoyers@efficios.com>
 <390b230b-629b-7f96-e7c9-b28f8b592102@gmail.com>
 <1453768496.36855.1600713879236.JavaMail.zimbra@efficios.com>
 <dd1caf15-2ef0-f557-b9a8-26c46739f20b@gmail.com>
 <1383129694.37216.1600716821449.JavaMail.zimbra@efficios.com>
 <1135414696.37989.1600782730509.JavaMail.zimbra@efficios.com>
 <4456259a-979a-7821-ef3d-aed5d330ed2b@gmail.com>
 <730d8a09-7d3b-1033-4131-520dc42e8855@efficios.com>
 <47175ae8-e7e8-473c-5103-90bf444db16c@efficios.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <cfdc41d9-cca1-7166-1a2e-778ac4bf8b73@gmail.com>
Date:   Wed, 23 Sep 2020 12:46:01 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <47175ae8-e7e8-473c-5103-90bf444db16c@efficios.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/23/20 11:03 AM, Michael Jeanson wrote:
> On 2020-09-23 12 h 04, Michael Jeanson wrote:
>>> It should work without asymmetric routing; adding the return route to
>>> the second vrf as I mentioned above fixes the FRAG_NEEDED problem. It
>>> should work for TTL as well.
>>>
>>> Adding a second pass on the tests with the return through r2 is fine,
>>> but add a first pass for the more typical case.
>>
>> Hi,
>>
>> Before writing new tests I just want to make sure we are trying to fix
>> the same issue. If I add a return route to the red VRF then we don't
>> need this patchset because whether the ICMP error are routed using the
>> table from the source or destination interface they will reach the
>> source host.
>>
>> The issue for which this patchset was sent only happens when the
>> destination interface's VRF doesn't have a route back to the source
>> host. I guess we might question if this is actually a bug or not.
>>
>> So the question really is, when a packet is forwarded between VRFs
>> through route leaking and an icmp error is generated, which table
>> should be used for the route lookup? And does it depend on the type of
>> icmp error? (e.g. TTL=1 happens before forwarding, but fragmentation
>> needed happens after when on the destination interface)
> 
> As a side note, I don't mind reworking the tests as you requested even
> if the patchset as a whole ends up not being needed and if you think
> they are still useful. I just wanted to make sure we understood each other.
> 

if you are leaking from VRF 1 to VRF 2 and you do not configure VRF 2
with how to send to errors back to source - MTU or TTL - then I will
argue that is a configuration problem, not a bug.

Now the TTL problem is interesting. You need the FIB lookup to know that
the packet is forwarded, and by the time of the ttl check in ip_forward
skb->dev points to the ingress VRF and dst points to the egress VRF. So
I think the change is warranted.

Let's do this for the tests:
1 pass through all of the tests (TTL and MTU, v4 and v6) with symmetric
routing configured and make sure they all pass. ie., keep all of them
and make sure all tests pass. No sense losing the tests and the thoughts
behind them.

Add a second pass with the asymmetric routing per the customer setup
since it motivated the investigation.

Rename the test to something like vrf_route_leaking.sh. It can be
expanded with more tests related to route leaking as they come up.
