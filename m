Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 071795B0D20
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 21:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbiIGTVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 15:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiIGTVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 15:21:32 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A104C00C8;
        Wed,  7 Sep 2022 12:21:30 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id AEBCB3200313;
        Wed,  7 Sep 2022 15:21:25 -0400 (EDT)
Received: from imap47 ([10.202.2.97])
  by compute2.internal (MEProxy); Wed, 07 Sep 2022 15:21:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=svenpeter.dev;
         h=cc:cc:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1662578485; x=1662664885; bh=EL
        eTSyZ4zS0CBGPjQv/fZw6BU0AoLOYg41xHNc0d8ug=; b=VO3xqacvYeGbmBrro6
        LigXmEI2UuSPXqWSPRAsdZNiqFE2u56ms9g86HZ4Lzbh8nXVpT8wHrO0vtv5qfk7
        WGJRHuFptgivh1Er2O83epogU2B3N+n7xW/ZnVQYSIYSVumhXgZfmwmsjWpZ57AP
        V1O3SYoakxkD4KyLuvHZThrgJpL5jirCBcibIqPNCeetmLrsMTLfkqfaYdijJcc3
        pgK3tqbKIJem2bCoruC0lL7Lj5WK8Zsh1EcOPX1oztZwYRx+xfA3UUVt5pudN8zu
        UyQqyTXI1oVKVpe0JEhTXw3HFRwd41O/zFuw0rNReYqyRFdheH2CtgoyL1kF/YJH
        Ly6A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1662578485; x=1662664885; bh=ELeTSyZ4zS0CBGPjQv/fZw6BU0Ao
        LOYg41xHNc0d8ug=; b=JuHAfxwxwCza2HmKYm4TMH116CNKDtQyFVBpgDf11z4E
        EHRBlVgF5L9InrdUrFZKI+ouiIzvLxhM3C6kzQ05S9H06hnq5sx+YzPSgJCLOHaZ
        LRgUna1HljdtWwtc0y2yZHeXvIsAig5pp617K6H697f9ZtZVwTVaFPHHbeB4iF9Z
        KL4q7GzcaclYUXqnhugi3GNFrGKyBFY22aR+Xx9P4dB9WXRm+cr+utRbraW3eo8v
        /mKHSI0PWO2iwdFV6Ho+OQUqs4DehTjL4haKMPGFe+qynhtN9rkxBoIj6ChPYNI6
        USaWKpZuxOwcQLgHoWJb6bEiK3ABkjxkhujsrJT1WA==
X-ME-Sender: <xms:M-8YYzyH_W0LY1pllZF-du9MwGaqox9TE23wyLu8UGWPbbf2SLiaLw>
    <xme:M-8YY7SYuJcYz66oAnTG7-IOev7syFifw6kZAITV8v1ITrxMbYYiFI14EQCbMQiXi
    5ZVPz4GRzUZY8i0QQg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedttddgudefjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdfu
    vhgvnhcurfgvthgvrhdfuceoshhvvghnsehsvhgvnhhpvghtvghrrdguvghvqeenucggtf
    frrghtthgvrhhnpeelvefggeffheevtdeivefhkeehfeettdejteduveeiheevveeilefg
    hfeiveeiueenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehsvhgvnhesshhvvghnphgvthgvrhdruggvvh
X-ME-Proxy: <xmx:M-8YY9UUG0iUvcodQL8KqTiSumQj-kpnMEqCxaXd9voljlSVE30rjw>
    <xmx:M-8YY9iofjdbz0hC-Aj5SoRVor_JfKTLK77nkQiSfy3UwrpY0FV2Tw>
    <xmx:M-8YY1C4A6Birg4HlhsVmdMxHZZ8BOFrZ1wgE0rMZlzGHJeqe3bSPQ>
    <xmx:Ne8YY9YtcPMkuAriURAAUjT5UOmsVzCgtOA6jnLN3xyNuWca0grfIA>
Feedback-ID: i51094778:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 60126A6007C; Wed,  7 Sep 2022 15:21:23 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-927-gf4c98c8499-fm-20220826.002-gf4c98c84
Mime-Version: 1.0
Message-Id: <220ab728-ed5b-415d-ab15-47a7153e8e5c@www.fastmail.com>
In-Reply-To: <CABBYNZLWc=2y0aVRc+_k_XzfJeEJkJ_ebaViqUybvaDY49p2_g@mail.gmail.com>
References: <20220907170935.11757-1-sven@svenpeter.dev>
 <20220907170935.11757-4-sven@svenpeter.dev>
 <CABBYNZLWc=2y0aVRc+_k_XzfJeEJkJ_ebaViqUybvaDY49p2_g@mail.gmail.com>
Date:   Wed, 07 Sep 2022 21:21:02 +0200
From:   "Sven Peter" <sven@svenpeter.dev>
To:     "Luiz Augusto von Dentz" <luiz.dentz@gmail.com>
Cc:     "Marcel Holtmann" <marcel@holtmann.org>,
        "Johan Hedberg" <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Krzysztof Kozlowski" <krzysztof.kozlowski+dt@linaro.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "Rob Herring" <robh+dt@kernel.org>,
        "Hector Martin" <marcan@marcan.st>,
        "Alyssa Rosenzweig" <alyssa@rosenzweig.io>, asahi@lists.linux.dev,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/5] Bluetooth: hci_event: Add quirk to ignore byte in LE
 Extended Adv Report
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Luiz,

On Wed, Sep 7, 2022, at 20:49, Luiz Augusto von Dentz wrote:
> Hi Sven,
>
> On Wed, Sep 7, 2022 at 10:10 AM Sven Peter <sven@svenpeter.dev> wrote:
>>
>> Broadcom controllers present on Apple Silicon devices use the upper
>> 8 bits of the event type in the LE Extended Advertising Report for
>> the channel on which the frame has been received.
>> Add a quirk to drop the upper byte to ensure that the advertising
>> results are parsed correctly.
>>
>> The following excerpt from a btmon trace shows a report received on
>> channel 37 by these controllers:
>>
>> > HCI Event: LE Meta Event (0x3e) plen 55
>>       LE Extended Advertising Report (0x0d)
>>         Num reports: 1
>>         Entry 0
>>           Event type: 0x2513
>>             Props: 0x0013
>>               Connectable
>>               Scannable
>>               Use legacy advertising PDUs
>>             Data status: Complete
>>             Reserved (0x2500)
>>           Legacy PDU Type: Reserved (0x2513)
>>           Address type: Public (0x00)
>>           Address: XX:XX:XX:XX:XX:XX (Shenzhen Jingxun Software [...])
>>           Primary PHY: LE 1M
>>           Secondary PHY: No packets
>>           SID: no ADI field (0xff)
>>           TX power: 127 dBm
>>           RSSI: -76 dBm (0xb4)
>>           Periodic advertising interval: 0.00 msec (0x0000)
>>           Direct address type: Public (0x00)
>>           Direct address: 00:00:00:00:00:00 (OUI 00-00-00)
>>           Data length: 0x1d
>>           [...]
>>         Flags: 0x18
>>           Simultaneous LE and BR/EDR (Controller)
>>           Simultaneous LE and BR/EDR (Host)
>>         Company: Harman International Industries, Inc. (87)
>>           Data: [...]
>>         Service Data (UUID 0xfddf):
>>         Name (complete): JBL Flip 5
>>
>> Signed-off-by: Sven Peter <sven@svenpeter.dev>
>> ---
>> changes from v1:
>>   - adjusted the commit message a bit to make checkpatch happy
>>
>>  include/net/bluetooth/hci.h | 11 +++++++++++
>>  net/bluetooth/hci_event.c   |  4 ++++
>>  2 files changed, 15 insertions(+)
>>
>> diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
>> index cf29511b25a8..62539c1a6bf2 100644
>> --- a/include/net/bluetooth/hci.h
>> +++ b/include/net/bluetooth/hci.h
>> @@ -263,6 +263,17 @@ enum {
>>          * during the hdev->setup vendor callback.
>>          */
>>         HCI_QUIRK_BROKEN_ENHANCED_SETUP_SYNC_CONN,
>> +
>> +       /*
>> +        * When this quirk is set, the upper 8 bits of the evt_type field of
>> +        * the LE Extended Advertising Report events are discarded.
>> +        * Some Broadcom controllers found in Apple machines put the channel
>> +        * the report was received on into these reserved bits.
>> +        *
>> +        * This quirk can be set before hci_register_dev is called or
>> +        * during the hdev->setup vendor callback.
>> +        */
>> +       HCI_QUIRK_FIXUP_LE_EXT_ADV_REPORT_EVT_TYPE,
>>  };
>>
>>  /* HCI device flags */
>> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
>> index 485c814cf44a..b50d05211f0d 100644
>> --- a/net/bluetooth/hci_event.c
>> +++ b/net/bluetooth/hci_event.c
>> @@ -6471,6 +6471,10 @@ static void hci_le_ext_adv_report_evt(struct hci_dev *hdev, void *data,
>>                         break;
>>
>>                 evt_type = __le16_to_cpu(info->type);
>> +               if (test_bit(HCI_QUIRK_FIXUP_LE_EXT_ADV_REPORT_EVT_TYPE,
>> +                            &hdev->quirks))
>> +                       evt_type &= 0xff;
>> +
>
> Don't think we really need to quirk in order to mask the reserved
> bits, according to the 5.3 spec only bits 0-6 are actually valid, that
> said the usage of the upper byte is sort of non-standard so I don't
> know what is broadcom/apple thinking that they could use like this,
> instead this should probably be placed in a vendor command or even add
> as part of the data itself with a vendor type.

Sure, I'll just mask them unconditionally then for v3.

I originally thought it was a strange bug in their firmware but
then I found their btmon-like tool called "PacketLogger" which
actually decodes that byte and shows it in the UI as "Channel".
It seems to be intentional :/



Best,

Sven
