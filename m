Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0CE9560A63
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 21:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbiF2Tgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 15:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiF2Tgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 15:36:52 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 738C7248CB
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 12:36:51 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id h65so22992155oia.11
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 12:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lzjvV6TEGCI2+GkCwCQBGWp15pXCppSxRObppBovh1w=;
        b=mgCmSa8PsVzlAN7QVEWktLRXQsgZ+25lmr0KIyYdymGue2sR+sVP/CE8EoiaIeFSPv
         dc4lxYJ6ZwiK6csrYdxWXQHNKjQHQl4NryYBZZ9+4aKy5xDLw6Oh4citdCIvZ8WDa9y9
         dh5kp8jSGUvifynfzTgZ1Fzyz69pNTw83oDRuJn7PIcio41C60sQfSbS9vZzWMLWWrnO
         /tvYfQFlMuy98QzJjvvs/hLKQVIaNkErFyCMlKXvscO9YcfGl+ARM9YQF49ErKK0wB+a
         fljRTXo6W1qArnjo5iB0ncK3QJOJwV4usx2msUKOTOagiOlg7zo1qUftBgXOD6LtRjJ7
         T2xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lzjvV6TEGCI2+GkCwCQBGWp15pXCppSxRObppBovh1w=;
        b=iojRUOVi4tGzmRavZ5/KW+vS32uggU96uvRnfx3K8xhnnzE5wFyYdv3uGlJmuh+SRs
         UJWxLjEnrn5R3SbkziqeCMUeLWO5IwrgtbWxLo7RFBt8qtDc93BvXGcKJ6ZMnxqCbxkg
         gugQKOlRum/kNfXdbLQ3i/bPWTRuIbqBUspTRaFddKqQvoOb+kVKyKAHlCqpQcgJYCjX
         t/7JhAI40VLyMuuyuVV36ISeieLKNaesgGNHm2dhfASBiiUtdFVlRCirGnVwrnj86CnK
         QFJk9Zl/TTwRv1HGvK+rrRSXYvKkTCMo9kU/hFK9UsB2rc/ljeJ/CGI2/w1qsv+Xw/LT
         GCyg==
X-Gm-Message-State: AJIora/YxIGpSs10JEicqS1jGEe3TV5RiMxBmb4+BBQVBSgAS6LR4Jkq
        3I1TG8BtErSwG/U+63ey1gMp+POz8zA6Ah2j3LHaVvPMwED7+g==
X-Google-Smtp-Source: AGRyM1s36cJAKIObYBLjBc785q6PxkbvyNc0aQvl033WogQlf5UnHPOIxh2qzqi9bMg7Y3euEysXKm+eaNNUXDhrBt4=
X-Received: by 2002:aca:3090:0:b0:335:b264:8bd7 with SMTP id
 w138-20020aca3090000000b00335b2648bd7mr2350297oiw.194.1656531410806; Wed, 29
 Jun 2022 12:36:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220628165024.25718-1-moises.veleta@linux.intel.com> <CAHNKnsTUbdhZ9uUJnF535WajPm6k7R2nECaJZrKjFJCUuHmHEQ@mail.gmail.com>
In-Reply-To: <CAHNKnsTUbdhZ9uUJnF535WajPm6k7R2nECaJZrKjFJCUuHmHEQ@mail.gmail.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Wed, 29 Jun 2022 22:36:39 +0300
Message-ID: <CAHNKnsTbnY5ZQRRgA=6bgN_6=ENO3Ycetiwv0sqqTAjqg2BhiA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/1] net: wwan: t7xx: Add AP CLDMA and GNSS port
To:     Moises Veleta <moises.veleta@linux.intel.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
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
        Madhusmita Sahu <madhusmita.sahu@intel.com>,
        Johan Hovold <johan@kernel.org>
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

CC GNSS subsystem maintainer.

Johan, you can find detailed port functionality description in the
previous thread [1].

1. https://lore.kernel.org/netdev/20220614205756.6792-1-moises.veleta@linux.intel.com/

On Wed, Jun 29, 2022 at 10:24 PM Sergey Ryazanov <ryazanov.s.a@gmail.com> wrote:
>
> Hello Moises,
>
> On Tue, Jun 28, 2022 at 7:51 PM Moises Veleta
> <moises.veleta@linux.intel.com> wrote:
>> The t7xx device contains two Cross Layer DMA (CLDMA) interfaces to
>> communicate with AP and Modem processors respectively. So far only
>> MD-CLDMA was being used, this patch enables AP-CLDMA and the GNSS
>> port which requires such channel.
>>
>> GNSS AT control port allows Modem Manager to control GPS for:
>> - Start/Stop GNSS sessions,
>> - Configuration commands to support Assisted GNSS positioning
>> - Crash & reboot (notifications when resetting device (AP) & host)
>> - Settings to Enable/Disable GNSS solution
>> - Geofencing
>
> I am still in doubt, should we export the pure GNSS port via the wwan
> subsystem. Personally, I like Loic's suggestion to export this port
> via the gnss subsystem. This way, the modem interface will be
> consistent with the kernel device model. What drawbacks do you see in
> this approach?

--
Sergey
