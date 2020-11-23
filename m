Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B15C02C03F9
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 12:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728766AbgKWLSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 06:18:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728564AbgKWLSG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 06:18:06 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68EADC0613CF;
        Mon, 23 Nov 2020 03:18:05 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id w6so14631373pfu.1;
        Mon, 23 Nov 2020 03:18:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c7qAoRDEBVkDADtuqAeO2Rb/J+k1l2uuc/tv5XiZIz0=;
        b=oBIa9Kk7yDENh2JR7iXYy+f7wKXrPKCeVdZAtdqXZ8CkA/5jDtHw/T1V/prn2ogng+
         wucjqc3cEu0nvuWiWLyWMkiYd03btoUcIMRHqpcSGZMG+WFrH18R0PZNgtHpdDcsbAFy
         /d0PDYsNI6fmxhlchkW1F/910DBlkEkVGshR5uiuFxPqR6Y8XZByXCap3jHGaUxg50Vj
         L+BE34h7As+Spm28EMnn+IJWN0aj/q9imsh3AfjSQiAmMV4UY3JO5oh/UvxyJ25YlqhE
         GpTEFHEnKXAxpTlWPRYlScpv9MmOMMFoGwXkmtAuZHYlcxwny8GE2tsM7fxxbq4xra+O
         DE0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c7qAoRDEBVkDADtuqAeO2Rb/J+k1l2uuc/tv5XiZIz0=;
        b=PztqiwFh8OZFr2ErE1NPIF0I766Y4pB+oi/t2kGH4g7SWJ4EsN169kZ6BKOry+nKhq
         I5Bn9yyoKJDVEbAWIb1CdHgsCUDVNgJAdXEmK3mNO4o2A/JYgUYQ47XwiVSv6OnI6Vvg
         8k6PjEV61YD/mE3Ob3D0PjfS6X3nSXiPHLFZpv0kSqj9iKFoxc8FrpTkBJQwWPDHTIqJ
         thqwOXB7v+bqf7o8hDQZx9ZwEapW5Tg2T+QkDTu98Qo/8dbugI2K3ytBgTJxdirR37W7
         yI/OvBmnwJhor8nRZf97zEgQf5fyOJo1DWqu5DoLfKW7BzTh28qTFpFbxR17XFwx5+8D
         Vsyw==
X-Gm-Message-State: AOAM532EcuLNj0wY1BNFjOG4wI33ofEAIT2AxrGTMVxcccNLu42pt/4b
        N3bjolOi/euvVVsvF90jN+p3suB8pONK7roZmtbebVylfpo=
X-Google-Smtp-Source: ABdhPJxEQmoN/29WJXjWq32wK1/WvB9Em+1Wlx9c/e2EEIl82L7krvZyaUVw7VPvm/Fq9YW5QvcuyHsQibuceAJ2Mmc=
X-Received: by 2002:a62:5b05:0:b029:197:fafb:50f3 with SMTP id
 p5-20020a625b050000b0290197fafb50f3mr6477933pfb.76.1606130284917; Mon, 23 Nov
 2020 03:18:04 -0800 (PST)
MIME-Version: 1.0
References: <20201120054036.15199-1-ms@dev.tdt.de> <20201120054036.15199-3-ms@dev.tdt.de>
 <CAJht_EONd3+S12upVPk2K3PWvzMLdE3BkzY_7c5gA493NHcGnA@mail.gmail.com>
 <CAJht_EP_oqCDs6mMThBZNtz4sgpbyQgMhKkHeqfS_7JmfEzfQg@mail.gmail.com>
 <87a620b6a55ea8386bffefca0a1f8b77@dev.tdt.de> <CAJht_EPc8MF1TjznSjWTPyMbsrw3JVqxST5g=eF0yf_zasUdeA@mail.gmail.com>
 <d85a4543eae46bac1de28ec17a2389dd@dev.tdt.de> <CAJht_EMjO_Tkm93QmAeK_2jg2KbLdv2744kCSHiZLy48aXiHnw@mail.gmail.com>
 <CAJht_EO+enBOFMkVVB5y6aRnyMEsOZtUBJcAvOFBS91y7CauyQ@mail.gmail.com> <16b7e74e6e221f43420da7836659d7df@dev.tdt.de>
In-Reply-To: <16b7e74e6e221f43420da7836659d7df@dev.tdt.de>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Mon, 23 Nov 2020 03:17:54 -0800
Message-ID: <CAJht_EPtPDOSYfwc=9trBMdzLw4BbTzJbGvaEgWoyiy2624Q+Q@mail.gmail.com>
Subject: Re: [PATCH net-next v4 2/5] net/lapb: support netdev events
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     Andrew Hendry <andrew.hendry@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 23, 2020 at 2:38 AM Martin Schiller <ms@dev.tdt.de> wrote:
>
> Well, one could argue that we would have to repair these drivers, but I
> don't think that will get us anywhere.

Yeah... One problem I see with the Linux project is the lack of
docs/specs. Often we don't know what is right and what is wrong.

>  From this point of view it will be the best to handle the NETDEV_UP in
> the lapb event handler and establish the link analog to the
> NETDEV_CHANGE event if the carrier is UP.

Thanks! This way we can make sure LAPB would automatically connect in
all situations.

Since we'll have a netif_carrier_ok check in NETDEV_UP handing, it
might make the code look prettier to also have a netif_carrier_ok
check in NETDEV_GOING_DOWN handing (for symmetry). Just a suggestion.
You can do whatever looks good to you :)

Thanks!
