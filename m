Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98FE93C64B7
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 22:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236684AbhGLUIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 16:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236420AbhGLUIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 16:08:12 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C3EC0613E5
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 13:05:24 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id q10so17415864pfj.12
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 13:05:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gFiQIMdbMlGiV4kNbAs8pfFngiJ6QhnK3Hudjk2XiOU=;
        b=SK++E2Zrabb9y24MNbsqgpf5V9FrMpggUlk9wC5vd7xfg1lLfLcJKNzdWVFHmIVrxM
         +MBMMeIz4XkqO2EKkpXz04sPF+JQ7je9mpilzkCKfS8n3j4lDqgAtfcArwbycRCv+IzH
         bbGykPzDaHBAogdGlGSv8CyULO7rjGUookBWyZBmaYv+nO3qWoYyX6lOrYCgKbdkt7d3
         F85DFhO/zv3Malp4LqnML+D8Y18E2MECcss5TZjHFGPZVLoOvydbWe+2uhT+4J4q/T4U
         mdCyLOX2eDX5AcNcag1QkW1p9cx3f2GgI4yzIrDlfeC7y7zDpr2+3xd+WdQilqYjsnYG
         NOsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gFiQIMdbMlGiV4kNbAs8pfFngiJ6QhnK3Hudjk2XiOU=;
        b=sssxOaQGqVj6ajxlAwXc1DfOJa9PSGfISAMKU3XT8+55g84Fdyc52mnct+O4yGJqqM
         9jj3jetuL9gWJIgqbBDYi66VAuhV1tfdLVNQmv/QuPGIjWgQsnUjCtW/dqIn1p+gPZ2s
         rcPjbAkW9+j1BFjs1jRQ8ZibkPJR6aNyqM0WuJ3c7n8vwThz3+W4Ka81BmylA5qdgXac
         gHcTQ/nU419JOgvRJQgOFGF9TfqM7A+h5DocKoUrlY0ns3QtmaWx3IIYajyFmZ+RZ+Qk
         GD3ZX0I38IL5ZW5wahH8FWMCoYYClSxxu3hXUN/w3XKGS+4vFotq13OChaiPwgFewsDt
         BsvA==
X-Gm-Message-State: AOAM532VNnoK6vcP/T44N1NVKaQ4v1TvHDEuBeYxOV1pSU2+hfwSoEVt
        x1HrwYs5XEipGaCUDTYe7r1odQ==
X-Google-Smtp-Source: ABdhPJzriLGXnQ37c8bvZnrfu5DlMt6tQKsjaPZcm40N4NMtTsgw75jNUkxFv5acnZULsUz1oSMJhw==
X-Received: by 2002:a62:442:0:b029:31d:2e52:f1c4 with SMTP id 63-20020a6204420000b029031d2e52f1c4mr772777pfe.14.1626120323694;
        Mon, 12 Jul 2021 13:05:23 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id fv8sm14557493pjb.21.2021.07.12.13.05.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 13:05:23 -0700 (PDT)
Date:   Mon, 12 Jul 2021 13:05:20 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Salah Triki <salah.triki@gmail.com>
Cc:     kevin.curtis@farsite.co.uk, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] replace for loop with array initializer
Message-ID: <20210712130520.748b6e3a@hermes.local>
In-Reply-To: <20210712192450.GA1153790@pc>
References: <20210712192450.GA1153790@pc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Jul 2021 20:24:50 +0100
Salah Triki <salah.triki@gmail.com> wrote:

> diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c
> index b3466e084e84..a90d3b9a8170 100644
> --- a/drivers/net/wan/farsync.c
> +++ b/drivers/net/wan/farsync.c
> @@ -567,7 +567,7 @@ static void fst_process_int_work_q(struct tasklet_struct *unused);
>  static DECLARE_TASKLET(fst_tx_task, fst_process_tx_work_q);
>  static DECLARE_TASKLET(fst_int_task, fst_process_int_work_q);
>  
> -static struct fst_card_info *fst_card_array[FST_MAX_CARDS];
> +static struct fst_card_info *fst_card_array[FST_MAX_CARDS] = { [0 ... FST_MAX_CARDS-1] = NULL };

Why bother, the default initialization in C is 0 (ie. NULL).
In fact, checkpatch should complain about useless array initialization for this.
