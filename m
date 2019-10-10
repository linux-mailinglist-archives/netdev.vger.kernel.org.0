Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28860D3442
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 01:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbfJJXXy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 19:23:54 -0400
Received: from mail-qk1-f172.google.com ([209.85.222.172]:38734 "EHLO
        mail-qk1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbfJJXXy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 19:23:54 -0400
Received: by mail-qk1-f172.google.com with SMTP id x4so3304382qkx.5
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 16:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=fUaQ6WoSH6XzjkSQgTq8RJcJ124XJflOmu0VJ/xFwSM=;
        b=tlyhI/dgeHfL8cy/la9LnR3LBzP5aNKC+skbXWUYHxVngx4Qd2VBY3gUiuLPtHuB4g
         anHx/g6Anr9byMffHo4hxd6lmH53cSpO7ltUqSgfQg1bHnuWRVyw6pjPA+wmP1rkEdjv
         gD92kwNTkgLBLijQMbrhUWNg4bkE17FJ+JSqvjeWK7K1u3dgGjLNvzdlbl2YZUQAVoRo
         wPoSW8JjoMVy/5XKsXMSOHnzvOz6ExxfvvKik1zQy+7aPKJUDpAY6+O+CMVj1YYZlx4p
         bKOsnZezhAD+0rEb6beB8jxaAnzzW5aH8UrZC5G0HOHtpe/ZjFUKfgDcOr92Vw/fkvTX
         M4EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=fUaQ6WoSH6XzjkSQgTq8RJcJ124XJflOmu0VJ/xFwSM=;
        b=Ccg2A4m0uEmO3hjCxkurZorMgzN9Z7zKwe51ms3cKeasDDB8PEpNRLpGthISsuDjK9
         2U3bQSs5sxCqD5G9axRYaIhMpXC6+ZDmrYV3oLy/wQPUXtrPRCOadL+geA/WWN0cKBnJ
         6GVZc43+QUufapOXDCMzyK/1zKuWYvja8HzonzwU95hHCTAr7a0GgCxwZxKYm4OAvnoR
         wc0pArhmUhqGGpBBScudRSJHwvm+ptPTenPhVAlYKYnyS760vfhlEXcf0XqMf6yg0EEw
         hak47kl32DhpxN9SD8INvmGshZL1Rh5LBYgqiyxbwL7HPrxxioKUx3264XlXSDsTbinO
         jbCQ==
X-Gm-Message-State: APjAAAVuDyEKdEyO6eGMbrjeAh3eIMhCzBKCiSdr6S5XWbf20smC8Wj6
        IehPeCnyeGRirTCR/OftvWReLQ==
X-Google-Smtp-Source: APXvYqzMYq0NiWofLSStCkmGWGdyZv7L0Qj9i1dRTXNZ2atw4FNlU6Csd0E1t8EKDOgbujFaY0yzrA==
X-Received: by 2002:a37:9007:: with SMTP id s7mr12407714qkd.384.1570749833573;
        Thu, 10 Oct 2019 16:23:53 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id o28sm2868621qkk.106.2019.10.10.16.23.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 16:23:53 -0700 (PDT)
Date:   Thu, 10 Oct 2019 16:23:38 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <richardcochran@gmail.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] ptp: ptp_dte: use
 devm_platform_ioremap_resource() to simplify code
Message-ID: <20191010162338.66e975c1@cakuba.netronome.com>
In-Reply-To: <20191009150325.12736-1-yuehaibing@huawei.com>
References: <20191009150325.12736-1-yuehaibing@huawei.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Oct 2019 23:03:25 +0800, YueHaibing wrote:
> Use devm_platform_ioremap_resource() to simplify the code a bit.
> This is detected by coccinelle.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied to net-next
