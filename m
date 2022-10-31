Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02E5561395C
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 15:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231597AbiJaOwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 10:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbiJaOwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 10:52:14 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1468EF031;
        Mon, 31 Oct 2022 07:52:13 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id j16so19585642lfe.12;
        Mon, 31 Oct 2022 07:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:organization:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oH27PpRVly2aDi6mWVUu1iZzX7AjDHjdV/xRXWcUScI=;
        b=ctvo4DKxAbXV/KTNGn+iwVP+OC0g4v2kHAQyQf93uGuk5RRgMb1wgxPZ5odJoysMhF
         NOD4IDKBiCfTiLFfLorjSvWP50R0jO4x+Hwn4vdcQYKJO5SkjFX1jiXhs7rBTwOeC+Y+
         SQDhxOJb+8nBC5DuBtF6XndlfSc5wTd6pAOO8sfOjqxhMTluI8XgGzu5N+niu0ZyfCXl
         ruWYZKPN8paZEMHNQXgs7FXnfPoWzqqn8FUc+djdDuYSc6jqoxwbfiTwYopWS5Mcmk2+
         gwozRyY5oWg54BVGqujPnKa501XVqmCpqqBgD/32E90hP/Bj7gUiBTK4tNA+L5ooevpR
         Kxng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:organization:message-id:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oH27PpRVly2aDi6mWVUu1iZzX7AjDHjdV/xRXWcUScI=;
        b=KAHgXG3MmAB6uXCYxGDqaqLNRle2nEMu7eRns0ivM8W82YOlvORIXhtedxgubnykKI
         +poPxryrt5bfAZ2yCj6xCrnx9GbHbck6aO2ulw7hbmFyrHyx3f7CZeb5aUSVU61JhOhd
         EAOdUXvBEYE2e/Cjgzwn8KmdpYXm4QsfY+WPnVUPVrSVVOZEF4ClUr/oHOhbDnuhZbD2
         gWQQA7g+qnUZ2zdzXQJGWMAcTwlMAFtSTXAed4hqBE+B6Aw9lfLzn1gd6IT4aEW8oc8P
         5aSOIBEI1yts2M8b3UdoRKMTxpMh7yyP0Iz8KEf51QlowJsjKdbHDn3RwmS3DYiq6HZK
         0A4g==
X-Gm-Message-State: ACrzQf0ckXOmNXrVCtHBW4kUME8cs/8yNzZgkeVH2mEwMZUp55rQ84bs
        r4rQCyYUuzqGsXlnJINMRi8=
X-Google-Smtp-Source: AMsMyM4OUE1cZ1JU4u1gLmDhijrjBmQr0FfYuzZGFn+2eRqx/R05QoLoU9cTiWA7pOZ0bGyZTq3i6w==
X-Received: by 2002:ac2:5dd5:0:b0:4a2:2960:a855 with SMTP id x21-20020ac25dd5000000b004a22960a855mr5796412lfq.399.1667227931190;
        Mon, 31 Oct 2022 07:52:11 -0700 (PDT)
Received: from wse-c0155 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id 7-20020ac25f07000000b0048ad4c718f3sm1318126lfq.30.2022.10.31.07.52.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 07:52:10 -0700 (PDT)
Date:   Mon, 31 Oct 2022 15:52:09 +0100
From:   Casper Andersson <casper.casan@gmail.com>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, UNGLinuxDriver@microchip.com,
        Randy Dunlap <rdunlap@infradead.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        Nathan Huckleberry <nhuck@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Daniel Machon <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Subject: Re: [PATCH net-next v2 2/5] net: microchip: sparx5: Adding more tc
 flower keys for the IS2 VCAP
Message-ID: <20221031145209.hqebvyfqdsrzhiuh@wse-c0155>
Organization: Westermo Network Technologies AB
References: <20221028144540.3344995-1-steen.hegelund@microchip.com>
 <20221028144540.3344995-3-steen.hegelund@microchip.com>
 <20221031103747.uk76tudphqdo6uto@wse-c0155>
 <51622bfd3fe718139cece38493946c2860ebdf77.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51622bfd3fe718139cece38493946c2860ebdf77.camel@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Steen,

On 2022-10-31 13:14, Steen Hegelund wrote:
> Hi Casper,
> 
> First of all thanks for the testing effort (as usual).  This is most welcome.
> 
> On Mon, 2022-10-31 at 11:44 +0100, Casper Andersson wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> > 
> > Hi Steen,
> > 
> > On 2022-10-28 16:45, Steen Hegelund wrote:
> > > - IPv4 Addresses
> > >     tc filter add dev eth12 ingress chain 8000000 prio 12 handle 12 \
> > >         protocol ip flower skip_sw dst_ip 1.0.1.1 src_ip 2.0.2.2    \
> > >         action trap
> > 
> > I'm not able to get this working on PCB135. I tested the VLAN tags and
> > did not work either (did not test the rest). The example from the
> > previous patch series doesn't work either after applying this series.
> 
> 
> Yes I did not really explain this part (and I will update the series with an explanation).
> 
> 1) The rule example in the previous series will no longer work as expected as the changes to the
> port keyset configuration now requires a non-ip frame to generate the MAC_ETYPE keyset.
> 
> So to test the MAC_ETYPE case your rule must be non-ip and not use "protocol all" which is not
> supported yet.  
> 
> Here is an example using the "protocol 0xbeef":
> 
> tc qdisc add dev eth3 clsact
> tc filter add dev eth3 ingress chain 8000000 prio 10 handle 10 \
>         protocol 0xbeef flower skip_sw \
>         dst_mac 0a:0b:0c:0d:0e:0f \
>         src_mac 2:0:0:0:0:1 \
>         action trap
> 
> And send a frame like this (using EasyFrame):
> 
> ef tx eth_fiber1 rep 10 eth dmac 0a:0b:0c:0d:0e:0f smac 2::1 et 0xbeef data repeat 50 0x61

Thanks, this works. I saw now that you even mentioned that "protocol
all" doesn't work at the very end of this commit message.

> I am not sure what went wrong when you tested the ipv4 rule, but if I create the rule that you
> quoted above the rule is activated when I send frames like this:
> 
> ef tx eth_fiber1 rep 10 eth dmac 0a:0b:0c:0d:0e:0f smac 2::2 ipv4 dip 1.0.1.1 sip 2.0.2.2  data
> repeat 50 0x61 

Looks like adding the "data" at the end of it makes a difference when
creating the packets. Without it the ip.proto field becomes 17 (UDP).
With "data" it becomes 0 (IPv6 Hop-by-Hop Option). Ef will defaults to
17 if no data is specified, otherwise it ends up 0. And the reason
UDP doesn't get trapped I assume is because this rule falls under the
IPV4_OTHER keyset (as opposed to IPV4_TCP_UDP).

Doing just this was enough:
ef tx eth0 rep 10 eth dmac 0a:0b:0c:0d:0e:0f smac 2::2 ipv4 dip 1.0.1.1 sip 2.0.2.2 data

This also solved it for VLANs. I have successfully tested ipv4, ipv6,
protocol info (ICMP), and vlan tag info from the examples you provided.

Tested on Microchip PCB135 switch.

Tested-by: Casper Andersson <casper.casan@gmail.com>

BR,
Casper

> 
> Note that the smac is changed to avoid hitting the first rule.
> 
> 2) As for the VLAN based rules, the VLAN information used by IS2 is the classified VID and PCP, so
> you need to create a bridge and add the VID to the bridge and the ports to see this in action.
> 
> IS0 uses the VLAN tags in the frames directly: this is one of the differences between IS0 and IS2.
> 
> This is how I set up a bridge on my PCB134 when I do the testing:
> 
> ip link add name br5 type bridge
> ip link set dev br5 up
> ip link set eth12 master br5
> ip link set eth13 master br5
> ip link set eth14 master br5
> ip link set eth15 master br5
> sysctl -w net.ipv6.conf.eth12.disable_ipv6=1
> sysctl -w net.ipv6.conf.eth13.disable_ipv6=1
> sysctl -w net.ipv6.conf.eth14.disable_ipv6=1
> sysctl -w net.ipv6.conf.eth15.disable_ipv6=1
> sysctl -w net.ipv6.conf.br5.disable_ipv6=1
> ip link set dev br5 type bridge vlan_filtering 1
> bridge vlan add dev eth12 vid 600
> bridge vlan add dev eth13 vid 600
> bridge vlan add dev eth14 vid 600
> bridge vlan add dev eth15 vid 600
> bridge vlan add dev br5 vid 600 self
> 
> This should now allow you to use the classified VLAN information in IS2 on these four ports.
> 
> > 
> > This example was provided in your last patch series and worked earlier.
> > 
> > My setup is PC-eth0 -> PCB135-eth3 and I use the following EasyFrames
> > command to send packets:
> > 
> > ef tx eth0 rep 50 eth smac 02:00:00:00:00:01 dmac 0a:0b:0c:0d:0e:0f
> > 
> > IPv4:
> > tc qdisc add dev eth3 clsact
> > tc filter add dev eth3 ingress chain 8000000 prio 12 handle 12 \
> >     protocol ip flower skip_sw dst_ip 1.0.1.1 src_ip 2.0.2.2    \
> >     action trap
> > 
> > ef tx eth0 rep 50 eth smac 02:00:00:00:00:01 dmac 0a:0b:0c:0d:0e:0f ipv4 dip 1.0.1.1 sip 2.0.2.2
> > 
> > Same setup as above and I can't get this to work either.
> 
> Maybe you are hitting the first rule here, so changing the smac to avoid that, should help.
> 
> > 
> > I'm using tcpdump to watch the interface to see if the packets are being
> > trapped or not. Changing the packets' dmac to broadcast lets me see the
> > packets so I don't have any issue with the setup.
> > 
> > BR,
> > Casper
> > 
> 
> Best Regards
> Steen

BR,
Casper
