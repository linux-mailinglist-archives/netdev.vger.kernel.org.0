Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBC60611587
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 17:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbiJ1PJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 11:09:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbiJ1PJW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 11:09:22 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B351320B104;
        Fri, 28 Oct 2022 08:09:21 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 279445C0063;
        Fri, 28 Oct 2022 11:09:21 -0400 (EDT)
Received: from imap47 ([10.202.2.97])
  by compute2.internal (MEProxy); Fri, 28 Oct 2022 11:09:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=svenpeter.dev;
         h=cc:cc:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1666969761; x=1667056161; bh=Sy
        6FI25zRCehPukmtH7/3V5knsC4JumJoR5V84h5kaM=; b=G+cOvYkJUUuGPABiFE
        zjECEj6bJ8KF8IJsUGHKSG0kkvtJ2VGlxHt/vHL3ot1tcHvmCSHq8Yxsn4jmlio7
        b87XcMRi/qNN2Hb+sQrrIZ/MprY+gQcSbAB1QGBlp6tKIsdFXVmWzpQXjwkBy+xO
        4NvUlBVNiARkhbYcP5kRP5B0zXk8MJkJINm4XJm8NEnr4Qzbl7givGBykTZzep89
        cUxHoMgh2r033YFDu1ONbt6pohcKPJwCy45muRy6CLnu6U5L9/8q6rm0UoXVOE4f
        JDMshM/hm6kmL+pRMQ9aVtqAhwjY2GOiTOFxCdJtIFMMe1NV8rq+RTaTz7G9SCGw
        O0AQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1666969761; x=1667056161; bh=Sy6FI25zRCehPukmtH7/3V5knsC4
        JumJoR5V84h5kaM=; b=TsctoJvwFdAcmmgfHHKeVjmT4R7aNkVhe6oQqMfWMVbJ
        5eenZ0qnr+0i+VeZ4wJBz8Vh/koB0kDeIK1jZa+7vK5IVeaOZdE+MA8+s4RxrBZ+
        X592De5wmxSVbMZkK3U06Bco6tBH2UULWY+GgRgGJdh0HdjwVinsImTnjLXK3bAJ
        Kvn9Ot2VuqzkO4U05kBK9GNBs4Ul0H1ednZr4yCjeLd8Qn7ZYGyCGJvEBWRxUmSn
        ow91pTIwYpEuEIFXibkL7lxzaZ977U4bzMrtl2gCdWegTSLYhVw5uyD2RhX3rB1A
        3yrcm+/abvZP9pUGBNFqCI2vjfocyFju8Dr4PVuyjQ==
X-ME-Sender: <xms:n_BbY5q9PM5WcB2nasCymuRAfsH5P_socO5xgz8nev3Qz577tghQMg>
    <xme:n_BbY7oyIwDdM-bSjSjqj4cCpDS2JGnPeg9RIC0TEUut5aaeH8DTzvXVTGvqiV-xP
    k58Tbpa6Z9GUzsD3y4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrtdeigdekgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdfuvhgv
    nhcurfgvthgvrhdfuceoshhvvghnsehsvhgvnhhpvghtvghrrdguvghvqeenucggtffrrg
    htthgvrhhnpeelvefggeffheevtdeivefhkeehfeettdejteduveeiheevveeilefghfei
    veeiueenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hsvhgvnhesshhvvghnphgvthgvrhdruggvvh
X-ME-Proxy: <xmx:oPBbY2MNaLXplfXAKqaolwa_6NaHLJ0Ptmad9_r4hec89t2_VdM70w>
    <xmx:oPBbY04RfC88foBNrWOloMJshDEZKbin3RfvfhkZRJoLcpJj_2C5dQ>
    <xmx:oPBbY442i4NZAMcpqZQCBHKaiD37HPyZZa7a9dcqmIt7_vtzC4goUg>
    <xmx:ofBbY3TVaZqRl7-HOh0h5ylgzJPy1WpKCeDbgQNMvtPaN1kDZyXdtg>
Feedback-ID: i51094778:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id EDD5AA6007C; Fri, 28 Oct 2022 11:09:19 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-1087-g968661d8e1-fm-20221021.001-g968661d8
Mime-Version: 1.0
Message-Id: <587611e4-eb08-4b86-a8e8-aaa10f8efee6@app.fastmail.com>
In-Reply-To: <CABBYNZKJnmfWfvxdgpxNFUGc7jTKP+BGv6CiZc2MsR970L35MA@mail.gmail.com>
References: <20221027150822.26120-1-sven@svenpeter.dev>
 <20221027150822.26120-7-sven@svenpeter.dev>
 <CABBYNZKJnmfWfvxdgpxNFUGc7jTKP+BGv6CiZc2MsR970L35MA@mail.gmail.com>
Date:   Fri, 28 Oct 2022 17:08:59 +0200
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
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 6/7] Bluetooth: Add quirk to disable MWS Transport Configuration
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Luiz,

On Thu, Oct 27, 2022, at 20:59, Luiz Augusto von Dentz wrote:
> Hi Sven,
>
> On Thu, Oct 27, 2022 at 8:09 AM Sven Peter <sven@svenpeter.dev> wrote:
>>
>> Broadcom 4378/4387 controllers found in Apple Silicon Macs claim to
>> support getting MWS Transport Layer Configuration,
>>
>> < HCI Command: Read Local Supported... (0x04|0x0002) plen 0
>> > HCI Event: Command Complete (0x0e) plen 68
>>       Read Local Supported Commands (0x04|0x0002) ncmd 1
>>         Status: Success (0x00)
>> [...]
>>           Get MWS Transport Layer Configuration (Octet 30 - Bit 3)]
>> [...]
>>
>> , but then don't actually allow the required command:
>>
>> > HCI Event: Command Complete (0x0e) plen 15
>>       Get MWS Transport Layer Configuration (0x05|0x000c) ncmd 1
>>         Status: Command Disallowed (0x0c)
>>         Number of transports: 0
>>         Baud rate list: 0 entries
>>         00 00 00 00 00 00 00 00 00 00
>>
>> Signed-off-by: Sven Peter <sven@svenpeter.dev>
>> ---
>>  include/net/bluetooth/hci.h | 10 ++++++++++
>>  net/bluetooth/hci_sync.c    |  2 ++
>>  2 files changed, 12 insertions(+)
>>
>> diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
>> index 8cd89948f961..110d6df1299b 100644
>> --- a/include/net/bluetooth/hci.h
>> +++ b/include/net/bluetooth/hci.h
>> @@ -273,6 +273,16 @@ enum {
>>          * during the hdev->setup vendor callback.
>>          */
>>         HCI_QUIRK_BROKEN_EXT_SCAN,
>> +
>> +       /*
>> +        * When this quirk is set, the HCI_OP_GET_MWS_TRANSPORT_CONFIG command is
>> +        * disabled. This is required for some Broadcom controllers which
>> +        * erroneously claim to support MWS Transport Layer Configuration.
>> +        *
>> +        * This quirk can be set before hci_register_dev is called or
>> +        * during the hdev->setup vendor callback.
>> +        */
>> +       HCI_QUIRK_BROKEN_MWS_TRANSPORT_CONFIG,
>>  };
>>
>>  /* HCI device flags */
>> diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
>> index 76c3107c9f91..91788d356748 100644
>> --- a/net/bluetooth/hci_sync.c
>> +++ b/net/bluetooth/hci_sync.c
>> @@ -4260,6 +4260,8 @@ static int hci_get_mws_transport_config_sync(struct hci_dev *hdev)
>>  {
>>         if (!(hdev->commands[30] & 0x08))
>>                 return 0;
>> +       if (test_bit(HCI_QUIRK_BROKEN_MWS_TRANSPORT_CONFIG, &hdev->quirks))
>> +               return 0;
>
> Let's add a macro that tests both the command and the quirk so we
> don't have to test them separately.

Sure, I'll add a macro for v5.


Best,


Sven
