Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0BF946575D
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 21:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236004AbhLAUvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 15:51:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353129AbhLAUtc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 15:49:32 -0500
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C4C7C0613FB;
        Wed,  1 Dec 2021 12:45:58 -0800 (PST)
Received: by mail-ua1-x931.google.com with SMTP id a14so51792315uak.0;
        Wed, 01 Dec 2021 12:45:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3gsFnP+ZnxQscLfmhBB0/p1c5J9Ak8k7rgkq4hSbtPQ=;
        b=YtVeQMqgjlOKpjN7MT2MGh1HqrZnG7ce/h1z66L++jDUBQvVjYZxt3OovOfBy9Ml3P
         QiHjq9T43KZHl3QtzNaqQ8+dRGcqDGYfd6b7qKlq9QeuhPM/K7jvsOvv94Xmys17Qmc5
         V0gKny8+hjMzx2cY3rzhrERvJmggeujnvUEa9j/eTFtq7zggicoUNDCzCCZa12Zu15KN
         2N7lqxKHWqm2uV2Mzt20reBxADCBond0JmogF3dzzFSoY3nZFeCTaNrbycUYIW/7joQL
         uA4kpWIzIcDCS092/lPuzKExkEhmBSXJJSuzmy5cr1g0B3D/Av3OixBXWBUctQThRQqd
         nZzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3gsFnP+ZnxQscLfmhBB0/p1c5J9Ak8k7rgkq4hSbtPQ=;
        b=rlNW99qWoBUlKDeO908raGtygLaqxwB/c3yIeps+IftHg7X58/C1TQj4s6TASgya3C
         zF7guB1xBgdUgE3P2EFs7GPRMS9R6NRycoMUMJu4ae/wyH1KrcTCXObM7clE1Fmxk4hQ
         9Qvu47pSaVR4riuMGretONo2AsyQ30ayVPlJf69TWAXY2xjBB0A+J8/3e8HOz7Xh9Btl
         VRE7yVBnn6oMplvgagj1gbrs7C5bhqaUAtYRxnAF0IMokEQz1+UuVtOFU0Mh1zpVibio
         OmX+nLzLq9YnPvBMc9VpAQwpw/Kvei4xlKgLJGBgQWhhdwEgdKm25V5SFvXOZIirHb4F
         aaaA==
X-Gm-Message-State: AOAM533FIuziqfWJJWVNN7iwmA1kt+exZF1huSici83na35JicivAx7K
        vT8VktI2wdwkmX+Y4sLKIVmLCvlhquusDzwImX8=
X-Google-Smtp-Source: ABdhPJwoznrM0H9yVzZ4pUHufuowilbQu6Bp3EUJlTqGs2pwfxnx+da5GUzNrVQZAXPfp3YIq3RV00iZgMcfdJkla5Q=
X-Received: by 2002:a05:6102:c4e:: with SMTP id y14mr11489182vss.61.1638391558160;
 Wed, 01 Dec 2021 12:45:58 -0800 (PST)
MIME-Version: 1.0
References: <20211101035635.26999-1-ricardo.martinez@linux.intel.com>
 <20211101035635.26999-7-ricardo.martinez@linux.intel.com> <CAHNKnsRe-88_jXvW4=0rPSDhVTbnJnDoeLpjHS4ouDv3pJXWSg@mail.gmail.com>
 <a9f1237c-78d5-d64e-6980-a7c7c5f6f5f9@linux.intel.com>
In-Reply-To: <a9f1237c-78d5-d64e-6980-a7c7c5f6f5f9@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Wed, 1 Dec 2021 23:45:47 +0300
Message-ID: <CAHNKnsSn9TRHdZiih6Y0geSD+e5CdY-uUeuvAvWdA0==e8GEEw@mail.gmail.com>
Subject: Re: [PATCH v2 06/14] net: wwan: t7xx: Add AT and MBIM WWAN ports
To:     "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        chandrashekar.devegowda@intel.com,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        mika.westerberg@linux.intel.com, moises.veleta@intel.com,
        pierre-louis.bossart@intel.com, muralidharan.sethuraman@intel.com,
        Soumya.Prakash.Mishra@intel.com, sreehari.kancharla@intel.com,
        suresh.nagaraj@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Ricardo,

On Wed, Dec 1, 2021 at 9:14 AM Martinez, Ricardo
<ricardo.martinez@linux.intel.com> wrote:
> On 11/9/2021 4:06 AM, Sergey Ryazanov wrote:
>> On Mon, Nov 1, 2021 at 6:57 AM Ricardo Martinez wrote:
>>> ...
>>>   static struct t7xx_port md_ccci_ports[] = {
>>> +       {CCCI_UART2_TX, CCCI_UART2_RX, DATA_AT_CMD_Q, DATA_AT_CMD_Q, 0xff,
>>> +        0xff, ID_CLDMA1, PORT_F_RX_CHAR_NODE, &wwan_sub_port_ops, 0, "ttyC0", WWAN_PORT_AT},
>>> +       {CCCI_MBIM_TX, CCCI_MBIM_RX, 2, 2, 0, 0, ID_CLDMA1,
>>> +        PORT_F_RX_CHAR_NODE, &wwan_sub_port_ops, 10, "ttyCMBIM0", WWAN_PORT_MBIM},
>>> ...
>>> +               if (count + CCCI_H_ELEN > txq_mtu &&
>>> +                   (port_ccci->tx_ch == CCCI_MBIM_TX ||
>>> +                    (port_ccci->tx_ch >= CCCI_DSS0_TX && port_ccci->tx_ch <= CCCI_DSS7_TX)))
>>> +                       multi_packet = DIV_ROUND_UP(count, txq_mtu - CCCI_H_ELEN);
>>
>> I am just wondering, the chip does support MBIM message fragmentation,
>> but does not support AT commands stream (CCCI_UART2_TX) fragmentation.
>> Is that the correct conclusion from the code above?
>
> Yes, that is correct.

Are you sure that the modem does not support AT command fragmentation?
The AT commands interface is a stream of chars by its nature. It is
designed to work over serial lines. Some modem configuration software
even writes commands to a port in a char-by-char manner, i.e. it
writes no more than one char at a time to the port.

The mechanism that is implemented in the driver to split user input
into individual messages is not a true fragmentation mechanism since
it does not preserve the original user input length. It just cuts the
user input into individual messages and sends them to the modem
independently. So, the modem firmware has no way to distinguish
whether the user input has been "fragmented" by the user or the
driver. How, then, does the modem firmware deal with an AT command
"fragmented" by a user? Will the modem firmware ignore the AT command
that is received in the char-by-char manner?

-- 
Sergey
