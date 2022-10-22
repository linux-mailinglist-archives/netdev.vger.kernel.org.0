Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88999608D52
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 15:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiJVNFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 09:05:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiJVNFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 09:05:31 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C926E10A7EC
        for <netdev@vger.kernel.org>; Sat, 22 Oct 2022 06:05:29 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id h203so4431248iof.1
        for <netdev@vger.kernel.org>; Sat, 22 Oct 2022 06:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0ibHJh2sht/y2IJVf3hrb3FpaN0hhH/mzHIt3bRRCdw=;
        b=q741EJmaAENuD63lxbWUSYNvrDZyYuWYxR1b7vWYB5oCd+o5kpOqY0yasJFXiOgy8p
         LJ6JJ1CdbpIABC6NS9Gk6nalX57IbXqvOGKhRB1xComBlOdAKd1d2Do7pMnQatYRRr6l
         vI/19zMCrN0OD2YhgbRi5k/vQBVxvwEq0+wU46Jm78WQLI9AvJ3k/dSU/7cZTtZzmBb7
         2A1ggEfm3p4O1fDasamK5nxk7GeuFQ9gQ6Z/SAPwBZbOq8DyMl05LeZTx37edqr3LJp7
         nm/F4Lc6RXZDnZ5csi/Cih9VItbkWahumyNZj9yLs1YYqYmd/8KBsXtjBptvqD8mou//
         CbMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0ibHJh2sht/y2IJVf3hrb3FpaN0hhH/mzHIt3bRRCdw=;
        b=8MHt4EgMtNCssCb5FFEXfMHcaB22MaCcVIIW/5fkXRHnOBf9pi7EpMcHGR1hfgW+f8
         CdCmBAt2Ixwy2y3o6qlO5AZG6pOSsgYKJc3gochopAJc/0i8xng9tFABaZMsfiJ2UpFy
         z6u5rpsBRLA6CfBOtK8aSVwY+OjHoRAB+m8v5Fg943+ZEBhf52HQMSe95pLUtjnL1mae
         mKQPWhYMSb9yQSek9LJfU1W+ZJiIzoXzLLWmXCTagfOt4py8sM/L6ARcnIlLdeSqd1sJ
         39rTOEojaA1HINQQxlnIYatLPL4NAd6s9G8O19WDwA0jlsORnhRnWrh3GCDRejwsVbLp
         HXUw==
X-Gm-Message-State: ACrzQf1FNzyQ3wX5jYkqhvdO4JrA+aBJfNmqG63JvKQIXUKeaTGA2UUF
        0FkvB6EaZoVXT2B32qGQEtOuUaZzh4CXWt0iMmU=
X-Google-Smtp-Source: AMsMyM7866pv+2hcJKZiqbbxoJJrpMnBZ4nz6nv7+bDIkVcAgBWR9yD/cnHmS1T6ZMCoYx0WxILBEf0XRnjpuowsLlw=
X-Received: by 2002:a05:6638:4987:b0:363:c403:28ff with SMTP id
 cv7-20020a056638498700b00363c40328ffmr15755988jab.235.1666443929194; Sat, 22
 Oct 2022 06:05:29 -0700 (PDT)
MIME-Version: 1.0
References: <20221021205917.1764666-1-m.chetan.kumar@linux.intel.com>
In-Reply-To: <20221021205917.1764666-1-m.chetan.kumar@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Sat, 22 Oct 2022 17:05:27 +0400
Message-ID: <CAHNKnsQzfBEpMMDNq27BEn9RL=zzhsQroeyVVMwJHe=Gpq-WKQ@mail.gmail.com>
Subject: Re: [PATCH V4 net-next 2/2] net: wwan: t7xx: Add port for modem logging
To:     m.chetan.kumar@linux.intel.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, linuxwwan@intel.com,
        linuxwwan_5g@intel.com,
        Moises Veleta <moises.veleta@linux.intel.com>,
        Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 21, 2022 at 7:31 PM <m.chetan.kumar@linux.intel.com> wrote:
> The Modem Logging (MDL) port provides an interface to collect modem
> logs for debugging purposes. MDL is supported by the relay interface,
> and the mtk_t7xx port infrastructure. MDL allows user-space apps to
> control logging via mbim command and to collect logs via the relay
> interface, while port infrastructure facilitates communication between
> the driver and the modem.
>
> Signed-off-by: Moises Veleta <moises.veleta@linux.intel.com>
> Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> Signed-off-by: Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>
> Acked-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>

Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
