Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 763D0623CF2
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 08:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232767AbiKJHxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 02:53:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232744AbiKJHxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 02:53:16 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95D9D275E4
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 23:53:12 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id bk15so1003809wrb.13
        for <netdev@vger.kernel.org>; Wed, 09 Nov 2022 23:53:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ys5U5XCPU8SCFGRzGI+PXKXPhzr2McHpZsK7SFCmB9o=;
        b=rFkMe/ZrXsr/X/2Bzs7BBQiuZEDICbyfloiCGMYZZFwQCQznuf5brNPFFhFRWlLA9s
         oU0KHFx2NviJSWenMCesuAxIRw+vkNuDzQi6MxA+wi7N2u5FL7PZvEQtRcibq7HiaLZZ
         yQQ7eGM0iJJIe+mA/E4SgZwYlXbNcGX7iooj1bwdOMyRNTsKAwM1WtTLYMbAqVDUV7Wl
         dU4tENDatMebLazeiooicnINVEV5BY2BlV40m80BXfgqIoZYRQgdlbYSJEltniH4WJoh
         AylXNsDFxolf9vDx5xECKzuFcbfxI1i2Nz8hQLEWRHNRuAK+RntZahMRNgkCn/GxgTng
         34QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ys5U5XCPU8SCFGRzGI+PXKXPhzr2McHpZsK7SFCmB9o=;
        b=osUicjPHQBSqQevy8CZc1bBJLkZrAlA59puhslfUBW7j2totzdzbmTOVeu5vKXn6kT
         ucAbSEWW9FAv27Z9yISAVTqoNjAH53cg66LEdTYEQCt7VJROYfAZGFEOPE45EMiRqJOL
         mwcGUmu9+/TaStsieozHlWNV+1vk8dGtM3LY6P1m0xgNu7uux5STkhw+iNcQLXhKJ4KE
         75m/OfSYIjHQl2Xw9Fgrgs58wO2Af02Q3snQtB2C9wpDg1fSj2tcSWHyT0VEwG+C6yMv
         /jCnB+YI6P6fR+SlXwDWNeHogd0+Zan5/jAw3mrvf3r/X1sw7W+k7DeKj7oTlR85i1EP
         S6lA==
X-Gm-Message-State: ACrzQf2qZ5n5IwkMB73ZeyNWbsm6NKjtSMMrwrcoNHxpHwou0qwO9ZsA
        aIkylM+o27BhqgRA4trcgstSlQ==
X-Google-Smtp-Source: AMsMyM588CejvZXiKJ9qN/dI/EZoMSds1JUHrkX/TLkqCkiRQu0+1OUwF/vg2V6nIEOKKN9x6lhJfQ==
X-Received: by 2002:a5d:6da2:0:b0:236:791d:e5a1 with SMTP id u2-20020a5d6da2000000b00236791de5a1mr40329503wrs.665.1668066791050;
        Wed, 09 Nov 2022 23:53:11 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id d2-20020a056000114200b00236860e7e9esm15052311wrx.98.2022.11.09.23.53.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 23:53:10 -0800 (PST)
Date:   Thu, 10 Nov 2022 08:53:09 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        bigeasy@linutronix.de, imagedong@tencent.com, kuniyu@amazon.com,
        petrm@nvidia.com
Subject: Re: [patch net-next v2 3/3] net: devlink: add WARN_ON to check
 return value of unregister_netdevice_notifier_net() call
Message-ID: <Y2yt5SDkCPTeAoez@nanopsycho>
References: <20221108132208.938676-1-jiri@resnulli.us>
 <20221108132208.938676-4-jiri@resnulli.us>
 <Y2uT1AZHtL4XJ20E@shredder>
 <CANn89iJgTLe0EJ61xYji6W-VzQAGtoXpZJAxgKe-nE9ESw=p7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iJgTLe0EJ61xYji6W-VzQAGtoXpZJAxgKe-nE9ESw=p7w@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Nov 09, 2022 at 05:26:10PM CET, edumazet@google.com wrote:
>On Wed, Nov 9, 2022 at 3:49 AM Ido Schimmel <idosch@idosch.org> wrote:
>>
>> On Tue, Nov 08, 2022 at 02:22:08PM +0100, Jiri Pirko wrote:
>> > From: Jiri Pirko <jiri@nvidia.com>
>> >
>> > As the return value is not 0 only in case there is no such notifier
>> > block registered, add a WARN_ON() to yell about it.
>> >
>> > Suggested-by: Ido Schimmel <idosch@idosch.org>
>> > Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>>
>> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
>
>Please consider WARN_ON_ONCE(), or DEBUG_NET_WARN_ON_ONCE()

Well, in this case, I think that plain WARN_ON is fine as this happens
only during driver cleanup which is not expected to happen very often
(or not at all) in real world scenarios.
