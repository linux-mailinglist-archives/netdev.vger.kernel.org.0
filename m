Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 258E18D750
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 17:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727222AbfHNPkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 11:40:04 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:35703 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfHNPkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 11:40:03 -0400
Received: by mail-pl1-f193.google.com with SMTP id gn20so1601011plb.2;
        Wed, 14 Aug 2019 08:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=/MNhvAe1aUSGuYylMPVo6sUzj61ox1fF3EFAj+VYkMo=;
        b=RTcAgzOBu9fZXX4Ano/BuBGNV9xA+PIWZUvaDNY43N9xOFCR37ysTZrbfZFggwngoa
         S24BEiBpnmNhnaCuAfNnn5r6x6yx2SHICBVgr5kv5RF/w9fcpp4J8KpOqdUeK/UR3w5r
         +5davpJUkfXIDzKCsiFCZrtpQK2PfRobxT+fMtXDvdUbiRjOrjuxHLiQEdo/cROqMXcr
         KODkVVQ+IpGR2PmjDgawXSq/j+w1BocGIZIzYLZPqwRvbJn6NEWhChoDcLDu+mu8+V7B
         Yeh9fNIKgy9Ci4XzFW2wzE+8pNW+TO0+cPMaEbEBoJhrhQr3G/W17xXFewtHY1tddlfn
         DuDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=/MNhvAe1aUSGuYylMPVo6sUzj61ox1fF3EFAj+VYkMo=;
        b=sp831+Dk8yZkKvC+WsSMh9iGZGLQWYO2AruC1S91wcq7ks/M5KzEq1w5I16rZywwYk
         Fd0xJsO07sVH3zANa6BrFYV76/zv6eFdl8r7WSL5mXEM6sjN/qRLZapHXumbv+4HZSaK
         CG0ZxXEOQUw087/RFuZZi8heCAy9OK2y0lTeapsbgyzLDsmlW8Lkp8uGTgElMIcfyNxE
         0y2vOEGL3RvDM7jOr1SYnxSex4t4t2vSrlsbghlS3zp+dH5Mkf7QQDDoFG/WFXb47Eq4
         TdkJPzscw6tqrmj9KVfHc5lLM3atCG1et12+0yqeh1inq0caFqnWCIz8VApbxkyGa/Fl
         8D0w==
X-Gm-Message-State: APjAAAUMWqoC1ACtU9hU1BaQqwr3WgZzAqo5HSCw+fCnBAFb1TwqeSXR
        2Uph+PqNY9CVu1KbN8z+tQ8=
X-Google-Smtp-Source: APXvYqzJYRF+TFURVDpwNn2tIkwnGmrjFdJ1DkgdL+dqaDtOskq6PID6zwDlUObcq/nHZq601qKdQQ==
X-Received: by 2002:a17:902:e38b:: with SMTP id ch11mr25057plb.275.1565797202982;
        Wed, 14 Aug 2019 08:40:02 -0700 (PDT)
Received: from [172.26.122.72] ([2620:10d:c090:180::6327])
        by smtp.gmail.com with ESMTPSA id t4sm145873pfq.153.2019.08.14.08.40.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 08:40:02 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Magnus Karlsson" <magnus.karlsson@intel.com>
Cc:     bjorn.topel@intel.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, brouer@redhat.com, maximmi@mellanox.com,
        bpf@vger.kernel.org, bruce.richardson@intel.com,
        ciara.loftus@intel.com, jakub.kicinski@netronome.com,
        xiaolong.ye@intel.com, qi.z.zhang@intel.com,
        sridhar.samudrala@intel.com, kevin.laatz@intel.com,
        ilias.apalodimas@linaro.org, kiran.patil@intel.com,
        axboe@kernel.dk, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH bpf-next v4 8/8] net/mlx5e: Add AF_XDP need_wakeup support
Date:   Wed, 14 Aug 2019 08:40:00 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <FA76BD00-F81D-453D-AB70-BDE6A4E0950E@gmail.com>
In-Reply-To: <1565767643-4908-9-git-send-email-magnus.karlsson@intel.com>
References: <1565767643-4908-1-git-send-email-magnus.karlsson@intel.com>
 <1565767643-4908-9-git-send-email-magnus.karlsson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14 Aug 2019, at 0:27, Magnus Karlsson wrote:

> From: Maxim Mikityanskiy <maximmi@mellanox.com>
>
> This commit adds support for the new need_wakeup feature of AF_XDP. The
> applications can opt-in by using the XDP_USE_NEED_WAKEUP bind() flag.
> When this feature is enabled, some behavior changes:
>
> RX side: If the Fill Ring is empty, instead of busy-polling, set the
> flag to tell the application to kick the driver when it refills the Fill
> Ring.
>
> TX side: If there are pending completions or packets queued for
> transmission, set the flag to tell the application that it can skip the
> sendto() syscall and save time.
>
> The performance testing was performed on a machine with the following
> configuration:
>
> - 24 cores of Intel Xeon E5-2620 v3 @ 2.40 GHz
> - Mellanox ConnectX-5 Ex with 100 Gbit/s link
>
> The results with retpoline disabled:
>
>        | without need_wakeup  | with need_wakeup     |
>        |----------------------|----------------------|
>        | one core | two cores | one core | two cores |
> -------|----------|-----------|----------|-----------|
> txonly | 20.1     | 33.5      | 29.0     | 34.2      |
> rxdrop | 0.065    | 14.1      | 12.0     | 14.1      |
> l2fwd  | 0.032    | 7.3       | 6.6      | 7.2       |
>
> "One core" means the application and NAPI run on the same core. "Two
> cores" means they are pinned to different cores.
>
> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
> Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
