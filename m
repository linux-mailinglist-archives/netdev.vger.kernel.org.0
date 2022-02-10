Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9F474B0926
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 10:08:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238252AbiBJJHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 04:07:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238209AbiBJJHm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 04:07:42 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79BCE18B
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 01:07:43 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id f10so9114905lfu.8
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 01:07:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=Q/4HD0u0FsnyQKuk9QMRqDFGsAdNtwpy+oe3vgRYJqk=;
        b=H0437sBkullS25ZzberqIQipH5vrhLiE1jFKeWT7M4dDVkB0x/tTE4hyBJleHxbWks
         fu7FaBU7T44VWSoatzAy9KH8CiYY7F8CvDkqs6/+wAE3WZISyL5f0/rZRMpolpxDcTIp
         JtHY5rFxJ0Lzxb1VluyqnPoNVgi7s4ik1+zCVKTNcHNFy2B26diPw4YtVDYnWguSvdQS
         854z536fISY2NwjLJwdCgIDTrJRsGD91QpRF6qfFHkTR70lUmZmvgtNSzAyadheUbBjc
         OdxpiqaRqdQP4k+O20pwmFixibIq4GB12axMnTSTZ3RHa0SWZluENmSvw1v/wA8H/jD2
         BBNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Q/4HD0u0FsnyQKuk9QMRqDFGsAdNtwpy+oe3vgRYJqk=;
        b=XFbysy8BmVc4iMyEJbNwJmxwptMDYUToCZ8OqeX0T4DgQD+eJ5peDH/QZlpA4LYN5X
         BoS/Stf3s/1aAIkFVMABcJe1CQfgzXZtSa691y+GG+083Cl2QdMnhPuhaA3I2SIO+jYQ
         aIxKFcdOjgNpcyXGBueIbllqgyriI1gvoO9nhQQWhNuKt0UY4Dex14zJM+oKzmlc4iOd
         b75Ujx6GiQk5WPJPv0mZ943W/qj4cvNrKlQfMPUCnbakpV2KDaIUiPwFO9fD7WP4maK3
         yaxuYklAcrSpviKmmg+AIf4NRzkQw9d3gYAHwGnfUewB+CRYuvNukLp9/0OHF3kt/vFV
         8Aww==
X-Gm-Message-State: AOAM5320aJP5XfNprMHs+L0DeaPel0XNoi/Et50id1rPh6ZCx9+8Qh/J
        DK5X3n/Zr5yx6J666T6Y45vfQx4NkTSO8w6RyuM=
X-Google-Smtp-Source: ABdhPJyAtJufJaQ1kQevjE4+ldeyn1C5gyL96boO1gO5BXH0nX7IsfzQI2BKk5f5K9OkF+xGm0QIEQ==
X-Received: by 2002:ac2:4472:: with SMTP id y18mr2527577lfl.209.1644484061721;
        Thu, 10 Feb 2022 01:07:41 -0800 (PST)
Received: from wse-c0127 ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id a21sm916698lfr.290.2022.02.10.01.07.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 01:07:41 -0800 (PST)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>,
        Hans Schultz <schultz.hans@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/5] Add support for locked bridge ports
 (for 802.1X)
In-Reply-To: <YgPsY6KrbDo2QHgX@shredder>
References: <20220209130538.533699-1-schultz.hans+netdev@gmail.com>
 <YgPsY6KrbDo2QHgX@shredder>
Date:   Thu, 10 Feb 2022 10:07:09 +0100
Message-ID: <86r18bum2q.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On ons, feb 09, 2022 at 18:31, Ido Schimmel <idosch@idosch.org> wrote:
> On Wed, Feb 09, 2022 at 02:05:32PM +0100, Hans Schultz wrote:
>> This series starts by adding support for SA filtering to the bridge,
>> which is then allowed to be offloaded to switchdev devices. Furthermore
>> an offloading implementation is supplied for the mv88e6xxx driver.
>
> [...]
>
>> Hans Schultz (5):
>>   net: bridge: Add support for bridge port in locked mode
>>   net: bridge: Add support for offloading of locked port flag
>>   net: dsa: Add support for offloaded locked port flag
>>   net: dsa: mv88e6xxx: Add support for bridge port locked mode
>>   net: bridge: Refactor bridge port in locked mode to use jump labels
>
> I think it is a bit weird to add a static key for this option when other
> options (e.g., learning) don't use one. If you have data that proves
> it's critical, then at least add it in patch #1 where the new option is
> introduced.

Do you suggest that I drop patch #5 as I don't have data that it is
critical?

>
> Please add a selftest under tools/testing/selftests/net/forwarding/. It
> should allow you to test both the SW data path with veth pairs and the
> offloaded data path with loopbacks. See tools/testing/selftests/net/forwarding/README

I will do that.
