Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E27355025BD
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 08:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350586AbiDOGpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 02:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245187AbiDOGpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 02:45:18 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E804AFB10;
        Thu, 14 Apr 2022 23:42:50 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id t11so13859811eju.13;
        Thu, 14 Apr 2022 23:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VLNoF3yabsR2vdbIrvz5ZQp7trjy2rftBz8pJCTD7/I=;
        b=MbYpvg06AwjI69mj6WbULaIcw073cG+ttS9uo5DoZiOQDxWjCFhNSiZIru2IQCjwRE
         /gRnF98GOp5QyL8o1HYf8P1rwk/Bh/DX1eByGXeIUcH+RoxR80YN7bGEf+RXWbgWLj69
         GnxTuiiBJdflKkyMxzIrfT1uwKpffMKgdX5WnUsS7Rc2i2aU7hUONsridAp6XOqskx8l
         yU+1XPwqPoCoW9Ik3TbXM5h4ZC4tSTcBdR0Mb1Ex+qb92zJu7UkJabAxrlO0tw76zrof
         UVy+V312oa13SaC2qE8BfQdSQytJYM0jxSNIjfJ6nCrp+IB2LXG2Y32iFIWRsckSnhdJ
         XARQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VLNoF3yabsR2vdbIrvz5ZQp7trjy2rftBz8pJCTD7/I=;
        b=eo8DFgAVagnbudTqnjdCOKLGKuoliDRP1ZmqrNmI3WEuGpdjYR8v2icxwWZBEVCX7E
         ugLs1CNyMxqRY7Pah1fVGmSJB2EQZxQPaDv+IQQ8m7CyvjMVh8sdgx/C4zeCAICIPaaI
         U2S9FIfI+3pE+HmuFUo6Q+JOtY9UhuWokqMN/Xd91PUHuQUhaySJKBKDk0LP9o2A+Pu2
         UQlLG+3OV0kQx0ZQ5yQQVyfb7z3ZvUz+lPfnDmwZZF5LPRaUBJD2ygFiJTsQz5Wndbcx
         8jF+HQDfIIfqHWvUl4MxYqRu4vm0fFuppyjBLDhsqCdpmIEfUZigw4Hntub7RoJg1wRF
         8xkA==
X-Gm-Message-State: AOAM532jRAZa1MiVgyiWMf0KcgegBD5puCQ0ZmNiutaQfuD/DEFMUXmI
        47ByN4nnmvh/Q40GzRbiAWs=
X-Google-Smtp-Source: ABdhPJxsOe+IpBYG3qCMqBiXjOXWnJ8BeI+1q3LDXRwgce2uW2vnEXvHdtiwn4f53fzfUaPBYvmOXA==
X-Received: by 2002:a17:906:eb42:b0:6e8:9197:f0e0 with SMTP id mc2-20020a170906eb4200b006e89197f0e0mr5213929ejb.550.1650004968858;
        Thu, 14 Apr 2022 23:42:48 -0700 (PDT)
Received: from anparri (host-79-52-64-69.retail.telecomitalia.it. [79.52.64.69])
        by smtp.gmail.com with ESMTPSA id u3-20020a17090657c300b006d01de78926sm1364280ejr.22.2022.04.14.23.42.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 23:42:48 -0700 (PDT)
Date:   Fri, 15 Apr 2022 08:42:45 +0200
From:   Andrea Parri <parri.andrea@gmail.com>
To:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>
Cc:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 2/6] hv_sock: Copy packets sent by Hyper-V out of the
 ring buffer
Message-ID: <20220415064245.GB2961@anparri>
References: <20220413204742.5539-1-parri.andrea@gmail.com>
 <20220413204742.5539-3-parri.andrea@gmail.com>
 <PH0PR21MB3025F86E824A90CE6428BB2FD7EE9@PH0PR21MB3025.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR21MB3025F86E824A90CE6428BB2FD7EE9@PH0PR21MB3025.namprd21.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 15, 2022 at 03:33:31AM +0000, Michael Kelley (LINUX) wrote:
> From: Andrea Parri (Microsoft) <parri.andrea@gmail.com> Sent: Wednesday, April 13, 2022 1:48 PM
> > 
> > Pointers to VMbus packets sent by Hyper-V are used by the hv_sock driver
> > within the gues VM.  Hyper-V can send packets with erroneous values or
> 
> s/gues/guest/

Fixed.

Thanks,
  Andrea
