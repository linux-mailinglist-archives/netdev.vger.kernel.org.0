Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5B7C6D64F7
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 16:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235809AbjDDOOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 10:14:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235814AbjDDOOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 10:14:05 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A59A2E53
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 07:13:41 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id y14so33002691wrq.4
        for <netdev@vger.kernel.org>; Tue, 04 Apr 2023 07:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680617620;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6gWPfU+3dCp4avtMydf5sy0jjZueGe216fxq9JB7dSs=;
        b=cQqi9fBMk3QRSB35VfH1WZX7etVAKLj0hZMIQspPzOfcRnfvcu9mYkUBysPNcZQS50
         +WEr+kBw9u3EGrqbbnCe/N89mcpqqvEL/riXwku/c6BiX6s2y3kYt+h5vcD5H0gKyX9l
         ijFXdDB/+cTlCAgqpA533tveZastd+maS1DwKsKYKprqm2lCgBRWyijpwdClcnP+3oyu
         GIKUXzzj0MtDF4HfdcXRJB3ANfl7AlB4F9OnwSArZ6mC/XDERf2zroOq+cI6iCM0U0zd
         L2HcU55f5zyM5a+PTCkp4Ej1SVbyvzf/g0I3nyg2RxcUBMqbW98IpanlSBx4GnGh0bm3
         tZhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680617620;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6gWPfU+3dCp4avtMydf5sy0jjZueGe216fxq9JB7dSs=;
        b=uHzftk/AmJ+ZahUJPgdsbllo5f7MxXPGfCsYzLD58leBVZ7Iy39s4vv89nhpvu2aPf
         WVG1CTsXWCHVe9OHsoRz5SFlWYvhjMJzqjxdSpV6yAOIGEv3jZgM6GeiBV9vRkzGozq0
         99TD27H0OI1tbUjSTCYPAZnbKgtSRdGB0o8MjGdntudncRmlyG5rpW5MVMcsaZc4HuNf
         fOx8pkJmuwaYEjIFIjEhS0fGrxrIfQrxaG5bn+1vBQbNqIjQK53hjumnttIPjkESUxpH
         uHuRgxalSMVvDEITlxpNTgpzMi4rZKPAQeS2DV9VUHNqQsFF6OavtnQ3KK2PKkIeeSQo
         3eaw==
X-Gm-Message-State: AAQBX9cG8tsokcoBd2IG2RUAg2IciVwoVNh+m6wr4RETZLzWLSzyHbxF
        tP5qGGV+Qyq4FMyuPtp59As=
X-Google-Smtp-Source: AKy350ZhguHAl6Il5KzxdTDerhUNR8P6vwsUyIAV9O5wUqNq9z/mPgLwXsKgGfmEKXfgLagVHq3u0g==
X-Received: by 2002:a5d:6ac7:0:b0:2e4:f53a:45a1 with SMTP id u7-20020a5d6ac7000000b002e4f53a45a1mr2001146wrw.57.1680617619894;
        Tue, 04 Apr 2023 07:13:39 -0700 (PDT)
Received: from ?IPV6:2a02:3100:946d:f000:c909:5149:917a:ff4e? (dynamic-2a02-3100-946d-f000-c909-5149-917a-ff4e.310.pool.telefonica.de. [2a02:3100:946d:f000:c909:5149:917a:ff4e])
        by smtp.googlemail.com with ESMTPSA id e2-20020a5d5002000000b002cfe0ab1246sm12428422wrt.20.2023.04.04.07.13.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Apr 2023 07:13:39 -0700 (PDT)
Message-ID: <cea96aa7-0073-4d81-6265-666c81809a0e@gmail.com>
Date:   Tue, 4 Apr 2023 16:13:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: Convention regarding SGMII in-band autonegotiation
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexander 'lynxis' Couzens <lynxis@fe80.eu>,
        Chukun Pan <amadeus@jmu.edu.cn>,
        John Crispin <john@phrozen.org>
References: <ZCtvaxY2d74XLK6F@makrotopia.org>
 <a0570b00-669f-120d-2700-a97317466727@gmail.com>
 <ZCvqJAVjOdogEZKD@makrotopia.org>
 <539986da-0bf7-8dd3-73d7-a2a584846f18@gmail.com>
 <ZCv5Awt1tQic2Ygj@shell.armlinux.org.uk>
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <ZCv5Awt1tQic2Ygj@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04.04.2023 12:16, Russell King (Oracle) wrote:
> On Tue, Apr 04, 2023 at 11:56:45AM +0200, Heiner Kallweit wrote:
>> On 04.04.2023 11:13, Daniel Golle wrote:
>>> On Tue, Apr 04, 2023 at 08:31:12AM +0200, Heiner Kallweit wrote:
>>>> Ideas from the patches can be re-used. Some patches itself are not ready
>>>> for mainline (replace magic numbers with proper constants (as far as
>>>> documented by Realtek), inappropriate use of phy_modify_mmd_changed,
>>>> read_status() being wrong place for updating interface mode).
>>>
>>> Where is updating the interface mode supposed to happen?
>>>
>>> I was looking at drivers/net/phy/mxl-gpy.c which calls its
>>> gpy_update_interface() function also from gpy_read_status(). If that is
>>> wrong it should probably be fixed in mxl-gpy.c as well...
>>>
>>
>> Right, several drivers use the read_status() callback for this, I think
>> the link_change_notify() callback would be sufficient.
> 
> Sorry, but that's too late.
> 
Indeed, my bad. It's been some time ago that I last looked deeper
into this corner of phylib.

> The problem is that phy_check_link_status() reads the link status, and
> then immediately acts on it calling phy_link_up() or phy_link_down()
> as appropriate. While the phy state changes at the same time, we're
> still in the state machine switch() here, and it's only after that
> switch() that we then call link_change_notify() - and that will be
> _after_ phylink or MAC driver's adjust_link callback has happened.
> 
> So, using link_change_notify() would mean that the phylib user will
> be informed of the new media parameters except for the interface mode,
> _then_ link_change_notify() will be called, and only then would
> phydev->interface change - and there's no callback to the phylib
> user to inform them that something changed.
> 
> In any case, we do _not_ want two callbacks into the phylib user for
> the state change, especially not one where the first is "link is up"
> and the second is "oh by the way the interface changed".
> 

