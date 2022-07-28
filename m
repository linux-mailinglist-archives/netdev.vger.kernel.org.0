Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 321C358466D
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 21:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbiG1SyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 14:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiG1SyY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 14:54:24 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98941747A6
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 11:54:23 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id os14so4668378ejb.4
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 11:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc;
        bh=VzdvYy/SKGrNllM02jn9EtMajZHmCFOfgXCfewO1fuA=;
        b=hHZ5pSvQF/z+Kp6q+RIoV/pPZP4j4ddUDfKW4Zu/zkeAKQEMeNsPb5SsoFyK0jNPXO
         7NOoS1QeurFbcn7TttUpjxG5VaYNwtDyWpYb6shc5lYMUBlSY68KXmFkrJiD97XDhRC2
         B7qv3MP1yVCZ+U5tyz8Gr0s8czHNqvKOzAnlj1Ypnyx0rLXjw+IXQR0e7QukyXlSvnDJ
         5bFAr0GZr8x8lyqlH4V04FC9KDqU5ic1PPvtP+bjlPmpEfQkbaT2YUI4LV/WOzNTPxth
         uNhju7ZPGmwNjdPvoDgZ02jrHLmAL2MqaHQvVET9WEfHstFYyvFVL5n4RUZUfasTkJCk
         bIug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=VzdvYy/SKGrNllM02jn9EtMajZHmCFOfgXCfewO1fuA=;
        b=zefToovIE+TkVjPL8Pa8mVClVRfdnp6j93u2R+mqlR0Zkd0lQgmTM/bX9cfVKPyfSt
         K+3EPJ8IjHh16q9XQGj/GceCS5hXO1Cb+eSNa9MjEyvrxQug5AipstZWraOd2OJW8nsc
         Y1Ae1jj6aVP4iUFYkhmSu6nvkH7qdTuixi0EZofXdGCiH2g/yfLJgNDM1uSMdziLVr2Y
         16/xCeobbBKBODghEqb3RBgh5y8oLn6wUO73n8l0TB6OIGt0gHK0Ds16Q1BDR5sX5FQ7
         ySLPoF7LqyHLaZqzY8L5yiactjbTbL5P9PWr3u71jLx8KLCAfys/4cgCtYt6lzEpF4Bb
         pbfA==
X-Gm-Message-State: AJIora9gphxBTjwd2zYweV8ErTPmgmVKqEdNXsWH3tBd9iR8lxpPXSn0
        G6Qh4iy+SggLaiA8tCGNc1tLx5O9CZM=
X-Google-Smtp-Source: AGRyM1vP68mrHHQcIgePgaPHShz3OVt1ujwLYADuUMibtr65xrIVCDYmC30lR+eY8YPc0wAqnCOjbw==
X-Received: by 2002:a17:907:2855:b0:72b:67b7:2c28 with SMTP id el21-20020a170907285500b0072b67b72c28mr213727ejc.331.1659034462014;
        Thu, 28 Jul 2022 11:54:22 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id m9-20020aa7c2c9000000b0043bbf79b3ebsm1134331edp.54.2022.07.28.11.54.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jul 2022 11:54:21 -0700 (PDT)
Subject: Re: [PATCH net-next v2 12/14] sfc: set EF100 VF MAC address through
 representor
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     ecree@xilinx.com, davem@davemloft.net, pabeni@redhat.com,
        linux-net-drivers@amd.com, netdev@vger.kernel.org
References: <cover.1658943677.git.ecree.xilinx@gmail.com>
 <304963d62ed1fa5f75437d1f832830d7970f9919.1658943678.git.ecree.xilinx@gmail.com>
 <20220727201034.3a9d7c64@kernel.org>
 <67138e0a-9b89-c99a-6eb1-b5bdd316196f@gmail.com>
 <20220728092008.2117846e@kernel.org>
 <8bfec647-1516-c738-5977-059448e35619@gmail.com>
 <20220728113231.26fdfab0@kernel.org>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <bfc03b98-53ce-077a-4627-6c8d51a29e08@gmail.com>
Date:   Thu, 28 Jul 2022 19:54:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220728113231.26fdfab0@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/07/2022 19:32, Jakub Kicinski wrote:
> IIRC the reprs are all linked to the PCI device of the PF in sysfs,
You mean /sys/class/net/$VFREP/device?  On sfc that's (intentionally)
 nonexistent; the only visible connection between repr and its owning
 PF is /sys/class/net/$VFREP/phys_switch_id which holds the same
 value as /sys/class/net/$PF/phys_port_id.

> How do you map reprs to VFs? The PCI devices of the VF may be on 
> a different system.
That's what the client ID from patch #10 is for.  We ask the FW for
 a handle to "caller's PCIe controller → caller's PF → VF number
 efv->idx", and that handle is what we store in efv->clid, and later
 pass to MC_CMD_SET_CLIENT_MAC_ADDRESSES in patch #12.

The user determines which repr corresponds to which VF by looking in
 /sys/class/net/$VFREP/phys_port_name (e.g. "p0pf0vf0").

> But reps are like switch ports in a switch ASIC, and the PCI
> device is the other side of the virtual wire. You would not be
> configuring the MAC address of a peer to peer link by setting 
> the local address.
Indeed.  I agree that .ndo_set_mac_address() is the wrong interface.
But the interface I have in mind would be something like
    int (*ndo_set_partner_mac_address)(struct net_device *, void *);
 and would only be implemented by representor netdevs.
Idk what the uAPI/UI for that would be; probably a new `ip link set`
 parameter.

-ed
