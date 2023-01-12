Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B94166787A
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 16:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240175AbjALPEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 10:04:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240306AbjALPDK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 10:03:10 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 798269597
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 06:50:50 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id vm8so45339840ejc.2
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 06:50:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yqigpjqdOBD3H+YX96cx5iW5aN2Sy82sRN53SWaFfpQ=;
        b=vpC5aT5Xc4CbMULU8ErpEZg0n98iSLv/1LTtMB3pdQ3ii1wwZDxi1BN71r+WBR3gwz
         XCLj2UNel51FvlKV/wLr4Z2FSOlOXB7fS1IZNuVX7tTEA5Y7aFHJGAAByxDWyJ5oI5bi
         3A7NhwRWaG7QDzTZzsLin2ve0Edb9el4s7qDof1lI/R6roNS9G6w2nT+hQwgVh8g16KB
         aAxr3ju7BLdctjj1QRukOAYRTJzT3qTIqDvHXeHkMgHU4klxGVSY1mP6KV1cG4BpaFn8
         jQbVGPdq+N2FWs9GB2eWki7/NFpI1Mv2thFtTo5gIpA85weZicpQiM6AcYHSCjdBt/f0
         U+sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yqigpjqdOBD3H+YX96cx5iW5aN2Sy82sRN53SWaFfpQ=;
        b=eaH5Vwlyy72FphD3SGivboiIG142u05Z2qwc+3RBxgYvSUPG5u/6HDGinfiUlJPycx
         2xDD8mekOuTD7xMR6tqWgbjPxFUpv10LiZeCfr+kizlMMuwfhdTV8EdFhHf2hoHR1Kwn
         UDn37Nqb9zbOgo3Uip33D/+3WCAWqlZ+UZXnmMrlCL2gfVWatwHmdD8gRCci/IOLnr6M
         Nc8l7aLSeIw22p1SQ4QVF/tWYDfYZB2wJhHvw1RNjU69yi6ulLTE2u35yPxU2cqu88wh
         mfAjEnmJoUmdXpx585AT6Tcq/oRPKGlXQUVlaHLVCHfTHnsM938qjuwJibNu7IWvmJ/u
         kU0A==
X-Gm-Message-State: AFqh2kqLqGRPc8/kvxJAJlrevAcl3lhVwVn/EtAQq4k7QEtnkvlgpt1w
        LC/PxkD+M8EbqVJPbhuyvvtbMA==
X-Google-Smtp-Source: AMrXdXtM20wyj7W7OhWhZQjQKkRV/NmMM6eTbMMW8FWWqTz5PHlKW944BEdC5/4v99CWCk+aDig/Ow==
X-Received: by 2002:a17:906:5f98:b0:84d:1b67:cecb with SMTP id a24-20020a1709065f9800b0084d1b67cecbmr19846042eju.43.1673535048887;
        Thu, 12 Jan 2023 06:50:48 -0800 (PST)
Received: from localhost ([217.111.27.204])
        by smtp.gmail.com with ESMTPSA id eg49-20020a05640228b100b00488117821ffsm7313998edb.31.2023.01.12.06.50.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 06:50:48 -0800 (PST)
Date:   Thu, 12 Jan 2023 15:50:46 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: Re: [RFC PATCH v4 0/4] Create common DPLL/clock configuration API
Message-ID: <Y8AeRnhwqT7Wo8OT@nanopsycho>
References: <20221129213724.10119-1-vfedorenko@novek.ru>
 <DM6PR11MB4657BF81BEBC10E6EC5044149BFD9@DM6PR11MB4657.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR11MB4657BF81BEBC10E6EC5044149BFD9@DM6PR11MB4657.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jan 12, 2023 at 01:23:29PM CET, arkadiusz.kubalewski@intel.com wrote:
>>From: Vadim Fedorenko <vfedorenko@novek.ru>
>>Sent: Tuesday, November 29, 2022 10:37 PM
>>
>>Implement common API for clock/DPLL configuration and status reporting.
>>The API utilises netlink interface as transport for commands and event
>>notifications. This API aim to extend current pin configuration and make it
>>flexible and easy to cover special configurations.
>>
>>v3 -> v4:
>> * redesign framework to make pins dynamically allocated (Arkadiusz)
>> * implement shared pins (Arkadiusz)
>>v2 -> v3:
>> * implement source select mode (Arkadiusz)
>> * add documentation
>> * implementation improvements (Jakub)
>>v1 -> v2:
>> * implement returning supported input/output types
>> * ptp_ocp: follow suggestions from Jonathan
>> * add linux-clk mailing list
>>v0 -> v1:
>> * fix code style and errors
>> * add linux-arm mailing list
>>
>>
>>Arkadiusz Kubalewski (1):
>>  dpll: add dpll_attr/dpll_pin_attr helper classes
>>
>>Vadim Fedorenko (3):
>>  dpll: Add DPLL framework base functions
>>  dpll: documentation on DPLL subsystem interface
>>  ptp_ocp: implement DPLL ops
>>
>> Documentation/networking/dpll.rst  | 271 ++++++++
>> Documentation/networking/index.rst |   1 +
>> MAINTAINERS                        |   8 +
>> drivers/Kconfig                    |   2 +
>> drivers/Makefile                   |   1 +
>> drivers/dpll/Kconfig               |   7 +
>> drivers/dpll/Makefile              |  11 +
>> drivers/dpll/dpll_attr.c           | 278 +++++++++
>> drivers/dpll/dpll_core.c           | 760 +++++++++++++++++++++++
>> drivers/dpll/dpll_core.h           | 176 ++++++
>> drivers/dpll/dpll_netlink.c        | 963 +++++++++++++++++++++++++++++
>> drivers/dpll/dpll_netlink.h        |  24 +
>> drivers/dpll/dpll_pin_attr.c       | 456 ++++++++++++++
>> drivers/ptp/Kconfig                |   1 +
>> drivers/ptp/ptp_ocp.c              | 123 ++--
>> include/linux/dpll.h               | 261 ++++++++
>> include/linux/dpll_attr.h          | 433 +++++++++++++
>> include/uapi/linux/dpll.h          | 263 ++++++++
>> 18 files changed, 4002 insertions(+), 37 deletions(-)  create mode 100644
>>Documentation/networking/dpll.rst  create mode 100644 drivers/dpll/Kconfig
>>create mode 100644 drivers/dpll/Makefile  create mode 100644
>>drivers/dpll/dpll_attr.c  create mode 100644 drivers/dpll/dpll_core.c
>>create mode 100644 drivers/dpll/dpll_core.h  create mode 100644
>>drivers/dpll/dpll_netlink.c  create mode 100644 drivers/dpll/dpll_netlink.h
>>create mode 100644 drivers/dpll/dpll_pin_attr.c  create mode 100644
>>include/linux/dpll.h  create mode 100644 include/linux/dpll_attr.h  create
>>mode 100644 include/uapi/linux/dpll.h
>>
>>--
>>2.27.0
>
>New thread with regard of our yesterday's call.
>
>Is it possible to initialize a multiple output MUX?
>Yes it is. Let's consider 4 input/2 output MUX and DPLL it connects with:
>            +---+   
>          --|   |   
>  +---+     |   |   
>--|   |   --| D |--
>  |   |     | P |   
>--| M |-----| L |--
>  | U |     | L |   
>--| X |-----|   |--
>  |   |     |   |   
>--|   |   --|   |   
>  +---+     +---+  
> 
>Basically dpll pins are initialized and assigned ids, like:
>5 inputs (0-4), 3 outputs (5-7).
>   +---+   
>0--|   |   
>   |   |   
>1--| D |--5
>   | P |   
>2--| L |--6
>   | L |   
>3--|   |--7
>   |   |   
>4--|   |   
>   +---+
>
>Then we would create and register muxed pins with existing dpll pins.
>Each muxed pin is allocated and registered with each parent it can provide
>signal with, like below (number in bracket is parent idx):
>                           +---+   
>                        0--|   |   
>                +---+      |   |   
> 8(2) /  9(3)---|   |   1--| D |--5
>                |   |      | P |   
>10(2) / 11(3)---| M |---2--| L |--6
>                | U |      | L |   
>12(2) / 13(3)---| X |---3--|   |--7
>                |   |      |   |   
>14(2) / 15(3)---|   |   4--|   |   
>                +---+      +---+
>
>Controlling the mux input/output:
>In this case selecting pin #8 would provide its signal into DPLLs input#2 and
>selecting #9 would provide its signal into DPLLs input#3.

Duplication of the mux pin (for example 8,9) seems a bit silly. What if
the mux has 8 outputs? You would have to have 8 pin indexes for each mux
input.

One thing is not clear to me. The mux outputs are fixed or selectable?
I mean, can the outputs be enabled/disabled wired to a specific mux
input?


>
>BR,
>Arkadiusz
