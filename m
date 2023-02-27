Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2E56A4CCE
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 22:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbjB0VJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 16:09:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbjB0VJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 16:09:14 -0500
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C021ABE8;
        Mon, 27 Feb 2023 13:09:14 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id t7-20020a9d7487000000b00693d565b852so4356699otk.5;
        Mon, 27 Feb 2023 13:09:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=z9cnnYYpu8BDS9XfqEVOyxhljFJQa5MMvXQQwk5tjFo=;
        b=iskc2DzDrf04kFnyzvj2BPhQn2X1NzA6nf4jsN570hhf+uPXbcNOusy7NuhP3cZ82f
         msg09XYUdqm1sLCEE/C6XIFL9AWFU68fuL0b8rYVO1ZGpOmOhLKgPzkfwaqjf9Jp2ijA
         0iLH4klrWGyvYsmxCH5hsbg83wqynDREmgMacPQDymAU3lvkZlBeiIjk8EfZfj27xNFe
         vRrOUNgQ55cPBc3hZnRAzA2R2Bntl7GCcUL1lKA1OudhoprFH9hOCOCxZohku+bpzIqq
         4Mm1YryJQzbLqayJsE3ScpcmX+H40RWIMY0rBXfs5q1ElOm/Z2IxHdf9ll09D7TxvxGp
         FSPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z9cnnYYpu8BDS9XfqEVOyxhljFJQa5MMvXQQwk5tjFo=;
        b=tAK6u5/VbSO8jCk9IH2DDmR85AG2GjkumfrtFGE+Tu8kEwUNd3h/y++/xGzom1bmuR
         jX/GSxgOfLmEBARne0lAd0ydJVa/8WhtsTaGKLuZPDJluc6b5Rzxi9kNwyeRHxJU/lrG
         alk6xeYnGOczn8ZIYrg/eps/lRU9UWy1CSHjueKLjwy837zcAMYRw5L01x91PCWUH00m
         bysSz+zeMxYPIuGjYcUSn5Ldee4Jqrc7ovbTIIMg4KJGPZYwe1O9SYJ4DTXMYWyxi+hB
         ArrO6U1I4YsMr5sAh6/07hUDsFHqMqmRPYeLwG6heORH+bql6EndVfVG0QIQVU9IBJND
         Tiog==
X-Gm-Message-State: AO0yUKWF7OvHfrWPVhdldZSybqrQjPXNBc92oRxsSlyq8rQUECiEs0LK
        6JR4R4RsfCxks0D9H7UHgcU=
X-Google-Smtp-Source: AK7set/frfjoCGyDv00Ap3jhlqT84pkSMjxNpuW1vmRQrw6g4fOBFze3niUcHS4Xyc0uUKQNMdNRtw==
X-Received: by 2002:a9d:12b7:0:b0:68b:ca45:786c with SMTP id g52-20020a9d12b7000000b0068bca45786cmr171980otg.22.1677532153319;
        Mon, 27 Feb 2023 13:09:13 -0800 (PST)
Received: from [192.168.1.135] ([216.130.59.33])
        by smtp.gmail.com with ESMTPSA id k14-20020a056830150e00b00690e990e61asm3007429otp.14.2023.02.27.13.09.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Feb 2023 13:09:12 -0800 (PST)
Sender: Larry Finger <larry.finger@gmail.com>
Message-ID: <e9f8501f-ede0-4d38-6585-d3dc2469d3fe@lwfinger.net>
Date:   Mon, 27 Feb 2023 15:09:11 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [RFC 0/6] pcmcia: separate 16-bit support from cardbus
Content-Language: en-US
To:     Arnd Bergmann <arnd@arndb.de>, Arnd Bergmann <arnd@kernel.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-kernel@vger.kernel.org
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hartley Sweeten <hsweeten@visionengravers.com>,
        Ian Abbott <abbotti@mev.co.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Kevin Cernekee <cernekee@gmail.com>,
        Lukas Wunner <lukas@wunner.de>,
        Manuel Lauss <manuel.lauss@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Olof Johansson <olof@lixom.net>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, linux-can@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-wireless@vger.kernel.org, Netdev <netdev@vger.kernel.org>
References: <20230227133457.431729-1-arnd@kernel.org>
 <3d8f28d7-78df-5276-612c-85b5262a987a@lwfinger.net>
 <c17bff4e-031e-4101-8564-51f6298b1c68@app.fastmail.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <c17bff4e-031e-4101-8564-51f6298b1c68@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/27/23 14:38, Arnd Bergmann wrote:
> Is this the Cardbus or the PCMCIA version of the BCM4306 device? As far
> as I understand this particular chip can be wired up either way inside
> of the card, and the PowerBook G4 supports both types of devices.
> 
> If it's the PCMCIA version, then dropping support for it was the idea
> of the patch series that we can debate, but if it was the Cardbus version
> that broke, then this was likely a bug I introduced by accident.

Arnd,

The BCM4306 is internal, and wired directly to the PCI bus. My understanding is 
that the BCM4318 is a cardbus device. It definitely shows up in an lspci scan.

Larry

