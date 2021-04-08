Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA8B358BA3
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 19:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232730AbhDHRqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 13:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232281AbhDHRqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 13:46:14 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ED69C061760;
        Thu,  8 Apr 2021 10:46:03 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id y124-20020a1c32820000b029010c93864955so3363411wmy.5;
        Thu, 08 Apr 2021 10:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lCKkqJ3NXKH56GSbHHisuie/Wy5x1/t4fNfwvCfwRS0=;
        b=tKdFqMXTz/ZUAylhcf0dX7Pd99h2N0h825fUOAXTdmTBgyq9zQaJMOiW5ZjEftllPn
         nCg8TKa0ArEFhK0lrR5BkPtD4rLYfKvtBoZ9MsHQ+bk1TfktmiGzqo+9PgK1NHi7NmZN
         G+ivzRd8xEKGHZjiYOfmorYT8XvXjRNUgP6ubU63330VT2M38wAzdEikpqZW/ehtMu/0
         9cnfjUesi+rFbHG8jqyn7O4sAcpmmseVEWs3IzVUWF7a7Z6ma8F9HfOUMiN9qsCFr+lT
         /J5sP0zdHIQl9ZFlCFhPYtGznp0yYdRliZYEN58amVsvZ++q4Vwi0iH9KAd68lsYLXJ8
         jsvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lCKkqJ3NXKH56GSbHHisuie/Wy5x1/t4fNfwvCfwRS0=;
        b=CQSFmKI4VDPzD2pWjSFQ4O1djwoj6GXss6yGSPpHJEU7VZBZaRegohOzbFRh9w5vvZ
         FC0wOSB/k0B6hwQwbiVl0Q4/U4T2uz3/SUCNPXcRyJhY34ri9VJL4LA19c7bgycYN2V/
         xbV07P0e2xF7kmXUKYpNdK9Xgt2oYplNdGDGSxHtfL51l6dFo0d0+iVdg46iSyFBcOW4
         GLpI3Wmr5XCRddlglWF98hJ/nhG5aQTEsi5X25RWcrG/vOdwLhjh/PeCu3MOupRzefI9
         UD4QwbsGot9BKS5wJljyRA2CtVwbYbVJPpzO0KedSceoXa1oGF+/lrEyKJfLNQi6VurW
         BNlQ==
X-Gm-Message-State: AOAM530nrw1Cq+NqOF1UceZjrn8XR1mD94ryW/GFiAdzU1FoBbcArGaC
        wwqXx60HuOxHg6/yxoOocak7CpGwD9/MbVLHNk0=
X-Google-Smtp-Source: ABdhPJxt3RfEZyGirw0ccTfdkUoOCkzCIp1zP8H80nQNbWIftSkhcWXsjOeEaug+viJNJAHmjXxTH6TEzHXPHnICnbE=
X-Received: by 2002:a05:600c:230e:: with SMTP id 14mr10077693wmo.150.1617903961136;
 Thu, 08 Apr 2021 10:46:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210408172353.21143-1-TheSven73@gmail.com> <CAFSKS=O4Yp6gknSyo1TtTO3KJ+FwC6wOAfNkbBaNtL0RLGGsxw@mail.gmail.com>
In-Reply-To: <CAFSKS=O4Yp6gknSyo1TtTO3KJ+FwC6wOAfNkbBaNtL0RLGGsxw@mail.gmail.com>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Thu, 8 Apr 2021 13:45:50 -0400
Message-ID: <CAGngYiVg+XXScqTyUQP-H=dvLq84y31uATy4DDzzBvF1OWxm5g@mail.gmail.com>
Subject: Re: [PATCH net v1] Revert "lan743x: trim all 4 bytes of the FCS; not
 just 2"
To:     George McCollister <george.mccollister@gmail.com>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi George,

On Thu, Apr 8, 2021 at 1:36 PM George McCollister
<george.mccollister@gmail.com> wrote:
>
> Can you explain the difference in behavior with what I was observing
> on the LAN7431?

I'm not using DSA in my application, so I cannot test or replicate
what you were observing. It would be great if we could work together
and settle on a solution that is acceptable to both of us.

> I'll retest but if this is reverted I'm going to start
> seeing 2 extra bytes on the end of frames and it's going to break DSA
> with the LAN7431 again.
>

Seen from my point of view, your patch is a regression. But perhaps my
patch set is a regression for you? Catch 22...

Would you be able to identify which patch broke your DSA behaviour?
Was it one of mine? Perhaps we can start from there.

Sven
