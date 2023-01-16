Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5328F66BBCE
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 11:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbjAPKei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 05:34:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbjAPKe3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 05:34:29 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BD971ABEC
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 02:34:24 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id x36so5445018ede.13
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 02:34:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5NSqKR3ZEAmACogLflZgQ4LzvHeKnv60a5yq6DE6xdc=;
        b=5gD8GB8aNon0VnGDuf7Q4XtCFvdeyzhgPbhqw42nXABobaejDhVgMqvhZWmy1NyGQ5
         PDNUH5nRO53Bvn3RvsoFd8+3CemgpOdZKr1CEGxI/K0o7Z2YsNoyCIiMQ8yMwzzkuQJX
         0GHljb2zkdpue9HarSrSRUTdSvYMMm1okXPEt1hvJ75Uec0Z1W+SD5udU88X3i8ZfFHV
         rrsSk80UY47UvPoGrNAoq0PtVMEBtW4EVnlsiJ3zhXwcwMAD2kh7noGNfR5h9fc7nbLZ
         j27x29b/o43PWt79dGlbTE5VP6eHGz438POilgYsCW0ChF4ZcyKicG83I0ATJtRbeQIV
         2a9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5NSqKR3ZEAmACogLflZgQ4LzvHeKnv60a5yq6DE6xdc=;
        b=q1WhWKXOuipSOxawzLovoHwleZ33dOj3p6w/nz2m7jDo8orQy3Tg4EeHQ+5aH7vfzL
         vrB9mc3l171a723vytHsMHQITYbDEmG7PEXpJPJF7tiKRL+lUs6Yq6ZMzWWMrIZwHqi6
         A0swbrObrCimp0hLt7ishnZ9SNktl6cxN2exfOXQ02v+zYr5XhSznhNvZMgVwvcc5Kes
         wldd4XuXRnRXU2j6/MB4e8X9cUmhS5l5R3BKJwC8T0/SHpQqeI7sxumNPyCKOPhRSoxE
         Y6+iAw4k554ytsLidtZSP/UimBE1FamlOiapvYvgN1pBfWG2YFJEHZJq0y8tNNKvFXUD
         Gm3g==
X-Gm-Message-State: AFqh2kp6JjzOKUTDsagOHC+1fbF/KDhVD7eZ7IwJUtUFEFQmwlFuI2xU
        PTleYK+ZxP9vrb4sIZhpcqMEsA==
X-Google-Smtp-Source: AMrXdXt8vSCDWOQ8MhcKurDyNGZqHDGJbYODfofLEKUuv+FeWxKoK81115oQmU/BwdKkNW6RACau+w==
X-Received: by 2002:a05:6402:104d:b0:486:ac69:b9e4 with SMTP id e13-20020a056402104d00b00486ac69b9e4mr59869017edu.4.1673865262595;
        Mon, 16 Jan 2023 02:34:22 -0800 (PST)
Received: from localhost ([217.111.27.204])
        by smtp.gmail.com with ESMTPSA id b15-20020aa7c90f000000b004615f7495e0sm11323264edt.8.2023.01.16.02.34.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 02:34:21 -0800 (PST)
Date:   Mon, 16 Jan 2023 11:34:20 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, idosch@nvidia.com,
        petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: Re: [patch net-next v4 00/10] devlink: linecard and reporters
 locking cleanup
Message-ID: <Y8UoLCZeXGJexbUd@nanopsycho>
References: <20230111090748.751505-1-jiri@resnulli.us>
 <Y8PEaPtKkcbNknNM@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8PEaPtKkcbNknNM@unreal>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Jan 15, 2023 at 10:16:24AM CET, leon@kernel.org wrote:
>On Wed, Jan 11, 2023 at 10:07:38AM +0100, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@nvidia.com>
>> 
>> This patchset does not change functionality.
>
>This series causes to some glitches in our CI. Jiri is looking into it.

I'm trying to untangle odd locking scheme during mlx5 auxdev probe. Stay
tuned.

>
>Thanks
