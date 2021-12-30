Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43C2948202C
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 21:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234067AbhL3UFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 15:05:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbhL3UFU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 15:05:20 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A7A8C061574
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 12:05:20 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id i31so56438638lfv.10
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 12:05:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4RKhw8kQqeCi7ypYjd9bDrdwnklIS2eVGLEVjN8J54s=;
        b=eAK9t/x8myCJxYly5GVAILX6Y6Jf1o1JrFOe9Qb3511fMBPSQ7EJS1gUjy5qEmbmuY
         hdNfSiG661hfn5wVK5cm2CXGSHdEXV3/sVZk+Q+uSRWc8j/cK5AF9ZPTUJ6uZgT+XLT5
         jh48WgrmAsNeQ6YZvWrnMpN54C7B7Wxv659ms=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4RKhw8kQqeCi7ypYjd9bDrdwnklIS2eVGLEVjN8J54s=;
        b=qGB844RSW49ya9/sKU9po1wTE0ZMOS/0bRQRO7jTWEbKBvGkz/itRudGIUDmXY/qPV
         7FjmW9mtlTz45jImuWb2Oo0HOpj9PNOAZSwLH0X49ZPyWj+OTEviAIcCAYyAI8OjMaOY
         7x/FJNC+L3QFQVJ5s7Q6xs9EXH05l3cRGZS+FJ0OMucOTFFD/2R/T9FQKfAsDQgjr0i6
         zAe4MSe3WGTLleD2hwuz9g1F27Iqj2lTTBrVQHEkbFtxBTvYWZrZ7Ipiw8QBYp8FMzYY
         y2f7Hcef8tvTopgVSMnt7VDjQbBcPBJYkrMJvn39plQmpaxiCQv3Y0KMilkfORAHOitk
         NPlQ==
X-Gm-Message-State: AOAM533huN8fr/Xwu79ypmp3GVnLK/FB/UtJHo3+aZkdlWSnJJgfwSTa
        v77fOiU83nvgr2QQl1nlw++t/cbZwtejpe/1BGJcp9EynjE=
X-Google-Smtp-Source: ABdhPJxJiOxGgvJJpvoM5js0xLY4NUDT4EG6IwUjuccA2GFqTuh8DCvVeCZ2IUOi4cSmxrFkUwpC4GPUi1MS76xJ1Qg=
X-Received: by 2002:ac2:511b:: with SMTP id q27mr29544886lfb.69.1640894718208;
 Thu, 30 Dec 2021 12:05:18 -0800 (PST)
MIME-Version: 1.0
References: <20211230163909.160269-1-dmichail@fungible.com>
 <20211230163909.160269-4-dmichail@fungible.com> <Yc3vDQ0cFE6vm0Ul@lunn.ch>
 <CAOkoqZ=ba_QiOdKbN==LU7gKCNSSfAbq29UJBPKB8MvX5sMJPQ@mail.gmail.com> <Yc4CUp9T/p69m7k8@lunn.ch>
In-Reply-To: <Yc4CUp9T/p69m7k8@lunn.ch>
From:   Dimitris Michailidis <d.michailidis@fungible.com>
Date:   Thu, 30 Dec 2021 12:05:05 -0800
Message-ID: <CAOkoqZn-1fz24M089gnK1bbuVBgmv9YKCSiRZm7OEwgrkD3UNw@mail.gmail.com>
Subject: Re: [PATCH net-next 3/8] net/funeth: probing and netdev ops
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 30, 2021 at 11:02 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Thu, Dec 30, 2021 at 10:33:03AM -0800, Dimitris Michailidis wrote:
> > On Thu, Dec 30, 2021 at 9:40 AM Andrew Lunn <andrew@lunn.ch> wrote:
> > >
> > > > +static int msg_enable;
> > > > +module_param(msg_enable, int, 0644);
> > > > +MODULE_PARM_DESC(msg_enable, "bitmap of NETIF_MSG_* enables");
> > > > +
> > >
> > > Module params are not liked. Please implement the ethtool op, if you
> > > have not already done so.
> >
> > The associated ethtool op is implemented. I think this module param is
> > fairly common
> > to control messages during probe and generally before the ethtool path
> > is available.
>
> It is common in order drivers, but in general new drivers don't have
> module parameters at all. Anybody debugging code before ethtool is
> available from user space is probably also capable of recompiling the
> driver to change the default value.

OK, will remove it.

>        Andrew
