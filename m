Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FDA530AF05
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 19:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232768AbhBASVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 13:21:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232374AbhBASUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 13:20:43 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC747C06174A
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 10:20:02 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id z22so19988472edb.9
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 10:20:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Aip1DiTAu70mKuVviJXcj4q9SjJosPv9Y7ClpI3VAGc=;
        b=lka+Bxizs3pZ0RCvK7N44TnghzZ6jg9qvuYDKBMCaNJteZAa9/sL3xrIYjsxb5g9j6
         YgXsSPseox5DHYUKhFd2hdaV8dA/N1ENZicxFwwveolR9/rTVBPs9tYEe/a5rgslFig6
         jpsHjkZ+3Ck55kqSUSkPan20/vG9cpz0rGY52nLxwVunZqUeEiIIDd+kibqVwF+liQBi
         GWSRMh3yj0DfzDtruErWd0eAqENwyCwqDxrcG2s7m6UvWkH890bytncblnCymDRNs8CI
         xleAjRpENIQcN5o6qotLyYc7M7BSxFeMUNBRHNtsOjyPhpS6mtecpDA8zvoOpTOYQJ4t
         zp8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Aip1DiTAu70mKuVviJXcj4q9SjJosPv9Y7ClpI3VAGc=;
        b=Ys+M55qN/BNmInNqjCtGg8OfwC/OvYcRMhF8BlaD+fb7hVhfhtHOpiWhpTvrqHF83n
         Hkur64AqHREQCjiyhHAMkRvwrkzaYRPh09hYtbmCftrq+78R3TMfGJeE9pb7vnJCLdcH
         ZDvIThiCajN91maqXr4rXOszJxMWA7h9fDPV0TGr8FLwMg0q+PVTLVUgw/1cays8I0NT
         S7XMgU7mrfKaEe+qUfqY7WJawUsuthXlpv19HaC7JQavE+zRmNg1lDOBt5irBJYq1QQk
         8zu19x78eustp//FLLYMXFRBMZim52KRPzzc8QpBOuZMpjtJZSzGXiiB+v1Ps10K+TUn
         pCQQ==
X-Gm-Message-State: AOAM530ZoW5nvFcs99NtzWf3HqIBh9mRJX40f9YVzXvBKSCxlxALSYst
        xudYObIQMrs+2varpCeJBRJFAG6TxZ49HjZG0OVBUw==
X-Google-Smtp-Source: ABdhPJx0XwQlnJRZ6H/hnScqxh0sF91wBnHKCh2lKAppmjShEZjRJNwM7b7U3sc/s1rKr5YpmSkysxzLqtrqYVcKPjo=
X-Received: by 2002:aa7:c2c7:: with SMTP id m7mr20028449edp.134.1612203601507;
 Mon, 01 Feb 2021 10:20:01 -0800 (PST)
MIME-Version: 1.0
References: <1611766877-16787-1-git-send-email-loic.poulain@linaro.org>
 <1611766877-16787-3-git-send-email-loic.poulain@linaro.org>
 <20210129182108.771dc2fe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <0bd01c51c592aa24c2dabc8e3afcbdbe9aa23bdc.camel@redhat.com>
In-Reply-To: <0bd01c51c592aa24c2dabc8e3afcbdbe9aa23bdc.camel@redhat.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Mon, 1 Feb 2021 19:27:09 +0100
Message-ID: <CAMZdPi_-b9GWrOcj8GBX8jnxyZN9WZ6nr9KPzXPZZKWfyPW3sQ@mail.gmail.com>
Subject: Re: [PATCH net-next 3/3] net: mhi: Add mbim proto
To:     Dan Williams <dcbw@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        =?UTF-8?B?Q2FybCBZaW4o5q635byg5oiQKQ==?= <carl.yin@quectel.com>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 1 Feb 2021 at 19:17, Dan Williams <dcbw@redhat.com> wrote:
>
> On Fri, 2021-01-29 at 18:21 -0800, Jakub Kicinski wrote:
> > On Wed, 27 Jan 2021 18:01:17 +0100 Loic Poulain wrote:
> > > MBIM has initially been specified by USB-IF for transporting data
> > > (IP)
> > > between a modem and a host over USB. However some modern modems
> > > also
> > > support MBIM over PCIe (via MHI). In the same way as QMAP(rmnet),
> > > it
> > > allows to aggregate IP packets and to perform context multiplexing.
> > >
> > > This change adds minimal MBIM support to MHI, allowing to support
> > > MBIM
> > > only modems. MBIM being based on USB NCM, it reuses some helpers
> > > from
> > > the USB stack, but the cdc-mbim driver is too USB coupled to be
> > > reused.
> > >
> > > At some point it would be interesting to move on a factorized
> > > solution,
> > > having a generic MBIM network lib or dedicated MBIM netlink virtual
> > > interface support.
>
> What would a kernel-side MBIM netlink interface do?  Just data-plane
> stuff (like channel setup to create new netdevs), or are you thinking
> about control-plane stuff like APN definition, radio scans, etc?

Just the data-plane (mbim encoding/decoding/muxing).

Loic
