Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0413E51377F
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 16:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346639AbiD1O7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 10:59:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235844AbiD1O7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 10:59:45 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D2534833E;
        Thu, 28 Apr 2022 07:56:31 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id i27so10086194ejd.9;
        Thu, 28 Apr 2022 07:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fBTI3znE+LKO0LEFJRRStXlDP5pWKM2ojbhgO7lwTtU=;
        b=qW+91MB6RdlwexC8ZyK+u+MprNrrSVVDvC+tZDVdDT0YoOFF6lTBrmk1+vm9Ufpfp5
         fX2VVIjNdcS9IKhfuVl6z0L/MUFOYDE7lBztH8qEJERs93Vhjp5PIrppm+dXdOMbJIwv
         riUB4arFqsBwqGuS+5qGPfySSU6YzmSuAtItaJn3BUcN+RAIYpBKK8hn6Vr3NAM4SjaN
         5w/Y2LJ2KWhmgrNAYi++mZy3Qy7fNDBkr/pvzNF5M4bA9j3FP/UdK+PPyb17wn664Ugs
         3Ta+VVjR7VcA+oRqSsIoX6Nk3NIjBUfy9jpExosKpCHEC9U+cLwdVVLKGX2Cn4sm9G7y
         OT/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fBTI3znE+LKO0LEFJRRStXlDP5pWKM2ojbhgO7lwTtU=;
        b=0VEDv9FRK0HLapD9PhRXREGQ/Yjc933uzNgaW2g47DOd4GpK2gdM45mw89jA4YfsZd
         szpZbLku+Z0PY6z0qWTFTzxqWqVQGHtGzSykrYkG8DHT5inSC6k9pAWzPOxQYfboVTfy
         oUg1aMTG1hzHxuKhmsARNnXyISQU4usBWBtkbYLL4NDbFd99LpkfYSEwU5/T+HLx88Hx
         acYAPVfmh3N9VV3HW+Vh0rU0ACaSND8B8aEdO1oMfssuyjTEMSfhikEdYC87wWV6na1I
         6BWFkJGtFxpaAbsZoa/3uuZZmMQWr5HwTu6zDwTxqLbEnhZQTQOIi3/aFFiXV1ZzOdUZ
         8Y9Q==
X-Gm-Message-State: AOAM5317gWq4fwysyPDquq+RMLtqwEvmFNZpyWQnI3kOO775XMjdXYpl
        cY5Q3UpFKSeUwo1KYyAlhrEt2oHNWgG+4uBz
X-Google-Smtp-Source: ABdhPJziVcXPSlOiG1m0iuUUjr7rCUxrFfYriXy2u1/9aAXQGkIKuPfbNzdR9637DJrunJNFuXNw0w==
X-Received: by 2002:a17:907:8b09:b0:6f3:8fd6:d298 with SMTP id sz9-20020a1709078b0900b006f38fd6d298mr21747066ejc.234.1651157789604;
        Thu, 28 Apr 2022 07:56:29 -0700 (PDT)
Received: from anparri (host-79-49-65-106.retail.telecomitalia.it. [79.49.65.106])
        by smtp.gmail.com with ESMTPSA id v10-20020a170906380a00b006a68610908asm76993ejc.24.2022.04.28.07.56.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 07:56:29 -0700 (PDT)
Date:   Thu, 28 Apr 2022 16:56:22 +0200
From:   Andrea Parri <parri.andrea@gmail.com>
To:     Wei Liu <wei.liu@kernel.org>
Cc:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-hyperv@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] hv_sock: Hardening changes
Message-ID: <20220428145622.GA7934@anparri>
References: <20220427131225.3785-1-parri.andrea@gmail.com>
 <20220428142202.tkiv4e2f4oukbfx3@liuwe-devbox-debian-v2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220428142202.tkiv4e2f4oukbfx3@liuwe-devbox-debian-v2>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >   Drivers: hv: vmbus: Accept hv_sock offers in isolated guests
> 
> This patch does not apply cleanly to hyperv-next.

I've just resent the series for hyperv-next, cf.

  https://lkml.kernel.org/r/20220428145107.7878-1-parri.andrea@gmail.com

Thanks,
  Andrea
