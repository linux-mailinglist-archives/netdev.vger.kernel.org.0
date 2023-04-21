Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9676EAEAA
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 18:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbjDUQGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 12:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjDUQGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 12:06:19 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3C8D93EF
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 09:06:16 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1a6ebc66ca4so19212475ad.3
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 09:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mistywest-com.20221208.gappssmtp.com; s=20221208; t=1682093176; x=1684685176;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Urv6ppi6OXKWX3BOygLRy1tzCsyRuqeEH/So92ZznKo=;
        b=vme8Hsk5LAI6/xZ6VELL5mjFCgu+gBD4C+YMXF0a9lMQ0l+oeRUYhSTS5lOlviFEvH
         /2BnUQNLUso4ErzKMQm3P/Rc2iCrTKr5E9QRIM9wO4xPW7AbUcypB7SSN9xRq9U1I1lP
         7IRVFItOapPWcooiIywU1oqct9KlFtWcPNmcEytv8Z2mq8ydZR5qfISQJt6iCtT7yTtn
         azPwdLnR00my9voI0PmkH2Dn9mAZbvLKKPPytaGoPGgqIXWJUcdMvYJ90626oN3Vt2Bi
         9uB/8/vaqAHxW6N/J5mHXH3UpmUE3t1BUbYgw+hf6AuZCCRM5lIPEwkZNblQiyLeHBLH
         D5mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682093176; x=1684685176;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Urv6ppi6OXKWX3BOygLRy1tzCsyRuqeEH/So92ZznKo=;
        b=BGnmd4SiwC0IeNeSOWWvAmp5wQCyUZcdzmY+hbYI5TOmTjdelbY3KCns0F233z+1pM
         ggDTgiIAKu34BnpsWEMBpfDZHhpycOPucaM+XI372d8GmnhEMwUqt7Y6vwQmBYGJhCaB
         twYDSSR5u/pQMqW1h2OgahGLS2SE4cqzOE5kQWcq0tqD40X+oYL3f0fgpUJP3U1As8fT
         ZxkMCieVSabvOlkTDr1GlXwxKHTCx13LNdba/c4kVlLl51M7GBVryBVfTBw8312xYVPL
         OA57tOa1JeE3UMVhbfTPJ2ckfYD5xZE7NRhlxJslPVcGT6cblDo2pJvaQH7deIWW+U5v
         JKrg==
X-Gm-Message-State: AAQBX9fdMTw0VkoFM2vNuyeDJJan/TCavq9CeE/pbLXCkgpS4Rbqj07s
        lr8Dj1GV6XE3ZTj5z/w5s3Cvgw==
X-Google-Smtp-Source: AKy350YZpGIOByd9dQsc2416/Tu0nUV9xttNYQn9NoipXP9Ur4pgtdTvDhT/YK4NcjnXyQngi9ybzg==
X-Received: by 2002:a17:902:c405:b0:1a6:f5d5:b80a with SMTP id k5-20020a170902c40500b001a6f5d5b80amr7763585plk.38.1682093176196;
        Fri, 21 Apr 2023 09:06:16 -0700 (PDT)
Received: from [192.168.98.6] (remote.mistywest.io. [184.68.30.58])
        by smtp.gmail.com with ESMTPSA id jj12-20020a170903048c00b001a19f2f81a3sm2928196plb.175.2023.04.21.09.06.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Apr 2023 09:06:15 -0700 (PDT)
Message-ID: <02b26c6f-f056-cec6-daf1-5e7736363d4e@mistywest.com>
Date:   Fri, 21 Apr 2023 09:06:14 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
From:   Ron Eggler <ron.eggler@mistywest.com>
Subject: Re: issues to bring up two VSC8531 PHYs
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Russell King - ARM Linux <linux@armlinux.org.uk>
References: <5eb810d7-6765-4de5-4eb0-ad0972bf640d@mistywest.com>
 <bb62e044-034e-771e-e3a9-a4b274e3dec9@gmail.com>
 <46e4d167-5c96-41a0-8823-a6a97a9fa45f@lunn.ch>
 <ba56f0a4-b8af-a478-7c1d-e6532144b820@gmail.com>
 <59fc6f98-0f67-f4a3-23c9-cd589aaa6af8@mistywest.com>
 <b3776edd-e337-44a4-8196-a6a94b498991@lunn.ch>
Content-Language: en-US
In-Reply-To: <b3776edd-e337-44a4-8196-a6a94b498991@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew, Russel & list,

Please aplogize for the delay in follow up!

On 2023-04-13 1:27 p.m., Andrew Lunn wrote:
>> Anyways, I changed the patch specify "ethernet-phy-ieee802.3-c22" instead,
>> it seems c22 is just a fallback if it's not specified per phy.txt -
>> Documentation/devicetree/bindings/net/phy.txt - Linux source code (v4.14) -
>> Bootlin<https://elixir.bootlin.com/linux/v4.14/source/Documentation/devicetree/bindings/net/phy.txt>
> I would not trust 4.14 Documentation. That has been dead for a long
> long time. We generally request you report networking issues against
> the net-next tree, or the last -rcX kernel.

Yeah, got it and I should have probably looked at the docs for the 
kernel version we're using which is 5.10.83-cip1 which leads me to:

https://elixir.bootlin.com/linux/v5.10.83/source/Documentation/devicetree/bindings/net/ethernet-phy.yaml

it does list "ethernet-phy-ieee802.3-c22" as an option.

I'm still a bit puzzled though because the VSC8531 datasheet clearly 
indicates that it's got a clause 45 register space: 
https://ww1.microchip.com/downloads/en/DeviceDoc/VMDS-10514.pdf page 54.

>> I connected it with a patch cable to a laptop and fired up tcpdump on the
>> laptop.
>> I can see ARP requests going out (from the laptop) but VSC8531s are not
>> responding (tried both ports).
>> What else can I do from here, is it time to probe the RGMII signals on the
>> board?
> What phy-mode are you using. Generally rgmii-id is what you want, so
> that the PHY adds the RGMII delays.

Okay great, I've added the following patch to my build:

diff --git a/r9a07g044.dtsi.orig b/r9a07g044.dtsi
index 16ff035..727815c 100644
--- a/arch/arm64/boot/dts/renesas/r9a07g044.dtsi
+++ b/arch/arm64/boot/dts/renesas/r9a07g044.dtsi
@@ -951,7 +951,7 @@
                                     <GIC_SPI 85 IRQ_TYPE_LEVEL_HIGH>,
                                     <GIC_SPI 86 IRQ_TYPE_LEVEL_HIGH>;
                        interrupt-names = "mux", "fil", "arp_ns";
-                       phy-mode = "rgmii";
+                       phy-mode = "rgmii-id";
                        clocks = <&cpg CPG_MOD R9A07G044_ETH0_CLK_AXI>,
                                 <&cpg CPG_MOD R9A07G044_ETH0_CLK_CHI>,
                                 <&cpg CPG_CORE R9A07G044_CLK_HP>;
@@ -971,7 +971,7 @@
                                     <GIC_SPI 88 IRQ_TYPE_LEVEL_HIGH>,
                                     <GIC_SPI 89 IRQ_TYPE_LEVEL_HIGH>;
                        interrupt-names = "mux", "fil", "arp_ns";
-                       phy-mode = "rgmii";
+                       phy-mode = "rgmii-id";
                        clocks = <&cpg CPG_MOD R9A07G044_ETH1_CLK_AXI>,
                                 <&cpg CPG_MOD R9A07G044_ETH1_CLK_CHI>,
                                 <&cpg CPG_CORE R9A07G044_CLK_HP>;

> You can also try:
>
> ethtool --phy-statistics ethX

after appliaction of the above patch, ethtool tells me

# ethtool --phy-statistics eth0
PHY statistics:
      phy_receive_errors: 65535
     phy_idle_errors: 255

and this along with the frame counters in ifconfig looks like there are 
no frames going back and forth between the MPU and the PHY:


# ifconfig
eth0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500  metric 1
         inet 192.168.1.123  netmask 255.255.255.0  broadcast 192.168.1.255
         ether e4:19:2f:15:1f:c1  txqueuelen 1000  (Ethernet)
         RX packets 0  bytes 0 (0.0 B)
         RX errors 0  dropped 0  overruns 0  frame 0
         TX packets 0  bytes 0 (0.0 B)
         TX errors 0  dropped 0 overruns 0  carrier 20  collisions 0
         device interrupt 170

eth1: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500  metric 1
         inet 192.168.1.234  netmask 255.255.0.0  broadcast 192.168.255.255
         ether f6:c8:2f:5e:01:7c  txqueuelen 1000  (Ethernet)
         RX packets 0  bytes 0 (0.0 B)
         RX errors 0  dropped 0  overruns 0  frame 0
         TX packets 0  bytes 0 (0.0 B)
         TX errors 0  dropped 0 overruns 0  carrier 79  collisions 0
         device interrupt 173

/proc/interrupts reports a few interrupts on eth0 & eth1:

# cat /proc/interrupts
            CPU0       CPU1
  11:     117135      97562     GICv3  27 Level     arch_timer
  13:          0          0     GICv3 202 Level     10001200.timer
  20:          0          0     GICv3 209 Level     10001200.timer
  56:          0          0     GICv3 358 Level     10049c00.ssi
  60:          0          0     GICv3 362 Level     1004a000.ssi
  65:          0          0     GICv3 448 Level     1004b000.spi:rx
  66:          0          0     GICv3 449 Level     1004b000.spi:tx
  67:          0          0     GICv3 412 Level 1004b800.serial:rx err
  68:          26          0     GICv3 414 Level 1004b800.serial:rx full
  69:      3478          0     GICv3 415 Level 1004b800.serial:tx empty
  70:          0          0     GICv3 413 Level 1004b800.serial:break
  71:        230          0     GICv3 416 Level 1004b800.serial:rx ready
  73:          0          0     GICv3 458 Level     canfd.g_err
  74:          0          0     GICv3 459 Level     canfd.g_recc
  75:          0          0     GICv3 454 Level     canfd.ch0_err
  77:          0          0     GICv3 460 Level     canfd.ch0_trx
  78:          0          0     GICv3 455 Level     canfd.ch1_err
  80:          0          0     GICv3 461 Level     canfd.ch1_trx
  87:          0          0     GICv3 382 Level     riic-tend
  88:          0          0     GICv3 380 Edge      riic-rdrf
  89:          3          0     GICv3 381 Edge      riic-tdre
  90:          1          0     GICv3 384 Level     riic-stop
  92:          1          0     GICv3 383 Level     riic-nack
  95:          0          0     GICv3 390 Level     riic-tend
  96:          0          0     GICv3 388 Edge      riic-rdrf
  97:          2          0     GICv3 389 Edge      riic-tdre
  98:          1          0     GICv3 392 Level     riic-stop
100:          1          0     GICv3 391 Level     riic-nack
103:         17          0     GICv3 406 Level     riic-tend
104:          0          0     GICv3 404 Edge      riic-rdrf
105:         51          0     GICv3 405 Edge      riic-tdre
106:         17          0     GICv3 408 Level     riic-stop
108:          0          0     GICv3 407 Level     riic-nack
111:          0          0     GICv3 379 Edge      10059000.adc
113:          5          0     GICv3 476 Level     tint0
114:          1          0     GICv3 477 Level     tint1
115:          0          0     GICv3 478 Level     tint2
116:          0          0     GICv3 479 Level     tint3
117:          0          0     GICv3 480 Level     tint4
118:          0          0     GICv3 481 Level     tint5
119:          0          0     GICv3 482 Level     tint6
120:          0          0     GICv3 483 Level     tint7
121:          0          0     GICv3 484 Level     tint8
122:          0          0     GICv3 485 Level     tint9
123:          0          0     GICv3 486 Level     tint10
124:          0          0     GICv3 487 Level     tint11
125:          0          0     GICv3 488 Level     tint12
126:          0          0     GICv3 489 Level     tint13
127:          0          0     GICv3 490 Level     tint14
128:          0          0     GICv3 491 Level     tint15
129:          0          0     GICv3 492 Level     tint16
130:          0          0     GICv3 493 Level     tint17
131:          0          0     GICv3 494 Level     tint18
132:          0          0     GICv3 495 Level     tint19
133:          0          0     GICv3 496 Level     tint20
134:          0          0     GICv3 497 Level     tint21
135:          0          0     GICv3 498 Level     tint22
136:          0          0     GICv3 499 Level     tint23
137:          0          0     GICv3 500 Level     tint24
138:          0          0     GICv3 501 Level     tint25
139:          0          0     GICv3 502 Level     tint26
140:          0          0     GICv3 503 Level     tint27
141:          0          0     GICv3 504 Level     tint28
142:          0          0     GICv3 505 Level     tint29
143:          0          0     GICv3 506 Level     tint30
144:          0          0     GICv3 507 Level     tint31
145:          0          0     GICv3 173 Edge      error
146:          0          0     GICv3 157 Edge 11820000.dma-controller:0
147:          0          0     GICv3 158 Edge 11820000.dma-controller:1
148:          0          0     GICv3 159 Edge 11820000.dma-controller:2
149:          0          0     GICv3 160 Edge 11820000.dma-controller:3
150:          0          0     GICv3 161 Edge 11820000.dma-controller:4
151:          0          0     GICv3 162 Edge 11820000.dma-controller:5
152:          0          0     GICv3 163 Edge 11820000.dma-controller:6
153:          0          0     GICv3 164 Edge 11820000.dma-controller:7
154:          0          0     GICv3 165 Edge 11820000.dma-controller:8
155:          0          0     GICv3 166 Edge 11820000.dma-controller:9
156:          0          0     GICv3 167 Edge 11820000.dma-controller:10
157:          0          0     GICv3 168 Edge 11820000.dma-controller:11
158:          0          0     GICv3 169 Edge 11820000.dma-controller:12
159:          0          0     GICv3 170 Edge 11820000.dma-controller:13
160:          0          0     GICv3 171 Edge 11820000.dma-controller:14
161:          0          0     GICv3 172 Edge 11820000.dma-controller:15
162:          0          0     GICv3 186 Level     11840000.gpu
163:          0          0     GICv3 187 Level     11840000.gpu
164:          1          0     GICv3 185 Level     11840000.gpu
166:        790          0     GICv3 136 Level     11c00000.mmc
167:          0          0     GICv3 137 Level     11c00000.mmc
168:      27937          0     GICv3 138 Level     11c10000.mmc
169:          0          0     GICv3 139 Level     11c10000.mmc
170:         20          0     GICv3 116 Level     eth0
173:         79          0     GICv3 119 Level     eth1
176:          0          0     GICv3 123 Level     ohci_hcd:usb3
177:          0          0     GICv3 128 Level     ohci_hcd:usb4
178:          0          0     GICv3 124 Level     ehci_hcd:usb1
179:          0          0     GICv3 129 Level     ehci_hcd:usb2
180:          0          0     GICv3 126 Level 11c50200.usb-phy
181:          0          0     GICv3 131 Level 11c70200.usb-phy
182:          0          0     GICv3 132 Edge      11c60000.usb
186:          0          0     GICv3 302 Edge      10048400.gpt
187:          0          0     GICv3 303 Edge      10048400.gpt
194:          0          0     GICv3 310 Edge      10048400.gpt
199:          0          0     GICv3 181 Level     10870000.vsp
208:          0          0     GICv3  80 Edge      timer@12801800
209:          0          0     GICv3 199 Level     rzg2l_cru
211:          1          0  11030000.pin-controller   8 Edge 
11c20000.ethernet-ffffffff:00
212:          3          0  11030000.pin-controller   9 Edge 
11c30000.ethernet-ffffffff:00
IPI0:      1995       6562       Rescheduling interrupts
IPI1:        200         161       Function call interrupts
IPI2:         0          0       CPU stop interrupts
IPI3:         0          0       CPU stop (for crash dump) interrupts
IPI4:         0          0       Timer broadcast interrupts
IPI5:         0          0       IRQ work interrupts
IPI6:         0          0       CPU wake-up interrupts
Err:          0


-- 


*RON EGGLER*
Firmware Engineer
(he/him/his)
www.mistywest.com
MistyWest Logo
