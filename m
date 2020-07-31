Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F87D234E8B
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 01:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgGaXW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 19:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbgGaXW6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 19:22:58 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D94BC06174A;
        Fri, 31 Jul 2020 16:22:58 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id w12so19653761iom.4;
        Fri, 31 Jul 2020 16:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=VDlp+vz35U0aK6Af2jpr6odZDXMA0hDHMcs5tnXQOE4=;
        b=rO88Sq1Rp/ODBrb/upGmxgtwBjZdOBar8kYJvoiLT0WMm3GFxhoJnqUh2v/M0HoLuE
         PdsOprQ9IFN39P2qU+j4jAqVbjPn/jDFuzu05aokFfTl5s2tX35pwpvGFzZQkMz36C+K
         OF1ivT+tZcgV/5Z+simprl55ZOd0zxHbmjz0JQHx8tn4XyMJ3HQf5xEFbJHX9wZh5cIe
         lcas5rxjs2GBohByH6xILKUD5m41/46rh2ixtS+9Ohv4I/w1LtSN1JoB6SpP7+pvOo9u
         jTYxZg+D/MubpuItgGzxV2pMg7uU385eWWJt0/OXgKWfzLc0t1Ilkw1od6erlba6MBW0
         yjZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=VDlp+vz35U0aK6Af2jpr6odZDXMA0hDHMcs5tnXQOE4=;
        b=Pa1dye2fyhRmYRy1mDpB8fIe8F4Txx5QO+CZse6Vtmb9qEBYsVr1UhVlGc4E1tvz6q
         hWt/zYaS5Z0iY9jnEUhOQSaIRDY0OAYOhJhhYIRVSKBezKnGeAONkoMYWVZkkgvNGOb5
         GOq1GMPCUTCHyL+BBjQE3sL4hkSuuyqKdXcpwEvRShzNxA1SxBPSezSPO+9wjPIWmw1k
         a0oeAoW0g5WprdX6sN+GqMb/EKb3vhHk1vyKajWh5Cpr0k9tH4WN9ZzdoOdY1TDi2QVa
         iYUkalqtGdTUwiRveeyIEINee0YN1XPUkEMJ7LjDOevrI18di3HoytIgurhTJh5Q2C1h
         Z0Rg==
X-Gm-Message-State: AOAM53232KzMTjJdT7m0gG0QQuh4vZFsB4QL7sZqx3S6NimoPj4ziof8
        nwFHZ/4UOho7HAoVpxD0KDc=
X-Google-Smtp-Source: ABdhPJytPFlYUWiCYFeWSC4Hk/res7kDBJbkyotfKB8Tl+iE0wKV5+4s+qHn3F7IWq/+kShVRGheFw==
X-Received: by 2002:a02:5e85:: with SMTP id h127mr7722227jab.49.1596237777470;
        Fri, 31 Jul 2020 16:22:57 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id t15sm6029066ilk.50.2020.07.31.16.22.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2020 16:22:56 -0700 (PDT)
Date:   Fri, 31 Jul 2020 16:22:51 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>,
        Song Liu <songliubraving@fb.com>
Message-ID: <5f24a7cb14074_54fa2b1d9fe285b4b6@john-XPS-13-9370.notmuch>
In-Reply-To: <20200731182830.286260-3-andriin@fb.com>
References: <20200731182830.286260-1-andriin@fb.com>
 <20200731182830.286260-3-andriin@fb.com>
Subject: RE: [PATCH v2 bpf-next 2/5] libbpf: add bpf_link detach APIs
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> Add low-level bpf_link_detach() API. Also add higher-level bpf_link__detach()
> one.
> 
> Acked-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---

I like it nice and straightforward.

Acked-by: John Fastabend <john.fastabend@gmail.com>
