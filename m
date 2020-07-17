Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEEDF223F8A
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 17:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgGQPZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 11:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbgGQPZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 11:25:01 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EFC4C0619D2
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 08:25:01 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id f16so6502484pjt.0
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 08:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iQhboAH+/70hTkJLYw7IEOrOub7JRvHS0jtS3sY0x8c=;
        b=eLgYSTilEjQVC6ChErMndBWHYWTxa6LLgvWfx/JNoUG4f6YMDLiIjsDONPHVu9zKMK
         6BqFYsesDV3CBsfjQfEvM2VMqETQkjGnljfg8Punmmri4SSbxku7M0i4nrzxsgvk3Vlw
         q38YyRQ7Vmut2Hc5SGjpQDJW8cpKF8aonAF88Iwup1uECj6C1LoZHLxSrpuYRg/JMGVd
         v8S/hDeuIdq4bw0Hh9Ebg+xmrwhFMqXuj63Lk9qNEhaLn48H03NpQezq2F7VBXBXC1k7
         2coRF1uog2ZG5z/MWc6+WVraSx1LIRKGSa7U/+zjSMpeCwOuQek7QKM+PSwe7IN++7WD
         MQNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iQhboAH+/70hTkJLYw7IEOrOub7JRvHS0jtS3sY0x8c=;
        b=ChabF84PSOY1UF3Bw5xzL3Vep8/R+gYFJgGIGqSGImV0C474qZNEJd0iHkmOOz4xRO
         9bgQ4P3DJp9/jM203etO86ciiTNAk5fGfF1O/Q555a23Dvx9EIc0AD/QEKDNsd56gT8W
         Zuo6dOtsakIw4P7jazSd/SR56G8e/ImJt+KPgpmDPJlX+H2dNS2IhaTrVFdUDe6VZVuD
         sOCwJku5H+mksSxFFudTfBCo1h8kWfp8QsBy5q0gYvftC5dpsUY8nP8kC4IZqxzpTS0Q
         U21iBn29q3S0tu/kVEte8Gw4g9yTtTmrw6Wc1fPN87pZb0H78gzV/rYE73q/c0+U594Z
         R2Fg==
X-Gm-Message-State: AOAM533TzfYjM2fPAW5Aj+THccMngsITdmmIrkwkeBk7uaXGniZ8iWJQ
        sYSCMspd87DMjKMiGM9OoIWWjg==
X-Google-Smtp-Source: ABdhPJwjH6a2O7HM/12NDEYWOnfnazKhTNVY+A4cqOW+dPsMcjnIwd4/bek9zhH9RDs3Yb2gFV0skw==
X-Received: by 2002:a17:90b:24a:: with SMTP id fz10mr10372146pjb.36.1594999500667;
        Fri, 17 Jul 2020 08:25:00 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id a14sm8124281pfh.81.2020.07.17.08.24.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 08:25:00 -0700 (PDT)
Date:   Fri, 17 Jul 2020 08:24:51 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Chi Song <Song.Chi@microsoft.com>
Cc:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: hyperv: Add attributes to show RX/TX
 indirection table
Message-ID: <20200717082451.00c59b42@hermes.lan>
In-Reply-To: <HK0P153MB027502644323A21B09F6DA60987C0@HK0P153MB0275.APCP153.PROD.OUTLOOK.COM>
References: <HK0P153MB027502644323A21B09F6DA60987C0@HK0P153MB0275.APCP153.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Jul 2020 06:04:31 +0000
Chi Song <Song.Chi@microsoft.com> wrote:

> The network is observed with low performance, if TX indirection table is imbalance.
> But the table is in memory and set in runtime, it's hard to know. Add them to attributes can help on troubleshooting.


The receive indirection table comes from RSS configuration.
The RSS configuration is already visible via ethtool so adding sysfs support
for that is redundant.

The transmit indirection table comes from the host, and is unique
to this driver. So adding a sysfs file for that makes sense.

The format of sysfs files is that in general there should be
one value per file.

One other possibility would be to make these as attributes under each
queues. But that is harder.
