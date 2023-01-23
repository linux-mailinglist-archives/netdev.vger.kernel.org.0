Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE1C1677C6C
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 14:26:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231940AbjAWN05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 08:26:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231964AbjAWN04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 08:26:56 -0500
Received: from mail.kernel-space.org (unknown [IPv6:2a01:4f8:c2c:5a84::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D52325288
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 05:26:54 -0800 (PST)
Received: from ziongate (localhost [127.0.0.1])
        by ziongate (OpenSMTPD) with ESMTP id 9232da91;
        Mon, 23 Jan 2023 13:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=simple; d=kernel-space.org; h=date
        :from:to:cc:subject:in-reply-to:message-id:references
        :mime-version:content-type; s=default; bh=cs1g1Ft5NqhbXOwhsQyj3z
        primQ=; b=ah6QmGiEZd8UFFPBv4fCahDn3SenjxX8tyD4XQHoHzbKARIp2paz76
        7lbK7PvcmeUY+LClDzf8FQWRXKqTw/4vuAl3X8QzYm/9PH8TKmo81tY7a7qX5/LN
        nidlgYq8fimsDipdg+qQ7lJJwBChGg9muDArp7UiAEifrAN8Fh/+s=
DomainKey-Signature: a=rsa-sha1; c=simple; d=kernel-space.org; h=date
        :from:to:cc:subject:in-reply-to:message-id:references
        :mime-version:content-type; q=dns; s=default; b=eTJtsA5wWySasBr9
        apJ+BNnxRouxyZWPv+fHKJHp/pukYHWiQRaXZ9C8I9BZtZKJK0KKFkReOq225gTm
        W5Ruw6kOm5xpgRy7zhmqj8jPACzHCcXdrHoCRfeporhwSAXOSoNOuRRKy9wFVstK
        044tVhpB0pqS6Ed2ivsYswWhRII=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel-space.org;
        s=20190913; t=1674480412;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=O7zl/OFc/Yalqqn+DwslRj09BVHbtXcDKer/voAqY8I=;
        b=QCCho5SloDMJLiJfSROSyBnqa6nRET9xh5q7dqpPk4PF1XzspWiFiQsBaYJghn04lysIw9
        LfsVLppjnMuOuXtDa8I+bRTanpUyN8OpuycaghsZhuBW3w4ribjEuljUZpTKLrf6edZ9H6
        8NFO/bEql/CZpEC3r8a7r2EYOIKfMgw=
Received: from dfj (<unknown> [95.236.233.95])
        by ziongate (OpenSMTPD) with ESMTPSA id 26ee3c25 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Mon, 23 Jan 2023 13:26:52 +0000 (UTC)
Date:   Mon, 23 Jan 2023 14:26:55 +0100 (CET)
From:   Angelo Dureghello <angelo@kernel-space.org>
To:     Vladimir Oltean <olteanv@gmail.com>
cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: Re: mv88e6321, dual cpu port
In-Reply-To: <20230123112828.yusuihorsl2tyjl3@skbuf>
Message-ID: <7e29d955-2673-ea54-facb-3f96ce027e96@kernel-space.org>
References: <5a746f99-8ded-5ef1-6b82-91cd662f986a@kernel-space.org> <Y7yIK4a8mfAUpQ2g@lunn.ch> <ed027411-c1ec-631a-7560-7344c738754e@kernel-space.org> <20230110222246.iy7m7f36iqrmiyqw@skbuf> <Y73ub0xgNmY5/4Qr@lunn.ch> <8d0fce6c-6138-4594-0d75-9a030d969f99@kernel-space.org>
 <20230123112828.yusuihorsl2tyjl3@skbuf>
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

Hi Vladimir,

On Mon, 23 Jan 2023, Vladimir Oltean wrote:

> On Mon, Jan 23, 2023 at 09:52:15AM +0100, Angelo Dureghello wrote:
>> I am now stuck to 5.4.70 due to freescale stuff in it.
>> I tried shortly a downgrade of net/dsa part from 5.5,
>> but, even if i have no errors, i can't ping out, something
>> seems has gone wrong, i don't like too much this approach.
>>
>> But of course, i could upgrade to 5.10 that's available
>> from freescale, with some effort.
>> Then, i still should apply a patch on the driver to have dual
>> cpu running, if i understand properly, correct ?
>
> What is the Freescale chip stuck on 5.4 (5.10 with some effort) if I may
> ask? I got the impression that the vast majority of SoCs have good
> enough mainline support to boot a development kernel and work on that,
> the exception being some S32 platforms.
>

I think i tested mainline kernel, but the rpmsg part to
communicate with M4 core and scu firmware seems not there.
So i am stuck with freescale stuff now. Anyway, freescale
released their 5.10 branch, so eventually i'll move
to that.

Regards,
angelo
