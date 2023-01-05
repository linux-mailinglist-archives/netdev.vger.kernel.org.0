Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49EF965E788
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 10:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232107AbjAEJSf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 04:18:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232000AbjAEJS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 04:18:27 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F6A650E50
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 01:18:26 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id bn26so16011588wrb.0
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 01:18:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2cijFW76Y08K/Ke8ea4D8/Y9Kexw0dUxz7+vv/bN6Tg=;
        b=b3ROOcR+PmyUgnfAIekj0+Nr2cWJ89Hw9fflIFwHb70hTJ7YvBuk5mHVJDZShMRmSk
         a3y+879Fu97i50XDof0EKnWH83WY0wBofJFBvQjZ25NiBiulzSZCGX0qqkr9jnshBS/a
         mhqgalUkdq8vB5XdcGWNxMQVFHk8OjrIwj/KwoimPFWTyi9QYGde9s6a8dnSwC2Hc0jv
         ZjHUyQRfHAro4G/EDaoxyuDzusukSN6us7NfMFIR3i61jkf2TbPqh1wq2DJJt5bwH+Oi
         GO0FLGhWl8IWeaVffMRKT0qLj1Ah5Xs4v8dbYfBQTKCubM5OYGe5KdXmWCSL7oHIkUkJ
         xAfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2cijFW76Y08K/Ke8ea4D8/Y9Kexw0dUxz7+vv/bN6Tg=;
        b=fXLn8CuiikZIH1cvf3u9f3jeAIkoayIkb+C+FdNsdyE28Fi8WHupLcWbtwtUWHFxke
         0TZ4u9WpTbHx2iKqHKiTJU+QpGBkCQ+bNl7cMtMC5T8FrkV5ZqjVkLjIOYsUx5w20b6Q
         6Uex9bqQPOFvO7BqCjALLSrjBO2uSuQVJUNNVl/V+RMgQKuhcfk4JO6WWSOQV8EcLK6v
         vlGni3tIclcPssl6Jvs92gV3dOKJ55kSQ82MvsAEINZY9Ap0SQUI/AuS96oSxLM8oVMO
         dG7VYh6NEI28g7v3Y59uJqZZNUHfdE8LMpWVqVz3rAt69sG3dh9VLChx0M+2zr4AUCFX
         Hm+Q==
X-Gm-Message-State: AFqh2kpTmn25eg1/3hmMymJv3EgTiEU+JnL4vwjHGMkSBWrPHFv3uYps
        87xUm/DEE583aRE5gG1ijoh/NQ==
X-Google-Smtp-Source: AMrXdXsRpFf2dJBNGhezkVl7qPijb+LQCwDiSF8C38oPMVZXF33Fk2SzQLEIy4Yma0OdhaxF5ieP7A==
X-Received: by 2002:a5d:6349:0:b0:2b6:320e:45a5 with SMTP id b9-20020a5d6349000000b002b6320e45a5mr141695wrw.29.1672910304744;
        Thu, 05 Jan 2023 01:18:24 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id e16-20020adfdbd0000000b002362f6fcaf5sm35921301wrj.48.2023.01.05.01.18.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 01:18:24 -0800 (PST)
Date:   Thu, 5 Jan 2023 10:18:23 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com
Subject: Re: [PATCH net-next v2 07/15] devlink: remove start variables from
 dumps
Message-ID: <Y7aV3923AVZTxJKa@nanopsycho>
References: <20230105040531.353563-1-kuba@kernel.org>
 <20230105040531.353563-8-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105040531.353563-8-kuba@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jan 05, 2023 at 05:05:23AM CET, kuba@kernel.org wrote:
>The start variables made the code clearer when we had to access
>cb->args[0] directly, as the name args doesn't explain much.
>Now that we use a structure to hold state this seems no longer
>needed.
>
>Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
