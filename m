Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A56441E0B2
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 20:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353169AbhI3SMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 14:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353130AbhI3SM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 14:12:29 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5EAFC06176A
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 11:10:46 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id a11so7848728ilk.9
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 11:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kvNALztHaapZiHyr87gDoU7KzQF7xStUg5vzkvd2Bc8=;
        b=YPp1rXQuSi4jyBMmY0w7DuJpuja9lWOD35RrEBGc1D0TlkkwIz8Y8UeH1LavqHrubb
         HY43HxIstWNHHzc94og8Y4eLZibwKqEsVAgOn8EjK7lUnEkYmumizH2jquc6ex9mHtCn
         hbW2zbpcE6rVE11E/L837TPRsHMDwh5yQbzktKXCV+qZphEX3JdyyKedfhknyu4HiVpm
         gNmwuoBeC5Q3ILACvUMBn72NzLlZcQcq1qTx1DktbsmzIR+NQRidOcztSwED33xUcW8O
         Ob32ed2WELWiic4TGKaqNCHlrQmqhu6oc7bh31FZIIbxqp+A/VR3IE8wtFPmiXDL+RWg
         sq9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kvNALztHaapZiHyr87gDoU7KzQF7xStUg5vzkvd2Bc8=;
        b=usNDW1cvm/m2SVvbbC93N+mALqO02vbAaoYD6XH8CgfKXBslixtWFBctacaN0+j5LS
         Xc3L/tMPdiVvkoGRlncFblJUmxMkU++eFOPBEzjGnj0tt5EY271YhB65P7kCu4tCaEdv
         w/lQEFHTYUAWU7ZW5/wUc8XOfeCpyTvqbCZncSw+/a9oE6eG2ksZxV6dbIBk6CeRdIRi
         YjDPjOtXll0D3HKEWDvzqvQDd+93/u4gA/GQXOYmV4SMpiXFGR05tqYlqpSlCrQzWy77
         A9rVDGwm7bapVIBTrSuHGUqVBgSGDGuNKesF/Ub2DjlICtiVgOEm6cFx++ZkxAmWb+6e
         NOgg==
X-Gm-Message-State: AOAM5327v7KwTw8jMsIRwo0SAWm9Xqvb6MbE0Ct0qfij9rEAKTaDUBJY
        y1N6y2UC1l4hxGVtepUl+0/WrgOOlTmQTcjHX6k=
X-Google-Smtp-Source: ABdhPJzw5hSRqXssACw+noLrlWe9kJAWI5mqYxCgcS2Puq7LfvR6cbka26nVazOqDYm2zZy9wdLBBLH6NEKUBHZE4RA=
X-Received: by 2002:a05:6e02:8a3:: with SMTP id a3mr5193812ilt.88.1633025446115;
 Thu, 30 Sep 2021 11:10:46 -0700 (PDT)
MIME-Version: 1.0
References: <CA+FuTSe-6MSpB4hwwvwPgDqHkxYJoxMZMDbOusNqiq0Gwa1eiQ@mail.gmail.com>
 <CA+FuTSdkJcj_ikNnJmGadBZ1fa7q26MZ1g3ERf8Ax+YbXvgcng@mail.gmail.com>
 <20210203052924-mutt-send-email-mst@kernel.org> <CAF=yD-J8rsr9JWdMGBSc-muFGMG2=YCWYwWOiQBQZuryioBUoA@mail.gmail.com>
 <20210203175837-mutt-send-email-mst@kernel.org> <CAEA6p_BqKECAU=C55TpJedG9gkZDakiiN27dcWOTJYH0YOFA_w@mail.gmail.com>
 <CA+FuTSf-uWyK6Jz=G67p+ep693oTczF55EUzrH9fXzBqTnoMQA@mail.gmail.com>
 <CAEA6p_DGgErG6oa1T9zJr+K6CosxoMb-TA=f2kQ_1bFdeMWAcg@mail.gmail.com>
 <20210413011508-mutt-send-email-mst@kernel.org> <CAEA6p_CCsfOrJO8CUcvmt0hg2bDE36UjJqeqKPOEBx0+ieJ2uA@mail.gmail.com>
 <20210929175118-mutt-send-email-mst@kernel.org> <CAEA6p_CQwn1BrU=t3yAmmKUgn9vWfkao_2c-FrqBk0qK0r7shQ@mail.gmail.com>
In-Reply-To: <CAEA6p_CQwn1BrU=t3yAmmKUgn9vWfkao_2c-FrqBk0qK0r7shQ@mail.gmail.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Thu, 30 Sep 2021 11:10:33 -0700
Message-ID: <CAA93jw4z7W6uUYKn5SdZ+Ci1tr1NrtCbhkkmua5xwfGA=V-8pQ@mail.gmail.com>
Subject: Re: [PATCH net] virtio-net: suppress bad irq warning for tx napi
To:     Wei Wang <weiwan@google.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To me, the symptoms of this problem (a packet storm) smelt like the
lack of bql leading to very bursty tcp behavior
and enormous tcp RTT inflation in this driver which I observed 6+ months back.

now that it seems to be fixed (?), could you re-run the netperf 128
stream test and share a packet capture? (try with pfifo_fast or
fq_codel
at the qdisc), and sch_fq as a control (which was working correctly).

thx.
