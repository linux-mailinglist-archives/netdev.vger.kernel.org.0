Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5AAD189C4A
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 13:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbgCRMuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 08:50:23 -0400
Received: from mail-vs1-f66.google.com ([209.85.217.66]:37906 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbgCRMuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 08:50:22 -0400
Received: by mail-vs1-f66.google.com with SMTP id x206so7605882vsx.5
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 05:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tNH5oppoky0OHGa5tXYcwyV7SJRdKkQrTvDjbdQHru4=;
        b=NA5BCCk6cEdsdxdych4EBOfRTF2f+xIX55/kbCWgDSx44xCejlGrWQVPFvMYTLJ3/w
         UERaGmqLf3LWko+XvLsAsrEqYUq0ZFzWsI2bmSRE9/r5GePZtFv4z7ql4tdzH2e7orjK
         39u8iqGXTLm2C/f+bF51L7D2GNwvVqkUQhMTVxiI04J+vug3vmax0NdgLdaZ8GQSYcwr
         0ku9IG4Wq7BUHpioN9okIkF6uk7yUTZFB2SsvGvxE1nW1NwsAHkyEgaFl6NPTKUIhYW6
         YBocu8VeNhu8yZ0n030mCJnOzc/0vb8wLCzZaNa9lULMMc3dezVYSoUdsN6mv5mTV1bp
         vw9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tNH5oppoky0OHGa5tXYcwyV7SJRdKkQrTvDjbdQHru4=;
        b=Prv1oOAc6QBn/WMfoK5K786/JFMNjpn6fr5QfuNLdmvfTiz7Cffa/8SfSk/9P0l+oP
         CTBFEa5Hv46AcQGH/95X9MRUYRNTHj3lAO8FctlDvOa8xstWFQ4YWWeums4STItKZHuh
         U5/W+E5Qhv8p/JpCJB6YfRJTIDhmxlHXMXCme8NKDnz+K2AS4o1IKpJpqU7KfhCgys4m
         6FG12VP1HAzGH2VEfZ+yE9AtUA1o6kJtDxZaSK+IACOJHLrIo9ujD/r2ZWZnnFZ9LnT/
         cTotwNkfUo03SMy5wY46O0vbmLpHoEiwNlIdpNQl7B7qKsREqe9szxsbmGbSLDvqfoo1
         RTTg==
X-Gm-Message-State: ANhLgQ3lLf18grJrInJj15h8BDj6FgUOSSjd7pZOuvTJmEIZbZXjwBgS
        XSP3C0pZ6WDdO6RFfiM4Bp/oqVjD2O77QAaYfxFO2g==
X-Google-Smtp-Source: ADFU+vuGTbacJJyl1R90h0Jboo62I4NU99xdEygLBx6b4WhzEwyH/jgtPtVjq2yCEIPJ3MRUxjSt1XO7sNNC/UvJxVc=
X-Received: by 2002:a67:df97:: with SMTP id x23mr3051735vsk.160.1584535820076;
 Wed, 18 Mar 2020 05:50:20 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9f:3b21:0:0:0:0:0 with HTTP; Wed, 18 Mar 2020 05:50:19
 -0700 (PDT)
X-Originating-IP: [5.35.35.59]
In-Reply-To: <f75365c7-a3ca-cf12-b2fc-e48652071795@suse.com>
References: <1584364176-23346-1-git-send-email-kda@linux-powerpc.org> <f75365c7-a3ca-cf12-b2fc-e48652071795@suse.com>
From:   Denis Kirjanov <kda@linux-powerpc.org>
Date:   Wed, 18 Mar 2020 15:50:19 +0300
Message-ID: <CAOJe8K3gDJrdKz9zVZNj=N76GygMnPbCKM0-kVfoV53fASAefg@mail.gmail.com>
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
> On 16.03.20 14:09, Denis Kirjanov wrote:
>> The patch adds a basic XDP processing to xen-netfront driver.
>>
>> We ran an XDP program for an RX response received from netback
>> driver. Also we request xen-netback to adjust data offset for
>> bpf_xdp_adjust_head() header space for custom headers.
>
> This is in no way a "verbose patch descriprion".
>
> I'm missing:
>
> - Why are you doing this. "Add XDP support" is not enough, for such
>    a change I'd like to see some performance numbers to get an idea
>    of the improvement to expect, or which additional functionality
>    for the user is available.
Ok, I'll try to measure  some numbers.

>
> - A short description for me as a Xen maintainer with only basic
>    networking know-how, what XDP programs are about (a link to some
>    more detailed doc is enough, of course) and how the interface
>    is working (especially for switching between XDP mode and normal
>    SKB processing).

You can search for the "A practical introduction to XDP" tutorial.
Actually there is a lot of information available regarding XDP, you
can easily find it.

>
> - A proper description of the netfront/netback communication when
>    enabling or disabling XDP mode (who is doing what, is silencing
>    of the virtual adapter required, ...).
Currently we need only a header offset from netback driver so that we can p=
ut
custom encapsulation header if required and that's done using xen bus
state switching,
so that:
- netback tells that it can adjust the header offset
- netfront part reads it
>
> - Reasoning why the suggested changes of frontend and backend state
>    are no problem for special cases like hot-remove of an interface or
>    live migration or suspend of the guest.

I've put the code to talk_to_netback which is called "when first
setting up, and when resuming"
If you see a problem with that please share.

>
> Finally I'd like to ask you to split up the patch into a netfront and
> a netback one.

Ok, will do.

Thanks!
>
>
> Juergen
>
