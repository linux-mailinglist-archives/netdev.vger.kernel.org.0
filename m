Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B95CF4A2C0
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 15:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729592AbfFRNsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 09:48:53 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:35096 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726158AbfFRNsw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 09:48:52 -0400
Received: by mail-qt1-f194.google.com with SMTP id d23so15363849qto.2;
        Tue, 18 Jun 2019 06:48:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=adlKPrwpF847OzhxpvAIaUJHnKpv+DcgWsB6FU5ma+M=;
        b=g28SISNBz50q7A99LjE5M18cWIZlm6vRN+3UCA7OqcaxUDZecvAOeTl4512khAESXt
         hjq7Qecf9LP2QhYgLS85/oIlUTSm+bX68dGrmSfkbxjPqdY2pGgf9zCh0b7IAaKvpHW/
         GPmBIyABkND63KP/u0j82NJmz3+qRBSA+hrjdyPNlXWWKBsnsdGQFUuFI7STv2LnMOqj
         M7Sd4K8HVmboM532kxixvZ6WwT13c69N9+/gQ3Wx9DSdwuzC2KsG6Z2/pTOYL2cXSrFv
         588HvWsbm7sgBzZ4gb0C29CUCFIK3vTrq8qYhzO33ypusWtuSveFB0tciOQeM6HdYjGI
         SzRg==
X-Gm-Message-State: APjAAAX8OaYUjEQMYD6xHb5nzFLkvi8w2xK0ii6NUDdLYyJPGATzt47B
        t0lJXcmekMcFCQStj0HX/tPMdEi0gTxhXBLXYYNUWsMrYz0=
X-Google-Smtp-Source: APXvYqwe5peIXb0dsyQ2lB/6iiVZYwjfA6+1m0/GVEMvpLamKwpY6BkfJDyFTbULruc/oWfp/h23fC2OdT9a520+YBw=
X-Received: by 2002:a0c:8b49:: with SMTP id d9mr26718089qvc.63.1560865731462;
 Tue, 18 Jun 2019 06:48:51 -0700 (PDT)
MIME-Version: 1.0
References: <380a6185-7ad1-6be0-060b-e6e5d4126917@linaro.org>
 <a94676381a5ca662c848f7a725562f721c43ce76.camel@sipsolutions.net>
 <CAK8P3a0kV-i7BJJ2X6C=5n65rSGfo8fUiC4J_G-+M8EctYKbkg@mail.gmail.com>
 <066e9b39f937586f0f922abf801351553ec2ba1d.camel@sipsolutions.net> <b3686626-e2d8-bc9c-6dd0-9ebb137715af@linaro.org>
In-Reply-To: <b3686626-e2d8-bc9c-6dd0-9ebb137715af@linaro.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 18 Jun 2019 15:48:32 +0200
Message-ID: <CAK8P3a0sL+nPmduZd=DNSsntq62e+o3upYsWg=iPNwzvgBp+Mg@mail.gmail.com>
Subject: Re: [PATCH v2 00/17] net: introduce Qualcomm IPA driver
To:     Alex Elder <elder@linaro.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>, abhishek.esse@gmail.com,
        Ben Chan <benchan@google.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        cpratapa@codeaurora.org, David Miller <davem@davemloft.net>,
        Dan Williams <dcbw@redhat.com>,
        DTML <devicetree@vger.kernel.org>,
        Eric Caruso <ejcaruso@google.com>, evgreen@chromium.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-soc@vger.kernel.org, Networking <netdev@vger.kernel.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        syadagir@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 18, 2019 at 3:16 PM Alex Elder <elder@linaro.org> wrote:
> On 6/17/19 6:28 AM, Johannes Berg wrote:
> > On Tue, 2019-06-11 at 13:56 +0200, Arnd Bergmann wrote:
>
> I'm probably missing something, but I think the checksum
> offload could be handled by the IPA driver rather than
> rmnet.  It seems to be an add-on that is completely
> independent of the multiplexing and aggregation capabilities
> that QMAP provides.

My best guess is that it is part of rmnet simply because this can
be done in a generic way for any qmap based back-end, and rmnet
was intended as the abstraction for qmap.

A better implementation of the checksumming might be to split
it out into a library that is in turn used by qmap drivers. Since this
should be transparent to the user interface, it can be moved
there later.

> >>> If true though, then I think this would be the killer argument *in
> >>> favour* of *not* merging this - because that would mean we *don't* have
> >>> to actually keep the rmnet API around for all foreseeable future.
>
> This is because it's a user space API?  If so I now understand
> what you mean.

Yes, I think agreeing on the general user interface is (as usual) the
one thing that has to be done as a prerequisite. I had originally
hoped that by removing the ioctl interface portion of the driver,
this could be avoided, but that was before I had any idea on the
upper layers.

     Arnd
