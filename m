Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 531FB18F322
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 11:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728075AbgCWKtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 06:49:21 -0400
Received: from mail-vs1-f67.google.com ([209.85.217.67]:39418 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727874AbgCWKtV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 06:49:21 -0400
Received: by mail-vs1-f67.google.com with SMTP id j128so1826566vsd.6
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 03:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZJqkjkJQd/k/G40mgrkDoQOdH4St7HF1IpqHBDocRBc=;
        b=1aivrEBupZ4lxfOihZytZ8Zcaisvj/fKYYdLn3q0+CSYFKzftkAQnpeScsv9e9so6B
         HAeooTzEFUvgwaRSPoQuk1SmZx9EIQE1iymgzcbIyBgt1+u/tVdOgHvKGS301vzd2vxM
         RIgL5N47rfk1RD8QFHniZb6Rq615BI3ubR7oKAU3nYYXfJrYWuVhxHbcpDFpdm0/jeHP
         Puz+RXo++6Zbiexj9qXIDdnCmCB65EuR9xALy8QLJ5Snj6qmpy9+nkx7D3MjcoxYVxRb
         3nq5eYlF7NA/CjkgbKGZFRgu0reePUMSgM+BbXvPZd3LZ6ziQXzXhQ6pZDhG0e9dZ6wl
         7XKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZJqkjkJQd/k/G40mgrkDoQOdH4St7HF1IpqHBDocRBc=;
        b=DA62ksG9TuwStJ71fTl9DuJNcBODweEr/YGZBbjmj45KnjJGC883RGu6qTySD/jh1t
         bYcdjFkhqPIeiqLFwYWL1E1v9P9pa9bYropKawnr/IOn6JU2mJuYfWYk30yBatRv2HTZ
         r0sV6OvhftrLyvAA/FKLW1veg1ZFO9l6lasph0FOeBuWkwbr/LG8eLXwvCWIkMiL1cW3
         gs+AroEYWwMlCTWpE/CThJ0c5QM82NfxrxZZJpJOUtbglV3/PO/tuDGnLrvXFKUmBk3N
         WoCYmkSLigNl6GBAmUg7FSZsGJxoxqP976x6KMHSworlE+iLfKCNVYmGXyNhcDDSdu0+
         x2fg==
X-Gm-Message-State: ANhLgQ19ZVY+B+cMamW10QdBpLmEGFStTMkOMOfNKgZvF1zQ8HcCV8rb
        G6ttOkry9cQF//FbU6hfJ5np5jENV5nfbZ0aSTelWA==
X-Google-Smtp-Source: ADFU+vuIDV4yU24V+CP/7jFvqxn+ol1ehIaNdwgjQgs/2Fkl9eNK8tGglYogk049b8UfTvzO8V7i+FltoadT/HE/G6k=
X-Received: by 2002:a67:df97:: with SMTP id x23mr15091722vsk.160.1584960560100;
 Mon, 23 Mar 2020 03:49:20 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9f:3b21:0:0:0:0:0 with HTTP; Mon, 23 Mar 2020 03:49:19
 -0700 (PDT)
X-Originating-IP: [5.35.40.234]
In-Reply-To: <9eb74bee-8434-62aa-8158-bae130353670@suse.com>
References: <1584364176-23346-1-git-send-email-kda@linux-powerpc.org>
 <f75365c7-a3ca-cf12-b2fc-e48652071795@suse.com> <CAOJe8K3gDJrdKz9zVZNj=N76GygMnPbCKM0-kVfoV53fASAefg@mail.gmail.com>
 <250783b3-4949-d00a-70e2-dbef1791a6c4@suse.com> <CAOJe8K0fBBi-M+Tdv2kC+ZaNvjx92tzYaU1QX2zr8QOBRLwu3g@mail.gmail.com>
 <9eb74bee-8434-62aa-8158-bae130353670@suse.com>
From:   Denis Kirjanov <kda@linux-powerpc.org>
Date:   Mon, 23 Mar 2020 13:49:19 +0300
Message-ID: <CAOJe8K34OS9vq9jWjVE9nrzvF+kdZnyAfGSS5tnJG-obDRwjSg@mail.gmail.com>
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

On 3/23/20, J=C3=BCrgen Gro=C3=9F <jgross@suse.com> wrote:
> On 23.03.20 11:15, Denis Kirjanov wrote:
>> On 3/18/20, J=C3=BCrgen Gro=C3=9F <jgross@suse.com> wrote:
>>> On 18.03.20 13:50, Denis Kirjanov wrote:
>>>> On 3/18/20, J=C3=BCrgen Gro=C3=9F <jgross@suse.com> wrote:
>>>>> On 16.03.20 14:09, Denis Kirjanov wrote:
>>>>>> The patch adds a basic XDP processing to xen-netfront driver.
>>>>>>
>>>>>> We ran an XDP program for an RX response received from netback
>>>>>> driver. Also we request xen-netback to adjust data offset for
>>>>>> bpf_xdp_adjust_head() header space for custom headers.
>>>>>
>>>>> This is in no way a "verbose patch descriprion".
>>>>>
>>>>> I'm missing:
>>>>>
>>>>> - Why are you doing this. "Add XDP support" is not enough, for such
>>>>>      a change I'd like to see some performance numbers to get an idea
>>>>>      of the improvement to expect, or which additional functionality
>>>>>      for the user is available.
>>>> Ok, I'll try to measure  some numbers.
>>>>
>>>>>
>>>>> - A short description for me as a Xen maintainer with only basic
>>>>>      networking know-how, what XDP programs are about (a link to some
>>>>>      more detailed doc is enough, of course) and how the interface
>>>>>      is working (especially for switching between XDP mode and normal
>>>>>      SKB processing).
>>>>
>>>> You can search for the "A practical introduction to XDP" tutorial.
>>>> Actually there is a lot of information available regarding XDP, you
>>>> can easily find it.
>>>>
>>>>>
>>>>> - A proper description of the netfront/netback communication when
>>>>>      enabling or disabling XDP mode (who is doing what, is silencing
>>>>>      of the virtual adapter required, ...).
>>>> Currently we need only a header offset from netback driver so that we
>>>> can
>>>> put
>>>> custom encapsulation header if required and that's done using xen bus
>>>> state switching,
>>>> so that:
>>>> - netback tells that it can adjust the header offset
>>>> - netfront part reads it
>>>
>>> Yes, but how is this synchronized with currently running network load?
>>> Assume you are starting without XDP being active and then you are
>>> activating it. How is the synchronization done from which request on
>>> the XDP headroom is available?
>>
>> Hi Jurgen,
>>
>> basically XDP is activated when you've assigned an xdp program to the
>> networking device.
>> Assigning an xdp program means that we have to adjust a pointer which
>> is RCU protected.
>
> This doesn't answer my question.
>
> You have basically two communication channels: the state of the frontend
> and backend for activation/deactivation of XDP, and the ring pages with
> the rx and tx requests and responses. How is the synchronization between
> those two channels done? So how does the other side know which of the
> packets in flight will then have XDP on or off?

Right,
that's done in xen-netback using xenbus state:
- in xennet_xdp_set() we call xenbus_switch_state to tell xen-netback to
adjust offset for an RX response.
-xen-netback reads the value from xenstore and adjusts the offset for
xen-netback
in xenvif_rx_data_slot() using vif->xdp_enabled flag.


>
>
> Juergen
>
