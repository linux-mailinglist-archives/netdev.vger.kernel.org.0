Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABD65A4675
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 11:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbiH2JvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 05:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiH2JvU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 05:51:20 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F47258537
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 02:51:18 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id kk26so14546941ejc.11
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 02:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=SlYMUlG2qSvFZB0N2mq5+Vuwq77kZgSrLYVLPhtOEnc=;
        b=VA8mRlDIJuRpUjAr2wap2tw76G9iqQ95P1eKHRbi0MXQ+y5IRx86u42xLbqDa3N5Uw
         WBpv8t9zipWs3CctFwvBsrOIu5XtbCOP1buoXyRAK4MLU31Yw5ngEBFKEMkK8zVonfRa
         j0ONoFy8E5axclexgQI8Deix+KM6vUXYS29+vk/m2cgOGWRgF4irThnGgYZYmbUaOgFL
         UAiaDDzB1hu/DAZMMj9RMnoiMeWabPFTFH2n9WQhu3VNwHXDNrCWsZF6emYbnh58OVDq
         r+pUZaGHVx50qLZUXUjESZfGWi8gRrSNSOgOjZjybuBNJVt27lkMLyDAdhTM/SlwI1T9
         rD/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=SlYMUlG2qSvFZB0N2mq5+Vuwq77kZgSrLYVLPhtOEnc=;
        b=qaLGmlOYDYnrofySjGIQRCY2abU2YBJM+XN28hHHq+TzaaTtO4EcLY9T83Ow+ouVaB
         tpNqvivSO380ZpxEnJAlbuBiDXBBhyy5e62+Gt7NRBpL+M3Fx9vGmXlv3a7qimLOfE2R
         rbafHQ4gI70LtCMS5dO+3BCQARX81T8sSXbD15wULpkn5e4DjUWALS70/wFM4R7K3iyO
         Cmt3GVhcrefelAiG9qXzKYLxmplALEjUko1tY3FjTM5npS/IEmMWTGskdTyYyIGAUxar
         oDX7g2+Z45Ygcv0PCsFmYttpKqXfXTVKcJpAYk6p8XeO8QNSqyrIwOEWjErxggBjgjKm
         NZMw==
X-Gm-Message-State: ACgBeo3/4NWcSlU0rfmtl2+HKvp8I2bbakvyPzisIQzCno+bvSBzBXGH
        TbXcC8FD8PB93OhnlUwP1MhH4A==
X-Google-Smtp-Source: AA6agR7M8nHmvMXeLrqK9slD36AnzRPtNtaEGwJrWTLaeYi3Ldj3MRdNNKrrHzv2HbakO0uElrxasg==
X-Received: by 2002:a17:907:2d23:b0:730:acf0:4907 with SMTP id gs35-20020a1709072d2300b00730acf04907mr13239673ejc.700.1661766676786;
        Mon, 29 Aug 2022 02:51:16 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id z2-20020a170906240200b0073c23616cb1sm4374177eja.12.2022.08.29.02.51.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Aug 2022 02:51:16 -0700 (PDT)
Message-ID: <4749d6b6-c20c-fd20-f904-accee3f1947a@blackwall.org>
Date:   Mon, 29 Aug 2022 12:51:14 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v5 net-next 1/6] net: bridge: add locked entry fdb flag to
 extend locked port feature
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@kapio-technology.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, Shuah Khan <shuah@kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
References: <20220826114538.705433-1-netdev@kapio-technology.com>
 <20220826114538.705433-2-netdev@kapio-technology.com>
 <Ywo16vHMqxxszWzX@shredder>
 <dd9a4156fe421f6be3a49f5b928ef77e@kapio-technology.com>
 <YwxwPJOx/n5SHZM5@shredder>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <YwxwPJOx/n5SHZM5@shredder>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/08/2022 10:52, Ido Schimmel wrote:
> On Sun, Aug 28, 2022 at 12:23:30PM +0200, netdev@kapio-technology.com wrote:
>> On 2022-08-27 17:19, Ido Schimmel wrote:
>>> On Fri, Aug 26, 2022 at 01:45:33PM +0200, Hans Schultz wrote:
>>>>
>>>>  	nbp_switchdev_frame_mark(p, skb);
>>>> @@ -943,6 +946,10 @@ static int br_setport(struct net_bridge_port
>>>> *p, struct nlattr *tb[],
>>>>  	br_set_port_flag(p, tb, IFLA_BRPORT_NEIGH_SUPPRESS,
>>>> BR_NEIGH_SUPPRESS);
>>>>  	br_set_port_flag(p, tb, IFLA_BRPORT_ISOLATED, BR_ISOLATED);
>>>>  	br_set_port_flag(p, tb, IFLA_BRPORT_LOCKED, BR_PORT_LOCKED);
>>>> +	br_set_port_flag(p, tb, IFLA_BRPORT_MAB, BR_PORT_MAB);
>>>> +
>>>> +	if (!(p->flags & BR_PORT_LOCKED))
>>>> +		p->flags &= ~BR_PORT_MAB;
>>
>> The reason for this is that I wanted it to be so that if you have MAB
>> enabled (and locked of course) and unlock the port, it will automatically
>> clear both flags instead of having to first disable MAB and then unlock the
>> port.
> 
> User space can just do:
> 
> # bridge link set dev swp1 locked off mab off
> 
> I prefer not to push such logic into the kernel and instead fail
> explicitly. I won't argue if more people are in favor.

+1

I prefer to fail explicitly too, actually I also had a comment about this but
somehow have managed to delete it before sending my review. :)
