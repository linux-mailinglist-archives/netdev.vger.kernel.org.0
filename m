Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1C44F8037
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 15:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343592AbiDGNOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 09:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240715AbiDGNOo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 09:14:44 -0400
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22E9F4CD4B;
        Thu,  7 Apr 2022 06:12:45 -0700 (PDT)
Received: by mail-wr1-f41.google.com with SMTP id d29so7767265wra.10;
        Thu, 07 Apr 2022 06:12:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HCI13kqR579Q1TCsRbXnz/bmREDBGKbTRNjDM5mKHYc=;
        b=0t9+qH6Zapk/S/VGvgTkGY9XvGsZ1L0cZP3z7zXRLHv5KAFCFj2dO8jqblU882eCmo
         5sjMDxiQFIAvdrlA+Bj9My86DbBpNLWbEr1IGQhzjHfw2zRjKrK52rHS0//nfO/SwwPJ
         5aFluSqy5rwbzVI78B316JGiQmCe9REmf8wudABCAEa+9WYP8LS+cMwAA1vrzO7DxAsG
         29plg1/CCleu2VGQ3sjyCgjpkJk16XDRuqRlZV7CsGjw0eYxOGbYA1vUbWeOWZ2SzcGc
         koHBzgO5d+LxT1+X1HZPxqXcQWBWeuJDo4e477F4bSeuwrTn66GZulJJaZTMfP63T7Fe
         5xLg==
X-Gm-Message-State: AOAM532CbXS1uJDNwdP32OSs+vJuIbSsFPNjloLNVr7oijUP7SEoCxyg
        LKgkZkULmUGMUyQK7Tp4XYs=
X-Google-Smtp-Source: ABdhPJxR6TVIZB16KefROVY559IWuQt8+VPOwN/mBpnp5UOY6KACX5raLvrPpeEItOnJ0uPbmhJgEw==
X-Received: by 2002:adf:d1cf:0:b0:207:8c13:f268 with SMTP id b15-20020adfd1cf000000b002078c13f268mr1884810wrd.345.1649337163635;
        Thu, 07 Apr 2022 06:12:43 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id o8-20020a5d6488000000b002051f1028f6sm20274396wri.111.2022.04.07.06.12.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 06:12:43 -0700 (PDT)
Date:   Thu, 7 Apr 2022 13:12:41 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
        edumazet@google.com, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, hawk@kernel.org,
        linux-hyperv@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] net: hyperv: remove use of bpf_op_t
Message-ID: <20220407131241.2mu2nqih3i46n4jz@liuwe-devbox-debian-v2>
References: <20220406213754.731066-1-kuba@kernel.org>
 <20220406213754.731066-2-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406213754.731066-2-kuba@kernel.org>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 06, 2022 at 02:37:52PM -0700, Jakub Kicinski wrote:
> Following patch will hide that typedef. There seems to be
> no strong reason for hyperv to use it, so let's not.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

FWIW this is a trivial change. If this is needed:

Acked-by: Wei Liu <wei.liu@kernel.org>
