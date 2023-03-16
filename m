Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52AD06BCF12
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 13:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbjCPMNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 08:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbjCPMNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 08:13:08 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 314D059438
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 05:13:01 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id x22so1068553wmj.3
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 05:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112; t=1678968779;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0WO9ZvpvbKYXwSvZnqpXO8L+DfOB3WdQq1e9D11Fqd0=;
        b=oVUGF0yasUG8tgP9FJtlDU/de74oAD79T9FS8r2MSfGFRpIJ41K+41e7qS9sP+Twqy
         poSmiTR1VOUd7g/CNm4uEosBAw/QbRSjHOidSfW1UQ1gKZKVjl/k3L2LBFDyHHt8Yeh3
         obq842Lj9kLvR5Iezk7uIybJ95+rkTGkrCMkapwdWCnqdFCnaA3EG4/EaDi7iI6fEFJM
         FuuaRUzjeEKWrVMalcg4VDenEqeJu59L+o+GkDhBRaN+WJyU4dVVNoe7fRgYhXz2cLzR
         hosk2HHNsANeiYufiHrjD5UyhGxJatkAlqUiN0kjipFVS8h6VtQrH+u5qIt14qdX7MpF
         WW5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678968779;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0WO9ZvpvbKYXwSvZnqpXO8L+DfOB3WdQq1e9D11Fqd0=;
        b=7t7YyjnwY8KGFKTY3Op3GTYNqpJh/gEKtzBNfWyaflNntXGp0M3KxEqmSiJ+hy5zZg
         HFzY+CPtDq/IF4oLIqJpt53Kqr2ZbbjGYrGdDkaWTtwySJb3hqMaZZ6dWQMFVM6gFcfx
         k9NCxJJrs2vTeTSGkeWO5KJMnCqhykugSgSt2248WV28KLTc0Y4OFb8KZYYEUpLZQLn6
         He7GhqOpxiWsT3jbrwFK5XxgSYlAIfNQp0WatExVJs0o029Hk3Uw2M9roYinZyWXqfdW
         wbYRJL56aX1+10z+wWRAcnDf2+toufmOrh9inzBbkx+VGy8/FpdoGFYa7zXl2eBmV9fG
         g9MA==
X-Gm-Message-State: AO0yUKVQzuWJuYf9PTFDDMgG2I+2jKIsvt5jgpc0ScIrYs1nHdpv7I0G
        CPD70i3XRfbea8VcEstMYx18JA==
X-Google-Smtp-Source: AK7set9NjrFBLZ4ieAlm3ZW5QgEeNlqzUCFNjWu5qAKobxPwLHR5HhGvM2v06tBMGI6Yp5t1wJ1/sw==
X-Received: by 2002:a05:600c:458e:b0:3eb:37ce:4c3d with SMTP id r14-20020a05600c458e00b003eb37ce4c3dmr19992464wmo.38.1678968779589;
        Thu, 16 Mar 2023 05:12:59 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id f13-20020adff44d000000b002cfe29d2982sm7048067wrp.103.2023.03.16.05.12.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 05:12:58 -0700 (PDT)
Date:   Thu, 16 Mar 2023 13:12:57 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadim Fedorenko <vadfed@meta.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>, poros@redhat.com,
        mschmidt@redhat.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org
Subject: Re: [PATCH RFC v6 6/6] ptp_ocp: implement DPLL ops
Message-ID: <ZBMHyarasEzecvlW@nanopsycho>
References: <20230312022807.278528-1-vadfed@meta.com>
 <20230312022807.278528-7-vadfed@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230312022807.278528-7-vadfed@meta.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Mar 12, 2023 at 03:28:07AM CET, vadfed@meta.com wrote:

[...]


>@@ -4243,6 +4430,8 @@ ptp_ocp_remove(struct pci_dev *pdev)
> 	struct ptp_ocp *bp = pci_get_drvdata(pdev);
> 	struct devlink *devlink = priv_to_devlink(bp);
> 

You are missing pins unregister and put here.

Btw, It would be probably good to add a WARN_ON into
dpll_device_unregister() to catch bugs like this one.



>+	dpll_device_unregister(bp->dpll);
>+	dpll_device_put(bp->dpll);
> 	devlink_unregister(devlink);
> 	ptp_ocp_detach(bp);
> 	pci_disable_device(pdev);
>-- 
>2.34.1
>
