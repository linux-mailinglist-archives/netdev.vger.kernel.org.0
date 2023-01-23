Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB3B6776C6
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 09:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231638AbjAWIwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 03:52:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231509AbjAWIwb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 03:52:31 -0500
Received: from mail.kernel-space.org (unknown [IPv6:2a01:4f8:c2c:5a84::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D48D31CACA
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 00:52:13 -0800 (PST)
Received: from ziongate (localhost [127.0.0.1])
        by ziongate (OpenSMTPD) with ESMTP id 3cc2412a;
        Mon, 23 Jan 2023 08:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=simple; d=kernel-space.org; h=date
        :from:to:cc:subject:in-reply-to:message-id:references
        :mime-version:content-type; s=default; bh=IiCD7gjkT/o0mddn9nRsWf
        aarbM=; b=kPLVA5tFl3Cin/fJCBdY/iipD9zu+j+u/rtPS2PYqaJSERe6+vmDU3
        UBAzCOXBsrzpu3ywMGXhEZPscj6PQeT0h8GGQZuuSHN0NANwWy+J3EeSHIbq98Gn
        LAp6XFIfRNt59dyc7n5GiElneiNGdc0sz9OTYsX0DQFOu0P5NaIbM=
DomainKey-Signature: a=rsa-sha1; c=simple; d=kernel-space.org; h=date
        :from:to:cc:subject:in-reply-to:message-id:references
        :mime-version:content-type; q=dns; s=default; b=gbuzMTnPTiLXvrLn
        /jEHGlAOudSYZuGh0C9AljX+vgVejC7EZ+tebgT9gItvQmqBmNOdG5vTG3NXQLoH
        NWILPoMv1wnpr/XXWHAMQgFRFQ79fF/5M+FTgEt8bhHngKsQ4rpMg1fbxbSr5ZTW
        enLQGVz1YcwGRya2TRITh06L/eY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel-space.org;
        s=20190913; t=1674463931;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=85ZgvTgIk1sr1FcmdBrTQmCZZinsRDNfIkATvKhrXfk=;
        b=sgeiUONpfMYxkKy3UcleYERSiMcymvLGnc8lwYo1DRcDIDnQIJov7hp/6SZ0cEuoOYDTRq
        JoJ+q/0WAaBTEKErKpWLOfWMG8ShZU+zCle7Be6bR+vjRSLdXPzs99vWajo6t45DTeL9JP
        BoSiv67mzTxeUYaAywt6HWVt81MfHUU=
Received: from dfj (<unknown> [95.236.233.95])
        by ziongate (OpenSMTPD) with ESMTPSA id af87b55a (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Mon, 23 Jan 2023 08:52:11 +0000 (UTC)
Date:   Mon, 23 Jan 2023 09:52:15 +0100 (CET)
From:   Angelo Dureghello <angelo@kernel-space.org>
To:     Andrew Lunn <andrew@lunn.ch>
cc:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Subject: Re: mv88e6321, dual cpu port
In-Reply-To: <Y73ub0xgNmY5/4Qr@lunn.ch>
Message-ID: <8d0fce6c-6138-4594-0d75-9a030d969f99@kernel-space.org>
References: <5a746f99-8ded-5ef1-6b82-91cd662f986a@kernel-space.org> <Y7yIK4a8mfAUpQ2g@lunn.ch> <ed027411-c1ec-631a-7560-7344c738754e@kernel-space.org> <20230110222246.iy7m7f36iqrmiyqw@skbuf> <Y73ub0xgNmY5/4Qr@lunn.ch>
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

thanks for the kind support.

On Wed, 11 Jan 2023, Andrew Lunn wrote:

>>> I cannot actually upgrade the kernel, due to cpu producer
>>> customizations that are not mainlined, so would try to
>>> downgrade the driver.
>>
>> The delta between v5.4 and the kernel where support for multiple CPU
>> ports was added is ~600 patches to the net/dsa/ folder alone. There are
>> some non-trivial interdependencies with phylib, phylink, devlink, switchdev.
>> You might also need support for the end result, if you end up cherry picking
>> only what you think is useful. Hopefully that will help you reconsider.
>
> v5.4 is really old, v5.10, v5.15 and v6.1 are also LTS kernels. I
> suggest you ask your CPU vendor for a v6.1, or v5.15 port of their
> vendor tree. v5.4 has a projected End Of Life December 2025, so if you
> are going to invest a few months effort trying to get this working, do
> you have enough time left to get some return on your investment? And a
> plan what to do once it is EOL?
>

I am now stuck to 5.4.70 due to freescale stuff in it.
I tried shortly a downgrade of net/dsa part from 5.5,
but, even if i have no errors, i can't ping out, something
seems has gone wrong, i don't like too much this approach.

But of course, i could upgrade to 5.10 that's available
from freescale, with some effort.
Then, i still should apply a patch on the driver to have dual
cpu running, if i understand properly, correct ?

I am now trying this way on mv88e6321,
- one vlan using dsa kernel driver,
- other vlan using dsdt userspace driver.

Do you think i may succeed, or better avoid any attempt,
and go for kernel upgrade ?

>       Andrew
>

Thanks a lot,
angelo
