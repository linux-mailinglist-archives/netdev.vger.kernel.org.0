Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E913956005B
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 14:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233422AbiF2Mpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 08:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiF2Mph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 08:45:37 -0400
X-Greylist: delayed 909 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 29 Jun 2022 05:45:36 PDT
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C31D52F381
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 05:45:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1656505811; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=Ug5OWxYC92DnAqwqZdIHoQJipfgk+MleRCyexaU7TFeyZ3SsL5kaD+uFN0VL0QLxwh0tEFwknHFETDon6HwI14QAy0P5XWQEmgesQpzFuZg14nPdqONlHbffRuUQQIgguxJFs58K0A3GWgNx9jOYwPfRj5Vg2IS1/HDSzo//GCA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1656505811; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=9lMtAZDndGB3jpUozFLreF1kAlRElpA0ALvA8Di5ht4=; 
        b=hGUt7QDO0vADGmzVDYwMi+bXACS2WDQ+2PX6fnqmDP0YyiGj4WCQGCFGuhV95y0qeAe1ZeUyAZ7qxNDOoT+Miu6sGmVXAzVPftSIKdSwQdW3OY7KckDjbN4lUmmobCw2eyh7HmqIpOPa7zIKkfGhOMKaR4rvVREwNanmbEWBtn4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1656505811;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=9lMtAZDndGB3jpUozFLreF1kAlRElpA0ALvA8Di5ht4=;
        b=TYT56/WxM8ckqNh668pvb8FQMj2Jfgyql8Je6OyoObI3TEwsOxDXn/ISKbrWZGnE
        cE07PRk37iwP91jYHBPddFiUX6Vx8YxxLY2GgBhK4To4aZMiFvWwv0MuvLoS1yTWVcZ
        TRHSLDG7MreF0TyjNFGLjEyvC0iE2J4t2ZQObsvE=
Received: from [10.10.10.122] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1656505808317308.1345358862295; Wed, 29 Jun 2022 05:30:08 -0700 (PDT)
Message-ID: <6f4e00d6-6b7d-e4c7-8108-67c009f7a6d8@arinc9.com>
Date:   Wed, 29 Jun 2022 15:30:03 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH net-next RFC 0/3] net: dsa: realtek: drop custom slave MII
Content-Language: en-US
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, alsi@bang-olufsen.dk, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzk+dt@kernel.org
References: <20220629035434.1891-1-luizluca@gmail.com>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20220629035434.1891-1-luizluca@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.06.2022 06:54, Luiz Angelo Daros de Luca wrote:
> The last patch cleans all the deprecated code while keeping the kernel
> messages. However, if there is no "mdio" node but there is a node with
> the old compatible stings "realtek,smi-mdio", it will show an error. It
> should still work but it will use polling instead of interruptions.
> 
> My idea, if accepted, is to submit patches 1 and 2 now. After a
> reasonable period, submit patch 3.
> 
> I don't have an SMI-connected device and I'm asking for testers. It
> would be nice to test the first 2 patches with:

I'd love to test this on an Asus RT-AC88U which has got the 
smi-connected RTL8365MB switch but modifying the OpenWrt SDK to build 
for latest kernels is a really painful process. I know it's not related 
to this patch series but, does anyone know a more efficient way of 
building the kernel with rootfs with sufficent userspace tools? Like, am 
I supposed to use Buildroot, Yocto?

Arınç
