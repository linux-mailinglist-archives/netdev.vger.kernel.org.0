Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76138240CCC
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 20:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728095AbgHJSN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 14:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727904AbgHJSN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 14:13:58 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E58CC061756;
        Mon, 10 Aug 2020 11:13:58 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id r4so5438561pls.2;
        Mon, 10 Aug 2020 11:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QWRjJz03fN2iX6SwFzIlTiyYOq7QYK9vU0Yu9DQQqFg=;
        b=B/RWcC5SUXP+AjseWeNvooqu2enNHgumz6rl6RK/sm6OxOMjpNAPqfgwbC2Uj/pCM2
         B6EI2DkyqlZY48bqmKCkvj6P7Z9gQxtGM0E9oS6mp1ZMfizCc2/VtqecTG+YJXQFBVpr
         P8UBvN1bTyo8RHgkypE4UW6SCVoQoDGJKKz0f4s1xKCbDOdfWY82/1eve6yzJaG0lQCi
         tH0oCJooIUESQKV/+DL6Er88LPwYDlQp8hK2EQT1rIK7gyPas2uDRMsBkDJnECgkBGSR
         5w1CZVYDTeJ8C+0oZS3iY29eCS5MnHmyz2pTcgNMJN1zErCg/R35id1oJ1Mt8s15lwKN
         jSJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QWRjJz03fN2iX6SwFzIlTiyYOq7QYK9vU0Yu9DQQqFg=;
        b=oBAQNoKCnzSSrm/Jtq2rK1bYJLSx+1zkIrlPI3f+mmyti6DSCSjZU+bKlQaG7KCRb1
         jKnBQsOwhaCRo0rP2dAeOAhROdAQRsx3vaKzkxF97VDqLrYCMiJqrTvPQnUvgHCSg3CT
         O0O463bKoc+ZL7IxygSdTAuDRtXdFvcpPE9TatgMWA6HABUp6sneaPKjQ+rcUCCDTXBT
         3DJejbpa6XjqHWsWSlO+AAreR4BNLK0G+T+YhNvKEU/G02cAE0gepgE+JxFxv6yKH4+X
         amTnCXIfbd8cQjABtc6lfQQVn/WNN1hIXxOrHeoYJ5k7CwjijVcHlmTdk1mf7vipyQgE
         IZaw==
X-Gm-Message-State: AOAM533xJyYoMIFR+u6p1Qvbdce68Ew56MhLvyN7FEaTgixupU2AtMqJ
        wCJynStqfUDs0IDjmB+ChT+JADZJIYd4fUBhJkI=
X-Google-Smtp-Source: ABdhPJxbl9r/s3RbDzcSSFfduZED7AMMCG8o6kF6ali+og7C3Xr9BVeqjDvPq1jNbLi7nO/qd5k95hpfX+ZnfkTAqZI=
X-Received: by 2002:a17:902:9892:: with SMTP id s18mr9546077plp.322.1597083237768;
 Mon, 10 Aug 2020 11:13:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200808175251.582781-1-xie.he.0141@gmail.com>
 <CA+FuTSfxWhq0pxEGPtOMjFUB7-4Vax6XMGsLL++28LwSOU5b3g@mail.gmail.com>
 <CAJht_EM9q9u34LMAeYsYe5voZ54s3Z7OzxtvSomcF9a9wRvuCQ@mail.gmail.com> <CA+FuTSdBNn218kuswND5OE4vZ4mxz3_hTDkcRmZn2Z9-gaYQZg@mail.gmail.com>
In-Reply-To: <CA+FuTSdBNn218kuswND5OE4vZ4mxz3_hTDkcRmZn2Z9-gaYQZg@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Mon, 10 Aug 2020 11:13:46 -0700
Message-ID: <CAJht_EPGD1RmnU6-ZJYocXCY-qcPxXeEuurQ6GJod=WGO69-jg@mail.gmail.com>
Subject: Re: [PATCH net] drivers/net/wan/lapbether: Added needed_tailroom
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Martin Schiller <ms@dev.tdt.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 10, 2020 at 12:32 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> What happens when a tunnel device passes a packet to these devices?
> That will also not have allocated the extra tailroom. Does that cause
> a bug?

I looked at the code in net/ipv4/ip_tunnel.c. It indeed appeared to me
that it didn't take needed_tailroom into consideration. However it
does take needed_headroom into consideration through the macro
LL_RESERVED_SPACE. I think it would be better for it to take
needed_tailroom into consideration, too.

However, looking at the comment of needed_tailroom in
include/linux/netdevice.h, it says "Extra tailroom the hardware may
need, but not in all cases can this be guaranteed". So if we take this
comment as the spec, we can consider this to be not a bug. The reason
the author of this comment said so, might be that he wanted to add
needed_tailroom to solve some problems, but he was not able to change
all code to take needed_tailroom into consideration, so he wrote in
the comment saying that it was not necessary to always guarantee
needed_tailroom.

If we take this comment as the spec, to prevent bugs, any driver that
sets needed_tailroom must always check (and re-allocate if necessary)
before using the tailroom.

However, I still think it would be better to always take into
consideration needed_tailroom (and needed_headroom, too), so that
eventually we can remove the words of "but not in all cases can this
be guaranteed" from the comment. That would make the code more logical
and consistent.

Thank you for raising this important question about needed_tailroom!
