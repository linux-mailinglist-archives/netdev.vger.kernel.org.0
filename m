Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7A04243791
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 11:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbgHMJX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 05:23:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbgHMJX4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 05:23:56 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAB16C061757
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 02:23:55 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id b25so3806687qto.2
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 02:23:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FlgXJkDcJ2dSEJoCJrzc6Bx/TdWFVZQ+M3dRdb+/OAY=;
        b=FHMtbofgWxbwCIlFVNWyXtrT054QygYqaR231qzBCS3ynNeGQo2r25jmNSHBGdvcyD
         PWZMlSn+1Md3dW/gocL4vsw9bvPeqX5UIK5xMa0efFGCiwHTj392+UkN+KpamILYhCdQ
         GnDAf53kD3lajvaxdhi3eMQWErE/3RY7u0+QB3didAHJnHTEW2++Airuqjx1AHS18GXV
         +XZykZOR4UcpCAwXsbKpKDFTodiKxVzPkbsPPbnXuiSE7dsk7A0QLcyQ9b6NpgHB/D3c
         NeCFquvrnDCMlJIqiHZiyclPleRa5un5CLRMLGf8fu6EGIDc9NxksKi19h0KfHkPANpR
         ILDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FlgXJkDcJ2dSEJoCJrzc6Bx/TdWFVZQ+M3dRdb+/OAY=;
        b=moLEVCHfeHxT+0aRpi67YEvzKly/DJJ6o7lyYmjl6U0BPEWqFOjaWHtrWxSXW3p5CF
         MFDbLXgqXKRXWlTyVD2bgKsLigbTiiBtgj/TEEH06iDDFoYr95e+2KjHiKNsQEfjCz+P
         R5xbG+PxUXjUwFeSjwfbhTXmUVA9X9PRCBFNZIRpdWm+Net6gcs9GCWjroqFl8w5KSjo
         n9OQBVXbzqsfIHlPMReUnAoMiaZSkU/bZT69r0ZCnTNVhkZfdvljM3ticqeJ0d1oNlij
         Gf/wZZsedIJHEz4aHqgVR/mhKUgP6jNznxu4VS82xtPGfftQwAIya61ckMfd09Bk5phB
         SQvg==
X-Gm-Message-State: AOAM532fRp90JRG/N03CPu8P4q5BRYtXkt0pe0rucqR9zJCxfXT70Pdw
        8vJs5+ti8DVDfHceWgyc39zs3SU7P2kI/fbWs5s=
X-Google-Smtp-Source: ABdhPJwgTBMwxYcwDxO9ycjEOd0NDHaGOAfpKiuoiChXfPgE/E2Az/wXeatOCjhU2mbcIQ5s+z/LTpi8Ic03aW3F5s8=
X-Received: by 2002:aed:2358:: with SMTP id i24mr4212932qtc.234.1597310635133;
 Thu, 13 Aug 2020 02:23:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200806145936.29169-1-popadrian1996@gmail.com>
 <20200806180759.GD2005851@lunn.ch> <CAL_jBfSZDGbKiKCjcdQ8uaHvtxxb0P4Rktw9TutWEGCfscJ=EQ@mail.gmail.com>
 <20200808143047.GG2028541@lunn.ch>
In-Reply-To: <20200808143047.GG2028541@lunn.ch>
From:   Adrian Pop <popadrian1996@gmail.com>
Date:   Thu, 13 Aug 2020 10:23:17 +0300
Message-ID: <CAL_jBfTUpcooEMdcaj1QsvGkD2AP_w+WzyZAzTr9nR4_6FNzHQ@mail.gmail.com>
Subject: Re: [PATCH ethtool v2] Add QSFP-DD support
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@mellanox.com, vadimp@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Paul Schmidt <paschmidt@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew!

I removed all the comments/constants/structs/functions that were
assuming the existence of page 0x10 and 0x11. I sent v3 to Ido (before
submitting it), he helped me test it and everything works fine. Please
let me know if there's anything else that should be changed.

Also, I just noticed I forgot to sign-off the patch. Can the following
lines be added by you or it's me who needs to add them by
re-submitting?
Signed-off-by: Adrian Pop <popadrian1996@gmail.com>
Tested-by: Ido Schimmel <idosch@mellanox.com>

Thank you!
Adrian

On Sat, 8 Aug 2020 at 17:30, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Thu, Aug 06, 2020 at 07:21:21PM +0300, Adrian Pop wrote:
> > Hi Andrew!
> >
> > Should I resubmit v3 after I delete the code that has to do with page
> > 0x10 and 0x11?
>
> Yes please.
>
>     Andrew
