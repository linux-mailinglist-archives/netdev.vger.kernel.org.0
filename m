Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77F8229328A
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 03:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389761AbgJTBAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 21:00:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389752AbgJTBAm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 21:00:42 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44166C0613CE;
        Mon, 19 Oct 2020 18:00:42 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id 144so137427pfb.4;
        Mon, 19 Oct 2020 18:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Wt3KqfnfSjM+CBBz1KRqqZfcBj5jRciRbk3GoY1qAmQ=;
        b=aVKfiRHRIKSBB7o1o3vef07vpUfNNY5HXxLzjvVfb5uqQ8sFEy0bKWH7R8OaPCwHy0
         mn0vtlwZwsvdtI7qfhWrlxnJ7aehOVG3HN/z2nZCRfXFs8UBuVNuYQQ2uYndatF+nvNj
         Km+LJVP5/Q8Ta3L7vxUN0lD7Hoz3itqNn01DRgawAwu0ziMFg2tXycwfL+T4eExBsH+H
         VewsT9tiBMZ/eAwH2n8Oy1JpvayD8NluyECa7obVhpQ5sMhpOtFtBfefZdsFHewp4muL
         VSjdm9ClN3oEIXpd5LCXgiyEK25XHBn9oe7GqcVkKsQ2vv42AcOCo8WJ6z9IacFWdfRr
         4iAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wt3KqfnfSjM+CBBz1KRqqZfcBj5jRciRbk3GoY1qAmQ=;
        b=INUNads/yrGgl9EuPezEw2YdV6idunBw60dEV9PahYutDDq6goLCgSSdPFk+3NfIEf
         UfyTus3gOQdsN/n62ByP97mKh5e68ooDSvViOz9987J1Ic7fDJeVDMegM2SWXZ0xY99u
         Xw+WoEgF12DhWRxNXW2G0iHxunCSu3piz/+5sZruF0OZmscyjcdAFGDPKbywsLmykaYa
         zRXJ9mcFmDmyxeSKXo3wTcRAyCKFWIlugbc/WOI+eZ1w+U7ihuged/gtXHVzm5qrbY1p
         HBtu18U+DTu5g3vymNfpuZE/xIxVR6AD/n69Ui77/15WCTjly4BUdtcaLF+0INdyToqM
         iiWQ==
X-Gm-Message-State: AOAM531gFSBqXvXb3CWrJQKRONSSVHKd85gQL8lh40SHYoR/km1dWxCB
        EjuJkoUf96duMbDhiSwwPkp39twclT6rm0RJ3g0=
X-Google-Smtp-Source: ABdhPJyjxtGJ1ZkWJ3fcrkttUzFT7j8cBZAyCFvf/1l6VO20r/xLZpk1GAeYRvli3beSKxHMM1GW6uLSsOzKfH2aT+o=
X-Received: by 2002:a63:7347:: with SMTP id d7mr509136pgn.63.1603155641844;
 Mon, 19 Oct 2020 18:00:41 -0700 (PDT)
MIME-Version: 1.0
References: <20201019104942.364914-1-xie.he.0141@gmail.com>
 <20201019142226.4503ed65@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAJht_EMNza4ChbhnCvEKQkYs14SpcjdajnDA6okr9actVzQp9Q@mail.gmail.com> <20201019154933.424b1fac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201019154933.424b1fac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Mon, 19 Oct 2020 18:00:31 -0700
Message-ID: <CAJht_EPcHyDegOqKNB-i6fAO0sd1tTYgxOEEv=k7wRnTe2-a0w@mail.gmail.com>
Subject: Re: [PATCH net] drivers/net/wan/hdlc: In hdlc_rcv, check to make sure
 dev is an HDLC device
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Krzysztof Halasa <khc@pm.waw.pl>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 19, 2020 at 3:49 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Cool! FWIW when you resend you can also trim the subject to just say:
>
> net: hdlc: In hdlc_rcv, check to make sure dev is an HDLC device
>
> There's no need for the full file path.

OK. I'll do that. Thanks!
