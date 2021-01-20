Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5DC2FDB67
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 22:25:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728546AbhATUzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 15:55:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729375AbhATNlX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 08:41:23 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D486CC061799
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 05:40:28 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id e15so2898562wme.0
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 05:40:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3IPLPyNVz/zLv3R9tQUHm5Db5Pb2mMQHS9csnAS+JC0=;
        b=s2T+7/vBbKbkqxJHds3Flb8yfClo859SIbLsTTnSYEqGVmCP4xRv66uX7KVLo8YjN/
         H9CGbvLNQVLqxFURvNd8/jzVB3vNW9aMPob4gqydVqAExtfAzGaEPtOHrRhg7Rd0en/p
         zF9Ewr9dA26zt7FF2FeKTq8b4hSOAROP7wr8dpy3cpTm3qybkqqxDBXr8nO+Ych8Tj3b
         J4S2WIdsLBKewWD9Bd7IrMhfBMKRnx/3R8ffJQFQbzkHymgAVz22T/O8LjWF1pRxQQ0Z
         3JusQ4bE8Pu9TAI6bdPMgm8OvKILPfQb03XzoHYetcHr8mO4X9K9dlg48/Si0EXtlPMo
         isnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3IPLPyNVz/zLv3R9tQUHm5Db5Pb2mMQHS9csnAS+JC0=;
        b=e8VV05A7hWdtaqpYHFlpATZn6S8DyCbaY6cx1hN6KRMJHz4t9TGtFJKhzfZ5t3kE92
         CKbISQFJ1w0X9+8lAHpvDU1yfd/cmeEF30o3Kvd6FpiF62RZR2gk72bgmuqee8OVAQfe
         7GL2n6Wu/AlKhDuChQFuR8KR5EKVz4yXLSD2rEdCSxyPShj5i9NGk+GKGEQOsiXG+xZp
         CoR8wemd58K4WFEkiaH8kJU1tPEn0788jkIm5tQqNn9AwkDFYBuwubHmR/OdOvAXFfmv
         wt/xiPfSCwcBfeib3I1LUJJbySYAZv9V7vDDmCgETs6oaWDqjJljjjjHrqS9/qxS7nUq
         as6w==
X-Gm-Message-State: AOAM533DjgTkd7EUHkLa1kaSzaH+ZRnSW+gfUqZ30ATkXSMGf06BJhFX
        hREShuM070psuGJPBdwA/kXiUA==
X-Google-Smtp-Source: ABdhPJxufkb3wqxBgkWG8fjpkJm9X+pWveAixw+giKJpcgZ6MH92BIoTMyuz0MsG2lf2qWtZ9Q0yzg==
X-Received: by 2002:a05:600c:2295:: with SMTP id 21mr4515366wmf.133.1611150027679;
        Wed, 20 Jan 2021 05:40:27 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id z1sm4088683wru.70.2021.01.20.05.40.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 05:40:27 -0800 (PST)
Date:   Wed, 20 Jan 2021 14:40:25 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ivan Vecera <ivecera@redhat.com>
Cc:     netdev@vger.kernel.org, saeed@kernel.org
Subject: Re: [PATCH net] team: postpone features update to avoid deadlock
Message-ID: <20210120134025.GD3565223@nanopsycho.orion>
References: <20210120122354.3687556-1-ivecera@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210120122354.3687556-1-ivecera@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jan 20, 2021 at 01:23:54PM CET, ivecera@redhat.com wrote:
>Team driver protects port list traversal by its team->lock mutex
>in functions like team_change_mtu(), team_set_rx_mode(),
>team_vlan_rx_{add,del}_vid() etc.
>These functions call appropriate callbacks of all enslaved
>devices. Some drivers need to update their features under
>certain conditions (e.g. TSO is broken for jumbo frames etc.) so
>they call netdev_update_features(). This causes a deadlock because
>netdev_update_features() calls netdevice notifiers and one of them
>is team_device_event() that in case of NETDEV_FEAT_CHANGE tries lock
>team->lock mutex again.
>
>Example (r8169 case):
>...
>[ 6391.348202]  __mutex_lock.isra.6+0x2d0/0x4a0
>[ 6391.358602]  team_device_event+0x9d/0x160 [team]
>[ 6391.363756]  notifier_call_chain+0x47/0x70
>[ 6391.368329]  netdev_update_features+0x56/0x60
>[ 6391.373207]  rtl8169_change_mtu+0x14/0x50 [r8169]
>[ 6391.378457]  dev_set_mtu_ext+0xe1/0x1d0
>[ 6391.387022]  dev_set_mtu+0x52/0x90
>[ 6391.390820]  team_change_mtu+0x64/0xf0 [team]
>[ 6391.395683]  dev_set_mtu_ext+0xe1/0x1d0
>[ 6391.399963]  do_setlink+0x231/0xf50
>...
>
>To fix the problem __team_compute_features() needs to be postponed
>for these cases.
>
>Fixes: 3d249d4ca7d0 ("net: introduce ethernet teaming device")
>Cc: Jiri Pirko <jiri@resnulli.us>
>Signed-off-by: Ivan Vecera <ivecera@redhat.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
