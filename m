Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2BE63D89B9
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 10:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235371AbhG1IYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 04:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235070AbhG1IYT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 04:24:19 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A7A7C061757
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 01:24:18 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id c3so1898416ilh.3
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 01:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=omd/1SeMY2p1KwQ68qQgqLrMpU5rLhs6hW4OZ6EqVao=;
        b=DhbRAwsCbfDhDyg3qozsu6aQqCi78QGxEVQAOtVPEIe+91lKB+K0r1dNKG36DX3Odm
         sUzW7wRRHTMzTAbPZ/kyGS+uV9b1ZuQwptdsfgmTDh4GpetO+ZSMC3OoCSeu/LdRf5mN
         R0WenLG3jJFjDFlur4fHNzx5QmOk285ArZkDSopNGlo5gsn1G7kOIDeiYVvljCUZDZpk
         +yWZ5PS3FZOJNzyM52xblX7lwGKWNZDdvLjstMLuQnkH8+MHRS/wR2U/9eF//IvLEtTf
         rtgP83bzrM/9FTtkzTfDHq5r2kUbGgtPKnbl77ggkE+7xYDayS+I4kgoJX+GNX5cXcKf
         oM+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=omd/1SeMY2p1KwQ68qQgqLrMpU5rLhs6hW4OZ6EqVao=;
        b=Y8FtZTRWD4WkzGBekKTY14QQh/U5dGuFZ+BPgsPXjHBbUxc0BSCgPP+yH4o9rk4tvl
         YcETl5qrjG4MaJV3uD2B5Ae7CI4QbikOQ388paCg+LE2DO5F6qcA6wY3+uQFnD1POjYA
         p4fdd34osqsdW2ODvOhycUBEAMbV98w+tdXb7dfQaIt491SCFm/k0srqvw8arG60XZvC
         QsvWUsuCHBYVDsRE3eodNPUllmU2Vb5Xg4H3MGEgPIPp3ysqGU/OxW1p1dx79Kt/82VB
         aQwhjT/Ffe59utgp+bEQ2/x/V6oYUrHDYwdd811ZKL5pjmv5bPPeFtFyXfSZ6gPFr8Qu
         y+Lw==
X-Gm-Message-State: AOAM530hBVBt7341+uKQmRunTpX8u9n4KWNv9C2OrknwZ6qVbRfa0mA9
        0lztP31e53Jl+khK32LjuBGomtwqSABsWPuDLg5YZSjcLOlGwoiM
X-Google-Smtp-Source: ABdhPJylcOgm9kOTb+2MslpnGeIT4+c72Va9hxQ2TRtKnwQcTIJZaaWVTT3rxafvYmck+V2+pGvfMsWxJkr0eHaZPnE=
X-Received: by 2002:a92:cec5:: with SMTP id z5mr18570399ilq.226.1627460657663;
 Wed, 28 Jul 2021 01:24:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210726194603.14671-1-gerhard@engleder-embedded.com>
 <20210726194603.14671-5-gerhard@engleder-embedded.com> <YP8pM+qD/AfuSCcU@lunn.ch>
 <CANr-f5y7eVbAf_NK3puJa3AcnkLXMbhzfwwmZ+r2KuWMbDhhsA@mail.gmail.com> <YQCLg3iLubJW+3yB@lunn.ch>
In-Reply-To: <YQCLg3iLubJW+3yB@lunn.ch>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
Date:   Wed, 28 Jul 2021 10:24:06 +0200
Message-ID: <CANr-f5wYUK4R_XsujwvhSbz-t3==UefQ9VM9kgoaP+Y-Qs_Aww@mail.gmail.com>
Subject: Re: [PATCH net-next 4/5] tsnep: Add TSN endpoint Ethernet MAC driver
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 28, 2021 at 12:41 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > I also expect some discussion about this feature. Mapping device specific
> > TX/RX queues to user space is not done in mainline Linux so far.
>
> That is probably not quite true. I expect GPUs do it, or at least
> something very similar.
>
> > I will follow your suggestion and drop tsnep_stream.c for the moment.
> > Any early comments about this feature are welcome, because the direct
> > use of additional TX/RX queues for real-time communication is the main
> > feature of this device.
>
> I know enough to know i don't know enough about cache management from
> user space to be able to make any sensible recommendations.
>
> You probably want to start a discussion with the XDP people and get
> them to agree XDP does not work for your use case. Also, the people
> who implemented zero-copy, MSG_ZEROCOPY and make sure that is also
> unsuitable. Then see if you can reuse some GPU code which has been
> well reviewed and tested. You will get less pushback that way,
> compared to your own code which will need a good review by somebody
> who understands all the issues.

I will try to follow your suggestions. Thanks!

Gerhard
