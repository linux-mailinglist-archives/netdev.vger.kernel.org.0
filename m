Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3FA5AF953
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 03:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbiIGBIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 21:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbiIGBIN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 21:08:13 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4068D8E4DF;
        Tue,  6 Sep 2022 18:08:11 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id a5-20020a17090aa50500b002008eeb040eso179906pjq.1;
        Tue, 06 Sep 2022 18:08:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=4/ZIZdVDq8QafnDshkBp2uy/VhVapnzNn87zZZcPkMs=;
        b=BXCJ/81wXRUVjLzY5YNY5ye2rZiq86cruthWzZHRASDILgN42toBND9Kb/oCI8DphG
         wOIZs5V3vi3G2eOQ8siyMkOd0WguXRDXSLb5t6LhaQm6ADHwIEP81mnE2AGSMfO/+krw
         Mr65tQ0TG93dXkc8fXfbTgIUIl/G8UnEASBjLNMoKbQHAAskGXHNmOULrObU/hUKCDua
         AeukbRKsMK3P+J3bP1eBo/mEYdhQNlqEShfWIKtcpVPBTrJ7L3YYPOo9pOpJMvZmjN76
         MLWvhHFAeCKvXXsFZRSfaakgapGZlABn/kUgXHUNLrIDOPQlbYaE7Ik5yvYU0e6HUMlt
         jaWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=4/ZIZdVDq8QafnDshkBp2uy/VhVapnzNn87zZZcPkMs=;
        b=RTFXRCSNtPpk0KsZJzpIHEMzaeWZ6cTxQBjf5UkgRRCBihhW9fP0xFX8sLVpbDArAD
         otcjVtrzECUhfI3xHcuotKUlsTvwTv0jfI6n6gnYiYmH39gZBpdrU3kP7q2Iv1TFpiUH
         Q7gQ8MPpHNJYxqTNB4SV9eUrV5ZlLLixNclKMARvjEoo6L1Ef/ICq0Mggk0aQ4ilGagi
         dphTNLmgi/iHH/RBufC26GGwkLThZkPe9ue34SDfTAc9VljxYpYtojvyukgZ1hwpJtaT
         SvGCzCAgeg6vmd9nZ9xz3uMHzfHes7gtcfMrEHSfqqjeXE6a3mrgFAE7I/V+Iuawx80O
         GoZw==
X-Gm-Message-State: ACgBeo3+2BRB6uZ8rlBQhHM4GwaNlNs2ojvhbTAjXctkKBgja32F4K6U
        Z/MvH4byoHOvosMViYdvGIw+Dkb+RmajIg==
X-Google-Smtp-Source: AA6agR57Xaz/Sv3hksaBQZHcfqE+BOwZHQhh0tXNqUeibP9IAHNiFB2O+UvExvW6jYOK4VgxY94zGQ==
X-Received: by 2002:a17:902:a5c7:b0:172:dd10:f638 with SMTP id t7-20020a170902a5c700b00172dd10f638mr1323811plq.127.1662512890636;
        Tue, 06 Sep 2022 18:08:10 -0700 (PDT)
Received: from taoren-fedora-PC23YAB4 ([76.132.249.1])
        by smtp.gmail.com with ESMTPSA id om2-20020a17090b3a8200b001f22647cb56sm13392417pjb.27.2022.09.06.18.08.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 18:08:10 -0700 (PDT)
Date:   Tue, 6 Sep 2022 18:08:05 -0700
From:   Tao Ren <rentao.bupt@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heyi Guo <guoheyi@linux.alibaba.com>,
        Dylan Hung <dylan_hung@aspeedtech.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Liang He <windhl@126.com>, Hao Chen <chenhao288@hisilicon.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>, Tao Ren <taoren@fb.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] ARM: dts: aspeed: elbert: Enable mac3
 controller
Message-ID: <Yxfu9bqIfGOMN0C4@taoren-fedora-PC23YAB4>
References: <20220905235634.20957-1-rentao.bupt@gmail.com>
 <20220905235634.20957-3-rentao.bupt@gmail.com>
 <YxaS2mS5vwW4HuqL@lunn.ch>
 <YxalTToannPyLQpI@taoren-fedora-PC23YAB4>
 <Yxc1N1auY5jk3yJI@lunn.ch>
 <45cdae58-632a-7cbb-c9d5-74c126ba6a3e@gmail.com>
 <YxfZOPz/iWVm0G5F@taoren-fedora-PC23YAB4>
 <YxfnkSAVq6FO0vd/@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxfnkSAVq6FO0vd/@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Wed, Sep 07, 2022 at 02:36:33AM +0200, Andrew Lunn wrote:
> > Specific to this Elbert platform, we don't have plan to configure
> > BCM53134 via OpenBMC MDIO (dts), because we expect the switch always
> > loads configurations from its EEPROM.
> 
> DSA offers more than configuration. You can also get interface
> statistics, and knowledge of if an interface is up/down. And since the
> PHY of the switch becomes normal Linux PHYs, you can do cable testing,
> if the PHY has support, etc.
> 
> Do you have spanning tree to break L2 network loops? Linux will
> provide that as well.
> 
> However, if you are happy with dumb switch, then what you posted is
> sufficient.
> 
> 	Andrew

Apprently I have very limited knowledge in DSA area, because I didn't
know these features.

I will keep the patch series as is for now, to at least enable ethernet
in Elbert OpenBMC, and will work out new patch series to add BCM53134 in
DSA later.

Thanks again for the review.


Cheers,

Tao

