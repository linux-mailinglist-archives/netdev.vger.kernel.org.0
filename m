Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5520D29F8F1
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 00:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725837AbgJ2XPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 19:15:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgJ2XPk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 19:15:40 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1888C0613CF;
        Thu, 29 Oct 2020 16:15:40 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id o9so2029823plx.10;
        Thu, 29 Oct 2020 16:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CUboJG1MFc205Dz+KzoBDHajCGO3lFF+AE+k3E7pJRs=;
        b=ajuNtNU9hFA6GOflitNgWcF+HHMoS7lMJ01KhPXwJMAjnOZP9uhFD8zvPDo2pxqIZw
         IcrbFCbmUZ/FSKJsSdWIQs3W6OX3fo2yP8gxqALj89jPVGXjcq9zMKjs9WXgZJetqIen
         AckHffd4j+dCW0W9G0nJDkOqHU7dKQ9oDopIhIx32jS9xG5QuDMz0qQyIF5Zua5jr3fW
         pQ80zje1Ktcc2oLj847GcSJSCSKTJESyOCgVydTTPzOFVj18LOgxzMny1CmyZIgmN/2U
         CCQYXATFD0yH7hi4kYDAFCt7qez79HEyCbmQV5xeGTOUSyY/JoXP6UNEfE5x8QPMPi85
         V2DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CUboJG1MFc205Dz+KzoBDHajCGO3lFF+AE+k3E7pJRs=;
        b=OP00m2Ueh/SoIfZsUTWZRqxAWWH8LCGuJnZ7oGdNhkU3YCJRMgU0BedDUp8d6v8bmy
         7qaW6ccG/cQRCGAlryEhGFMwl5GAiiai9op3LhAN/wRBku6TopEE6orNWfBftNTiJR5F
         1BkZtAqkiVBH40cFUKNwNw1g8sfmXGeX8jCsYg9hpqzebyGi3cBbYm3cQgnSrli2bogH
         Enm1DiGV1+JfWPTpOL+LvkYJr8rQ9EWMkHisurP/jhTgyAB90rzNXW2ih2bOeJb0lUvj
         YZwRwxR0IHt2v1aVmR8y6sX1XBQPH7ECI/lvv6cxrk//s75K7aKCa61LIBTTwXMovHRK
         Yt0g==
X-Gm-Message-State: AOAM531KIyTACoy2xjXQBeuaQp2D51jNVa391vqQEiUMyHuugblhnqgT
        ybqpTgeUU5d2n78ZKy3PCNPe2BbbCi50RaaNcTE=
X-Google-Smtp-Source: ABdhPJxkXE3b0LH1pbbkUSyEkdlF3AN9xkchzBPhUutxzuc4gTxndbGdLHOSrST+lGxIAPCxzFj0PCm9+6ATjJZjod8=
X-Received: by 2002:a17:902:9a05:b029:d6:8672:ca8b with SMTP id
 v5-20020a1709029a05b02900d68672ca8bmr6005043plp.77.1604013340126; Thu, 29 Oct
 2020 16:15:40 -0700 (PDT)
MIME-Version: 1.0
References: <20201028184310.7017-1-xie.he.0141@gmail.com> <20201028184310.7017-3-xie.he.0141@gmail.com>
 <CA+FuTSf_Veb8Pexix5_Nx3Ujm3P+d=0VNx6hhzPsyoBBdwQ=BQ@mail.gmail.com>
In-Reply-To: <CA+FuTSf_Veb8Pexix5_Nx3Ujm3P+d=0VNx6hhzPsyoBBdwQ=BQ@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Thu, 29 Oct 2020 16:15:29 -0700
Message-ID: <CAJht_EPzFiNXjOLgPTrJbMU=e_akB0bEK1zib0SCtVWCvm5sbA@mail.gmail.com>
Subject: Re: [PATCH net-next v3 2/4] net: hdlc_fr: Change the use of "dev" in
 fr_rx to make the code cleaner
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Krzysztof Halasa <khc@pm.waw.pl>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 9:58 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> No need for dev at all then?

Right, there's no need for "dev" at all actually. I kept "dev" just to
keep the code for updating "dev->stats" simpler, because otherwise we
need to write "skb->dev->stats" instead, and there are 3 lines where
we need to write it.
