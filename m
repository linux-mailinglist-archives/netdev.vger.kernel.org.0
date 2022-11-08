Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9530862184C
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 16:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233964AbiKHPbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 10:31:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231740AbiKHPbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 10:31:17 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6065810D0
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 07:31:16 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id a67so23012140edf.12
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 07:31:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=77MlvYrSo2GNKJVGomS31FpqZbhx0yNZ6IAPQdhRuvE=;
        b=eKNRxNVDQhX53Qn4SGuahJRXIOuG1FJ4gw6S+uoiOkDIjuhaWTQjcr3tKyOOz618lR
         x0HefKtXnQFMyyfCTLapRDkzUJE4Kpe3s9zllRYhl6o+7tEvByAcqr7II6MI8C8kqOee
         +R2oo6jwxNw+NIwSOV0/sBRk1WePr8XU5rd4LTfzH/ijqOrWdTDFkxDNCPUBBSaPwGld
         8MrfhrDIymXCcVtH8I1Qdw5MBJuqSFI+latc0n7Y2mNlfVU070SkjKBX/GrKV+Q89moG
         fuQ8JXxzeP4YjIGAFg1U4ntsDIDgurxLxnw02zTe/wBOLnsEr7rPmTEYYMSVSveoKMSS
         YVog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=77MlvYrSo2GNKJVGomS31FpqZbhx0yNZ6IAPQdhRuvE=;
        b=3mWzS6PmLFRv3WX0GQFoErLn/GbE/BlkrvEtGXMAZABFZKucuGSF4TFFVKzIXMXbw5
         tPKYo8pimslVv1MhPojOC5VY2ButNYUyYTKlNdPzuT+I0n/ZWDOlNL5w/PZRK1uYVbSG
         ATYAvX3I95AqGaTx4o/ykonMY9Zr62ks1IA5H2p/zbtOTEF4p6ngCay8ri3oMmC0LxuZ
         M1gr/eUwEjzGpX6J0J6P8d35ugR0n9h49+V8x04GlujIe8LdxaL95rAKnzryIBlzvJsg
         5Pbojeq8MAulRy8GLVM5kmWlDt1E7/Bnifn/35KFhou98smDgX71jFk+1ZtJn9mN52IN
         Ry0g==
X-Gm-Message-State: ACrzQf1AoIcDPR2Dq1uLtYJ95KsaIBzBUadTQrueNZfWiNNstcucuboK
        4AippHMmhP7xOLikKsTCuYc=
X-Google-Smtp-Source: AMsMyM6oI3ybSm1UPu85xQM+oOQKADRoVo1IKGpZBzQ2zADP6gIEQhPV8OPEII1yLpP1EKXDm0M5nA==
X-Received: by 2002:aa7:d8c4:0:b0:461:8d31:41fc with SMTP id k4-20020aa7d8c4000000b004618d3141fcmr56233732eds.202.1667921474791;
        Tue, 08 Nov 2022 07:31:14 -0800 (PST)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id kx5-20020a170907774500b007add62dafb7sm4805681ejc.5.2022.11.08.07.31.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 07:31:14 -0800 (PST)
Date:   Tue, 8 Nov 2022 17:31:11 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     Petr Machata <petrm@nvidia.com>, vladimir.oltean@nxp.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ivan Vecera <ivecera@redhat.com>, netdev@vger.kernel.org,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        bridge@lists.linux-foundation.org,
        "Hans J . Schultz" <netdev@kapio-technology.com>, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 00/15] mlxsw: Add 802.1X and MAB offload support
Message-ID: <20221108153111.vlyb2lxo7rm2i3kk@skbuf>
References: <cover.1667902754.git.petrm@nvidia.com>
 <Y2o2dB+k+yDHRVtA@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2o2dB+k+yDHRVtA@shredder>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 08, 2022 at 12:59:00PM +0200, Ido Schimmel wrote:
> + Vladimir
> 
> You weren't copied on the patches by mistake. They are available here:
> https://lore.kernel.org/netdev/cover.1667902754.git.petrm@nvidia.com/

Thanks for copying me. The patches look great to my eyes. I didn't go
into details into the mlxsw details, just because I really have no clue
there.
