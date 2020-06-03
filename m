Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1734F1ED844
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 00:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbgFCWB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 18:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbgFCWB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 18:01:26 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 086CEC08C5C0
        for <netdev@vger.kernel.org>; Wed,  3 Jun 2020 15:01:25 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id u16so2306209lfl.8
        for <netdev@vger.kernel.org>; Wed, 03 Jun 2020 15:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DjuJym+PsublFg582moiJsUOZJe22SXedKsqGHkAckk=;
        b=oT8TZ971FdMM5yuhEXC+A+MmgcygUww76d7BgzSeIQRFr34EBrMwMsTsPmBqEUKz9e
         CON19Wp5FznPUS7Ec9MexcUaTDUFbPnmMILNOACM1LQJK26msIMmhbDUjcATLicJKvcn
         LX/z2q4a2B2CWr1e9m44mIjB1fRvM3ecceStF3BqBg5QUJreQIlCYx3zRA6E7L8OA9Ne
         A3vOgAT2e9XEooA/j0T+GPWL6+YRLuvs7dIrWCQDJ/ejpzdCA5Yv607xVwdkA9+Fj1fP
         t81JbkJ53ApJdYCz0NuWoGatca3UYsZYclNwiJRv8WmDB1xRUGGaTZqJQATCDWHOlH7F
         /BXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DjuJym+PsublFg582moiJsUOZJe22SXedKsqGHkAckk=;
        b=ET7WIQsCsmblOrgDVjbymldgfwz4UCyLJby9pLonwwfjElbYcZggWcEj89NoiSFQgn
         dytgVCp0kCzVsYdZdHoPGK5B2NS/oHFed0g8hhqBwj4SjmcM3l/nPTgDZv8QeEUi+rSn
         CtjYYXwtEkRZ1G0q+9i26iL3VNPJc2Hn1jfwEQIs4o/t9sm3HG1XeZ0v05E5LqkQQRtA
         1/aaZX732xTN3zQwjcfv+CYfy0d99JLdQUW+j1b9n41lRwfh/P2iCYbUbiG09Vz+ps0H
         RHCEB/dAOna+bdR6x9MfI+MumpwpF7aIvpFcBHgOLlZYvaQ8g9+8s8yRoUR/t0wKV5Jg
         bxKg==
X-Gm-Message-State: AOAM532mjVXFxVr1LK0iWJ8kQaoraalxnLVoItlYsT67hvrZkDFwPFjh
        dndluUREp0n0LkIn+RikHCKUz5/r9WyfiDRF1E7CSw==
X-Google-Smtp-Source: ABdhPJzOW4KTX5hNsWdI70EEKwbyfr3lhSIsyfeuj3oWDY+jlnlisjMqzDN36DWTirM3zIUnhjYGKPZdXbD1gV4patA=
X-Received: by 2002:ac2:5cd1:: with SMTP id f17mr760474lfq.4.1591221683350;
 Wed, 03 Jun 2020 15:01:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200602205456.2392024-1-linus.walleij@linaro.org> <20200603135244.GA869823@lunn.ch>
In-Reply-To: <20200603135244.GA869823@lunn.ch>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Thu, 4 Jun 2020 00:01:11 +0200
Message-ID: <CACRpkdbu4O_6SvgTU3A5mYVrAn-VWpr9=0LD+M+LduuqVnjsnA@mail.gmail.com>
Subject: Re: [net-next PATCH 1/5] net: dsa: tag_rtl4_a: Implement Realtek 4
 byte A tag
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev <netdev@vger.kernel.org>, DENG Qingfang <dqfext@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew!

On Wed, Jun 3, 2020 at 3:52 PM Andrew Lunn <andrew@lunn.ch> wrote:

> Do you think you are passed basic debug/reverse engineering? There are
> a lot of netdev_dbg() statements here. It would be nice to remove most
> of them, if you think the code is stable.

OK

> Is there any hint in OpenRRPC that tags can be used in the other
> direction?

It appears OpenRRPC is something totally different, but yeah
I looked in that code. I have documentation on three other tag
types: a 8 byte tag (not similar) another 4 byte tag (protocol 9)
and I looked at the RTL838x kernel code which has a third
tag format (trailer). None of it is very helpful.

> Where is spanning tree performed? In the switch, or by the
> host?

In the switch I think.
There is a register in the ASIC to set the spanning tree status
to disabled, blocking, learning or forwarding.

> That is one example where the host needs to be able to
> send/receive frames on specific ports.

No luck there I'm afraid :/

Yours,
Linus Walleij
