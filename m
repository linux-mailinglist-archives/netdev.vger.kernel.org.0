Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66E5A6D3800
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 15:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbjDBNBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 09:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbjDBNBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 09:01:30 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D33510A89
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 06:01:29 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id on15so6201773qvb.7
        for <netdev@vger.kernel.org>; Sun, 02 Apr 2023 06:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680440488; x=1683032488;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oxXPyTPKP2oE3eyGtRNpy4db/f6/PfEID91UVydyuX4=;
        b=EK/3xO/pFaiU59O8AiNfLwaT9t6D3bSF9G4hWFR4v/mcPCtarLLNCw6k2Vr8AR1J/V
         KCrSeXla1WbYOz11stYSmuNEXFXCtUZBYr3FprrNbewNm4KKq0EMO9nfbWyiMLVd+DI/
         0Da+MecndFTv+EYJStaRtoS6dJhS+WhctWqgIAUPvj3Q1SB11NV031X9U57sq0HQeIYU
         8lCzA5WUC/seC9cOqpUrH7nvHm9x+9js0GRtk4i37DmtUyj4WxVmWJSK866Xe3P6hQXx
         V/ey7UWzf9sP2OxH87mP0pXlghLzAFY981txHUIGO93lj76PAdV+oEoVGcmqQHebJ0D+
         tfOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680440488; x=1683032488;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oxXPyTPKP2oE3eyGtRNpy4db/f6/PfEID91UVydyuX4=;
        b=omJLJw/IBD02jBI/KdhFBjED/fyUchKi36lnHoJ5zcnbCUf/hDI2w5hD2ZQdk6SWIb
         GbL1MTdvo2cYHfb20akLfvZgMmipYLpJhToWMzzvnPBY4TjPyRS2DDhl5xJS2/BXXL0i
         jyb2kuGLPWwe5ScVzB09uR25Pl2b1iXnU8xjbTz81K+bp7nGaHHgXKMogrzrkGRUrEBS
         GVclpu7UXJyc+SeWmWR41HSP4kMDLQhTx+EVpWviTCdSGJ2p7OSPPymRmugZt99MeXEF
         ZdKu8CfPPpuzuDxg2XtoEVkk2QFYtDJWSBtM+BgnYFDEVZUA4YsqVNQ2xfj9J0Rt62Yk
         qNkA==
X-Gm-Message-State: AAQBX9ecrKVC5ZrQKB95QDo0TM0W28u9qLSRKJjyHiEDtEx9ipbIqlzk
        YwBxFQ1lU3krVPCeR0F+md8=
X-Google-Smtp-Source: AKy350aGH0D5Qw4INkWCB9Pb7g48QIreDcTtXNQdOylJGbug5OsdeXP49SpqJlpvUKK+WPxMDdp5pg==
X-Received: by 2002:a05:6214:27e8:b0:5a9:2bc0:ea8b with SMTP id jt8-20020a05621427e800b005a92bc0ea8bmr53618877qvb.47.1680440488668;
        Sun, 02 Apr 2023 06:01:28 -0700 (PDT)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id lg9-20020a056214548900b005dd8b9345ecsm1915348qvb.132.2023.04.02.06.01.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Apr 2023 06:01:28 -0700 (PDT)
Message-ID: <355d4dad-c0a5-330f-5cee-37e87bacd449@gmail.com>
Date:   Sun, 2 Apr 2023 06:01:25 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH net-next 7/7] net: create a netdev notifier for DSA to
 reject PTP on DSA master
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
 <20230402123755.2592507-8-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230402123755.2592507-8-vladimir.oltean@nxp.com>
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
> The fact that PTP 2-step TX timestamping is broken on DSA switches if
> the master also timestamps the same packets is documented by commit
> f685e609a301 ("net: dsa: Deny PTP on master if switch supports it").
> We attempt to help the users avoid shooting themselves in the foot by
> making DSA reject the timestamping ioctls on an interface that is a DSA
> master, and the switch tree beneath it contains switches which are aware
> of PTP.
> 
> The only problem is that there isn't an established way of intercepting
> ndo_eth_ioctl calls, so DSA creates avoidable burden upon the network
> stack by creating a struct dsa_netdevice_ops with overlaid function
> pointers that are manually checked from the relevant call sites. There
> used to be 2 such dsa_netdevice_ops, but now, ndo_eth_ioctl is the only
> one left.
> 
> There is an ongoing effort to migrate driver-visible hardware timestamping
> control from the ndo_eth_ioctl() based API to a new ndo_hwtstamp_set()
> model, but DSA actively prevents that migration, since dsa_master_ioctl()
> is currently coded to manually call the master's legacy ndo_eth_ioctl(),
> and so, whenever a network device driver would be converted to the new
> API, DSA's restrictions would be circumvented, because any device could
> be used as a DSA master.
> 
> The established way for unrelated modules to react on a net device event
> is via netdevice notifiers. So we create a new notifier which gets
> called whenever there is an attempt to change hardware timestamping
> settings on a device.
> 
> Finally, there is another reason why a netdev notifier will be a good
> idea, besides strictly DSA, and this has to do with PHY timestamping.
> 
> With ndo_eth_ioctl(), all MAC drivers must manually call
> phy_has_hwtstamp() before deciding whether to act upon SIOCSHWTSTAMP,
> otherwise they must pass this ioctl to the PHY driver via
> phy_mii_ioctl().
> 
> With the new ndo_hwtstamp_set() API, it will be desirable to simply not
> make any calls into the MAC device driver when timestamping should be
> performed at the PHY level.
> 
> But there exist drivers, such as the lan966x switch, which need to
> install packet traps for PTP regardless of whether they are the layer
> that provides the hardware timestamps, or the PHY is. That would be
> impossible to support with the new API.
> 
> The proposal there, too, is to introduce a netdev notifier which acts as
> a better cue for switching drivers to add or remove PTP packet traps,
> than ndo_hwtstamp_set(). The one introduced here "almost" works there as
> well, except for the fact that packet traps should only be installed if
> the PHY driver succeeded to enable hardware timestamping, whereas here,
> we need to deny hardware timestamping on the DSA master before it
> actually gets enabled. This is why this notifier is called "PRE_", and
> the notifier that would get used for PHY timestamping and packet traps
> would be called NETDEV_CHANGE_HWTSTAMP. This isn't a new concept, for
> example NETDEV_CHANGEUPPER and NETDEV_PRECHANGEUPPER do the same thing.
> 
> In expectation of future netlink UAPI, we also pass a non-NULL extack
> pointer to the netdev notifier, and we make DSA populate it with an
> informative reason for the rejection. To avoid making it go to waste, we
> make the ioctl-based dev_set_hwtstamp() create a fake extack and print
> the message to the kernel log.
> 
> Link: https://lore.kernel.org/netdev/20230401191215.tvveoi3lkawgg6g4@skbuf/
> Link: https://lore.kernel.org/netdev/20230310164451.ls7bbs6pdzs4m6pw@skbuf/
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
