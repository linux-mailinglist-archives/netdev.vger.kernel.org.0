Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C55CC65E786
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 10:18:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbjAEJSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 04:18:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231820AbjAEJSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 04:18:01 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF58544D2
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 01:18:00 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id g10so13747131wmo.1
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 01:18:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KM02Z82ayPTmyCcu1IUBL25KIS72F30osTwR/ji70F4=;
        b=S8Qid32Dsw04OPK8sJ+hfKKSo9R2KqwOoIhSdZX2W/09UfyREX/p6sLyMze+ljCWIL
         uRNODTLR/XMf6o4i1vv4+URLYTV2XwvfjeQkA3Xfp4gYTS+CTRQM/tvGwe4jV35qzonU
         7r/ksNEM+R7wB30wCZqrH7WfcbwMMP6/tmw5XbUBOsCC5PdkXiRvkaqCRk99pi1chaVL
         MofEPqv6UfITxPbBJ0a+pljOE2VcojvtTBiwZUVYFOVtpx6SZ6EJfjw/1WmV2ttx0bJ8
         ElMCLVqibrqkNkOsIOFhLRBMCdG7QTke97OwViqiuvSeSEFs+69hnYhf6b47Qd5/2xY3
         sdNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KM02Z82ayPTmyCcu1IUBL25KIS72F30osTwR/ji70F4=;
        b=BDU850zvV+IaHRiQ6QYtWIHqf/ft4I5D6Sgrf+8ZKLbTBzSQSttKyYKzkXdpbxfdq+
         fd30XF3/vHW7VAN6DSeNA1h5Cui0mzvXg7pBh8yh1Sw/IDy/EpT+uM2gx+Bm/sMu8eFF
         7sudKMF6xeN0zT4CDJ+EXgGvCTy4vhi5WusQj3i1yF/6L3rmz89xzdwNNZwPRSRs4os+
         aGvU4pQsEmfEYTBLDGffO7iHKX1Suue55igQ378aWP/AEBzd0ItMV/GkKhtlZbFUo5UM
         2hoj6MowwR8PpU+rO+U8Orym5Q/2jt4gYI3NdTYF1Om7CCaQ9rlF9QQaqaWkreakJkEq
         6lUQ==
X-Gm-Message-State: AFqh2krvIfE2tOYDOU5gjzZEmhXasaXOswiiWq/ZindItAL9ieeI2zTS
        3OKN+xlTCRAZX1BVu/bLacP75A==
X-Google-Smtp-Source: AMrXdXvbzhD/vS+tfT0jok06+RwH/tRC2dwklzsOfS7Lfc7cCH7S5jtrZq/pKNsgw8iQGnXWG079PA==
X-Received: by 2002:a05:600c:3509:b0:3cf:93de:14e8 with SMTP id h9-20020a05600c350900b003cf93de14e8mr35025466wmq.39.1672910278950;
        Thu, 05 Jan 2023 01:17:58 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id ay14-20020a05600c1e0e00b003d9a71ee54dsm1710705wmb.36.2023.01.05.01.17.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 01:17:58 -0800 (PST)
Date:   Thu, 5 Jan 2023 10:17:57 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com
Subject: Re: [PATCH net-next v2 06/15] devlink: use an explicit structure for
 dump context
Message-ID: <Y7aVxVrJx5nrq0Qs@nanopsycho>
References: <20230105040531.353563-1-kuba@kernel.org>
 <20230105040531.353563-7-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105040531.353563-7-kuba@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jan 05, 2023 at 05:05:22AM CET, kuba@kernel.org wrote:
>Create a dump context structure instead of using cb->args
>as an unsigned long array. This is a pure conversion which
>is intended to be as much of a noop as possible.
>Subsequent changes will use this to simplify the code.
>
>The two non-trivial parts are:
> - devlink_nl_cmd_health_reporter_dump_get_dumpit() checks args[0]
>   to see if devlink_fmsg_dumpit() has already been called (whether
>   this is the first msg), but doesn't use the exact value, so we
>   can drop the local variable there already
> - devlink_nl_cmd_region_read_dumpit() uses args[0] for address
>   but we'll use args[1] now, shouldn't matter
>
>Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
