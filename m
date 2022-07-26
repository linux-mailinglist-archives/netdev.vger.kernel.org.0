Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13FDB581712
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 18:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238407AbiGZQOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 12:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiGZQOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 12:14:22 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47F9D1B7A2;
        Tue, 26 Jul 2022 09:14:21 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id p6-20020a17090a680600b001f2267a1c84so16055172pjj.5;
        Tue, 26 Jul 2022 09:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=sxCiejdgjbnQ0B+v/quEBzxm/zg0vtvLG15rrehYGJI=;
        b=dO5yzNA9aEQKlezrCaP4TamoeJGFnrgtWM2X/4LveXcYuEob68SkjWoEr3pEBodcGh
         qCOZR7YmRCr26N8xdFIFRup6nKX2xXGaxT5/8QjZr6Z+VD7bdun/P6Lx5sq/3ocV0eqT
         28+bgZ9j9RebPWZgggcMojOcfbUuIbq5qGn/AjJdMEn59smh+IoLFe77+jIGKsNKhgM2
         oFsPbHR5IIqvLPvSAiKRseQupFB5Ib4iqo3m8hDpAJV817FomqRBpj1zlej0a43T2sLR
         TcKfhCkgT6sUK5oiWSlBriAD5c4ctQteTplrpBwSLRkAu9FD4l1AFJxbJpgbDslI1DXA
         AiPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=sxCiejdgjbnQ0B+v/quEBzxm/zg0vtvLG15rrehYGJI=;
        b=eBfZ2nuGFKrD3o70g1aTPZJg7+ZClS7wINFvOTLzWhbrG0sx5asHc80ztpAPk5ae1c
         omPbeB9KOC+JFa6+7cKq7bYCHsoO5ghD1SdnsqRKAKt9g8+TdiY7XbXbzYzq/JLW1rOI
         hJeRfZronCP2sIuI8HXhCSV8ZygOWNrAS5tXz0DFeuIgv4FGcM6TegnTKbNxDUC5f3mh
         L8MnrlRXJCoAEMaXjiS16wxaLdEQ+Xcb2PKmWXD3FOzkU4SqadPg16u5ja7C5ROP8vt8
         zlWUWEjl3DgDOeOsa6BxTFnSruPl+gGCyA47FwLTtOxxpSYhRujLNNQxYBY3k2cBTKYX
         TBqQ==
X-Gm-Message-State: AJIora94YSzdQhhxZGz2Xg6t4Kwa+HA0V/AIICrvlZJHPSrDxVO+G7pG
        G9gwcu4SUl8OL3gwpY4WjqM=
X-Google-Smtp-Source: AGRyM1tJInDWTHoJjOTG3ZuXWWINSzfFPDtoTQveu+osVuZOIYAJU+djiBBXErYcWRRVPpj+pDd0qA==
X-Received: by 2002:a17:90a:6d64:b0:1f2:5981:325e with SMTP id z91-20020a17090a6d6400b001f25981325emr20326257pjj.109.1658852060680;
        Tue, 26 Jul 2022 09:14:20 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id bf17-20020a656d11000000b003fd4831e6fesm10355369pgb.70.2022.07.26.09.14.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jul 2022 09:14:20 -0700 (PDT)
Message-ID: <174b5e64-a250-e1b2-43b9-474b915ddc22@gmail.com>
Date:   Tue, 26 Jul 2022 09:14:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC net-next 0/2] net: dsa: bcm_sf2: Utilize PHYLINK for all
 ports
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20220725214942.97207-1-f.fainelli@gmail.com>
 <20220726112344.3ar7s7khiacqueus@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220726112344.3ar7s7khiacqueus@skbuf>
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

On 7/26/22 04:23, Vladimir Oltean wrote:
> Hi Florian,
> 
> On Mon, Jul 25, 2022 at 02:49:40PM -0700, Florian Fainelli wrote:
>> Hi all,
>>
>> Although this should work for all devices, since most DTBs on the
>> platforms where bcm_sf2 is use do not populate a 'fixed-link' property
>> for their CPU ports, but rely on the Ethernet controller DT node doing
>> that, we will not be registering a 'fixed-link' instance for CPU ports.
>>
>> This still works because the switch matches the configuration of the
>> Ethernet controller, but on BCM4908 where we want to force 2GBits/sec,
>> that I cannot test, not so sure.
>>
>> So as of now, this series does not produce register for register
>> compatile changes.
> 
> My understanding of this change set is that it stops overriding the link
> status of IMP ports from dsa_switch_ops :: setup (unconditionally) and
> it moves it to phylink_mac_link_up(). But the latter may not be called
> when you lack a fixed-link, and yet the IMP port(s) still work(s).
> 
> This begs the natural question, is overriding the link status ever needed?

It was until we started to unconditionally reset the switch using the "external" reset method as opposed to the "internal" reset method which turned out not to be functional:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=eee87e4377a4b86dc2eea0ade162b0dc33f40576

At any rate (no pun intended), 4908 will want a 2GBit/sec IMP port to be set-up and we have no way to do that other than by forcing that setting, either through the bcm_sf2_imp_setup() method or via a hack to the mac_link_up() callback. This is kind of orthogonal in the sense that there is no "official" support for speed 2000 mbits/sec anyway in the emulated SW PHY, PHYLINK or anywhere in between but if we want to fully transition over to PHYLINK to configure all ports, which is absolutely the goal, we will need to find a solution one way or another.

I would prefer if also we sort of "transferred" the 'fixed-link' parameters from the DSA Ethernet controller attached to the CPU port onto the PHYLINK instance of the CPU port in the switch as they ought to be strictly identical otherwise it just won't work. This would ensure that we continue to force the link and it would make me sleep better a night to know that the IMP port is operating strictly the same way it was. My script compares register values before/after for the registers that are static and this was flagged as a difference.
-- 
Florian
