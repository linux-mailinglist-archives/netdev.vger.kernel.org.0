Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68C68D1E62
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 04:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732632AbfJJCXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 22:23:51 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42076 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbfJJCXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 22:23:50 -0400
Received: by mail-pg1-f195.google.com with SMTP id z12so2641982pgp.9
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 19:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=aBeHMgOj8kOPkp/mXf555NmaRLhdV3k2lpJOHH9DSxs=;
        b=jpByXRk0Y1OKjPhmlZ2hdsZFkPAOQ4gxO6YktXsyMGFkt8zs5UgN01+ApBKqYIpXVK
         62tgy3MHc0GouJPG+0KS4EtpqXs+JfTGgCsCibU9/L/p7W3fNz4XIaljkvbpB/GJfOBk
         SJzZwqA3MxxYuPD6vTbXvuKFe6JaN29BwoL5yZLOVrrCQ90zwiRa/rgewEr4/5yYAsAI
         mL+IR3MJOlx78/XUXSCB6K42n4pMYMCbsRZt7EJg6wygNXptQ6Q4Y8XPXd/DAQFHP9W2
         toD8hZQvdaj6HQp4FouvgCR9vfHy4mwckHYbFov78+07qu8WLosCGCekNGILc1gurbXo
         GFsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=aBeHMgOj8kOPkp/mXf555NmaRLhdV3k2lpJOHH9DSxs=;
        b=C4v03qGdj4NFIVdEXU0ICY2HJhpiZUetWfLnYdnnmjKyzWoFNAI16VJqLjD7lbsy8z
         gMtR23mB6EWF9KEKCt4dAWFZZsFPmK1q2rm4PN242mCVUVbfx40FjxZgViBh0N1SWCSo
         h8AjD37O5J+xifnQ0c2sjrvCJ7BV2+ZVo4+Y32Sgrzu3L4wYuoab3H8uvJgbHNgb5JV5
         ziFEJSpjA/Z16YiFiJF7NCzvT8I3eEaE7g1/39TElRgX46BXNBc3vjnvkXx9EGvT/wzo
         dyxt+caeYout/VlCj/XJK63656asmscM3gvRU/Zg9odNRvDuDNoKaEo5eOXqX5VTPltV
         neDw==
X-Gm-Message-State: APjAAAU7ib2iZMb+51Fzu5XsqKFTGBogXKRvHn19l0piSVQbajoC15pn
        haeVnWWV37kfZhr8A4UQId6Qeg==
X-Google-Smtp-Source: APXvYqwIOi9sHsxYxViE9LtrIeUR0YAWQ5FeFfl7acya6XRrVGkRVJeHhp1JawccOJyWsSkcHBW47g==
X-Received: by 2002:a17:90a:24ab:: with SMTP id i40mr7955033pje.121.1570674229873;
        Wed, 09 Oct 2019 19:23:49 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id n15sm3166468pjt.13.2019.10.09.19.23.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 19:23:49 -0700 (PDT)
Date:   Wed, 9 Oct 2019 19:23:35 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] act_mirred: Fix mirred_init_module error
 handling
Message-ID: <20191009192335.3019d283@cakuba.netronome.com>
In-Reply-To: <20191009031052.40528-1-yuehaibing@huawei.com>
References: <20191009031052.40528-1-yuehaibing@huawei.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Oct 2019 11:10:52 +0800, YueHaibing wrote:
> If tcf_register_action failed, mirred_device_notifier
> should be unregistered.
> 
> Fixes: 3b87956ea645 ("net sched: fix race in mirred device removal")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Why does the subject say net-next, looks like the bug was introduced
all the way back in 2.6.36. For fixes for code which is already in
Linus'es main tree the subject should say [PATCH net]. Those are on the
fast path to the -rc releases and stable.

Applied to net, and queued for stable, please let me know if I
misunderstood the intention here.
