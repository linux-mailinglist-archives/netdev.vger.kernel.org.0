Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE8DD55C55C
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244725AbiF1HE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 03:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343708AbiF1HEo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 03:04:44 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7CCF27173
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 00:04:14 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id ej4so16166159edb.7
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 00:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eDn3dht2/D+ZQK9SSTRuAZZR+21qC04HtRN/aXKLPBM=;
        b=OJwXas1bZEVv5wg16DYhRFrQqVbnBgUqw2zd4YMj0yK6e71mD/2zBEui5elyAbNzcS
         1T8bvdritJIGBOe2+9U3M0nNgo0q3mX7y22PdnIgifiEPym7/h9mXfL+9Uf3MeWgcjIP
         PlVfZmp+/qZa4XtNbyKj0KuTb6NHIpI0xIGTFpzcuziIBpRfASQZBR15SGNo4sTe3ZNh
         oiu8qs4/a7rooTYTTl7CI07ZhtH4e/OZX/7i+aAsfUipF49qgoo3wqH7g2VUgKJWPiqV
         aGiD1guDjZYzmBJtAhb/JPDSvG6NoXEbWGCVoBGkHgHn8zjbw5GwT77010rQ9vFgI3Km
         ZZvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eDn3dht2/D+ZQK9SSTRuAZZR+21qC04HtRN/aXKLPBM=;
        b=6jFQWLHrHOKKg16lcGFG1Qeg90Hz++WmbBlS1VrFen9JdTBHIwZWPya7g6N1XsCeMi
         LTTf0eGIZ6/+U7YeCgqKjh+R8s4TSZjnEotL/9bbiVSDx3fx2hYKkgCHmgNE4m4x21nY
         TdcupH5vByUouweoNzxdd/WIh9dO6XrP58Oq521MbraAHjwI0HAohYGYWgsUDpFl4prG
         PAU41I2qr+Lsh7WU30QmMBYvt3ZxjWlOKumoM70KHKUEdNCPy/wlDz3Ia7jQ/At1UdIw
         JxyWrwiW4LAnqIeBZZwPO/jMGcnOKpX2PFFH5gnAhivJETpgdmP3g1Km1gb7HHsz+1W8
         /F8A==
X-Gm-Message-State: AJIora+wrhve8yjFEuklYzNKARynzSrOWT0R8nCWPjNPmDTLlKh5Zu3C
        laxMehYWVmJ+xmPWj7t3tuUX9aGmhsnWj/hBnHE=
X-Google-Smtp-Source: AGRyM1t3C6yL9JxUwVEQaI3LvFof0o/TjdZ+vODzr8SDaBxHrG9Yq76c3QCdrKBsBfP8P74dVuuzjQ==
X-Received: by 2002:a05:6402:1f14:b0:435:97f3:640 with SMTP id b20-20020a0564021f1400b0043597f30640mr20673700edb.169.1656399853283;
        Tue, 28 Jun 2022 00:04:13 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id au8-20020a170907092800b00722e19fec6dsm6009203ejc.156.2022.06.28.00.04.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 00:04:12 -0700 (PDT)
Date:   Tue, 28 Jun 2022 09:04:11 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        davem@davemloft.net, petrm@nvidia.com, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, saeedm@nvidia.com
Subject: Re: [patch net-next RFC 0/2] net: devlink: remove devlink big lock
Message-ID: <Yrqn6zM/kYVpc+Cg@nanopsycho>
References: <20220627135501.713980-1-jiri@resnulli.us>
 <YrnPqzKexfgNVC10@shredder>
 <20220627104945.5d8337a5@kernel.org>
 <YrqgkKxHReC6evao@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrqgkKxHReC6evao@nanopsycho>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jun 28, 2022 at 08:32:49AM CEST, jiri@resnulli.us wrote:
>Mon, Jun 27, 2022 at 07:49:45PM CEST, kuba@kernel.org wrote:
>>On Mon, 27 Jun 2022 18:41:31 +0300 Ido Schimmel wrote:
>>> On Mon, Jun 27, 2022 at 03:54:59PM +0200, Jiri Pirko wrote:
>>> > This is an attempt to remove use of devlink_mutex. This is a global lock
>>> > taken for every user command. That causes that long operations performed
>>> > on one devlink instance (like flash update) are blocking other
>>> > operations on different instances.  
>>> 
>>> This patchset is supposed to prevent one devlink instance from blocking
>>> another? Devlink does not enable "parallel_ops", which means that the
>>> generic netlink mutex is serializing all user space operations. AFAICT,
>>> this series does not enable "parallel_ops", so I'm not sure what
>>> difference the removal of the devlink mutex makes.
>>> 
>>> The devlink mutex (in accordance with the comment above it) serializes
>>> all user space operations and accesses to the devlink devices list. This
>>> resulted in a AA deadlock in the previous submission because we had a
>>> flow where a user space operation (which acquires this mutex) also tries
>>> to register / unregister a nested devlink instance which also tries to
>>> acquire the mutex.
>>> 
>>> As long as devlink does not implement "parallel_ops", it seems that the
>>> devlink mutex can be reduced to only serializing accesses to the devlink
>>> devices list, thereby eliminating the deadlock.
>>
>>I'm unclear on why we can't wait for mlx5 locking rework which will
>
>Sure we can, no rush.
>
>>allow us to move completely to per-instance locks. Do you have extra
>>insights into how that work is progressing? I was hoping that it will
>
>It's under internal review afaik.
>
>>be complete in the next two months. 
>
>What do you mean exactly? Is that that we would be okay just with
>devlink->lock? I don't think so. We need user lock because we can't take
>devlink->lock for port split and reload. devlink_mutex protects that now,

Okay, I take back port split, that is already fixed.
Moshe is taking care of the reset (port_new/del, reporter_*). I will
check out the reload. One we have that, you are correct, we are fine
with devlink->lock instance lock.

Thanks!


>the devlink->cmd_lock I'm introducing here just replaces devlink_mutex.
>If we can do without, that is fine. I just can't see how.
>Also, I don't see the relation to mlx5 work. What is that?
