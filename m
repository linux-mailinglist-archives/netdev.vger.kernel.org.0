Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD7C31670
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 23:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727678AbfEaVMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 17:12:38 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:46256 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727005AbfEaVMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 17:12:38 -0400
Received: by mail-qt1-f196.google.com with SMTP id z19so2594676qtz.13;
        Fri, 31 May 2019 14:12:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AZptDCZbtMb0PQHhtVnS/aF9UysKMAzgtneB0+7FC+I=;
        b=fXeIVN34xckBCndWGV5hGmm7h9qaopS1ztQocf+iEL8dlB9iQt0WrO6Yqw1j2BjNb4
         Av4aWOR5F3XWolPuq/+zl1aGyfviRFwmvriCnSiYMdSsYpAepBkUg1CvBsHjU3NogKRk
         qywUvfnhntKZcKN3oIjEAq25M2rGaUwdJGIs2IlUg71Y9whAuZRB1Lbi6HT1mGMfh9um
         8fT6i35u7AqX3tfVpPvDwIvNbvC7gecbUp7fn7dATjugICJY9ql6Sd0egP9WZlRWBs5f
         Vumh8D/d/eG5WKMOCvGfk/S5wmyGuCgK+Ipl9NoCjOiviCIl3VE5SEPhB+3YecFl9vag
         Y1LQ==
X-Gm-Message-State: APjAAAWs2RUKSTHYkiK0O9znTh8lDDX2DraweKL+E6uhqk/KxX2xvOgT
        MLs2idA2MFdU6ks31xBK3743tMAen4Q9tIs8RjR3Jm9i
X-Google-Smtp-Source: APXvYqzHvUnfa6x/YLh/Fjn3Tw3E+yBquiW3NroCyGZFdVC85oGAnHKEDZucf7nAm9xpQNUD3gkU2OGRWDNqkRg6xhY=
X-Received: by 2002:aed:3e7c:: with SMTP id m57mr6159988qtf.204.1559337157081;
 Fri, 31 May 2019 14:12:37 -0700 (PDT)
MIME-Version: 1.0
References: <20190531035348.7194-1-elder@linaro.org> <e75cd1c111233fdc05f47017046a6b0f0c97673a.camel@redhat.com>
 <065c95a8-7b17-495d-f225-36c46faccdd7@linaro.org> <CAK8P3a05CevRBV3ym+pnKmxv+A0_T+AtURW2L4doPAFzu3QcJw@mail.gmail.com>
 <a28c5e13-59bc-144d-4153-9d104cfa9188@linaro.org>
In-Reply-To: <a28c5e13-59bc-144d-4153-9d104cfa9188@linaro.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 31 May 2019 23:12:20 +0200
Message-ID: <CAK8P3a2rkQd3t-yNdNGePW8E7rhObjAvUpW6Ga9AM6rJJ27BOw@mail.gmail.com>
Subject: Re: [PATCH v2 00/17] net: introduce Qualcomm IPA driver
To:     Alex Elder <elder@linaro.org>
Cc:     Dan Williams <dcbw@redhat.com>, David Miller <davem@davemloft.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        evgreen@chromium.org, Ben Chan <benchan@google.com>,
        Eric Caruso <ejcaruso@google.com>, cpratapa@codeaurora.org,
        syadagir@codeaurora.org,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        abhishek.esse@gmail.com, Networking <netdev@vger.kernel.org>,
        DTML <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-soc@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 10:47 PM Alex Elder <elder@linaro.org> wrote:
> On 5/31/19 2:19 PM, Arnd Bergmann wrote:
> > On Fri, May 31, 2019 at 6:36 PM Alex Elder <elder@linaro.org> wrote:
> >> On 5/31/19 9:58 AM, Dan Williams wrote:
> >>> On Thu, 2019-05-30 at 22:53 -0500, Alex Elder wrote:
> >
> > Does this mean that IPA can only be used to back rmnet, and rmnet
> > can only be used on top of IPA, or can or both of them be combined
> > with another driver to talk to instead?
>
> No it does not mean that.
>
> As I understand it, one reason for the rmnet layer was to abstract
> the back end, which would allow using a modem, or using something
> else (a LAN?), without exposing certain details of the hardware.
> (Perhaps to support multiplexing, etc. without duplicating that
> logic in two "back-end" drivers?)
>
> To be perfectly honest, at first I thought having IPA use rmnet
> was a cargo cult thing like Dan suggested, because I didn't see
> the benefit.  I now see why one would use that pass-through layer
> to handle the QMAP features.
>
> But back to your question.  The other thing is that I see no
> reason the IPA couldn't present a "normal" (non QMAP) interface
> for a modem.  It's something I'd really like to be able to do,
> but I can't do it without having the modem firmware change its
> configuration for these endpoints.  My access to the people who
> implement the modem firmware has been very limited (something
> I hope to improve), and unless and until I can get corresponding
> changes on the modem side to implement connections that don't
> use QMAP, I can't implement such a thing.

Why would that require firmware changes? What I was thinking
here is to turn the bits of the rmnet driver that actually do anything
interesting on the headers into a library module (or a header file
with inline functions) that can be called directly by the ipa driver,
keeping the protocol unchanged.

> > Always passing data from one netdev to another both ways
> > sounds like it introduces both direct CPU overhead, and
> > problems with flow control when data gets buffered inbetween.
>
> My impression is the rmnet driver is a pretty thin layer,
> so the CPU overhead is probably not that great (though
> deaggregating a message is expensive).  I agree with you
> on the flow control.

The CPU overhead I mean is not from executing code in the
rmnet driver, but from passing packets through the network
stack between the two drivers, i.e. adding each frame to
a queue and taking it back out. I'm not sure how this ends
up working in reality but from a first look it seems like
we might bounce in an out of the softirq handler inbetween.

          Arnd
