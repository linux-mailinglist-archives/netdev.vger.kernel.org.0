Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5561C5756D6
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 23:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240299AbiGNVYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 17:24:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239483AbiGNVY3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 17:24:29 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D152131907;
        Thu, 14 Jul 2022 14:24:27 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id y11so4870415lfs.6;
        Thu, 14 Jul 2022 14:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KmMdFk8G2KWuImmWS/3z+3mHwuhXIUfq+ZzcZznCa7M=;
        b=JhjgNgUcWpT6UpJ6+xGlUp9j5fyCOhvvjY/msLRbgnNAZALpEsEv+pC0uaAyH5U6Fu
         Ko235YJKjQUY2BY/cKBnFx4ZnOMPtLoeZpWvuX8Gav3kKasqrUC9PIbNScisgcbGJ613
         EqtaLLPzDYiQhLYQNsKMmjWBv3rWhNGuWm4Hcih9FMEqFAdAI10R0piqU2COSv/L6/H5
         bZEgNmgFrlEaLyyMKtX/FZoGzx+BWxRk0+y0kqJf4+Hubl9Jmx/Ok0WJLABV2WapFCj3
         qiijIC4S23Kekxw4AsB9nj5Vmxy2k6Y0zgnMN+3CkHjXF2a8cetE3WRUDFlPxNZrbq4Q
         aRfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KmMdFk8G2KWuImmWS/3z+3mHwuhXIUfq+ZzcZznCa7M=;
        b=yOXs9DFvYMapZtjCQTQAhll04ONpAZJS/lrd56S0ZeRhPjWrtHKKpUZ31n/PCV0C+s
         o5LyPggsPuqOgXJTmiuEYiue5mVmrqGRd0y/rYa2XYTgOwa2VPpAcdjen/evJI49x+4L
         niTHQ0jcr8+TF1XKOF5KhtTwUGCRqbKlLUgTUaSsxnFhnic2lfYhUYZ7yokxs4BWSYsu
         OFRPN0scbKx/RAcxQlbDxDMjtgiRZmcw2wTO0m1UJEqR/Suj/SARbWJXOsBxmilbeMyI
         4CjVzzbmsht0khI1GIbesMHaoJ7nbyIweJpIUV2zoklBBfuO4HaD6DZ8QBtfBIIp4Onb
         GlFA==
X-Gm-Message-State: AJIora+u6zlVH0pXURpUDf2wAIUMjNJwfTG6MdACud2i1k5z1KcERNqw
        2C9mjrx0w9ygTyB37CCDsX8mKvXT+6l9KjDcWCump11wMa5eDQ==
X-Google-Smtp-Source: AGRyM1tKDoCwBiJw79GFxlAUQnD00JvhrzmBQ3hgkUDZEDwskW2jn16eIBqhnl38acb3siyZPggfyuEsVz/JoTG1lU4=
X-Received: by 2002:a05:6512:22c8:b0:488:e69b:9311 with SMTP id
 g8-20020a05651222c800b00488e69b9311mr5960155lfu.564.1657833866078; Thu, 14
 Jul 2022 14:24:26 -0700 (PDT)
MIME-Version: 1.0
References: <1657782880-28234-1-git-send-email-quic_zijuhu@quicinc.com>
In-Reply-To: <1657782880-28234-1-git-send-email-quic_zijuhu@quicinc.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Thu, 14 Jul 2022 14:24:14 -0700
Message-ID: <CABBYNZKn6NUJdtdOASSDs4+h_rZVvamcVPW1KZdmXkALEpCEmg@mail.gmail.com>
Subject: Re: [PATCH v1] Bluetooth: Fix cvsd sco setup failure
To:     Zijun Hu <quic_zijuhu@quicinc.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Luiz Augusto Von Dentz <luiz.von.dentz@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
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

Hi Zijun,

On Thu, Jul 14, 2022 at 12:14 AM Zijun Hu <quic_zijuhu@quicinc.com> wrote:
>
> A cvsd sco setup failure issue is reported as shown by
> below btmon log, it firstly tries to set up cvsd esco with
> S3/S2/S1 configs sequentially, but these attempts are all
> failed with error code "Unspecified Error (0x1f)", then it
> tries to set up cvsd sco with D1 config, unfortunately, it
> still fails to set up sco with error code
> "Invalid HCI Command Parameters (0x12)", this error code
> terminates attempt with remaining D0 config and marks overall
> sco/esco setup failure.
>
> It is wrong D1/D0 @retrans_effort 0x01 within @esco_param_cvsd
> that causes D1 config failure with error code
> "Invalid HCI Command Parameters (0x12)", D1/D0 sco @retrans_effort
> must not be 0x01 based on spec, so fix this issue by changing D1/D0
> @retrans_effort from 0x01 to 0xff as present @sco_param_cvsd.

Please quote the spec regarding the invalid parameters:

BLUETOOTH CORE SPECIFICATION Version 5.3 | Vol 4, Part E
page 1891

0x01 At least one retransmission, optimize for power consumption (eSCO con-
nection required).

> < HCI Command: Setup Synchrono.. (0x01|0x0028) plen 17  #3405 [hci0]
>         Handle: 3
>         Transmit bandwidth: 8000
>         Receive bandwidth: 8000
>         Max latency: 10
>         Setting: 0x0060
>           Input Coding: Linear
>           Input Data Format: 2's complement
>           Input Sample Size: 16-bit
>           # of bits padding at MSB: 0
>           Air Coding Format: CVSD
>         Retransmission effort: Optimize for power consumption (0x01)
>         Packet type: 0x0380
>           3-EV3 may not be used
>           2-EV5 may not be used
>           3-EV5 may not be used
> > HCI Event: Command Status (0x0f) plen 4               #3406 [hci0]
>       Setup Synchronous Connection (0x01|0x0028) ncmd 1
>         Status: Success (0x00)
> > HCI Event: Synchronous Connect Comp.. (0x2c) plen 17  #3408 [hci0]
>         Status: Unspecified Error (0x1f)
>         Handle: 4
>         Address: 14:3F:A6:47:56:15 (OUI 14-3F-A6)
>         Link type: eSCO (0x02)
>         Transmission interval: 0x00
>         Retransmission window: 0x00
>         RX packet length: 0
>         TX packet length: 0
>         Air mode: CVSD (0x02)
> < HCI Command: Setup Synchrono.. (0x01|0x0028) plen 17  #3409 [hci0]
>         Handle: 3
>         Transmit bandwidth: 8000
>         Receive bandwidth: 8000
>         Max latency: 7
>         Setting: 0x0060
>           Input Coding: Linear
>           Input Data Format: 2's complement
>           Input Sample Size: 16-bit
>           # of bits padding at MSB: 0
>           Air Coding Format: CVSD
>         Retransmission effort: Optimize for power consumption (0x01)
>         Packet type: 0x0380
>           3-EV3 may not be used
>           2-EV5 may not be used
>           3-EV5 may not be used
> > HCI Event: Command Status (0x0f) plen 4               #3410 [hci0]
>       Setup Synchronous Connection (0x01|0x0028) ncmd 1
>         Status: Success (0x00)
> > HCI Event: Synchronous Connect Comp.. (0x2c) plen 17  #3416 [hci0]
>         Status: Unspecified Error (0x1f)
>         Handle: 4
>         Address: 14:3F:A6:47:56:15 (OUI 14-3F-A6)
>         Link type: eSCO (0x02)
>         Transmission interval: 0x00
>         Retransmission window: 0x00
>         RX packet length: 0
>         TX packet length: 0
>         Air mode: CVSD (0x02)
> < HCI Command: Setup Synchrono.. (0x01|0x0028) plen 17  #3417 [hci0]
>         Handle: 3
>         Transmit bandwidth: 8000
>         Receive bandwidth: 8000
>         Max latency: 7
>         Setting: 0x0060
>           Input Coding: Linear
>           Input Data Format: 2's complement
>           Input Sample Size: 16-bit
>           # of bits padding at MSB: 0
>           Air Coding Format: CVSD
>         Retransmission effort: Optimize for power consumption (0x01)
>         Packet type: 0x03c8
>           EV3 may be used
>           2-EV3 may not be used
>           3-EV3 may not be used
>           2-EV5 may not be used
>           3-EV5 may not be used
> > HCI Event: Command Status (0x0f) plen 4               #3419 [hci0]
>       Setup Synchronous Connection (0x01|0x0028) ncmd 1
>         Status: Success (0x00)
> > HCI Event: Synchronous Connect Comp.. (0x2c) plen 17  #3426 [hci0]
>         Status: Unspecified Error (0x1f)
>         Handle: 4
>         Address: 14:3F:A6:47:56:15 (OUI 14-3F-A6)
>         Link type: eSCO (0x02)
>         Transmission interval: 0x00
>         Retransmission window: 0x00
>         RX packet length: 0
>         TX packet length: 0
>         Air mode: CVSD (0x02)
> < HCI Command: Setup Synchrono.. (0x01|0x0028) plen 17  #3427 [hci0]
>         Handle: 3
>         Transmit bandwidth: 8000
>         Receive bandwidth: 8000
>         Max latency: 65535
>         Setting: 0x0060
>           Input Coding: Linear
>           Input Data Format: 2's complement
>           Input Sample Size: 16-bit
>           # of bits padding at MSB: 0
>           Air Coding Format: CVSD
>         Retransmission effort: Optimize for power consumption (0x01)
>         Packet type: 0x03c4
>           HV3 may be used
>           2-EV3 may not be used
>           3-EV3 may not be used
>           2-EV5 may not be used
>           3-EV5 may not be used
> > HCI Event: Command Status (0x0f) plen 4               #3428 [hci0]
>       Setup Synchronous Connection (0x01|0x0028) ncmd 1
>         Status: Success (0x00)
> > HCI Event: Synchronous Connect Comp.. (0x2c) plen 17  #3429 [hci0]
>         Status: Invalid HCI Command Parameters (0x12)
>         Handle: 0
>         Address: 14:3F:A6:47:56:15 (OUI 14-3F-A6)
>         Link type: SCO (0x00)
>         Transmission interval: 0x00
>         Retransmission window: 0x00
>         RX packet length: 0
>         TX packet length: 0
>         Air mode: u-law log (0x00)

This really sounds like the controller fault, it seem to be picking up
SCO based on packet type alone instead of checking if retransmission
is suggesting to use eSCO instead, otherwise there is no use to define
D1/D0 for both eSCO and SCO since the controller will always pick SCO
instead.

> Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
> Tested-by: Zijun Hu <quic_zijuhu@quicinc.com>
> ---
>  net/bluetooth/hci_conn.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
> index 7829433d54c1..2627d5ac15d6 100644
> --- a/net/bluetooth/hci_conn.c
> +++ b/net/bluetooth/hci_conn.c
> @@ -45,8 +45,8 @@ static const struct sco_param esco_param_cvsd[] = {
>         { EDR_ESCO_MASK & ~ESCO_2EV3, 0x000a,   0x01 }, /* S3 */
>         { EDR_ESCO_MASK & ~ESCO_2EV3, 0x0007,   0x01 }, /* S2 */
>         { EDR_ESCO_MASK | ESCO_EV3,   0x0007,   0x01 }, /* S1 */
> -       { EDR_ESCO_MASK | ESCO_HV3,   0xffff,   0x01 }, /* D1 */
> -       { EDR_ESCO_MASK | ESCO_HV1,   0xffff,   0x01 }, /* D0 */
> +       { EDR_ESCO_MASK | ESCO_HV3,   0xffff,   0xff }, /* D1 */
> +       { EDR_ESCO_MASK | ESCO_HV1,   0xffff,   0xff }, /* D0 */
>  };

This doesn't seem right, you are changing the parameters for eSCO
table not SCO, which further reinforce this is probably the controller
not really doing its job and checking if retransmission is actually
meant for eSCO rather than SCO.

>  static const struct sco_param sco_param_cvsd[] = {
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project
>


-- 
Luiz Augusto von Dentz
