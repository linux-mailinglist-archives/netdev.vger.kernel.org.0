Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB22755C9E6
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245549AbiF1GdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 02:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245743AbiF1Gcy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 02:32:54 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCA332610A
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 23:32:51 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id lw20so23651003ejb.4
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 23:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DrFtAXY8JiAUbXj1cHJgmzk53yAiyY4rQ6bNJBtwqzA=;
        b=EmCIf9xwfz0e2RQ10EAsxcakCKPgaQXKVcV/2bpGXVRkUAXtf3i/OsHpjdvPiG9iBv
         tTLoCgiovYqbEiKcMbWGrqVOLeYcdM33aL+qYryWvX6Odt7o3Wu5u8/OhqfFLyIhR+9F
         2FK1GMxyLCTRfJhnao+sd0t3FirDJ5hqsMWcFG7+pivlzC0SsobAPjkX5btBVG3auvBd
         iT0hu4rwdYn8PqzkvAU+C8WFOtF7iH4vziz06hy1+QMPCoVrhbH56Jpl4sVX2zXXw7TS
         YfetkSc8NQMpugFHogOpjwNqdhzLEvKoh1mZiqN3xUizXkcWjyeZJF1ZdvKjYwtVMu1x
         Z7Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DrFtAXY8JiAUbXj1cHJgmzk53yAiyY4rQ6bNJBtwqzA=;
        b=cRNg1f+awF39kLPz3pb7fRNidiQF4gqjB/LwuC8QjTSJrQ+YSWMi9XSaeL19tHstO6
         dV/zoIbLYzf/mmPZnvUIzVAFO503ZRO0b/1tRJmbOne33f3JFoW2+V9g1MsY2NbK5cOo
         iCf3sp/K9R+UEue5SUuh0QfnNiRy0MgLf92oQtmrR5ZAdtBM/KoYCO5qANK1ES+K9jMs
         YOukfbPV4fAmyG0w4pttDkAvxkAhQbNE3PX3zKXE/2Xr6MS9D16rGZ6D0A8ixUaNxBYO
         MApM/4F0GQ3Yr4W34a02qBY/sLt3pW9NeacvkImXsNWyJwMbe2c+EEP32dslGVfRQZbF
         By4A==
X-Gm-Message-State: AJIora/XcoeaHOn+XrkGJJx+TEty9okqA8lsNAtZSakbO7DRnjfcILPK
        wNhBR8nzBbchq8mJXQm6o7AOJA==
X-Google-Smtp-Source: AGRyM1tfaULDcLfpl2shm5eTPKoSC6FvGjmgTezp4t4RRmfYVoJUML2jRXXATpXM6It/sV6Vetgn+w==
X-Received: by 2002:a17:907:a424:b0:702:f94a:a897 with SMTP id sg36-20020a170907a42400b00702f94aa897mr15742536ejc.255.1656397970280;
        Mon, 27 Jun 2022 23:32:50 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id z7-20020a1709063ac700b0072321c99b78sm5912083ejd.57.2022.06.27.23.32.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 23:32:49 -0700 (PDT)
Date:   Tue, 28 Jun 2022 08:32:49 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        davem@davemloft.net, petrm@nvidia.com, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, saeedm@nvidia.com
Subject: Re: [patch net-next RFC 0/2] net: devlink: remove devlink big lock
Message-ID: <YrqgkKxHReC6evao@nanopsycho>
References: <20220627135501.713980-1-jiri@resnulli.us>
 <YrnPqzKexfgNVC10@shredder>
 <20220627104945.5d8337a5@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627104945.5d8337a5@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jun 27, 2022 at 07:49:45PM CEST, kuba@kernel.org wrote:
>On Mon, 27 Jun 2022 18:41:31 +0300 Ido Schimmel wrote:
>> On Mon, Jun 27, 2022 at 03:54:59PM +0200, Jiri Pirko wrote:
>> > This is an attempt to remove use of devlink_mutex. This is a global lock
>> > taken for every user command. That causes that long operations performed
>> > on one devlink instance (like flash update) are blocking other
>> > operations on different instances.  
>> 
>> This patchset is supposed to prevent one devlink instance from blocking
>> another? Devlink does not enable "parallel_ops", which means that the
>> generic netlink mutex is serializing all user space operations. AFAICT,
>> this series does not enable "parallel_ops", so I'm not sure what
>> difference the removal of the devlink mutex makes.
>> 
>> The devlink mutex (in accordance with the comment above it) serializes
>> all user space operations and accesses to the devlink devices list. This
>> resulted in a AA deadlock in the previous submission because we had a
>> flow where a user space operation (which acquires this mutex) also tries
>> to register / unregister a nested devlink instance which also tries to
>> acquire the mutex.
>> 
>> As long as devlink does not implement "parallel_ops", it seems that the
>> devlink mutex can be reduced to only serializing accesses to the devlink
>> devices list, thereby eliminating the deadlock.
>
>I'm unclear on why we can't wait for mlx5 locking rework which will

Sure we can, no rush.

>allow us to move completely to per-instance locks. Do you have extra
>insights into how that work is progressing? I was hoping that it will

It's under internal review afaik.

>be complete in the next two months. 

What do you mean exactly? Is that that we would be okay just with
devlink->lock? I don't think so. We need user lock because we can't take
devlink->lock for port split and reload. devlink_mutex protects that now,
the devlink->cmd_lock I'm introducing here just replaces devlink_mutex.
If we can do without, that is fine. I just can't see how.
Also, I don't see the relation to mlx5 work. What is that?
