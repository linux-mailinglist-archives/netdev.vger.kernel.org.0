Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA38E6A4C5B
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 21:39:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbjB0Ui7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 15:38:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjB0Ui5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 15:38:57 -0500
X-Greylist: delayed 340 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 27 Feb 2023 12:38:53 PST
Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [85.215.255.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A76761CACC;
        Mon, 27 Feb 2023 12:38:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1677529967; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=IhyRK/LCSLXFmhDRD/Dr1guGh+7yYw8ILz5Ya6JLhCqlTkilCKeq4ncdICStUDhptw
    Hs4vULkR/DB4Y9gGUeqRvlebAIPE67RCnultI+PybtWhvnCAd7AB/87MTsS/grvxsj8Q
    D6Ofi5q7iLe8mnRWThJpKV2DW6HDpVf0Be173esQuB/XxVvD1G4lszA0s89P4rtFO1wR
    isfwGJUkcSklnAhtXGBWt0zLKltshyrVHSax4r3/Hsg3Er5l55MDFq+Qve9Evjb6/IOM
    fffjRyT5an+h+A5SmTTymMsj23sFeyDocdZ91WZkaGmTIlg//pfbM5LQmjJ3rNNK0xTZ
    bqhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1677529967;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=wKj3foVIx8l1HkzeDENrj553SI1e2euuTmuWcuQpxeY=;
    b=OHxih5nm72pjhM4dgaSVeDPtcaCAMbMJ80B2QCiJI/M3zwrTno8j0i6bLvlJDLGEDB
    78ZEM7jt3erWHSf71KqTp3UzHx/kGHsCSPKyV8FyYcRQGLROxE90T1Kv/dG8Uo+JIAMa
    MqcQdzdvrRr1S9+xAGo2hSDaUP7xvadSWIWTBLm4391Lk7I/iskkISLjGrIdm222q6pQ
    d/R3fsrxC8pNIEODz1k3dVZCpFqprMaIDBqRIpUwFf50QaZynCFxdHAKacikLBg5TJDc
    7D78wRDiCRxQYPJ2VKFU3TVujCgkO344Qcr0j4Benw9LjB7vBxdQJGQekSDZdG1HVjUB
    aSrw==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1677529967;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=wKj3foVIx8l1HkzeDENrj553SI1e2euuTmuWcuQpxeY=;
    b=Xb4ZTrw8FighxuOGDkFoVS7BNHKs0YJZMEPPef9v7rb110Sbl2r4w09XRLtX/5OfQ6
    UHaaGtZi+el4xG0O1+hdd5vMnh7XyM0mMpUNZxjbGDxbtlWoVV9deQpwoxTOZi6HVMtT
    SfQzC5QhthQrVrbJvKp+aYTF/tbZOCKTmJvvNZIal/Wfjs5cl8UAEuCBDJUS66jByUq1
    JraL6Ta7PJ11tuWQCyO6U/fc4c+qINyk/5WVgRQaQWz8i5nrcxpUOHdJcytSIANTXeGH
    XhZ/Ts3yj5ASLikVxUL4Pen0SSTa3OmdfLyCu8CV5uf6QIy/DALxigwWiTiJILvv5FJP
    LRkw==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusl129OHEdFq0USEbDUQnQ=="
Received: from [IPV6:2a00:6020:4a8e:5000::923]
    by smtp.strato.de (RZmta 49.3.0 AUTH)
    with ESMTPSA id x84a76z1RKWkrhm
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Mon, 27 Feb 2023 21:32:46 +0100 (CET)
Message-ID: <c5f1e652-b7e7-ff79-11e3-8c5c91011b83@hartkopp.net>
Date:   Mon, 27 Feb 2023 21:32:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [RFC 0/6] pcmcia: separate 16-bit support from cardbus
To:     Arnd Bergmann <arnd@arndb.de>, Arnd Bergmann <arnd@kernel.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-kernel@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hartley Sweeten <hsweeten@visionengravers.com>,
        Ian Abbott <abbotti@mev.co.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Kevin Cernekee <cernekee@gmail.com>,
        Lukas Wunner <lukas@wunner.de>,
        Manuel Lauss <manuel.lauss@gmail.com>,
        Olof Johansson <olof@lixom.net>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, linux-can@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-wireless@vger.kernel.org, Netdev <netdev@vger.kernel.org>
References: <20230227133457.431729-1-arnd@kernel.org>
 <1daa9f1f-6a68-273f-0866-72a4496cd0db@hartkopp.net>
 <c5ea695e-8693-4033-9941-c582f1c6f6be@app.fastmail.com>
Content-Language: en-US
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <c5ea695e-8693-4033-9941-c582f1c6f6be@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27.02.23 20:53, Arnd Bergmann wrote:
> On Mon, Feb 27, 2023, at 20:07, Oliver Hartkopp wrote:

>> I assume these CAN bus PCMCIA interfaces won't work after your patch
>> set, right?
> 
> Correct, the patch series in its current form breaks this since
> your laptop is cardbus compatible. The options I can see are:
> 
> - abandon my series and keep everything unchanged, possibly removing
>    some of the pcmcia drivers that Dominik identified as candidates
> 
> - decide on a future timeline for when you are comfortable with
>    discontinuing this setup and require any CAN users with cardbus
>    laptops to move to USB or cardbus CAN adapters, apply the series
>    then
> 
> - duplicate the yenta_socket driver to have two variants of that,
>    require the user to choose between the cardbus and the pcmcia
>    variant depending on what card is going to be used.
> 
> Can you give more background on who is using the EMS PCMCIA card?
> I.e. are there reasons to use this device on modern kernels with
> machines that could also support the USB, expresscard or cardbus
> variants, or are you likely the only one doing this for the
> purpose of maintaining the driver?

Haha, good point.

In fact the EMS PCMCIA, the PEAK PCMCIA (PCAN PC Card) and the supported 
Softing PCMCIA cards are nearly 20 year old designs and they are all 
discontinued for some time now. Today you can easily get a high 
performance Classical CAN USB adapter with an excellent OSS firmware for 
~13 EUR.

The only other laptop CAN "Cards" I'm aware of are PCIe "ExpressCard" 
34/54 from PEAK System which use the PCI subsystem.

Maybe you are right and we should simply drop the support for those old 
PCMCIA drivers which will still be supported for the LTS 6.1 lifetime then.

@Marc Kleine-Budde: What do you think about removing these three drivers?

Best regards,
Oliver
