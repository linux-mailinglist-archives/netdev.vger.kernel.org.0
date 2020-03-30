Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7212197CB7
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 15:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730356AbgC3NS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 09:18:59 -0400
Received: from mail-vk1-f194.google.com ([209.85.221.194]:45536 "EHLO
        mail-vk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730166AbgC3NS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 09:18:59 -0400
Received: by mail-vk1-f194.google.com with SMTP id b187so4631540vkh.12
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 06:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XwZpLeLtaipuZp19cuI2yuUic0Ig6FMuaAiCXHLwbS0=;
        b=Y8uGNkbJRMeI5Q5ciI0E70h+TD8j78aOmh3jT0o6oN/G54unchhocb4VFV1n1aUzq+
         gjQiFCAo35K+fRVXcYKrELxcxzdD3WyeNQPRcI5m+YZ1UcyDutmN6LzowbhvK8GnJCmr
         8fbqTG816AyZUAWkSNb21l3f+VHBWbc4Qt3HzrvTVFvaEkkTeNsJ2wFp4tu9q7G28jqM
         Fvf6Uhws4PpbtbA73JeWUVjqAzQzEjxtxprncMBFs2MKsj2Gp25/IMUpmOWhLKe7mo4R
         gxHriaBUKgO8AKyJFP+IwHhPKU9L3a16aZZfXxfoYf6DQiFYlUCx36UGXSQyL9a9FC1T
         ziAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XwZpLeLtaipuZp19cuI2yuUic0Ig6FMuaAiCXHLwbS0=;
        b=EcZISstummtX1KSDx9iZas2Ckbx8f/ufhDboc1p795KPp4M/gljoJqAfqiVVfM8AW+
         f0o0I7nYYEfIv5QRd93WOq/qnygQ+WG5FumEn4YHDQsENwVlv20K/ePNybLOjsViFxts
         tWwjpygLRgokXHUol0hviXMm3OYx1FFOlYbZ5/Kdq90IXCy2h1CZvCw0OISFifiOU9uw
         eHeKaEl6RpLp98u8wSTVonvTYqlcMVyLXqBVt5H4aqikmIHzuG7LtKZ1oo5n/3oVqw+5
         TGzS/+xNHS4JvNP2p1PSWqFLw0yF6+EojJEZ9T9h84e1Ua2c85im124sdAYf5Wzww99g
         kYXQ==
X-Gm-Message-State: AGi0PuYyOU3pwV9SNcTnfej9iQJWpM/Rc++7UkKOXeAPj3a14M8pNSaH
        rN7Vif/4G2ti58QVLwUaVpiv2qACy3rouvPd+3Pl6g==
X-Google-Smtp-Source: APiQypLMFSV+imrA+mJ1GR2URlkGhGdGfIKo4yEEuan55vG0q/lADU1cisCdWcaqvU2Tbk+eKniDKKJc1xx2bJXLHPk=
X-Received: by 2002:a1f:5003:: with SMTP id e3mr7430294vkb.59.1585574337389;
 Mon, 30 Mar 2020 06:18:57 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab0:6507:0:0:0:0:0 with HTTP; Mon, 30 Mar 2020 06:18:56
 -0700 (PDT)
X-Originating-IP: [5.35.40.234]
In-Reply-To: <e8ecb2ff-6241-e79d-047d-19013e480832@suse.com>
References: <1584364176-23346-1-git-send-email-kda@linux-powerpc.org>
 <f75365c7-a3ca-cf12-b2fc-e48652071795@suse.com> <CAOJe8K3gDJrdKz9zVZNj=N76GygMnPbCKM0-kVfoV53fASAefg@mail.gmail.com>
 <250783b3-4949-d00a-70e2-dbef1791a6c4@suse.com> <CAOJe8K0fBBi-M+Tdv2kC+ZaNvjx92tzYaU1QX2zr8QOBRLwu3g@mail.gmail.com>
 <9eb74bee-8434-62aa-8158-bae130353670@suse.com> <CAOJe8K34OS9vq9jWjVE9nrzvF+kdZnyAfGSS5tnJG-obDRwjSg@mail.gmail.com>
 <d29338f2-62ef-e33c-a3d8-a9a9d2e3bf63@suse.com> <CAOJe8K3+ddELP=nac+WRB1d5ccsDQu2UBVY4T2GiFFUfhk0jcQ@mail.gmail.com>
 <fdac742b-71ae-6945-ccc8-6af5b75446e1@suse.com> <CAOJe8K2X39rEN+Rjvoc3_TYfKwf0h117U=-pbRPAcKZvMPWTmA@mail.gmail.com>
 <e8ecb2ff-6241-e79d-047d-19013e480832@suse.com>
From:   Denis Kirjanov <kda@linux-powerpc.org>
Date:   Mon, 30 Mar 2020 16:18:56 +0300
Message-ID: <CAOJe8K3toNrq_LZNpw9x8-ABEjYE3x9k03j7Z6A6Xuwgv7BLiQ@mail.gmail.com>
Subject: Re: [PATCH net-next v4] xen networking: add basic XDP support for xen-netfront
To:     =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Cc:     netdev@vger.kernel.org, ilias.apalodimas@linaro.org,
        wei.liu@kernel.org, paul@xen.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/30/20, J=C3=BCrgen Gro=C3=9F <jgross@suse.com> wrote:
> On 30.03.20 15:09, Denis Kirjanov wrote:
>> On 3/30/20, J=C3=BCrgen Gro=C3=9F <jgross@suse.com> wrote:
>>> On 30.03.20 14:16, Denis Kirjanov wrote:
>>>> On 3/23/20, J=C3=BCrgen Gro=C3=9F <jgross@suse.com> wrote:
>>>>> On 23.03.20 11:49, Denis Kirjanov wrote:
>>>>>> On 3/23/20, J=C3=BCrgen Gro=C3=9F <jgross@suse.com> wrote:
>>>>>>> On 23.03.20 11:15, Denis Kirjanov wrote:
>>>>>>>> On 3/18/20, J=C3=BCrgen Gro=C3=9F <jgross@suse.com> wrote:
>>>>>>>>> On 18.03.20 13:50, Denis Kirjanov wrote:
>>>>>>>>>> On 3/18/20, J=C3=BCrgen Gro=C3=9F <jgross@suse.com> wrote:
>>>>>>>>>>> On 16.03.20 14:09, Denis Kirjanov wrote:
>>>>>>>>>>>> The patch adds a basic XDP processing to xen-netfront driver.
>>>>>>>>>>>>
>>>>>>>>>>>> We ran an XDP program for an RX response received from netback
>>>>>>>>>>>> driver. Also we request xen-netback to adjust data offset for
>>>>>>>>>>>> bpf_xdp_adjust_head() header space for custom headers.
>>>>>>>>>>>
>>>>>>>>>>> This is in no way a "verbose patch descriprion".
>>>>>>>>>>>
>>>>>>>>>>> I'm missing:
>>>>>>>>>>>
>>>>>>>>>>> - Why are you doing this. "Add XDP support" is not enough, for
>>>>>>>>>>> such
>>>>>>>>>>>         a change I'd like to see some performance numbers to ge=
t
>>>>>>>>>>> an
>>>>>>>>>>> idea
>>>>>>>>>>>         of the improvement to expect, or which additional
>>>>>>>>>>> functionality
>>>>>>>>>>>         for the user is available.
>>>>>>>>>> Ok, I'll try to measure  some numbers.
>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>> - A short description for me as a Xen maintainer with only basi=
c
>>>>>>>>>>>         networking know-how, what XDP programs are about (a lin=
k
>>>>>>>>>>> to
>>>>>>>>>>> some
>>>>>>>>>>>         more detailed doc is enough, of course) and how the
>>>>>>>>>>> interface
>>>>>>>>>>>         is working (especially for switching between XDP mode
>>>>>>>>>>> and
>>>>>>>>>>> normal
>>>>>>>>>>>         SKB processing).
>>>>>>>>>>
>>>>>>>>>> You can search for the "A practical introduction to XDP"
>>>>>>>>>> tutorial.
>>>>>>>>>> Actually there is a lot of information available regarding XDP,
>>>>>>>>>> you
>>>>>>>>>> can easily find it.
>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>> - A proper description of the netfront/netback communication
>>>>>>>>>>> when
>>>>>>>>>>>         enabling or disabling XDP mode (who is doing what, is
>>>>>>>>>>> silencing
>>>>>>>>>>>         of the virtual adapter required, ...).
>>>>>>>>>> Currently we need only a header offset from netback driver so
>>>>>>>>>> that
>>>>>>>>>> we
>>>>>>>>>> can
>>>>>>>>>> put
>>>>>>>>>> custom encapsulation header if required and that's done using xe=
n
>>>>>>>>>> bus
>>>>>>>>>> state switching,
>>>>>>>>>> so that:
>>>>>>>>>> - netback tells that it can adjust the header offset
>>>>>>>>>> - netfront part reads it
>>>>>>>>>
>>>>>>>>> Yes, but how is this synchronized with currently running network
>>>>>>>>> load?
>>>>>>>>> Assume you are starting without XDP being active and then you are
>>>>>>>>> activating it. How is the synchronization done from which request
>>>>>>>>> on
>>>>>>>>> the XDP headroom is available?
>>>>>>>>
>>>>>>>> Hi Jurgen,
>>>>>>>>
>>>>>>>> basically XDP is activated when you've assigned an xdp program to
>>>>>>>> the
>>>>>>>> networking device.
>>>>>>>> Assigning an xdp program means that we have to adjust a pointer
>>>>>>>> which
>>>>>>>> is RCU protected.
>>>>>>>
>>>>>>> This doesn't answer my question.
>>>>>>>
>>>>>>> You have basically two communication channels: the state of the
>>>>>>> frontend
>>>>>>> and backend for activation/deactivation of XDP, and the ring pages
>>>>>>> with
>>>>>>> the rx and tx requests and responses. How is the synchronization
>>>>>>> between
>>>>>>> those two channels done? So how does the other side know which of
>>>>>>> the
>>>>>>> packets in flight will then have XDP on or off?
>>>>>>
>>>>>> Right,
>>>>>> that's done in xen-netback using xenbus state:
>>>>>> - in xennet_xdp_set() we call xenbus_switch_state to tell xen-netbac=
k
>>>>>> to
>>>>>> adjust offset for an RX response.
>>>>>> -xen-netback reads the value from xenstore and adjusts the offset fo=
r
>>>>>> xen-netback
>>>>>> in xenvif_rx_data_slot() using vif->xdp_enabled flag.
>>>>>
>>>>> And before that all in-flight requests in the ring pages are being
>>>>> processed and no new requests are guaranteed to be enqueued?
>>>>
>>>> Actually I don't see the need to sync these requests since that all we
>>>> have to do is to copy
>>>> data with specified offset:
>>>> with xdp->enabled=3D1: copy with the offset XDP_PACKET_HEADROOM
>>>> with xdd->enabled=3D0: copy without the offset
>>>
>>> Isn't that racy?
>>>
>>> In xennet_xdp_set() you set queue->xdp_prog and then you change the
>>> state to Reconfiguring. From the time queue->xdp_prog is set you'll
>>> do the Xdp processing in xennet_get_responses(), even if the response
>>> you are working on doesn't have the headroom you need, as the backend
>>> didn't create it with headroom (it needs some time until it has seen
>>> the new state and could react on it by sending _new_ responses with
>>> headroom).
>>
>> Ah, I see. You mean that we have to wait until XenbusStateReconfigured
>> is set in
>> xen-netfront and only after that it's safe to process packets.
>
> Right. That is the problem of using a different communication channel
> for enabling/disabling XDP.

Ok, I'll update my patch.

Thanks for review!

>
>
> Juergen
>
