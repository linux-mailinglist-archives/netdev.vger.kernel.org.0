Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A31C44E205
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 07:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232430AbhKLGq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 01:46:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbhKLGq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 01:46:29 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02346C061766;
        Thu, 11 Nov 2021 22:43:39 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id f8so33926519edy.4;
        Thu, 11 Nov 2021 22:43:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mXSkFnc6W0uhF72QqlDzmJCFzXvpezEdkesJtVNnp3E=;
        b=UpRk14MJ7uYWNUuWq6RGfSl03WE0hF/rRg8e3ANeTB90dB9PQHvdgrgRwe6VL5aSnH
         6LfrlZ/Zpc6PlQFibFSYVOURI+qcjWMI7rSVy/N0GMRAN22lvWnZvotdM13snSHe0AQ0
         2OUWUTLJsnneMa7zKIneZxyqwbITw9onKJ/+yxLr8CZoOJeO8yG6u83bz0V5FaM+FLqU
         AIXRkp/iXKAG0UCgSL0eqCMMEns5d1mCCRmXyPUxYHaiRTdfIkhm9FUc6ESHwxdvhSbo
         bskx4+UDUpHjYA+R/km39C3L0gBtQ1xtJFlwFHeeMvfHTfotl3Sd9kZ198pyjgxjyKJJ
         A2sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mXSkFnc6W0uhF72QqlDzmJCFzXvpezEdkesJtVNnp3E=;
        b=w/kuWxP/2ZjLtnkyWV9SezmOTDMwYliuP7RLAQlpSjFhy+usWioPVFB5kOBsCVN2T4
         wbjChwNpCeu0L9dxDq3D3IMhV0hyWVX/TvM2hUJs8+eBtak7Ws9hVklqLhRNllv7Ymz2
         D5TXPt7YkaX8Y1vqszJEjvJ+QPFoJakj0I7aALSq7DH2xSU/3akRxiBTD0uOulBd1y0V
         MBFKkZ54gs4NBv7fsI+FqS9Ukd2k+jx//RF/KTWT5iNSYAMZq4Cwf8fn3yAMY4iiGeoT
         qja0M/5wJvWNLMAfXFkBbYl285OD5sXBc5MyeX0f7lidNlfUwUmzZ97m3Oo/0YcaNtbO
         wGLQ==
X-Gm-Message-State: AOAM5311BkL4zFaMoesNh7vOHfEJVXXfK1ZM0sCbTMfrobzsLXgTwYbW
        iIga29zhnnt8RUwXmlp9RYd+GQQGULSXw5hTNdI=
X-Google-Smtp-Source: ABdhPJwbJWR2WlmTMbOdEF6bvWmcevTpX6YpBmODKhY0/OXyhaT7s03WYdjeMHmqzQQjTteukvUzoyLBuZqOB9LuTm4=
X-Received: by 2002:a17:906:8a62:: with SMTP id hy2mr16490299ejc.347.1636699417619;
 Thu, 11 Nov 2021 22:43:37 -0800 (PST)
MIME-Version: 1.0
References: <20211111133530.2156478-1-imagedong@tencent.com>
 <20211111060827.5906a2f9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CADxym3bk5+3t9jFmEgCBBYHWvNJx6BJGdjk+-zqiQaJPtLM=Ug@mail.gmail.com> <20211111175032.14999302@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211111175032.14999302@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Fri, 12 Nov 2021 14:42:23 +0800
Message-ID: <CADxym3YzMGG3gZ1X6gc=qF182Ow0iO+782Hjn3QvnFnRhfEbRA@mail.gmail.com>
Subject: Re: [PATCH net-next 0/2] net: snmp: tracepoint support for snmp
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Steven Rostedt <rostedt@goodmis.org>, mingo@redhat.com,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        dsahern@kernel.org, Menglong Dong <imagedong@tencent.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Fri, Nov 12, 2021 at 9:50 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 12 Nov 2021 09:40:47 +0800 Menglong Dong wrote:
> > > I feel like I have seen this idea before. Is this your first posting?
> > >
> > > Would you mind including links to previous discussion if you're aware
> > > of any?
> >
> > This is the first time that I post this patch. Do you mean that someone
> > else has done this before? Sorry, I didn't find it~
>
> I see. Yes, I believe very similar changes were proposed in the past.
>
> I believe that concerns about the performance impact had prevented them
> from being merged.

I have found a similar post:
https://lore.kernel.org/netdev/20090303165747.GA1480@hmsreliant.think-freely.org/

And this is the tracepoint for kfree_skb().

I also concerns about the performance. However, with the tracepoints disabled,
they don't have any impact; with enabled, their impact is no more than the
tracepoint in kfree_skb() and consume_skb().

What's more, I have also realized another version: create tracepoint for every
statistics type, such as snmp_udp_incsumerrors, snmp_udp_rcvbuferrors, etc.
This can solve performance issue, as users can enable part of them, which
may be triggered not frequently. However, too many tracepoint are created, and
I think it may be not applicable.

Thanks!
Menglong Dong
