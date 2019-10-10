Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66907D1E21
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 04:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732252AbfJJCEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 22:04:42 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38679 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbfJJCCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 22:02:25 -0400
Received: by mail-pg1-f193.google.com with SMTP id x10so2621811pgi.5
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 19:02:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=FbH5/M1kecQb0plbAd/dEDw3t0kvnc34T2To18NEpXo=;
        b=UtlzfI0tLccGKmIdWg9sx90/N7dfUKvpSt2dxGBvzZcHiqHR6ejVlnBv7sY+H7Y8u5
         jfj71fne8PGRt3C//aAWr7o5WdlEJskXxuiefyoeDtC1rZV+CFLDyPxqPzzPPy0NsSy6
         +sB60oYcvdCeKeNgtsWDCMhF8AXjBqcls/KPSvyfXnRipMfhhadGsWUdURQF4hII01XR
         Tn/UCTqgpnrdNeK02wycBUegegEnBSPCz6oGK+6IMx4UQ/SXTz7RfJyRy/ySQyZMxUVp
         anuQLUe8rDzSrdI+MGgcE8Y5lxtY5RujyK0onYdGNU8vV7NCM7sC5ay+wgdRdORupkCh
         9S/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=FbH5/M1kecQb0plbAd/dEDw3t0kvnc34T2To18NEpXo=;
        b=pV1Er0eQ6lZAMsntQi1geWdkBJCERTNXGM2P8pidCE7rbKro5M2cfg9Nf7S9/5d7zL
         onxkhZY4b9jwZ9CCQcOU0Q7JRWghp2qz8jOhg9ypr9QnCGQmLXZsm8m/ZjmrgRVdreQP
         PD2DSPXqZI+qVdFQ8qaWjy391zHQuexwtsnYLWHMtVFRuBs3xJ/37HC5eJHeO5CUL01h
         u5ZoeQd+NoTckfZ707rVg/o3XEwAcwhOjCD0dSslns0Gtq+vKBXLD07qvl8YGb3N5cRS
         iupPUyGMxYwr0WfEZ4ApgDxEVpSmBX8jyR8A0k224aM7pf+FA2eL/i5qRv4Rb8k/OOqG
         PjFg==
X-Gm-Message-State: APjAAAUzpbp79bLQm4XIbOzRI7aarlclD8ryUNOJQtlQPL66B61zKKd9
        mDTRIBlXA+8DtJvz+7C6mcDzBg==
X-Google-Smtp-Source: APXvYqxMtARq5aDsakYUWw19M1n5cuACR5SNjPQpNTVv6S3ZguHUColDn4ep8TA0yfaBW421SW6ZTg==
X-Received: by 2002:a63:1f58:: with SMTP id q24mr7172058pgm.298.1570672944094;
        Wed, 09 Oct 2019 19:02:24 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id u9sm3490761pfl.138.2019.10.09.19.02.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 19:02:23 -0700 (PDT)
Date:   Wed, 9 Oct 2019 19:02:10 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, gor@linux.ibm.com,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: Re: [PATCH net 0/3] net/smc: fixes for -net
Message-ID: <20191009190210.4592990b@cakuba.netronome.com>
In-Reply-To: <20191009080441.76077-1-kgraul@linux.ibm.com>
References: <20191009080441.76077-1-kgraul@linux.ibm.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  9 Oct 2019 10:04:38 +0200, Karsten Graul wrote:
> Fixes for -net, more info in commit logs.

Please write a sentence or two describing the nature of the fixes.
This message ends up in merge commits in the tree, pointing at the
commits themselves is unhelpful.

Please provide Fixes tags pointing at the commit which introduced the
bug in all of the patches.

Thank you.
