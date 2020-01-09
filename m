Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77089136148
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 20:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731601AbgAITlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 14:41:12 -0500
Received: from mail-qv1-f68.google.com ([209.85.219.68]:43240 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728567AbgAITlM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 14:41:12 -0500
Received: by mail-qv1-f68.google.com with SMTP id p2so3473270qvo.10
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 11:41:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Q4vnsEfzNIrALLcCZXDUP8/YAasqG1VcRqRjbyzH4Pk=;
        b=zl8EIOKCOGCZkvs7u4amSbTiz9Tx441o70QA7dyqSM0Fjf3SBq7qSa+D0nxL9aDHem
         LujGcwK3HNSN+RPUEjBKUscnOTMSBeBG4u2G8ATC9A8+XBr465SgXY/evCqlfNvU0isv
         3AQudtni0bk5TTgGRVeqvxezZKw/DJiVvXvCz+bZwGv1J2nHPwstgR6CIrLX2XylwhT2
         Mr6rQJmtbJI5n99M7HuS4yJuHekrhp/AC6gp2ihg3gviAsNjZ5rbyKeM78otiLOm20+Y
         VFrFZRboUslMG5S8x5khsB9aKfnR154LLtSS/jFPDH8slKVy9LkiJ2O3BOnk74fYOXBc
         3UAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Q4vnsEfzNIrALLcCZXDUP8/YAasqG1VcRqRjbyzH4Pk=;
        b=nqmiItmpzYPtTau+d+ZHwp4uWywPhU/GhfL4ApYE61aMvITRXBAjEbihagKBeRCvbS
         L+Wh0Xt9HX8kzJ1gq7EiV8DWsQ+u6lCmmrhE7kezRe4I9XxEhiziX+c7ST0Rx4L5GGl+
         hn1tmU7Mv6rdpPndmDc210U1nc9BNWb7j2eaXQSaPMA8EgE+7iB85ZtH/82KpOTYEkkm
         rFtj8ZMWuy9kaWK8I6ncxMjM7Mlb5UheVPid0QJDnZT2DD8RNwPV8FrF2Bx7xSY7uLOK
         /xwG8sMxlKwq4ncfHI0Y+hpZPMHaPc0G+uLTJrUIIKFvyKQkLgGE73+XZZAbpKRVHtFd
         dyKQ==
X-Gm-Message-State: APjAAAXZ58xGKpSCp4bTJEnmhv2azHh1+Gv3PbB+givUlhF8JmMKLb7M
        hxKzGYmgs4x80/nbMGBKlM6grw==
X-Google-Smtp-Source: APXvYqwoX3MLGoSE2L8uKK84oTc1WHbGM0aK/cg8QIKuOJetoSr3FJUo2lYXObUVYAd1xhNHFLw7/w==
X-Received: by 2002:a0c:e610:: with SMTP id z16mr10254764qvm.215.1578598871363;
        Thu, 09 Jan 2020 11:41:11 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id m5sm3757474qtq.6.2020.01.09.11.41.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 11:41:11 -0800 (PST)
Date:   Thu, 9 Jan 2020 11:41:05 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Alex Vesker <valex@mellanox.com>, davem@davemloft.net,
        Jiri Pirko <jiri@mellanox.com>, linuxarm@huawei.com,
        linyunsheng@huawei.com, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [question] About triggering a region snapshot through the
 devlink cmd
Message-ID: <20200109114105.142dc3dd@cakuba.netronome.com>
In-Reply-To: <18867ab8-6200-20c6-6ce0-8c123609622f@intel.com>
References: <02874ECE860811409154E81DA85FBB58B26FA36F@fmsmsx101.amr.corp.intel.com>
        <HE1PR0502MB3771BD83B728249E6C21967AC33E0@HE1PR0502MB3771.eurprd05.prod.outlook.com>
        <HE1PR0502MB3771D512C2D23F551EB922F4C33E0@HE1PR0502MB3771.eurprd05.prod.outlook.com>
        <18867ab8-6200-20c6-6ce0-8c123609622f@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Jan 2020 11:14:38 -0800, Jacob Keller wrote:
> On 1/8/2020 4:15 AM, Alex Vesker wrote:
> > I am a biased here but, devlink trigger can be useful... I am not aware
> > of other alternatives,
> > devlink health has it`s benefits but it is not devlink region. If you
> > will decide to implement I can
> > review the design, if Jiri is ok with the idea.
> >   
> 
> Sure. I am not quite sure how long it will be till patches are on the
> list, as I'm currently in the process of implementing devlink support
> for one of the Intel drivers, and would be using that driver as an example.
> 
> Actually, come to think of it, I may just implement the region trigger
> and use netdevsim as the example. That should enable those patches to
> hit the list sooner than the patches for implementing devlink for the
> ice driver.

Just to be clear - you mean implement triggering the dump over netlink?
FWIW that seems fairly reasonable to me, but please do explain the use
case clearly in the patches.

netdevsim is a driver mock up, and debugfs is its control interface.
The trigger there is to simulate an async device error, this trigger
should not be used as example or justification for anything real driver
may need.
