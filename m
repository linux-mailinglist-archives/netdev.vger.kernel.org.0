Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F33285136C1
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 16:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348266AbiD1OZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 10:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235849AbiD1OZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 10:25:20 -0400
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 115EFB7167;
        Thu, 28 Apr 2022 07:22:06 -0700 (PDT)
Received: by mail-wr1-f45.google.com with SMTP id x18so7064803wrc.0;
        Thu, 28 Apr 2022 07:22:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JEV/gRiIboowFneDPWmwyJ1nyTcxlK0F4cE9gOGek2A=;
        b=RwTYspm/bHKOn2vDZLJtsOXF4pSCdD20BxQQyDzUwcCifCPA1CwmKcB0pPuZfEpbL5
         jSWL7lf1EF2tGh6ebmJxBJl7wGSZRiRGm/i/Yt0OT+xAA9vtQz4sTIVN52o22/zR8YQq
         ntu/krKaUpsGzNcfKdQ2//gouM1DG4RFDoVYuoZB271yIn1lmA5ED9aomEsPV42DSYG4
         m5Q4su73hcGrtlDzgqQY4tISZlPiQeGBIfjybJYIVzEjESXS6Jooa62bGlvOnenom/Ye
         H+18KXhVMNqBdBQF2bI1A1vM0tpGKq3WRNy5vZJ84o2H4jHjz0ymzqk0GyV2ki2KaEj8
         PrHA==
X-Gm-Message-State: AOAM5332Qpu+6LE3sYc7fZPsuXDJnb257aUwLHe3W0qiMwnzMXC6J5hI
        rugPFcf9wN2m9sKf8b9TmhQ=
X-Google-Smtp-Source: ABdhPJznPLb2OMC6g5J4b7e7c+k6RIWPzQZckIWjLIExi5veGYSl1V59TUDwLc8acbDhh1Bh1df4ng==
X-Received: by 2002:adf:d1e3:0:b0:20a:e6bd:75ce with SMTP id g3-20020adfd1e3000000b0020ae6bd75cemr10694908wrd.340.1651155724375;
        Thu, 28 Apr 2022 07:22:04 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id f13-20020a0560001a8d00b0020aab7cefc4sm8804wry.46.2022.04.28.07.22.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 07:22:03 -0700 (PDT)
Date:   Thu, 28 Apr 2022 14:22:02 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
Cc:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-hyperv@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] hv_sock: Hardening changes
Message-ID: <20220428142202.tkiv4e2f4oukbfx3@liuwe-devbox-debian-v2>
References: <20220427131225.3785-1-parri.andrea@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427131225.3785-1-parri.andrea@gmail.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 27, 2022 at 03:12:20PM +0200, Andrea Parri (Microsoft) wrote:
> Changes since v1[1]:
>   - Expand commit message of patch #2
>   - Coding style changes
> 
> Changes since RFC[2]:
>   - Massage changelogs, fix typo
>   - Drop "hv_sock: Initialize send_buf in hvs_stream_enqueue()"
>   - Remove style/newline change
>   - Remove/"inline" hv_pkt_iter_first_raw()
> 
> Applies to v5.18-rc4.
> 
> Thanks,
>   Andrea
> 
> [1] https://lkml.kernel.org/r/20220420200720.434717-1-parri.andrea@gmail.com
> [2] https://lkml.kernel.org/r/20220413204742.5539-1-parri.andrea@gmail.com
> 
> Andrea Parri (Microsoft) (5):
[...]
>   Drivers: hv: vmbus: Accept hv_sock offers in isolated guests

This patch does not apply cleanly to hyperv-next.
