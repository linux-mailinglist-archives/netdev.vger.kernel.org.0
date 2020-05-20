Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 722F81DB8AC
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 17:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbgETPvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 11:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726650AbgETPvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 11:51:04 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B114C061A0E
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 08:51:04 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id s69so1477380pjb.4
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 08:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PGt5BLdFYxU6z1cqTJIqi+js4tZYCy5XiqwrbJue7TA=;
        b=VBDVFrk6oKnVNDIw8raagKq5a8eJuK45dEaNEJhAanbz91rxFKnrQTllLBUsf1VmYC
         NoqgnZ2zzAHzxt/ftq82ycjy2pqQDQCGwnNPuNsAedzasPPDynnRSobblUVi2uAjP81x
         dloti4nJ8TCEoIefrSsNa+yBd5be88qsolNL9eu+S30O7URyhU7bdMrCvhOIgp/x2nh8
         VaJJHi5duJo24MpKRBmNnqCLc/OoeNEceeU7MEBsNfXTkm9fRGgI4MpAQZUCvNZfpOjZ
         aj/YNjC383Z9TeAONWCxS25M+59WYmG0oUtYGird2unKBRZuTIzj3PUiAQJTAtNiMlh/
         rSTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PGt5BLdFYxU6z1cqTJIqi+js4tZYCy5XiqwrbJue7TA=;
        b=AHQ6eQ5ojO86n0J4iRw2L/JyW/CanyokwRNXj+gbIHz6yL/nDuKfGvVHi1Yrx08yaV
         IZevlkOQcsEZ31xC2KdQXJUiIlHsfe8EgIlUaiOx1vVMM68O+LxTJgq7Jy/r6A59uWii
         ZSUYWwImaN0qsDRblw1l+wkbBrquCcGgh/8YiVT1QuiQ2nb17aZcomBcus2/9yiahbSY
         7Bgy6oHHB4VzBaF33/Jl+6cZdAAmBhOExLG+rfwFOO3hFdBXaA1/xx9d1+K51ZafexXd
         S07+Z017n33V2vcPML+/QLXr8p3K5v9HUhx8BTrhsFK96/UegpUmTozRSXaNgTZNGAAK
         kE1g==
X-Gm-Message-State: AOAM531Pj8B1WVww0OlmDjUh3IKwN6c6iuNS1e0Yw75rRmyYOv0iUQd3
        AWx8Kd/vzCmZ16ZiaeK5JXOAzg==
X-Google-Smtp-Source: ABdhPJx04CU5osC8N8WwltpLcZT/kJVkSQfwexK2sh11BxrJR6el86m4PMpCODbiTjaQgxTmnH5d/A==
X-Received: by 2002:a17:902:9342:: with SMTP id g2mr5279742plp.326.1589989863733;
        Wed, 20 May 2020 08:51:03 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id w19sm2343277pfc.95.2020.05.20.08.51.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 08:51:03 -0700 (PDT)
Date:   Wed, 20 May 2020 08:50:54 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        davem@davemloft.net, bridge@lists.linux-foundation.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH net v3] net: bridge: fix vlan stats use-after-free on
 destruction
Message-ID: <20200520085054.2031ad8a@hermes.lan>
In-Reply-To: <20181116165001.30896-1-nikolay@cumulusnetworks.com>
References: <20181114172703.5795-1-nikolay@cumulusnetworks.com>
        <20181116165001.30896-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 16 Nov 2018 18:50:01 +0200
Nikolay Aleksandrov <nikolay@cumulusnetworks.com> wrote:

> +	if (v->priv_flags & BR_VLFLAG_PER_PORT_STATS)
>  		free_percpu(v->stats);

Why not not v->stats == NULL as a flag instead?

Then the fact that free_percpu(NULL) is a Nop would mean less code
in the bridge driver.
