Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0F2F675513
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 13:56:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbjATM4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 07:56:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjATM4k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 07:56:40 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 473505FFF
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 04:56:38 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id g11so1160528eda.12
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 04:56:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YA0Lc/7gd6GGdSfySVcU6D0QEZc1V1Kdc4VBtpNZfBc=;
        b=a7UxM5tyUCGQSknnpU1I+L9xi4PrVNann5F0QWQziRZHPzz3ltSdgNV5tg8kxElga6
         zMrhKfnN9oXjo84jTY8Kxr7KPtmb4TejhIaupZBIki/2fUhKqdvkNoMe/6hkdrW6/uA1
         ejpvhotEcwL20BOSOL6Osrb/MrgWUuT3AF4c+kl2HNS8SqzaDinqAwoBb1ZjJReDIFJ6
         JOLlHBx+MyS0oNrWMaSnaRU/i4R5wTs77qeTzwodugV8HjxacGDQw6UdcIH3mmmViIVd
         I+DUTcCg6q61Xvk2WuQxB4k/WxqN2im517eBnBLYGm/2TcquEAVCk8bFO+3a2vbShCFw
         kecg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YA0Lc/7gd6GGdSfySVcU6D0QEZc1V1Kdc4VBtpNZfBc=;
        b=UNRf3ezFbmiTo9kw7yUuZ80a4k9nUkMxo5acGOmiULXLD5W+Vo5qf078TlzYdMwzeb
         INnNHDF5qf84rR/BkRl7rI8HPVIKOrEOPpgfkJhs77Jcmcb84oEAks9f3O3i4N05JoI8
         StICtrE3vxoDORHWn6wweOHpIA6iNdZmeGHn/9ayzvXizXB6CmQN8qOjjgb5tVZbyMfy
         NDmNAzBs8X94/zzQxk+h1nULz9B47GWpJvqUmavlkgKam4nL9wJ4NNV2DYNt+bZ8qxJ/
         8e/+0QUdBW+DVxahoQQN+2UXkYi5IbXokh2XmcQk/3exR0y/oeM+s9uJZ+G7bGrHQ+JS
         U3Kw==
X-Gm-Message-State: AFqh2koZ8XitmH8EKbaQoxkZHcBYPzvWsgNxidbfPJuNs4v0RJQIczCt
        jD1G7gw1zsYipITrWmWqSBQMlQ==
X-Google-Smtp-Source: AMrXdXuaj4zDXYxtP+fZPrrgfOW1exYB7z7ZTASR8cFVBTBvtbduPl3R+x8dgVlWXIAS2+C+uv77ww==
X-Received: by 2002:a05:6402:5d3:b0:49b:58ca:ebbc with SMTP id n19-20020a05640205d300b0049b58caebbcmr17881279edx.32.1674219396721;
        Fri, 20 Jan 2023 04:56:36 -0800 (PST)
Received: from localhost ([217.111.27.204])
        by smtp.gmail.com with ESMTPSA id x14-20020a056402414e00b0045b4b67156fsm17277051eda.45.2023.01.20.04.56.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 04:56:35 -0800 (PST)
Date:   Fri, 20 Jan 2023 13:56:34 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadim Fedorenko <vadfed@meta.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        Milena Olech <milena.olech@intel.com>,
        Michal Michalik <michal.michalik@intel.com>
Subject: Re: [RFC PATCH v5 1/4] dpll: Add DPLL framework base functions
Message-ID: <Y8qPgj9BFsbFKhwx@nanopsycho>
References: <20230117180051.2983639-1-vadfed@meta.com>
 <20230117180051.2983639-2-vadfed@meta.com>
 <Y8l63RF8DQz3i0LY@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8l63RF8DQz3i0LY@nanopsycho>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jan 19, 2023 at 06:16:13PM CET, jiri@resnulli.us wrote:
>Tue, Jan 17, 2023 at 07:00:48PM CET, vadfed@meta.com wrote:

[...]


>>+/**
>>+ * dpll_cmd - Commands supported by the dpll generic netlink family
>>+ *
>>+ * @DPLL_CMD_UNSPEC - invalid message type
>>+ * @DPLL_CMD_DEVICE_GET - Get list of dpll devices (dump) or attributes of
>>+ *	single dpll device and it's pins
>>+ * @DPLL_CMD_DEVICE_SET - Set attributes for a dpll
>>+ * @DPLL_CMD_PIN_SET - Set attributes for a pin
>>+ **/
>>+enum dpll_cmd {
>>+	DPLL_CMD_UNSPEC,
>>+	DPLL_CMD_DEVICE_GET,
>>+	DPLL_CMD_DEVICE_SET,
>>+	DPLL_CMD_PIN_SET,
>
>Have pin get to get list of pins, then you can have 1:1 mapping to
>events and loose the enum dpll_event_change. This is the usual way to do
>stuff. Events have the same cmd and message format as get.

I was thinking about that a bit more.
1) There is 1:n relationship between PIN and DPLL(s).
2) The pin configuration is independent on DPLL, with an
   exeption of PRIO.

Therefore as I suggested in the reply to this patch, the pin should be
separate entity, allocated and having ops unrelated to DPLL. It is just
registered to the DPLLs that are using the pin.

The pin ops should not have dpll pointer as arg, again with exception of
PRIO.

DPLL_CMD_DEVICE_GET should not contain pins at all.

There should be DPLL_CMD_PIN_GET added which can dump and will be used
to get the list of pins in the system.
- if DPLL handle is passed to DPLL_CMD_PIN_GET, it will dump only pins
  related to the specified DPLL.

DPLL_CMD_PIN_GET message will contain pin-specific attrs and will have a
list of connected DPLLs:
       DPLLA_PIN_IDX
       DPLLA_PIN_DESCRIPTION
       DPLLA_PIN_TYPE
       DPLLA_PIN_SIGNAL_TYPE
       DPLLA_PIN_SIGNAL_TYPE_SUPPORTED
       DPLLA_PIN_CUSTOM_FREQ
       DPLLA_PIN_MODE
       DPLLA_PIN_MODE_SUPPORTED
       DPLLA_PIN_PARENT_IDX
       DPLLA_PIN_DPLL    (nested)
          DPLLA_DPLL_HANDLE   "dpll_0"
          DPLLA_PIN_PRIO    1
       DPLLA_PIN_DPLL    (nested)
          DPLLA_DPLL_HANDLE   "dpll_1"
          DPLLA_PIN_PRIO    2

Please take the names lightly. My point is to show 2 nests for 2
DPLLS connected, on each the pin has different prio.

Does this make sense?

One issue to be solved is the pin indexing. As pin would be separate
entity, the indexing would be global and therefore not predictable. We
would have to figure it out differntly. Pehaps something like this:

$ dpll dev show
pci/0000:08:00.0: dpll 1             first dpll on 0000:08:00.0
pci/0000:08:00.0: dpll 2             second dpll on the same pci device
pci/0000:09:00.0: dpll 1             first dpll on 0000:09:00.0
pci/0000:09:00.0: dpll 2             second dpll on the same pci device

$ dpll pin show
pci/0000:08:00.0: pin 1 desc SOMELABEL_A
  dpll 1:                          This refers to DPLL 1 on the same pci device
    prio 80
  dpll 2:                          This refers to DPLL 2 on the same pci device
    prio 100
pci/0000:08:00.0: pin 2 desc SOMELABEL_B
  dpll 1:
    prio 80
  dpll 2:
    prio 100
pci/0000:08:00.0: pin 3 desc SOMELABEL_C
  dpll 1:
    prio 80
  dpll 2:
    prio 100
pci/0000:08:00.0: pin 4 desc SOMELABEL_D
  dpll 1:
    prio 80
  dpll 2:
    prio 100
pci/0000:09:00.0: pin 1 desc SOMEOTHERLABEL_A
  dpll 1:
    prio 80
  dpll 2:
    prio 100
pci/0000:09:00.0: pin 2 desc SOMEOTHERLABEL_B
  dpll 1:
    prio 80
  dpll 2:
    prio 100
pci/0000:09:00.0: pin 3 desc SOMEOTHERLABEL_C
  dpll 1:
    prio 80
  dpll 2:
    prio 100
pci/0000:09:00.0: pin 4 desc SOMEOTHERLABEL_C
  dpll 1:
    prio 80
  dpll 2:
    prio 100

Note there are 2 groups of pins, one for each pci device.

Setting some attribute command would looks like:
To set DPLL mode:
$ dpll dev set pci/0000:08:00.0 dpll 1 mode freerun
   netlink:
   DPLL_CMD_DEVICE_SET
      DPLLA_BUS_NAME "pci"
      DPLLA_DEV_NAME "0000:08:00.0"
      DPLLA_DPLL_INDEX 1
      DPLLA_DPLL_MODE 3

$ dpll dev set pci/0000:08:00.0 dpll 2 mode automatic


To set signal frequency in HZ:
$ dpll pin set pci/0000:08:00.0 pin 3 frequency 10000000
   netlink:
   DPLL_CMD_PIN_SET
      DPLLA_BUS_NAME "pci"
      DPLLA_DEV_NAME "0000:08:00.0"
      DPLLA_PIN_INDEX 3
      DPLLA_PIN_FREQUENCY 10000000

$ dpll pin set pci/0000:08:00.0 pin 1 frequency 1


To set individual of one pin for 2 DPLLs:
$ dpll pin set pci/0000:08:00.0 pin 1 dpll 1 prio 40
   netlink:
   DPLL_CMD_PIN_SET
      DPLLA_BUS_NAME "pci"
      DPLLA_DEV_NAME "0000:08:00.0"
      DPLLA_PIN_INDEX 1
      DPLLA_DPLL_INDEX 1
      DPLLA_PIN_PRIO 40

$ dpll pin set pci/0000:08:00.0 pin 1 dpll 2 prio 80


Isn't this neat?


[...]
