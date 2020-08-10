Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2BB8240295
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 09:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbgHJHcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 03:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726569AbgHJHcX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 03:32:23 -0400
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27FCAC061756
        for <netdev@vger.kernel.org>; Mon, 10 Aug 2020 00:32:23 -0700 (PDT)
Received: by mail-vs1-xe41.google.com with SMTP id q13so3730782vsn.9
        for <netdev@vger.kernel.org>; Mon, 10 Aug 2020 00:32:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sJo6TZcaNoJonrq3wQzaYlOn0q7KCaKbS7KLCKU2QzA=;
        b=J526to2DvxuRZ8736kFIZtIMrd+wGpUCmG9v/rejtCm6ZNbh/i5xF906ohsgmAiJ78
         FPeEcYbsYrJ3+Qiyi7vfxUQIT0YTtEeGabjI+phjc6DvfO3d/No2a/62W+3KjbK9N1yE
         C8EIRoSvnU2dzVpWyvin8SRVuszcz2foFihxhvFK6OQYA/F+eJS2pfM1+0cTYy/Z4bn3
         SKofNlcHWdAd0oGfiCt5GOYGUbIDXX+ZVEcHaE/xSSqEV02cBBNtLQs86tNIL+zkUeut
         lIqtPEQSc3Ru8im6pH2QAvwoxYV0EO8jBYG12kwkquzTCdgHQqKnVDF9bVWjNAizum9R
         S8Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sJo6TZcaNoJonrq3wQzaYlOn0q7KCaKbS7KLCKU2QzA=;
        b=CI17sER/iWy1TbXVelfUHLVR3SyEgHV19nVpKEO2BCAbaSqLP9vqczkWqpZrGFrXc7
         ykNUKUzKJwRIKKwaDTqn54UbUvzTa7Ovf5E6gR+Gigzwr56VViyYad5f1y689UDt/0qp
         KU6NOLEa7sQN1+BxaWNjTtaBjQ11/cpGX6aLKSbaC0W+KmMwpTOUpbyjMMfTok36Z5PW
         c5VXbCrqg6iK3ULktcnOvZpOe2IFNoxQWgkRQ5PG+L3YOfFqoIoY2+I7/q52R8sUSRn5
         UPus773cD+LsTeesW+JCF9AqJuy9hfLN49Zo60r+bqmpESCLwADuTcRsYWEgpBdT3n4G
         WULw==
X-Gm-Message-State: AOAM5315ac8kdjngTW8e74lIx5WK5ghtijqiKyoXegUxdq8Ki5H9pm6y
        3u4hJ+VENnQTGLToaOCYKi5NHoiRr0M=
X-Google-Smtp-Source: ABdhPJwfj+lqh5UXN4yGfQF1OOn+Td5tS9D3+s3eMOXPR63VH0UhOblIf7+hRiDVTVMGyJ8JX5JuIQ==
X-Received: by 2002:a67:1a43:: with SMTP id a64mr18715365vsa.235.1597044741713;
        Mon, 10 Aug 2020 00:32:21 -0700 (PDT)
Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com. [209.85.222.45])
        by smtp.gmail.com with ESMTPSA id d27sm1659121vkl.43.2020.08.10.00.32.20
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2020 00:32:20 -0700 (PDT)
Received: by mail-ua1-f45.google.com with SMTP id g20so1242607uap.8
        for <netdev@vger.kernel.org>; Mon, 10 Aug 2020 00:32:20 -0700 (PDT)
X-Received: by 2002:a9f:2648:: with SMTP id 66mr13443939uag.37.1597044739732;
 Mon, 10 Aug 2020 00:32:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200808175251.582781-1-xie.he.0141@gmail.com>
 <CA+FuTSfxWhq0pxEGPtOMjFUB7-4Vax6XMGsLL++28LwSOU5b3g@mail.gmail.com> <CAJht_EM9q9u34LMAeYsYe5voZ54s3Z7OzxtvSomcF9a9wRvuCQ@mail.gmail.com>
In-Reply-To: <CAJht_EM9q9u34LMAeYsYe5voZ54s3Z7OzxtvSomcF9a9wRvuCQ@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 10 Aug 2020 09:31:43 +0200
X-Gmail-Original-Message-ID: <CA+FuTSdBNn218kuswND5OE4vZ4mxz3_hTDkcRmZn2Z9-gaYQZg@mail.gmail.com>
Message-ID: <CA+FuTSdBNn218kuswND5OE4vZ4mxz3_hTDkcRmZn2Z9-gaYQZg@mail.gmail.com>
Subject: Re: [PATCH net] drivers/net/wan/lapbether: Added needed_tailroom
To:     Xie He <xie.he.0141@gmail.com>
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

On Sun, Aug 9, 2020 at 7:12 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> On Sun, Aug 9, 2020 at 1:48 AM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > Does this solve an actual observed bug?
> >
> > In many ways lapbeth is similar to tunnel devices. This is not common.
>
> Thank you for your comment!
>
> This doesn't solve a bug observed by me. But I think this should be
> necessary considering the logic of the code.
>
> Using "grep", I found that there were indeed Ethernet drivers that set
> needed_tailroom. I found it was set in these files:
>     drivers/net/ethernet/sun/sunvnet.c
>     drivers/net/ethernet/sun/ldmvsw.c
> Setting needed_tailroom may be necessary for this driver to run those
> Ethernet devices.

What happens when a tunnel device passes a packet to these devices?
That will also not have allocated the extra tailroom. Does that cause
a bug?
