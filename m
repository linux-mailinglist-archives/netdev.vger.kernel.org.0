Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BCA5583AB6
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 10:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235243AbiG1IxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 04:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235297AbiG1Iw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 04:52:56 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56666655A0
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 01:52:55 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id z18so1294919edb.10
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 01:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YD6NPTofpdb/OrV3lCoLvgZH39SrPlv9LDKkq27yBCM=;
        b=oIGxfaWcIK+hri1iHnKvFAesDsOuKPk0Myl06X68CL93PRk2wQPtuG9zPOvIUx15Eh
         hqu0jwxKwXrrTZS9bj2jbk68OjG29FixhiqoJx88mykK9fDbu3xYoPY15znFaa17EzGw
         mhZZZ2JOUHpjPI8Ci5PMSCOru8HFIRHlQj73+WBTSjw4nCVILqj2LvdGJeEdepbEM87d
         bCw8KtxG0w38dYbyPSYU5CoNmzhFk32JW2zZBqDACm5cUTAdeoVMImQy7pzxY1lQGi3n
         nidIbtD3QCo6ikc4AoKyctg0cavpUoaLUBM77gBXItaoWeBzUrlQSDYzvyhpiY+Vyddy
         euVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YD6NPTofpdb/OrV3lCoLvgZH39SrPlv9LDKkq27yBCM=;
        b=kQwHZQJXAAIgs+bVT010PBDeFtn7R4ZMjGCid94/BpNnTuJ14H3iSlBOGx3bHN2wjW
         ih7MDZBKLNJ+NWOubM5SftsDNnSxWkgk5Ef1R0OYKqZfm7LCkcjo+dcFLoAV+TfJCgPq
         5KB6Qk3NWWdl2Ileb9DshCsBJQZ/rYJKRUJRzbS1Iz7DhEOlIULWHuJzX0s2ySsWLpep
         yGtmWnzRFHUFDDAJH0f21v+GMYsF6Bxja/WT3QEDlMYkUKuQuzV3rFoBLX1V0m2sr4EM
         JJ163i+8PrALummtIuEwupdKPyqL8Syc6eiCltE6hHfwy3U8i9HOD98mJKn8DWZSVyuI
         yEGw==
X-Gm-Message-State: AJIora/2UX8Wdvsaa5PIJOSSt434XdVIG5F9gXstVlxitcrz95m/vYv4
        7L60LIebhEsbiJAli0rkKC7kzQ==
X-Google-Smtp-Source: AGRyM1vy2El5ArOcpspPqyD6vzOa5X7VJhcpu8WOInv6X1q+4q5Veo+8cXQ8oYn1ClPZ/K6NkC2w4w==
X-Received: by 2002:a05:6402:5201:b0:43b:f621:3ce0 with SMTP id s1-20020a056402520100b0043bf6213ce0mr19966419edd.22.1658998373818;
        Thu, 28 Jul 2022 01:52:53 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id h5-20020a1709067cc500b0072aadbd48c7sm171996ejp.84.2022.07.28.01.52.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 01:52:53 -0700 (PDT)
Date:   Thu, 28 Jul 2022 10:52:52 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vikas Gupta <vikas.gupta@broadcom.com>
Cc:     jiri@nvidia.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        dsahern@kernel.org, stephen@networkplumber.org,
        edumazet@google.com, pabeni@redhat.com, ast@kernel.org,
        leon@kernel.org, linux-doc@vger.kernel.org, corbet@lwn.net,
        michael.chan@broadcom.com, andrew.gospodarek@broadcom.com
Subject: Re: [PATCH net-next v9 1/2] devlink: introduce framework for
 selftests
Message-ID: <YuJOZC5KjH1sfNov@nanopsycho>
References: <20220727165721.37959-1-vikas.gupta@broadcom.com>
 <20220727165721.37959-2-vikas.gupta@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727165721.37959-2-vikas.gupta@broadcom.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jul 27, 2022 at 06:57:20PM CEST, vikas.gupta@broadcom.com wrote:
>Add a framework for running selftests.
>Framework exposes devlink commands and test suite(s) to the user
>to execute and query the supported tests by the driver.
>
>Below are new entries in devlink_nl_ops
>devlink_nl_cmd_selftests_show_doit/dumpit: To query the supported
>selftests by the drivers.
>devlink_nl_cmd_selftests_run: To execute selftests. Users can
>provide a test mask for executing group tests or standalone tests.
>
>Documentation/networking/devlink/ path is already part of MAINTAINERS &
>the new files come under this path. Hence no update needed to the
>MAINTAINERS
>
>Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
