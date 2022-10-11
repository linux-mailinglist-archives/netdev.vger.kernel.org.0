Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08B715FAEAD
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 10:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbiJKIrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 04:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiJKIrM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 04:47:12 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4913660520
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 01:47:08 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id qw20so29242667ejc.8
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 01:47:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LK95q74XIadLRG8UNQxgJhN9fL+IlgoqYblU0SzXCh8=;
        b=A/Vx135nKgYBGqsMpFR3ZJPhtMdCqDjjhnOaqdeqKr0D24HYjfYXxqjYaQpM6NU/qb
         ralcbMVh16ryYzi7mGrqux//glGa01eCv8mSCPDNvmjbaV+suo5mm41Rwp/vUaHDz3KW
         UGVi/bw/ac756KJESbu8mvt1mW+q1ay3ZvDJ1whC+4cb1fpUJA9+BQuiErag2u423HBw
         myH0mv3Cd1c7NwiyV8Jndq6Um3i9QQSiVLhexoH11YX17XUzxPxf/RZrA52Elf4OQCsH
         ZppFdgpwIIi2GteHAyYyY67eAu5lkopbd0pIQsUO4FI78mFySC2BN+kYtdaveigQS+v3
         ianA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LK95q74XIadLRG8UNQxgJhN9fL+IlgoqYblU0SzXCh8=;
        b=GbixqkpW87DoMkj6z/MJ5b2gx5Vy1q16g0OkYQimFF6kuXxLyTmFRPofDXMQeLFOxw
         LLhZOvAHK3aI2bAhpLdWB2NJIcGyOCwarRP2CP5RAw9sJEKErohx0f1edf7yNGPSSm6F
         54NbbKwPK20drGMoEtTfABCDl4q4WDjKMN4Jpz9k5dwSRKRqUdWX7mTS5MEjCp1JjWbr
         qA/FA9ZZvLb0Ey9fOO+6/zXv9OevUJEy4zDc2XiPdPDxLet7UkEzXSGETPxJ0YLFUaJB
         vWFxuSUQ5VsFYhK3t4/OxPevfU3rKtozJsMvTkj+gpijnpboGNkTMifH9WdK6G0WWQl4
         /rIw==
X-Gm-Message-State: ACrzQf03JvbkR0hrpDFG6OsC8W+oomL2MqUNuDivoWQVVcgzp0ArZdW0
        Oz39B9f+MWnniOt0zZ3thT9PYw==
X-Google-Smtp-Source: AMsMyM5+hP9RU4wT1m5tt5KypA6kO/GWwcR9/era6nY/8kWGijTj2YDqjkWYQGh2kWquIc1bEOFo2Q==
X-Received: by 2002:a17:906:730f:b0:783:27c5:f65f with SMTP id di15-20020a170906730f00b0078327c5f65fmr19132415ejc.142.1665478025961;
        Tue, 11 Oct 2022 01:47:05 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id 2-20020a170906300200b0077a11b79b9bsm2277917ejz.133.2022.10.11.01.47.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 01:47:05 -0700 (PDT)
Date:   Tue, 11 Oct 2022 10:47:04 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org, Vadim Fedorenko <vadfed@fb.com>
Subject: Re: [RFC PATCH v3 1/6] dpll: Add DPLL framework base functions
Message-ID: <Y0UtiBRcc8aBS4tD@nanopsycho>
References: <20221010011804.23716-1-vfedorenko@novek.ru>
 <20221010011804.23716-2-vfedorenko@novek.ru>
 <Y0PjULbYQf1WbI9w@nanopsycho>
 <24d1d750-7fd0-44e2-318c-62f6a4a23ea5@novek.ru>
 <Y0UqFml6tEdFt0rj@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0UqFml6tEdFt0rj@nanopsycho>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Oct 11, 2022 at 10:32:22AM CEST, jiri@resnulli.us wrote:
>Mon, Oct 10, 2022 at 09:54:26PM CEST, vfedorenko@novek.ru wrote:
>>On 10.10.2022 10:18, Jiri Pirko wrote:
>>> Mon, Oct 10, 2022 at 03:17:59AM CEST, vfedorenko@novek.ru wrote:
>>> > From: Vadim Fedorenko <vadfed@fb.com>

[...]


>>I see your point. We do have hardware which allows changing type of SMA
>>connector, and even the direction, each SMA could be used as input/source or
>>output of different signals. But there are limitation, like not all SMAs can
>>produce IRIG-B signal or only some of them can be used to get GNSS 1PPS. The
>
>Okay, so that is not the *type* of source, but rather attribute of it.
>Example:
>
>$ dpll X show
>index 0
>  type EXT
>  signal 1PPS
>  supported_signals
>     1PPS 10MHz
>
>$ dpll X set source index 1 signal_type 10MHz
>$ dpll X show
>index 0
>  type EXT
>  signal 10MHz
>  supported_signals
>     1PPS 10MHz
>
>So one source with index 0 of type "EXT" (could be "SMA", does not
>matter) supports 1 signal types.
>
>
>Thinking about this more and to cover the case when one SMA could be
>potencially used for input and output. It already occured to me that
>source/output are quite similar, have similar/same attributes. What if
>they are merged together to say a "pin" object only with extra
>PERSONALITY attribute?
>
>Example:
>
>-> DPLL_CMD_PIN_GET - dump
>      ATTR_DEVICE_ID X
>
><- DPLL_CMD_PIN_GET
>
>       ATTR_DEVICE_ID X
>       ATTR_PIN_INDEX 0
>       ATTR_PIN_TYPE EXT
>       ATTR_PIN_SIGNAL 1PPS   (selected signal)
>       ATTR_PIN_SUPPORTED_SIGNALS (nest)
>         ATTR_PIN_SIGNAL 1PPS
>         ATTR_PIN_SIGNAL 10MHZ
>       ATTR_PIN_PERSONALITY OUTPUT   (selected personality)
>       ATTR_PIN_SUPPORTED_PERSONALITIES (nest)
>         ATTR_PIN_PERSONALITY DISCONNECTED
>         ATTR_PIN_PERSONALITY INPUT
>         ATTR_PIN_PERSONALITY OUTPUT     (note this supports both input and
>					  output)
>
>       ATTR_DEVICE_ID X
>       ATTR_PIN_INDEX 1
>       ATTR_PIN_TYPE EXT
>       ATTR_PIN_SIGNAL 10MHz   (selected signal)
>       ATTR_PIN_SUPPORTED_SIGNALS (nest)
>         ATTR_PIN_SIGNAL 1PPS
>         ATTR_PIN_SIGNAL 10MHZ
>       ATTR_PIN_PERSONALITY DISCONNECTED   (selected personality - not
>					    connected currently)
>       ATTR_PIN_SUPPORTED_PERSONALITIES (nest)
>         ATTR_PIN_PERSONALITY DISCONNECTED
>         ATTR_PIN_PERSONALITY INPUT      (note this supports only input)
>
>       ATTR_DEVICE_ID X
>       ATTR_PIN_INDEX 2
>       ATTR_PIN_TYPE GNSS
>       ATTR_PIN_SIGNAL 1PPS   (selected signal)
>       ATTR_PIN_SUPPORTED_SIGNALS (nest)
>         ATTR_PIN_SIGNAL 1PPS
>       ATTR_PIN_PERSONALITY INPUT   (selected personality - note this is
>				     now he selected source, being only
>				     pin with INPUT personality)
>       ATTR_PIN_SUPPORTED_PERSONALITIES (nest)
>         ATTR_PIN_PERSONALITY DISCONNECTED
>         ATTR_PIN_PERSONALITY INPUT      (note this supports only input)
>
>       ATTR_DEVICE_ID X
>       ATTR_PIN_INDEX 3
>       ATTR_PIN_TYPE SYNCE_ETH_PORT
>       ATTR_PIN_NETDEV_IFINDEX 20
>       ATTR_PIN_PERSONALITY OUTPUT   (selected personality)
>       ATTR_PIN_SUPPORTED_PERSONALITIES (nest)
>         ATTR_PIN_PERSONALITY DISCONNECTED
>         ATTR_PIN_PERSONALITY INPUT
>         ATTR_PIN_PERSONALITY OUTPUT     (note this supports both input and
>					  output)
>
>       ATTR_DEVICE_ID X
>       ATTR_PIN_INDEX 4
>       ATTR_PIN_TYPE SYNCE_ETH_PORT
>       ATTR_PIN_NETDEV_IFINDEX 30
>       ATTR_PIN_PERSONALITY OUTPUT   (selected personality)
>       ATTR_PIN_SUPPORTED_PERSONALITIES (nest)
>         ATTR_PIN_PERSONALITY DISCONNECTED
>         ATTR_PIN_PERSONALITY INPUT
>         ATTR_PIN_PERSONALITY OUTPUT     (note this supports both input and
>					  output)
>
>
>This allows the user to actually see the full picture:
>1) all input/output pins in a single list, no duplicates
>2) each pin if of certain type (ATTR_PIN_TYPE) EXT/GNSS/SYNCE_ETH_PORT
>3) the pins that can change signal type contain the selected and list of
>   supported signal types (ATTR_PIN_SIGNAL, ATTR_PIN_SUPPORTED_SIGNALS)
>4) direction/connection of the pin to the DPLL is exposed over
>   ATTR_PIN_PERSONALITY. For each pin, the driver would expose it can
>   act as INPUT/OUTPUT and even more, it can indicate the pin can
>   disconnect from DPLL entirely (if possible).
>5) user can select the source by setting ATTR_PIN_PERSONALITY of certain
>   pin to INPUT. Only one pin could be set to INPUT and that is the
>   souce of DPLL.
>   In case no pin have personality set to INPUT, the DPLL is
>   free-running.

Okay, thinking about it some more, I would leave the source select
indepentent from the ATTR_PIN_PERSONALITY and selectable using device
set cmd and separate attribute. It works better even more when consider
autoselect mode.

Well of course only pins with ATTR_PIN_PERSONALITY INPUT could be
selected as source.


>
>This would introduce quite nice flexibility, exposes source/output
>capabilities and provides good visilibity of current configuration.
>
>
>>interface was created to cover such case. I believe we have to improve it to
>>cover SyncE configuration better, but I personally don't have SyncE hardware
>>ready to test and that's why I have to rely on suggestions from yours or
>>Arkadiusz's experience. From what I can see now there is need for special
>>attribute to link source to net device, and I'm happy to add it. In case of
>>fixed configuration of sources, the device should provide only one type as
>>supported and that's it.
>>

[...]
