Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 653839F4A2
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 22:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728312AbfH0U6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 16:58:52 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:42167 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726735AbfH0U6w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 16:58:52 -0400
Received: by mail-yb1-f194.google.com with SMTP id z2so46346ybp.9
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 13:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PTZCSYaWdxKl4RxEaoywUui8WrMcztkIhxCZbzEZ7fY=;
        b=podREHlM9KOEWblZW55cZzmlvhYB8p722jMlTIdcI7YjkKy96x2Kv7i/wL5sGsG5cc
         kWDO6TbnBvbazmV9g+QFF0MPhlIAl8o10QzdySvkJWyKaCHf8QqcY9fYiEWV3estTx04
         tNPvGm2/ADHzD0DLwmwszAoDE/vMygH1FpMc+x5Dn8yyVeD391dHhhn4ZMx6/RfXGwaP
         ehrTDmlU8yVoOMJXlpnlV51VLY9GFqQ5EJAUJm6RoIKNdwptQyXDRtA/WSx58vPQw9Nn
         d8fv6g5q7rFpxPCkrxOinNP8b6k9v621mWyM0mZGk2hLhBfEHUBmPanRIkRZJ3PSirMc
         rO6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PTZCSYaWdxKl4RxEaoywUui8WrMcztkIhxCZbzEZ7fY=;
        b=OPvnl2tjD4vcg8KlCBreTVWkiGBYUOIB30SVxExk2/tRMGC+BCN06TW68AeeLbuwXQ
         W7VwN4/1eV5RYnh4Y0hgDr9tU5AfSp0wT23b23VSvJG46Y3Gw6fg6tXTrrrqRNs2jn2N
         rsC8xrtMGeqO2ZEV0g6Je62cCSgFzDJlMNohb4V+LtI6DrPsjBaHdhVFiagkKsclj2gN
         neUymm3novrotDncugnjZ8euZhXwL1tc4pY88RZeXxroHwUaR6bSozQvFHe960LEuchV
         Vg0cJzCcv1KMYc/c2f+khYPxI2cKPzQWZyi0NWEhnVSKHkXG8JQ3Gme+VPOnp/sCGWGK
         4vpQ==
X-Gm-Message-State: APjAAAV5hD6u+aZSGJ0SqM0ebqfXpn2v+mRFi7Qs48C1kau9664slqR+
        D63l0W5wwuf8dSATj3F68jUCRbn2w8g7n44F26cL7g==
X-Google-Smtp-Source: APXvYqwGQWwWpghcPgpODku2vBUQiiJipR9vyG4oCEt3XMv80ThETSlXBtZVmr22gif3pOUw9ptQbvuUatQrB8uUsPg=
X-Received: by 2002:a25:1f41:: with SMTP id f62mr601002ybf.518.1566939530965;
 Tue, 27 Aug 2019 13:58:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190827190933.227725-1-willemdebruijn.kernel@gmail.com>
 <CANn89iKwaar9fmgfoDTKebfRGHjR2K3gLeeJCr-bvturzgj3zQ@mail.gmail.com> <CA+FuTSfK=xSMJvVNJB7DKdqwG_FAi2gLjbCvkXVqF99n71rRdg@mail.gmail.com>
In-Reply-To: <CA+FuTSfK=xSMJvVNJB7DKdqwG_FAi2gLjbCvkXVqF99n71rRdg@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 27 Aug 2019 22:58:39 +0200
Message-ID: <CANn89i++59nk_RFMOgor6XL3ZZY7t9QLa70sppKe6eQBrObagQ@mail.gmail.com>
Subject: Re: [PATCH net] tcp: inherit timestamp on mtu probe
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 27, 2019 at 10:54 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:

> Sure, that's more descriptive.
>
> One caveat, the function is exposed in a header, so it's a
> bit more churn. If you don't mind that, I'll send the v2.

Oh right it is also used from tcp_shifted_skb() after Martin KaFai Lau fix ...
