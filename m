Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04742575A47
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 06:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbiGOEWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 00:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiGOEWD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 00:22:03 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 269B078222;
        Thu, 14 Jul 2022 21:22:02 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id a9so5951275lfk.11;
        Thu, 14 Jul 2022 21:22:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xicz3lxrpm4AozXGZNFiu+uBvZMtxkxpfq9/6PE8U88=;
        b=mVqOt4CsXffSL/GFdpdQ3YGQpSrfeAsVDptomsssJP5CQN2nUOsThY3RdzBb6Sh0fg
         NIOZgCddcn7rjy6ijB6sK0crpgC7i7hEja1xwISyHKCA8PZt6pNwlaONqYtUwPI+96Xt
         83rtgAEFI/w7j3VjjgV8ytx8uT/igCEBvg6E8YSO3MKZ2enQA2YDiXUvpNG7sKYTT3DC
         kPl3MoLajQ1xlYvzulcc1QDhzLEobv++TxOZ8O/9EZzdmNSiy+AUV9prN1YKcP6PwJGH
         BABJ1eLNcvNJz7HhQ/axPKInCWed0tOrM+bEYAdVagpnSXNCtagqGv3yCTHY00jKonSL
         CBFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xicz3lxrpm4AozXGZNFiu+uBvZMtxkxpfq9/6PE8U88=;
        b=I8R44IClRYRNMWfnP8GN9UfoGU+hp2f+GaGqrj+/ghE6rHtts907d9kAZmrrhyFd8L
         vplZnRi6hV4PT2ZBGEYAIuq+q8+9daLOyUFqx4hrQ62qKP7aIIMObDL9f4+/sEPkoQ5B
         ntCmbUbvKKvdWLjyxEHo3a88nWMYBba6oflLxs87M26AVfM3flQoyzv/J7nh8D1dxFxd
         Tre5+hwlsBVStIEKBd5TsIJzLYM7wD5pZasFQzjV3B0P2QuzhCud1dykyPjWiWTne2JI
         FX4Tmisz//nJfBlrEjb6NnnXoDLkkBGmdrQqfVXWh9xa9naNN3mmTrd88iQHTRdTHtE1
         /Rtg==
X-Gm-Message-State: AJIora/vY5HeaSJc3AZTxhQhE9/Dm5fposdjolrL0i18Zm2+ipQ3EQSl
        D57CohGKfROruf1FF08P2Q0q+hh37puAmsxj06Q=
X-Google-Smtp-Source: AGRyM1tZNMaUiFIdhFiPiiYue3RJo8NLo0P8RHFsSFwUSwYH33OJavFrY4jZuanjSeVepfxHjkKMTDeE28LRYKT4s5g=
X-Received: by 2002:a05:6512:2621:b0:47f:d228:bdeb with SMTP id
 bt33-20020a056512262100b0047fd228bdebmr6567872lfb.121.1657858920395; Thu, 14
 Jul 2022 21:22:00 -0700 (PDT)
MIME-Version: 1.0
References: <1657782880-28234-1-git-send-email-quic_zijuhu@quicinc.com>
 <CABBYNZKn6NUJdtdOASSDs4+h_rZVvamcVPW1KZdmXkALEpCEmg@mail.gmail.com> <e1c55f9f-1615-d9a9-a4b4-40416708e69b@quicinc.com>
In-Reply-To: <e1c55f9f-1615-d9a9-a4b4-40416708e69b@quicinc.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Thu, 14 Jul 2022 21:21:48 -0700
Message-ID: <CABBYNZKqEQoN+_iLd=+4n3_D6zULKytiNhPOLQp1HvBTSOravw@mail.gmail.com>
Subject: Re: [PATCH v1] Bluetooth: Fix cvsd sco setup failure
To:     quic_zijuhu <quic_zijuhu@quicinc.com>
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
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, Jul 14, 2022 at 8:31 PM quic_zijuhu <quic_zijuhu@quicinc.com> wrote=
:
>
> On 7/15/2022 5:24 AM, Luiz Augusto von Dentz wrote:
> > Hi Zijun,
> >
> > On Thu, Jul 14, 2022 at 12:14 AM Zijun Hu <quic_zijuhu@quicinc.com> wro=
te:
> >>
> >> A cvsd sco setup failure issue is reported as shown by
> >> below btmon log, it firstly tries to set up cvsd esco with
> >> S3/S2/S1 configs sequentially, but these attempts are all
> >> failed with error code "Unspecified Error (0x1f)", then it
> >> tries to set up cvsd sco with D1 config, unfortunately, it
> >> still fails to set up sco with error code
> >> "Invalid HCI Command Parameters (0x12)", this error code
> >> terminates attempt with remaining D0 config and marks overall
> >> sco/esco setup failure.
> >>
> >> It is wrong D1/D0 @retrans_effort 0x01 within @esco_param_cvsd
> >> that causes D1 config failure with error code
> >> "Invalid HCI Command Parameters (0x12)", D1/D0 sco @retrans_effort
> >> must not be 0x01 based on spec, so fix this issue by changing D1/D0
> >> @retrans_effort from 0x01 to 0xff as present @sco_param_cvsd.
> >
> > Please quote the spec regarding the invalid parameters:
> >
> BLUETOOTH CORE SPECIFICATION Version 5.3 | Vol 1, Part F
> page 375
>
> 2.18 INVALID HCI COMMAND PARAMETERS (0x12)
> The Invalid HCI Command Parameters error code indicates that at least one=
 of
> the HCI command parameters is invalid.
> This shall be used when:
> =E2=80=A2 the parameter total length is invalid.
> =E2=80=A2 a command parameter is an invalid type.
> =E2=80=A2 a connection identifier does not match the corresponding event.
> =E2=80=A2 a parameter is odd when it is required to be even.
> =E2=80=A2 a parameter is outside of the specified range.
> =E2=80=A2 two or more parameter values have inconsistent values.
> Note: An invalid type can be, for example, when a SCO Connection_Handle i=
s
> used where an ACL Connection_Handle is required.
>
> > BLUETOOTH CORE SPECIFICATION Version 5.3 | Vol 4, Part E
> > page 1891
> >
> > 0x01 At least one retransmission, optimize for power consumption (eSCO =
con-
> > nection required).
> >
> >> < HCI Command: Setup Synchrono.. (0x01|0x0028) plen 17  #3405 [hci0]
> >>         Handle: 3
> >>         Transmit bandwidth: 8000
> >>         Receive bandwidth: 8000
> >>         Max latency: 10
> >>         Setting: 0x0060
> >>           Input Coding: Linear
> >>           Input Data Format: 2's complement
> >>           Input Sample Size: 16-bit
> >>           # of bits padding at MSB: 0
> >>           Air Coding Format: CVSD
> >>         Retransmission effort: Optimize for power consumption (0x01)
> >>         Packet type: 0x0380
> >>           3-EV3 may not be used
> >>           2-EV5 may not be used
> >>           3-EV5 may not be used
> >>> HCI Event: Command Status (0x0f) plen 4               #3406 [hci0]
> >>       Setup Synchronous Connection (0x01|0x0028) ncmd 1
> >>         Status: Success (0x00)
> >>> HCI Event: Synchronous Connect Comp.. (0x2c) plen 17  #3408 [hci0]
> >>         Status: Unspecified Error (0x1f)
> >>         Handle: 4
> >>         Address: 14:3F:A6:47:56:15 (OUI 14-3F-A6)
> >>         Link type: eSCO (0x02)
> >>         Transmission interval: 0x00
> >>         Retransmission window: 0x00
> >>         RX packet length: 0
> >>         TX packet length: 0
> >>         Air mode: CVSD (0x02)
> >> < HCI Command: Setup Synchrono.. (0x01|0x0028) plen 17  #3409 [hci0]
> >>         Handle: 3
> >>         Transmit bandwidth: 8000
> >>         Receive bandwidth: 8000
> >>         Max latency: 7
> >>         Setting: 0x0060
> >>           Input Coding: Linear
> >>           Input Data Format: 2's complement
> >>           Input Sample Size: 16-bit
> >>           # of bits padding at MSB: 0
> >>           Air Coding Format: CVSD
> >>         Retransmission effort: Optimize for power consumption (0x01)
> >>         Packet type: 0x0380
> >>           3-EV3 may not be used
> >>           2-EV5 may not be used
> >>           3-EV5 may not be used
> >>> HCI Event: Command Status (0x0f) plen 4               #3410 [hci0]
> >>       Setup Synchronous Connection (0x01|0x0028) ncmd 1
> >>         Status: Success (0x00)
> >>> HCI Event: Synchronous Connect Comp.. (0x2c) plen 17  #3416 [hci0]
> >>         Status: Unspecified Error (0x1f)
> >>         Handle: 4
> >>         Address: 14:3F:A6:47:56:15 (OUI 14-3F-A6)
> >>         Link type: eSCO (0x02)
> >>         Transmission interval: 0x00
> >>         Retransmission window: 0x00
> >>         RX packet length: 0
> >>         TX packet length: 0
> >>         Air mode: CVSD (0x02)
> >> < HCI Command: Setup Synchrono.. (0x01|0x0028) plen 17  #3417 [hci0]
> >>         Handle: 3
> >>         Transmit bandwidth: 8000
> >>         Receive bandwidth: 8000
> >>         Max latency: 7
> >>         Setting: 0x0060
> >>           Input Coding: Linear
> >>           Input Data Format: 2's complement
> >>           Input Sample Size: 16-bit
> >>           # of bits padding at MSB: 0
> >>           Air Coding Format: CVSD
> >>         Retransmission effort: Optimize for power consumption (0x01)
> >>         Packet type: 0x03c8
> >>           EV3 may be used
> >>           2-EV3 may not be used
> >>           3-EV3 may not be used
> >>           2-EV5 may not be used
> >>           3-EV5 may not be used
> >>> HCI Event: Command Status (0x0f) plen 4               #3419 [hci0]
> >>       Setup Synchronous Connection (0x01|0x0028) ncmd 1
> >>         Status: Success (0x00)
> >>> HCI Event: Synchronous Connect Comp.. (0x2c) plen 17  #3426 [hci0]
> >>         Status: Unspecified Error (0x1f)
> >>         Handle: 4
> >>         Address: 14:3F:A6:47:56:15 (OUI 14-3F-A6)
> >>         Link type: eSCO (0x02)
> >>         Transmission interval: 0x00
> >>         Retransmission window: 0x00
> >>         RX packet length: 0
> >>         TX packet length: 0
> >>         Air mode: CVSD (0x02)
> >> < HCI Command: Setup Synchrono.. (0x01|0x0028) plen 17  #3427 [hci0]
> >>         Handle: 3
> >>         Transmit bandwidth: 8000
> >>         Receive bandwidth: 8000
> >>         Max latency: 65535
> >>         Setting: 0x0060
> >>           Input Coding: Linear
> >>           Input Data Format: 2's complement
> >>           Input Sample Size: 16-bit
> >>           # of bits padding at MSB: 0
> >>           Air Coding Format: CVSD
> >>         Retransmission effort: Optimize for power consumption (0x01)
> >>         Packet type: 0x03c4
> >>           HV3 may be used
> >>           2-EV3 may not be used
> >>           3-EV3 may not be used
> >>           2-EV5 may not be used
> >>           3-EV5 may not be used
> >>> HCI Event: Command Status (0x0f) plen 4               #3428 [hci0]
> >>       Setup Synchronous Connection (0x01|0x0028) ncmd 1
> >>         Status: Success (0x00)
> >>> HCI Event: Synchronous Connect Comp.. (0x2c) plen 17  #3429 [hci0]
> >>         Status: Invalid HCI Command Parameters (0x12)
> >>         Handle: 0
> >>         Address: 14:3F:A6:47:56:15 (OUI 14-3F-A6)
> >>         Link type: SCO (0x00)
> >>         Transmission interval: 0x00
> >>         Retransmission window: 0x00
> >>         RX packet length: 0
> >>         TX packet length: 0
> >>         Air mode: u-law log (0x00)
> >
> > This really sounds like the controller fault, it seem to be picking up
> > SCO based on packet type alone instead of checking if retransmission
> > is suggesting to use eSCO instead, otherwise there is no use to define
> > D1/D0 for both eSCO and SCO since the controller will always pick SCO
> > instead.
> >
> i don't agree with you about above opinion:
> S3/S2/S1 here is for eSCO but D1/D0 is for SCO, it should try to set up
> SCO after all eSCO setup failures based HFP_v1.8 spec, so it is reasonabl=
e to
> return "Invalid HCI Command Parameters" for SCO setup with retransmission=
 parameter
> 0x01 since SCO doesn't need retransmission.
>
> the spec doesn't say it is available for D1/D0 on eSCO.
>
> Hands-Free Profile V1.8 | page 133
>
> 5.7.1.1 Selection of Synchronous Transport
> To select the type of synchronous transport (eSCO or SCO) to use, devices=
 shall adhere to the following
> logic:
> =E2=80=A2 If eSCO is supported by the responder, the synchronous connecti=
on shall first be attempted on an
> eSCO logical transport. See section 5.7.1.2
> =E2=80=A2 If eSCO is unavailable for use (e.g., not supported by the Resp=
onder or link establishment fails),
> and SCO is not currently forbidden because a BR/EDR secure connection is =
being used, the
> Initiator shall open a SCO logical connection. See section 5.7.1.3.
>
> Hands-Free Profile V1.8 | page 115
> 5.7.1.3 Negotiation of SCO Configuration Parameters
> Requirements related to the use of SCO links, under the conditions when t=
he use of a SCO logical
> transport is permitted, are covered by the parameter sets D0-D1.
>
> Hands-Free Profile V1.8 | page 24
> shows a summary of the mapping of codec requirements on link features for=
 this profile.
> Feature Support in HF Support in AG
> 1. D0 =E2=80=93 CVSD on SCO link (HV1) M M
> 2. D1 =E2=80=93 CVSD on SCO link (HV3) M M
> 3. S1 =E2=80=93 CVSD eSCO link (EV3) M M
> 4. S2 =E2=80=93 CVSD on EDR eSCO link (2-EV3) M M
> 5. S3 =E2=80=93 CVSD on EDR eSCO link (2-EV3) M M

If D0-D1 are SCO only, then yes but then they should not even be part
of the eSCO table, still I don't think the controller should be
looking just to packet type or these types are not supported in eSCO?

> >> Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
> >> Tested-by: Zijun Hu <quic_zijuhu@quicinc.com>
> >> ---
> >>  net/bluetooth/hci_conn.c | 4 ++--
> >>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
> >> index 7829433d54c1..2627d5ac15d6 100644
> >> --- a/net/bluetooth/hci_conn.c
> >> +++ b/net/bluetooth/hci_conn.c
> >> @@ -45,8 +45,8 @@ static const struct sco_param esco_param_cvsd[] =3D =
{
> >>         { EDR_ESCO_MASK & ~ESCO_2EV3, 0x000a,   0x01 }, /* S3 */
> >>         { EDR_ESCO_MASK & ~ESCO_2EV3, 0x0007,   0x01 }, /* S2 */
> >>         { EDR_ESCO_MASK | ESCO_EV3,   0x0007,   0x01 }, /* S1 */
> >> -       { EDR_ESCO_MASK | ESCO_HV3,   0xffff,   0x01 }, /* D1 */
> >> -       { EDR_ESCO_MASK | ESCO_HV1,   0xffff,   0x01 }, /* D0 */
> >> +       { EDR_ESCO_MASK | ESCO_HV3,   0xffff,   0xff }, /* D1 */
> >> +       { EDR_ESCO_MASK | ESCO_HV1,   0xffff,   0xff }, /* D0 */
> >>  };
> >
> > This doesn't seem right, you are changing the parameters for eSCO
> > table not SCO, which further reinforce this is probably the controller
> > not really doing its job and checking if retransmission is actually
> > meant for eSCO rather than SCO.
> >
> here it is D1/D0 SCO setup after S3/S2/S1 eSCO attempts failure as above =
my comments.

Well then all we need to do is to remove the last 2 lines since they
are already handled by the table below.

> >>  static const struct sco_param sco_param_cvsd[] =3D {
> >> --
> >> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Fo=
rum, a Linux Foundation Collaborative Project
> >>
> >
> >
>


--=20
Luiz Augusto von Dentz
