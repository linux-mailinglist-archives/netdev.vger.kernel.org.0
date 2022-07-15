Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 265AC5759FD
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 05:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241320AbiGODbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 23:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiGODbp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 23:31:45 -0400
Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com [199.106.114.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7220374DF3;
        Thu, 14 Jul 2022 20:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1657855904; x=1689391904;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xY2yachpGu6OmHeDqcP49WLUTl0R8LDePjw81BXl58g=;
  b=t8T9NK8Y8OTwTEA/hWAcbmWu3mayJq4unbMOH46BtGuU56ogMVPWd88R
   Pkw7yHf9+q7Bbtc5k8kBcy6Gwf+0gquU0ByYfq5Yeopbjvj1LXXHbzff1
   vf5ymj26AxlUstzxlExHpMv+bzmkHOyNz3vq98IqtH2pgfwdVikByKCS2
   0=;
Received: from unknown (HELO ironmsg04-sd.qualcomm.com) ([10.53.140.144])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 14 Jul 2022 20:31:43 -0700
X-QCInternal: smtphost
Received: from unknown (HELO nasanex01a.na.qualcomm.com) ([10.52.223.231])
  by ironmsg04-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 20:31:43 -0700
Received: from [10.253.39.163] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 14 Jul
 2022 20:31:40 -0700
Message-ID: <e1c55f9f-1615-d9a9-a4b4-40416708e69b@quicinc.com>
Date:   Fri, 15 Jul 2022 11:31:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v1] Bluetooth: Fix cvsd sco setup failure
Content-Language: en-US
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
CC:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Luiz Augusto Von Dentz <luiz.von.dentz@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
References: <1657782880-28234-1-git-send-email-quic_zijuhu@quicinc.com>
 <CABBYNZKn6NUJdtdOASSDs4+h_rZVvamcVPW1KZdmXkALEpCEmg@mail.gmail.com>
From:   quic_zijuhu <quic_zijuhu@quicinc.com>
In-Reply-To: <CABBYNZKn6NUJdtdOASSDs4+h_rZVvamcVPW1KZdmXkALEpCEmg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/15/2022 5:24 AM, Luiz Augusto von Dentz wrote:
> Hi Zijun,
> 
> On Thu, Jul 14, 2022 at 12:14 AM Zijun Hu <quic_zijuhu@quicinc.com> wrote:
>>
>> A cvsd sco setup failure issue is reported as shown by
>> below btmon log, it firstly tries to set up cvsd esco with
>> S3/S2/S1 configs sequentially, but these attempts are all
>> failed with error code "Unspecified Error (0x1f)", then it
>> tries to set up cvsd sco with D1 config, unfortunately, it
>> still fails to set up sco with error code
>> "Invalid HCI Command Parameters (0x12)", this error code
>> terminates attempt with remaining D0 config and marks overall
>> sco/esco setup failure.
>>
>> It is wrong D1/D0 @retrans_effort 0x01 within @esco_param_cvsd
>> that causes D1 config failure with error code
>> "Invalid HCI Command Parameters (0x12)", D1/D0 sco @retrans_effort
>> must not be 0x01 based on spec, so fix this issue by changing D1/D0
>> @retrans_effort from 0x01 to 0xff as present @sco_param_cvsd.
> 
> Please quote the spec regarding the invalid parameters:
> 
BLUETOOTH CORE SPECIFICATION Version 5.3 | Vol 1, Part F
page 375

2.18 INVALID HCI COMMAND PARAMETERS (0x12)
The Invalid HCI Command Parameters error code indicates that at least one of
the HCI command parameters is invalid.
This shall be used when:
• the parameter total length is invalid.
• a command parameter is an invalid type.
• a connection identifier does not match the corresponding event.
• a parameter is odd when it is required to be even.
• a parameter is outside of the specified range.
• two or more parameter values have inconsistent values.
Note: An invalid type can be, for example, when a SCO Connection_Handle is
used where an ACL Connection_Handle is required.

> BLUETOOTH CORE SPECIFICATION Version 5.3 | Vol 4, Part E
> page 1891
> 
> 0x01 At least one retransmission, optimize for power consumption (eSCO con-
> nection required).
> 
>> < HCI Command: Setup Synchrono.. (0x01|0x0028) plen 17  #3405 [hci0]
>>         Handle: 3
>>         Transmit bandwidth: 8000
>>         Receive bandwidth: 8000
>>         Max latency: 10
>>         Setting: 0x0060
>>           Input Coding: Linear
>>           Input Data Format: 2's complement
>>           Input Sample Size: 16-bit
>>           # of bits padding at MSB: 0
>>           Air Coding Format: CVSD
>>         Retransmission effort: Optimize for power consumption (0x01)
>>         Packet type: 0x0380
>>           3-EV3 may not be used
>>           2-EV5 may not be used
>>           3-EV5 may not be used
>>> HCI Event: Command Status (0x0f) plen 4               #3406 [hci0]
>>       Setup Synchronous Connection (0x01|0x0028) ncmd 1
>>         Status: Success (0x00)
>>> HCI Event: Synchronous Connect Comp.. (0x2c) plen 17  #3408 [hci0]
>>         Status: Unspecified Error (0x1f)
>>         Handle: 4
>>         Address: 14:3F:A6:47:56:15 (OUI 14-3F-A6)
>>         Link type: eSCO (0x02)
>>         Transmission interval: 0x00
>>         Retransmission window: 0x00
>>         RX packet length: 0
>>         TX packet length: 0
>>         Air mode: CVSD (0x02)
>> < HCI Command: Setup Synchrono.. (0x01|0x0028) plen 17  #3409 [hci0]
>>         Handle: 3
>>         Transmit bandwidth: 8000
>>         Receive bandwidth: 8000
>>         Max latency: 7
>>         Setting: 0x0060
>>           Input Coding: Linear
>>           Input Data Format: 2's complement
>>           Input Sample Size: 16-bit
>>           # of bits padding at MSB: 0
>>           Air Coding Format: CVSD
>>         Retransmission effort: Optimize for power consumption (0x01)
>>         Packet type: 0x0380
>>           3-EV3 may not be used
>>           2-EV5 may not be used
>>           3-EV5 may not be used
>>> HCI Event: Command Status (0x0f) plen 4               #3410 [hci0]
>>       Setup Synchronous Connection (0x01|0x0028) ncmd 1
>>         Status: Success (0x00)
>>> HCI Event: Synchronous Connect Comp.. (0x2c) plen 17  #3416 [hci0]
>>         Status: Unspecified Error (0x1f)
>>         Handle: 4
>>         Address: 14:3F:A6:47:56:15 (OUI 14-3F-A6)
>>         Link type: eSCO (0x02)
>>         Transmission interval: 0x00
>>         Retransmission window: 0x00
>>         RX packet length: 0
>>         TX packet length: 0
>>         Air mode: CVSD (0x02)
>> < HCI Command: Setup Synchrono.. (0x01|0x0028) plen 17  #3417 [hci0]
>>         Handle: 3
>>         Transmit bandwidth: 8000
>>         Receive bandwidth: 8000
>>         Max latency: 7
>>         Setting: 0x0060
>>           Input Coding: Linear
>>           Input Data Format: 2's complement
>>           Input Sample Size: 16-bit
>>           # of bits padding at MSB: 0
>>           Air Coding Format: CVSD
>>         Retransmission effort: Optimize for power consumption (0x01)
>>         Packet type: 0x03c8
>>           EV3 may be used
>>           2-EV3 may not be used
>>           3-EV3 may not be used
>>           2-EV5 may not be used
>>           3-EV5 may not be used
>>> HCI Event: Command Status (0x0f) plen 4               #3419 [hci0]
>>       Setup Synchronous Connection (0x01|0x0028) ncmd 1
>>         Status: Success (0x00)
>>> HCI Event: Synchronous Connect Comp.. (0x2c) plen 17  #3426 [hci0]
>>         Status: Unspecified Error (0x1f)
>>         Handle: 4
>>         Address: 14:3F:A6:47:56:15 (OUI 14-3F-A6)
>>         Link type: eSCO (0x02)
>>         Transmission interval: 0x00
>>         Retransmission window: 0x00
>>         RX packet length: 0
>>         TX packet length: 0
>>         Air mode: CVSD (0x02)
>> < HCI Command: Setup Synchrono.. (0x01|0x0028) plen 17  #3427 [hci0]
>>         Handle: 3
>>         Transmit bandwidth: 8000
>>         Receive bandwidth: 8000
>>         Max latency: 65535
>>         Setting: 0x0060
>>           Input Coding: Linear
>>           Input Data Format: 2's complement
>>           Input Sample Size: 16-bit
>>           # of bits padding at MSB: 0
>>           Air Coding Format: CVSD
>>         Retransmission effort: Optimize for power consumption (0x01)
>>         Packet type: 0x03c4
>>           HV3 may be used
>>           2-EV3 may not be used
>>           3-EV3 may not be used
>>           2-EV5 may not be used
>>           3-EV5 may not be used
>>> HCI Event: Command Status (0x0f) plen 4               #3428 [hci0]
>>       Setup Synchronous Connection (0x01|0x0028) ncmd 1
>>         Status: Success (0x00)
>>> HCI Event: Synchronous Connect Comp.. (0x2c) plen 17  #3429 [hci0]
>>         Status: Invalid HCI Command Parameters (0x12)
>>         Handle: 0
>>         Address: 14:3F:A6:47:56:15 (OUI 14-3F-A6)
>>         Link type: SCO (0x00)
>>         Transmission interval: 0x00
>>         Retransmission window: 0x00
>>         RX packet length: 0
>>         TX packet length: 0
>>         Air mode: u-law log (0x00)
> 
> This really sounds like the controller fault, it seem to be picking up
> SCO based on packet type alone instead of checking if retransmission
> is suggesting to use eSCO instead, otherwise there is no use to define
> D1/D0 for both eSCO and SCO since the controller will always pick SCO
> instead.
> 
i don't agree with you about above opinion:
S3/S2/S1 here is for eSCO but D1/D0 is for SCO, it should try to set up
SCO after all eSCO setup failures based HFP_v1.8 spec, so it is reasonable to 
return "Invalid HCI Command Parameters" for SCO setup with retransmission parameter
0x01 since SCO doesn't need retransmission.

the spec doesn't say it is available for D1/D0 on eSCO.

Hands-Free Profile V1.8 | page 133

5.7.1.1 Selection of Synchronous Transport
To select the type of synchronous transport (eSCO or SCO) to use, devices shall adhere to the following
logic:
• If eSCO is supported by the responder, the synchronous connection shall first be attempted on an
eSCO logical transport. See section 5.7.1.2
• If eSCO is unavailable for use (e.g., not supported by the Responder or link establishment fails),
and SCO is not currently forbidden because a BR/EDR secure connection is being used, the
Initiator shall open a SCO logical connection. See section 5.7.1.3.

Hands-Free Profile V1.8 | page 115
5.7.1.3 Negotiation of SCO Configuration Parameters
Requirements related to the use of SCO links, under the conditions when the use of a SCO logical
transport is permitted, are covered by the parameter sets D0-D1.

Hands-Free Profile V1.8 | page 24
shows a summary of the mapping of codec requirements on link features for this profile.
Feature Support in HF Support in AG
1. D0 – CVSD on SCO link (HV1) M M
2. D1 – CVSD on SCO link (HV3) M M
3. S1 – CVSD eSCO link (EV3) M M
4. S2 – CVSD on EDR eSCO link (2-EV3) M M
5. S3 – CVSD on EDR eSCO link (2-EV3) M M

>> Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
>> Tested-by: Zijun Hu <quic_zijuhu@quicinc.com>
>> ---
>>  net/bluetooth/hci_conn.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
>> index 7829433d54c1..2627d5ac15d6 100644
>> --- a/net/bluetooth/hci_conn.c
>> +++ b/net/bluetooth/hci_conn.c
>> @@ -45,8 +45,8 @@ static const struct sco_param esco_param_cvsd[] = {
>>         { EDR_ESCO_MASK & ~ESCO_2EV3, 0x000a,   0x01 }, /* S3 */
>>         { EDR_ESCO_MASK & ~ESCO_2EV3, 0x0007,   0x01 }, /* S2 */
>>         { EDR_ESCO_MASK | ESCO_EV3,   0x0007,   0x01 }, /* S1 */
>> -       { EDR_ESCO_MASK | ESCO_HV3,   0xffff,   0x01 }, /* D1 */
>> -       { EDR_ESCO_MASK | ESCO_HV1,   0xffff,   0x01 }, /* D0 */
>> +       { EDR_ESCO_MASK | ESCO_HV3,   0xffff,   0xff }, /* D1 */
>> +       { EDR_ESCO_MASK | ESCO_HV1,   0xffff,   0xff }, /* D0 */
>>  };
> 
> This doesn't seem right, you are changing the parameters for eSCO
> table not SCO, which further reinforce this is probably the controller
> not really doing its job and checking if retransmission is actually
> meant for eSCO rather than SCO.
> 
here it is D1/D0 SCO setup after S3/S2/S1 eSCO attempts failure as above my comments.
>>  static const struct sco_param sco_param_cvsd[] = {
>> --
>> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project
>>
> 
> 

