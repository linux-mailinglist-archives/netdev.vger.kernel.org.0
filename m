Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95C69430465
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 20:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240638AbhJPSzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 14:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231497AbhJPSzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 14:55:35 -0400
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1661C061765;
        Sat, 16 Oct 2021 11:53:26 -0700 (PDT)
Received: by mail-oo1-xc29.google.com with SMTP id j11-20020a4a92cb000000b002902ae8cb10so290742ooh.7;
        Sat, 16 Oct 2021 11:53:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VbZjgfgW1ldJeZo80k5WOQardHbQMA5bFJ+6MeL1R1o=;
        b=Jmxs9cuCs11h1RBcRizumYEXSCz7RVDgr/y504qog9DwRDmYfItQ8bkrNilc7CC6aC
         6FpI3fSXQP7vfU9lI3ga0SglHsZz5QdRC9AwcspsCGF5AW2/9xUgFrNVPU7HI58uMERI
         YEyTq4ZfDIjPbXoEeM3uQZWkSUrgOCmFareIcB0EDa9NMn2jMoQ+aDfQOXjXaZv4EeAG
         U3edPNOGLGx8o51VqMVvVMx35RgZCDOkR90781d21BkIadxBc6ir5qQUuovvYfNsUuyt
         1WpyWmpTU3mTyy4uCX02NRoiygQc2Tm3NCUYxywFKgBYZaxZT5CjAZaQ+DSj6ktML+ZC
         17jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VbZjgfgW1ldJeZo80k5WOQardHbQMA5bFJ+6MeL1R1o=;
        b=FCWTdUUS+qrlz6rdGqWuxMoMmPTKKptBi+zLfsruTBOew9GR0RlSSZ9sc6PcIgCevn
         bkEX9KdO+LYhMfPF0bA/UprSOFS0SePv/P5TC949WWRKLCSSmSWPVdaV95kOSIEVr4AF
         a7cw+U7aTDqNLzXB+gJD8mt5Ca6WAIQL2TMakZo0p5qIKmyd13kx7jQKCLfwJd2qdq7z
         4+k6X1nJaF2s/A9rV6mTxW4jlm7wowtehaHKoY4Uz0rdaFDrLBN9jCQ+L+dzzWiZngRj
         q4tOu2+iRSYEdqcJ2b0Y92r9//WYgLsqu5BdnbS75MMj0rBSzwpqtj+fbp1A3vp1SFQE
         hfFA==
X-Gm-Message-State: AOAM532DBCmiifxs3LGfMStilTXD4PpcOT4KHvdqHqFDjpLdO5frZjDN
        lHCbeWdyraZjb+t9YIC4QQBey9hyYZLKGw==
X-Google-Smtp-Source: ABdhPJy8oK8I1raNXH9a5z/8m+hVRVRvom2Ya6wzdeUhQr58UGm8Aw9F4b03J0JzpGBCNRMoSZ/K8g==
X-Received: by 2002:a05:6820:35a:: with SMTP id m26mr14609121ooe.45.1634410405893;
        Sat, 16 Oct 2021 11:53:25 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.34])
        by smtp.googlemail.com with ESMTPSA id 16sm2078397oty.20.2021.10.16.11.53.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Oct 2021 11:53:25 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v1 0/3] Optional counter statistics support
To:     Mark Zhang <markzhang@nvidia.com>, jgg@nvidia.com,
        dledford@redhat.com
Cc:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        aharonl@nvidia.com, netao@nvidia.com, leonro@nvidia.com
References: <20211014075358.239708-1-markzhang@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3ce4df7a-eca8-b58b-62e6-f841dbd831f1@gmail.com>
Date:   Sat, 16 Oct 2021 12:53:24 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211014075358.239708-1-markzhang@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/14/21 1:53 AM, Mark Zhang wrote:
> Change Log:
> v1:
>  * Add a new nldev command to get the counter status;
>  * Some cosmetic changes.
> v0: https://lore.kernel.org/all/20210922093038.141905-1-markzhang@nvidia.com/
> 
> ----------------------------------------------------------------------
> Hi,
> 
> This is supplementary part of kernel series [1], which provides an
> extension to the rdma statistics tool that allows to set or list
> optional counters dynamically, using netlink.
> 
> Thanks
> 
> [1] https://www.spinics.net/lists/linux-rdma/msg106283.html
> 
> Neta Ostrovsky (3):
>   rdma: Update uapi headers
>   rdma: Add stat "mode" support
>   rdma: Add optional-counters set/unset support
> 
>  man/man8/rdma-statistic.8             |  55 +++++
>  rdma/include/uapi/rdma/rdma_netlink.h |   5 +
>  rdma/stat.c                           | 341 ++++++++++++++++++++++++++
>  3 files changed, 401 insertions(+)
> 

applied to iproute2-next
