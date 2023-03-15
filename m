Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00F246BBC41
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 19:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231875AbjCOSg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 14:36:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232559AbjCOSgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 14:36:17 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91226911F3;
        Wed, 15 Mar 2023 11:35:38 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id d7so17207033qtr.12;
        Wed, 15 Mar 2023 11:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678905316;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=m749fDtbrwnbtsdbSR3iTym7V0AHJvTvz+0m46zxJQA=;
        b=py0F/+uO1s9taxL+qiIsLsRJGbq4tgLbGeY3r8fsYrX83XpqAItfpFJmr8MeSBT4ee
         aTy1By1IOGejChNJl6R/q1PZ1iBHcCPq6RoXf4yEkvMQUeqZ11PSakMYNteqvY4u2mHF
         uk9hiyOcNbAJ9U3KHVLRGQLDcV1NWFPsTCjevk+qGsfNJCP0KqwXEI4uQoOFJaKG7Y2v
         GdVwJHy1eulKyvlr2GB1Asy4I5+T4U1EBN3EOR6eaRjj7d+lg9bqo8pCCwSQ+N3QWBMs
         h3970gEf0tobyE1pa3uGCSZuMdZOuhs2Hl3Bcjf3tV44k/T673vv/UNlOtE2x/XPJkxu
         1QCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678905316;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m749fDtbrwnbtsdbSR3iTym7V0AHJvTvz+0m46zxJQA=;
        b=b+22XLf2QEsQ4Z+a8zK5eEyZirgB20kNZ0w2RiaxyxfMvAPlaYd1myCf1epJUGNXYI
         RkEhALPqAFBtjoBPAFRqJJlYI9MOK/DqnynOhSpWG+et6hOFnZ/vqj/E7hq3cvkE5n4d
         Kq+oE+0VLgu12ZtAgRYGnLmklcr/xe3hr/m6QVh0uCLtu/jV+NLqsxJ8qkbkRcobep1n
         L+ycIVGIaMpnD7upPztOf/1CdtTjWk5zMNhTydVMMk3mRWfcWyLGPE95Wr3Lb2VavKSS
         abQL1US7XIXv6MVJJTxkoVvpurY1J6IxnkFqDwbbsLAnhmfi9yGJaE86deUaDwpIectg
         YbpQ==
X-Gm-Message-State: AO0yUKXfluPQqCLQ+X1Td9/zDZNZBe8pPBwVwWCGIGWHDtiFDlI0qEIU
        P7BX37T/KAfg2q2EVSyB16E=
X-Google-Smtp-Source: AK7set+QNmug8jooNtpKuNS14ABi91L3keZQT7KpiNrvi+ztPfTXD58T4sF7k1fVpHSX37CBNg6/pg==
X-Received: by 2002:a05:622a:c9:b0:3c0:3d56:8c40 with SMTP id p9-20020a05622a00c900b003c03d568c40mr1380096qtw.62.1678905316027;
        Wed, 15 Mar 2023 11:35:16 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id x1-20020ac87ec1000000b003bfb6ddc49dsm4142144qtj.1.2023.03.15.11.35.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 11:35:15 -0700 (PDT)
Message-ID: <a5eff8f8-aa9c-90d2-a960-fa462bf3dd00@gmail.com>
Date:   Wed, 15 Mar 2023 11:35:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net 2/2] net: dsa: mv88e6xxx: fix max_mtu of 1492 on 6165,
 6191, 6220, 6250, 6290
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Murali Krishna Policharla <murali.policharla@broadcom.com>,
        Lukasz Majewski <lukma@denx.de>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
References: <20230314182405.2449898-1-vladimir.oltean@nxp.com>
 <20230314182405.2449898-3-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230314182405.2449898-3-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/14/23 11:24, Vladimir Oltean wrote:
> There are 3 classes of switch families that the driver is aware of, as
> far as mv88e6xxx_change_mtu() is concerned:
> 
> - MTU configuration is available per port. Here, the
>    chip->info->ops->port_set_jumbo_size() method will be present.
> 
> - MTU configuration is global to the switch. Here, the
>    chip->info->ops->set_max_frame_size() method will be present.
> 
> - We don't know how to change the MTU. Here, none of the above methods
>    will be present.
> 
> Switch families MV88E6165, MV88E6191, MV88E6220, MV88E6250 and MV88E6290
> fall in category 3.
> 
> The blamed commit has adjusted the MTU for all 3 categories by EDSA_HLEN
> (8 bytes), resulting in a new maximum MTU of 1492 being reported by the
> driver for these switches.
> 
> I don't have the hardware to test, but I do have a MV88E6390 switch on
> which I can simulate this by commenting out its .port_set_jumbo_size
> definition from mv88e6390_ops. The result is this set of messages at
> probe time:
> 
> mv88e6085 d0032004.mdio-mii:10: nonfatal error -34 setting MTU to 1500 on port 1
> mv88e6085 d0032004.mdio-mii:10: nonfatal error -34 setting MTU to 1500 on port 2
> mv88e6085 d0032004.mdio-mii:10: nonfatal error -34 setting MTU to 1500 on port 3
> mv88e6085 d0032004.mdio-mii:10: nonfatal error -34 setting MTU to 1500 on port 4
> mv88e6085 d0032004.mdio-mii:10: nonfatal error -34 setting MTU to 1500 on port 5
> mv88e6085 d0032004.mdio-mii:10: nonfatal error -34 setting MTU to 1500 on port 6
> mv88e6085 d0032004.mdio-mii:10: nonfatal error -34 setting MTU to 1500 on port 7
> mv88e6085 d0032004.mdio-mii:10: nonfatal error -34 setting MTU to 1500 on port 8
> 
> It is highly implausible that there exist Ethernet switches which don't
> support the standard MTU of 1500 octets, and this is what the DSA
> framework says as well - the error comes from dsa_slave_create() ->
> dsa_slave_change_mtu(slave_dev, ETH_DATA_LEN).
> 
> But the error messages are alarming, and it would be good to suppress
> them.
> 
> As a consequence of this unlikeliness, we reimplement mv88e6xxx_get_max_mtu()
> and mv88e6xxx_change_mtu() on switches from the 3rd category as follows:
> the maximum supported MTU is 1500, and any request to set the MTU to a
> value larger than that fails in dev_validate_mtu().
> 
> Fixes: b9c587fed61c ("dsa: mv88e6xxx: Include tagger overhead when setting MTU for DSA and CPU ports")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

