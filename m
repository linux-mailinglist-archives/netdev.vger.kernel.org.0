Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B41E12DA70
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 18:04:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbfLaRE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Dec 2019 12:04:28 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39805 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbfLaRE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Dec 2019 12:04:27 -0500
Received: by mail-pg1-f196.google.com with SMTP id b137so19740013pga.6
        for <netdev@vger.kernel.org>; Tue, 31 Dec 2019 09:04:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IckcsG3HFCabNI08gljyFwaBUv35dNb/kuU/hE7NNxA=;
        b=MliHKoHMj+k0fU50bFAHmgJXBzw8gj51PfKkYSZw+vSOhXZUkAHZYXDvY8xKzQbv2g
         bJgE/lXJb28RnXkTH0Rp0RTyZKlPpM9WEYTlfWGdlAlGlTT+HvbpAiAjpuzpCYC8m8uO
         VuyBBRLo1Mapg2CchNrl8QdWO6/uXbcDU6cRAHqx8R0s9/dBLBsaH/QRAoauvITxmjPo
         ysIdrj2yryM82u4JqqzNxCyG4G0adbSSfUxV94M+baB6AMsO32qs5zdTeLlsqscSsSKT
         fqBDiiDf/hC/AVbqPO8/ZHdg3Fdhn2FGDu4Jfdq/B6P862w/kyedoAcneQkT21njTkJn
         Leiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IckcsG3HFCabNI08gljyFwaBUv35dNb/kuU/hE7NNxA=;
        b=MuO9XOjPCgzbwOqIUsOvDjZ1PabhTM6ptMOc6hRqYMf2SDTMBlx6ccTnr0cTKu0OAb
         7fhtW9PK0COwkhHZbAbybS3vYhWYrMPlVXs4RmKIhlH+64FebCtzX6mWh4KN1ffkdoMs
         Oov6QPsWBCBgIyx8u9qVhYHokMerRD4Sv5yhXg1Cfdi2CG9IGe9zcfGuajWoVuF/qg7D
         FzsMd2XYYzU3GCmNqwHOQB/T3mF7UlU6wBtBg19qy+iZ0TspuuGlYqGQuH9U2ojN6D1q
         uaTzbOFGwfXbgTDnOV9yyyypkgAL+TzCr5klU3VOMLM3iDE3bGH2Nja3vMkLHYQuS7mG
         TEnw==
X-Gm-Message-State: APjAAAWvow9I850WpSO3CrNGr0QwBzb7PjSJKYnVR2LVUx6B90OYVwXh
        BIB/pDmqTqFI8utxk3hDB12hEA==
X-Google-Smtp-Source: APXvYqzpfv2nWhp+K0R5Pps3ltheGedZuBQgo7ZbZ/AGIZnpuTbIgOUmD3Vs54gq5YxrHcFQOKSmmQ==
X-Received: by 2002:aa7:83d6:: with SMTP id j22mr57425011pfn.122.1577811867121;
        Tue, 31 Dec 2019 09:04:27 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id u23sm56579232pfm.29.2019.12.31.09.04.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Dec 2019 09:04:26 -0800 (PST)
Date:   Tue, 31 Dec 2019 09:04:18 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     gautamramk@gmail.com
Cc:     netdev@vger.kernel.org,
        "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>,
        Dave Taht <dave.taht@gmail.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Leslie Monis <lesliemonis@gmail.com>,
        "Sachin D . Patil" <sdp.sachin@gmail.com>,
        "V . Saicharan" <vsaicharan1998@gmail.com>,
        Mohit Bhasi <mohitbhasi1998@gmail.com>
Subject: Re: [PATCH net-next v2 1/2] net: sched: pie: refactor code
Message-ID: <20191231090418.56adedc1@hermes.lan>
In-Reply-To: <20191231112316.2788-2-gautamramk@gmail.com>
References: <20191231112316.2788-1-gautamramk@gmail.com>
        <20191231112316.2788-2-gautamramk@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 31 Dec 2019 16:53:15 +0530
gautamramk@gmail.com wrote:

> From: "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>
> 
> This patch is a precursor for the addition of the Flow Queue Proportional
> Integral Controller Enhanced (FQ-PIE) qdisc. The patch removes functions
> and structures common to both PIE and FQ-PIE and moves it to the
> header file pie.h
> 
> Signed-off-by: Mohit P. Tahiliani <tahiliani@nitk.edu.in>
> Signed-off-by: Sachin D. Patil <sdp.sachin@gmail.com>
> Signed-off-by: V. Saicharan <vsaicharan1998@gmail.com>
> Signed-off-by: Mohit Bhasi <mohitbhasi1998@gmail.com>
> Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
> Signed-off-by: Gautam Ramakrishnan <gautamramk@gmail.com>
> ---
>  include/net/pie.h   | 400 ++++++++++++++++++++++++++++++++++++++++++++
>  net/sched/sch_pie.c | 386 ++----------------------------------------
>  2 files changed, 415 insertions(+), 371 deletions(-)
>  create mode 100644 include/net/pie.h
> 
> diff --git a/include/net/pie.h b/include/net/pie.h


Adding lots of static functions in a header file is not the way
to get code reuse in Linux kernel. It looks like you just did
large copy/paste from existing sch_pie.c to new header file.

You can use reuse data structures and small 'static inline' functions in a header file.
But putting code like drop_early in a header file is not best
practice.

You need to create a real kernel API for this kind of thing
by making a helper module which is reused by multiple places.
