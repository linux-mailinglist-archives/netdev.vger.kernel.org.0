Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF8218F286
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 11:15:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbgCWKPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 06:15:42 -0400
Received: from mail-vs1-f67.google.com ([209.85.217.67]:37842 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727829AbgCWKPm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 06:15:42 -0400
Received: by mail-vs1-f67.google.com with SMTP id o3so8372360vsd.4
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 03:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CX0btN3Hd/1LmAJsxZF9LyWE1bX+HgAhsQSbCuh1ch4=;
        b=ncfwln5LDXeKyZN8twWWgCmjiUP/hZwSqR5BW6sJSPRpQJPr4nGu1J7j/TJoQGXDwH
         LqfX3C+R1RKFVqeSaWeMwFVyNrOkkmPhqUIg3FwnETbuD3kju7PSpO28wErRjJ09uA5e
         CPydZi7/qGVnAe/0sg/WkBytGQazVerukEdDtaTgtz/YI2XzUlGNA38wMljeSKiR1ZAn
         VGYwSQ6AQoF+Rwh+bFSph4UeLLNSXCb/2SnA1dtDf6NKajMBorXZevnPx8wsKmJvhHNY
         gr2e3pVSZC56YeK01q/BV5e8wvAWeBFg4/2fNXZLTo5dlTRMvHhpONJ8Eciu0AFvxGAC
         uWDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CX0btN3Hd/1LmAJsxZF9LyWE1bX+HgAhsQSbCuh1ch4=;
        b=B7KR/z+4m/q6Y9mVDEasbTxnqsDCv/sdbYyYOXC/nN5obaKQtGNo+OAizXhHWN/eOa
         ZCay4Oqrgr8yB885RwAZlCXWOVWl7FIacIaPcJupF58ONRntcnF3Je0V7e2YxLkfK1aC
         MeMydTef92lNgYMGxWG6xh5lerdKcSKIEehNM7bVe9uu3oFzR3I30j9OKZeZfl53/LyZ
         9KgJOYjxWw0pusYcCyc9UYfpKSfJxYKGHGSECP7xpcA+6542oYw6dQK3ppo/gNZaf198
         pZYhC01JICOv1RhslIOdBKoTZYoCM3Gs/l2J+d+XMCcMTZU5tkEZ+GF7VjsIPjGyk67B
         lRKg==
X-Gm-Message-State: ANhLgQ2xh865EAtLdiGwugvQhs883z/tcXTAujjX8tsGA/J3vNvDBKEc
        TCuYwiQrlMzDqhbFSaXHwcH8JhTBqVt8+WBSVGqZ7g==
X-Google-Smtp-Source: ADFU+vsM2JGM/+LIKWOyqC6kMrc6O7M+zG3pc3tcn9HLnV/Lbuu+LrcVZKn8+xE76LsodiiBRR2Jt4nQLGno8Q7cLyI=
X-Received: by 2002:a05:6102:1157:: with SMTP id j23mr14582584vsg.80.1584958541133;
 Mon, 23 Mar 2020 03:15:41 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9f:3b21:0:0:0:0:0 with HTTP; Mon, 23 Mar 2020 03:15:40
 -0700 (PDT)
X-Originating-IP: [5.35.40.234]
In-Reply-To: <250783b3-4949-d00a-70e2-dbef1791a6c4@suse.com>
References: <1584364176-23346-1-git-send-email-kda@linux-powerpc.org>
 <f75365c7-a3ca-cf12-b2fc-e48652071795@suse.com> <CAOJe8K3gDJrdKz9zVZNj=N76GygMnPbCKM0-kVfoV53fASAefg@mail.gmail.com>
 <250783b3-4949-d00a-70e2-dbef1791a6c4@suse.com>
From:   Denis Kirjanov <kda@linux-powerpc.org>
Date:   Mon, 23 Mar 2020 13:15:40 +0300
Message-ID: <CAOJe8K0fBBi-M+Tdv2kC+ZaNvjx92tzYaU1QX2zr8QOBRLwu3g@mail.gmail.com>
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

On 3/18/20, J=C3=BCrgen Gro=C3=9F <jgross@suse.com> wrote:
> On 18.03.20 13:50, Denis Kirjanov wrote:
>> On 3/18/20, J=C3=BCrgen Gro=C3=9F <jgross@suse.com> wrote:
>>> On 16.03.20 14:09, Denis Kirjanov wrote:
>>>> The patch adds a basic XDP processing to xen-netfront driver.
>>>>
>>>> We ran an XDP program for an RX response received from netback
>>>> driver. Also we request xen-netback to adjust data offset for
>>>> bpf_xdp_adjust_head() header space for custom headers.
>>>
>>> This is in no way a "verbose patch descriprion".
>>>
>>> I'm missing:
>>>
>>> - Why are you doing this. "Add XDP support" is not enough, for such
>>>     a change I'd like to see some performance numbers to get an idea
>>>     of the improvement to expect, or which additional functionality
>>>     for the user is available.
>> Ok, I'll try to measure  some numbers.
>>
>>>
>>> - A short description for me as a Xen maintainer with only basic
>>>     networking know-how, what XDP programs are about (a link to some
>>>     more detailed doc is enough, of course) and how the interface
>>>     is working (especially for switching between XDP mode and normal
>>>     SKB processing).
>>
>> You can search for the "A practical introduction to XDP" tutorial.
>> Actually there is a lot of information available regarding XDP, you
>> can easily find it.
>>
>>>
>>> - A proper description of the netfront/netback communication when
>>>     enabling or disabling XDP mode (who is doing what, is silencing
>>>     of the virtual adapter required, ...).
>> Currently we need only a header offset from netback driver so that we ca=
n
>> put
>> custom encapsulation header if required and that's done using xen bus
>> state switching,
>> so that:
>> - netback tells that it can adjust the header offset
>> - netfront part reads it
>
> Yes, but how is this synchronized with currently running network load?
> Assume you are starting without XDP being active and then you are
> activating it. How is the synchronization done from which request on
> the XDP headroom is available?

Hi Jurgen,

basically XDP is activated when you've assigned an xdp program to the
networking device.
Assigning an xdp program means that we have to adjust a pointer which
is RCU protected.

>
>>>
>>> - Reasoning why the suggested changes of frontend and backend state
>>>     are no problem for special cases like hot-remove of an interface or
>>>     live migration or suspend of the guest.
>>
>> I've put the code to talk_to_netback which is called "when first
>> setting up, and when resuming"
>> If you see a problem with that please share.
>
> What happens if a migration is just starting when netfront has switched
> its state to "Reconfigured"? Will the new device activation at the
> target host work as desired? In which state will XDP be on the frontend
> after that (i.e. is a direct state transition on the frontend from
> "Reconfigured" to "Initializing" fine)? It should be spelled out in the
> commit message that this scenario has been thought of and that it will
> work.
Well, that definitely means that I have to play with that scenario.

Moreover, I've found a problem with memory consumption while testing a
pktgen load with
xen-netfront.

Thank!
>
>>
>>>
>>> Finally I'd like to ask you to split up the patch into a netfront and
>>> a netback one.
>>
>> Ok, will do.
>
> Thanks.
>
>
> Juergen
>
