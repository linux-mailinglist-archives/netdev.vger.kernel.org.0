Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4387656413D
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 18:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232335AbiGBP7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 11:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232336AbiGBP7T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 11:59:19 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7BD4BC2E
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 08:59:18 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id q6so9045524eji.13
        for <netdev@vger.kernel.org>; Sat, 02 Jul 2022 08:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Zu87SdJXqRm3fqzawG/X8olpzVQrP5DI7IILYqr7ICE=;
        b=3SV0GCYhCQdw6EzJvdotwzNYVyf1y9VFjUNHCNWXY2qMXAzdZ8VBSWo36WmfSM8/Ov
         Swpf2H27Tr/mLrN9RUqBPgBm28rCsWwhqFPJ2LXeVqcOuAKtgIJE2KADbpDGC+AFP9JM
         yo+PWORVob1ZJJIEkdutJg5pAYAatkQ9itcD1GgSpKddbApiHzB3CMNfWv0h3KSiUq9I
         Bjil8qCR3JfEpToVBV7n6rIr826+8yHIgtha8E5Ba+KBunEAJ7fq51PR2opAOchf9VeN
         EEwt8bYhMIe+v7A9cH4YeKhD7DNVaYYEQdrehxf9Bg4+2YkfYyc/J/HyD0Ecig2PlgUc
         XvbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Zu87SdJXqRm3fqzawG/X8olpzVQrP5DI7IILYqr7ICE=;
        b=7O/tkjLO9qhvHoECh8BPpkn2jWzrMQ6txdCdIAM0HW818ZP264ertZ1/S0Yp/aqvA9
         124ysNyn/gjZ12Lqv/LkzIK0Yq2+b06uXKIvTuceyGpVXo62ttVAOzCdUqY/mWdFmtAf
         3t8F1HG/ejgG6cz4Gnm/0T25zL9J4RWoHXtSJI8zbtqEjVsjQUp3N7HavJlWqkUDIWoI
         BAqLGlXHetWx5lyNUcIYShf58fzJYKZq64iDtZY+gho9dvu7AhazgSgmNXsvJiT051ef
         /RJAcW8eEpPaCv3Z2PWn959OoWm0CW2FNq5CZEvIy/Vkm04XHpqpE5T/sA+G4zCBPhhd
         HvtA==
X-Gm-Message-State: AJIora9dHmyccgjHhT0YejncX6Pycx1xVRlyYwg3mC9iedZIA795e6W+
        tRbRTm/hQuAOEWZ75Uhs8bVcoQ==
X-Google-Smtp-Source: AGRyM1sIJ8wbAD0rKoFHTR59MEW2UClqHX1wwWQL9VgN7KKj4rwHmB0zwPRuRtMrAdLU7NH2nzeNkA==
X-Received: by 2002:a17:906:149:b0:712:c9:7981 with SMTP id 9-20020a170906014900b0071200c97981mr19215326ejh.218.1656777557275;
        Sat, 02 Jul 2022 08:59:17 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id k14-20020aa7c04e000000b00431962fe5d4sm17230613edo.77.2022.07.02.08.59.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Jul 2022 08:59:16 -0700 (PDT)
Date:   Sat, 2 Jul 2022 17:59:15 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, saeedm@nvidia.com,
        moshe@nvidia.com
Subject: Re: [patch net-next v2 2/3] net: devlink: call lockdep_assert_held()
 for devlink->lock directly
Message-ID: <YsBrUxF4ZDMMK7li@nanopsycho>
References: <20220701164007.1243684-1-jiri@resnulli.us>
 <20220701164007.1243684-3-jiri@resnulli.us>
 <20220701201021.400a5a83@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220701201021.400a5a83@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Jul 02, 2022 at 05:10:21AM CEST, kuba@kernel.org wrote:
>On Fri,  1 Jul 2022 18:40:06 +0200 Jiri Pirko wrote:
>> In devlink.c there is direct access to whole struct devlink so there is
>> no need to use helper. So obey the customs and work with lock directly
>> avoiding helpers which might obfuscate things a bit.
>
>I think you sent this as / before I replied to all the patches.

Sorry.

>Still not sure what the basis for the custom is.

Please see the reply to your comment of this patch in v1. Thanks!
