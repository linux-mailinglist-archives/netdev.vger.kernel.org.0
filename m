Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6488445252
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 12:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbhKDLmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 07:42:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhKDLmU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 07:42:20 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7829DC061714
        for <netdev@vger.kernel.org>; Thu,  4 Nov 2021 04:39:42 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id u11so11404135lfs.1
        for <netdev@vger.kernel.org>; Thu, 04 Nov 2021 04:39:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=shoFlf8Iwgb7mgmbI5GIhkEf8lobFKb2KklbgoSeR9Y=;
        b=2G8Tm1eQ5PjeNG5qJP5no3q805XdZ64HD3SvEIanTDOKyDLDwdx6Fh9YKbz9+0feTc
         06MaKJ6WxjpHPBpiH2FOQl9dG/VGagfib5jb+yeaG0fEtFzrf75paE8i+XKX7rNUuVCo
         wqsA80hv5fFkwFdvqhL1YbpwnO5/IaZbkeyJ1RHOBvplwKYtPNFYqNxW2NEfPPTiuegj
         dckdLgvzXtSS/4jyMwPJGZspVs2RuLCg9JmZyR5IyZDBNoSn52WHwDJ3erop7SM7SjC4
         Ml6DmxYdnrUjF8FyRX/QDk72Je5AUBZgIgjW7j2beFtfITSl5NsdfWRb0BqxhljjKOfQ
         ijVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=shoFlf8Iwgb7mgmbI5GIhkEf8lobFKb2KklbgoSeR9Y=;
        b=XHtJ7KvSTMdqSzj9L/S85VqEODkZJgjOizk4NRraYGITQ0ueziaulq6tUd/PzbNvVW
         KuPmQuDitoZOv5gYBbi0pX4zxnm4PAG2TF1y/tzJIh9iygVKrweUflORfJ5uZu20AGUG
         GUc8EMKJKQP7kdC/JQiYQdgaSJYs4eB0VQLjBxqE+2qbu2/r9A3ttdpZ+kZ5FYHK4A7l
         wAM6H2zbD1W8pYm39MZ04AK6Z5lhMriBnV3NTDVDIPE+hrzGkLr4RYlBQBCj+nOZfJ+2
         LVzOTXPFQwh+goOLN1CfcRG6WOKq73OMnhkyD6CFHaqMi61EilLOz+sVolKO2JmadwRZ
         oGHw==
X-Gm-Message-State: AOAM532AZUyZ31D0kiz+Vxccj+fLxgfJoSnGPeE6kwN6NaFpak2tRb8w
        7pshlab/+OS+IYn2QmLpfq9tQw==
X-Google-Smtp-Source: ABdhPJxPSyQnbrM+NY4bMEGjXtndxBnyAuCbybicTf5D/tm78QZpDIZlMX0jthTN8L/sasIMh18HWw==
X-Received: by 2002:a05:6512:10cb:: with SMTP id k11mr47357032lfg.617.1636025980802;
        Thu, 04 Nov 2021 04:39:40 -0700 (PDT)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id q17sm443006lfr.246.2021.11.04.04.39.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 04:39:40 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Alvin =?utf-8?B?4pS8w6FpcHJhZ2E=?= <alsi@bang-olufsen.dk>
Subject: Re: [RFC PATCH net-next 0/6] Rework DSA bridge TX forwarding
 offload API
In-Reply-To: <20211102100702.72u2abq3mft45svo@skbuf>
References: <20211026162625.1385035-1-vladimir.oltean@nxp.com>
 <20211102100702.72u2abq3mft45svo@skbuf>
Date:   Thu, 04 Nov 2021 12:39:38 +0100
Message-ID: <87mtmkjgjp.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 02, 2021 at 10:07, Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
> On Tue, Oct 26, 2021 at 07:26:19PM +0300, Vladimir Oltean wrote:
>> This change set replaces struct net_device *dp->bridge_dev with a
>> struct dsa_bridge *dp->bridge that contains some extra information about
>> that bridge, like a unique number kept by DSA.
>> 
>> Up until now we computed that number only with the bridge TX forwarding
>> offload feature, but it will be needed for other features too, like for
>> isolation of FDB entries belonging to different bridges. Hardware
>> implementations vary, but one common pattern seems to be the presence of
>> a FID field which can be associated with that bridge number kept by DSA.
>> The idea was outlined here:
>> https://patchwork.kernel.org/project/netdevbpf/patch/20210818120150.892647-16-vladimir.oltean@nxp.com/
>> (the difference being that with this new proposal, drivers would not
>> need to call dsa_bridge_num_find, instead the bridge_num would be part
>> of the struct dsa_bridge :: num passed as argument).
>> 
>> No functional change intended.
>
> Any feedback?

Sorry Vladimir, I've been on holiday. I will try to review this
ASAP. Based on a quick look, I like it.

I actually had some cross-chip fixes w.r.t. forward offloading queued
up, and this series should make that cleaner as well.
