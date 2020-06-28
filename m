Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3090320C96F
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 20:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgF1SHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 14:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbgF1SHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 14:07:21 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9775C03E979
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 11:07:21 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id d4so7262992pgk.4
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 11:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6tuyUOIxjyWqmJnamgu5030/ktbw/T7BcK6BoFh+6w4=;
        b=fgRbYlHcbEyAsXiiRDjM23HJj3hb8WE6VsZiX/Hr3CJjGuVXv7iJYAf93hQ+O5WJCY
         p3yNdC60sJ/dFwXur3n6gcgxDyYk8yGRGL62gjO8UT7ozUWjaOJb5dYwknmuWlvOcEsO
         jy0RVEVAkDjxMLunk51GCgi9oMOl0rMSRkdc+//UC6zq6YcoA3Xnp/BzXZm0MhGuqndU
         yrWCG6hl3Kx0pUc2rldNwAUE9kBRtui73SUgt3m77o8Zpf4Plx7xwavmDvugJTG8my9p
         4Of+PTTI+8E0Tii8aPAPkIcXZkzNAQFs6Zn346Z0p2WzR49Qb0u+Bdb8t/+2lieDxG6H
         IuTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6tuyUOIxjyWqmJnamgu5030/ktbw/T7BcK6BoFh+6w4=;
        b=QCF5pIimofMmsVpxNDHvasB2W37b3DX13t8m7MAV31hVv5K9nX5CMfYULCvXiOG042
         2+qfZwGjomT0J5Xp0by+DX8E4pYV69TJmkBI42ih+wQ3YCIUgYdf2jdIjRr99TZ00QsZ
         QaSUabrFGhAVlxszucISHvLaQ+jA+4TskB1ve3t3CQ74q4AzKSFZzil0olgpyXK476l7
         BtOAQNKArL/t+a/w6OXC6tLY9CfSdZwowVNdxAmeqNDTum6TK7IcwG3jfzdv1oJ2zinJ
         kVify8TURVxtOc/3DsRYUKnHXzvKBHCS3MM2m3nF6rdGzYuTWJN/AZYvH5Nh0d0dZLAd
         Cy7Q==
X-Gm-Message-State: AOAM532j7vQkVSeH+oQSKO7glP7yKRd8v+L+ypQiIxKkV6GadxoyNPj2
        TfdFp/991KkhwSk+KEgmBP0TSrmPqs0=
X-Google-Smtp-Source: ABdhPJyPiLhUifFjYG/SZcvRgN4vsyMYBlrqcVyuakPUwUEcDSU7K2KSaY29hXEHYFTfrJSM1cXWgg==
X-Received: by 2002:a63:7246:: with SMTP id c6mr7259769pgn.422.1593367641325;
        Sun, 28 Jun 2020 11:07:21 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id t1sm3553064pgq.66.2020.06.28.11.07.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2020 11:07:21 -0700 (PDT)
Date:   Sun, 28 Jun 2020 11:07:18 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     zhangnaru <zhangnaru@huawei.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] bridge-utils: Check parameters reasonable of path cost
 and port priority
Message-ID: <20200628110718.167fd9e1@hermes.lan>
In-Reply-To: <3E3F5F15FD425047800B90FF7EEC401F581910@DGGEMI511-MBS.china.huawei.com>
References: <3E3F5F15FD425047800B90FF7EEC401F581910@DGGEMI511-MBS.china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 28 Jun 2020 12:24:14 +0000
zhangnaru <zhangnaru@huawei.com> wrote:

> Subject: [PATCH] bugfix-bridge-not-check-parameters
> brtctl_cmd.c: check parameters reasonable of path cost and port priority
> In function br_cmd_setpathcost and br_cmd_setportprio, check the input
> parameters are within a reasonable range to prevent the obvious value
> error before set path cost and port priority
> 
> Signed-off-by: liuqianya <liuqianya@huawei.com>
> Signed-off-by: ZhangNaru <zhangnaru@huawei.com>

Not sure it makes to put patches on a dead utility.
Use the iproute2 bridge command instead.
