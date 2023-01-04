Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEF1B65D041
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 11:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbjADKGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 05:06:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238672AbjADKF5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 05:05:57 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F178E45
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 02:05:56 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id g10so11376023wmo.1
        for <netdev@vger.kernel.org>; Wed, 04 Jan 2023 02:05:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8ypp6pe8QM17Jwqmwbse8rVyoiw3G1CJobst9rhOM80=;
        b=zs93dnlSjcUn4dLQB+g6ci8ONcSB0OIicGKAzFwOUdyOsiP2BdN41xzDl61zm1aIfS
         MrbaAZ83KiZvpBhw/t8DYv4NJMVCyBQpeCN5MD0CRzOfsHK5E0rEuw+7g30IJlxCu1o1
         7mme2lJfGROMTjOYj4QSOqP/j6D7KtoKzQLkJhrcS+SPNUWMmwxYQzPBqdFNS0k33TCR
         4Nh97pBdxldwyd3IpdVJ2t0JOwuODBwgAcCU0lv8Wta/TDD2+zqVY32YHRsQt6GBI+Qn
         RHm6LFVNL8Ch8KR5aJf4uABPa83sVpCdfQprlonnJAJTgRRPjEO6pZ2NYvDmDU5Q3iXK
         crrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8ypp6pe8QM17Jwqmwbse8rVyoiw3G1CJobst9rhOM80=;
        b=RCUpXagENg3ztPspw6ooiq0SWZfWwVioDi1c1iStiW0bWxEVKNJZnTDJKUIg9Yh90n
         JNfSxA5onxivVbM6jEwH3vzLvCvGpk74jEvIF6JkyNb8bil8ysntHIEDTEfkO4ywgOO3
         Q9/34PkJR2qGR73lGwMB6+sU4pB32XGRtQixdcSHm7is0phtLCxOJY0YGh0IZ+4cxzx/
         xkCEKQWyxJD3N7oMZOeHOLVrHo/wAl79169QyBRXLJWho/hudqPY4NwGT77orMIYRJMI
         8wZ3/Bs4zWQt+lW9bVlhur/E2gC7//cMiPZ43beH7NoKUODiWddu9NHiPOcvrFP0yLJA
         xTxA==
X-Gm-Message-State: AFqh2krX38ZtuaQ4A26xFAltD3H97iBaUtqDHYQ6aORnGpQ7aSFA6UD6
        JoXZP7Vve974CQnm1NG/Do0ERg==
X-Google-Smtp-Source: AMrXdXtdSvODhtUpSoyKwK3n1xKvFNIcvBBe+L4SGuQu/F2kyOp5m5g+9A7T2S/Kngi735fZ40A/xw==
X-Received: by 2002:a7b:c38e:0:b0:3d3:4ca9:240 with SMTP id s14-20020a7bc38e000000b003d34ca90240mr37429194wmj.33.1672826755095;
        Wed, 04 Jan 2023 02:05:55 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id x7-20020a05600c2d0700b003c6c3fb3cf6sm43495715wmf.18.2023.01.04.02.05.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 02:05:54 -0800 (PST)
Date:   Wed, 4 Jan 2023 11:05:53 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com
Subject: Re: [PATCH net-next 07/14] devlink: drop the filter argument from
 devlinks_xa_find_get
Message-ID: <Y7VPgXHep5We0TQQ@nanopsycho>
References: <20230104041636.226398-1-kuba@kernel.org>
 <20230104041636.226398-8-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104041636.226398-8-kuba@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jan 04, 2023 at 05:16:29AM CET, kuba@kernel.org wrote:
>Looks like devlinks_xa_find_get() was intended to get the mark
>from the @filter argument. It doesn't actually use @filter, passing
>DEVLINK_REGISTERED to xa_find_fn() directly. Walking marks other
>than registered is unlikely so drop @filter argument completely.
>
>Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
