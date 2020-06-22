Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09E2A203308
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 11:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbgFVJN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 05:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726417AbgFVJNZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 05:13:25 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E30AC061794
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 02:13:25 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id mb16so17266590ejb.4
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 02:13:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=11fZbXrOPoHv0u2rPxbmmeFfnAoXQpO/h1fiZOIZ0jE=;
        b=h8Gvqy6ABtYGbZS21QK1gBvhTh8t+2XefQolQA91DJzK081+VfNLyji+Jiosp3i5lU
         tQYzNf3b71AmBCjVzD+OIfR4zcZDZ79olkyE9ngG4KFyjktBeeSv+SrqJNbnFaQYZlvb
         7DT8jXltk0jNdfjVAtempMzGnfvHTo488R5yrmszZ197gVunfQfL0YkPnX6l9qMJzhRi
         xXQw8glZfagFLfRyJTMqzIWQ6lOfPndI/QyMP6LxIpOXA49VvO31v34G2OZV0ktHgHpM
         DX5PXXjWn56fRDHddQtNF/bmxNde3N4PLgHVLzc9mbD/v2DOdiZwZJMdCwRol9FsGC7e
         HzHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=11fZbXrOPoHv0u2rPxbmmeFfnAoXQpO/h1fiZOIZ0jE=;
        b=LCYlYjxhn4LAh7HeAnmUDyb1+4/BG+HbybmO7WW2YYuYfEUNTCoTrkDERK7iLias/v
         km0Gs358yinem6aiHmOlObVrya+J42ZXIwwpMO92lq5qT1lee1YUUFAt2bIdD9ILITbP
         qK/xonhQnymXeBae/TtgLVz8AM+Yf/5MSfcd2/tejlWraILTMa4OiXrs/2XFA2RzhTBK
         PnARU7bW3ajGAqjoNTR5dZjT/KXyqjw0h1CB4Nkm0DF1uRQhDrEtn4eI+FbALrt5QZEf
         dNn/qTQZRjiRFu4HFSS56D/yYKnwRXJx4eTALbLTGHI9aEFO2iFtJdG3xolEolm439UO
         zTkw==
X-Gm-Message-State: AOAM530Js6iAREWOsC8blkL6BturzdI+Zze/nIJxq09ByO1RxYcbYPsH
        LGU+TT4WWxvWGe5IgdHA7vGMsQ==
X-Google-Smtp-Source: ABdhPJy+2pt1tGrfRXH5NDRCeh2YhTlxlkUPVkSz8MiNVvUGaOXMwpAur1ri/CZp247LtZ/0f2R4Fw==
X-Received: by 2002:a17:906:2bd1:: with SMTP id n17mr14391596ejg.147.1592817203241;
        Mon, 22 Jun 2020 02:13:23 -0700 (PDT)
Received: from netronome.com ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id w17sm853510eju.42.2020.06.22.02.13.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 02:13:22 -0700 (PDT)
Date:   Mon, 22 Jun 2020 11:13:21 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>
Cc:     wenxu@ucloud.cn, netdev@vger.kernel.org, pablo@netfilter.org,
        vladbu@mellanox.com
Subject: Re: [PATCH net v5 0/4] several fixes for indirect flow_blocks offload
Message-ID: <20200622091320.GA24715@netronome.com>
References: <1592484551-16188-1-git-send-email-wenxu@ucloud.cn>
 <20200619.201342.2288126609984082133.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200619.201342.2288126609984082133.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 19, 2020 at 08:13:42PM -0700, David Miller wrote:
> From: wenxu@ucloud.cn
> Date: Thu, 18 Jun 2020 20:49:07 +0800
> 
> > From: wenxu <wenxu@ucloud.cn>
> > 
> > v2:
> > patch2: store the cb_priv of representor to the flow_block_cb->indr.cb_priv
> > in the driver. And make the correct check with the statments
> > this->indr.cb_priv == cb_priv
> > 
> > patch4: del the driver list only in the indriect cleanup callbacks
> > 
> > v3:
> > add the cover letter and changlogs.
> > 
> > v4:
> > collapsed 1/4, 2/4, 4/4 in v3 to one fix
> > Add the prepare patch 1 and 2
> > 
> > v5:
> > patch1: place flow_indr_block_cb_alloc() right before
> > flow_indr_dev_setup_offload() to avoid moving flow_block_indr_init()
> > 
> > This series fixes commit 1fac52da5942 ("net: flow_offload: consolidate
> > indirect flow_block infrastructure") that revists the flow_block
> > infrastructure.
> > 
> > patch #1 #2: prepare for fix patch #3
> > add and use flow_indr_block_cb_alloc/remove function
> > 
> > patch #3: fix flow_indr_dev_unregister path
> > If the representor is removed, then identify the indirect flow_blocks
> > that need to be removed by the release callback and the port representor
> > structure. To identify the port representor structure, a new 
> > indr.cb_priv field needs to be introduced. The flow_block also needs to
> > be removed from the driver list from the cleanup path
> > 
> > 
> > patch#4 fix block->nooffloaddevcnt warning dmesg log.
> > When a indr device add in offload success. The block->nooffloaddevcnt
> > should be 0. After the representor go away. When the dir device go away
> > the flow_block UNBIND operation with -EOPNOTSUPP which lead the warning
> > demesg log. 
> > The block->nooffloaddevcnt should always count for indr block.
> > even the indr block offload successful. The representor maybe
> > gone away and the ingress qdisc can work in software mode.
> 
> Series applied, thank you.

Hi Dave,

when you get a chance could you pull net into net-next
to get these changes there?

Thanks!
