Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4B44CB21C
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 01:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730248AbfJCXDc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 19:03:32 -0400
Received: from mail-qk1-f172.google.com ([209.85.222.172]:40294 "EHLO
        mail-qk1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727452AbfJCXDb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 19:03:31 -0400
Received: by mail-qk1-f172.google.com with SMTP id y144so4088119qkb.7
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 16:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=kVOPEnbcJjPgAft4eD+6AFgA7yeu0kfXt9PkRR3lEn4=;
        b=saStQY0Pc5ieTag2p3XLxAWItR8U96LyvNJHf/geNsxm1K6VXK4RAdDKn5l4GVltFk
         C7iQKqHLbFkZJaVmRz8iVlpwFh8qBkXJm7h5xZnRid8AwZdyExbSe8fcsvpApDL+EIOR
         jOuWSGAoAyUV80TU0GFl1n2oROc/LkCRVa8xPsN6JbgqcqwTLZWMeRgVhB2odv5MRgja
         PBWVL5cE8qeOaztIgSjXDj4cqCf0gEb+etBqTsU0JTXZn+kX8ntWcobkZA5uJ6eUAIYn
         E491zHx5HP/hzqPYpVtZ5q2snY/ImbT76OYz5bKOA4KWvo4QbQn0tvXUo5oEoFbEtIux
         n/YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=kVOPEnbcJjPgAft4eD+6AFgA7yeu0kfXt9PkRR3lEn4=;
        b=pWiWTKLM9I9vE+mCTBaRc79tUtxJy6mELcel9cl0fIA4TECBdS4X3ew2C4Sow7LaWy
         +ZvqoRXBbfAMebE8Cnt/5cXrJIHPSP2zurhG0Oi0U2utgQW8OhCS3yXiHh/vVEuCuxof
         1cM0/kINxPDP9aRSBHqJZj7/JU/iQi55qqov+RXBX0kGGemuIhDya1MDzOj2L8jHjJk3
         +l2bloRXodsn6QHlI4IWcGXDOv1E4pY0u6lLELJjL7l+webNSh5sL0n/rXNaZZ6C/4qU
         C79RWj5rl9s8x8xBkbqnveDEEVqimp4PUiFY3JxBT8I1v1CID6jlUM/DijXDhARPOGL+
         YKWw==
X-Gm-Message-State: APjAAAWgvQ+925aWbEnvjloqcfBt/JbMz6KbiXNDyVm5k4MQHLc0mVbq
        qtf50NNpx4LY57sI0CYuEEQ/CA==
X-Google-Smtp-Source: APXvYqyqwW+u7E/rOC2mbBVv1mKRdnaaXDsk3wIiG0vPv1qVYGgpOIqcsR2+fOD/y4dws2LTO7VP+A==
X-Received: by 2002:ae9:eb8c:: with SMTP id b134mr6892097qkg.377.1570143809521;
        Thu, 03 Oct 2019 16:03:29 -0700 (PDT)
Received: from cakuba.hsd1.ca.comcast.net ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id p199sm2119368qke.18.2019.10.03.16.03.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 16:03:29 -0700 (PDT)
Date:   Thu, 3 Oct 2019 16:03:22 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@mellanox.com,
        dsahern@gmail.com, tariqt@mellanox.com, saeedm@mellanox.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, shuah@kernel.org,
        mlxsw@mellanox.com
Subject: Re: [patch net-next v3 01/15] netdevsim: change fib accounting and
 limitations to be per-device
Message-ID: <20191003160322.428bd9c0@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20191003094940.9797-2-jiri@resnulli.us>
References: <20191003094940.9797-1-jiri@resnulli.us>
        <20191003094940.9797-2-jiri@resnulli.us>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  3 Oct 2019 11:49:26 +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Currently, the accounting is done per-namespace. However, devlink
> instance is always in init_net namespace for now, so only the accounting
> related to init_net is used. Limitations set using devlink resources
> are only considered for init_net. nsim_devlink_net() always
> returns init_net always.
> 
> Make the accounting per-device. This brings no functional change.
> Per-device accounting has the same values as per-net.
> For a single netdevsim instance, the behaviour is exactly the same
> as before. When multiple netdevsim instances are created, each
> can have different limits.
> 
> This is in prepare to implement proper devlink netns support. After
> that, the devlink instance which would exist in particular netns would
> account and limit that netns.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
