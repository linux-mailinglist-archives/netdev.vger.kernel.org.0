Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C33557C3DD
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 07:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbiGUF5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 01:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiGUF5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 01:57:24 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7253677A51
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 22:57:23 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id c22so431929wmr.2
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 22:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Z0MfCT0sGUrxQrY+ZuFkS3ZcmwaXCbZ8eYpgvWL9gag=;
        b=tXOp8nRttS9/yhGH2mKBwZL+ZOL2nFPczJdZ0XqLKaeru7VPusS4iMf8Jyj/VxGyXx
         MjpOK37GWIwTdQ9BkUBmubdtk44euM59Kn2FfftK1OF5BfbMyDPW6IVHn/X6BwZvfIvT
         FqsA0NVL8zOioNqD2uJKAKKf/rFezljMqbYQ8qht+bdWe6Zj3B+4BTKzX639pzbtJTI2
         XgtcXEbdlkhrJa35HGzKla3dZ5qYWn3g3wLeS09H4rizVaSkLydOJ2RYvHeGG4TMiCNQ
         Dyv61/vye5XFFubyJRsfbhlPbUJlV7AtzohlWbN6Zvf11TqISLE58AfOfrOSmPKist/5
         GcEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Z0MfCT0sGUrxQrY+ZuFkS3ZcmwaXCbZ8eYpgvWL9gag=;
        b=SIha1tLN3nxv5FMnvAuip4Cwceq9NA96ry27w9vvcghLyZwZ+GjcgjRCereudrBPM5
         rBwMSSP2bluuL3faLoDU/pU+PmmrSp8p0vdYLPUUBBqZqX3jDirtMGBTJgGQf3+/4wKv
         uQ+AqLPpK2hXo7uZDkEpWwjRUrydJ11a5Ybf1nhWgUsydU84R6YJ+wEkOKGwgme6fR1p
         70l/k/Jv1lSRWMEVZ6GCd/A4HllhhRcA6Ci4bfxRkIu2x70kpqoDwPThD75bvdneR+PC
         vArtzKGafxDkz/jWhJSb5/orcXHRrhu2OtVJ4nyam+jOqzE0ty624FZn/FPOxMXKOMGZ
         g1sw==
X-Gm-Message-State: AJIora9g6C4/hk+eSBEsvrjvS3AEWZEWUyg9cbdLzGRiQ4JUDOlUzjc7
        by4f46EhTM3/Lpfs1xpZfh8diA==
X-Google-Smtp-Source: AGRyM1tw1QfcBEmkWYuh9xKRGk7Jggwhex/cbR1crZOQV+dZ4kcz/8aBIUC0uuDi9HTRsWCc6mlTbg==
X-Received: by 2002:a05:600c:35d6:b0:3a3:1c4f:6f46 with SMTP id r22-20020a05600c35d600b003a31c4f6f46mr6696720wmq.206.1658383041881;
        Wed, 20 Jul 2022 22:57:21 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id t7-20020a0560001a4700b0021e53a148d3sm788613wry.62.2022.07.20.22.57.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 22:57:21 -0700 (PDT)
Date:   Thu, 21 Jul 2022 07:57:20 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next PATCH 0/2] devlink: implement dry run support for
 flash update
Message-ID: <YtjqwG/1PZICc9NB@nanopsycho>
References: <20220720183433.2070122-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220720183433.2070122-1-jacob.e.keller@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Did you use get_maintainers script to get cc list?
