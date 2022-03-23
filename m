Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFA204E5473
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 15:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbiCWOom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 10:44:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbiCWOol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 10:44:41 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E09585F56;
        Wed, 23 Mar 2022 07:43:10 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id j15so3265985eje.9;
        Wed, 23 Mar 2022 07:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Hpxed2/jWw1SnL0rgO1qfgfRqMtI3k981lUGVm09vkU=;
        b=O2BqoSAh8gk1zLk+rTW6Ok7XPTKVbiDZpl3IsitPRospP8Ri04nFQm3HmjmxWD8esZ
         TXlNJRszB3c+JWkthBN0VqA68eeZNepKxhkBr/i6KRJ0mjx0O83AaS1wxvPJtGncuWbf
         2ioHKTZBpE1JeMuH5lWQmzVAw18gaQUjfSvRNysQbBEA2TAjHJZlPm30ZkCIVy03ALNU
         1ByYkDchELaUiRr9VHUFbLPb7AQWOeloXV4Dw6A1+gwGf/nVEQm6Jwd+SbR2pxBhl0ax
         tpdpy1ZjS5rouUd5ItbkvxVQJHNzQx7NOZeJzU6uousyu3EiPEFktr2bh53oRTJ9kaSI
         fmnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Hpxed2/jWw1SnL0rgO1qfgfRqMtI3k981lUGVm09vkU=;
        b=bvNtkVWGJkyDHihos6fj26hvlU/j/e1xuqsmq4mzE6u9VGpnDrSVpS5UTaVSn4t8vC
         nzr2H0PhbkWyjN6bWFtj15EDZYY8NXaWZlOCb7ypcnwSsiZJc14hdiMXcUGZND/yUYkK
         Ue8vOUpdHUjNaWx5Km3qof7s2kLtijeM8AEXqpFPhL66oiHyMo+LCbaoQaKjerzWaZnr
         5NeNdcZoagOg8vLeTr8BP9o7oqvq7mGFVYFUbcqMY+XHgQwWAgBahM1TvmJh0o5ukQrc
         Jg1KElxy/9/9TjhleZtf7jejNxddgQTwR0JXLq0zLKRCaU9C7F1WiUi6DCkjq3e19yjv
         8KMw==
X-Gm-Message-State: AOAM530WwpAoxiIPqDePOlkp2ALRYkbHfz+twBTpyRKuNxscIg8atQ4y
        SrQDcc9a1o8ZZTstEvunkPI=
X-Google-Smtp-Source: ABdhPJwyOwLyZClpvoP74uQ8L+CTpqUUUT4k9yf6eYbUGuuYrVf6B+0SSNew3VD7cWqS01XglgyBgw==
X-Received: by 2002:a17:907:b590:b0:6cf:48a4:9a4c with SMTP id qx16-20020a170907b59000b006cf48a49a4cmr329020ejc.6.1648046587068;
        Wed, 23 Mar 2022 07:43:07 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id n2-20020a17090673c200b006db8ec59b30sm24449ejl.136.2022.03.23.07.43.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 07:43:06 -0700 (PDT)
Date:   Wed, 23 Mar 2022 16:43:04 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Hans Schultz <schultz.hans@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 net-next 2/4] net: switchdev: add support for
 offloading of fdb locked flag
Message-ID: <20220323144304.4uqst3hapvzg3ej6@skbuf>
References: <20220317093902.1305816-1-schultz.hans+netdev@gmail.com>
 <20220317093902.1305816-3-schultz.hans+netdev@gmail.com>
 <86o81whmwv.fsf@gmail.com>
 <20220323123534.i2whyau3doq2xdxg@skbuf>
 <86wngkbzqb.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86wngkbzqb.fsf@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 23, 2022 at 01:49:32PM +0100, Hans Schultz wrote:
> >> Does someone have an idea why there at this point is no option to add a
> >> dynamic fdb entry?
> >> 
> >> The fdb added entries here do not age out, while the ATU entries do
> >> (after 5 min), resulting in unsynced ATU vs fdb.
> >
> > I think the expectation is to use br_fdb_external_learn_del() if the
> > externally learned entry expires. The bridge should not age by itself
> > FDB entries learned externally.
> >
> 
> It seems to me that something is missing then?
> My tests using trafgen that I gave a report on to Lunn generated massive
> amounts of fdb entries, but after a while the ATU was clean and the fdb
> was still full of random entries...

I'm no longer sure where you are, sorry..
I think we discussed that you need to enable ATU age interrupts in order
to keep the ATU in sync with the bridge FDB? Which means either to
delete the locked FDB entries from the bridge when they age out in the
ATU, or to keep refreshing locked ATU entries.
So it seems that you're doing neither of those 2 things if you end up
with bridge FDB entries which are no longer in the ATU.
