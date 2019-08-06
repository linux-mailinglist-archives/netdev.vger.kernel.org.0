Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07667828D0
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 02:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731066AbfHFAqq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 20:46:46 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:42734 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729383AbfHFAqq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 20:46:46 -0400
Received: by mail-qt1-f194.google.com with SMTP id h18so82919528qtm.9
        for <netdev@vger.kernel.org>; Mon, 05 Aug 2019 17:46:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=p8EkPLfMAiHYzvY7/WHeWoOy2NzVK3krQJDIDAIgywc=;
        b=gMySazlZHEbNfuWW9hFvliEeRFIs1GtAopLb0fk3gG60CpC614Xv/q8S6YcfcqWjpf
         6Dzr1OaT64dNc/z1rrf2vhD+JWUJKMfcXVcmTb475FjvWQs6mxQ7r2rLkj6JOLf89wt1
         RR0C2hofkZdiF1+1DEjDtvIG5c+Go+itIaZlYRQhbOH3YJYp7I1Tgt7AKKa3aI0NreYU
         T3LW0h9AwK2X2DwlJIcIQFkGUOuVYhItomSF9JKz1ApVGb+HCilkp9gOctBmu0+BWyuC
         eYBr+0fxSNeb+bxzg1nPFPxr9vBcerY/0FqjCsZZ4mLab7gbI4BjX5Yyh0oRTRC5XXRi
         vJPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=p8EkPLfMAiHYzvY7/WHeWoOy2NzVK3krQJDIDAIgywc=;
        b=oNQArjQB2M/m65PE+FQk1N7ei1ojD7Er//NkW2LKc365NvwRJElAUU6VHIvgPhY8sE
         K9b5B1L1l2NjGTUgUVro0R7/WVcVe3vVvFVyJ2/z55161TcyRCjzsGDrq9KzEoepI4Ez
         WM/iaYaM3eNAmnTNpObZI79HNJdnRgcTutBj9soFF+Cu/aoYShKulXx5Ms9gWMU0H8ah
         BVzRlq4EmfLyE/xhTcRsttzTFiQsTzMOVOpwjkGP9Ed54mvmMtMSzTKiKuwFT7Mta4zr
         Nb6rSdUAWEpLL7nivmIRVEjnURDcFqgrb3vGc+883PhHyyMVnKRGjT/eGzWKtI587Tmb
         XIeQ==
X-Gm-Message-State: APjAAAWTccRUrn72OJrqkDnCs+DJzye6lxrvNlFRM11vqTpTd9pPkzwf
        DcnElC3biUhVUE0GWkioVZktVikftcU=
X-Google-Smtp-Source: APXvYqyoKp7/WAVVsNNKyyEnGmtOchartOCs7vbZynHSvtZkvaxBgn5DxezlrO7b2Jfh5Zjk7y63XQ==
X-Received: by 2002:ac8:43c5:: with SMTP id w5mr778262qtn.280.1565052405730;
        Mon, 05 Aug 2019 17:46:45 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id m5sm35642248qke.25.2019.08.05.17.46.44
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 17:46:45 -0700 (PDT)
Date:   Mon, 5 Aug 2019 17:46:18 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiangfeng Xiao <xiaojiangfeng@huawei.com>
Cc:     <davem@davemloft.net>, <yisen.zhuang@huawei.com>,
        <salil.mehta@huawei.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <leeyou.li@huawei.com>,
        <xiaowei774@huawei.com>, <nixiaoming@huawei.com>
Subject: Re: [PATCH v1 1/3] net: hisilicon: make hip04_tx_reclaim
 non-reentrant
Message-ID: <20190805174618.2b3b551a@cakuba.netronome.com>
In-Reply-To: <1564835501-90257-2-git-send-email-xiaojiangfeng@huawei.com>
References: <1564835501-90257-1-git-send-email-xiaojiangfeng@huawei.com>
        <1564835501-90257-2-git-send-email-xiaojiangfeng@huawei.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 3 Aug 2019 20:31:39 +0800, Jiangfeng Xiao wrote:
> If hip04_tx_reclaim is interrupted while it is running
> and then __napi_schedule continues to execute
> hip04_rx_poll->hip04_tx_reclaim, reentrancy occurs
> and oops is generated. So you need to mask the interrupt
> during the hip04_tx_reclaim run.

Napi poll method for the same napi instance can't be run concurrently.
Could you explain a little more what happens here?

Also looking at hip04_rx_poll() I don't think the interrupt re-enabling
logic guarantees the interrupt is not armed when NAPI is scheduled.
Please note that NAPI is no longer scheduled if napi_complete_done()
returned false.

