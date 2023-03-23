Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA3F6C6DBC
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 17:35:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231727AbjCWQfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 12:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbjCWQfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 12:35:38 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D094438E87;
        Thu, 23 Mar 2023 09:34:12 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id t19so13155729qta.12;
        Thu, 23 Mar 2023 09:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679589251;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ymDJDYJzs0i/isCCvz+nZjYckQ5h0Q/W69CkIWbYoQg=;
        b=hiGb2bGruQXMpAzeZV3fsezlqDScHym1Jsg7pvtvvOmrH2A2WrFLx2ljvX/etEABRX
         X00J6SQHFU/TBtMNQbKYg5EBtHIEoSFVeSGt6vd4igc6RW+hSTBa9k7BPGmJuS3QIJAZ
         DWJ39g5lrdzmt2cNylEVFDmb0l8cxgmIzfE798T8qHFgH/G6Zk1JL+LuWWMrcLXrFFen
         t7dv1co5LqcHpwan3zkZyrVB5grt3vbdsZnCV0KTibJ6UbTr33xDXpZL9Eq9WqMShiHV
         ry6TqRaJjMiH80IAn/ms2baOO7vba1cIeIm8nv5qC/t6Yv0kDTQ/wBuXl7BejuhlFW/8
         fagw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679589251;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ymDJDYJzs0i/isCCvz+nZjYckQ5h0Q/W69CkIWbYoQg=;
        b=qasIyf8mHBot/CxM3IA6Xfr3Mg0cvgoZ2OHh1OIs8Ic4N1gFkFY+WzAOhGtvKWm8uK
         aBcm3UnluqSYUqdFct2+Mor0p2rD2CXo3mvU8QYyRd4caoGG4szTbg5QwWfHGyrDBcNC
         odNp/IYl+7LQmJPELARlK3SB6u4yWPaCZHALtsP783uBswrCYubrNaRa2cTFU26wCixY
         dFoI92ZegQJCw6n4+NCTQtH7bGC4cv4Fzbf7p/ijUiC8OuoPGacX3EQD/owuuKtUVswk
         wNOzpCQRJHqS1CTS3ELvwmH7pSnVpjB3/It1+6SiroHsXghVt5ZYZdzRB/CvsPSUiqFL
         MpjA==
X-Gm-Message-State: AO0yUKUUV6x6Hf1dOlhsmYq8gkXf18wB53Z/0+u1NzwEGFlq4kCXedLU
        vDW+dZ3QAREaW71Bu+24Gws=
X-Google-Smtp-Source: AK7set9/1KHBdOD4impskBvEATZdqeWunhSKtK0Xpt+noJ8I6XEF7zvHUiLJbXEHkTX82eVB0u1utQ==
X-Received: by 2002:a05:622a:284:b0:3bf:d238:6ca with SMTP id z4-20020a05622a028400b003bfd23806camr10924314qtw.68.1679589251634;
        Thu, 23 Mar 2023 09:34:11 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b6-20020ac87546000000b003d29e23e214sm12007406qtr.82.2023.03.23.09.34.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Mar 2023 09:34:11 -0700 (PDT)
Message-ID: <1dab843b-268f-7c7c-6049-8f0f6d4c920a@gmail.com>
Date:   Thu, 23 Mar 2023 09:34:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next 9/9] net: dsa: tag_ocelot: call only the relevant
 portion of __skb_vlan_pop() on TX
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        linux-kernel@vger.kernel.org
References: <20230322233823.1806736-1-vladimir.oltean@nxp.com>
 <20230322233823.1806736-10-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230322233823.1806736-10-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/22/23 16:38, Vladimir Oltean wrote:
> ocelot_xmit_get_vlan_info() calls __skb_vlan_pop() as the most
> appropriate helper I could find which strips away a VLAN header.
> That's all I need it to do, but __skb_vlan_pop() has more logic, which
> will become incompatible with the future revert of commit 6d1ccff62780
> ("net: reset mac header in dev_start_xmit()").
> 
> Namely, it performs a sanity check on skb_mac_header(), which will stop
> being set after the above revert, so it will return an error instead of
> removing the VLAN tag.
> 
> ocelot_xmit_get_vlan_info() gets called in 2 circumstances:
> 
> (1) the port is under a VLAN-aware bridge and the bridge sends
>      VLAN-tagged packets
> 
> (2) the port is under a VLAN-aware bridge and somebody else (an 8021q
>      upper) sends VLAN-tagged packets (using a VID that isn't in the
>      bridge vlan tables)
> 
> In case (1), there is actually no bug to defend against, because
> br_dev_xmit() calls skb_reset_mac_header() and things continue to work.
> 
> However, in case (2), illustrated using the commands below, it can be
> seen that our intervention is needed, since __skb_vlan_pop() complains:
> 
> $ ip link add br0 type bridge vlan_filtering 1 && ip link set br0 up
> $ ip link set $eth master br0 && ip link set $eth up
> $ ip link add link $eth name $eth.100 type vlan id 100 && ip link set $eth.100 up
> $ ip addr add 192.168.100.1/24 dev $eth.100
> $ # needed to work around an apparent DSA RX filtering bug
> $ ip link set $eth promisc on
> 
> I could fend off the checks in __skb_vlan_pop() with some
> skb_mac_header_was_set() calls, but seeing how few callers of
> __skb_vlan_pop() there are from TX paths, that seems rather
> unproductive.
> 
> As an alternative solution, extract the bare minimum logic to strip a
> VLAN header, and move it to a new helper named vlan_remove_tag(), close
> to the definition of vlan_insert_tag(). Document it appropriately and
> make ocelot_xmit_get_vlan_info() call this smaller helper instead.
> 
> Seeing that it doesn't appear illegal to test skb->protocol in the TX
> path, I guess it would be a good for vlan_remove_tag() to also absorb
> the vlan_set_encap_proto() function call.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

