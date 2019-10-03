Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01A92CB240
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 01:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731177AbfJCXVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 19:21:48 -0400
Received: from mail-qk1-f171.google.com ([209.85.222.171]:34355 "EHLO
        mail-qk1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727452AbfJCXVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 19:21:48 -0400
Received: by mail-qk1-f171.google.com with SMTP id q203so4172374qke.1
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 16:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=zOlNXsg6dMk8T+sUP8mE7g/346LvIpkwBfyB3eZ4X6k=;
        b=Oxj1L7vQ5NThDaq89uWtFseP9uMw8AyDvH7+uyXYUa/+5GXUTI8JK5vZ9JHMnL1ktH
         GvJQlXzFrLM2MzWj1NhjhiLyImn05Jo7XgColG2yedSGuTIFz5MmLwpza32EcVcwHajL
         Cz2uxVpW+19dHABmYOZKhdBs+d9Y7CKH1IpyQqy1Bu4qx5JwsqqXkiOE+3hB3rvgraOu
         QaZawnjOVzGzLz3WOx0w85nMOVMeiDv8O+SnKglYpqKHQoUpzZUMrsn2eUUkiA9ggOr3
         9BSo7VRJ/H3LDbQ0XAelz/I4/GV6c+J7th5xlFpq1LGIor84qwEqxl/2JXx1KfO8WhiK
         wXcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=zOlNXsg6dMk8T+sUP8mE7g/346LvIpkwBfyB3eZ4X6k=;
        b=rCFa4GPP3UHI/cdVqW3CYosOmjEjWl7k19qcLldxAY37ED2P/f3chDtW2z/XgZzDn3
         mlW4uvrmw9oDqsRaK2NOfwMWt9SVF/FxgblXlSMs92RJpWjZJ2NSN88iL5KJBGcr4Akd
         Xr4RkByrXTZ84gOkHGucQNfvXUcUT5dlSH4CC4HxMDwjTCIDRMAPwXlkq4IGFBfgntAU
         WnmvzAU8znYito27RTHeGUAcnolgUVPmh+UJDZCSdETwAoVz+ZKRZxJ6M87mh/VAe0T3
         fUu+uB7h3kdt3mc33N/g4KUeCiglW3WT51q0Woq+1pB6HEmwqVS66IAhY/j+72B9XeN3
         /ESw==
X-Gm-Message-State: APjAAAV055ZQoItrWG0/DQZNjap9aym5HgwvixGg2IlYzSAY/V7kC2Pp
        jzScNtvawqmiln2q13a97hsFMg==
X-Google-Smtp-Source: APXvYqzp0QnNmU2LDbyhAUU0RWwjOMdq//ALQZsV2NuWkxBfZKQZSzwLFGeWVCXIazmPkg7FdxoR7g==
X-Received: by 2002:a05:620a:6cf:: with SMTP id 15mr7166011qky.112.1570144905835;
        Thu, 03 Oct 2019 16:21:45 -0700 (PDT)
Received: from cakuba.hsd1.ca.comcast.net ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id h10sm2153107qtk.18.2019.10.03.16.21.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 16:21:45 -0700 (PDT)
Date:   Thu, 3 Oct 2019 16:21:39 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@mellanox.com,
        dsahern@gmail.com, tariqt@mellanox.com, saeedm@mellanox.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, shuah@kernel.org,
        mlxsw@mellanox.com
Subject: Re: [patch net-next v3 13/15] netdevsim: take devlink net instead
 of init_net
Message-ID: <20191003162139.0c360701@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20191003094940.9797-14-jiri@resnulli.us>
References: <20191003094940.9797-1-jiri@resnulli.us>
        <20191003094940.9797-14-jiri@resnulli.us>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  3 Oct 2019 11:49:38 +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Follow-up patch is going to allow to reload devlink instance into
> different network namespace, so use devlink_net() helper instead
> of init_net.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
