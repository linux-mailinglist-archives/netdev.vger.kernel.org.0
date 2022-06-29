Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E64E055FD68
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 12:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232946AbiF2Kga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 06:36:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232071AbiF2Kg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 06:36:28 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13F573E0C8
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 03:36:27 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id sb34so31604031ejc.11
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 03:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gtd2Uuqvu9sWd2GHMBkrzoAelHW+0awzjkO/Cq0cPQk=;
        b=itSDLTrDKlgrYXih7p9RpQlX1wiB76HiqG6jsUIlCP5/LiPSVf9kD/bzr35/bAzrax
         cykqKKQjMxh4ppXFT9AYL70NZY4zrwytnv0v46+OwevQ2eXio2E+5hU0l0eGfMsg6Xwx
         af/m1xe/w6Z0UCRObrEnRwwME633Cde3HVZuFqm9UUqNprEjAFJ1sLlnazvO+zQ3z4pZ
         jJiMAAuih7M+J9DfbdL9UCK2xuKsgnnC3Za04PRiySZQFF6e9l3hkyZmKKIFzvHNVZ4y
         wpuxi9OvUEdhL18cL9qMg00Bk0N7k8Q30SDJ/FNWSkizEC1ZbocYmcItTvwilp4aFpb5
         NmsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gtd2Uuqvu9sWd2GHMBkrzoAelHW+0awzjkO/Cq0cPQk=;
        b=a+a68GgLr3Al+awzWF5qGZW5e1PdgT6b1OPUeRdz7Tx/m5fypn8U7ahtDs3S0YvcX8
         CW2vADwg2fHdVpK8ZICGt+pZm0n0Uo8OZd+rcuJ0eyAcPMRzXlyR/OvUinTnTIEOUVoM
         IyVuthPZzIWjHAMfjMYmrLTWu4jfvItOrdZ9SKWx0qXv+aAG/K2HlOEcdIhyKKCeMOJj
         /HyQahCF0jaw4xq3mQetKF9OfEv9JjTWWVHNnmAYQZEev6f/b/zXWm4ObzVUQTk+JtqS
         HeGGS1Xb84vsBkOBkzA2czGo7hJ+Qy9iW2yKlLsVr928XpApNb8MMJs9nWYE8OovNMz9
         C+/Q==
X-Gm-Message-State: AJIora+Of32RdG4dbzc42vmaTvEqmuybGfiAQCkhw8yxe3Zl2KqQtww1
        1oP7KakbigjClEZSRcZbxvCJfA==
X-Google-Smtp-Source: AGRyM1sbj5uJi4D30638zD/6xbE8cGNs7+ypcBf1LtWSbrMQT1TKEt39ClHEbBwHwi8wNiRCKH3fVQ==
X-Received: by 2002:a17:906:5047:b0:710:456a:695e with SMTP id e7-20020a170906504700b00710456a695emr2632851ejk.433.1656498985671;
        Wed, 29 Jun 2022 03:36:25 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id f8-20020a056402150800b0043578cf97d0sm11137421edw.23.2022.06.29.03.36.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 03:36:25 -0700 (PDT)
Date:   Wed, 29 Jun 2022 12:36:24 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com
Subject: Re: [patch net-next RFC 0/2] net: devlink: remove devlink big lock
Message-ID: <YrwrKDAkR2xCAAWd@nanopsycho>
References: <20220627135501.713980-1-jiri@resnulli.us>
 <YrnPqzKexfgNVC10@shredder>
 <YrnS2tcgyI9Aqe+b@nanopsycho>
 <YrqxHpvSuEkc45uM@shredder>
 <YrworZb5yNdnMFDI@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrworZb5yNdnMFDI@nanopsycho>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jun 29, 2022 at 12:25:49PM CEST, jiri@resnulli.us wrote:
>Tue, Jun 28, 2022 at 09:43:26AM CEST, idosch@nvidia.com wrote:
>>On Mon, Jun 27, 2022 at 05:55:06PM +0200, Jiri Pirko wrote:
>>> Mon, Jun 27, 2022 at 05:41:31PM CEST, idosch@nvidia.com wrote:
>>> >On Mon, Jun 27, 2022 at 03:54:59PM +0200, Jiri Pirko wrote:
>>> >> From: Jiri Pirko <jiri@nvidia.com>
>>> >> 
>>> >> This is an attempt to remove use of devlink_mutex. This is a global lock
>>> >> taken for every user command. That causes that long operations performed
>>> >> on one devlink instance (like flash update) are blocking other
>>> >> operations on different instances.
>>> >
>>> >This patchset is supposed to prevent one devlink instance from blocking
>>> >another? Devlink does not enable "parallel_ops", which means that the
>>> >generic netlink mutex is serializing all user space operations. AFAICT,
>>> >this series does not enable "parallel_ops", so I'm not sure what
>>> >difference the removal of the devlink mutex makes.
>>> 
>>> You are correct, that is missing. For me, as a side effect this patchset
>>> resolved the deadlock for LC auxdev you pointed out. That was my
>>> motivation for this patchset :)
>>
>>Given that devlink does not enable "parallel_ops" and that the generic
>>netlink mutex is held throughout all callbacks, what prevents you from
>>simply dropping the devlink mutex now? IOW, why can't this series be
>>patch #1 and another patch that removes the devlink mutex?
>
>Yep, I think you are correct. We are currently working with Moshe on

Okay, I see the problem with what you suggested:
devlink_pernet_pre_exit()
There, devlink_mutex is taken to protect against simultaneous cmds
from being executed. That will be fixed with reload conversion to take
devlink->lock.


>conversion of commands that does not late devlink->lock (like health
>reporters and reload) to take devlink->lock. Once we have that, we can
>enable parallel_ops.
>
>>
>>> 
>>> 
>>> >
>>> >The devlink mutex (in accordance with the comment above it) serializes
>>> >all user space operations and accesses to the devlink devices list. This
>>> >resulted in a AA deadlock in the previous submission because we had a
>>> >flow where a user space operation (which acquires this mutex) also tries
>>> >to register / unregister a nested devlink instance which also tries to
>>> >acquire the mutex.
>>> >
>>> >As long as devlink does not implement "parallel_ops", it seems that the
>>> >devlink mutex can be reduced to only serializing accesses to the devlink
>>> >devices list, thereby eliminating the deadlock.
>>> >
>>> >> 
>>> >> The first patch makes sure that the xarray that holds devlink pointers
>>> >> is possible to be safely iterated.
>>> >> 
>>> >> The second patch moves the user command mutex to be per-devlink.
>>> >> 
>>> >> Jiri Pirko (2):
>>> >>   net: devlink: make sure that devlink_try_get() works with valid
>>> >>     pointer during xarray iteration
>>> >>   net: devlink: replace devlink_mutex by per-devlink lock
>>> >> 
>>> >>  net/core/devlink.c | 256 ++++++++++++++++++++++++++++-----------------
>>> >>  1 file changed, 161 insertions(+), 95 deletions(-)
>>> >> 
>>> >> -- 
>>> >> 2.35.3
>>> >> 
