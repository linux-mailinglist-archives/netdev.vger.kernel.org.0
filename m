Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8838E347BB7
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 16:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236449AbhCXPIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 11:08:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236510AbhCXPIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 11:08:10 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A237C061763
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 08:08:10 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id l4so33436127ejc.10
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 08:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7cQCHQSN42V0b65rcmjVJgqxBIgamQdqoJ6gw7JVJmA=;
        b=jFc5tEN3PtRiJm65g9ki1M4oJ09vsxuvqBcqz/TQqnvmcKzDLglCJ57WV0xF1qPm13
         IfbHL27bGG38zgAO/BC8KlM5ogdBoa8sFlnxVOfDm/qKFpC3gHGvufNr6ehOaqLPC/HI
         sHBDNqBySJOPrrjZCaDXwyUKLzJ1unarTgKRlTPJw6UeYVZsT+HCD7akiP32QlSRRGvj
         zIabWxmKV7+g1mLDSQezTeXPJ1PGGRMo8mwr5MKU83kSCdkQP8MQR0ZtfsqgpreF4Z1c
         9Q55U6ToIkX3pQdhAVG7HGwIRzzsBT7G/RPgcTWkUxuu3s9/1xouzzVJU+g19csWE50a
         mRfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7cQCHQSN42V0b65rcmjVJgqxBIgamQdqoJ6gw7JVJmA=;
        b=JWv8WgZi3MGWUcnYBQQn0dAcCXDeUisMBf8QwO6bui8KK3dMRtjHCy56VlDTN7js8q
         Sr1ZjIXeYNzQm4+OKX86MzunzB3c8p+7CzuAnZcujHaRwZ+LbGhBEyloJty5ywNCcsFz
         pmbYAm4NImIk4QLtqbjUiHNT/5IFf3Fvnb1DwMN9XKT+5lxv2qEZ1/PnCBbLIiMGBuSQ
         YdnOQk0VN3P9v+MHq5Rq27egnbrhq3Qs4k0Dgbiy0YdzbSwiE4iBNtoHADWXQKCvDiNz
         Z0VWjtpuRKvUuy/X5sSBLUkoHbK7TdW++0hXGVZOA6cDqDfsZ4og9PeCrb8ee1vtLqNx
         JjJg==
X-Gm-Message-State: AOAM5323QUIqR9O1orodi8DU6Ml9yNeG4K7G18WEaPPHpZOXlxOjVRsn
        GO5zNNM/rwSIzHyoDq7FNMY=
X-Google-Smtp-Source: ABdhPJzBc8kc28GQqqJRmVP2tgUg2i2WIodI61ilIX1B/Z8wW5nRrkvc6toaB+kkMC8zfWwMnmwpRA==
X-Received: by 2002:a17:907:20c7:: with SMTP id qq7mr4052837ejb.528.1616598488740;
        Wed, 24 Mar 2021 08:08:08 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id gr16sm1060573ejb.44.2021.03.24.08.08.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 08:08:08 -0700 (PDT)
Date:   Wed, 24 Mar 2021 17:08:07 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Allow dynamic
 reconfiguration of tag protocol
Message-ID: <20210324150807.f2amekt2jdcvqhhl@skbuf>
References: <20210323102326.3677940-1-tobias@waldekranz.com>
 <20210323113522.coidmitlt6e44jjq@skbuf>
 <87blbalycs.fsf@waldekranz.com>
 <20210323190302.2v7ianeuwylxdqjl@skbuf>
 <8735wlmuxh.fsf@waldekranz.com>
 <20210324140317.amzmmngh5lwkcfm4@skbuf>
 <87pmzolhlv.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pmzolhlv.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 04:02:52PM +0100, Tobias Waldekranz wrote:
> On Wed, Mar 24, 2021 at 16:03, Vladimir Oltean <olteanv@gmail.com> wrote:
> > On Tue, Mar 23, 2021 at 10:17:30PM +0100, Tobias Waldekranz wrote:
> >> > I don't see any place in the network stack that recalculates the FCS if
> >> > NETIF_F_RXALL is set. Additionally, without NETIF_F_RXFCS, I don't even
> >> > know how could the stack even tell a packet with bad FCS apart from one
> >> > with good FCS. If NETIF_F_RXALL is set, then once a packet is received,
> >> > it's taken for granted as good.
> >> 
> >> Right, but there is a difference between a user explicitly enabling it
> >> on a device and us enabling it because we need it internally in the
> >> kernel.
> >> 
> >> In the first scenario, the user can hardly complain as they have
> >> explicitly requested to see all packets on that device. That would not
> >> be true in the second one because there would be no way for the user to
> >> turn it off. It feels like you would end up in a similar situation as
> >> with the user- vs. kernel- promiscuous setting.
> >> 
> >> It seems to me if we enable it, we are responsible for not letting crap
> >> through to the port netdevs.
> >
> > I think there exists an intermediate approach between processing the
> > frames on the RX queue and installing a soft parser.
> >
> > The BMI of FMan RX ports has a configurable pipeline through Next
> > Invoked Actions (NIA). Through the FMBM_RFNE register (Rx Frame Next
> > Engine), it is possible to change the Next Invoked Action from the
> > default value (which is the hardware parser). You can choose to make the
> > Buffer Manager Interface enqueue the packet directly to the Queue
> > Manager Interface (QMI). This will effectively bypass the hardware
> > parser, so DSA frames will never be sent to the error queue if they have
> > an invalid EtherType/Length field.
> >
> > Additionally, frames with a bad FCS should still be discarded, as that
> > is done by the MAC (an earlier stage compared to the BMI).
> 
> Yeah this sounds like the perfect middle ground. I guess that would then
> be activated with an `if (netdev_uses_dsa(dev))`-guard in the driver,
> like how Florian solved it for stmmac? Since it is not quite "rx-all".

I think this would have to be guarded by netdev_uses_dsa for now, yes.
Also, it is far from being a "perfect" middle ground, because if you
disable the hardware parser, you also lose the ability to do frame
classification and hashing/flow steering to multiple RX queues on that
port, I think.
