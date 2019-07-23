Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44B4871E09
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 19:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388511AbfGWRyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 13:54:10 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:47006 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731661AbfGWRyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 13:54:10 -0400
Received: by mail-pf1-f193.google.com with SMTP id c73so19506719pfb.13
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 10:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Xg18Wmcda2NQTY3JiovoNWKyppM8RU1ptP6rzatQkgY=;
        b=tr8ftqIN0pNicDIeNPmyElDXnXHA95F2FUV5c5mLRGDZNerd6+CIInh8bWEOt01yCu
         bgZmIjcj3Pg6svrTWnVFF6uwc7yTgAW0661BPVxQ3rBMJQQp9a56SoZaVxa+5n+Wja6H
         olnH8xPDslI+LgSlWVsURyVxb7J3+gX72qdZ2R4T2fLS/1SmL7YGOpJ6A/eo+mVSb1Q2
         nNFSAOrLADmZnCdKAtWgpb85ZwG0iWerDPm3zzOzDhYnzvsLXYeQtGGCNS7saVmIwbc0
         mZgVdI7FU5P4rfujzY1o2gCVHV/YAJDsGwskntCM/VWXG4Cj8Y5JB3hHLC9b1VSFeiL6
         O2tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xg18Wmcda2NQTY3JiovoNWKyppM8RU1ptP6rzatQkgY=;
        b=mTLXL9lRk8UsCoBrh33z+ocvINNuDBi/dbgYoAfWmvRYiDx6YEexRHN+femmgr6YlH
         2y36PJlHFW4WkDGqwK8Q9MTrOuvyXn/6xHluBsgJ21F6qw5Ta/+l4G8umvCN+5a2OLiH
         jPpgkluL2YotGmiogpzrskQbTa3LvbAuaBUYKEB/MuWWgIJ0NOQw4wjuF0vqQ/jpbdQi
         NEd/2kR+SZymT5FV4tTCCBGrWMoK3OcIZXmPuCCmMd/S7g593vsEA7R9me1xPRs8UKLF
         N/qOP2PavcXomSrJShVnd3dYGlh8MmjWENbI0UlT3azrOlnkojDYkfvYmDUHCUcfC5OC
         Mv+Q==
X-Gm-Message-State: APjAAAV2ivempT1SNXyO7bTH+jHIzbtj45N20sLF4f4clc/XgeDPCBXf
        hTi4S50Iocv9g44yCw+Z/GA=
X-Google-Smtp-Source: APXvYqwKJO4SEs1ZHhPct09jy3lm7BIpldeakDhri7IUN8T79zbQqhF9BUc21tqhTHmbUSJ+o+7bjg==
X-Received: by 2002:a62:2aca:: with SMTP id q193mr7142223pfq.209.1563904449382;
        Tue, 23 Jul 2019 10:54:09 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id q22sm39271506pgh.49.2019.07.23.10.54.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 10:54:09 -0700 (PDT)
Date:   Tue, 23 Jul 2019 10:54:01 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, sthemmin@microsoft.com, dsahern@gmail.com,
        alexanderk@mellanox.com, mlxsw@mellanox.com
Subject: Re: [patch iproute2 1/2] tc: action: fix crash caused by incorrect
 *argv check
Message-ID: <20190723105401.4975396d@hermes.lan>
In-Reply-To: <20190723112538.10977-1-jiri@resnulli.us>
References: <20190723112538.10977-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Jul 2019 13:25:37 +0200
Jiri Pirko <jiri@resnulli.us> wrote:

> From: Jiri Pirko <jiri@mellanox.com>
> 
> One cannot depend on *argv being null in case of no arg is left on the
> command line. For example in batch mode, this is not always true. Check
> argc instead to prevent crash.
> 
> Reported-by: Alex Kushnarov <alexanderk@mellanox.com>
> Fixes: fd8b3d2c1b9b ("actions: Add support for user cookies")
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

Actually makeargs does NULL terminate the last arg so what input
to batchmode is breaking this?
