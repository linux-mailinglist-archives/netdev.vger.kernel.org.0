Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD7FB58569B
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 23:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239424AbiG2Vlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 17:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239412AbiG2Vle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 17:41:34 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E9C8BA88;
        Fri, 29 Jul 2022 14:41:33 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id w185so5710390pfb.4;
        Fri, 29 Jul 2022 14:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=57obf29IT2UZccMSTT/tsBJZzq+uEhJZEW2DCGBYqTs=;
        b=VSMlL6oM67DyvQHVa7hYnc+BDKZ9JV5hDkEoPfQsdRTbdqscTEIzoRgPjchYBJNwHi
         gTAPh/ObjO8/hr0CgzA74QPx0LgmpvKscRZ/2/h4HUo+suU8FIqnQiZ9CX3kz8wiX5bV
         kyA5lvik+duvYpXwKYZsA5ggMAc8CHkbIGi2kA3DGKbE+bcgXRWRobVQyuv7lF5kUdvd
         nOTRg1P3BMKRgR7sR04X2ZMJJETIfvsnIN/Mq0JWAAm8r6S5Yq7phpiWIWTZ9UbMnyOb
         HEtQFa5zYjp/+EhOqYOybzxpS2hj7SjJPv1RDPsfzI/Sn1aSDcPLB5VszwQcEdY/CE2H
         l2iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=57obf29IT2UZccMSTT/tsBJZzq+uEhJZEW2DCGBYqTs=;
        b=LGbYonIWdYT5xVz+D0B0B4cx1yj/boSmxIXGREv1V0XsaZ++5RlaMJ+CyVesu5sLgI
         kKyuPGmwnQ0NZEtOoRi2PX7H6UEqQd9s8GDrSo0yVGjtAE+GcVUYnQDARMWrzhqCmT1c
         t5arYEddGZ74IAipnmie8uLrSuYQ3HERlzkXtwsotehn/pDITVBMVRUUWPXaX6VMOxQL
         C4/mDxMUQo4oXbHjCe/58jUCN4Hik4M+CW3WtpiWX4o3a23dRZn6skrnA5W6dKnPipOu
         qG7PmF7w0QRlu8e1w9ofAL2SX19BnR3RQhChhj9HwI8CeIfiaUSVwqxU6S0tBpD+dz2H
         HIuA==
X-Gm-Message-State: ACgBeo0+xkZ95dkXuDwy760b3+cJW8eye86vZqtXaIirUYJ823skt5du
        mKC/SBkrgsKl1SmC7Zm70+Y=
X-Google-Smtp-Source: AA6agR64rffYEcSUdWLcbXSz+T/RM90MmyVd4b1DkhdyetJovCxlyp7qjQscjPtx/qoiDbiukPawxQ==
X-Received: by 2002:a63:1f42:0:b0:41b:bbb8:ee36 with SMTP id q2-20020a631f42000000b0041bbbb8ee36mr694099pgm.20.1659130893254;
        Fri, 29 Jul 2022 14:41:33 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b5-20020a170902d50500b0016be24e3668sm4139437plg.291.2022.07.29.14.41.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Jul 2022 14:41:32 -0700 (PDT)
Message-ID: <ab878e39-6a37-0f28-9b24-0b81287b40cc@gmail.com>
Date:   Fri, 29 Jul 2022 14:41:25 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [net-next PATCH v5 12/14] net: dsa: qca8k: move port VLAN
 functions to common code
Content-Language: en-US
To:     Christian Marangi <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220727113523.19742-1-ansuelsmth@gmail.com>
 <20220727113523.19742-13-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220727113523.19742-13-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8
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

On 7/27/22 04:35, Christian Marangi wrote:
> The same port VLAN functions are used by drivers based on qca8k family
> switch. Move them to common code to make them accessible also by other
> drivers.
> Also drop exposing busy_wait and make it static.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
