Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDEB2553F22
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 01:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbiFUXpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 19:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbiFUXpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 19:45:15 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8D53313AC
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 16:45:14 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-31772f8495fso145718127b3.4
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 16:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HOOb28yXlIwXR2aXR35cW9PpO/c5xONXnfV/FY/1RUc=;
        b=D083YPvG/j+BIXDOQCA8szml1M9ThHUkMVmVsIpmyseYhvbF5k86mCrVBruo6Byv07
         XJ+zlQOIt+aOv3H3vXLhNj83yfQtrI+x4XiChFeVEFEBWxkMxRBwJ8m5LhBOlAQi2/45
         LgFWU2DWCByci7lE4R37EzffuEMNUjlEfkBx7Fyrid9++et3GzfOAWsmhV9H9kjBfZ4U
         j8drUu3/CD0IRS+5xfH15g0ea0LPCAxjkEHYinNw+hEJVUTzmrvPkS71pf+qz9+943+4
         Marcf2dW0lHSxtfpo+lJlBW6jdr90eiarxDYyHaKyzrvlEQtsDIX+6T+X99xgIYWpBFm
         cdFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HOOb28yXlIwXR2aXR35cW9PpO/c5xONXnfV/FY/1RUc=;
        b=FBUv1FPKXFmWN1SQb+0SZmh9eExImARdAiQd86ZsB+W6HASciZKnlGP5r3m7OzbN/B
         AwFaxTp/MIG3Nx3vlYa8CdERp1gnGQgJASqN+2WBcZxMk/gfbHp/UsFEzMTCLFI9NCCF
         /AgoFBDM/Y0nQeUS0SI1Doy6uY0186xtva73NrVHQfnCCQfSP58EqS78HXJlatOg5ZSq
         jjMfiJciVmeKIc9MpoFzk8WTiePBMiUu4dqLlCvKoH19Mb1Cuf4prKwvTZGHQmGdhil3
         3d7vGurMjvrrmoAYhp5iugoWD+PMTIxOLKx0h0VOTLBy2iv041xxsYNd048od61IPCiB
         iWFg==
X-Gm-Message-State: AJIora8qnFCpSXmGkQDCWM9qdrTZ8GHz3JfbCOyf4ScGoYY+Oxyjt072
        C3AUrkbLaxTxvyflGgaC7Lhs8NG+FoJYvE3Mbac=
X-Google-Smtp-Source: AGRyM1sC4M8rgIS5S0DHsjdv4ALur2XPYWtyPocn56I8LtPBZnbqzCTjghGhvNgVtuutriKs/bhNIHrgpcCWFAn/XCA=
X-Received: by 2002:a0d:ff81:0:b0:317:bfca:bb33 with SMTP id
 p123-20020a0dff81000000b00317bfcabb33mr817587ywf.516.1655855113962; Tue, 21
 Jun 2022 16:45:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220614205756.6792-1-moises.veleta@linux.intel.com>
 <CAMZdPi8cdgDUtDN=Oqz7Po+_XsKS=tRmx-Hg=_Mix9ftKQ5b3A@mail.gmail.com>
 <566dc410-458e-8aff-7839-d568e55f9ff3@linux.intel.com> <CAHNKnsRaOS54c6K_s5JmmgDP2KEV38XpGWY5eAmQJ-EUnQt4Ww@mail.gmail.com>
 <45113752-c6a6-a578-3a5a-575d2348d856@linux.intel.com>
In-Reply-To: <45113752-c6a6-a578-3a5a-575d2348d856@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Wed, 22 Jun 2022 02:45:02 +0300
Message-ID: <CAHNKnsTpxKF2bQMEyGfL=73YvtGWZmra_eL4n_qF+smtwSvmhA@mail.gmail.com>
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

On Tue, Jun 21, 2022 at 7:45 PM moises.veleta
<moises.veleta@linux.intel.com> wrote:
> On 6/18/22 04:55, Sergey Ryazanov wrote:
>> On Fri, Jun 17, 2022 at 8:28 PM moises.veleta
>> <moises.veleta@linux.intel.com> wrote:
>>> On 6/16/22 10:29, Loic Poulain wrote:
>>>> On Tue, 14 Jun 2022 at 22:58, Moises Veleta
>>>> <moises.veleta@linux.intel.com> wrote:
>>>>> The t7xx device contains two Cross Layer DMA (CLDMA) interfaces to
>>>>> communicate with AP and Modem processors respectively. So far only
>>>>> MD-CLDMA was being used, this patch enables AP-CLDMA and the GNSS
>>>>> port which requires such channel.
>>>>>
>>>>> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
>>>>> Co-developed-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
>>>>> Signed-off-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
>>>>> Signed-off-by: Moises Veleta <moises.veleta@linux.intel.com>
>>>>> ---
>>>> [...]
>>>>>    static const struct t7xx_port_conf t7xx_md_port_conf[] = {
>>>>>           {
>>>>> +               .tx_ch = PORT_CH_AP_GNSS_TX,
>>>>> +               .rx_ch = PORT_CH_AP_GNSS_RX,
>>>>> +               .txq_index = Q_IDX_CTRL,
>>>>> +               .rxq_index = Q_IDX_CTRL,
>>>>> +               .path_id = CLDMA_ID_AP,
>>>>> +               .ops = &wwan_sub_port_ops,
>>>>> +               .name = "t7xx_ap_gnss",
>>>>> +               .port_type = WWAN_PORT_AT,
>>>> Is it really AT protocol here? wouldn't it be possible to expose it
>>>> via the existing GNSS susbsystem?
>>> The protocol is AT.
>>> It is not possible to using the GNSS subsystem as it is meant for
>>> stand-alone GNSS receivers without a control path. In this case, GNSS
>>> can used for different use cases, such as Assisted GNSS, Cell ID
>>> positioning, Geofence, etc. Hence, this requires the use of the AT
>>> channel on the WWAN subsystem.
>> To make it clear. When you talking about a control path, did you mean
>> that this GNSS port is not a simple NMEA port? Or did you mean that
>> this port is NMEA, but the user is required to activate GPS
>> functionality using the separate AT-commands port?
>>
>> In other words, what is the format of the data that are transmitted
>> over the GNSS port of the modem?
>>
> It is an AT port where MTK GNSS AT commands can be sent and received.
> Not a simple NMEA port, but NMEA data can be sent to Host via an AT
> command. Control port is exposed for Modem Manager to send GNSS comands,
> which may include disable/enable GPS functionality (enabled by default).
>
> These are MTK GNSS AT commands, which follow the syntax as defined by
> 3GPP TS 27.007.  These are not standard AT commands.

Now it is pretty clear. Thank you for your explanation. Please add
this info somewhere near the GNSS port static configuration. This will
help avoid similar confusion in the future.

BTW, does the regular AT port of this modem support the MTK GNSS AT
commands? Or maybe the GNSS port supports regular modem management AT
commands (PDP, RSSI, SMS, etc.)? In other words, are these GNSS and AT
ports interchangeable or does each have a specific purpose?

If both ports are interchangeable, then it is ok to expose each as a
WWAN AT port. But if the GNSS port only supports the MTK GNSS AT
commands, then I am afraid we should not expose it via the WWAN
subsystem at least as a regular AT port. This probably will confuse a
user a lot.

It is not the format of the command used, it is a matter of the
interface nature. There will be different controlling daemons. E.g.,
the AT port will be used by ModemManager or something similar and the
GNSS port will be used by gpsd. And a user will have a hard time to
figure out which WWAN AT port should be used for what purpose if we
expose these ports simply as wwan0at0 and wwan0at1.

-- 
Sergey
