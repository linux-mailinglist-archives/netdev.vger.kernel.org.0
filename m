Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2D3E6365EC
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 17:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238213AbiKWQgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 11:36:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235641AbiKWQgN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 11:36:13 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7323327FFD
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 08:36:11 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id y24so20559209edi.10
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 08:36:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=apTM0Ik7CzGZyqk/XR+xwCnr7CnVDv1GyMumXtSC7/A=;
        b=ZJtMR5Zj4SlkE5c73UuuVITX6NJ0bUdyffNM+5ummHf31IWtHTxLSbvzkUi4yqNJr4
         xwrCW1qztCS9Tbc2MdTnY5w+X6MMrvO46p9r0mfCZhbvViW9xiYWhuuS/i6CW3K2z9Ek
         jhLnpRbJ/29dFCGgBEi5BlvN9dCsghuq+5NOPquF47yBLK5cQ38WkZCZh0L0Ehfj8ZC4
         zkL5lM6dDy3IJHaKc48TRE0C0kXWz0xDO/8W9QWXXV2od1TTQgRK+3dYYLem8cH6xy9g
         TYMI7WY8G3ABHsz1802C+pkWn82dpdAqiYpx6g0fNEv5QxUAzjNuzBmn+eG3Ni2cS4Yr
         BW/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=apTM0Ik7CzGZyqk/XR+xwCnr7CnVDv1GyMumXtSC7/A=;
        b=eOyrVYLxQmw58MldYBVbrwontA23BOiHwLxD4CdYtWNY5F4CzDkkCgEJPbAK5NMwZ5
         UOgMkK2j5FF19WuhLPvbcE2wLreLzEC8Jt4aywAJKJQWq4sUK9FDW0bSoYwFoIxg7fok
         gNk37JqWVv74pTNRSMA8papXhs34Jx2/N9uxqLsOPA0EdjEd1/0YapHShSHe+FcHSbSH
         hBiijFnqveqpZ7hf0Zesz1VTNxYI0YlwF99V1/n2G14LyBnlNVmfHg22TNvDnHEik3/5
         JlsBlslptS1X1aSJ1whWmlISak7wf+dMqkPduESBerbYDfMjZcBgLYpEnEOES8nt7Oqz
         qMvw==
X-Gm-Message-State: ANoB5pkuT15GrqiJqrPUHbqX7+9MibTGtgryAPSesrzDaiwUdg0YAJ+2
        xM3BPW4wi9z8uY4qlh+6iFyGdQ==
X-Google-Smtp-Source: AA0mqf5VTeQWZeYCmrGFhB5H+h+AUt/iPaoS2srO6ODp1gp2UVg0Fxi83jsL9zuXdWNfWA0VK6SLlQ==
X-Received: by 2002:a05:6402:4311:b0:458:c66a:3664 with SMTP id m17-20020a056402431100b00458c66a3664mr12426629edc.79.1669221369681;
        Wed, 23 Nov 2022 08:36:09 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id kw10-20020a170907770a00b0078d4ee47c82sm7368179ejc.129.2022.11.23.08.36.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 08:36:08 -0800 (PST)
Date:   Wed, 23 Nov 2022 17:36:07 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Steve Williams <steve.williams@getcruise.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        vinicius.gomes@intel.com, xiaoliang.yang_1@nxp.com,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [EXT] Re: [PATCH net-next] net/hanic: Add the hanic network
 interface for high availability links
Message-ID: <Y35L9ykSI37snvSw@nanopsycho>
References: <20221118232639.13743-1-steve.williams@getcruise.com>
 <20221121195810.3f32d4fd@kernel.org>
 <20221122113412.dg4diiu5ngmulih2@skbuf>
 <CALHoRjcw8Du+4Px__x=vfDfjKnHVRnMmAhBBEznQ2CfHPZ9S0A@mail.gmail.com>
 <20221123142558.akqff2gtvzrqtite@skbuf>
 <Y34zoflZsC2pn9RO@nanopsycho>
 <20221123152543.ekc5t7gp2hpmaaze@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123152543.ekc5t7gp2hpmaaze@skbuf>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Nov 23, 2022 at 04:25:43PM CET, vladimir.oltean@nxp.com wrote:
>On Wed, Nov 23, 2022 at 03:52:17PM +0100, Jiri Pirko wrote:
>> >Reworded, why must the hanic functionality to be in the kernel?
>> 
>> I guess for the same reason other soft netdevice driver are in the
>> kernel. You can do bridge, bond, etc in a silimilar way you described
>> here...
>
>You have to consider the value added to the kernel in each case
>(and also what were the best practices when those other drivers were
>introduced; you can't just use bonding as a precedent for anything).
>
>I believe hanic does not even attempt to solve a generic enough problem
>to be the FRER endpoint driver for the Linux kernel. It assumes streams
>will be {MAC SA, VID} on RX, and {MAC DA, VID} on TX. That's already
>policy enforced by the kernel, when the kernel should just provide the
>mechanisms for user space to enforce one. This type of stream
>classification will not be the case for 802.1CB networks in general.
>According to some of my own research, you can also solve some of the
>problems Steve is addressing in other ways.
>
>For example, in order to make {MAC DA, VLAN} streams identify both the
>sender and the receiver, one can arrange that in a network, each sender
>has its own VLAN ID which identifies it as a sender. I know of at least
>one network where this is the case. But this would also be considered
>policy, and I'm not suggesting that hanic should use this approach
>rather than the other. 802.1CB simply does not recommend one mode of
>arranging streams over another.
>
>The fact that hanic needs 802.1Q uppers as termination points for
>{MAC, VLAN} addresses seemst to simply not scale for IP-based streams,
>or generic byte@offset pattern matching based streams.

Vlan implementation could be easily done internally in hanic driver if
needed, similar to bridge and openvswitch vlan implementations.


>
>Additionally, the hanic driver will probably need a rewrite when Steve
>enables some options like CONFIG_PROVE_LOCKING or CONFIG_DEBUG_ATOMIC_SLEEP.

Well, there are lots of other issues in the driver as it is right now.
I don't think it is worth to discuss it now.


>It currently creates sysfs files for streams from the NET_TX softirq.
>It's not even clear to me that stream auto-discovery is something
>desirable generally. I'd rather pre-program my termination streams if
>I know what I'm doing, rather than let the kernel blindly trust possibly
>maliciously crafted 802.1CB tags.
>
>When I suggested a tap based solution, I was trying to take the Cruise

tap is slow. That is I guess the reason for kernel implementation.


>hanic driver, as presented, at face value and to propose something which
>seems like a better fit for it. I wasn't necessarily trying to transform
>the hanic driver into something useful in general for the kernel, since
>I don't know if that's what Steve's goal is.

Or, you can always implement this as a BPF program :)
