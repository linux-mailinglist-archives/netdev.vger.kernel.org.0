Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 513DF64D913
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 10:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbiLOJxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 04:53:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbiLOJxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 04:53:15 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD92D5C759
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 01:52:40 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id i7so2444611wrv.8
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 01:52:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=045EsEd0cH3SshhPqyJbNYnwY7NiytO6jJjQ/uOYzmU=;
        b=VU8Hn2DLQFcyneBB0XOKW/0LxRkcnGXZ0U4K0k3SQuu/DtZkaR3ZOfsQUpQxH1fQSo
         nssyGm8E3Au1cwXrgcu/4sPW+zzCRMuHRwQz8TLZC+vEYMqRAwiTKuKkb/5cd6JyKjRM
         asqgO7Ph+a06oKeppmh224QSCmbcYtqMRlSQIfkh06p554hqEof2FnW8qgiFzCnAgWxh
         ARNd7jeRTUbMiDbGusLQ66yYHe3LNfmIh/qMFLshN1gSgzhBm8OKh8XbSe9m2avoqjVk
         yg/CqTwgRinlZZMwWbzIe0rlTwhV2UuQEX8MGrVut5voEAqsnTOeW5hqjsLXdsCBmuZQ
         iDqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=045EsEd0cH3SshhPqyJbNYnwY7NiytO6jJjQ/uOYzmU=;
        b=QmU4Nd1R2uG6sEgoM/HJIto7t3RRCFEQ3yw5OxcQ3YGk/sXMpaOpWMVDZYcxAni4CC
         DDw+j/4l+8Kg4pz+R4hZQIaHWk/9+6TZ+1trZ8kzAMhzD25a9ls2m1WzxX8df3NrsL5a
         t8b08dH6knXDe6+RW0UY76kgwu4txeqUVQlQPIqMLcLK5pM5Rn96CjgvbeaOGG5f1PHW
         QqEJVWNWb4igquh1f11jHgWME0gMDsVlkZG6OgipKxBkC+y4NC3ZMUdDHfIBCEU/y/vo
         vwDFk/xiayJB1cjbn7fsCfqR+CkzdLwR86G4C0uMZVVNmeyu+3FO/WOi8qmx6RbC6W4N
         ZXuA==
X-Gm-Message-State: ANoB5pkRQZFeqA36Y5UxXHWrD91McY4nD7UGsyHq1CxoTz8kcwsAdsND
        ZeqgNomrcdjqLzUvnSFiif9Kqw==
X-Google-Smtp-Source: AA0mqf5dQ52etYjqPGK43LHkqhK9pn7HAaG15+5LtCGSUxe3yizYZFQKwOviU9E+yhVSjw9FHr+2Tw==
X-Received: by 2002:adf:aa81:0:b0:242:2436:bd05 with SMTP id h1-20020adfaa81000000b002422436bd05mr16836820wrc.43.1671097959302;
        Thu, 15 Dec 2022 01:52:39 -0800 (PST)
Received: from localhost ([217.111.27.204])
        by smtp.gmail.com with ESMTPSA id h1-20020adfaa81000000b002366c3eefccsm5372858wrc.109.2022.12.15.01.52.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 01:52:38 -0800 (PST)
Date:   Thu, 15 Dec 2022 10:52:37 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com, leon@kernel.org
Subject: Re: [RFC net-next 06/15] devlink: use an explicit structure for dump
 context
Message-ID: <Y5ruZei/Pd9rb/pi@nanopsycho>
References: <20221215020155.1619839-1-kuba@kernel.org>
 <20221215020155.1619839-7-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221215020155.1619839-7-kuba@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Dec 15, 2022 at 03:01:46AM CET, kuba@kernel.org wrote:
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
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Neat.
