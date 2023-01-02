Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9A7F65B456
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 16:40:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236236AbjABPjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 10:39:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232151AbjABPjy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 10:39:54 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98BF9BB
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 07:39:53 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id az7so2200389wrb.5
        for <netdev@vger.kernel.org>; Mon, 02 Jan 2023 07:39:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yMroW05oFhzknL98EQCsQ+SYSzTJ+LrSISoJgrOG1c4=;
        b=z6lnklFSzA0EUtdobeGYXiDOCKMR83l8jJ5DsNGAUKi0waNzUooYubwdcTs3pe5VVB
         9wGgFoHpBJXkvb9uCDCtHuhnqyYYQ1UXWu7zgGQMn4ki2w212Iz9sPYRJy/8tbD4h5Zc
         0Fq0NEgUwH0WA2H5bBzCS4BkvR4+3F5lgSbtoirwyuhuFeLJCLjhFHagaITMSHi5LN0G
         K69E+HsNzg0S28aO7qdYPIbL9+4Kz3w7ZCvsdzzovupAZWp7si7RhlBH4U598c41myEh
         WIXx2CsE6cZWP42xWUFNN/L6zU1to+73+sbv/Z0xVTu88f68x6iu7R79GSAvdrCnBXEc
         hnmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yMroW05oFhzknL98EQCsQ+SYSzTJ+LrSISoJgrOG1c4=;
        b=liQO5q9BLbZBFH4v1lpwJ5jFa/WKs0dJgtkcuOmuFvgLOBPObFnVTrMdL8Dvu1yEhn
         jlFDX9RSCUbGAobdU4USa1fdWoSFh6OCSy9Vks5BT0mQsK+mpS0YmywoLv96LOcbQRiQ
         /WMnZTi9lS1pNLq9U5r/Tjp2Z30v2kv+qfbz3mjCFmnW+Z8dODdeL5Id0RZ495x1YCBo
         9LF3sbgL06EM57I6kehJXMC+VjzXTxl+m/Ucdoqn945u3sOSEVcFEzf3BbytZXm5zby1
         Hd80ZjDp8htaxGciuQUdDd04ZHy75bIvALMpLahTbPnXjmpzw05H9VVtevHOZdEYVcsd
         6SFA==
X-Gm-Message-State: AFqh2kodshO+uGI66Xht38qThIbbU2YWdjAqV6vAbzaND5iE67Gl2aF6
        g/6M6j/zxgPqnQyZW3/V6gXkFA==
X-Google-Smtp-Source: AMrXdXt7BEAS/UD6tVnAMFCTIvKMlxBXfdrbEMQxwT2ptAJu2hH0NGuN+4l8xPhfnxBWa97PDxnFUA==
X-Received: by 2002:a5d:4b06:0:b0:28a:87f4:b21c with SMTP id v6-20020a5d4b06000000b0028a87f4b21cmr10061768wrq.32.1672673992182;
        Mon, 02 Jan 2023 07:39:52 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id c4-20020adfe704000000b00241b5af8697sm29097757wrm.85.2023.01.02.07.39.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jan 2023 07:39:51 -0800 (PST)
Date:   Mon, 2 Jan 2023 16:39:50 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Daniil Tatianin <d-tatianin@yandex-team.ru>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net v2] drivers/net/bonding/bond_3ad: return when there's
 no aggregator
Message-ID: <Y7L6xl0Xa9KhfG2Z@nanopsycho>
References: <20230102095335.94249-1-d-tatianin@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230102095335.94249-1-d-tatianin@yandex-team.ru>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jan 02, 2023 at 10:53:35AM CET, d-tatianin@yandex-team.ru wrote:
>Otherwise we would dereference a NULL aggregator pointer when calling
>__set_agg_ports_ready on the line below.
>
>Found by Linux Verification Center (linuxtesting.org) with the SVACE
>static analysis tool.
>
>Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
