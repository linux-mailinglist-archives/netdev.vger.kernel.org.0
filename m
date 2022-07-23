Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF20757F029
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 17:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235470AbiGWPoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 11:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234210AbiGWPoV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 11:44:21 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A022018F
        for <netdev@vger.kernel.org>; Sat, 23 Jul 2022 08:44:20 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id f15so536339edc.4
        for <netdev@vger.kernel.org>; Sat, 23 Jul 2022 08:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZLdA2ERQ47Gn3HeVkfGSNgKMTZe+t4pJKXQ2WTQOOxU=;
        b=yFXoJQGXAJOOu/GppNHyplycfD7PJ8WiPXv+SLcTIZ9Ye/Q8M+KR+b4u8fe36+8YgJ
         fZSbtrfeaiQZEU0lQSbJNs/Ucs9y7TLMLJEewW70DqaKmPO1gFjV7Tfmvs/i3ABAVVmL
         sHYcoUgZq5d9kr+xWbg+1lv+Fbk1Sn71c0rytbbVYTTwua0COJyunVreOhbUW3OU1f6F
         T6Jhaz0+Odb76y6pk3qEzwBUVZZxPpT75v6J9cqwXymSfetIUTgTuYLeZjXtUBqvrJXd
         trEfX+25fk3hmgPaaMmqV2XyJUAcTzMlMWWd+fr66pNMN1dCfVyA5x9Ze0L50oEBeEyx
         P3xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZLdA2ERQ47Gn3HeVkfGSNgKMTZe+t4pJKXQ2WTQOOxU=;
        b=2Y1RCAp7waCN9yCOO4jqL8LFz3xcpeWuSQlhXwjBVZoVzKYR7YuVI08dJ4/v1hJEMu
         iT6bd1eHz2SvtPqEKhEsSGPQ+HNpR3DgKek9HCCzTZYnBJwts1sdUAPzQcda5unox8MQ
         ILVJhQkofwDG/F/r1X3mPV8vX0I6E54hlPwMbbiu+48ghLwbsEM4tKGomP4lSxEmbY/w
         xOhY51WMDcJbL8KJumvvZ97AK6MdlcwegWMibxKS/ukh31n5Q9qFtFe8sgPCHDQx2ol1
         RsaDA11wSOXVIsDIpeVsMBn52z9nwqxT0waK29h2SuraooUdOnNxFciKVeokLDrWMDsx
         25hw==
X-Gm-Message-State: AJIora/5HLJwMjru7cPJChLmTifbHv4Sk0JlaSngNYdeaDhv/RYSCsWo
        6yrQwtIefEXu5B6BWiyj6TA7HQ==
X-Google-Smtp-Source: AGRyM1sH46+f4ZuygWDwVwUeumRtREqkUCaziINFnSXqvd44fjFzzlqKiXZOOwXhwAVMNq4rFutTYQ==
X-Received: by 2002:aa7:d847:0:b0:43b:d8af:afa3 with SMTP id f7-20020aa7d847000000b0043bd8afafa3mr4558674eds.247.1658591058771;
        Sat, 23 Jul 2022 08:44:18 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id nc19-20020a1709071c1300b00722d5b26ecesm3251129ejc.205.2022.07.23.08.44.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jul 2022 08:44:18 -0700 (PDT)
Date:   Sat, 23 Jul 2022 17:44:17 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vikas Gupta <vikas.gupta@broadcom.com>
Cc:     jiri@nvidia.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        dsahern@kernel.org, stephen@networkplumber.org,
        edumazet@google.com, pabeni@redhat.com, ast@kernel.org,
        leon@kernel.org, linux-doc@vger.kernel.org, corbet@lwn.net,
        michael.chan@broadcom.com, andrew.gospodarek@broadcom.com
Subject: Re: [PATCH net-next v6 2/2] bnxt_en: implement callbacks for devlink
 selftests
Message-ID: <YtwXUZyk4g3JJO3I@nanopsycho>
References: <20220723042206.8104-1-vikas.gupta@broadcom.com>
 <20220723042206.8104-3-vikas.gupta@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220723042206.8104-3-vikas.gupta@broadcom.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Jul 23, 2022 at 06:22:06AM CEST, vikas.gupta@broadcom.com wrote:
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
