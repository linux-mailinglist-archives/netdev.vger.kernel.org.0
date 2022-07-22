Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A042257DF28
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 12:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236759AbiGVJsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 05:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236120AbiGVJrf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 05:47:35 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB88C87F4A
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 02:44:44 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id j29-20020a05600c1c1d00b003a2fdafdefbso2175027wms.2
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 02:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=E9vcJOsdgIjAaSy7NpDkCxTaNhk4Fnyk07v+Af9hfNE=;
        b=UEVG9Ul1xV/Pi8+g7CCXwS9rnlt6WG8ar3AAD4WdZyE1jBcnoCLRP7L//NwI1kDL8L
         ubkFn4w+A7gfw/jnePpdWNkyaKeVPZtHm9VeLeYZZg+1kQHF+pF7jLCensdI/IQTHJW+
         IpiWa44+MFFgE7ucY8Mr7R2I0+69GyzFe1Y0OwTFvG1k7qj/etUWvzjrFIcbiuYUXGzm
         QpCV7MFS0hT/5Ln5hXe9baEHC/e5s6zldmt+ypoipKD1yZbVtoc3Yt6jcy+aVP5o3/SJ
         949wldqEwP8CTzoiiLuCmBHUOubfh47MIzwKABM5FOoC9dNpZrZ8aDK/G81I7fNuQlTr
         ohPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=E9vcJOsdgIjAaSy7NpDkCxTaNhk4Fnyk07v+Af9hfNE=;
        b=H+5NTeZQiPX8B1YHfV+78GGw7W5q4EczBIzNewFWYWjED6iyPcoF8GnVy9hQYAX6C4
         DJWkC37dEitnw/yNUQNEYOeRT9sfvubhLgGE8ZTi1oWv557DIs/2ZID9vFc/Hz9MPZjT
         uTYmbPFAgC6bN/wwEwu2yntSwoDmvBII9JSZCP0k7dPwte3arU2YejM3niFb/kbGppMk
         K0Gdn/zI4ZNxjv9W4vipPnCitk2D8HAMOD4FPlV/AJW/xt6TLOaHYQRs7SRhdwzJXWx2
         A5rhEuElGTWcctJw4h96BSfrAunp4JurqUpHIHHx0qikX7KQfQKV4AbAT2bzC4NOEZdR
         VYhg==
X-Gm-Message-State: AJIora9E91TDdgCDZLzT/uP+2Fk4GzHKPFmlDuuDRx2v5HSfRh2eI3Zq
        QWEG3DOu7fsnScsPVWDeqA3jrw==
X-Google-Smtp-Source: AGRyM1vZwQho/B7YCxdtN3ZF7W1s7uvwXdN7oMnRkFhmKYK6vvky9qhPo/N4v8mUEX38XsEEorD8wQ==
X-Received: by 2002:a05:600c:198c:b0:3a2:b440:ed46 with SMTP id t12-20020a05600c198c00b003a2b440ed46mr11773857wmq.110.1658483082901;
        Fri, 22 Jul 2022 02:44:42 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id h7-20020a05600c2ca700b003a3253b706esm2417230wmc.34.2022.07.22.02.44.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 02:44:42 -0700 (PDT)
Date:   Fri, 22 Jul 2022 11:44:41 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vikas Gupta <vikas.gupta@broadcom.com>
Cc:     jiri@nvidia.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        dsahern@kernel.org, stephen@networkplumber.org,
        edumazet@google.com, pabeni@redhat.com, ast@kernel.org,
        leon@kernel.org, linux-doc@vger.kernel.org, corbet@lwn.net,
        michael.chan@broadcom.com, andrew.gospodarek@broadcom.com
Subject: Re: [PATCH net-next v5 2/2] bnxt_en: implement callbacks for devlink
 selftests
Message-ID: <YtpxibOCEZrx0KYF@nanopsycho>
References: <20220722091129.2271-1-vikas.gupta@broadcom.com>
 <20220722091129.2271-3-vikas.gupta@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220722091129.2271-3-vikas.gupta@broadcom.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jul 22, 2022 at 11:11:29AM CEST, vikas.gupta@broadcom.com wrote:
>Add callbacks
>=============
>.selftest_check: returns true for flash selftest.
>.selftest_run: runs a flash selftest.
>
>Also, refactor NVM APIs so that they can be
>used with devlink and ethtool both.
>
>Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
>Reviewed-by: Michael Chan <michael.chan@broadcom.com>
>Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
