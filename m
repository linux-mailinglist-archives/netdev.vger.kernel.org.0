Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88991269A08
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 02:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbgIOACo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 20:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbgIOACo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 20:02:44 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F846C06174A
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 17:02:43 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id j11so2493319ejk.0
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 17:02:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IJClWMatAlzomwBK0n1+OdLQzpomgAa9R0jZyxBVjkg=;
        b=WQHV1M47yLZnmSf9oJAnJUlCOKcL8rXPWTpZlJODmyL94fedyRBJt9L2LLOt3F6spk
         WuU4UU9t3GOL7Dv6zA1vbAOrjCQJKaO5K0mADF4SFjUgT5Su48Ac4FUN0eg3ftiaPHRT
         IaSfjglYbIrfJJiKWU0EMtQRNFyVfwOeviB5xSsil7b5HCSdWwc4W1yO3FpV6ZkFSAD7
         iE4W9PdSLL9x9RLUEDqXWPz1BC3XQlJe6iDNBHBn5Zl4F6AicBPkwrA/QrMaloBGpQQV
         14GbeHpQYQ0M6DT2n1CL2tUDO7Z115321go9MQtbP7KxMcVzN9O7V4MRRDu6Vqurs31l
         uICg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IJClWMatAlzomwBK0n1+OdLQzpomgAa9R0jZyxBVjkg=;
        b=mbOTn/TDviTTRDrPujHC7tdIVQdmMhUhJPAU0mwrtzEeyqNJqV0Njm5/bTobI/Xd49
         Q3kDlNqz7vy1klZi/SOToyAP9YeXmDYEyEDHQNR+2aj81RmqEvcKVCTY05OWIiHZ9Xpa
         T7S5yh8LfU+ovFo78P08X2zzqxaJXctWY1EYknjd0r6SBYz+OED/xlSW1moMnCwoXIV3
         0D0UfFP4Zze7cext1iv2EP8HDKmJkYhC3U69HRuk/vJppk9jRlMHJ6CymR8ZhrxIhBrU
         B05+VMOVhpnYOFCJQ2BPXteNLGYIctJLoBohjYj3gx+xqLw+wCTs7tUSBXwJrRbteL1Z
         +Yig==
X-Gm-Message-State: AOAM531DJzp7UQb/UOXYOwGkKq9+fs/wZMEgx6Qb0VHh5sz7bSNYE/WO
        cML/tV6OTqKEIF63vPeOfr4=
X-Google-Smtp-Source: ABdhPJwwU2wmI815BcKfUk3USqJ6iZwD5zNxSiUKvlohtAmkxB6U7XxQ5GbD2rVlhohGz0DDwgTDAA==
X-Received: by 2002:a17:906:b04a:: with SMTP id bj10mr17159816ejb.303.1600128162351;
        Mon, 14 Sep 2020 17:02:42 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id v23sm8691019ejh.84.2020.09.14.17.02.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 17:02:41 -0700 (PDT)
Date:   Tue, 15 Sep 2020 03:02:39 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Gaube, Marvin (THSE-TL1)" <Marvin.Gaube@tesat.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: PROBLEM: (DSA/Microchip): 802.1Q-Header lost on KSZ9477-DSA
 ingress without bridge
Message-ID: <20200915000239.acgjvsi7c66s45xb@skbuf>
References: <ad09e947263c44c48a1d2c01bcb4d90a@BK99MAIL02.bk.local>
 <c531bf92-dd7e-0e69-8307-4c4f37cb2d02@gmail.com>
 <f8465c4b8db649e0bb5463482f9be96e@BK99MAIL02.bk.local>
 <b5ad26fe-e6c3-e771-fb10-77eecae219f6@gmail.com>
 <020a80686edc48d5810e1dbf884ae497@BK99MAIL02.bk.local>
 <800bbbe8-2c51-114c-691b-137fd96a6ccd@gmail.com>
 <20200804195423.ixeevhsviap535on@skbuf>
 <b4a859cc-1e17-67c2-a619-968e9fcfaf10@gmail.com>
 <0c963932e9174ef1a58f684cd5754a1a@BK99MAIL02.bk.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c963932e9174ef1a58f684cd5754a1a@BK99MAIL02.bk.local>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marvin,

On Wed, Aug 05, 2020 at 05:45:51AM +0000, Gaube, Marvin (THSE-TL1) wrote:
> Hello,
> I'm using the upstream driver Vladimir mentioned, as of 5.4.51.
>
> Best regards
> Marvin Gaube

Could you try net-next again, now that David has merged this patch?

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=b14a9fc45202c37a8540e1afb26b4783666a60c1

Thanks,
-Vladimir
