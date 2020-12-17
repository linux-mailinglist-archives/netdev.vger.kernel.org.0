Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF3D2DDAD9
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 22:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728184AbgLQVaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 16:30:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726689AbgLQVaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 16:30:14 -0500
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3053DC0617A7
        for <netdev@vger.kernel.org>; Thu, 17 Dec 2020 13:29:34 -0800 (PST)
Received: by mail-ua1-x933.google.com with SMTP id y26so131325uan.5
        for <netdev@vger.kernel.org>; Thu, 17 Dec 2020 13:29:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=urAPcSZI0AoxV640vCzvFnC8SN1UrtzLHnxgpBxd1pM=;
        b=r9UT9t38JUuZdqamQnu/y5XIuGAOfcGFq0OYmGBBVEMkSphsxKepRxZRSQcmPmDZh+
         vvvfi+BmN0AFkHEgjRIQDXJdTjK4XHyPDC2zm0NtCfH8EkknSsOIUrlcaNzw8CbLCs4I
         8/2/+j9+vYK7q6kZiUAigTC4UObyW7dqO3Uj0jUMk+IdWuy6sDMaQrJO+l8ggxS+nVzY
         5luNtNIvzN7oFlhIM6l+Sey8mRuI6HUMSxRaGLcAsw2eU21Hcaz05ETKv1CcTAwSLUa0
         Qq1yR78NgmSuuc0ONk0PcxrO1+cpOIp6umMgPykCXA60vFgEA4O+CGPcTb5lAuVU8EdP
         4+Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=urAPcSZI0AoxV640vCzvFnC8SN1UrtzLHnxgpBxd1pM=;
        b=sSbHfP9YovLcbm59MijjLVjuMscwC7oio7bCkFoeseO6q8r/lr+Xx2KWr9f/7sKpCB
         YG8yA58j4eO0/yex52GCqYRwpSYBnVV5MGyh8UqHpaqvZ/zR97zZx/i8b91RTAvHUhxO
         urH3Ga5YKe6RRqY2uGT7Xjsyct/HHNYNetymaE7Grg0WlZaEAtDxIVJTk0QRaT1s+59Z
         NouxWvMTLsgByMJGMjn4RNaNuJo5tPL5XvJVsTcZzJ90FBp9wx1+FkVcOk6WtDH9ymHV
         nnhdbudA70Qa7cMa9qqtLkOqHwEdgMPDtAXy+BKKefs/vHn/7wxi+LfKYFuzjYUnsP1+
         O6BA==
X-Gm-Message-State: AOAM533/sXGkDwbknJVhEPr1zxrzLbgyFqWBecpYN6uycU8c4TKo5DGv
        8O9J1uBgVoSfzNC6TFzThdnI1WjXqmY=
X-Google-Smtp-Source: ABdhPJz9qTeAeqLdXpR1SR5ZkAjmu0ZGv331k4HdLiDoL4T4MsQ68dTFHSeb/XDxS3vVXSE1p9rufg==
X-Received: by 2002:ab0:6ed0:: with SMTP id c16mr1067729uav.137.1608240572422;
        Thu, 17 Dec 2020 13:29:32 -0800 (PST)
Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com. [209.85.222.52])
        by smtp.gmail.com with ESMTPSA id s204sm1035408vkb.27.2020.12.17.13.29.31
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Dec 2020 13:29:31 -0800 (PST)
Received: by mail-ua1-f52.google.com with SMTP id y21so136129uag.2
        for <netdev@vger.kernel.org>; Thu, 17 Dec 2020 13:29:31 -0800 (PST)
X-Received: by 2002:a9f:2356:: with SMTP id 80mr1166550uae.92.1608240570490;
 Thu, 17 Dec 2020 13:29:30 -0800 (PST)
MIME-Version: 1.0
References: <425a2567dbf8ece01fb54fbb43ceee7b2eab9d05.1608051077.git.baruch@tkos.co.il>
 <1fc59ef61e324a969071ea537ccc2856adee3c5b.1608051077.git.baruch@tkos.co.il> <20201217102037.6f5ceee9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201217102037.6f5ceee9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 17 Dec 2020 16:28:54 -0500
X-Gmail-Original-Message-ID: <CA+FuTScTEthUW=s+5_jnnHj4SQeFr0=HsgwVeNegNOaCNQ+C=Q@mail.gmail.com>
Message-ID: <CA+FuTScTEthUW=s+5_jnnHj4SQeFr0=HsgwVeNegNOaCNQ+C=Q@mail.gmail.com>
Subject: Re: [PATCH net 2/2] docs: networking: packet_mmap: don't mention PACKET_MMAP
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Baruch Siach <baruch@tkos.co.il>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        =?UTF-8?Q?Ulisses_Alonso_Camar=C3=B3?= <uaca@alumni.uv.es>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 17, 2020 at 2:48 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 15 Dec 2020 18:51:17 +0200 Baruch Siach wrote:
> > Before commit 889b8f964f2f ("packet: Kill CONFIG_PACKET_MMAP.") there
> > used to be a CONFIG_PACKET_MMAP config symbol that depended on
> > CONFIG_PACKET. The text still refers to PACKET_MMAP as the name of this
> > feature, implying that it can be disabled. Another naming variant is
> > "Packet MMAP".
> >
> > Use "PACKET mmap()" everywhere to unify the terminology. Rephrase the
> > text the implied mmap() feature disable option.
>
> Should we maybe say AF_PACKET mmap() ?

I don't think that the feature name PACKET_MMAP implies
CONFIG_PACKET_MMAP, or thus that the name is obsolete now that the
latter is.

If it needs a rename, the setsockopt is PACKET_[RT]X_RING. So, if this
needs updating, perhaps PACKET_RING would be suitable. Or TPACKET,
based on the version definitions.
