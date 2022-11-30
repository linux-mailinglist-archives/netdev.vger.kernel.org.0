Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C36463D5A8
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 13:32:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233443AbiK3Mc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 07:32:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232460AbiK3Mc2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 07:32:28 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54651450A0
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 04:32:26 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id td2so26852481ejc.5
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 04:32:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=csbn9ZA9ZuwCO7vca9fwDmQPDYbQoHiHPP6TTlnfzgY=;
        b=Kb4vLWPGEHi8yeDUacFHkNuvQDyQusoagzzW9VEjPTFiqT5OTDpEtEJYZFw7V830jj
         lPEM4sEuOzqtm7UzC0agwCcatSTBOIAq3xKpM2Rl+x83tudbGL9D0RpDDNj0mQplBjQE
         348G6xfvsx+M5zq8UZBHsyd1Ysst+uloMk6A+CqukUvdipTYypG2al0yRLeVneL3YSgF
         bGBYeTY0G3SzmrZvQ/GZfMx4P+Se52rFnuLTm1RZASdhJMieLUGa48OnpMVUuX7Fg3yo
         YhP3hiPFwKqyBzYWhF69l60llDb0jkd52geAhN4VMcGGYpu6+eqa0lBOM4it8rnHoZmi
         iMHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=csbn9ZA9ZuwCO7vca9fwDmQPDYbQoHiHPP6TTlnfzgY=;
        b=F2ayTRpmaXaToX1tXUA0b+NBCMqBBozFXECDRZrj7JF4NzyjPb5zI1bEeYSVSTcXpP
         /Y3Ez6MVbTxlO3hxj1Rf4BaPLTNh21DmPezFYnpyCetr4+MFLpwJwe1DgZVrsowbIByt
         ZYgt42QlS3RieXRKytmIFflcpmYZjWtmqhF3CT0fvrsBi4RfC4LpuaRz5VtdjhJwGsmY
         IDVaZ9yAcm1NqEVHyxTMR2S6qPDHt+SGp2vUQArDgyqWrcxAR4ScENp7Ml1ssx4lWnJE
         oGp1PMMBMFqQ2mpYihwcY9AlSPgPnELC6sv+dlPR+0Of2fd3DGL700lpXR6xaqhg0ZHV
         ZAog==
X-Gm-Message-State: ANoB5pnUqrVDqGpzvd0OlxShINOFybi97Y5cls0+4ztUGDU6D7nuWRMq
        uzd4kqCS4wawy2MRiFj+RMH5qtVUmmcgNWXwOng=
X-Google-Smtp-Source: AA0mqf73IYitcwwy+EOHIAFmV/8X7Uv20xNLcSHFr78y8bO/rSsdAwSc/FVBomlP6JP6xZbqOpEIew==
X-Received: by 2002:a17:906:a387:b0:78d:946e:f65d with SMTP id k7-20020a170906a38700b0078d946ef65dmr52098133ejz.365.1669811544914;
        Wed, 30 Nov 2022 04:32:24 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id s17-20020a05640217d100b004585eba4baesm568982edy.80.2022.11.30.04.32.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 04:32:24 -0800 (PST)
Date:   Wed, 30 Nov 2022 13:32:23 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org
Subject: Re: [RFC PATCH v4 0/4] Create common DPLL/clock configuration API
Message-ID: <Y4dNV14g7dzIQ3x7@nanopsycho>
References: <20221129213724.10119-1-vfedorenko@novek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129213724.10119-1-vfedorenko@novek.ru>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Nov 29, 2022 at 10:37:20PM CET, vfedorenko@novek.ru wrote:
>Implement common API for clock/DPLL configuration and status reporting.
>The API utilises netlink interface as transport for commands and event
>notifications. This API aim to extend current pin configuration and
>make it flexible and easy to cover special configurations.

Overall, I see a lot of issues on multiple levels. I will go over them
in follow-up emails. So far, after couple of hours looking trought this,
I have following general feelings/notes:

1) Netlink interface looks much saner than in previous versions. I will
   send couple of notes, mainly around events and object mixtures and
   couple of bugs/redundancies. But overall, looks fineish.

2) I don't like that concept of a shared pin, at all. It makes things
   unnecessary complicated. Just have a pin created for dpll instance
   and that's it. If another instance has the same pin, it should create
   it as well. Keeps things separate and easy to model. Let the
   hw/fw/driver figure out the implementation oddities.
   Why exactly you keep pushing the shared pin idea? Perhaps I'm missing
   something crucial.

3) I don't like the concept of muxed pins and hierarchies of pins. Why
   does user care? If pin is muxed, the rest of the pins related to this
   one should be in state disabled/disconnected. The user only cares
   about to see which pins are related to each other. It can be easily
   exposed by "muxid" like this:
   pin 1
   pin 2
   pin 3 muxid 100
   pin 4 muxid 100
   pin 5 muxid 101
   pin 6 muxid 101
   In this example pins 3,4 and 5,6 are muxed, therefore the user knows
   if he connects one, the other one gets disconnected (or will have to
   disconnect the first one explicitly first).

4) I don't like the "attr" indirection. It makes things very tangled. It
   comes from the concepts of classes and objects and takes it to
   extreme. Not really something we are commonly used to in kernel.
   Also, it brings no value from what I can see, only makes things very
   hard to read and follow.

   Please keep things direct and simple:
   * If some option could be changed for a pin or dpll, just have an
     op that is directly called from netlink handler to change it.
     There should be clear set of ops for configuration of pin and
     dpll object. This "attr" indirection make this totally invisible.
   * If some attribute is const during dpll or pin lifetime, have it
     passed during dpll or pin creation.



>
>v3 -> v4:
> * redesign framework to make pins dynamically allocated (Arkadiusz)
> * implement shared pins (Arkadiusz)
>v2 -> v3:
> * implement source select mode (Arkadiusz)
> * add documentation
> * implementation improvements (Jakub)
>v1 -> v2:
> * implement returning supported input/output types
> * ptp_ocp: follow suggestions from Jonathan
> * add linux-clk mailing list
>v0 -> v1:
> * fix code style and errors
> * add linux-arm mailing list
>
>
>Arkadiusz Kubalewski (1):
>  dpll: add dpll_attr/dpll_pin_attr helper classes
>
>Vadim Fedorenko (3):
>  dpll: Add DPLL framework base functions
>  dpll: documentation on DPLL subsystem interface
>  ptp_ocp: implement DPLL ops
>
> Documentation/networking/dpll.rst  | 271 ++++++++
> Documentation/networking/index.rst |   1 +
> MAINTAINERS                        |   8 +
> drivers/Kconfig                    |   2 +
> drivers/Makefile                   |   1 +
> drivers/dpll/Kconfig               |   7 +
> drivers/dpll/Makefile              |  11 +
> drivers/dpll/dpll_attr.c           | 278 +++++++++
> drivers/dpll/dpll_core.c           | 760 +++++++++++++++++++++++
> drivers/dpll/dpll_core.h           | 176 ++++++
> drivers/dpll/dpll_netlink.c        | 963 +++++++++++++++++++++++++++++
> drivers/dpll/dpll_netlink.h        |  24 +
> drivers/dpll/dpll_pin_attr.c       | 456 ++++++++++++++
> drivers/ptp/Kconfig                |   1 +
> drivers/ptp/ptp_ocp.c              | 123 ++--
> include/linux/dpll.h               | 261 ++++++++
> include/linux/dpll_attr.h          | 433 +++++++++++++
> include/uapi/linux/dpll.h          | 263 ++++++++
> 18 files changed, 4002 insertions(+), 37 deletions(-)
> create mode 100644 Documentation/networking/dpll.rst
> create mode 100644 drivers/dpll/Kconfig
> create mode 100644 drivers/dpll/Makefile
> create mode 100644 drivers/dpll/dpll_attr.c
> create mode 100644 drivers/dpll/dpll_core.c
> create mode 100644 drivers/dpll/dpll_core.h
> create mode 100644 drivers/dpll/dpll_netlink.c
> create mode 100644 drivers/dpll/dpll_netlink.h
> create mode 100644 drivers/dpll/dpll_pin_attr.c
> create mode 100644 include/linux/dpll.h
> create mode 100644 include/linux/dpll_attr.h
> create mode 100644 include/uapi/linux/dpll.h
>
>-- 
>2.27.0
>
