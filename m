Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D115587EE
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 19:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbfF0RF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 13:05:58 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:40436 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726405AbfF0RF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 13:05:58 -0400
Received: by mail-lf1-f66.google.com with SMTP id a9so2082678lff.7;
        Thu, 27 Jun 2019 10:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iOhDHETC5N147AFVi2bFRpawUQhaX7cNPdGDjgonKbE=;
        b=jpn5X78o7EpWieqkKWa01DsUePXYcOaSUM8L2Ciqxp0pHWZLoRQo1XPg7vrtVsXzoq
         kCHXSi5z3v+4eI9XPsPSnpUFLakGro5T6dI74bekoZt4EyryN4hYMiyQeO7cER2Zk+x/
         72yFryCaoLJNTOWPSrAPupMr7UzykXZRlzZv2fcRXtVrXQjwaHQiheLGSxjiLrIHkrWY
         5GyQFw1Eminvx8EodGGVk2wRzP7BUkSPCyf0koJ1eJHJoAcbAjRlUR4+qjxRRu6lv80i
         ZGbaAEUwWv0RQkNJJZ0R/1KVJh8/SbcYZudYe1feb1kuzD/84YFE+bvX1ld3BFwsfQbM
         qaZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iOhDHETC5N147AFVi2bFRpawUQhaX7cNPdGDjgonKbE=;
        b=A7ZWtAKyLvDzkqLvmxkmzGDlM9qs2MEXBwXr2gRsRsk6Hwdom9ls4Ey62gH+LG42Lq
         hBjWaEPL8HxiV4TsK4+Yolwgfm4uC36tKdk54bIsmGKxLR6NwhCGTEBl7oOROtpVUhuD
         go+lCx9d9xVSAGWuccHMbEUfrPrt+2g6q8I1th30BPi60LDH0g3HvCHuAHa3tN2IsmvK
         3JRso96aXPr6BuLYEf3B+TKr60LaXYcOyYVnJ7XjxpCTNWHLvupDUbhMliGN73q1F8vS
         bnT5o6z5prX4JvAgrGe+MyJs6tLWLcn4OoSSJawBRB8yq+uDN+Gnc5mTlwMKDEvG/XtB
         BXvg==
X-Gm-Message-State: APjAAAU3/d8ZqR455QCbsKOaFBKlAL4L2Hyyh7VzKjgrVGZptbwu3yQ2
        E1Wm568iF7lphHf6Ew5ZtjbNTM/JSmriu5Uyyxo=
X-Google-Smtp-Source: APXvYqyNQZydmw3JcNC//3y6wLs9KgBg47pVU3W/YRxmyD2cYDhjxsYKbbryEfM2It5oHcMCBIHmXu08PcP0GnDpR5I=
X-Received: by 2002:a19:e05c:: with SMTP id g28mr2662435lfj.167.1561655155630;
 Thu, 27 Jun 2019 10:05:55 -0700 (PDT)
MIME-Version: 1.0
References: <20190627010137.5612-1-c0d1n61at3@gmail.com> <20190627032532.18374-2-c0d1n61at3@gmail.com>
 <7f6f44b2-3fe4-85f6-df3c-ad59f2eadba2@linuxfoundation.org>
 <20190627.092253.1878691006683087825.davem@davemloft.net> <9687ddc6-3bdb-5b2a-2934-ed9c6921551d@linuxfoundation.org>
In-Reply-To: <9687ddc6-3bdb-5b2a-2934-ed9c6921551d@linuxfoundation.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 27 Jun 2019 10:05:43 -0700
Message-ID: <CAADnVQLxrwkgHY6sg98NVfAsG3EYeJLxAevskOUdB=gNQugfSg@mail.gmail.com>
Subject: Re: [Linux-kernel-mentees][PATCH v2] packet: Fix undefined behavior
 in bit shift
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     David Miller <davem@davemloft.net>, c0d1n61at3@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 9:54 AM Shuah Khan <skhan@linuxfoundation.org> wrote:
>
> On 6/27/19 10:22 AM, David Miller wrote:
> > From: Shuah Khan <skhan@linuxfoundation.org>
> > Date: Wed, 26 Jun 2019 21:32:52 -0600
> >
> >> On 6/26/19 9:25 PM, Jiunn Chang wrote:
> >>> Shifting signed 32-bit value by 31 bits is undefined.  Changing most
> >>> significant bit to unsigned.
> >>> Changes included in v2:
> >>>     - use subsystem specific subject lines
> >>>     - CC required mailing lists
> >>>
> >>
> >> These version change lines don't belong in the change log.
> >
> > For networking changes I actually like the change lines to be in the
> > commit log.  So please don't stray people this way, thanks.
> >
>
> As a general rule, please don't include change lines in the commit log.
> For networking changes that get sent to David and netdev, as David
> points out here, he likes them in the commit log, please include them
> in the commit log.
>
> I am working on FAQ (Frequently Answered Questions) section for mentees.
> I will add this to it.

Same for bpf trees.
We prefer developers put as much as info as possible into commit logs
and cover letters.
Explanation of v1->v2->v3 differences is invaluable not only at
the point of code review, but in the future.
