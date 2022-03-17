Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A16034DC12C
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 09:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbiCQIae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 04:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbiCQIac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 04:30:32 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F245E019;
        Thu, 17 Mar 2022 01:29:15 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id h11so6276186ljb.2;
        Thu, 17 Mar 2022 01:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=0LIMf2wAtLBEAi/57yWN7rM87seWRRBpgZ91TFWXDsc=;
        b=Ct1jRFK9QSNtX/UHfG54ye6ymLlehHvfGhaxcp4KotK30E4V7fGxxSRW2iMJ8nJWjr
         IX95NN9TNTnCKufsm5+m49eAxrXJSLQ4qH7fpRbR85s03bwOaGnm+mbCZx+tOVKWPqiV
         PP3yRghqAVBGHCYKL2iX9KS3xZQuFj8g3FPbgrtiMY91HvdR5F9SOQIWs9oSgDdlw754
         4Q64Pb4sF5dcuT5B4f2z4x/4MUOM5YegzVCLc34FAg65vxYm67s7hmCfNI6Pqp8p8u9J
         2dr+VmwRn2HltCf2aFgEYrTuZNArDMjdDEvTM9dM3VbDgWyVO7Lw/1bf+Rw5gWfyc0Fz
         j/mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=0LIMf2wAtLBEAi/57yWN7rM87seWRRBpgZ91TFWXDsc=;
        b=AzpwopQX3aHTcPglWjOvG5V2kq3fuw25lL2viTvKlC0xta8ePP3/klUX6TDSzDFl4k
         Mu7g0NYyQL10V5r3RW362cKlq6CiO9l593WySoWEcih0li0/j/zx3FP6HVGZtZuNY9/8
         AoTuHidSrma3LV2zg+Q8DPmLUC1c+qHWCZHXEcPnmZ6/CU9xrrc6IJz6zmXQu8oxP2WG
         9dyRhjVKUZySiXo28U5n2GlKleDzAd1aiS0JI2AJyVFUiEls4tpebDrOrRwEHSo2Rm3U
         7pB2AK2E8TKrgiKOplb+g5aDjtZymU8aJU2i2jOfw+F4UIDovM4ALTX9GmP5wCQh6eOz
         AxSA==
X-Gm-Message-State: AOAM533JVE29yiBVKXKLNAxjKBw2f+mRbTeWgOiHrUwNlJ9NSwJPQA2Z
        +/OJCkgZerxfX2qmadndc4c=
X-Google-Smtp-Source: ABdhPJygQccngwI1ufgBGMLKZLloqXjZMfJqcXYh6qOSHO3Vg4I+aYcTJqZghnw3PaphvUjTInlKqA==
X-Received: by 2002:a2e:a552:0:b0:249:3f52:9fec with SMTP id e18-20020a2ea552000000b002493f529fecmr2110810ljn.341.1647505753448;
        Thu, 17 Mar 2022 01:29:13 -0700 (PDT)
Received: from wse-c0127 ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id p1-20020a056512312100b004489135d9easm384297lfd.255.2022.03.17.01.29.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 01:29:12 -0700 (PDT)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Hans Schultz <schultz.hans@gmail.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next 0/3] Extend locked port feature with FDB locked
 flag (MAC-Auth/MAB)
In-Reply-To: <f9b3ecf5-c2a4-3a7a-5d19-1dbeae5acb69@gmail.com>
References: <20220310142320.611738-1-schultz.hans+netdev@gmail.com>
 <f9b3ecf5-c2a4-3a7a-5d19-1dbeae5acb69@gmail.com>
Date:   Thu, 17 Mar 2022 09:29:10 +0100
Message-ID: <86o825htih.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On ons, mar 16, 2022 at 17:18, Florian Fainelli <f.fainelli@gmail.com> wrote:
> On 3/10/2022 6:23 AM, Hans Schultz wrote:
>> This patch set extends the locked port feature for devices
>> that are behind a locked port, but do not have the ability to
>> authorize themselves as a supplicant using IEEE 802.1X.
>> Such devices can be printers, meters or anything related to
>> fixed installations. Instead of 802.1X authorization, devices
>> can get access based on their MAC addresses being whitelisted.
>> 
>> For an authorization daemon to detect that a device is trying
>> to get access through a locked port, the bridge will add the
>> MAC address of the device to the FDB with a locked flag to it.
>> Thus the authorization daemon can catch the FDB add event and
>> check if the MAC address is in the whitelist and if so replace
>> the FDB entry without the locked flag enabled, and thus open
>> the port for the device.
>> 
>> This feature is known as MAC-Auth or MAC Authentication Bypass
>> (MAB) in Cisco terminology, where the full MAB concept involves
>> additional Cisco infrastructure for authorization. There is no
>> real authentication process, as the MAC address of the device
>> is the only input the authorization daemon, in the general
>> case, has to base the decision if to unlock the port or not.
>> 
>> With this patch set, an implementation of the offloaded case is
>> supplied for the mv88e6xxx driver. When a packet ingresses on
>> a locked port, an ATU miss violation event will occur. When
>> handling such ATU miss violation interrupts, the MAC address of
>> the device is added to the FDB with a zero destination port
>> vector (DPV) and the MAC address is communicated through the
>> switchdev layer to the bridge, so that a FDB entry with the
>> locked flag enabled can be added.
>
> FWIW, we may have about a 30% - 70% split between switches that will 
> signal ATU violations over a side band interrupt, like mv88e6xxx will, 
> and the rest will likely signal such events via the proprietary tag
> format.

I guess that the proprietary tag scheme a scenario where the packet can
be forwarded to the bridge module's ingress queue on the respective
port?

> -- 
> Florian
