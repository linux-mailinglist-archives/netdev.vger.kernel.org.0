Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF46D1EF5
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 05:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732688AbfJJDie (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 23:38:34 -0400
Received: from mail-pf1-f174.google.com ([209.85.210.174]:37056 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726709AbfJJDid (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 23:38:33 -0400
Received: by mail-pf1-f174.google.com with SMTP id y5so2980925pfo.4
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 20:38:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=nvMSdzhDq2v9CJ3QXH920L5RTwB2/2dix39S4REPtqM=;
        b=UxZ2qdrFonjnqmTayw67wl78XHBAJ+DppcT0s2jix/MIV9kotIIPWtDj647SgrlE4W
         Q+O4P6hgc9vBHWYu2Bw3yIj9o4SRkJlWUFOxpl29aQGR+IXxlGnv0n4J1iHgqL3J8rGp
         RDlOrRDWC7Y/5vT5tzurILX6OPX4bSP9oxEQED4mGVUK/XggpEGLu6DenjmbubWt2SZg
         DqgLpWdWAcx1KrMiqG3/xOId5j1DoEo/7fJ2UV0UVExE+EduGMzRvxbFLj5VUak9OO73
         S3BEMmXzb7fgzHcfiEEns52V2q3BboZWqKdIxEp7+HpwTQWel4w5uvnmTa0cmpp58VS/
         zyRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=nvMSdzhDq2v9CJ3QXH920L5RTwB2/2dix39S4REPtqM=;
        b=K8Khaq1VW6IzO1pJT4CLcLaZtTomX/rX3omyOA+cCTmwF/1c7TDimtSlJQrWlSh6g1
         ISQotcEX83osE7k+JcCGj36kW9tlB5sSwJwtpUIHT+sNud7HZX1jRKfUBm21K4PiU7zM
         6EQiUyNCVvOi5pj/Qzx5PtiGv0g/F6ixSEE0p5mdlfS0pSQok0RK+zE0iYnppAxDAiaF
         LlMic6nJRPMUb5LM4AKFiKBFLZm/rDKr5Zd6t7iPGhH7RhRPymzDmRvhtXWGLbf67go6
         xRoYsnJdboqnFyAWauAdZY7Oafein7q9+DUrx45GgtIOcwBn7ONlUg7LZv8ExhWaNbYl
         MSQg==
X-Gm-Message-State: APjAAAVgufqYwevq8hSJFhg+IM9SCNXi7+8X+L3/VCPsFhUGPkHm3C/b
        qg5Cp8AsfDnYqdrZKroam5gOJLuCp6M=
X-Google-Smtp-Source: APXvYqzn8PvMUNGh7Jk181owtHN3ozrpVV9H5OS+ciPWvnjxx1cwpBRoo223hiTLbzquaBEme1XJDA==
X-Received: by 2002:a17:90a:8003:: with SMTP id b3mr8442855pjn.43.1570678712843;
        Wed, 09 Oct 2019 20:38:32 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id w27sm7302055pfq.32.2019.10.09.20.38.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 20:38:32 -0700 (PDT)
Date:   Wed, 9 Oct 2019 20:38:18 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, ayal@mellanox.com,
        moshe@mellanox.com, eranbe@mellanox.com, mlxsw@mellanox.com
Subject: Re: [patch net-next 2/4] devlink: propagate extack down to health
 reporter ops
Message-ID: <20191009203818.39424b5d@cakuba.netronome.com>
In-Reply-To: <20191009110445.23237-3-jiri@resnulli.us>
References: <20191009110445.23237-1-jiri@resnulli.us>
        <20191009110445.23237-3-jiri@resnulli.us>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  9 Oct 2019 13:04:43 +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> During health reporter operations, driver might want to fill-up
> the extack message, so propagate extack down to the health reporter ops.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

I wonder how useful this is for non-testing :( We'd probably expect most
health reporters to have auto-recovery on and therefore they won't be
able to depend on that extack..
