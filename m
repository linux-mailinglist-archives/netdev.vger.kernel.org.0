Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 341F8B5542
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 20:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729139AbfIQSYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 14:24:10 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:38622 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727746AbfIQSYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 14:24:09 -0400
Received: by mail-oi1-f196.google.com with SMTP id 7so3741278oip.5
        for <netdev@vger.kernel.org>; Tue, 17 Sep 2019 11:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3vUiG+ffNcy8bb488Ep6eZ03iaA8AMf08GzSTmiqRAo=;
        b=nTCxx3qA3AIYbW+mjgC9GrtI74ltp84aPgAi16N626bmzJn7IwmjtMtku7aT28OpFY
         CtqF9frARd9jWCZwM87mdFbap0Okkm+MP6psxug/Y7GBs1U6/m4oFjWNVhhX1p64gkrT
         M8s2dHbxy3+gsVCthDSgcW8yjzGPRHvUK54/16EeFgpoRmXT0tBgSmTplKKfKlOM/kal
         IR8Yd251IvGX58cHVGkpN6778FwsAAnDmUbWeNGTbM+XHXAJZeN5HwXK1Gnm9sZnfRMy
         YsVwm4Tk4CFgM/U4fkpfnWX8+opKJSXOj0yUP3AwMgrEn7rLdMk/9HkxEFgt7ZUcPcjB
         SZwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3vUiG+ffNcy8bb488Ep6eZ03iaA8AMf08GzSTmiqRAo=;
        b=AU27klLQtztY43iIuqQOtl6ZOUlxofpqIifQnMNtQo3zt1Lbo/+D0cBAU9QvD56hCK
         ZtX+NSwjxk+OW1Ql5p1AjQF/mYxxUg0ACRAYCj0pRe6LvgLYhcrQ0Ua4cCqWDBVpD74l
         pnuNhtbQpPptOQ5/USF/0k3SNLWIpyYSF7xVFdepUjUhx8jtMub0OMOJQ1lfbqpy+whq
         2QYXy3XI/buMfjFZ2PliGvbBjE+2XR+wp9RpThEDB6O8VNKgZ4SZOwf6EgjN0vvQ9aIF
         +e3A+8tAhWJQWYRxv0Z1aUxVOaJHYW02XltT/yzp7xMo0b/uR3OIaSmGosky/S1ypATJ
         9LAQ==
X-Gm-Message-State: APjAAAV15XP7EWXYoCTtyKlwADBoQ17gzJH4loqbJJWM+0RZRBcyz+Tf
        T621gJPh2/qhoOJf1YBb3qNo/FSH+Y9/CqjiTlovYQ==
X-Google-Smtp-Source: APXvYqxUun7iEdS+NASsCLWgkgR7EvtM6zpRQ1sZWhI8nrsWWjZWP3IVeoQ+y9e8uaeL2HrhQbdlw5bG+o33Vbr8LGA=
X-Received: by 2002:a54:478d:: with SMTP id o13mr4989359oic.95.1568744648540;
 Tue, 17 Sep 2019 11:24:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190910201128.3967163-1-tph@fb.com> <CANn89iKCSae880bS3MTwrm=MeTyPsntyXfkhJS7CfgtpiEpOsQ@mail.gmail.com>
 <2c6a44fd-3b7e-9fd9-4773-34796b64928f@akamai.com> <CANn89iKJdMGD6kdKrQJk_sHO4ec=Ko3iAiBy_oDzU2UPGtvJNg@mail.gmail.com>
In-Reply-To: <CANn89iKJdMGD6kdKrQJk_sHO4ec=Ko3iAiBy_oDzU2UPGtvJNg@mail.gmail.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Tue, 17 Sep 2019 14:23:52 -0400
Message-ID: <CADVnQyknrHTOZ7bFCwkzTX6e1aK7EA1haxDSSws2jNJebATHwQ@mail.gmail.com>
Subject: Re: [PATCH v2] tcp: Add TCP_INFO counter for packets received out-of-order
To:     Eric Dumazet <edumazet@google.com>
Cc:     Jason Baron <jbaron@akamai.com>, Thomas Higdon <tph@fb.com>,
        netdev <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Dave Jones <dsj@fb.com>, Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 17, 2019 at 1:22 PM Eric Dumazet <edumazet@google.com> wrote:
>
>  Tue, Sep 17, 2019 at 10:13 AM Jason Baron <jbaron@akamai.com> wrote:
> >
> >
> > Hi,
> >
> > I was interested in adding a field to tcp_info around the TFO state of a
> > socket. So for the server side it would indicate if TFO was used to
> > create the socket and on the client side it would report whether TFO
> > worked and if not that it failed with maybe some additional states
> > around why it failed. I'm thinking it would be maybe 3 bits.

BTW, one aspect of that "did TFO work" info is available already in
tcp_info in the tcpi_options field.

Kernel side is:
  if (tp->syn_data_acked)
        info->tcpi_options |= TCPI_OPT_SYN_DATA;

We use this bit in packetdrill tests on client and server side to
check that the TFO data-in-SYN succeeded:
   +0 %{ assert (tcpi_options & TCPI_OPT_SYN_DATA) != 0, tcpi_options }%

These TFO bits were added much later than the other bits, so IMHO it
would be OK to add more bits somewhere unused in tcp_info to indicate
reasons for TFO failure. Especially if, as you suggest, "0" as a code
point could indicate that the code point is undefined, and all
meaningful code points were non-zero.

neal

> > My question is whether its reasonable to use the unused bits of
> > __u8    tcpi_delivery_rate_app_limited:1;. Or is this not good because
> > the size hasn't changed? What if I avoided using 0 for the new field to
> > avoid the possibility of not knowing if 0 because its the old kernel or
> > 0 because that's now its a TFO state? IE the new field could always be >
> > 0 for the new kernel.
> >
>
> I guess that storing the 'why it has failed' would need more bits.
>
> I suggest maybe using an event for this, instead of TCP_INFO ?
>
> As of using the bits, maybe the monitoring application does not really care
> if running on an old kernel where the bits would be zero.
>
> Commit eb8329e0a04db0061f714f033b4454326ba147f4 reserved a single
> bit and did not bother about making sure the monitoring would detect if this
> runs on an old kernel.
