Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5D856D37FF
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 14:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbjDBM6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 08:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbjDBM57 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 08:57:59 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D1E16A60
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 05:57:58 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id t13so19481191qvn.2
        for <netdev@vger.kernel.org>; Sun, 02 Apr 2023 05:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680440277; x=1683032277;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qOalBZy5ltk6TN40To3s4pSUUZifGEYzxoD5wlM/R50=;
        b=Hd04PKzpHPcQz2rKsWcWBUlDw71aETM2rH2s8XUN0QnogM8LkY1IhhXIIquL8IKRKO
         t2Jdfebo+IyP9SPRDbt/eFmxN5VX5y8T5uZczHVT+OUlf6y0kiyAiGQ846BckjOFvQ3Z
         3jQgbVApgp1kfmKxO1kjkyn/hRmMaVS1NB6/cGRSwoYVk2vEFQvRsCpk6Xcy5QT2ooFH
         SRJT6TX6MhT8R4XpRnjVHhB+HvYWA69WixVmp6pfg/vJ8BtO++GhbkXMbrbNQkIiCwEY
         Nccdrny6DP/Z5RWoe17qX1ANydQ//pajlLuBeDq8odayNQHFPOY+DhbHB/2tvxgS3eZF
         w1dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680440277; x=1683032277;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qOalBZy5ltk6TN40To3s4pSUUZifGEYzxoD5wlM/R50=;
        b=XTl+qzF9M8D8tz+oPPOsM5bBceMJZ2MBJukuhaTj9b1YjpvPZQvpWR/kA2R/+tHnCv
         Iqfn3jcNnV7Jfshngp5+u0F3JNWWzd1pz8KQvVs2iqmcyxWhMHMeoqHQ56lRYYCl376C
         2/fXrd4AgfSXGpno+T9teXJ/k2AKhJBiPazVR06PLHv1HArY3wkDp+IYhZzZ3Q1wLZxD
         x9+FhPtXLs25T0c4FVDvzoDYxkFI/h1YavqH2RpjTkAMrDIMkreB7nxJQjmPXzUb+vrR
         918oiOGF6KAiPcSy+KNpP0M31zsVd947xVdL0mDYz7jKWZGsShhEFh4heY8JdBeYFjBt
         TMOQ==
X-Gm-Message-State: AAQBX9dSF8xGphRtk70o1vhS6/SeKpjfYnw6mokXe0JIG6FKQPdborlk
        rVZPpwWZKeAP1YolT5EiDv8=
X-Google-Smtp-Source: AKy350boua/01wcXHNci5wr2DVtdH9DAZimwmH/KwTktlEvGVQClmHGOitPh2p6jh6CTvn5qpVX51A==
X-Received: by 2002:a05:6214:2406:b0:5ac:d562:4ea8 with SMTP id fv6-20020a056214240600b005acd5624ea8mr30148737qvb.9.1680440277422;
        Sun, 02 Apr 2023 05:57:57 -0700 (PDT)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id y20-20020ac87094000000b003e4e9aba4b3sm1884659qto.73.2023.04.02.05.57.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Apr 2023 05:57:56 -0700 (PDT)
Message-ID: <4e1eb1da-c409-7541-9839-6621fda0ccfc@gmail.com>
Date:   Sun, 2 Apr 2023 05:57:54 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH net-next 6/7] net: dsa: make dsa_port_supports_hwtstamp()
 construct a fake ifreq
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Maxim Georgiev <glipus@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        =?UTF-8?Q?K=c3=b6ry_Maincent?= <kory.maincent@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
References: <20230402123755.2592507-1-vladimir.oltean@nxp.com>
 <20230402123755.2592507-7-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230402123755.2592507-7-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/2/2023 5:37 AM, Vladimir Oltean wrote:
> dsa_master_ioctl() is in the process of getting converted to a different
> API, where we won't have access to a struct ifreq * anymore, but rather,
> to a struct kernel_hwtstamp_config.
> 
> Since ds->ops->port_hwtstamp_get() still uses struct ifreq *, this
> creates a difficult situation where we have to make up such a dummy
> pointer.
> 
> The conversion is a bit messy, because it forces a "good" implementation
> of ds->ops->port_hwtstamp_get() to return -EFAULT in copy_to_user()
> because of the NULL ifr->ifr_data pointer. However, it works, and it is
> only a transient step until ds->ops->port_hwtstamp_get() gets converted
> to the new API which passes struct kernel_hwtstamp_config and does not
> call copy_to_user().
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
