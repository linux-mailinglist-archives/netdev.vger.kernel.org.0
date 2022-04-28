Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA2D5137AB
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 17:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348736AbiD1PHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 11:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343735AbiD1PHa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 11:07:30 -0400
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02087B3DD4;
        Thu, 28 Apr 2022 08:04:16 -0700 (PDT)
Received: by mail-wm1-f54.google.com with SMTP id l16-20020a05600c1d1000b00394011013e8so2462149wms.1;
        Thu, 28 Apr 2022 08:04:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aOn3QWkuh0ydUrhyFT9ChUTB/QLPIdqyaS5nxDi3weo=;
        b=Aen6B2I/EbFtvivoFjRY0zzxXbeN2UOioDt8BTr975YRb97xotWpaB/qxk92MCDIii
         C6x6yxfTKkXqLXEJT6l1pOZEGzJkr3rCtH3XIsAvTrJyvtDQwpyAoiN/48s++nAR3pGG
         ZHhXS9u8m5ljrsCK4xK4zs47AkSivBK7CJjYImPf00et5DsHtMUCMLeFCGmng5y2oTB3
         c81Utk1nKh5Wctx0ITaIURQmYD4lBX1B0eVM1s266Nxb3bgCbI+JTqf2l16kcyFZAzP4
         8MhL6H9SoLqsOrnX5j39yCgL9yhhP8V4HbWgio2saluKQZa84mpSIlERCyRyqCHXKWga
         WciQ==
X-Gm-Message-State: AOAM530YzhsQaPzoHQYfgPsxWQ2Z5AQBO0EzZEVAktKGlEeeTflKRzCL
        PiGSYLpMnQ885gwfIKYYfR/5cngbI3s=
X-Google-Smtp-Source: ABdhPJx8sgR6B7xHw7l1C9SXEHaH+hh2lrlTScVm4bP4RKwU51USBkK8Ka4+0C9buvTS8s/LQAMuww==
X-Received: by 2002:a05:600c:651:b0:381:3d7b:40e0 with SMTP id p17-20020a05600c065100b003813d7b40e0mr40403517wmm.17.1651158254597;
        Thu, 28 Apr 2022 08:04:14 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id g13-20020a5d64ed000000b0020a9e488976sm110523wri.25.2022.04.28.08.04.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 08:04:14 -0700 (PDT)
Date:   Thu, 28 Apr 2022 15:04:12 +0000
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
Subject: Re: [PATCH hyperv-next v2 0/5] hv_sock: Hardening changes
Message-ID: <20220428150412.ligbpeltkhevdat6@liuwe-devbox-debian-v2>
References: <20220428145107.7878-1-parri.andrea@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220428145107.7878-1-parri.andrea@gmail.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 28, 2022 at 04:51:02PM +0200, Andrea Parri (Microsoft) wrote:
> 
> Andrea Parri (Microsoft) (5):
>   hv_sock: Check hv_pkt_iter_first_raw()'s return value
>   hv_sock: Copy packets sent by Hyper-V out of the ring buffer
>   hv_sock: Add validation for untrusted Hyper-V values
>   Drivers: hv: vmbus: Accept hv_sock offers in isolated guests
>   Drivers: hv: vmbus: Refactor the ring-buffer iterator functions

Applied to hyperv-next. Thanks.
