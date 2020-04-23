Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6C071B64BA
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 21:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgDWTqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 15:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbgDWTqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 15:46:24 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 867A7C09B042
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 12:46:22 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id g16so5323164eds.1
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 12:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UWBKc1vPy8o34MbRI1kOkjD27wAb7qiaJjKVkbxQjmQ=;
        b=dXWBAMCz4fD2VYeKdY5YBjjBv6S5sQ60lqmJp4D+vFX/o9QPToLh5q7EvGjo3ENHqw
         mLaIRN+lpImTnnWzDm1X86ZzdaEOsoSmwDLaBpGhtYKpN7nSlH/euDXNnX+H1vdcFjAJ
         zNmsTmWIX3HrR5pt0lzuxvBQWjOSMavGhmbo8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UWBKc1vPy8o34MbRI1kOkjD27wAb7qiaJjKVkbxQjmQ=;
        b=Ud3cniSlPG8hvLo/PDYPT5cYLWNg/dYqeKSN4SxFCluKHAR3u9G03rBxIy6Rt63FHF
         t0e2ljCFqX8lZ4AqquG91nvGeZNnlZwHDGHmCR5DtZ4o+dWLkMjYq/8tanWcfdjOT88b
         Ox97LwYncbeQ0ZVuXUr4KRAQTos/LbGsea6DgVPm9UXJMSJ6ZmgTf87fyIa+qy/srkEU
         hhXruADdUTzs7XcALgriis89WihhWiBcRrNF/2x++n53mX1Frh3boGcZkpSDLT+eaHGt
         rqI+XqWOkjgwuOAUFvqmabScKDwxNek/dODzjuY3Nzdpf9/wO0BhzbcCBmmmDR1ceFui
         ra5w==
X-Gm-Message-State: AGi0PuZ1xo7TvTlfNc10BqGKadKmtBChDvy7rI3iZ5RKzYubqAeM8+Na
        VgvzX6I/aqbtlYvUckB5bE0YKt3w4HstGPRzzP3Ibw==
X-Google-Smtp-Source: APiQypLNDl98dsPFWOsJ/PXrpen+/mRqszeKYqZ1mBHg9/PCZPMR31Yv7YlLGsPenaYvhfqQsZar/dGpNmqrbc5dU5w=
X-Received: by 2002:a05:6402:684:: with SMTP id f4mr4340991edy.240.1587671181270;
 Thu, 23 Apr 2020 12:46:21 -0700 (PDT)
MIME-Version: 1.0
References: <1587619280-46386-1-git-send-email-roopa@cumulusnetworks.com>
 <CAJieiUgHMjVozdSE_DM1yDnGuUEXkamDgmKwUfdBbvhTdx3Eqg@mail.gmail.com> <9bc6f1cd-7d18-8222-6e09-918488c3f6b5@gmail.com>
In-Reply-To: <9bc6f1cd-7d18-8222-6e09-918488c3f6b5@gmail.com>
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
Date:   Thu, 23 Apr 2020 12:46:10 -0700
Message-ID: <CAJieiUgkO5x71KDAVvcF1nhA7Du9RnHqxTtTSOOh9JMGehOuyg@mail.gmail.com>
Subject: Re: [PATCH net-next 0/2] nexthop: sysctl to skip route notifications
 on nexthop changes
To:     David Ahern <dsahern@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Benjamin Poirier <bpoirier@cumulusnetworks.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 23, 2020 at 8:10 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 4/23/20 8:48 AM, Roopa Prabhu wrote:
> >
> >
> > On Wed, Apr 22, 2020, 10:21 PM Roopa Prabhu <roopa@cumulusnetworks.com
> > <mailto:roopa@cumulusnetworks.com>> wrote:
> >
> >     From: Roopa Prabhu <roopa@cumulusnetworks.com
> >     <mailto:roopa@cumulusnetworks.com>>
> >
> >     Route notifications on nexthop changes exists for backward
> >     compatibility. In systems which have moved to the new
> >     nexthop API, these route update notifications cancel
> >     the performance benefits provided by the new nexthop API.
> >     This patch adds a sysctl to disable these route notifications
> >
> >     We have discussed this before. Maybe its time ?
> >
> >     Roopa Prabhu (2):
> >       ipv4: add sysctl to skip route notify on nexthop changes
> >       ipv6: add sysctl to skip route notify on nexthop changes
> >
> >
> >
> > Will update the series with some self test results with sysctl on later
> > today. Expect v2
> >
>
> and I have some changes for you. :-)
>
> There's a bit more to a "all of the processes know about nexthops; give
> me best performance" switch. I will send you a starter patch - the one I
> used for the LPC 2019 talk.

okay, thanks. :) .
