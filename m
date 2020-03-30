Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E369E197BA4
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 14:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729913AbgC3MQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 08:16:16 -0400
Received: from mail-ua1-f68.google.com ([209.85.222.68]:40877 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729705AbgC3MQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 08:16:15 -0400
Received: by mail-ua1-f68.google.com with SMTP id t20so6150150uao.7
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 05:16:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=48W+1OvErjubjjK762DK/7nORfuohREXCfJclOEzgT0=;
        b=EXgrp/GvML7F2lCxhwp1Y4nsu614aVAfA5ToezVR638S0tDL5N6Ht1pieVDR9gzQke
         tMwLHNLy3BsoSXAgf9YxmC7rZqi3osJ5FCApD87aMzpT7K8DAOf7tVhl8tTch6xpDY6N
         a2phLr3a7a9G4cyys7hqiBjWMwwK0uT6LFFy1CQXe3AXFu+crr2aITYDEloczk4kKD7/
         1palkFvCXLMWCe4yVq8etrEQTlvxtiBCwTyMHU3OU7sRaFHQyqJkhGQ4uZhR4R2OVroS
         q70wBtFRi0GHQsOqF3kOgYG2OHZpXjIlwVjz0GymN7zVBjacPb8M0KcrpNi8IxpN/nFJ
         V1vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=48W+1OvErjubjjK762DK/7nORfuohREXCfJclOEzgT0=;
        b=obzSYqpGYoroi/2cO1HLkA4r+HFkcqTIgEmQqnmyi8BdabiSq6qQItD/iE3qAm642V
         7zO58tgHtvo0ZGVkXyxRAcsi4nGRJPKLjxjem+AXLPNMtdnPabe3+/aayt+zmyqyflE1
         dlUyIkb5barWbs0INDL3JK0n7//gbwM/OK5yepZAxe72EADRhcXcS31Ji8xk7Bo+g+b9
         uwTyIrZJ2ss3kXJu6eHiYPxZmRe1lBadEbwUay6iLp7CmrPshGAGuymhkQhWImk6xeFW
         1hhTvUDcTAWxjLpk67h31JC6End82IW8FSPcEflDNmN1hLXfYI/C5wlBkkBQx12T25c2
         65xA==
X-Gm-Message-State: AGi0PuaOERepJiktsz15Pe/W57R3hq4dCHi6QTGNEqlpoSxCJ6I+w6BF
        qwWJQdrQtpGiaoDMjCDyjbYwGoby5vpIBvLP3DHqUf3/
X-Google-Smtp-Source: APiQypJbn+Kf67WB5YlBr4sbU6tmZvJHzbmnbkToCPHIED0FceCjEJ1qgDxrEQJBAre23VOblPhChObFsjm6EeO7jLY=
X-Received: by 2002:a9f:3381:: with SMTP id p1mr7434600uab.119.1585570571922;
 Mon, 30 Mar 2020 05:16:11 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab0:6507:0:0:0:0:0 with HTTP; Mon, 30 Mar 2020 05:16:10
 -0700 (PDT)
X-Originating-IP: [5.35.40.234]
In-Reply-To: <d29338f2-62ef-e33c-a3d8-a9a9d2e3bf63@suse.com>
References: <1584364176-23346-1-git-send-email-kda@linux-powerpc.org>
 <f75365c7-a3ca-cf12-b2fc-e48652071795@suse.com> <CAOJe8K3gDJrdKz9zVZNj=N76GygMnPbCKM0-kVfoV53fASAefg@mail.gmail.com>
 <250783b3-4949-d00a-70e2-dbef1791a6c4@suse.com> <CAOJe8K0fBBi-M+Tdv2kC+ZaNvjx92tzYaU1QX2zr8QOBRLwu3g@mail.gmail.com>
 <9eb74bee-8434-62aa-8158-bae130353670@suse.com> <CAOJe8K34OS9vq9jWjVE9nrzvF+kdZnyAfGSS5tnJG-obDRwjSg@mail.gmail.com>
 <d29338f2-62ef-e33c-a3d8-a9a9d2e3bf63@suse.com>
From:   Denis Kirjanov <kda@linux-powerpc.org>
Date:   Mon, 30 Mar 2020 15:16:10 +0300
Message-ID: <CAOJe8K3+ddELP=nac+WRB1d5ccsDQu2UBVY4T2GiFFUfhk0jcQ@mail.gmail.com>
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
> On 23.03.20 11:49, Denis Kirjanov wrote:
>> On 3/23/20, J=C3=BCrgen Gro=C3=9F <jgross@suse.com> wrote:
>>> On 23.03.20 11:15, Denis Kirjanov wrote:
>>>> On 3/18/20, J=C3=BCrgen Gro=C3=9F <jgross@suse.com> wrote:
>>>>> On 18.03.20 13:50, Denis Kirjanov wrote:
>>>>>> On 3/18/20, J=C3=BCrgen Gro=C3=9F <jgross@suse.com> wrote:
>>>>>>> On 16.03.20 14:09, Denis Kirjanov wrote:
>>>>>>>> The patch adds a basic XDP processing to xen-netfront driver.
>>>>>>>>
>>>>>>>> We ran an XDP program for an RX response received from netback
>>>>>>>> driver. Also we request xen-netback to adjust data offset for
>>>>>>>> bpf_xdp_adjust_head() header space for custom headers.
>>>>>>>
>>>>>>> This is in no way a "verbose patch descriprion".
>>>>>>>
>>>>>>> I'm missing:
>>>>>>>
>>>>>>> - Why are you doing this. "Add XDP support" is not enough, for such
>>>>>>>       a change I'd like to see some performance numbers to get an
>>>>>>> idea
>>>>>>>       of the improvement to expect, or which additional
>>>>>>> functionality
>>>>>>>       for the user is available.
>>>>>> Ok, I'll try to measure  some numbers.
>>>>>>
>>>>>>>
>>>>>>> - A short description for me as a Xen maintainer with only basic
>>>>>>>       networking know-how, what XDP programs are about (a link to
>>>>>>> some
>>>>>>>       more detailed doc is enough, of course) and how the interface
>>>>>>>       is working (especially for switching between XDP mode and
>>>>>>> normal
>>>>>>>       SKB processing).
>>>>>>
>>>>>> You can search for the "A practical introduction to XDP" tutorial.
>>>>>> Actually there is a lot of information available regarding XDP, you
>>>>>> can easily find it.
>>>>>>
>>>>>>>
>>>>>>> - A proper description of the netfront/netback communication when
>>>>>>>       enabling or disabling XDP mode (who is doing what, is
>>>>>>> silencing
>>>>>>>       of the virtual adapter required, ...).
>>>>>> Currently we need only a header offset from netback driver so that w=
e
>>>>>> can
>>>>>> put
>>>>>> custom encapsulation header if required and that's done using xen bu=
s
>>>>>> state switching,
>>>>>> so that:
>>>>>> - netback tells that it can adjust the header offset
>>>>>> - netfront part reads it
>>>>>
>>>>> Yes, but how is this synchronized with currently running network load=
?
>>>>> Assume you are starting without XDP being active and then you are
>>>>> activating it. How is the synchronization done from which request on
>>>>> the XDP headroom is available?
>>>>
>>>> Hi Jurgen,
>>>>
>>>> basically XDP is activated when you've assigned an xdp program to the
>>>> networking device.
>>>> Assigning an xdp program means that we have to adjust a pointer which
>>>> is RCU protected.
>>>
>>> This doesn't answer my question.
>>>
>>> You have basically two communication channels: the state of the fronten=
d
>>> and backend for activation/deactivation of XDP, and the ring pages with
>>> the rx and tx requests and responses. How is the synchronization betwee=
n
>>> those two channels done? So how does the other side know which of the
>>> packets in flight will then have XDP on or off?
>>
>> Right,
>> that's done in xen-netback using xenbus state:
>> - in xennet_xdp_set() we call xenbus_switch_state to tell xen-netback to
>> adjust offset for an RX response.
>> -xen-netback reads the value from xenstore and adjusts the offset for
>> xen-netback
>> in xenvif_rx_data_slot() using vif->xdp_enabled flag.
>
> And before that all in-flight requests in the ring pages are being
> processed and no new requests are guaranteed to be enqueued?

Actually I don't see the need to sync these requests since that all we
have to do is to copy
data with specified offset:
with xdp->enabled=3D1: copy with the offset XDP_PACKET_HEADROOM
with xdd->enabled=3D0: copy without the offset

Thanks!

>
>
> Juergen
>
