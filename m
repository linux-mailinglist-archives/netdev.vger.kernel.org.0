Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9812F550456
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 13:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233218AbiFRL4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jun 2022 07:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbiFRL4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jun 2022 07:56:09 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5400111147
        for <netdev@vger.kernel.org>; Sat, 18 Jun 2022 04:56:08 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id p129so8345642oig.3
        for <netdev@vger.kernel.org>; Sat, 18 Jun 2022 04:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I0nc3b3/USythZUFIWXt1CvDQN2qkh8vERQLw9FUP0s=;
        b=ZenWYjANA2sFCkeclGgoi6Vjm0stSc8Mztf7nkXrGK3b4J4hTZofxolFrXgTokmsXI
         hJCIhJ110RshQ+sY+2hyPyfRJNukLEs9C3cVssuyynxGjDTMLqggoCf2FOZGCuobQUyB
         xPr3cuIVxD+KjS+KfLX5UynJd24juaV87NU5ptDLRkk0s8sH492P1DR7Xgz0ianmI8kx
         0ciEPwGAWGDTSkI39fDo0vES5IqlF2FPSxBSZ5/A6SOSZ2luFBK45gCWlrr/TC77RzEh
         o0q5lpZoGdS0atyFrum/SFImjdh2sJpqIxBFPoicm+F0oN2LRh7YMEJ+rmFCLIpIhhxc
         uRdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I0nc3b3/USythZUFIWXt1CvDQN2qkh8vERQLw9FUP0s=;
        b=C/S1ui5AZro+IYLyK6P2ItFsVQt7l9Jw5pR8V96vR99PlYEDJtQb7Ym+P2oAWsH4k3
         jrLV9yH+5LaMZQFclv9ANC7GdTrMgoeBE6vSm63eblKjU98EUnLJSGf8lhOD1aKrW5Cr
         MHvvKiHQCWIawhZLkjrBVx4/PrC2FtQKIlvL7iY1lMc1rRHH+xgLRHb36aG9KsLhlfgI
         rRcRwTbBIroJ2Iu0552j6GkIdWC6RABLTeEvrENFKUEbUptMlS7dAc3xrV3uFoeVLS68
         OxzeTdlgS3Dp5AlfFXAecbHhYk3umN/a9hvFqAjI/QYl/BZ6TK5nui1KsroqUM5VQx/s
         9J5A==
X-Gm-Message-State: AJIora9Hnku+R8tCFHr6F2BPOVIUw1PQfoUVZbyCF2brGgVwJaAfl1xA
        fOM7k95gvtDMhS6lFqiWXs+ZfyAH7pK8O/vuW+9rkw2sHDYARpBg
X-Google-Smtp-Source: AGRyM1v3H2l4y0+t64VTu4bClAG/wE+dhwAhBzF9lSzapI+dortOkP70qhDWzMcY/p/vYX1q3v6X2uiPVpJk1+w4gzM=
X-Received: by 2002:a05:6808:130c:b0:32f:4589:c8fd with SMTP id
 y12-20020a056808130c00b0032f4589c8fdmr7462132oiv.220.1655553367759; Sat, 18
 Jun 2022 04:56:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220614205756.6792-1-moises.veleta@linux.intel.com>
 <CAMZdPi8cdgDUtDN=Oqz7Po+_XsKS=tRmx-Hg=_Mix9ftKQ5b3A@mail.gmail.com> <566dc410-458e-8aff-7839-d568e55f9ff3@linux.intel.com>
In-Reply-To: <566dc410-458e-8aff-7839-d568e55f9ff3@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Sat, 18 Jun 2022 14:55:56 +0300
Message-ID: <CAHNKnsRaOS54c6K_s5JmmgDP2KEV38XpGWY5eAmQJ-EUnQt4Ww@mail.gmail.com>
Subject: Re: [PATCH net-next 1/1] net: wwan: t7xx: Add AP CLDMA and GNSS port
To:     "moises.veleta" <moises.veleta@linux.intel.com>
Cc:     Loic Poulain <loic.poulain@linaro.org>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        "Devegowda, Chandrashekar" <chandrashekar.devegowda@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com,
        =?UTF-8?B?SGFpanVuIExpdSAo5YiY5rW35YabKQ==?= 
        <haijun.liu@mediatek.com>,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Sharma, Dinesh" <dinesh.sharma@intel.com>,
        =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        "Veleta, Moises" <moises.veleta@intel.com>,
        Madhusmita Sahu <madhusmita.sahu@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Moises,

On Fri, Jun 17, 2022 at 8:28 PM moises.veleta
<moises.veleta@linux.intel.com> wrote:
> On 6/16/22 10:29, Loic Poulain wrote:
>> Hi Moises,
>>
>> On Tue, 14 Jun 2022 at 22:58, Moises Veleta
>> <moises.veleta@linux.intel.com> wrote:
>>> From: Haijun Liu <haijun.liu@mediatek.com>
>>>
>>> The t7xx device contains two Cross Layer DMA (CLDMA) interfaces to
>>> communicate with AP and Modem processors respectively. So far only
>>> MD-CLDMA was being used, this patch enables AP-CLDMA and the GNSS
>>> port which requires such channel.
>>>
>>> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
>>> Co-developed-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
>>> Signed-off-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
>>> Signed-off-by: Moises Veleta <moises.veleta@linux.intel.com>
>>> ---
>> [...]
>>>   static const struct t7xx_port_conf t7xx_md_port_conf[] = {
>>>          {
>>> +               .tx_ch = PORT_CH_AP_GNSS_TX,
>>> +               .rx_ch = PORT_CH_AP_GNSS_RX,
>>> +               .txq_index = Q_IDX_CTRL,
>>> +               .rxq_index = Q_IDX_CTRL,
>>> +               .path_id = CLDMA_ID_AP,
>>> +               .ops = &wwan_sub_port_ops,
>>> +               .name = "t7xx_ap_gnss",
>>> +               .port_type = WWAN_PORT_AT,
>> Is it really AT protocol here? wouldn't it be possible to expose it
>> via the existing GNSS susbsystem?
>
> The protocol is AT.
> It is not possible to using the GNSS subsystem as it is meant for
> stand-alone GNSS receivers without a control path. In this case, GNSS
> can used for different use cases, such as Assisted GNSS, Cell ID
> positioning, Geofence, etc. Hence, this requires the use of the AT
> channel on the WWAN subsystem.

To make it clear. When you talking about a control path, did you mean
that this GNSS port is not a simple NMEA port? Or did you mean that
this port is NMEA, but the user is required to activate GPS
functionality using the separate AT-commands port?

In other words, what is the format of the data that are transmitted
over the GNSS port of the modem?

-- 
Sergey
