Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD71407EE6
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 19:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbhILRU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 13:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbhILRU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Sep 2021 13:20:26 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 242B5C061574
        for <netdev@vger.kernel.org>; Sun, 12 Sep 2021 10:19:12 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id c42-20020a05683034aa00b0051f4b99c40cso10109475otu.0
        for <netdev@vger.kernel.org>; Sun, 12 Sep 2021 10:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=h6b9VYaRETxDlwOMtck9WJ1ZreJbpX7Avb6dXtG6yMs=;
        b=Y7djpI6YS3Rzlh1BnVzpsxqa3MvBHwPveo3lkW/YOUeLQRkOCMA6xUOiMQ4Bgn4KTq
         W+lAYNTG0mYdBp7do723VeL2wL+RIoNU6NL+ULky+SyY09xtfY/lvRZrKwEap/mW1LFa
         +Z8NdTqcb/y0MGyS5OAiokn+UuJhtf/oIDAXh9ge6MmhcW/U0DLs8wZfGsLnh3Kh3g9N
         64F7cxCdXm1Tye/KOt9aoXVd2XlkxjsNi4307lD2kCxm++Cbh8CLzEEI+bG82/hJTQsz
         KkbwY14dMct47DjFGL/icIUpnrJMIHpnSj3iCgx6YWSJhs7On5qrRGNNefzZy8Eh3/m7
         ii4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=h6b9VYaRETxDlwOMtck9WJ1ZreJbpX7Avb6dXtG6yMs=;
        b=nAkoiqUuQ6rvItawQ2Oh7j1nXlHFrtrzZjaQdZEpbplcET7iu3Zh2N9uPfhkiIa2eV
         DqlEMub9A64PehbYbCckSkjtHTn2sxAwIj+qqhIQVaom37dwppnorgocnnxgNFPIjqCU
         EokjFsVD51+6hMAHsErAbZCFMDkFWlolveoGaqUckNPl+tL91dTCkxrvB703cqq7/F36
         jG07SPsFV4N93ZkJv/ky0Hv29xwKQYtWYvMco9M2JvawzW1jNb4Cn8cqKdlMJMB1JE/y
         NQOB9A0uYSQpuIH4fUH2K1SHFyjvuJZo5JN2sFW4jWoT6YUuMUY83woqT5/R3tQIKGda
         9uLA==
X-Gm-Message-State: AOAM530gYZ4gf3lLMjsrWPQsOg59EHYbhIObUgd4uXAatfCgZNp2ZwmP
        7C+kA12SND6UqWZM1kUuC1C7RRdUHfs=
X-Google-Smtp-Source: ABdhPJx4KzUrLfDabaVs9vEmOl8OtjTIIHqe8xao1lAbYFujzfvbQevqmsGDMbeueaMvhfytFCqWYQ==
X-Received: by 2002:a9d:5d15:: with SMTP id b21mr6671448oti.356.1631467151615;
        Sun, 12 Sep 2021 10:19:11 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.45])
        by smtp.googlemail.com with ESMTPSA id r20sm1244380oot.16.2021.09.12.10.19.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Sep 2021 10:19:11 -0700 (PDT)
Subject: Re: [PATCH v2] ip: Support filter links/neighs with no master
To:     Lahav Schlesinger <lschlesinger@drivenets.com>,
        netdev@vger.kernel.org
Cc:     dsahern@kernel.org
References: <20210909072019.8220-1-lschlesinger@drivenets.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <02b774f4-3a65-cf3e-9341-c6b9a842a205@gmail.com>
Date:   Sun, 12 Sep 2021 11:19:10 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210909072019.8220-1-lschlesinger@drivenets.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/9/21 1:20 AM, Lahav Schlesinger wrote:
> Commit d3432bf10f17 ("net: Support filtering interfaces on no master")
> in the kernel added support for filtering interfaces/neighbours that
> have no master interface.
> 
> This patch completes it and adds this support to iproute2:
> 1. ip link show nomaster
> 2. ip address show nomaster
> 3. ip neighbour {show | flush} nomaster
> 
> Signed-off-by: Lahav Schlesinger <lschlesinger@drivenets.com>
> ---
> v1 -> v2
>     Break long lines
> ---
>  ip/ipaddress.c           | 3 +++
>  ip/iplink.c              | 1 +
>  ip/ipneigh.c             | 4 +++-
>  man/man8/ip-address.8.in | 7 ++++++-
>  man/man8/ip-link.8.in    | 7 ++++++-
>  man/man8/ip-neighbour.8  | 7 ++++++-
>  6 files changed, 25 insertions(+), 4 deletions(-)
> 

applied to iproute2-next. Thanks,

