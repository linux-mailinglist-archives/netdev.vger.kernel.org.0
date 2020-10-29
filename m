Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFB4729F8E5
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 00:11:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725803AbgJ2XLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 19:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgJ2XLF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 19:11:05 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D69CC0613CF;
        Thu, 29 Oct 2020 16:11:05 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id 10so3657234pfp.5;
        Thu, 29 Oct 2020 16:11:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=momvZOdlHpaCCuc93v0uI2iApTyQ7po6lrdeppS0yYQ=;
        b=KwgYAeC2Uqi5d1ZwpEjQlJH+6iCCyac14BESia1p2kSZQ2VyQgIkn1aDC++5aGWIZ7
         K2jzcc5PMO9NrASP5h2WBt9UwWFqvNyZ/2nqC1lpyXcm5jFOu+Q+UTaJzJNZhZsQIWag
         G845jo2E0v9ZG8GjVcQyuFZY1BCtUWCSpubG1wKLHXD3dXmxjW5AYu8wlStm4dI/1rkR
         dx+o6uxriYBNAD7wzSTy7nGC+gtZQXYF6vtn374ESwCGN+JllIW+xy/Ieo/bC2B8EXLV
         326ZosJz6jyWlqDKnuXNdc0ssQRTBFl/QAuwMJLw7wtKV0kH6KCpDrzf1rZ66HKdXY4Z
         MjSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=momvZOdlHpaCCuc93v0uI2iApTyQ7po6lrdeppS0yYQ=;
        b=he6BwCn5QoPvyc9DAIrf+332/sL7u+wpQyAjk6D8S9379hXSXF3DeXYysfeNHsLPW/
         YoAkbFlCO4IZL+gPMOF3duasNNrVLIfv2jVmgH1VRIrcmyhHrCPorfcHYSCeTvU5+E9K
         VQct1vw6roKKBnkw+easMCvvoMrBOl0qp+USk15kzzUyN488D0rm0l+Jr/kmC2ltLaWl
         IM6ydnCXNwAGFJEnfz0cpH5H6JVd5Wt1ChFlZONdnaf/G9l4My+Z3o7mRyNYt2X2iqPn
         xJMvf5qEAHkhNrA63Oq4ZYVSbPBUWJXBP7c4+bwXe5vsDxzd6XuI9mZaVbhJNiWOx0mM
         kbbQ==
X-Gm-Message-State: AOAM533fMQlNZ3nlOEg2T3IhMm+RUkIy+YY7oW1Zr20g1EgF/FXYCpku
        b/pchZhytfWdlokpT15xaZh3tf0IJbs6j0MZkFY=
X-Google-Smtp-Source: ABdhPJwTbjG3lpnmInc7SSpeq4ZAHHTWUxPo0T9uJDrGeSW3zhQ0BCfONALbLDpQ2K1AhpsM7rjXci0FxbekrSEps64=
X-Received: by 2002:a62:3004:0:b029:156:47d1:4072 with SMTP id
 w4-20020a6230040000b029015647d14072mr6555163pfw.63.1604013064561; Thu, 29 Oct
 2020 16:11:04 -0700 (PDT)
MIME-Version: 1.0
References: <20201028184310.7017-1-xie.he.0141@gmail.com> <20201028184310.7017-2-xie.he.0141@gmail.com>
 <CA+FuTSdPrkp4AdNkiQNpPxfwwn0X=xzKccKP+oH-ozcorDKD8Q@mail.gmail.com>
In-Reply-To: <CA+FuTSdPrkp4AdNkiQNpPxfwwn0X=xzKccKP+oH-ozcorDKD8Q@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Thu, 29 Oct 2020 16:10:53 -0700
Message-ID: <CAJht_EOKd_08JnAoUQqn_jrLntew0ymX7Y2bDK-d=EqnyJaWkw@mail.gmail.com>
Subject: Re: [PATCH net-next v3 1/4] net: hdlc_fr: Simpify fr_rx by using
 "goto rx_drop" to drop frames
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

On Thu, Oct 29, 2020 at 10:00 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> This does change rx_dropped count on errors. Not sure how important
> that is. But perhaps good to call out in the commit explicitly if it's
> intentional.

Yes, this is intentional, because I think we need to count it as a
"drop" whenever we drop an skb. I'll note this explicitly in the
commit message in the next versions of the patch. Thanks!
