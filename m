Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5489C65D790
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 16:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239804AbjADPwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 10:52:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239736AbjADPvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 10:51:53 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5476839F9B
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 07:51:52 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id m26-20020a05600c3b1a00b003d9811fcaafso20273788wms.5
        for <netdev@vger.kernel.org>; Wed, 04 Jan 2023 07:51:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iOQvPN3AgcSsJra29UfwC3UQqSq5j/hI+8vzua/k4pc=;
        b=gJ+bLXbuGEWq9AGSHSJkyBQLrT040HbLOCc7DlhnsXj3A+mKSPEohb9KazTGH2BSO3
         qBQvd7qZgYWuhxzgsrLg+7grU4v+dYRnyULZdLlhS5SL3DVh0yMS4A/Bre0Eakc0abTs
         ch1soH0SIuDbJbBZ+41MAMmJzbXh7v2eGPvbZNHDXgPCv53z30SXWL5uP5ITgnJH+JSr
         mJtrwtPzGp0gDS47yoKn+Qbh5rN3twVhc+xIY9Q+ALOGkOG97erbwDXHPjiRQ90tNO0v
         6m3MLEWoM2If0B91iQ3vhhzxhuJFAAHymu/RwW9EnfKqgmbuHjqvmgB7wkvzCZgDZ2jW
         OvuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iOQvPN3AgcSsJra29UfwC3UQqSq5j/hI+8vzua/k4pc=;
        b=eE2dmILx7u79F6k6ebakeLRi+eX9ijyp866LaWagH8IpqGPQd2tCLdL4EoQ7VRrXSc
         827MJJdqZHJmZnaWAvn0loEeBaWAN2LwHqBmvMkB/B2Ap1ZIPATXjb1Jh6pDcDg9AUix
         yPocY6QrmONSNgSLLWF4Urpm/CYAqYncUD7sBFcAOcA+Q4Mde3yQSLnuFrgbTiJxytso
         n2U4BBUfCesLNEEFwTdAdgW5p6kyy1P3h60iroepssHnYZLOLbDd9bZR+wMKzanEUpfL
         fo7Sfw9TMwVc+Jq0euh38VPq9a4n0fhkQES0ifXeJjkO6EZlVlVFbS8mHLvGJUHpgYpq
         4SfA==
X-Gm-Message-State: AFqh2kq9cN2+C8blp141ToLaV54pux00vpLYnQSgMB4y+vM5fJUw7Kk7
        FY8Tsb62Rd742f3in4hwoaMYHw==
X-Google-Smtp-Source: AMrXdXviWI8DCxn/mCO0Y9v9PQ/ILiJTo7WK1Xz+Mf8ESfH+crHBSa2aC1E2BU9ClnUpAMQ/flVqVQ==
X-Received: by 2002:a05:600c:34d0:b0:3d6:b691:b80d with SMTP id d16-20020a05600c34d000b003d6b691b80dmr33771609wmq.21.1672847510805;
        Wed, 04 Jan 2023 07:51:50 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id q16-20020a05600c46d000b003d1f3e9df3csm56537607wmo.7.2023.01.04.07.51.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 07:51:50 -0800 (PST)
Date:   Wed, 4 Jan 2023 16:51:49 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com
Subject: Re: [PATCH net-next 11/14] devlink: restart dump based on devlink
 instance ids (function)
Message-ID: <Y7WglQeJi8p9pgr1@nanopsycho>
References: <20230104041636.226398-1-kuba@kernel.org>
 <20230104041636.226398-12-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104041636.226398-12-kuba@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jan 04, 2023 at 05:16:33AM CET, kuba@kernel.org wrote:
>Use xarray id for cases of sub-objects which are iterated in
>a function.
>
>Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
