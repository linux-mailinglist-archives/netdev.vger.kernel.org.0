Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C879183971
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 21:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbfHFTNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 15:13:17 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:40449 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfHFTNQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 15:13:16 -0400
Received: by mail-qk1-f195.google.com with SMTP id s145so63815493qke.7
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 12:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=VnZDZzBAZi4D2nAqWC3qKDXkK4ME9tg6Ir4ylUba4jg=;
        b=SGfjoPA4i1Mm/bTUKSTpZMu1+1qm1orBY6Je1wobz3GeFacipSg3vaAISShedMFloX
         LklV3gXrz4aVn2LkyVj4UGkiuug9d6vhoRh51P1R8K08xXmni+YlDqLz8dI3NLFPUtKm
         oXY6zQlFVCaE3xrmablLByoFZQyld45ysxfuYu+Xc5ngbYZpKCyfE+FXoPrChbqAQHHM
         DtLsZmCMf0xURVExyIwdvQDIWIY39E/4jCu6x3sLTdiAC3HbVr/wFL4DQJkY+DtHK78U
         xpyCC6A7pGy23rjcJ8F5xwjRU6ri2zszNhOdqCpClLxZzFBTnmnjXiZE5BLiiVrPSHxA
         AKVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=VnZDZzBAZi4D2nAqWC3qKDXkK4ME9tg6Ir4ylUba4jg=;
        b=kverrLfbXE+hgjTVt0MAqrjALF3tqJM23VZyqzF8U1aXCsQH4PBvT4kPrxfIjbtKFB
         v1LUkyP/19vrAqn2CXZfEWtqou+h3K5WGrqWuo4y2iK9oVqrppnNm5ScFmzdH1fte3yC
         G1zSd1djaAgPdT8UwQgGFtjhb7rnTq0HdgwaS/IWjA6OhEVILhq6rXMTmBinDirVyMyF
         1qfouMM/cGU9r12fnTxqfkwfG6Tk4kGsjN0mum+C3AhtWzEXkV7aaai2EL74YcpFVcOs
         p9eZzZ+Ysb2h6AogqVdkeDLL7NroQYIkH+ZBza4Zb3X8oodcvKDhpwafUIV6XJ8SPRKw
         V5FQ==
X-Gm-Message-State: APjAAAVkLYsqD3eFZj0I9k5engunDlfGslxV54fK4HDAjytKADX/rieb
        yIlPwy+hRnBXohkmyvQtCVMCMQ==
X-Google-Smtp-Source: APXvYqwTM9Nkb/KONg55InkFyQG+V6Xua7EUBriiyRj1o00r4ii18WpOUrQTfkoxnkYCgxcEOVoOUQ==
X-Received: by 2002:a37:311:: with SMTP id 17mr4499484qkd.466.1565118790235;
        Tue, 06 Aug 2019 12:13:10 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id z19sm40441271qtu.43.2019.08.06.12.13.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 12:13:10 -0700 (PDT)
Date:   Tue, 6 Aug 2019 12:12:42 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        vkuznets <vkuznets@redhat.com>,
        "marcelo.cerri@canonical.com" <marcelo.cerri@canonical.com>
Subject: Re: [PATCH net] hv_netvsc: Fix a warning of suspicious RCU usage
Message-ID: <20190806121242.141c2324@cakuba.netronome.com>
In-Reply-To: <PU1P153MB0169AECABF6094A3E7BEE381BFD50@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <PU1P153MB0169AECABF6094A3E7BEE381BFD50@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 6 Aug 2019 05:17:44 +0000, Dexuan Cui wrote:
> This fixes a warning of "suspicious rcu_dereference_check() usage"
> when nload runs.
> 
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
> Signed-off-by: Dexuan Cui <decui@microsoft.com>

Minor change in behaviour would perhaps be worth acknowledging in the
commit message (since you check ndev for NULL later now), and a Fixes
tag would be good.

But the looks pretty straightforward and correct!
