Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDEC2FCCFC
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 09:54:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728894AbhATIy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 03:54:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23978 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726493AbhATIxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 03:53:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611132730;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=d4UnMNibyh8PbpucVHsdwUM+5SKhACPpSJYaybcE7KM=;
        b=WWD4s26KjoPdOa/NeRLB+nsDtNUQ7uKMK4Wbi1qyNw3m2NLfaE3UUDjGmyZ2P0aP0FYMfk
        7LjVgIB6xLb6BRqjEeoCa/5j8LPBhUtAGsvPm58SL9SSTtlv6QrsXKVptXK+/Ndxx8xINS
        EmDNZ9RIg7Z3MQ9ZXcoTZDP6+tb8tgE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-290-mN1Aw8geNxmkyAl-J8Cyvw-1; Wed, 20 Jan 2021 03:52:05 -0500
X-MC-Unique: mN1Aw8geNxmkyAl-J8Cyvw-1
Received: by mail-wr1-f71.google.com with SMTP id q18so11120777wrc.20
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 00:52:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=d4UnMNibyh8PbpucVHsdwUM+5SKhACPpSJYaybcE7KM=;
        b=cl9mZzHCs3tJHjUOW9P9xwqWKUyhHECfEXKC7jhTl6slbW80qK+ymLjLIra+/OKc3B
         qanRsNAldMvixJGPYzEWA4r/lfJAEajChXWTo83t0O0ufhVaXPK+8CI7UES7ZsrLvXDv
         rxglVvxZ6AVlP5M+LQBx/Jis19DdFIylFd7+u/dgrFIU27N92yaaC/7pxxx0GCeZAajL
         VEuADEdGKL95gn1tsewcMaJs1LW9wGXV2mVPTl6NAouFTLqWun0MfoUdYMWFNtuKBmVn
         UrN0fbITa5aGAeZT2OB2RLFdurJiTPMTNdp+Hy5Pd4hbUOFx4Q6FBBGgSBuJs844k6XP
         2VKA==
X-Gm-Message-State: AOAM530h+4AjNcQe3wOEuDh1uK+hIeca9fUHkxzDjSO5fvnTCTx9WIgl
        YSajd0rVtNSCPOCsizM2uhdO+KNTInvFOBhnd5nwatPgqu9rskRjX/BT6BocrJFwKoQiuoYKq5q
        t0SjFpXkVAt2YB6dY
X-Received: by 2002:a1c:7f8c:: with SMTP id a134mr3287573wmd.184.1611132723753;
        Wed, 20 Jan 2021 00:52:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy9HHKjWFC7iPFhp5YFU8NaoWOBXnOXFOBmJKdJIiIKgWhVdaqgHhBEeVM6yYHYdkW+3705MQ==
X-Received: by 2002:a1c:7f8c:: with SMTP id a134mr3287561wmd.184.1611132723632;
        Wed, 20 Jan 2021 00:52:03 -0800 (PST)
Received: from redhat.com (bzq-79-177-39-148.red.bezeqint.net. [79.177.39.148])
        by smtp.gmail.com with ESMTPSA id w23sm2532766wmi.13.2021.01.20.00.52.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 00:52:03 -0800 (PST)
Date:   Wed, 20 Jan 2021 03:52:00 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eli Cohen <elic@nvidia.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lulu@redhat.com
Subject: Re: [PATCH v1] vdpa/mlx5: Fix memory key MTT population
Message-ID: <20210120035031-mutt-send-email-mst@kernel.org>
References: <20210107071845.GA224876@mtl-vdi-166.wap.labs.mlnx>
 <07d336a3-7fc2-5e4a-667a-495b5bb755da@redhat.com>
 <20210120053619.GA126435@mtl-vdi-166.wap.labs.mlnx>
 <20210120025651-mutt-send-email-mst@kernel.org>
 <20210120081154.GA132136@mtl-vdi-166.wap.labs.mlnx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210120081154.GA132136@mtl-vdi-166.wap.labs.mlnx>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 10:11:54AM +0200, Eli Cohen wrote:
> On Wed, Jan 20, 2021 at 02:57:05AM -0500, Michael S. Tsirkin wrote:
> > On Wed, Jan 20, 2021 at 07:36:19AM +0200, Eli Cohen wrote:
> > > On Fri, Jan 08, 2021 at 04:38:55PM +0800, Jason Wang wrote:
> > > 
> > > Hi Michael,
> > > this patch is a fix. Are you going to merge it?
> > 
> > yes - in the next pull request.
> > 
> 
> Great thanks.
> Can you send the path to your git tree where you keep the patches you
> intend to merge?

https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git linux-next

Note I often rebase it (e.g. just did).

-- 
MST

