Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86BBA64DE0F
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 16:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbiLOPuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 10:50:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiLOPuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 10:50:05 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D272DAB1;
        Thu, 15 Dec 2022 07:50:04 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id fy4so10949051pjb.0;
        Thu, 15 Dec 2022 07:50:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=k8G/8RXiEhOzMc/81TIBBs+LW8Zpaz/v5O7f5fWpB04=;
        b=XM0kUwkqZi5hGnkSkjz2Cpud2SoXkmiX8yNV2ZZY0SzzaLFqDihi8ID/XChVRbxNqU
         2MeFUHFzOroqNGzWZKtWMVXwXagYJ9Fj8TB2Jur/qWlLB/Ifz808O5Pje9sURKIrJN1O
         1MKrw4uKPf+DeT3faCfN6wR9hWXRAq0fY4rdLetO1RAk5+Op1jq+acItfMbJxzxfVjFN
         //si2stfabeXgokfVbNRKMa58wN00SIHqEH08AyMtU6HRZ97DRRzPM67GFpHw9VKUjDI
         LT2mRmr0XcSNBfg4ZyjA3OUzYGoK6/1pyrWON0Hdt3/UxJNxSk6z2bck74KpfnqdKxlt
         CcsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=k8G/8RXiEhOzMc/81TIBBs+LW8Zpaz/v5O7f5fWpB04=;
        b=PCghuCjbbbZx3hE9UhwZMJbhIoca86zVqo8fzeGc/4EsaE3s+zs3ldgIHacYxvZtah
         ClP1a63d166mJvo/B2bKf522BMzAd9VZotQuUWA9XQHE9KVDH+ywq1s8tE3RiHqxkaXH
         ip91DwvlTjw4f8nidAneUz2HoEpOuuG9lO0CP7wb6499dlZu9HyiU5spFXqywGs7G2T0
         i2RTYiBiFuojqjiZLzImhTZk+U6wBgoXjuepixxGy+/qhmeIT7fRPd0/JJqp/JfQCWV2
         5EAYYmD1cP9XLguqsTM5BpHwo9J8LApJRkkeRFiVeznBkhHMLOU6jxYXPfu4ZOebb2SP
         TmwQ==
X-Gm-Message-State: ANoB5pk0Tj6ZAH03mgNkWiN+wExm3f1tZQF6dERf6/oewo0+fwXePKVg
        vVLdh6DCOvktIp0oz/o441M=
X-Google-Smtp-Source: AA0mqf65vw2X2wrKCt69D9VuyzNWu7U2N1te/d7g2e/bDiApq9HFSP9xcL4dE0SQSLGQvtPEju2TJw==
X-Received: by 2002:a17:902:ea91:b0:189:6f76:9b61 with SMTP id x17-20020a170902ea9100b001896f769b61mr28207711plb.39.1671119402897;
        Thu, 15 Dec 2022 07:50:02 -0800 (PST)
Received: from [192.168.0.128] ([98.97.42.38])
        by smtp.googlemail.com with ESMTPSA id n15-20020a170902d2cf00b00176b84eb29asm3931682plc.301.2022.12.15.07.50.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 07:50:02 -0800 (PST)
Message-ID: <3bc9c4dab64860fde7405fd589375f0ae087afe9.camel@gmail.com>
Subject: Re: [PATCH v7] igb: Assign random MAC address instead of fail in
 case of invalid one
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     =?UTF-8?Q?=E6=A2=81=E7=A4=BC=E5=AD=A6?= <lianglixuehao@126.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        linux-kernel@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Netdev <netdev@vger.kernel.org>
Date:   Thu, 15 Dec 2022 07:49:59 -0800
In-Reply-To: <2D8AD99A-E29B-40CC-AFEC-3D9D4AC80C14@126.com>
References: <20221213074726.51756-1-lianglixuehao@126.com>
         <Y5l5pUKBW9DvHJAW@unreal> <20221214085106.42a88df1@kernel.org>
         <Y5obql8TVeYEsRw8@unreal> <20221214125016.5a23c32a@kernel.org>
         <4576ee79-1040-1998-6d91-7ef836ae123b@gmail.com>
         <CAKgT0UdZUmFD8qYdF6k47ZmRgB0jS-graOYgB5Se+y+4fKqW8w@mail.gmail.com>
         <2D8AD99A-E29B-40CC-AFEC-3D9D4AC80C14@126.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-12-15 at 11:24 +0800, =E6=A2=81=E7=A4=BC=E5=AD=A6 wrote:
> The module parameter method does bring some inconvenience to the user,=
=20
> especially the parameter needs to be specified when the module is loaded.=
=20
> But as alexander said, if the net device is not successfully registered,=
=20
> the user has no chance to modify the invalid MAC address in the current E=
EPROM.=20
> At present, the read/write of EEPROM is bundled with the net driver.=20
> I am not sure if there is any other way to complete the modification of E=
EPROM=20
> independently of the network driver;
>=20
> Is it necessary to bind the registration of net device to the judgment of=
 invalid MAC?
> I personally think that MAC configuration is not the capability or functi=
on of the device,=20
> this should not affect the registration of the device;
> Can the invalid MAC be judged in the up stage of the network device?=20
> In this way, the net driver can continue to be loaded successfully,=20
> and the MAC can be changed using ethtool, and it will not increase the di=
fficulty of debugging for users.
>=20
> Thanks

The problem is that the decision all depends on use case. For a small
embedded device or desktop system it probably doesn't care as it will
always just default to DHCP most likely anyway so it doesn't really
care about maintaining a static MAC configuration.

However the igb device covers a range of products including workstation
and some server. The issue is that changing the MAC address on server
setups can trigger significant issues depending on the setup as things
like static IP reservations can be lost due to either a static DHCP
reservation or sysconfig potentially being lost. I know on older redhat
systems random MACs would lead to a buildup up sysconfig files as it
would generate a new one every time the MAC changed. It is one of the
reasons why Intel stopped using random MAC on VFs if I recall
correctly.

Lastly one thing that occurs to me is that there is support for
providing a MAC address via eth_platform_get_mac_address() as some of
the smaller embedded parts have an option to run without an EEPROM. I
wonder if there isn't a way to work around this by providing a
devicetree overlay on problematic systems.



