Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC2463743C
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 09:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbiKXIm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 03:42:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiKXImY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 03:42:24 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 529981025F3
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 00:42:24 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id n20so2702554ejh.0
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 00:42:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FxpMPW/uTls1Rbueb2J2qwV922OLwnYIljULIPbIlG8=;
        b=1+g1VG5NKNoRIKlP1wijbkOrH6eyPgU9OnwlPAjmkmkCZ2a4yEIWKMIwm/zYZcsiAI
         Zt1ic8U/poJgjX91RByfzm6QQ8ulN10y6tpSm8gvCT3XiuPrr9/+VWovfHVqiULWsVhw
         y7y2zDeuVTIC9lKk8wOd7y6wUuDUjnwOtAIdDEchi331S/C1kEIdMJ9F8Sm6gHHNgB+h
         uvsXAu2EBECjn6Bt4YwsuxLNOIPZvT33zhK8SaKejoXnjVl6HyqiH/36gCDJrY41eRlN
         8/nooeoEV9ra2L8AdzbenXUerEXrUMOZLMwTOWpF4ZnMIr9KyPW9xA0Hk3N0BZw4p1Ls
         dKEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FxpMPW/uTls1Rbueb2J2qwV922OLwnYIljULIPbIlG8=;
        b=VY5/bv0903QX68htWv32rhpx+hLLWro4TQ4kPr1XEbr5gFkdEaqoOtk6gzU+3qCfs7
         TRErw9CoJoYpn5U3XFSO+ANnwMy0XtCJPslDR39k3xAOJpYbBVxUKnpSvluJ11UdeFg1
         ErgJhDNEQ0Tcq5xSjelYXce2M1YVFwchjpn1fEUXW3hInIU/MrdKZKqTOzk91+3uw6tc
         FDSohgGl6ikeASktEN5pSBcXAjP+rnNk7ZvGcWHKB9Qym4d5kJxWOb6GL/6M++pwxjXO
         F7HDr6NcwgNm/9xCNo83YeLB1UfJJ+u/7YTKeShYL5n5sYyBMmbDOr/zEFYpymBnBjIY
         mDgw==
X-Gm-Message-State: ANoB5pmvW9xHAGdYvqQE5XCVPI1M5fxF4D3yEnPpl8Dcn6/48bIJWs1Y
        s4Z1op01fPA4zPeqEdqA5p0D/A==
X-Google-Smtp-Source: AA0mqf51MyywySD59i+Vfblrs9FUL8Oq7FA1nwMdLgl615EJFYdkzJH1KqA4zeeuPsZg5KdjJSn26Q==
X-Received: by 2002:a17:906:19d7:b0:7b2:b782:e1df with SMTP id h23-20020a17090619d700b007b2b782e1dfmr22618777ejd.308.1669279342875;
        Thu, 24 Nov 2022 00:42:22 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id c60-20020a509fc2000000b0046a0096bfdfsm254604edf.52.2022.11.24.00.42.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 00:42:22 -0800 (PST)
Date:   Thu, 24 Nov 2022 09:42:21 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v2 2/9] devlink: report extended error message
 in region_read_dumpit
Message-ID: <Y38ubc6IyMkW15NQ@nanopsycho>
References: <20221123203834.738606-1-jacob.e.keller@intel.com>
 <20221123203834.738606-3-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123203834.738606-3-jacob.e.keller@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Nov 23, 2022 at 09:38:27PM CET, jacob.e.keller@intel.com wrote:
>Report extended error details in the devlink_nl_cmd_region_read_dumpit

Nit: It is customary to use "()"s when mentioning the function name in
patch description.
w

>function, by using the extack structure from the netlink_callback.
>
>Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
