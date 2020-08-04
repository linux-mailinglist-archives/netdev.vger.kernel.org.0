Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D997923B876
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 12:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729407AbgHDKHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 06:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728311AbgHDKHw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 06:07:52 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E83C06174A;
        Tue,  4 Aug 2020 03:07:51 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id z20so1820652plo.6;
        Tue, 04 Aug 2020 03:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oJdxWGQYUK1/0Tk5To4OdiSJhwKCWBDTC5eP+NtdeJU=;
        b=Uv2wL9/B0Zh+y88bUQ/S771LAewriGVxI8lSuTGvu1TBIvGZ+3Gc90rSJCs60kBV0e
         4/7UfBuaNQa/VmFJagebEKIf/bMHZhakzZf1tWahBg3byESGrXKdJKQfwB2W/S1FzU5B
         HXVG4XnprmC6Ni1seBLNhDRza+3ouyewoA99x8V+OiQGCojsjcoXg4JlaHI1jYx3aG8a
         b/4CwrytoOOAxzBPvcsh7LjTciaGvcPoFqUQ5K27z+2B0ZRRgLS1VIOmEHvdJSY8byNh
         rHCmtElC//YwQ4qwUusX9LJhPgPwbqQZXl8xCM/MUaECiQT7E/8Bi1ywlSm1Isn23tRw
         5huA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oJdxWGQYUK1/0Tk5To4OdiSJhwKCWBDTC5eP+NtdeJU=;
        b=jMwug148g9T5urHwMCblF+n+cFiG2aIoROBGvkyGuoZppucAMB2M3dHnTwwOXSzvbC
         TwdtZtLEv2Tvwzz06o/1wHDlRusH/lksmIsiM4R6mg+IH0ns0vfcJrqnOJRLqhFP3A33
         rqUmRjZr/0KceVzcCqBPCOvtF1GgxKKB7Mc8/tElbZCgqaMizUjGRvF1CeA3aAEXOzcm
         Cv4OVCEi04KSZxERNRDHgtaZGLQEihimQ/S4bPI7E1fwmhC1vNfcU7pNbsMfzUL73Kzu
         UjHOP9jRDsVklQXWLcVWXneT9EASWSqfVWUrT61Rt+UoFZ57FECibqRDTyfbXvjwNY+9
         0CwA==
X-Gm-Message-State: AOAM531nCmDqkF9tDoD1U6jEQmr/LFJ/lzMz869b8z9fEGVHkx5by+RY
        guSLCQOZeNEWP5HunJXm8dwhEtK37K1m1hP0eYo=
X-Google-Smtp-Source: ABdhPJzKBZruPonTXVRdrVWPQ51pluAyZm8JDgUWVMUntZwTCguj1qNB4a6zBs1FUB/na2VFL3NipjZZb44qT+6Mftw=
X-Received: by 2002:a17:90b:128e:: with SMTP id fw14mr3808101pjb.66.1596535671522;
 Tue, 04 Aug 2020 03:07:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200730073702.16887-1-xie.he.0141@gmail.com> <CAJht_EO1srhh68DifK61+hpY+zBRU8oOAbJOSpjOqePithc7gw@mail.gmail.com>
 <c88c0acc63cbc64383811193c5e1b184@dev.tdt.de> <CA+FuTSeCFn+t55R8G54bFt4i8zP_gOHT7eZ5TeqNmcX5yL3tGw@mail.gmail.com>
In-Reply-To: <CA+FuTSeCFn+t55R8G54bFt4i8zP_gOHT7eZ5TeqNmcX5yL3tGw@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Tue, 4 Aug 2020 03:07:40 -0700
Message-ID: <CAJht_EOeCpy_SLKk2KXJHBj79VCujUZWiZou_BDfMr+pVWKGPA@mail.gmail.com>
Subject: Re: [PATCH v2] drivers/net/wan/lapbether: Use needed_headroom instead
 of hard_header_len
To:     Willem de Bruijn <willemb@google.com>
Cc:     Martin Schiller <ms@dev.tdt.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 4, 2020 at 12:06 AM Willem de Bruijn <willemb@google.com> wrote:
>
> > BTW: The linux x25 mailing list does not seem to work anymore. I've been
> > on it for some time now, but haven't received a single email from it.
> > I've tried to contact owner-linux-x25@vger.kernel.org, but only got an
> > "undeliverable" email back.
>
> That is odd. It is a vger hosted list.
>
> I'm not subscribed, but indeed the spinics archive ends in 2009 and
> the other archive link resolves to something that is definitely not
> X.25 related.
>
> http://vger.kernel.org/vger-lists.html#linux-x25

Maybe we could contact <majordomo@vger.kernel.org>. It seems to be the
manager of VGER mail lists.
