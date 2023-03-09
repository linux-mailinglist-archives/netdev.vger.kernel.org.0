Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2436B200A
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 10:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbjCIJaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 04:30:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbjCIJaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 04:30:19 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CFA1231F1
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 01:30:18 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id cy23so4304140edb.12
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 01:30:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112; t=1678354217;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+5GJN8BZeSAMwWXzGvcfLbjVojpW6gFlX9NTLj8w0Y4=;
        b=RDSzAFWJ+qSIw+EFAFCEbu1W67yvwt33G4JxsmMapFqRlG3A+awCyjkx86KNwsBLpd
         6TB987lUEtWvKv8eIRq+KtGXnP3HF1j9TtvGl2QWfrGb9SFqUkiW5Ysxr42aqu+lIBxE
         nn7nSFmTbzgg5g+a8/u0nieiLr2wVViHkJuW2dB3RyWYTl3MWsyWb1IFGsDzMrSPP7ie
         BkXNDPgqloCpJVZcQaCw5ASEIHyjDLvj1vHbbUNmbivrPQ+0ae3mdLp/0H3ffmAgiBfE
         kbbnXUM+YRptwVYNg6Jv55bTZyz69qkowrkNJEEBo0UjWVQHiI+09kL10OaREFyLZhk2
         CgHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678354217;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+5GJN8BZeSAMwWXzGvcfLbjVojpW6gFlX9NTLj8w0Y4=;
        b=J++Ze7kpSUt+Z1D4FmmAHE0LCAwCWmVTnDHFPoSVWat5Z5ObYa9jLxXAaJ+qp9yT08
         CakrC6XAjrvF7ZW4uxFQ0EqzZ0WQTLmREprm9uTJWVWsynbEKoky6qSAFEgSWwVwDre9
         n08MPz5GcHPwmnSbd+wZACcVByL2MiRVtJSMjaERJNdUm1se7TLuIgJhpyyqKXwXvXsN
         u5BYD3n5jIK74m62xTRSz1KO73RGP2LZztRNg8TBWu0c8KSxmd4ZeC+zRQMawYqaytqg
         6zA/aDqGK99v0EEOhEY2p+9dk7UJkZX4Yr2RCrlwK132J7y8170ne3HxuMdzZJtzdFS0
         J9WQ==
X-Gm-Message-State: AO0yUKWjqXS7MiNzPMmL0zUTuuIpuUf+PJjzrEbjI4QeSTUCdjDKAMD2
        7dfitz7V5pjeSfXn8vXA9jKMFg==
X-Google-Smtp-Source: AK7set9SpcOUeCxmf8vXypuxHawhAEezKQIRhP/vpL0fr9BAteYoECEFdugpZ2c9cTTY7rPEtTMW9w==
X-Received: by 2002:a17:906:3bc7:b0:8f0:143d:d67a with SMTP id v7-20020a1709063bc700b008f0143dd67amr20105805ejf.63.1678354216648;
        Thu, 09 Mar 2023 01:30:16 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id l3-20020a1709067d4300b008e54ac90de1sm8542530ejp.74.2023.03.09.01.30.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 01:30:16 -0800 (PST)
Date:   Thu, 9 Mar 2023 10:30:14 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io, leon@kernel.org
Subject: Re: [PATCH RFC v4 net-next 03/13] pds_core: health timer and
 workqueue
Message-ID: <ZAmnJvkAe4vJHRcN@nanopsycho>
References: <20230308051310.12544-1-shannon.nelson@amd.com>
 <20230308051310.12544-4-shannon.nelson@amd.com>
 <ZAhXycSgSiNFwpNl@nanopsycho>
 <64d72af6-66f5-ff68-f7b3-1fffba61422b@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64d72af6-66f5-ff68-f7b3-1fffba61422b@amd.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Mar 09, 2023 at 03:08:44AM CET, shannon.nelson@amd.com wrote:
>On 3/8/23 1:39 AM, Jiri Pirko wrote:
>> Wed, Mar 08, 2023 at 06:13:00AM CET, shannon.nelson@amd.com wrote:
>> > Add in the periodic health check and the related workqueue,
>> > as well as the handlers for when a FW reset is seen.
>> 
>> Why don't you use devlink health to let the user know that something odd
>> happened with HW?
>
>Just haven't gotten to that yet.

Please do it from start, this is exactly why devlink health was
introduced.

>sln
>
