Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D758C644483
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 14:28:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234260AbiLFN2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 08:28:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234131AbiLFN17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 08:27:59 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D336C2250B
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 05:27:52 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id k22-20020a05600c1c9600b003d1ee3a6289so1110243wms.2
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 05:27:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uycol23sLMJvKSN/Uf+hAHaSexrmgv6QP0a0Ox9Q4o4=;
        b=i0qmxSRb3waD4rxuHBCB4ucip+pAeuTwiZiojywQQLgL57PhZxX709w+IATXT/K62P
         0fRN9Kl0PLOMfFWahzeM3pD8VBNEgoQSqLodQ6CogsuhWlA5nkzSl5wVMl+KP0cUNnTo
         SLIeTPxs/WSD7LrrKwWm5du/ggUj38ZuFPnNknFZNZd9TDzaOXANwQ32QEcVauqRor78
         t/QS7meh8yvSUiSnLHoCWxFXGawsCVEvXN0tqRUvFAnh7HSjJQR87bTopt5XOycvhBzu
         G9zEv2YRt9kqOI9VPhrjz2Rx3i3NcaqZTdWvXs0teBvJN+jpdOOfY9qKAYJjnQCkcFfp
         oP9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uycol23sLMJvKSN/Uf+hAHaSexrmgv6QP0a0Ox9Q4o4=;
        b=pnF4q3BTY27sppjxKccYyz3c73Ev8cNGxHteV3ISnzY2VapvzRDRzbPnDAcabUtTsp
         E6QKqXt9z2HfOB+I6wnuFdsb8xGEP5p69owTDGHDXzdugnp1BE1Kq3BSAOY39d5pIcNf
         OsLIgeU5ghypMBB6lf67uGq4CyJDiBxYRJJwAlS433+6lpIK4FcC+zosJkFLZjf1flz+
         osq3G9FuLUsitgl5jT+XuwQbmF+bjKb5mrhRGUaFacbUD7hqJ1C+5uNdte0VZwOtxWq1
         8yMqUnuNdjW9QSrZaYWu37ZKrT0/SekO5902ZpYk9Pa7phLPa/fWpUyHTw7Bw7dQLUnD
         NPOQ==
X-Gm-Message-State: ANoB5pn9JA6lVPfep/QwbS5ybmRaP+DyUovHI5zCO823trSJALeFr5Vd
        VS2+6ZFbMj3H8lzwtUebtYNlMg==
X-Google-Smtp-Source: AA0mqf5W3612gH3fFbqiHPC1BGF8Y+BrWOxXdZ0XfxjlNvvZ6nazP6Wx9Jyd9dGJf/2+ofVWqAbTmA==
X-Received: by 2002:a05:600c:1c09:b0:3d0:4fcb:253b with SMTP id j9-20020a05600c1c0900b003d04fcb253bmr33255121wms.199.1670333270983;
        Tue, 06 Dec 2022 05:27:50 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id i1-20020a05600c354100b003b4868eb71bsm26978780wmq.25.2022.12.06.05.27.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 05:27:50 -0800 (PST)
Date:   Tue, 6 Dec 2022 14:27:49 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] ice: switch: fix potential memleak in
 ice_add_adv_recipe()
Message-ID: <Y49DVUIaZhoky0B1@nanopsycho>
References: <1670225902-10923-1-git-send-email-zhangchangzhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1670225902-10923-1-git-send-email-zhangchangzhong@huawei.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Dec 05, 2022 at 08:38:22AM CET, zhangchangzhong@huawei.com wrote:
>When ice_add_special_words() fails, the 'rm' is not released, which will
>lead to a memory leak. Fix this up by going to 'err_unroll' label.
>
>Compile tested only.
>
>Fixes: 8b032a55c1bd ("ice: low level support for tunnels")
>Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
