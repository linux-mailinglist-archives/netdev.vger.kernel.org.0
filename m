Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7E7B282109
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 06:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725772AbgJCEI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 00:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgJCEI3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 00:08:29 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE903C0613D0;
        Fri,  2 Oct 2020 21:08:28 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id cr8so2729638qvb.10;
        Fri, 02 Oct 2020 21:08:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zBZuvzKTzC3+x63VzgUilAxVy8DCFohuKHJKD1EvjDY=;
        b=h0Jsyp6FEyBF9oYBsoMZuqTOtYvqHaQYbVN3Yy2g1KaQD4sBoTfTJU6/Qo8LFobEji
         ubcCLLIkkBQwAAiHz4cwapZ0F8D7qD8qI4MxS0sTdzvMBT+k1amc59ZCzyMVb0Ah7S1f
         cwS7WKwgjedNhqAE0FhJa5g70OdxkIPCQPzVL2/RHjEGSwt0FbxOtqfuFpkqDM72Z48A
         UllEDCJiuUrvVMNncHoxmXQ4TyIpLKJk1fbMOpRYjlivm6O+2a9zVx3mbQSxEUhahKdd
         v6oDuqaY7AxBC5vtSt5Q00FBbDpPG9zvEudWkAflw/0peKYzt/smdz8T657JUzPLi/zn
         xFQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zBZuvzKTzC3+x63VzgUilAxVy8DCFohuKHJKD1EvjDY=;
        b=TQ1G0QY77D129BClFhakdBWNMCmztNloCiu69MWuOccrZO8Le5Xf1jgxQFy+PIixm9
         5nBHJwWFW5mMu1RMEsTM5bGF33UW6RYrfZ31UxBp06p1p+UfNRoqWp04Iqz53rKues5O
         51GuXk3GBTtzXTZ7t9YwBiTfpEAe9D+8+qXrJ7GN9ZH6EzdPQj6SSrPq+Txg++tTfteg
         A5sdirvtwLggGaOoSVFuV968hcA6wGb8KtHuRuLFpRVx/kZbuFC7fZgd2c17iStFUUxF
         iG1t7qBz6dSAo6nuQDQvgSB3isRhaQSZbWKm7EbcvxeEunb0vFLZZB7qGwBv33uAKoCl
         +jUg==
X-Gm-Message-State: AOAM532VVock7AIedB7SnvmvJUg+0G5tpXATCrvEVkBYhWtuEY1oWDL7
        vcAcbTguK/uuWPL/z/+ZzPI=
X-Google-Smtp-Source: ABdhPJz9A2sxgEg4Am0qpXASgb7cNvuOHN+jMeUXPvIyTFLxoz5wV91WrPBFvRXh8PD0pvM1GxT7NQ==
X-Received: by 2002:a0c:e5cf:: with SMTP id u15mr5227462qvm.14.1601698108019;
        Fri, 02 Oct 2020 21:08:28 -0700 (PDT)
Received: from localhost.localdomain ([177.220.172.62])
        by smtp.gmail.com with ESMTPSA id f14sm2541258qkh.134.2020.10.02.21.08.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2020 21:08:27 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id E040DC6195; Sat,  3 Oct 2020 01:08:24 -0300 (-03)
Date:   Sat, 3 Oct 2020 01:08:24 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     kernel test robot <lkp@intel.com>
Cc:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        linux-sctp@vger.kernel.org, kbuild-all@lists.01.org,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>,
        Tom Herbert <therbert@google.com>, davem@davemloft.net
Subject: Re: [PATCH net-next 11/15] sctp: add udphdr to overhead when
 udp_port is set
Message-ID: <20201003040824.GG70998@localhost.localdomain>
References: <7ff312f910ada8893fa4db57d341c628d1122640.1601387231.git.lucien.xin@gmail.com>
 <202009300218.2AcHEN0L-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202009300218.2AcHEN0L-lkp@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 03:00:42AM +0800, kernel test robot wrote:
> Hi Xin,
> 
> Thank you for the patch! Yet something to improve:

I wonder how are you planning to fix this. It is quite entangled.
This is not performance critical. Maybe the cleanest way out is to
move it to a .c file.

Adding a
#if defined(CONFIG_IP_SCTP) || defined(CONFIG_IP_SCTP_MODULE)
in there doesn't seem good.

>    In file included from include/net/sctp/checksum.h:27,
>                     from net/netfilter/nf_nat_proto.c:16:
>    include/net/sctp/sctp.h: In function 'sctp_mtu_payload':
> >> include/net/sctp/sctp.h:583:31: error: 'struct net' has no member named 'sctp'; did you mean 'ct'?
>      583 |   if (sock_net(&sp->inet.sk)->sctp.udp_port)
>          |                               ^~~~
>          |                               ct
> 
