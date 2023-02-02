Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B72EC687CAB
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 12:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbjBBLud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 06:50:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbjBBLuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 06:50:32 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A709663855
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 03:50:30 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id lu11so5234777ejb.3
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 03:50:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ND1arZiFmIyuwqmmqgllEbqeW/LIGBOpqueXupfrldI=;
        b=fLRj6EUBlXyV8CpgC7FaIUyzoreXMDERT3p4vDwMkk/DkNZ6bkpfGx1sUIW/d1tAIG
         R8K3sOTnY1BrC6Hg3+7o+lBdsVlcJdVlDOu54NKnmdAQFgm78z/sAkXhSigYOAEbXhqS
         lHv/4TMM27++HjWcAw4cNCC+ELN5hdvBHGBRHOyAQ9r8XXdo0U46D1hb0RqM6Pvw3iXb
         db13LB1Z0TZCW2w18HxjktL1xSHMgb7wlsnoWl6kn8ZmVOUHG/QwYGjaoSlcVh/fkHbX
         MjWUe05RfA2ZGcjD7weEJwq+Tj+joC4dmkcm1Z9DegE2x2Rs4HXcNJ5GcGYPWPbCk5l3
         jiWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ND1arZiFmIyuwqmmqgllEbqeW/LIGBOpqueXupfrldI=;
        b=ZuwI8xyxXBw7ZtiAxOKwG2bcNDeQl/iy6ORIOFcoh5Qx3upzT3utIE0YNIWPmd+A2a
         4QsCR1pLmDJTOAVCORIYcLLYKFYDLhuT4un8Fw6hpG88dcFmdaWScNppsjwws10J0W24
         AeCgScd8nn/fBhQO58p1gpxA3pCFZzvw+jBev30Cq3iAB2hiBf4mf9dtEJG3fM0TjbGm
         hQ2uHG0nXmYTu35JumQYXFVtPU42YQuiQHYTW/RB81CmOPbqEIyk2C4dImI/j2SKCyBs
         IXMhX1cVqtxox8NnUE0U6CpG8A2Wh0t72wAtacexXkKSJLl+IwoWSFIAiwmvjbj+xhpX
         Lrkw==
X-Gm-Message-State: AO0yUKXCtzEKnVAuyWkFoqDQbJyd/jV7NJ3wZWBchOh1YbqSx/FO7Tu8
        nLyKSzRau7Th95+uAm7kdf415w==
X-Google-Smtp-Source: AK7set/UTpKwyh+r7H14WFAawBMfGZisVlMbX07fmyg5uGPJK2bOSsTlz+aJdlIXm+Iv19YJl95GrQ==
X-Received: by 2002:a17:906:94cb:b0:879:ec1a:4ac with SMTP id d11-20020a17090694cb00b00879ec1a04acmr5245642ejy.76.1675338629160;
        Thu, 02 Feb 2023 03:50:29 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id jr23-20020a170906515700b0086f4b8f9e42sm11508126ejc.65.2023.02.02.03.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 03:50:28 -0800 (PST)
Date:   Thu, 2 Feb 2023 12:50:27 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     alejandro.lucero-palau@amd.com
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, habetsm.xilinx@gmail.com,
        ecree.xilinx@gmail.com, linux-doc@vger.kernel.org, corbet@lwn.net,
        jiri@nvidia.com
Subject: Re: [PATCH v5 net-next 1/8] sfc: add devlink support for ef100
Message-ID: <Y9ujg6LhLHbP5XcU@nanopsycho>
References: <20230202111423.56831-1-alejandro.lucero-palau@amd.com>
 <20230202111423.56831-2-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202111423.56831-2-alejandro.lucero-palau@amd.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Feb 02, 2023 at 12:14:16PM CET, alejandro.lucero-palau@amd.com wrote:
>From: Alejandro Lucero <alejandro.lucero-palau@amd.com>
>
>Basic devlink infrastructure support.

Btw, you should use imperative mood in the patch description to tell the
codebase what to do. Nevermind :)

>
>Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
