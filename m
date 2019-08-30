Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31E15A40C3
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 01:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728187AbfH3XGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 19:06:00 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41428 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728208AbfH3XGA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 19:06:00 -0400
Received: by mail-pg1-f196.google.com with SMTP id x15so4236598pgg.8
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 16:05:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=vQ0RQyeBGvlKMouk4X7nITJZVdjq0EWkMY4a5NZ/dZQ=;
        b=xQRCv0mi0eqGRYV/ApW2A3oDEZUa1JFHMJTj+zkFkf66OWCAFlrAkvdcmOExCKzJp/
         8d0lJBfUjEAhih8i9BG0EXJVvpJZWbBbaywySUXCV3N9UZcW4SBLFn2cxICiXyjzMdev
         ODyPR1MUXBohpro70eUuwg03iB5iVzUq84iTGwcTK1afHHJ82QZbgGCodDkdVbhMDlz+
         gnxzBHlYewWJrM1rEY7SuBEgSPQjN5ZmeCeXCzSgiErCGZiilfRAiR0MgcSv+b3q+jK9
         DYU+Pbpsxpz05Eqq8GODoDR98sC6ZaTakqg4XmHEfaJaRbYCYLevZFVCS60Yq5GaPWhN
         NQ9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=vQ0RQyeBGvlKMouk4X7nITJZVdjq0EWkMY4a5NZ/dZQ=;
        b=szvsa5kuJjE9Diis2WE8dsvx6R8OA3OIYhkAxdjKr/1nqea0VX577Me5gHOnv4jinQ
         A/0MWcpn4h0Z+t9Wq2UalWwsVDbupXeIhuVpNX1MsGqc6aNU8/JTtcpiVrRVrfjqFaFP
         5ambY3uEqdBIVDY8wRLL99/HCFbWp2rc5bN/fVpl2aP8z9rGzkchqJ+fVP8WkgRj668P
         bYaUgQQV2X2Txk1J0OjRXkv5tG9zAf3rHiE7kvTyxocY81jgAsi7u8tgDyz8cMf09qtU
         aOCArLGMKbnFnubpX6qetvg6QBVCMRwWJqWTgQBW3we3ODFp2/OE4qFms38pNX4m0y0p
         Wyjw==
X-Gm-Message-State: APjAAAX4VZyXWVeZ+SF9wGn4sg0NBt3ayppCJBEBNPTONsA4kuza0tDo
        gPXxGgy9DTspReoAaAYcnc3FYg==
X-Google-Smtp-Source: APXvYqy4SP+CeDdQB323fXjcyLOvixFSIEIvkWq/VTDq2eiaZ/PI0TTeUDqlL1VjeoU5O8Dnut/1iQ==
X-Received: by 2002:a63:7d05:: with SMTP id y5mr14993115pgc.425.1567206359284;
        Fri, 30 Aug 2019 16:05:59 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 2sm7101550pjh.13.2019.08.30.16.05.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2019 16:05:59 -0700 (PDT)
Date:   Fri, 30 Aug 2019 16:05:36 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     "sashal@kernel.org" <sashal@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next, 1/2] hv_netvsc: Allow scatter-gather feature
 to be tunable
Message-ID: <20190830160536.0da5fdf2@cakuba.netronome.com>
In-Reply-To: <1567136656-49288-2-git-send-email-haiyangz@microsoft.com>
References: <1567136656-49288-1-git-send-email-haiyangz@microsoft.com>
        <1567136656-49288-2-git-send-email-haiyangz@microsoft.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Aug 2019 03:45:24 +0000, Haiyang Zhang wrote:
> In a previous patch, the NETIF_F_SG was missing after the code changes.
> That caused the SG feature to be "fixed". This patch includes it into
> hw_features, so it is tunable again.
> 
> Fixes: 	23312a3be999 ("netvsc: negotiate checksum and segmentation parameters")
         ^
Looks like a tab sneaked in there.

> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
