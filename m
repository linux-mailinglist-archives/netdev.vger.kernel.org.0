Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2552A0F38
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 21:10:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727265AbgJ3UJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 16:09:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726424AbgJ3UIf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 16:08:35 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9039FC0613CF;
        Fri, 30 Oct 2020 13:08:35 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id k9so4441546pgt.9;
        Fri, 30 Oct 2020 13:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sMDtH8VxeNPZ8O/3AtiHwIqOh8hNMiAGbFZ1FHIVjKc=;
        b=Xc9+hGxs0kORu/ZSCaSk4BLO93G+dHQUa4GqLXZMPy0GS6gGCB/RJqCmQd31fBpqNh
         2LL3lHubU+3N7BlAestsH13EBSmmd5xgSsDP1CJdEamuphKgsO/5YiqWImVNXA2zt0WS
         q9aloq5B6YxesQS0SjOI9Lec0VXayhcSULb2FhzkouUlw8ageBN4FijOzx0bMq+tT7V6
         mQMIJKbR9ikAUBjs4P9huhAco/o5aZHFdHooo27r7fQQfJd/5RQFlN+1rgAoJ48HaFUK
         AAefsPnveibXjvgfh8lXPinZg5SSV+3CQD+OPkQfihFZ8gsfIsubyRKFSbwLGtF1HsUD
         IMWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sMDtH8VxeNPZ8O/3AtiHwIqOh8hNMiAGbFZ1FHIVjKc=;
        b=cagiMu+XTr2Qwi8Ltr0ViTGU4wi/CjIS8MVcc6bC4dgNFCfqpbmS9LArh+BCeFgyS4
         /MjF8voXGs+F0ii1RutoxqhMij4Gpfxn7UNo1lkG2K5M1YCULiYKS9NRZpTPfb/VGuXT
         HMN9R50t2MFVeFX9rKPeaPQZZ/MeJmQ38r9lpraA32tX+k8gduNOVa18O4dLEKVssdyX
         Qba9VNweae47kGsG0n5rR0it8s5suMzltG9Dbs3tUUmlf1f7IGLrLiaPYv2j6OACZ8xu
         5JMGYCKMRfcwhcr2Dr6tZ+a08azGJYDcp5CHQ+0N2KckgI9kJlLqz39vFoiSHsg9Suwf
         TE1A==
X-Gm-Message-State: AOAM533TW5hfIFrkwnA0XnRc7WJ0Jn/EZajJqqznMxNuIwoEhMW8DXfN
        tXvlulnvbRMcohB3om31U5xeOIhRtwOyHCaZQcg=
X-Google-Smtp-Source: ABdhPJyx2mtM6QVOkjC/AybFhgEnxkJI32aPb9gSfckAryCS3xqi32Lc1dqitRf6J2Yo7PzHRV/KEsuatM0w9HkYoyk=
X-Received: by 2002:a62:3004:0:b029:156:47d1:4072 with SMTP id
 w4-20020a6230040000b029015647d14072mr10814739pfw.63.1604088515210; Fri, 30
 Oct 2020 13:08:35 -0700 (PDT)
MIME-Version: 1.0
References: <20201030022839.438135-1-xie.he.0141@gmail.com>
 <20201030022839.438135-5-xie.he.0141@gmail.com> <CA+FuTSczR03KGNdksH2KyAyzoR9jc6avWNrD+UWyc7sXd44J4w@mail.gmail.com>
In-Reply-To: <CA+FuTSczR03KGNdksH2KyAyzoR9jc6avWNrD+UWyc7sXd44J4w@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Fri, 30 Oct 2020 13:08:24 -0700
Message-ID: <CAJht_ENORPqd+GQPPzNfmCapQ6fwL_YGW8=1h20fqGe4_wDe9Q@mail.gmail.com>
Subject: Re: [PATCH net-next v4 4/5] net: hdlc_fr: Do skb_reset_mac_header for
 skbs received on normal PVC devices
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

On Fri, Oct 30, 2020 at 9:30 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> Acked-by: Willem de Bruijn <willemb@google.com>

Thanks for your ack!

> Should this go to net if a bugfix though?

Yes, this should theoretically be a bug fix. But I didn't think this
was an important fix, because af_packet.c already had workarounds for
this issue for all drivers that didn't have header_ops. We can
separate this patch to make it go to "net" though, but I'm afraid that
this will cause merging conflicts between "net" and "net-next".
