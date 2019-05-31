Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74D513182A
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 01:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727058AbfEaXdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 19:33:12 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38577 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727035AbfEaXdK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 19:33:10 -0400
Received: by mail-pf1-f195.google.com with SMTP id a186so6384396pfa.5
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 16:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zzddG9Gjm8AXO9IHzYUM1VDR0CHwahQe8D71s9hFu/c=;
        b=sUFNLE70qFuM1j32iqPxE2N82dVJJzFJaig1Wc2IOUGvkXLZBJWeWXEnUpoER7ZDH5
         lmPoYejl4nkgIgnY4RVJpWC4DbOXHt4cuJn3rNDITsEMmuHlooOoGM8q0p6UsN22WV3r
         nsI1V8f9K77o0rjLcWUEgQj2DtJF5B2CAgykzgCf4yXUgSsJNINJozSXCUelfZYikR0t
         vY2DgytSi3PGwSkp748aqkLh23FuFSagcBfJmDMaSw1brMGuZAZXdz+2y75ZfA+d4Aqj
         UPpnZFpNufpYERlc5isr4RxlVC7tXskMUL9Rc1IH1UTus0aA98hA1TKSQvlLnNB7znCx
         3pIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zzddG9Gjm8AXO9IHzYUM1VDR0CHwahQe8D71s9hFu/c=;
        b=VPkKm7Rs/+Nnex3eDkuW0l/FZe2kloL+C+6iO9oGExx2lVTyRMx50UZADqLNI1oVen
         p3EwSa4x6u6pWxOv2iGChTDX8BAQ9mls98FwqN4LhnEZZsPnGopB2IrWrDsRLuvDyP0n
         57Zq0mJcwEJsV7sd6I9aAMXRCusX2eFa3iLojuuKb4t3HPcnyzIuuWb1jselJOSDtNZy
         q8hJzVcnxBzHHhJ2IEW3H4dTOz3ZHBa7ha0OLAwmuRA5SdxiiXXSOR+idlNl9hm+Iu+P
         iL2zcAGmCiX6okGG5Jstx0AlZbzisLIJSVVnBx7rLhzET9+qrNW5NfosHYSkVbSGRtyQ
         BKBw==
X-Gm-Message-State: APjAAAW7fvfF0gaE8BdJz+JP80Oo4RwaGGjEh2S2UW+ovz+KIgU0hzZs
        /dEq7mbYS7eUP4MJq19e7fd1uQ==
X-Google-Smtp-Source: APXvYqyJ7gQmtzmeiKPbNeIHflsw1vNpFtYMs7bzVo3F+1S7RJ+MFhz+r8ETLxFyxFKwyQDGRT1VaQ==
X-Received: by 2002:aa7:8b12:: with SMTP id f18mr13286126pfd.178.1559345589344;
        Fri, 31 May 2019 16:33:09 -0700 (PDT)
Received: from minitux (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id c17sm7733229pfo.114.2019.05.31.16.33.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 31 May 2019 16:33:08 -0700 (PDT)
Date:   Fri, 31 May 2019 16:33:06 -0700
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, Dan Williams <dcbw@redhat.com>,
        David Miller <davem@davemloft.net>,
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
Subject: Re: [PATCH v2 00/17] net: introduce Qualcomm IPA driver
Message-ID: <20190531233306.GB25597@minitux>
References: <20190531035348.7194-1-elder@linaro.org>
 <e75cd1c111233fdc05f47017046a6b0f0c97673a.camel@redhat.com>
 <065c95a8-7b17-495d-f225-36c46faccdd7@linaro.org>
 <CAK8P3a05CevRBV3ym+pnKmxv+A0_T+AtURW2L4doPAFzu3QcJw@mail.gmail.com>
 <a28c5e13-59bc-144d-4153-9d104cfa9188@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a28c5e13-59bc-144d-4153-9d104cfa9188@linaro.org>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri 31 May 13:47 PDT 2019, Alex Elder wrote:

> On 5/31/19 2:19 PM, Arnd Bergmann wrote:
> > On Fri, May 31, 2019 at 6:36 PM Alex Elder <elder@linaro.org> wrote:
> >> On 5/31/19 9:58 AM, Dan Williams wrote:
> >>> On Thu, 2019-05-30 at 22:53 -0500, Alex Elder wrote:
> >>>
> >>> My question from the Nov 2018 IPA rmnet driver still stands; how does
> >>> this relate to net/ethernet/qualcomm/rmnet/ if at all? And if this is
> >>> really just a netdev talking to the IPA itself and unrelated to
> >>> net/ethernet/qualcomm/rmnet, let's call it "ipa%d" and stop cargo-
> >>> culting rmnet around just because it happens to be a net driver for a
> >>> QC SoC.
> >>
> >> First, the relationship between the IPA driver and the rmnet driver
> >> is that the IPA driver is assumed to sit between the rmnet driver
> >> and the hardware.
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
> 

But any such changes would either be years into the future or for
specific devices and as such not applicable to any/most of devices on
the market now or in the coming years.


But as Arnd points out, if the software split between IPA and rmnet is
suboptimal your are encouraged to fix that.

Regards,
Bjorn
