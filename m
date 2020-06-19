Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 350E1200287
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 09:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729714AbgFSHK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 03:10:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727096AbgFSHKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 03:10:55 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DE6EC06174E
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 00:10:52 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id p20so9010084ejd.13
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 00:10:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DLtyURrquTBmgYcUvFy6Cq/SRtjdPMbiRQ6vpQM5xAI=;
        b=pfpJdCS9iXtMe+2E0DD4wT1C0wmRUHlBuz3SUG81Tv8pVfPzlmCZ1gVLEs7eCES/lG
         6Z/zp24Yt3zr2+DNL6TWPHAFoq+qcA7q7rrYSoHcLiiF92agNbSxFx5vm03Wf4J8cfTa
         H0CtUbLPIP5vROMajpnPAMDT2EtW7xlEjnEUWe78vio7q9O5PWL6fMJOag34C3HzlmQ6
         v5RgXaFy5Gpqof4HA5A0r7sb2RyC1w6FP4hSQnkb4YkGZT0BiDt9navxW4s+Cdoof3qt
         bDxE5hk+FKFFzDQB+SCWUm9M48DqMgDvWQPw/DprAYySprfIWUbHARDWRRf46aSJXK0z
         xbgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DLtyURrquTBmgYcUvFy6Cq/SRtjdPMbiRQ6vpQM5xAI=;
        b=tmpGT6aFLvKOL3guQ/HBlDbyjeIWo3sX7s7yvlpSmsuikgIbyeHPtC5TwzsbuplWn0
         /neBhXpKdflxFDo5RNfs5lBaF5BLaomOlOU2+Vb3v+K9CBQcDEV+OMSDFH5sDSIFjZml
         jQBhevg2BcFRM8ordEAqPaqLGJr5GAYgXEptvh1eNkvuH7IjxrVH/2TUlmfi3XW+sogE
         ARc1jifozfUjfTaEfjl7n94M/S3C45I2udMdxsU12GL6gotGIs6OwokBZTe+pd3vcrcH
         rUyURGdUhFHcfgpDQz3TyLSexeMa9gLoQ4j7ooIESB6X3QYoGcN+FdSEPyPXRWGNStGl
         wmkQ==
X-Gm-Message-State: AOAM533tOSdEBMTLnGwi8Uu/64yfJTudCiY3A/TP+nqcASqvUNYP8wdt
        JgIMVLtu/x192awYAmumeGEcPDg8zR4=
X-Google-Smtp-Source: ABdhPJzcBkh5VBwZ/ei2y+SEGMWAwvPGlQdbxKUg7D5M3Uoh4QL3f8+epRVOS5lWan+x2PLFMrl43g==
X-Received: by 2002:a17:906:d143:: with SMTP id br3mr2259984ejb.548.1592550651691;
        Fri, 19 Jun 2020 00:10:51 -0700 (PDT)
Received: from netronome.com ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id w3sm4086085ejn.87.2020.06.19.00.10.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2020 00:10:51 -0700 (PDT)
Date:   Fri, 19 Jun 2020 09:10:50 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     wenxu@ucloud.cn
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pablo@netfilter.org,
        vladbu@mellanox.com
Subject: Re: [PATCH net v5 0/4] several fixes for indirect flow_blocks offload
Message-ID: <20200619071049.GF9312@netronome.com>
References: <1592484551-16188-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1592484551-16188-1-git-send-email-wenxu@ucloud.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 08:49:07PM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> v2:
> patch2: store the cb_priv of representor to the flow_block_cb->indr.cb_priv
> in the driver. And make the correct check with the statments
> this->indr.cb_priv == cb_priv
> 
> patch4: del the driver list only in the indriect cleanup callbacks
> 
> v3:
> add the cover letter and changlogs.
> 
> v4:
> collapsed 1/4, 2/4, 4/4 in v3 to one fix
> Add the prepare patch 1 and 2
> 
> v5:
> patch1: place flow_indr_block_cb_alloc() right before
> flow_indr_dev_setup_offload() to avoid moving flow_block_indr_init()
> 
> This series fixes commit 1fac52da5942 ("net: flow_offload: consolidate
> indirect flow_block infrastructure") that revists the flow_block
> infrastructure.
> 
> patch #1 #2: prepare for fix patch #3
> add and use flow_indr_block_cb_alloc/remove function
> 
> patch #3: fix flow_indr_dev_unregister path
> If the representor is removed, then identify the indirect flow_blocks
> that need to be removed by the release callback and the port representor
> structure. To identify the port representor structure, a new 
> indr.cb_priv field needs to be introduced. The flow_block also needs to
> be removed from the driver list from the cleanup path
> 
> 
> patch#4 fix block->nooffloaddevcnt warning dmesg log.
> When a indr device add in offload success. The block->nooffloaddevcnt
> should be 0. After the representor go away. When the dir device go away
> the flow_block UNBIND operation with -EOPNOTSUPP which lead the warning
> demesg log. 
> The block->nooffloaddevcnt should always count for indr block.
> even the indr block offload successful. The representor maybe
> gone away and the ingress qdisc can work in software mode.
> 
> 
> wenxu (4):
>   flow_offload: add flow_indr_block_cb_alloc/remove function
>   flow_offload: use flow_indr_block_cb_alloc/remove function
>   net: flow_offload: fix flow_indr_dev_unregister path
>   net/sched: cls_api: fix nooffloaddevcnt warning dmesg log

Reviewed-by: Simon Horman <simon.horman@netronome.com>

