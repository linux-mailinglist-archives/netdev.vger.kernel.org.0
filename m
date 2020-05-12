Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66FDB1CF592
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 15:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729700AbgELNVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 09:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729336AbgELNVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 09:21:48 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73D1CC061A0C
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 06:21:48 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id d16so11057092edq.7
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 06:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Bls6QyucqKx9N25KNTJnUYOUsXzu0L4ZPVXbHH9hWeg=;
        b=zraIEWMT+uEhqa+ML+ZV0gGcD0azPgYTymN2WONwa9VZDoETQOgFXnS55itILO/FMn
         FHt+3WorY8I9GwTk7L7PU1xqH6N7iX9RpOmaxBPSkculxA6c1SEPt80A/RgSeb5WSGmC
         NjC1M3ZAKNPckPpQp5BZLZ4HCwCPYdY1fGofXMdGArzGXxktOzMo/+l4k/swGFvQlvdF
         Slwn3ZbUhmZIY/7ycnj2tDPXPsICnGD+iD8ViD8NaDOjEf65SSDt5RWI9PXmPcX9slM2
         gkRbhCdypyt3df+5IEIMl7M9Iy3CVPiehPJeZdrG+PLyDjbO0Eo0Hcvrk4EtIV2zNr+W
         RXFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Bls6QyucqKx9N25KNTJnUYOUsXzu0L4ZPVXbHH9hWeg=;
        b=nXAgObUkJrhYjlsVNsey+XEhsVX1ySEjNSbhbFpNgut9//eBs4CmJhdd9qrT3mboCx
         xpXEpeJECIxb3bgmJM8W4M1avzghLeUg+zkWZBYZzmzTLGDt8zjPFyNAhW8vkRmfQVnh
         X0FvhYL9z0reg3KCR3qT8J5fhaHVdXCUvAiRBuaJKVE/vmU9fSpVweeIhA8R4L2Gld8z
         1ky3DLYxYnFsGfdP4wtHNlFB5vEwRHzdu5zjngW5NqtBNzZwM+haa7CSMiVV2HQc9y7Q
         cHiIzJ83KeSW1FbpGC+tTgEdNWmtduWDK4IClaHSwkz4f9Y23Z4Nwfbk2aMs3QwlOjmp
         G48Q==
X-Gm-Message-State: AGi0PuZF5dg9bJam5neWiXb5wCDAE8CA4QavQTCDZgoJNen+tgDqaHKS
        2MCU8ldh/Jf5cq8l0ozY7EIHpHj/r0TdQzInePaCqg==
X-Google-Smtp-Source: APiQypKPwVfHOl0sWCJH2vFW+axQ5kWP1JQjys6dXu3V5vruJilfN1WQa+DLoiV/Mlh8cCpIcpV+tEf2ujfVl19iovw=
X-Received: by 2002:aa7:c492:: with SMTP id m18mr17643285edq.346.1589289706982;
 Tue, 12 May 2020 06:21:46 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a50:7497:0:0:0:0:0 with HTTP; Tue, 12 May 2020 06:21:46
 -0700 (PDT)
X-Originating-IP: [5.35.46.227]
In-Reply-To: <eb54bbfb-a97d-7cd8-e354-8828b74548fc@suse.com>
References: <1589192541-11686-1-git-send-email-kda@linux-powerpc.org>
 <1589192541-11686-2-git-send-email-kda@linux-powerpc.org> <649c940c-200b-f644-8932-7d54ac21a98b@suse.com>
 <CAOJe8K29vn6TK8t7g7j387F41ig-9yY-jT-k=mVpDQW3xmDPSg@mail.gmail.com>
 <62f29aba-93d5-9a7d-a4ac-7fae1ac46f22@suse.com> <CAOJe8K3mQuf_wj6rZ-hSHixosBsdvHZkgZRYHRGJjqaXHNoPxw@mail.gmail.com>
 <eb54bbfb-a97d-7cd8-e354-8828b74548fc@suse.com>
From:   Denis Kirjanov <kda@linux-powerpc.org>
Date:   Tue, 12 May 2020 16:21:46 +0300
Message-ID: <CAOJe8K3EHevDJ+3P59=F6AU7dVBvubR4-yUbeLGQ1WbFK5icZg@mail.gmail.com>
Subject: Re: [PATCH net-next v9 1/2] xen networking: add basic XDP support for xen-netfront
To:     =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Cc:     paul@xen.org, netdev@vger.kernel.org, brouer@redhat.com,
        wei.liu@kernel.org, ilias.apalodimas@linaro.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/12/20, J=C3=BCrgen Gro=C3=9F <jgross@suse.com> wrote:
> On 12.05.20 14:27, Denis Kirjanov wrote:
>> On 5/12/20, J=C3=BCrgen Gro=C3=9F <jgross@suse.com> wrote:
>>> On 11.05.20 19:27, Denis Kirjanov wrote:
>>>> On 5/11/20, J=C3=BCrgen Gro=C3=9F <jgross@suse.com> wrote:
>>>>> On 11.05.20 12:22, Denis Kirjanov wrote:
>>>>>> The patch adds a basic XDP processing to xen-netfront driver.
>>>>>>
>>>>>> We ran an XDP program for an RX response received from netback
>>>>>> driver. Also we request xen-netback to adjust data offset for
>>>>>> bpf_xdp_adjust_head() header space for custom headers.
>>>>>>
>>>>>> synchronization between frontend and backend parts is done
>>>>>> by using xenbus state switching:
>>>>>> Reconfiguring -> Reconfigured- > Connected
>>>>>>
>>>>>> UDP packets drop rate using xdp program is around 310 kpps
>>>>>> using ./pktgen_sample04_many_flows.sh and 160 kpps without the patch=
.
>>>>>
>>>>> I'm still not seeing proper synchronization between frontend and
>>>>> backend when an XDP program is activated.
>>>>>
>>>>> Consider the following:
>>>>>
>>>>> 1. XDP program is not active, so RX responses have no XDP headroom
>>>>> 2. netback has pushed one (or more) RX responses to the ring page
>>>>> 3. XDP program is being activated -> Reconfiguring
>>>>> 4. netback acknowledges, will add XDP headroom for following RX
>>>>>       responses
>>>>> 5. netfront reads RX response (2.) without XDP headroom from ring pag=
e
>>>>> 6. boom!
>>>>
>>>> One thing that could be easily done is to set the offset on
>>>> xen-netback
>>>> side
>>>> in  xenvif_rx_data_slot().  Are you okay with that?
>>>
>>> How does this help in above case?
>>>
>>> I think you haven't understood the problem I'm seeing.
>>>
>>> There can be many RX responses in the ring page which haven't been
>>> consumed by the frontend yet. You are doing the switch to XDP via a
>>> different communication channel (Xenstore), so you need some way to
>>> synchronize both communication channels.
>>>
>>> Either you make sure you have read all RX responses before doing the
>>> switch (this requires stopping netback to push out more RX responses),
>>> or you need to have a flag in the RX responses indicating whether XDP
>>> headroom is provided or not (requires an addition to the Xen netif
>>> protocol).
>> Hi J=C3=BCrgen,
>>
>> I see your point that we can have a shared ring with mixed RX responses
>> offset.
>> Since the offset field is set always  to 0 on netback side we can
>> adjust it and thus mark that a response has the offset adjusted or
>> it's not (if the offset filed is set to 0).
>
> For one I don't see your code in netfront to test this condition.

Right, it's not in the current version.

>
> And I don't think this is a guaranteed interface. Have you checked all
> netback versions in older kernels, in qemu, and in BSD?
>
> BTW, I'm pretty sure the old xen-linux netback sometimes used an offset
> not being 0. And yes, those kernels are still active in some cases (e.g.
> SLES11-SP4 is still supported for customers having a long time service
> agreement and this version is based on xen-linux).

I see, good to know.
I think that I can add a new flag like XEN_NETRXF_xdp_headroom in this case

>>
>> In this case we have to run an xdp program on netfront side only for a
>> response with offset set to xdp headroom.
>>
>> I don't see a race in the scenario above.
>
> I do.
>
>
> Juergen
>
>>
>> Or I'm completely wrong and this can not happen due to the
>>> way XDP programs work, but you didn't provide any clear statement this
>>> being the case.
>>>
>>>
>>> Juergen
>>>
>
>
