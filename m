Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9ECB7D2D
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 16:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390016AbfISOsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 10:48:53 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:40027 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389041AbfISOsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 10:48:53 -0400
Received: by mail-pg1-f193.google.com with SMTP id w10so2035613pgj.7
        for <netdev@vger.kernel.org>; Thu, 19 Sep 2019 07:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=m5gv6uKX7NjWmYUmexgGWoYBeU37IqxxkUfBqoUrZeE=;
        b=LXRfS2kfbQyn3dVUy2NvrVA2XQxxcgnNItJkf1tIsCyNblAdjEto80/mdNm9kmYXw4
         GT+6LPffS0XsgtRLyjTGYHfCGAunNdvM4A8qoG9gG7z3ft6zkvoeWRSpvwaSRDBhhKcJ
         /oA5CpgcqswaRwm2KtH3hPFkcAytWbGCqFnMvxoAyKubdNdwyvDxPTTBJiPCxQN23THb
         0gC/br6RtdI1jEoA/RzUkySYNw5MfldGEcwcwmhhhm0xYUsh21erE99mFDaJRyvI2JYZ
         gHzFPWqKoxeWPlS1RtWFFXhTq9a6JbpP21UT8ZeE3dLjFGELngCu8gfb1K4krJ1/T7V1
         Pe0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=m5gv6uKX7NjWmYUmexgGWoYBeU37IqxxkUfBqoUrZeE=;
        b=NeMpMeZC8VCQBzONHaLV3xaY7P0u+cV10Nn1Y4q6cgAGfYty+M3WjjmPBfyePlwZT4
         Mp6QNaR++muzrBs3PichXL+RvYiddZuYWDMgST8iacl8MV8p/+KIlkobPdxTF4rx0A+r
         YeGRG1bDAJCthpag4aQRgEr+u4KrQig5pmnjqY0SCQqmCU0aU6zWKJePHRbzKgpIcCND
         5XXSOZtlXFntGDTyboe4k0tynPd2bRyzkrA0sQXP+40ucTRxKqexS4j/hIfcoAI7m6LB
         qS/lqN3x1Mq7pc12COwgcNeuvmNJJaohnBX0TzMOjotGaQgrRhxzodZieYZ+WahliBuN
         9inA==
X-Gm-Message-State: APjAAAXegXAil5RRnOEJ+CHyZqa5OZaOM9LnJsmZVpeBljHbZOjRT7OD
        mnKoKq1CczHp1lNNZOlBFHU=
X-Google-Smtp-Source: APXvYqyrvU7NjWZbDnNdgCFW9lNfate09Anz5JPS7NSNcTAhqBLxwBW6JgT+8WBMGX1CTknVl7JdPw==
X-Received: by 2002:a63:e05:: with SMTP id d5mr1015381pgl.230.1568904532739;
        Thu, 19 Sep 2019 07:48:52 -0700 (PDT)
Received: from [172.27.227.189] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id b14sm495896pfi.95.2019.09.19.07.48.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Sep 2019 07:48:51 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v2] bpf: replace snprintf with asprintf when
 dealing with long buffers
To:     Andrea Claudi <aclaudi@redhat.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@kernel.org
References: <c25efdff9a67ed4bc23862d0ef4ff8073de69c4e.1568638725.git.aclaudi@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <bea3013b-376e-64a5-6ec8-ab54957018d9@gmail.com>
Date:   Thu, 19 Sep 2019 08:48:50 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <c25efdff9a67ed4bc23862d0ef4ff8073de69c4e.1568638725.git.aclaudi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/16/19 7:00 AM, Andrea Claudi wrote:
> This reduces stack usage, as asprintf allocates memory on the heap.
> 
> This indirectly fixes a snprintf truncation warning (from gcc v9.2.1):
> 
> bpf.c: In function ‘bpf_get_work_dir’:
> bpf.c:784:49: warning: ‘snprintf’ output may be truncated before the last format character [-Wformat-truncation=]
>   784 |  snprintf(bpf_wrk_dir, sizeof(bpf_wrk_dir), "%s/", mnt);
>       |                                                 ^
> bpf.c:784:2: note: ‘snprintf’ output between 2 and 4097 bytes into a destination of size 4096
>   784 |  snprintf(bpf_wrk_dir, sizeof(bpf_wrk_dir), "%s/", mnt);
>       |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Fixes: e42256699cac ("bpf: make tc's bpf loader generic and move into lib")
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> ---
>  lib/bpf.c | 155 ++++++++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 116 insertions(+), 39 deletions(-)
> 

applied to iproute2-next. Thanks


