Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3CE85834D3
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 23:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233961AbiG0V1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 17:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiG0V1e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 17:27:34 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCCD05C972;
        Wed, 27 Jul 2022 14:27:33 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id bp15so33736524ejb.6;
        Wed, 27 Jul 2022 14:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dHk/nIZIen1AdZIuJjh0VLKLPwk90ODmGxgfoYUv0pM=;
        b=NUintwL8++PesHsw3v01wuUfAC4+ztcOw7Zb1LqLX3JL7NNi58TqpeHWbfZ7vVY4j6
         HNweitKxjbV7snOL9vBxB09RXpcmFxl/ro1TGnC9vNHRrCn4Nzyip9vERGIvOBZE5Flg
         HJc0tmAMEQyjG9JTsxhqWOJQ0IDLMc32g4xCTxn0jFuknDyCGSEprBTNokSfT6+J9d2g
         Q0Viwkn3ckuATa0ywSJJ/tSp7lsedI1KyfuVlH0Z1iWifwYf44WRu0ZeM5cvs7NWfVfG
         JCTueRN835o9aA1tfpzKaS9iZi6jNMqkyfPfLaxwn/tBpDbY3mrHfRPeYZS4II7ReX+x
         dQqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dHk/nIZIen1AdZIuJjh0VLKLPwk90ODmGxgfoYUv0pM=;
        b=mB9Kgk6POtp+MfWGsQptycI2bKtsm7dh9Mr8h2YLfpUcF+lMk9QoKCfMeUDTdgO/FK
         XCjss8w6MAExu7i6KSx+g/cWadIqK6Nkl7O8AHODRG8qS8hf3nv2rscWur+RThJjBRu3
         4P4JrlJK8b3Y2RSfRVmGepnKhXdYUTozUlRCQXRLbxh0Y+059eNZqiJ5nNy/e1tUOpj4
         eQnRAq4kUGeT+zuMJROguFhpj+D1I1zbOO2XgqsAyCsi7KzWCtjx/LMEeimt7KYuCGN3
         mvFln38Ao9lsiBMpp+xvFOoXIBNUMogrEqnT2WyHPbVtbiIlOU5WnqcCfzkuYL2gkgzV
         ouvw==
X-Gm-Message-State: AJIora8TQBD8TMYP/mvuIz6fp4hzA5+IAUg4+YodT1q6zlLb+/zm/3PF
        FgC5EnWxxAB2TkmfWLt4Twg=
X-Google-Smtp-Source: AGRyM1tZTJ6VoFWUEsrjg8ZdZdjWjNpwMczEJ2oNxZ5eZgqUIFB015mHYH5m704ibrPyhECQdRAccg==
X-Received: by 2002:a17:906:93e8:b0:72b:6923:a0b9 with SMTP id yl8-20020a17090693e800b0072b6923a0b9mr18572531ejb.244.1658957252154;
        Wed, 27 Jul 2022 14:27:32 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id y3-20020aa7ccc3000000b0043577da51f1sm10888831edt.81.2022.07.27.14.27.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 14:27:31 -0700 (PDT)
Date:   Thu, 28 Jul 2022 00:27:28 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Grzegorz Bernacki <gjb@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Samer El-Haj-Mahmoud <Samer.El-Haj-Mahmoud@arm.com>,
        upstream@semihalf.com
Subject: Re: [net-next: PATCH v3 6/8] net: core: switch to
 fwnode_find_net_device_by_node()
Message-ID: <20220727212728.hgf7vbasmup4i2il@skbuf>
References: <20220727064321.2953971-1-mw@semihalf.com>
 <20220727064321.2953971-7-mw@semihalf.com>
 <20220727143147.u6yd6wqslilspyhw@skbuf>
 <CAPv3WKc88KQN=athEqBg=Z5Bd1SC3QSOPZpDH7dfuYGHhR+oVg@mail.gmail.com>
 <20220727163848.f4e2b263zz3vl2hc@skbuf>
 <CAPv3WKe+e6sFd6+7eoZbA2iRTPhBorD+mk6W+kJr-f9P8SFh+w@mail.gmail.com>
 <20220727211112.kcpbxbql3tw5q5sx@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727211112.kcpbxbql3tw5q5sx@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 28, 2022 at 12:11:12AM +0300, Vladimir Oltean wrote:
> The 'label' property of a port was optional, you've made it mandatory by accident.
> It is used only by DSA drivers that register using platform data.

I didn't mean to say exactly this, the second phrase was an addition
through which I tried to make it clear that the "cpu" label *is* used,
but only by the drivers using platform data. With OF it's not, neither
that nor label = "dsa". We have other means of recognizing a CPU or DSA
port, by the 'ethernet' and/or 'dsa' phandles.

Additionally, the label is optional even for user port. One can have
udev rules that assign names to Ethernet ports. I think that is even
encouraged; some of the things in DSA predate the establishment of some
best practices.
