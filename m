Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EDB16BA9B8
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 08:47:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbjCOHrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 03:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231784AbjCOHrp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 03:47:45 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1ACB168A6;
        Wed, 15 Mar 2023 00:47:29 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id k25-20020a7bc419000000b003ed23114fa7so478100wmi.4;
        Wed, 15 Mar 2023 00:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678866448;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7jivhOMF2Dp5QIJkx8toAZguDtgmdufs2dThkF05/Cc=;
        b=gYOesFjImuZKGkOWZLdnq694h6tVVEdT0BCh4sYKY/cIiA33hRhjo9bkgApd4kx1zz
         yUt5KGZTRU8cbHrQumF8iKfMCnIKDU6OeN+JZ2bEjaSWaL1azxpzk3sWxxZ913t7DtsV
         lVlnJ4bhehuTMkqXZiwggJFu3IoXooxwtDT3NhCHxrIGVCQv/+XVb6jzxBWfHtzabh+3
         EbvROOmPNv3Y4ldf3YbaafAj3nsH6IMbBvdcWtnUBRUoyCq13ltxQVQnJ/ETGn51Y8cx
         wvHQOaYL8jY2EoaJVzjpfldFlEwxdQrniQe37tUC2uf+7Wun4AIWAp22L+c4a2Cl2RbS
         +s9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678866448;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7jivhOMF2Dp5QIJkx8toAZguDtgmdufs2dThkF05/Cc=;
        b=JRtENLczSZCHjf6MRlGdYk2GBa5CRhSbIAk02V0V4y885tzEfc6qXsrjoAhjjpXQnY
         RozACb19S4Vh22Vt8ef9T2o0hbORjKmXC1fdKc3Mgge+hhj78X7GMWdbXRPvZ5WYIAko
         ho/vJBEykJdgl4nWysIYKF0R7Kghw5wkrgxe1enUkXRTUdEqh1cbYqE6sCJihHR1izoF
         F2tdeOP0ylJrX84oTfic9AskpO9/WunAN3JFP8Zccx+zf9+82Mn+AETuP7xLQ3PHx92J
         GAHD2TOvUZX6Sj6wu4WmAvMIDaQXj+HHhNFkVV1Kc/SeaZQACILdh/P1fOx7v+SvUj2z
         Hv6Q==
X-Gm-Message-State: AO0yUKW+CzP1nLUKYYUc6qQmkKjVcKn8XQBk6jQg3C43DlGYjsRBjQbz
        8kCbZOIxa2azjaQX9f8Iy10=
X-Google-Smtp-Source: AK7set8IdII9/ujkq6fv8gNRveyl1MOjV31vY9KaLeBL6Ky2dpNemQxB7223epsYE0anRCJQcS4yFA==
X-Received: by 2002:a05:600c:198e:b0:3ea:4af0:3475 with SMTP id t14-20020a05600c198e00b003ea4af03475mr17299381wmq.1.1678866448152;
        Wed, 15 Mar 2023 00:47:28 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id t8-20020a05600c450800b003daf6e3bc2fsm4842127wmo.1.2023.03.15.00.47.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 00:47:26 -0700 (PDT)
Date:   Wed, 15 Mar 2023 10:47:21 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Sumitra Sharma <sumitraartsy@gmail.com>
Cc:     outreachy@lists.linux.dev, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, coiby.xu@gmail.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] Staging: qlge: Fix indentation in conditional
 statement
Message-ID: <6e12c373-2bfd-48d8-b77d-17f710c094f7@kili.mountain>
References: <20230314121152.GA38979@sumitra.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314121152.GA38979@sumitra.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 05:11:52AM -0700, Sumitra Sharma wrote:
> Add tabs/spaces in conditional statements in to fix the
> indentation.
> 
> Signed-off-by: Sumitra Sharma <sumitraartsy@gmail.com>
> 
> ---
> v2: Fix indentation in conditional statement, noted by Dan Carpenter
>  <error27@gmail.com>
> v3: Apply changes to fresh git tree
> 

Thanks!

Reviewed-by: Dan Carpenter <error27@gmail.com>

regards,
dan carpenter

