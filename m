Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9B95BD065
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 17:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbiISPRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 11:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbiISPQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 11:16:36 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE2262251D;
        Mon, 19 Sep 2022 08:15:56 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 56C0F5C03AB;
        Mon, 19 Sep 2022 11:15:55 -0400 (EDT)
Received: from imap47 ([10.202.2.97])
  by compute2.internal (MEProxy); Mon, 19 Sep 2022 11:15:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=svenpeter.dev;
         h=cc:cc:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1663600555; x=1663686955; bh=IJ
        MTW8UozEq4kXWzkrXIWScQVhLfZvAbgQQvmEGIG9A=; b=rBDuNZWtZkpL26YBye
        R9OYq1BLfrYeOYvCcL9kc0+qk+sPyDcIpUEpkvHFzFSr589NM20dKE5ogc82EOQN
        NSRU72xWJn1Q+rP6qx2T71WWZWwqN71h9Hmx7v4UDCy3WJPruUzt0S9hyPSDXWST
        HPJwno5DLvwTuBGwfYDxlzEmaa8Y49N1qaz1gLPINx4DM468YrLgvbweoN4Iqps3
        bs8493F5Ew6D2jwAaxoQ/KkAOx+HGoPP2TBlU+Fy3K6fiME58ZxKZ05lgm7IZTVL
        Orj3qWn9vBe4ZQ0zI7p2WU41lAUUr/h4hcu+LQX5DI89KCX4SfPKtTUwrbdmjlgI
        Vkuw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1663600555; x=1663686955; bh=IJMTW8UozEq4kXWzkrXIWScQVhLf
        ZvAbgQQvmEGIG9A=; b=DcfEDWGC8jagbQAcl82nUeQWb0OMJXs6T+nwyOe4t2z1
        K7JQPEQNg9kdjcR8UuDKyg7vYp55XLINXBxs1KZ5+eE9ME5KInwDcDjiPDnjKL9L
        rcgA4rIoJ0hbPh3tWekVxC0mvuF8XTiJDCOONNkdo1UD3Bvt9ArBRxPhIJyFoOrc
        0yv87BlfSYSP8WBuEx7UzXpXsOlQem6534nT/f386hdZGdi8YJL2tcajeVwIYfRP
        4kW1cpDiZP5IM611Bn5VIorwp35DXuWhrjnxglM+rj0X1H0GhSaGh7TOdv0SalPH
        Hle5FsuVPnFCgbEgfaWIdI4+wmOw09J7Tj4P5CGATA==
X-ME-Sender: <xms:q4coY8PN0Bbq0gtDpb0q4fd90zXSlUC7mNrJEENwFlkARhJKuW42Ow>
    <xme:q4coYy_qfmHIB9GVDwuYCspP4JGJnstGJzQT96fnLmWWErvMJRbaSHvQlEOJ1QPag
    PKxlzodzHOtK41YC0s>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedvjedgkeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedfufhv
    vghnucfrvghtvghrfdcuoehsvhgvnhesshhvvghnphgvthgvrhdruggvvheqnecuggftrf
    grthhtvghrnhepleevgfegffehvedtieevhfekheeftedtjeetudevieehveevieelgffh
    ieevieeunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    epshhvvghnsehsvhgvnhhpvghtvghrrdguvghv
X-ME-Proxy: <xmx:q4coYzRIJCZZy1uzO7npOzBGCO1nT7rw-BYE57EJeTYuO1x_UF7Wbw>
    <xmx:q4coY0viJMOUqmqNV4sxc0TC4z6WDn5uDvduok3V_Izr0017CRBDFg>
    <xmx:q4coY0eAax0YQ3mdRKElwCvfRfKrVN_c7bZJZMyqqQVP407DH9MkMw>
    <xmx:q4coY4_kwPdlrKn9W6E4CfwYOS2xkPMXHC2QQx2jyXU6cC6sFUIqog>
Feedback-ID: i51094778:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 1FAB0A6007C; Mon, 19 Sep 2022 11:15:55 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-935-ge4ccd4c47b-fm-20220914.001-ge4ccd4c4
Mime-Version: 1.0
Message-Id: <581df839-87d6-4076-8d83-5f3174852a61@app.fastmail.com>
In-Reply-To: <CAL_JsqL96Er9JuDajHWtf=i7bvzrf7PLzk-G-Qm4wTxTr5BStg@mail.gmail.com>
References: <20220907170935.11757-1-sven@svenpeter.dev>
 <20220907170935.11757-3-sven@svenpeter.dev>
 <bcb799ea-d58e-70dc-c5c2-daaff1b19bf5@linaro.org>
 <20220912211226.GA1847448-robh@kernel.org>
 <CAL_JsqL96Er9JuDajHWtf=i7bvzrf7PLzk-G-Qm4wTxTr5BStg@mail.gmail.com>
Date:   Mon, 19 Sep 2022 17:15:54 +0200
From:   "Sven Peter" <sven@svenpeter.dev>
To:     "Rob Herring" <robh@kernel.org>,
        "Krzysztof Kozlowski" <krzysztof.kozlowski@linaro.org>
Cc:     "Marcel Holtmann" <marcel@holtmann.org>,
        "Johan Hedberg" <johan.hedberg@gmail.com>,
        "Luiz Augusto von Dentz" <luiz.dentz@gmail.com>,
        "Krzysztof Kozlowski" <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "Hector Martin" <marcan@marcan.st>,
        "Alyssa Rosenzweig" <alyssa@rosenzweig.io>, asahi@lists.linux.dev,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "open list:BLUETOOTH DRIVERS" <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/5] dt-bindings: net: Add Broadcom BCM4377 family PCIe
 Bluetooth
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Thu, Sep 15, 2022, at 15:09, Rob Herring wrote:
> On Mon, Sep 12, 2022 at 4:12 PM Rob Herring <robh@kernel.org> wrote:
>>
>> On Thu, Sep 08, 2022 at 01:19:17PM +0200, Krzysztof Kozlowski wrote:
>> > On 07/09/2022 19:09, Sven Peter wrote:
>> > > These chips are combined Wi-Fi/Bluetooth radios which expose a
>> > > PCI subfunction for the Bluetooth part.
>> > > They are found in Apple machines such as the x86 models with the T2
>> > > chip or the arm64 models with the M1 or M2 chips.
>> > >
>> > > Signed-off-by: Sven Peter <sven@svenpeter.dev>
>> > > ---
>
>> > > +examples:
>> > > +  - |
>> > > +    pcie {
>> > > +      #address-cells = <3>;
>> > > +      #size-cells = <2>;
>> > > +
>> > > +      bluetooth@0,1 {
>> >
>> > The unit address seems to be different than reg.
>>
>> Right, this says dev 0, func 1.
>
> Actually, the reg value of 0x100 is correct. func is bits 8-10. dev
> starts in bit 11.

Yup, if I write the example as

  - |
    pcie@a0000000 {
      #address-cells = <3>;
      #size-cells = <2>;
      reg = <0xa0000000 0x1000000>;
      device_type = "pci";
      ranges = <0x43000000 0x6 0xa0000000 0xa0000000 0x0 0x20000000>;

      bluetooth@0,1 {
        compatible = "pci14e4,5f69";
        reg = <0x100 0x0 0x0 0x0 0x0>;
        brcm,board-type = "apple,honshu";
        /* To be filled by the bootloader */
        local-bd-address = [00 00 00 00 00 00];
      };
    };


then no warnings appear. If I instead use "bluetooth@0,2" I get the following
warning:

Warning (pci_device_reg): /example-0/pcie@a0000000/bluetooth@0,2: PCI unit address format error, expected "0,1"



Sven
