Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29BE93216B3
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 13:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbhBVMar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 07:30:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbhBVMaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 07:30:24 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7783FC06178A
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 04:29:28 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id o10so7404532wmc.1
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 04:29:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=Um/pAjy6evc5KsuZIFI5b7KNbsTtb3tpuv1m3a0q7J4=;
        b=a0AzI0rXQ285SWuOENJHM8IagtB78Ge0b4+0LuieruoGSZqvz7hFYLu9xLBaP32tVn
         RV+7x/KgfhzO7rIVCqQOiYLblxknhC8EKtG3Bkxuc2dAqiXncRMpxcp11djf5gZs1yjy
         YJ1WL/AdEEJgfQnmkOqyu1wj7U12xMqO8hcp0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=Um/pAjy6evc5KsuZIFI5b7KNbsTtb3tpuv1m3a0q7J4=;
        b=TGQRwJk9tI5iPbOXlqnGplZEMv9ykj1aEK2zlIOGyui4ZLOXXZ+z7cF/fTsRPZZ9Hf
         nREEd+iJaLrQiieF1j8MbTAhDSHYsUaqUydpehjKTQT1ELrRtmFBwdIMyjbwVql6Jmub
         RcYXjIZKOSWO19CNv/WVDDYVK7OLLr6EwR5xOyqF3wmv9lL1sk8nnY0loYns8Sd+CuXO
         9v2oNyFlR9Ka4fKyIa0NRKDLXpcdiEgKSB/2P4/WuVStgG9kA5fb3QWThzdsJmbXSjTW
         ZpfiPUk/Pl8tKPQnN0Qyr/ydzFX7gYjkaNTWdc2qS4XtfVUqUY7/ZKIfycXV8VN9XjiU
         4kNg==
X-Gm-Message-State: AOAM531YrBvkHT2tyE7DW8K94Tg4TXxDGH1CElxcX68vKr7slu5mzPK3
        Ix8i1QPWMA4rQ7ZRGokbZqVZJw==
X-Google-Smtp-Source: ABdhPJzSp9EhYmjWwrD942KIJkvb7ao4IxqBsrwe5KqBXvOTQbNE8DpmG8JTyGUKpgoaEeE6q3MrSQ==
X-Received: by 2002:a05:600c:220f:: with SMTP id z15mr5456805wml.170.1613996967254;
        Mon, 22 Feb 2021 04:29:27 -0800 (PST)
Received: from cloudflare.com (79.184.34.53.ipv4.supernova.orange.pl. [79.184.34.53])
        by smtp.gmail.com with ESMTPSA id q15sm29726585wrr.58.2021.02.22.04.29.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 04:29:26 -0800 (PST)
References: <20210220052924.106599-1-xiyou.wangcong@gmail.com>
 <20210220052924.106599-7-xiyou.wangcong@gmail.com>
User-agent: mu4e 1.1.0; emacs 27.1
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        jiang.wang@bytedance.com, Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [Patch bpf-next v6 6/8] sock_map: make sock_map_prog_update()
 static
In-reply-to: <20210220052924.106599-7-xiyou.wangcong@gmail.com>
Date:   Mon, 22 Feb 2021 13:29:26 +0100
Message-ID: <87blcc476h.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 20, 2021 at 06:29 AM CET, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
>
> It is only used within sock_map.c so can become static.
>
> Suggested-by: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---

Thanks for the cleanup.

Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
