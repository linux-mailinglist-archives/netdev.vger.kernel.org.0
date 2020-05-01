Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF19D1C100B
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 10:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbgEAIvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 04:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728159AbgEAIvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 04:51:42 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 155AEC035495
        for <netdev@vger.kernel.org>; Fri,  1 May 2020 01:51:42 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id e26so5277971wmk.5
        for <netdev@vger.kernel.org>; Fri, 01 May 2020 01:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/onMzr06WAyq3qJ/zlRF+9qK/KnsZRqsjh/fGHC7Igg=;
        b=Qzlzh7Hnzx7f2teQnuBrgGyRMFL8jWsDc9c528EGftGsRyf+wuIJWZmqeUbH8G64yU
         PvxT3JW+k7Reec27QYc4ELzXo4qWAw5HhAVa9Z2KGMqll/NPKCdVsBV6TapDTt5uPh0s
         l6+Ud5js5BkgrcT6remvJaQMc/ZLqoirgfAiBjZmMhcEdMS8h4zxw6bNSEbFcalcfhfE
         JtU4XFZ1Rqu5t0xphaq/IOi7XIjtwEOPw/Ovb8BpvykjQXLSzM2s+zBZq6AIp0rok98R
         fMmAfG3STmWyTcab8T/7QSgic+J7aurENkUVHbJkkOVJOUlOafv71L1Bb87MfB4M6E/6
         XrvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/onMzr06WAyq3qJ/zlRF+9qK/KnsZRqsjh/fGHC7Igg=;
        b=O9TmowCXAYB3pzFyIF+sIdJxY66IjKvO/hgYGDU1YfXdpP7+b4bcA0W1GX8rY3Fdr6
         yZZt48EFS340PjyGxjn4ZCXBIFuyQ5xOM9w0cgDddgJ7pnaGdIYE78ZI6W1xr1o+3t75
         3KAzWrp/d2oYJ96jcxrFVqrtbk7iyRequ9NdfI0tXAxnL2cAzT2CVM/wAlr3NX77j+lX
         yEMzfHQXss+NG79QTha03AFQZawQIJWhu2Ydc2JhwIHwMCatCaT+mlsa6Rp4AUYDtoKn
         P6EPzkkaU9Sf9sRTTEiPUxpXRHLcbORVTr1cmIWIAmCL6ffX5+QSEKbvpAtXubWVyaF+
         A1lA==
X-Gm-Message-State: AGi0PubfyzyQ/m+x4zBYdzkgM+8dvQPUPwdT201Csk+cQlKIlaqXBf/P
        q3LYuuSOyLxzifkSkecIbpn6z8sB/HSm9A==
X-Google-Smtp-Source: APiQypLKa7N66sjwk+we6EQmvy5gsNM7uAfu8W/XZC1J5hmkbtp0k005+Mif+b1XyVMYefAQ8qmnXg==
X-Received: by 2002:a05:600c:14d4:: with SMTP id i20mr3084491wmh.118.1588323100790;
        Fri, 01 May 2020 01:51:40 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id z15sm3267140wrs.47.2020.05.01.01.51.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2020 01:51:40 -0700 (PDT)
Date:   Fri, 1 May 2020 10:51:39 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kernel-team@fb.com,
        jacob.e.keller@intel.com
Subject: Re: [PATCH net-next v3 1/3] devlink: factor out building a snapshot
 notification
Message-ID: <20200501085139.GG6581@nanopsycho.orion>
References: <20200430175759.1301789-1-kuba@kernel.org>
 <20200430175759.1301789-2-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430175759.1301789-2-kuba@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Apr 30, 2020 at 07:57:56PM CEST, kuba@kernel.org wrote:
>We'll need to send snapshot info back on the socket
>which requested a snapshot to be created. Factor out
>constructing a snapshot description from the broadcast
>notification code.
>
>v3: new patch
>
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
