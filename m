Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2172586D11
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 16:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232994AbiHAOlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 10:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232828AbiHAOk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 10:40:57 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66E453A4BF
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 07:40:54 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id p10so10199418wru.8
        for <netdev@vger.kernel.org>; Mon, 01 Aug 2022 07:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=14KOQn3U09Etizd1SZ3pc5DfY9+tF9zMxWV58jSuGuE=;
        b=ln9Otoqf4wEoVRIgdfZr95riVXGLZq63ykvOyiv+nRsT6MXy2pw0qlNiHv/wkKg8VR
         qy6rgo5S0kRmVSJSI8oHq+/TK9IDHrzOdBpMh7NoQseDYEygb5jCpitEs5/YbUvxtYl9
         Wdl7/jFbSDXmtqsBIlqeKGrOnRmp/MS2sN9mbbe2UDX19rieQ9Eq9czDezqyITQaZrBu
         OGG13Y1dXSdGcYKkB4UfByrAaFXUic4Wv1k5L/4kyGvWKa/Bl+SpabJDRHId0rlL7zcR
         hes8/TjC/da/ehnuer1ZmnPG7I8QC2wan9ylugRQoiQEV7Z1cDYYnlFylLmUiohQKlh7
         zfHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=14KOQn3U09Etizd1SZ3pc5DfY9+tF9zMxWV58jSuGuE=;
        b=JTfQds683raMh0yyrL5g04tBJmSSYOBHgObNpGiaK4lY6wAHZseyLiOo+20QqCvR5o
         d46sohGMJSEv0QdwKuVCQ5NoUKcqiV3A3jrMu3W48mldA9D5KIYxFW0Sk+SfPTup9z3n
         xkUQ0fEs0NcSyNj1ZWpIZQ6CWz+WnxFDwnR+LduGn4IxpTgoeO2W12BHT+E/3msAFmE5
         1gnDUMt8NnfJf9rMQbW5QX6kPq1Dq8ZxhVKrCJ2av0Zs+zCHmHSYrdTqF+7h3DefFfjH
         zjZxaJ31wDvOD1T6i1e49bJ4kI9ctNvlF5sm7lmmxN68jtyFG9a7JezE9d9Z7KxMC/tF
         htMg==
X-Gm-Message-State: ACgBeo0roLd9rkpdOuzmOHIJDKJoOm5UTs9Pprb5tS6aScTMMpr77bMH
        kESDC9vrh2HJYVYfSGNGSW/bTA==
X-Google-Smtp-Source: AA6agR6CLIJddHIFsdoRnEoCimzh2cjJp8NBZ07mvCC7qWBoeICAgZyMqz5vnhXXvm6O7FW3ZXd9ag==
X-Received: by 2002:adf:e0cd:0:b0:21f:bb1:21f4 with SMTP id m13-20020adfe0cd000000b0021f0bb121f4mr10665807wri.113.1659364852659;
        Mon, 01 Aug 2022 07:40:52 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id r21-20020a05600c35d500b003a17ab4e7c8sm20525405wmq.39.2022.08.01.07.40.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Aug 2022 07:40:51 -0700 (PDT)
Date:   Mon, 1 Aug 2022 16:40:50 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Moshe Shemesh <moshe@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        netdev Mailing List <netdev@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kbuild Mailing List <kbuild@lists.01.org>,
        kbuild-all Mailing List <kbuild-all@lists.01.org>
Subject: Re: [PATCH] net: devlink: Fix missing mutex_unlock() call
Message-ID: <Yufl8sENNlOjsfwf@nanopsycho>
References: <202207311503.QBFSGqiL-lkp@intel.com>
 <20220801115742.1309329-1-ammar.faizi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220801115742.1309329-1-ammar.faizi@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Aug 01, 2022 at 01:59:56PM CEST, ammarfaizi2@gnuweeb.org wrote:
>From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
>
>Commit 2dec18ad826f forgets to call mutex_unlock() before the function
>returns in the error path:
>
>   New smatch warnings:
>   net/core/devlink.c:6392 devlink_nl_cmd_region_new() warn: inconsistent \
>   returns '&region->snapshot_lock'.
>
>Make sure we call mutex_unlock() in this error path.
>
>Reported-by: kernel test robot <lkp@intel.com>
>Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
>Fixes: 2dec18ad826f52658f7781ee995d236cc449b678 ("net: devlink: remove region snapshots list dependency on devlink->lock")
>Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>

Thanks for the fix!
