Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6361B2BD8
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 18:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgDUQCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 12:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725930AbgDUQCb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 12:02:31 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECF43C061A41
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 09:02:30 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id j2so17037160wrs.9
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 09:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ye/SmwElLwM30oPz5wYhXP29ThHh4Zq79pAOX5B7shk=;
        b=fa6bftItDO5LWCl1lBELjz2ahU79ilbe11/KVvNYjdY6Eo8imcM7RF/9gMwoO1bOHx
         6ndmu+Kfuxjg+tvLGgWjxL87R7ciqGIux6sbihBr08Sg69uLZlIEU+7V7NSpNtMN96Nj
         /SNyfM07U0mgb/RiZ50esRfNwf1Z95HuOK6pdLPeMZZD3g0e/ntIDEG3c15F6RFsOxiJ
         zkP1/K3BPnnhp3A3dkd23ZOOVRD9mYYf+UNa5kA9PfZGzazKJjTVtt+xpp/KJ2QSXp9t
         5fQ2hVyln5U7RvLzmc6xY4zbQoUHVlvmD5KbK1BpFfpbbF678zj4/fuuopX9WAqR/5PD
         FlkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ye/SmwElLwM30oPz5wYhXP29ThHh4Zq79pAOX5B7shk=;
        b=oyl0uEqQnirVGB727KTRPJh1kHqc3VgcsEZF9aHs8rLmRmVROq4lSCwzDolmk+wFxO
         s8lqqDxTdYFixr8pOYTcsZWyZsv0kRbgmxqH6jJCOomlZmmbltqaoC59LR4IEYGPO5kZ
         /Fu/mpKptx2eXcdHW/g04rwb1U9J8r7QeyJ16HzdQ/FA7kkTD6YYLFcyuS+wDg5dbIxM
         i1LRjg+n0vbsdelMQaER5Iu4VOqf5CTHOK5Yizj8kSpQIyk73SvauVYlJJw3GvboNiww
         a/dvYdl/wld1piiMs1UqbS5+sXqI+c/AXX0Jb7Y4UUrmiCJfBxGmuFs1dsDxRCjVT8rR
         ZMMQ==
X-Gm-Message-State: AGi0PuYF01YobpcL76LHiY4kXUy6tOlE3huM2rSTI2NdU32rHlgnM3yp
        JxLUuDZ54PqE+nDJN/8eljDFkg==
X-Google-Smtp-Source: APiQypK+crp30ycYZdIpo/J9zfjwOREnnhrm2+qdXs/8OC1g2sMHjRWB5siPT7J/wz6FqNKYoXI4gA==
X-Received: by 2002:a05:6000:114c:: with SMTP id d12mr9428752wrx.381.1587484949682;
        Tue, 21 Apr 2020 09:02:29 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id n2sm4784159wrq.74.2020.04.21.09.02.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 09:02:28 -0700 (PDT)
Date:   Tue, 21 Apr 2020 18:02:27 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Maor Gottlieb <maorg@mellanox.com>
Cc:     davem@davemloft.net, jgg@mellanox.com, dledford@redhat.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        kuba@kernel.org, jiri@mellanox.com, dsahern@kernel.org,
        leonro@mellanox.com, saeedm@mellanox.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alexr@mellanox.com
Subject: Re: [PATCH V3 mlx5-next 04/15] bonding/alb: Add helper functions to
 get the xmit slave
Message-ID: <20200421160227.GC6581@nanopsycho.orion>
References: <20200421102844.23640-1-maorg@mellanox.com>
 <20200421102844.23640-5-maorg@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200421102844.23640-5-maorg@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Apr 21, 2020 at 12:28:33PM CEST, maorg@mellanox.com wrote:
>Add two helper functions to get the xmit slave of bond in alb or tlb
>mode. Extract the logic of find the xmit slave from the xmit flow
>to function. Xmit flow will xmit through this slave and in the
>following patches the new .ndo will call to the helper function
>to return the xmit slave.
>
>Signed-off-by: Maor Gottlieb <maorg@mellanox.com>

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
