Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEC99350E98
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 07:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232994AbhDAFw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 01:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233143AbhDAFwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 01:52:24 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FDFDC0613E6;
        Wed, 31 Mar 2021 22:51:58 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id f19so1039914ion.3;
        Wed, 31 Mar 2021 22:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=OTyQxYLSlThQz6eRBuBi8jp2yti8YzRb4dxOv5HfhEI=;
        b=AiE+mjccUKeSTPrt2xxATdWOgiNqVrk7cZOH9q6jl2tUSGtC4Lml8AGSryY54AgVVB
         Btn8R26BLXBhAdiaC9KZ7k/Dp49xCUlmcnkNHZXxY52BJsxIWtRAPus9Scq1IWngOLdg
         BSDON4uzdLlC8YxrQp3ugLAD5NllsJLKl/lGpZEwObBWAX4nI45K/G6U/QELJZ31pFxp
         COE8QyE/ECxs0PCW/7QbGOP1UUzNPLrBdZeWImT4yeiOcci7J3+bIXZFwIAHgKoYXUlB
         JL1ibymXul32cqnfz08RTas4fEHOZ97CnFa1CQRzxz3gGnL2w5XgE3D+Vnnu4xFGz1BD
         lXzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=OTyQxYLSlThQz6eRBuBi8jp2yti8YzRb4dxOv5HfhEI=;
        b=Mz3KP7K6Mryq55r6XlIQrrtL8oNl2T+qm6v0Gmx9AvEEC+AoOW3kdzR/qqxbRCmH0b
         3ej/3pkJ8Kibr+IeCKRhXezw6l0eqRtFps4noL2282wAzrSfoYX1f/1wZcZCZyJlZiqW
         OAos2JW4P0P8YcEL/AGmvqssR8C57irq9YHLpzgUHx31/jzKA8yiWYzmDnpw8fO+iZt3
         VH2RG71JeDpmBDUgrIgyLnP/cktqSYBk+5ytJyJ8kHIg3hakp6iMH0x9KX2X8FPxNU4E
         lridA2jdJ529ZT2oVqfAnOdBgnXDmYNk0EcHlox6nhvvkcb8HllecRMm63HkXSnuqSRZ
         KVIQ==
X-Gm-Message-State: AOAM532sz1vSoqiPiT0wYHv/AbIgNzfnoWR/WTGBX9vORpqQBU7K8tUO
        j/qOWap1rc12QWjR5aszjNM=
X-Google-Smtp-Source: ABdhPJwzJlWOEuR8qsxpoU+4AN+1+RkLdwjzCcnb+ZQyO0gq3IkEG0QKlCjCC8OT4g8pPFEJGVnymQ==
X-Received: by 2002:a02:a303:: with SMTP id q3mr6358504jai.32.1617256318002;
        Wed, 31 Mar 2021 22:51:58 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id a4sm2188693iow.55.2021.03.31.22.51.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 22:51:57 -0700 (PDT)
Date:   Wed, 31 Mar 2021 22:51:49 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <60655f759ee6e_938bb208f6@john-XPS-13-9370.notmuch>
In-Reply-To: <20210331023237.41094-10-xiyou.wangcong@gmail.com>
References: <20210331023237.41094-1-xiyou.wangcong@gmail.com>
 <20210331023237.41094-10-xiyou.wangcong@gmail.com>
Subject: RE: [Patch bpf-next v8 09/16] sock_map: introduce BPF_SK_SKB_VERDICT
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> Reusing BPF_SK_SKB_STREAM_VERDICT is possible but its name is
> confusing and more importantly we still want to distinguish them
> from user-space. So we can just reuse the stream verdict code but
> introduce a new type of eBPF program, skb_verdict. Users are not
> allowed to attach stream_verdict and skb_verdict programs to the
> same map.
> 
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---

Looks good.

Acked-by: John Fastabend <john.fastabend@gmail.com>
