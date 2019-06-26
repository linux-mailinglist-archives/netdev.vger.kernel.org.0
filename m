Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4463256EFA
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 18:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbfFZQmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 12:42:11 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33483 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbfFZQmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 12:42:10 -0400
Received: by mail-pg1-f195.google.com with SMTP id m4so1487932pgk.0;
        Wed, 26 Jun 2019 09:42:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fF9czJULMxLTbfxNvlrqNjkKfIUZaiTFHPKKs5V16I8=;
        b=ej1uX36ej8YPX/dGcgpVF/4FCixCrzN6x7heZ46MiCM3O/eggAdTPqNQRJ7p8BfdDH
         VFUkRrC7nclH1wOsU/BBN66RM2yAROimByBG07t7wr7IjmfMs66+pOPDNo68cS3d7FUA
         /SdsZGtPPxIy+b/A2rseZ+3WQ960wrgO6K2zcA74RwEBQ2gJUALNEZlw6NAjA1WDYLU7
         TxV9mxm26CFtiSWVxLki+0SeYKPuXqnFANGPy1msWDtNqoHmGr3Chfey8ID2FGl+f1wn
         o4I2Ly/efEbCBJOAY1i5EapkBLLybjaRI5DubuiS1aw1tm1WBNX3IzmamhiUYRGEKUZi
         gwtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fF9czJULMxLTbfxNvlrqNjkKfIUZaiTFHPKKs5V16I8=;
        b=flYDVKlO0OMPbYlDSVZ6Gv52S49IXhEXHuisK/69jvzUOBZdu27Hslr62DXWYYbPKM
         AQne9CxVDQ4b/R9QZz06BGpHgwyk61yfozXveO36Fa6objwBcBdOJOJImmwXSQnJ9qh4
         92LkJNurSbWGfa7r3aAqb54J0xFH0TF6VsjVqshxroqCz4g6vnFr6t5rktQGbPMtu/3+
         whbRXLfJb6GAKhOcIt56ogndcwxgxpAI17SpUcpHjD4x42ofSKvrEdpPmbl2ug84P1be
         c1/PVD+Ints3QgU8RI3LFSGVdZrEZra9UyJZ9J9SgVQCtMU1u9wkfZ6yppZ6XhVAqJSc
         E+jg==
X-Gm-Message-State: APjAAAUyBhKS26gK61SFBIug5qKWTY8bN6qTElHFq9axgK20LqV4q2rq
        +Nvi50ffKJlIbnpUTK5FETc=
X-Google-Smtp-Source: APXvYqz3iNGpcp441LrG9Az8HN+tFFM03b6vgbvp0lg8PhQytUym/yufh8rr6hJfFdRz256XLvq0Qw==
X-Received: by 2002:a65:5a4a:: with SMTP id z10mr3841763pgs.250.1561567329748;
        Wed, 26 Jun 2019 09:42:09 -0700 (PDT)
Received: from [172.26.110.73] ([2620:10d:c090:180::1:e729])
        by smtp.gmail.com with ESMTPSA id j23sm19824443pff.90.2019.06.26.09.42.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 09:42:08 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Willem de Bruijn" <willemdebruijn.kernel@gmail.com>
Cc:     "Toke =?utf-8?b?SMO4aWxhbmQtSsO4cmdlbnNlbg==?=" <toke@redhat.com>,
        "Jesper Dangaard Brouer" <brouer@redhat.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Jubran, Samih" <sameehj@amazon.com>, davem@davemloft.net,
        netdev@vger.kernel.org, "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Daniel Borkmann" <borkmann@iogearbox.net>,
        "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
        "Alexei Starovoitov" <alexei.starovoitov@gmail.com>,
        "Jakub Kicinski" <jakub.kicinski@netronome.com>,
        xdp-newbies@vger.kernel.org
Subject: Re: XDP multi-buffer incl. jumbo-frames (Was: [RFC V1 net-next 1/1]
 net: ena: implement XDP drop support)
Date:   Wed, 26 Jun 2019 09:42:07 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <99AFC1EE-E27E-4D4D-B9B8-CA2215E68E1B@gmail.com>
In-Reply-To: <CA+FuTSfKnhv9rr=cDa_4m7Dd9qkEm_oabDfyvH0T0sM+fQTU=w@mail.gmail.com>
References: <20190623070649.18447-1-sameehj@amazon.com>
 <20190623070649.18447-2-sameehj@amazon.com> <20190623162133.6b7f24e1@carbon>
 <A658E65E-93D2-4F10-823D-CC25B081C1B7@amazon.com>
 <20190626103829.5360ef2d@carbon> <87a7e4d0nj.fsf@toke.dk>
 <20190626164059.4a9511cf@carbon> <87h88cbdbe.fsf@toke.dk>
 <CA+FuTSfKnhv9rr=cDa_4m7Dd9qkEm_oabDfyvH0T0sM+fQTU=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 26 Jun 2019, at 8:20, Willem de Bruijn wrote:

> On Wed, Jun 26, 2019 at 11:01 AM Toke H=C3=B8iland-J=C3=B8rgensen =

> <toke@redhat.com> wrote:
>>
>> Jesper Dangaard Brouer <brouer@redhat.com> writes:
>>
>>> On Wed, 26 Jun 2019 13:52:16 +0200
>>> Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:
>>>
>>>> Jesper Dangaard Brouer <brouer@redhat.com> writes:
>>>>
>>>>> On Tue, 25 Jun 2019 03:19:22 +0000
>>>>> "Machulsky, Zorik" <zorik@amazon.com> wrote:
>>>>>
>>>>>> =EF=BB=BFOn 6/23/19, 7:21 AM, "Jesper Dangaard Brouer" =

>>>>>> <brouer@redhat.com> wrote:
>>>>>>
>>>>>>     On Sun, 23 Jun 2019 10:06:49 +0300 <sameehj@amazon.com> =

>>>>>> wrote:
>>>>>>
>>>>>>     > This commit implements the basic functionality of drop/pass =

>>>>>> logic in the
>>>>>>     > ena driver.
>>>>>>
>>>>>>     Usually we require a driver to implement all the XDP return =

>>>>>> codes,
>>>>>>     before we accept it.  But as Daniel and I discussed with =

>>>>>> Zorik during
>>>>>>     NetConf[1], we are going to make an exception and accept the =

>>>>>> driver
>>>>>>     if you also implement XDP_TX.
>>>>>>
>>>>>>     As we trust that Zorik/Amazon will follow and implement =

>>>>>> XDP_REDIRECT
>>>>>>     later, given he/you wants AF_XDP support which requires =

>>>>>> XDP_REDIRECT.
>>>>>>
>>>>>> Jesper, thanks for your comments and very helpful discussion =

>>>>>> during
>>>>>> NetConf! That's the plan, as we agreed. From our side I would =

>>>>>> like to
>>>>>> reiterate again the importance of multi-buffer support by xdp =

>>>>>> frame.
>>>>>> We would really prefer not to see our MTU shrinking because of =

>>>>>> xdp
>>>>>> support.
>>>>>
>>>>> Okay we really need to make a serious attempt to find a way to =

>>>>> support
>>>>> multi-buffer packets with XDP. With the important criteria of not
>>>>> hurting performance of the single-buffer per packet design.
>>>>>
>>>>> I've created a design document[2], that I will update based on our
>>>>> discussions: [2] =

>>>>> https://github.com/xdp-project/xdp-project/blob/master/areas/core/x=
dp-multi-buffer01-design.org
>>>>>
>>>>> The use-case that really convinced me was Eric's packet =

>>>>> header-split.
>
> Thanks for starting this discussion Jesper!
>
>>>>>
>>>>>
>>>>> Lets refresh: Why XDP don't have multi-buffer support:
>>>>>
>>>>> XDP is designed for maximum performance, which is why certain =

>>>>> driver-level
>>>>> use-cases were not supported, like multi-buffer packets (like =

>>>>> jumbo-frames).
>>>>> As it e.g. complicated the driver RX-loop and memory model =

>>>>> handling.
>>>>>
>>>>> The single buffer per packet design, is also tied into eBPF =

>>>>> Direct-Access
>>>>> (DA) to packet data, which can only be allowed if the packet =

>>>>> memory is in
>>>>> contiguous memory.  This DA feature is essential for XDP =

>>>>> performance.
>>>>>
>>>>>
>>>>> One way forward is to define that XDP only get access to the first
>>>>> packet buffer, and it cannot see subsequent buffers. For XDP_TX =

>>>>> and
>>>>> XDP_REDIRECT to work then XDP still need to carry pointers (plus
>>>>> len+offset) to the other buffers, which is 16 bytes per extra =

>>>>> buffer.
>>>>
>>>> Yeah, I think this would be reasonable. As long as we can have a
>>>> metadata field with the full length + still give XDP programs the
>>>> ability to truncate the packet (i.e., discard the subsequent pages)
>>>
>>> You touch upon some interesting complications already:
>>>
>>> 1. It is valuable for XDP bpf_prog to know "full" length?
>>>    (if so, then we need to extend xdp ctx with info)
>>
>> Valuable, quite likely. A hard requirement, probably not (for all use
>> cases).
>
> Agreed.
>
> One common validation use would be to drop any packets whose header
> length disagrees with the actual packet length.
>
>>>  But if we need to know the full length, when the first-buffer is
>>>  processed. Then realize that this affect the drivers RX-loop, =

>>> because
>>>  then we need to "collect" all the buffers before we can know the
>>>  length (although some HW provide this in first descriptor).
>>>
>>>  We likely have to change drivers RX-loop anyhow, as XDP_TX and
>>>  XDP_REDIRECT will also need to "collect" all buffers before the =

>>> packet
>>>  can be forwarded. (Although this could potentially happen later in
>>>  driver loop when it meet/find the End-Of-Packet descriptor bit).
>
> Yes, this might be quite a bit of refactoring of device driver code.
>
> Should we move forward with some initial constraints, e.g., no
> XDP_REDIRECT, no "full" length and no bpf_xdp_adjust_tail?
>
> That already allows many useful programs.
>
> As long as we don't arrive at a design that cannot be extended with
> those features later.

I think collecting all frames until EOP and then processing them
at once sounds reasonable.



>>> 2. Can we even allow helper bpf_xdp_adjust_tail() ?
>>>
>>>  Wouldn't it be easier to disallow a BPF-prog with this helper, when
>>>  driver have configured multi-buffer?
>>
>> Easier, certainly. But then it's even easier to not implement this at
>> all ;)
>>
>>>  Or will it be too restrictive, if jumbo-frame is very uncommon and
>>>  only enabled because switch infra could not be changed (like Amazon
>>>  case).
>
> Header-split, LRO and jumbo frame are certainly not limited to the =

> Amazon case.
>
>> I think it would be preferable to support it; but maybe we can let =

>> that
>> depend on how difficult it actually turns out to be to allow it?
>>
>>>  Perhaps it is better to let bpf_xdp_adjust_tail() fail runtime?
>>
>> If we do disallow it, I think I'd lean towards failing the call at
>> runtime...
>
> Disagree. I'd rather have a program fail at load if it depends on
> multi-frag support while the (driver) implementation does not yet
> support it.

If all packets are collected together (like the bulk queue does), and =

then
passed to XDP, this could easily be made backwards compatible.  If the =

XDP
program isn't 'multi-frag' aware, then each packet is just passed in =

individually.

Of course, passing in the equivalent of a iovec requires some form of =

loop
support on the BPF side, doesn't it?
-- =

Jonathan

