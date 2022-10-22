Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88383608CD4
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 13:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbiJVLkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 07:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbiJVLj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 07:39:59 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC931C2;
        Sat, 22 Oct 2022 04:32:44 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id t16so14890655edd.2;
        Sat, 22 Oct 2022 04:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FNcxlcjmRlhNk+bv6B7cAEGwdM5R0LeaFhjoH03CG4E=;
        b=V9pZGPntNZAfrt4tMjcaBvXFuvvPLtmeJTcdaWDR7LnKHyBKe+xcoKmr9zwywSRmL2
         rDnJ/X3kqlYKBPsPVcK0RUBTFKGgoWRJyq1A1S847kwjwcR657PUZiIaZRRYB5CIVp5v
         Hh2av0UR0oVek9j3FPR/CLfnU1mxF+vPLWccqkzVntDy4MKHodTfdcyFbQrTjdNKQ5ak
         pQO/ToUnoRapcVvJ2ZaCb759vqW+gPUneB6/UAyC4hls31hnD48Ilxq1V584B1G5y0Ka
         08AnrQXLvIhyZ4ingsiHj+lHef6L4OPiMoAzZno/Jjwl6kQEJCAITgI8+BL8UlDBktb9
         ALjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FNcxlcjmRlhNk+bv6B7cAEGwdM5R0LeaFhjoH03CG4E=;
        b=CWx9yN3HEQDt0CqBERvq/bE6nt/+eFFeNYzqyisLXhzQYtz16ms4EHcy0ad1Byohp4
         HjqAu5m9Spyl1Wu6rC2tTFreTbpQqY5Y8puqLTCSz9RbpDbRoyUBEVJ0vd/7vtruxRoU
         vE/dbv9R4CGB/imuNh+uH0MIrCjfMVVQemsusljEpJdJi3gjWtqgAM59nakm3lzfXFXt
         sdNXl0moP/8YMkEbA3prynuLYERJxXmlZnFOeG17zmQSKa5Io3LI9Ro+ayLOivSpoStX
         YYHKN1yO7OFY2BqnrBOwwOH2zLshKaOfsP28LPbMNbkIMSrEcLXzRwtrg5Swt5FAeP1G
         u3YA==
X-Gm-Message-State: ACrzQf1IVn5UUl3Ejg2r3Tl14vpNdPE6xeuQeC/3jL7DBnVqeF81v44r
        xEBplNMmMxhiHAjUF2Vh+M8=
X-Google-Smtp-Source: AMsMyM7gsD7G5B+ulzHBeDwhpF+5tFa+eEHmDw3n38Q+gnTfGu7G78wB84BnPaUM3/ZANesdFCHtkg==
X-Received: by 2002:a05:6402:34d0:b0:460:96c4:94af with SMTP id w16-20020a05640234d000b0046096c494afmr12126869edc.365.1666438362909;
        Sat, 22 Oct 2022 04:32:42 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id t5-20020a056402524500b0045726e8a22bsm15277836edd.46.2022.10.22.04.32.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Oct 2022 04:32:42 -0700 (PDT)
Date:   Sat, 22 Oct 2022 14:32:38 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Cc:     "netdev@kapio-technology.com" <netdev@kapio-technology.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Hans Schultz <schultz.hans@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>,
        Amit Cohen <amcohen@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH v8 net-next 10/12] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
Message-ID: <20221022113238.beo5zhufl2x645lf@skbuf>
References: <20221020225719.l5iw6vndmm7gvjo3@skbuf>
 <82d23b100b8d2c9e4647b8a134d5cbbf@kapio-technology.com>
 <20221021112216.6bw6sjrieh2znlti@skbuf>
 <7bfaae46b1913fe81654a4cd257d98b1@kapio-technology.com>
 <20221021163005.xljk2j3fkikr6uge@skbuf>
 <d1fb07de4b55d64f98425fe66156c4e4@kapio-technology.com>
 <20221021173014.oit3qmpkrsjwzbgu@skbuf>
 <b88e331e016ad3801f1bf1a0dec507f3@kapio-technology.com>
 <20221021181411.sv52q4yxr5r7urab@skbuf>
 <GV1P190MB2019CFA0EB9B5E717F39B621E42C9@GV1P190MB2019.EURP190.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <GV1P190MB2019CFA0EB9B5E717F39B621E42C9@GV1P190MB2019.EURP190.PROD.OUTLOOK.COM>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Oleksandr,

On Sat, Oct 22, 2022 at 08:50:20AM +0000, Oleksandr Mazur wrote:
> >The essence of my proposal was to send a bug fix now which denies
> >BR_LEARNING to be set together with BR_PORT_LOCKED. The fact that
> >link-local traffic is learned by the software bridge is something
> >unintended as far as I understand.
> 
> >You tried to fix it here, and as far as I could search in my inbox, that
> >didn't go anywhere:
> >https://lore.kernel.org/netdev/47d8d747-54ef-df52-3b9c-acb9a77fa14a@blackwall.org/T/#u
> 
> >I thought only mv88e6xxx offloads BR_PORT_LOCKED, but now, after
> >searching, I also see prestera has support for it, so let me add
> >Oleksandr Mazur to the discussion as well. I wonder how they deal with
> >this? Has somebody come to rely on learning being enabled on a locked
> >port?
> 
> Hello,
> 
> >The fact that
> >link-local traffic is learned by the software bridge is something
> >unintended as far as I understand.
> 
> In prestera driver, if port is in blocked state only the PAE frames
> can be trapped, so i'm not sure where other traffic might come from
> that you are talking. Or maybe i didn't get the issue here right,
> sorry?

I hope the following script will exemplify what I mean.

#!/bin/bash

ip netns add ns0
ip -n ns0 link add br0 type bridge
ip -n ns0 link add veth0 type veth peer name veth1
ip -n ns0 link set veth1 master br0
ip -n ns0 link set veth1 type bridge_slave locked on learning on
ip -n ns0 link set veth0 up
ip -n ns0 link set veth1 up
ip -n ns0 link set br0 up
addr=$(ip -j -n ns0 link show dev veth0 | jq -r '.[]["address"]')
ip netns exec ns0 mausezahn veth0 -q -c 1 -p 64 -b 01:80:c2:00:00:0e -t ip
sleep 1
ip netns exec ns0 bridge fdb show dev veth1 master | grep ${addr}
ip netns del ns0

It will print:

6e:71:0a:8d:85:9e master br0

or in other words, the brport veth1 has learned the MAC SA of veth0 as a
dynamic FDB entry even with no user space daemon to handle the
authentication protocol.

In turn, having this MAC SA present in the bridge FDB means that
communication with this station is now allowed. As far as I can tell,
this is *not* intended. Only the authentication protocol should create
the FDB entry.

Compare this with the same script, but with "locked on learning off".
No FDB entry will be printed.

> 
> Also, basically, prestera driver does not rely on the learning flag if
> the port's flag BR_PORT_LOCKED is set. What this means, is that we
> discard any learning changes on the port if LOCKED is still set (done
> inside firmware, if i recall correctly). E.g. learning is always off,
> if port is in BR_PORT_LOCKED state, or in a block state but also has a
> static fdb entry (aka mac-auth entry).

So I take this as meaning that we could deny BR_LEARNING on ports with
BR_PORT_LOCKED set, and prestera wouldn't be adversely affected. Ok.

> The concept we follow is basically:
>   - some userspace daemon blocks the port;
>   - speaks with the <auth-center> (PAE traffic);
>   - the daemon itself populates the FDB with authenticated MACs (adding static FDB MACs);
>   - forces learning flag disable, disables the PORT_LOCKED flag. At
>   this point switch can basically receive only the traffic from
>   authorized addresses (fdb still has static entries; learning
>   disabled).

I don't understand the last step. Why is the BR_PORT_LOCKED flag disabled?
If disabled, the port will receive frames with any unknown MAC SA,
not just the authorized ones.
