Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F36962A0E7F
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 20:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727676AbgJ3TW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 15:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727624AbgJ3TVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 15:21:36 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C377DC0613CF;
        Fri, 30 Oct 2020 12:21:36 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id j18so6167934pfa.0;
        Fri, 30 Oct 2020 12:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Zw5N/jCkLYe8gG0oOK08OE33XmxFC4T9rEPMRps3o6s=;
        b=dCagn3RRbS2Av5tEK7SuOoJc6AOcR4cqdO1yf89DHwvbmFGEs8K/wu2u/wZNt5L9Im
         ZW/x7B32N+cV/HmUcyOOHipQymTFzGBJ8s1v40vpn6VWstgw4avLuUfoPkG2wBVGWKzo
         LMYVw/dEdRjw6zGWmTh6YhvsxI9L1W5hmPgZ/e/gTqKM0LX91hHmyvf6GBgX8uZK9aET
         DrfSza1tS8bi1s7aGW121yjk+pN2noaHuHHPjgE1bktf/HVDo2lT8Ejgw9lk7P8zTJnR
         44Ke9NcQGMBW0ZEV5FTymm//FnqalVDoltfI0Nd1uvS8q2uGG+FHfDTeBKGZlmm7kkC0
         f9vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zw5N/jCkLYe8gG0oOK08OE33XmxFC4T9rEPMRps3o6s=;
        b=pKMvKRYWWSC14aDuo0XbeE0ndJYw13KAzk5TnTXisp1EWg64qc9pSdD8CwC7JGS0bX
         XioIWTlzey97c9pw8KDdMQ3K0cB7RKZAh94NmGcn3vi2JtOYIr7oLLzhAOY95aMlyqcb
         izSVgrpizspN0jvqOHZqOv9sbVQoeTX7CMtRgvrKVhov3rkboYZO6bn9XPLKnTaOVU/5
         oX+hy0FieVAESg6seO685vlAGUTyJl6ExLCfl38euJ4AjRXyP/GZnsBAU8Y9OZSlIYsj
         UpCsXAXTfYgO5Udgu2u/PLoRMsPWUkpeDeiXbI6HTnrJZsRCCALwHQZBiNr/w+QZ+Z/b
         kTtA==
X-Gm-Message-State: AOAM532F9c+GojQaIhwZss2bh5v9Y9kSyzzTfxAZXkHwzZGhbZFl33ul
        mdSuBoPvMFFEC9TdO4Plq0KdoP/mxWpxFDEJmC4=
X-Google-Smtp-Source: ABdhPJx8fLrzna1Se3Ha9jTpWNB+7f1DMjMM4geqta1/JjLqVOuc8wv6vRhXiF5kFhIrg4UGVDcCB5iojH1WkW2HdgQ=
X-Received: by 2002:a17:90a:aa91:: with SMTP id l17mr4508499pjq.198.1604085696383;
 Fri, 30 Oct 2020 12:21:36 -0700 (PDT)
MIME-Version: 1.0
References: <20201030022839.438135-1-xie.he.0141@gmail.com>
 <20201030022839.438135-4-xie.he.0141@gmail.com> <CA+FuTSe4yGowGs2ST5bDYZpZ-seFCziOmA8dsMMwAukJMcRuQw@mail.gmail.com>
In-Reply-To: <CA+FuTSe4yGowGs2ST5bDYZpZ-seFCziOmA8dsMMwAukJMcRuQw@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Fri, 30 Oct 2020 12:21:24 -0700
Message-ID: <CAJht_EOCba57aFarDYWU=Mhzn+k1ABn8HwgYt=Oq+kXijQPGvA@mail.gmail.com>
Subject: Re: [PATCH net-next v4 3/5] net: hdlc_fr: Improve the initial checks
 when we receive an skb
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

On Fri, Oct 30, 2020 at 9:31 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> > Add an fh->ea2 check to the initial checks in fr_rx. fh->ea2 == 1 means
> > the second address byte is the final address byte. We only support the
> > case where the address length is 2 bytes.
>
> Can you elaborate a bit for readers not intimately familiar with the codebase?
>
> Is there something in the following code that has this implicit
> assumption on 2-byte address lengths?

Yes, the address length must be 2 bytes, otherwise the 3rd and 4th
bytes would not be the control and protocol fields as we assumed in
the code.

The frame format is specified in RFC 2427
(https://tools.ietf.org/html/rfc2427). We can see the overall frame
format on Page 3. If the address length is longer than 2 bytes, all
the following fields will be shifted behind.
