Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08D824D4310
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 10:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240609AbiCJJGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 04:06:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240637AbiCJJGx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 04:06:53 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F41801385A7
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 01:05:50 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id c25so3937796edj.13
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 01:05:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5fjiLpn4LQo/lyBh/cbpUtG0Axa6TRPfBL2LBdmv6ls=;
        b=TE2StmCUmWWj/Wi5xaF/KLz8HfkF5kdpS7q+/qrknJ+zU2MUpBPLOTILcGTFsGYN9X
         3u8gpjqyUmNmOMctQ7ENeZP0gMaCpxJKUpBGnuldplJK5EPSK2/A9fqp0JDSSTeEzgbQ
         o/fJPsBA9kzIr+sc+3qxww4Uzg4tsmAFL1Hm3DhxsmUMOEzV9WRP+YwXAJMfZfk4ckXZ
         GPTd57Hs8vGSFPylAfZ77pB9uGnScjMdq8Z4ADbZpKV0hfNDXwD2oscxIbG/GWl0U4wz
         ug6hsYElCyraXkXfT720zHxxvN36qbJx0+atZBkxSukJ4P59MFIbCI7h1vPYSajyLJ1l
         lh9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5fjiLpn4LQo/lyBh/cbpUtG0Axa6TRPfBL2LBdmv6ls=;
        b=oM4zGciYshSKYbNEd/L+AVuJaJTiavk4uN1ey0t13VArnAE5RPhPdqxT4LPM8wJRU/
         NPKo3TTj/7nG+gs2AdyqclqnPBtwQbW4SUw0w4atCO2k5jK/WMfCus57NFEvlxH1STbx
         OwNbW3cZ9JK1UL4SWNJ1sHnVU3tgalikrZX/ciDytybU7Jd+rQaWJtvWkpMsiBKY3rTk
         XjYGRuXIJBYyUZG0sDXBE0j9AtZhr6hKMHsoZ2DC/UtttUaZovkpqXNjh0T1F3V6213v
         3U2EFfpMauauCBDkRHofUI5tcnfYhGvGRaqh1GTKP0iTHPsXCEX6C0Gu+cDro5rVTW2+
         5XVw==
X-Gm-Message-State: AOAM532Nl3vw8vmWdoNoGkEHihq7kaRxtTp5YH4KjNok+td2l0XFhPQ0
        me5o/hk25B5yeWVQVWxqPT2vDA==
X-Google-Smtp-Source: ABdhPJysW14cv6JsZtvA3UfS75OpHi/Hi0YK5uROz2Be0Gtiy6mlZeHT8AVnWqDO1z6Fq3n36XA3Ng==
X-Received: by 2002:a50:d903:0:b0:416:17b1:8557 with SMTP id t3-20020a50d903000000b0041617b18557mr3262318edj.372.1646903149420;
        Thu, 10 Mar 2022 01:05:49 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id g13-20020a50bf4d000000b00410d407da2esm1795047edk.13.2022.03.10.01.05.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 01:05:48 -0800 (PST)
Date:   Thu, 10 Mar 2022 10:05:47 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     idosch@nvidia.com, petrm@nvidia.com, simon.horman@corigine.com,
        netdev@vger.kernel.org, leonro@nvidia.com
Subject: Re: [RFT net-next 0/6] devlink: expose instance locking and simplify
 port splitting
Message-ID: <Yim/a+sB0IKwTfxH@nanopsycho>
References: <20220310001632.470337-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220310001632.470337-1-kuba@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Mar 10, 2022 at 01:16:26AM CET, kuba@kernel.org wrote:
>This series puts the devlink ports fully under the devlink instance
>lock's protection. As discussed in the past it implements my preferred
>solution of exposing the instance lock to the drivers. This way drivers
>which want to support port splitting can lock the devlink instance
>themselves on the probe path, and we can take that lock in the core
>on the split/unsplit paths.
>
>nfp and mlxsw are converted, with slightly deeper changes done in
>nfp since I'm more familiar with that driver.
>
>Now that the devlink port is protected we can pass a pointer to
>the drivers, instead of passing a port index and forcing the drivers
>to do their own lookups. Both nfp and mlxsw can container_of() to
>their own structures.
>
>I'd appreciate some testing, I don't have access to this HW.

I like this patchset. To be honest, I made a mistake to not do have it
like this from the beginning. I tried to hide the devlink lock from the
user/driver, but as it turned out, that was probably not a good idea :)


>
>Jakub Kicinski (6):
>  devlink: expose instance locking and add locked port registering
>  eth: nfp: wrap locking assertions in helpers
>  eth: nfp: replace driver's "pf" lock with devlink instance lock
>  eth: mlxsw: switch to explicit locking for port registration
>  devlink: hold the instance lock in port_split / port_unsplit callbacks
>  devlink: pass devlink_port to port_split / port_unsplit callbacks
>
> drivers/net/ethernet/mellanox/mlxsw/core.c    |  36 ++---
> drivers/net/ethernet/mellanox/mlxsw/minimal.c |   6 +
> .../net/ethernet/mellanox/mlxsw/spectrum.c    |   7 +
> .../net/ethernet/netronome/nfp/flower/main.c  |   4 +-
> drivers/net/ethernet/netronome/nfp/nfp_app.c  |   2 +-
> drivers/net/ethernet/netronome/nfp/nfp_app.h  |  12 +-
> .../net/ethernet/netronome/nfp/nfp_devlink.c  |  55 +++----
> drivers/net/ethernet/netronome/nfp/nfp_main.c |  19 +--
> drivers/net/ethernet/netronome/nfp/nfp_main.h |   6 +-
> .../net/ethernet/netronome/nfp/nfp_net_main.c |  34 ++--
> .../net/ethernet/netronome/nfp/nfp_net_repr.c |   4 +-
> drivers/net/ethernet/netronome/nfp/nfp_port.c |  17 --
> drivers/net/ethernet/netronome/nfp/nfp_port.h |   2 -
> include/net/devlink.h                         |  15 +-
> net/core/devlink.c                            | 148 ++++++++++--------
> 15 files changed, 196 insertions(+), 171 deletions(-)
>
>-- 
>2.34.1
>
