Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3A968AA95
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 15:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233090AbjBDOed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 09:34:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjBDOec (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 09:34:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC47301AF;
        Sat,  4 Feb 2023 06:34:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 847A360C3E;
        Sat,  4 Feb 2023 14:34:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 518ADC433EF;
        Sat,  4 Feb 2023 14:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675521267;
        bh=LJ4CRn6Bmk26RHcXjAQDBTuF0R0J/GXwABjS4Ad3rmM=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=sb1xBqtQluQbOFWab5ivA8tCeC+afVELQy2AUKSJwt02P2N7cxp2xJPvyAD52t9gn
         I9c7VkhCeKbErCf7Ej+r4BcedPJ+LwDCiOAUxV15UG5okV411ENzILvbQYiGoMCrWz
         PjZC8leRxjtvJQquLhhE9gH5IsFigb4eczwYr/3v7Ebqt7aCCdzWGb0AmPdJFUmnZZ
         fDa73d+LT5eGVSFXM1DcXcGJaZKlbwSLjVUvDK0gF3HSPXC04SCVWIp9Kf/ZoJSQCM
         cLGyTbbJ6rDhot6Cbu+IIaXB33eO6jqwxRBHl8BmJAEe+HmOK7A8eDfQsen8ntaYcS
         2M9Q3YgyLDuiA==
Date:   Sat, 04 Feb 2023 15:22:20 +0100
From:   Conor Dooley <conor@kernel.org>
To:     yanhong wang <yanhong.wang@starfivetech.com>
CC:     linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>
Subject: Re: [PATCH v4 0/7] Add Ethernet driver for StarFive JH7110 SoC
User-Agent: K-9 Mail for Android
In-Reply-To: <81217dc9-5673-f7eb-3114-b39de8302687@starfivetech.com>
References: <20230118061701.30047-1-yanhong.wang@starfivetech.com> <Y8h/D7I7/2KhgM00@spud> <81217dc9-5673-f7eb-3114-b39de8302687@starfivetech.com>
Message-ID: <958E7B1C-E0FF-416A-85AD-783682BA8B54@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3 February 2023 04:02:54 GMT+01:00, yanhong wang <yanhong=2Ewang@starfi=
vetech=2Ecom> wrote:
>
>
>On 2023/1/19 7:21, Conor Dooley wrote:
>> Hey Yanhong!
>>=20
>> On Wed, Jan 18, 2023 at 02:16:54PM +0800, Yanhong Wang wrote:
>>> This series adds ethernet support for the StarFive JH7110 RISC-V SoC=
=2E The series
>>> includes MAC driver=2E The MAC version is dwmac-5=2E20 (from Synopsys =
DesignWare)=2E
>>> For more information and support, you can visit RVspace wiki[1]=2E
>>> =09
>>> This patchset should be applied after the patchset [2], [3], [4]=2E
>>> [1] https://wiki=2Ervspace=2Eorg/
>>> [2] https://lore=2Ekernel=2Eorg/all/20221118010627=2E70576-1-hal=2Efen=
g@starfivetech=2Ecom/
>>> [3] https://lore=2Ekernel=2Eorg/all/20221118011108=2E70715-1-hal=2Efen=
g@starfivetech=2Ecom/
>>> [4] https://lore=2Ekernel=2Eorg/all/20221118011714=2E70877-1-hal=2Efen=
g@starfivetech=2Ecom/
>>=20
>> I've got those series applied, albeit locally, since they're not ready,
>> but I cannot get the Ethernet to work properly on my board=2E
>> I boot all of my dev boards w/ tftp, and the visionfive2 is no exceptio=
n=2E
>> The fact that I am getting to the kernel in the first place means the
>> ethernet is working in the factory supplied U-Boot [1]=2E
>>=20
>> However, in Linux this ethernet port does not appear to work at all=2E
>> The other ethernet port is functional in Linux, but not in the factory
>> supplied U-Boot=2E
>>=20
>> Is this a known issue? If it's not, I'll post the logs somewhere for
>> you=2E In case it is relevant, my board is a v1=2E2a=2E
>>=20
>> Thanks,
>> Conor=2E
>>=20
>> 1 - U-Boot 2021=2E10 (Oct 31 2022 - 12:11:37 +0800), Build: jenkins-VF2=
_515_Branch_SDK_Release-10
>
>
>No, this is not a issue=2E=20
>These patches need to rely on the yt8531 phy driver of motorcomm company
>and the corresponding clock delay configuration to work normally,=20
>and the yt8531 phy driver is being submitted=2E I have applied the
>motorcomm patchs during my test on board v1=2E2b, so the ethernet cannot =
work without
>the application of the motorcomm patchs=2E=20
>
>For the patchs of yt8531, see [1]
>
>1 - https://patchwork=2Ekernel=2Eorg/project/netdevbpf/cover/202302020300=
37=2E9075-1-Frank=2ESae@motor-comm=2Ecom/

Please put that info into the cover of the next round of your submission t=
hen=2E

Thanks,
Conor=2E

