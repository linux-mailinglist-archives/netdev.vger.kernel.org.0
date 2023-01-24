Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E297D6791D4
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 08:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233507AbjAXHVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 02:21:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232292AbjAXHVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 02:21:36 -0500
Received: from mail.kernel-space.org (unknown [IPv6:2a01:4f8:c2c:5a84::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79FEF7ED6
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 23:21:34 -0800 (PST)
Received: from ziongate (localhost [127.0.0.1])
        by ziongate (OpenSMTPD) with ESMTP id 7d2c4a42;
        Tue, 24 Jan 2023 07:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=simple; d=kernel-space.org; h=date
        :from:to:cc:subject:in-reply-to:message-id:references
        :mime-version:content-type; s=default; bh=n1mrFF5boJa9LXclESa3yU
        lDISU=; b=b3JkWw9KAI/GYeZWtcqOXeGazi9nO/C6jXQiPNwX9E7tpPm8iePO/Q
        8V1hiPuJ+ctwyZ55LWulxFnhy6Lk30MC/W397dECS7X8I4JmnYR2MU0kwjFZGDap
        pQL1hnjDuBLXdpc4kqkCkxHw3TQVWwE5tsx+GEw5y0VqVmeoFR4Bs=
DomainKey-Signature: a=rsa-sha1; c=simple; d=kernel-space.org; h=date
        :from:to:cc:subject:in-reply-to:message-id:references
        :mime-version:content-type; q=dns; s=default; b=jFeAVcL2pbqSHR/u
        135PxSt1ymoeMVMSrfDyDVjpTLflc0G/Fdumk/q2imCwH/m7EoG3WNQYXS5F/3X7
        Kp7c+xNlh0HEZqAMahzT0egsJsIIrRImPTWTNfW8+jdOxJcdRnFbnRAjHMnmDWbp
        CRgbf3m0gi56hqxcWnNOqGhPgFU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel-space.org;
        s=20190913; t=1674544892;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=136kEHAgDtAFAV0yMJTc9edJCMLD/L+54SBBKW+AW20=;
        b=VCBUVnEko5PZ2BXMdt1D4tHfmbAPkrA68EVhfZrMEJiayJZJYoGi/uoT7kpBy5uGjCKijC
        umBGQw+8yzPPUK2TSZ0bLQx+nsO7EoKOy4uziO3GMu6scZ2njQfYrR2VoFbzrAAp7BxMKw
        NB2qBGPF6ZHUQVX/nQBiUjdQG+Lbj2o=
Received: from dfj (<unknown> [95.236.233.95])
        by ziongate (OpenSMTPD) with ESMTPSA id 4d5d8a25 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 24 Jan 2023 07:21:31 +0000 (UTC)
Date:   Tue, 24 Jan 2023 08:21:35 +0100 (CET)
From:   Angelo Dureghello <angelo@kernel-space.org>
To:     Andrew Lunn <andrew@lunn.ch>
cc:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Subject: Re: mv88e6321, dual cpu port
In-Reply-To: <Y87pLbMC4GRng6fa@lunn.ch>
Message-ID: <7dd335e4-55ec-9276-37c2-0ecebba986b9@kernel-space.org>
References: <5a746f99-8ded-5ef1-6b82-91cd662f986a@kernel-space.org> <Y7yIK4a8mfAUpQ2g@lunn.ch> <ed027411-c1ec-631a-7560-7344c738754e@kernel-space.org> <20230110222246.iy7m7f36iqrmiyqw@skbuf> <Y73ub0xgNmY5/4Qr@lunn.ch> <8d0fce6c-6138-4594-0d75-9a030d969f99@kernel-space.org>
 <20230123112828.yusuihorsl2tyjl3@skbuf> <7e29d955-2673-ea54-facb-3f96ce027e96@kernel-space.org> <20230123191844.ltcm7ez5yxhismos@skbuf> <Y87pLbMC4GRng6fa@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RDNS_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Andrew and Vladimir,

On Mon, 23 Jan 2023, Andrew Lunn wrote:

>> I don't know what this means:
>>
>> | I am now trying this way on mv88e6321,
>> | - one vlan using dsa kernel driver,
>> | - other vlan using dsdt userspace driver.
>>
>> specifically what is "dsdt userspace driver".
>
> I think DSDT is Marvells vendor crap code.
>
Yes, i have seen someone succeeding using it, why do you think it's 
crap ?

> Having two drivers for the same hardware is a recipe for disaster.
>
>  Andrew
>

What i need is something as

         eth0 ->  vlan1 -> port5(rmii)  ->  port 0,1,2
         eth1 ->  vlan2 -> port6(rgmii) ->  port 3,4

The custom board i have here is already designed in this way
(2 fixed-link mac-to-mac connecitons) and trying my best to have
the above layout working.

If you have any suggestion on how to proceed, really appreciated.

Thanks,
angelo
