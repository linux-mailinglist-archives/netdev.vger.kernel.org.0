Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D91E56A6493
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 02:13:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbjCABN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 20:13:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbjCABNy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 20:13:54 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DFA915891;
        Tue, 28 Feb 2023 17:13:51 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id l13-20020a0568301d6d00b0068f24f576c5so6692179oti.11;
        Tue, 28 Feb 2023 17:13:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=oEBx/PZMBNyHmgNExVPbEAPmWmNsn6Qj9xnMQGkJNno=;
        b=Gkm2+ehKSgvZvheKoRDMw5PoCdLIZu5A+3rnf1+N7KTvzei/nU6PzzO0wVTgHMOFUP
         YaeWiw2kTj5dkJSAa6gh/vdJHQY4O0cq3QfNdmIkenq6DDHJvK8SrIHS+JaclLZxXxhc
         2omCLS5UldgkTAecp4m5Dvsl/pFAWxtVraBB3wiR7BWy3v42qr4eRXelWC8/XIGfRwxI
         TiAsFg4m2uDN5ApBgTsWKo7V3rByleBGK78hVaUGUukIjfmN7IFrmq79VICrGzEWioIW
         6LaObCp8NCeW3DjKhi9J3ZAtqfY7ADHgzVRyMpih++0VMvYmq25AN0w0RpHEc1wxmZOf
         Mmuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oEBx/PZMBNyHmgNExVPbEAPmWmNsn6Qj9xnMQGkJNno=;
        b=LJTEhKvaocPnN6o5mptQsVtorwYGoWdwXo1Hj0DJATAQ4qad94Kfv0aEoFIaGreC4O
         LGWneX3pqjCUgeXk3hdVMoEUJWxmGFKkclR9QcBRlVKn+lT2b+6GV+mm7QvgkTt/eanz
         y/HWU28w5IwyYO2yfKx0Jzn/ZnGQfEZgjhg4dY6vmaUpz06vNZ0zST70nmSLOgK5Y65G
         Hq9OoRwlRISYCcS+LqOc8nVlAZMsqaUTR9hs5eP1aVzgO05Apw8OlNNykUCkmZfH6f/C
         eEnu566SrGMvGjInx7erZlJq7OsTmzSOmbH6Qzf8oYc4dEbagQNaa3TV2MAweVxy15Qt
         5jUw==
X-Gm-Message-State: AO0yUKVZVI1EWzNEjzGAvB/VgLJxDdidC+imqfjoBXmQxnjSFOmmvnUC
        HGd7LCMq2aTNYTx5YxWY6fw=
X-Google-Smtp-Source: AK7set9pAeCLIHmdY+B1zAQ/NF+5q3+1fPreB3j3JGWux5VMEZCbi/9KewRlamj7fIOsnXrdybD37g==
X-Received: by 2002:a9d:19eb:0:b0:694:11c1:29f7 with SMTP id k98-20020a9d19eb000000b0069411c129f7mr2759141otk.19.1677633230469;
        Tue, 28 Feb 2023 17:13:50 -0800 (PST)
Received: from [192.168.1.119] ([216.130.59.33])
        by smtp.gmail.com with ESMTPSA id z10-20020a0568301daa00b00693c4348e8asm4524817oti.42.2023.02.28.17.13.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Feb 2023 17:13:49 -0800 (PST)
Sender: Larry Finger <larry.finger@gmail.com>
Message-ID: <866973b7-1f54-21a3-79aa-992ed0594c1a@lwfinger.net>
Date:   Tue, 28 Feb 2023 19:13:48 -0600
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
 <e9f8501f-ede0-4d38-6585-d3dc2469d3fe@lwfinger.net>
 <7085019b-4fad-4d8d-89c0-1dd33fb27bb7@app.fastmail.com>
 <18be9b45-e7c1-9f81-afeb-3e0d4cfe5f73@lwfinger.net>
 <31fee002-db3b-43d9-b8bc-5a869516c2d7@app.fastmail.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <31fee002-db3b-43d9-b8bc-5a869516c2d7@app.fastmail.com>
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

On 2/28/23 02:37, Arnd Bergmann wrote:
> My intention was to keep Cardbus support working with old defconfig files,
> and I've not moved CONFIG_CARDBUS into a separate submenu between
> CONFIG_PCI_HOTPLUG and CONFIG_PCI_CONTROLLER but left the driver in
> drivers/pci/hotplug. I think that's the best compromise here, but maybe
> the PCI maintainers have a better idea.

Arnd,

I did a bit more investigation. My original .config had CONFIG_PCI_HOTPLUG not 
defined, but did have CONFIG_CARDBUS and the various yenta modules turned on. 
With your changes, the CONFIG_PCI_HOTPLUG overrode CARDBUS.

I thought mine was a corner case, but now I am not sure. As stated above, the 
Debian 12 factory configuration for ppc32 does not turn on PCI hotplug, but the 
x86_64 configuration for openSUSE Tumbleweed does. The x86_64 configuration in 
Fedora 37 does not contain CONFIG_PCI_HOTPLUG, but does have CARDBUS set.

It seems that several distros may get the wrong result with this change,

Larry

