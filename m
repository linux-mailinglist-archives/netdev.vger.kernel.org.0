Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70B6B2532AB
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 17:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgHZPAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 11:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727814AbgHZPAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 11:00:08 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43D2DC061574
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 08:00:08 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id x2so856262vsp.13
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 08:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5cIrV1+eukb/f7OdTc7tq6XgEUP4mZGFJru/50URUMY=;
        b=YHyQ/xBUhtFHvOrFF3UrWSkOcu/b+WObqZLusFpr+CAy9aLKPqx2nl3/R1G55PM5rM
         Ut5WswiLQokx9h9jrbq3Ek908ApWEOUrVxg/RQb9Yp5moKaOCMirA5eND+GlAGyDqj0c
         4NlIbZzFtrOxh9pAwhk/GLNjPCbwB6FvBpQGM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5cIrV1+eukb/f7OdTc7tq6XgEUP4mZGFJru/50URUMY=;
        b=InbSj8XchB8CRAQmCC13EbcNN8bCc3qIv0OXO2o6AIWzjOqYjQxdx4QyuSeg7p4am4
         uheRf8ippOFGOrheWOmN7Wd7nmSP2ZOoW4zo6cZjl8TaTrkzipuwTxSyqFf/6mdlNJ0D
         IgeKCHPBqjNNr0dndJQwmj6gg3ph681AkSlSFBzIBhE+tZl9ji+0+iFsqch0ZaXz1RXd
         wbL21iYGHbXY+qfR/jxiiH71Mn3v/KW+zdui75RMrQX4VYSgaXMufbbP9X4OUEldv3Wq
         uN6zSru5qw/kHrrZsZppKLbVVOlbUqDZnc1DjzuuI0qXarj7yXpZrUHP/bdKx9ffNr9L
         dOMQ==
X-Gm-Message-State: AOAM530ntXFchRClpiOwEMaxA+Qax10swT5t6q6rv1vYR/+Rk0bFhfv1
        5dgVNUuJcMLxOc2QJNbizpnhkVNKCrddZg==
X-Google-Smtp-Source: ABdhPJyQvngHB2WRb3kAzgma7zMbO8lP2I5IImoF7gH9THXYEOZStJihdiijrDuYAGbXwywgbI3r9A==
X-Received: by 2002:a67:8c89:: with SMTP id o131mr2837423vsd.41.1598454006607;
        Wed, 26 Aug 2020 08:00:06 -0700 (PDT)
Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com. [209.85.221.176])
        by smtp.gmail.com with ESMTPSA id j15sm439540vki.8.2020.08.26.08.00.05
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Aug 2020 08:00:06 -0700 (PDT)
Received: by mail-vk1-f176.google.com with SMTP id x142so499887vke.0
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 08:00:05 -0700 (PDT)
X-Received: by 2002:a1f:fc02:: with SMTP id a2mr9424339vki.65.1598454005234;
 Wed, 26 Aug 2020 08:00:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200709082024.v2.1.I4d2f85ffa06f38532631e864a3125691ef5ffe06@changeid>
 <20200826145011.C4E48C43387@smtp.codeaurora.org>
In-Reply-To: <20200826145011.C4E48C43387@smtp.codeaurora.org>
From:   Doug Anderson <dianders@chromium.org>
Date:   Wed, 26 Aug 2020 07:59:52 -0700
X-Gmail-Original-Message-ID: <CAD=FV=Uu4dnzeTB+DfecO5uZSJWjq4qbi4=Uwgy-QwPphLApBw@mail.gmail.com>
Message-ID: <CAD=FV=Uu4dnzeTB+DfecO5uZSJWjq4qbi4=Uwgy-QwPphLApBw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] ath10k: Keep track of which interrupts fired,
 don't poll them
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     ath10k <ath10k@lists.infradead.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Rakesh Pillai <pillair@codeaurora.org>,
        Abhishek Kumar <kuabhs@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Aug 26, 2020 at 7:51 AM Kalle Valo <kvalo@codeaurora.org> wrote:
>
> Douglas Anderson <dianders@chromium.org> wrote:
>
> > If we have a per CE (Copy Engine) IRQ then we have no summary
> > register.  Right now the code generates a summary register by
> > iterating over all copy engines and seeing if they have an interrupt
> > pending.
> >
> > This has a problem.  Specifically if _none_ if the Copy Engines have
> > an interrupt pending then they might go into low power mode and
> > reading from their address space will cause a full system crash.  This
> > was seen to happen when two interrupts went off at nearly the same
> > time.  Both were handled by a single call of ath10k_snoc_napi_poll()
> > but, because there were two interrupts handled and thus two calls to
> > napi_schedule() there was still a second call to
> > ath10k_snoc_napi_poll() which ran with no interrupts pending.
> >
> > Instead of iterating over all the copy engines, let's just keep track
> > of the IRQs that fire.  Then we can effectively generate our own
> > summary without ever needing to read the Copy Engines.
> >
> > Tested-on: WCN3990 SNOC WLAN.HL.3.2.2-00490-QCAHLSWMTPL-1
> >
> > Signed-off-by: Douglas Anderson <dianders@chromium.org>
> > Reviewed-by: Rakesh Pillai <pillair@codeaurora.org>
> > Reviewed-by: Brian Norris <briannorris@chromium.org>
> > Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
>
> My main concern of this patch is that there's no info how it works on other
> hardware families. For example, QCA9984 is very different from WCN3990. The
> best would be if someone can provide a Tested-on tags for other hardware (even
> some of them).

I simply don't have access to any other Atheros hardware.  Hopefully
others on this thread do, though?  ...but, if nothing else, I believe
code inspection shows that the only places that are affected by the
changes here are:

* Wifi devices that use "snoc.c".  The only compatible string listed
in "snoc.c" is wcn3990.

* Wifi devices that set "per_ce_irq" to true.  The only place in the
table where this is set to true is wcn3990.

While it is certainly possible that I messed up and somehow affected
other WiFi devices, the common bits of code in "ce.c" and "ce.h" are
fairly easy to validate so hopefully they look OK?

-Doug
