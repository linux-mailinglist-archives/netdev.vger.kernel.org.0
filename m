Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6753C11FAC0
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 20:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbfLOT2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 14:28:42 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:37659 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbfLOT2m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 14:28:42 -0500
Received: by mail-pl1-f194.google.com with SMTP id c23so3513002plz.4
        for <netdev@vger.kernel.org>; Sun, 15 Dec 2019 11:28:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=rPsHgWoVliUzCfoQUS1blic49KbyQ3P6hiA0vlRuwPM=;
        b=0G2KwDeOvr1PDWkhsZKhj8sJ1DujRF4X9/bHT1Uos4Jh8MPKOhC7vni6/4tLnoHtL7
         D/Otm24z0mViKDeN9vQq8zOsgqx2+bLs1HfJFilk5SPij+NzgHnXcJfswMRmbKKsNho6
         NOKktmfpxioWjJ6m/gz5tOQTvMIB9He5hDD7IMPBKFX+WdfeJFcnx+xFNiOu8eyiy9Pl
         PbLr95+W3BY1P5cOuHqa1BUfr+DDwl/gEFDWd6YFG0D0cXBiuN9S2hHAaXcmJtzKPtDR
         WZiFuV62EhYsNu0RdJvXCL+0cPTbxJ2lG0SMjk3uMjPGan8H2dTgBFmnal8BZ/HwvooH
         9cbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=rPsHgWoVliUzCfoQUS1blic49KbyQ3P6hiA0vlRuwPM=;
        b=q0BaAl5+kP3Sh/dRbmVwNRqWsHobZ5OAxd3cWp27Gmkns/wtXKGwuf/v89CgLq0Kf1
         ycnjSdTRcBvYQtRBgumPgmOWVfDOVndq1CPllNZnj6kDHIeiDS4mpZympmmIXORubHH1
         kSxaeA54FUkUuO3jEiRTp+rFVI4p/eM1l0tqNvUbkv/N2NgXJz9vNPzj7S+UfUyGXm4X
         zbseF3MCrx96pLGg7R4/CP222XeZKn5E9VboqBL09W6eRq9PR+7msIJTNK9fCGgFmc49
         CurIWlTImZsbkeQFB68dJZcgXJVi9MfMtd3HJfAwmpjdafNnH/+RXTK2yIA17dWNd0Rb
         uaFA==
X-Gm-Message-State: APjAAAV0ZVCpJedw1hmbJAVzraZr5L1PovpBh//Stg5FHektAcinl1jg
        7D3kkuhOr3vYruU6gxXvmAYU7lyMeac=
X-Google-Smtp-Source: APXvYqyJ6kaEyj5IIfO5+eRuaORTbCt+3SmsHm9xZzq2vSNPweQNYWmpqmYvPksVo0AV5ApDEv+FtQ==
X-Received: by 2002:a17:90a:3ae3:: with SMTP id b90mr13861251pjc.62.1576438121816;
        Sun, 15 Dec 2019 11:28:41 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id x4sm19056105pfx.68.2019.12.15.11.28.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Dec 2019 11:28:41 -0800 (PST)
Date:   Sun, 15 Dec 2019 11:28:39 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Vishal Kulkarni <vishal@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@daveloft.net, nirranjan@chelsio.com,
        Herat Ramani <herat@chelsio.com>
Subject: Re: [PATCH net] cxgb4: Fix kernel panic while accessing sge_info
Message-ID: <20191215112839.7844fbb7@cakuba.netronome.com>
In-Reply-To: <1576199379-24260-1-git-send-email-vishal@chelsio.com>
References: <1576199379-24260-1-git-send-email-vishal@chelsio.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Dec 2019 06:39:39 +0530, Vishal Kulkarni wrote:
> The sge_info debugfs collects offload queue info even when offload capability
> is disabled and leads to panic.
> 
> [  144.139871] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  144.139874] CR2: 0000000000000000 CR3: 000000082d456005 CR4: 00000000001606e0
> [  144.139876] Call Trace:
> [  144.139887]  sge_queue_start+0x12/0x30 [cxgb4]
> [  144.139897]  seq_read+0x1d4/0x3d0
> [  144.139906]  full_proxy_read+0x50/0x70
> [  144.139913]  vfs_read+0x89/0x140
> [  144.139916]  ksys_read+0x55/0xd0
> [  144.139924]  do_syscall_64+0x5b/0x1d0
> [  144.139933]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [  144.139936] RIP: 0033:0x7f4b01493990
> 
> Fix this crash by skipping the offload queue access in sge_qinfo when
> offload capability is disabled
> 
> Signed-off-by: Herat Ramani <herat@chelsio.com>
> Signed-off-by: Vishal Kulkarni <vishal@chelsio.com>

Applied, please provide Fixes tag in the future.
