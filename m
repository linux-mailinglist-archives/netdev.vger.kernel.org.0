Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4CD03A8712
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 19:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbhFORI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 13:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbhFORIz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 13:08:55 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FD07C061574
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 10:06:49 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id l4so13531559ljg.0
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 10:06:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=0R0qwlbEBz3QDKNYoBgbuKFJQQG4+PG2LFCc2nrFpLQ=;
        b=CgYfgmpGtFQsfvP4dRzWgYsG+Lot/SZir/R4WeFPzX+lvW0OYU8xFWO4+hDmbiiJKR
         0XVAq0uNS7HVUNNfWjnxl9YL2u2M+s6w5tIUFVFq3jO4XX4olwBWAwQ0PbK1NozLUlV9
         buYugQWsVIccJ5zxyacL6Cs4a/mfA3FrFzAJjlpFYDwNwk6gowjdbBXf1AOS3bAl/+uo
         V38HdKOglkXb9cZ4Ptlxo17JDNuX7/J4yUKAtdvDmhlkrfdXlgE6FVth3ANMVJZihSbf
         Wio0gryZyGVRakD/M/bUJhUPaqW6KYy52Qv4BSngGZKP0HWI2EF+cxDJAYfcX4Lewm4f
         DYoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=0R0qwlbEBz3QDKNYoBgbuKFJQQG4+PG2LFCc2nrFpLQ=;
        b=gg8Jb47bVL2nOWgUFPD23jUV5P6VH5iKMn+u45hU68LWLDXYINh7WiAz6vTsyUpg9g
         C6aui9ijXrb4k1v59CntZkqcvwYebhCa+bw9EhKDkCdor2iNno7iewKo+SriLmX0N/yB
         oGQrsOcCBdQKE82z+uE247666PI7og00aChbocTbz8orenNON6RUckGTxHV/x8jW9tiV
         EsvdkWOHelXsmu/6vsZWNdiYNluPsJPwP+LmdKkWKdTa1s9oD8mtcXi0Gg91RKKbKdOF
         2NvL6VsOimP5uW9ICbU1anoKghALBXhdM5APPNCT2D7PSG0IRqOFsNl++rveWY/PI4kL
         OTMw==
X-Gm-Message-State: AOAM533RBvzEMqvWRp6jyzDrzbGlfykpejQgcZTz+uiJkdRQut5+hWjR
        o4fE72VPyaVeVbXb2XWG9hc=
X-Google-Smtp-Source: ABdhPJxB7ER2Ln8W1af86X7jksZftS0MXWD3SV2sMYKyxLOBOyhLTIPtEyec3uwF6ySEStmaEBXkhg==
X-Received: by 2002:a2e:2a41:: with SMTP id q62mr524460ljq.371.1623776807452;
        Tue, 15 Jun 2021 10:06:47 -0700 (PDT)
Received: from wbg (h-155-4-221-38.NA.cust.bahnhof.se. [155.4.221.38])
        by smtp.gmail.com with ESMTPSA id b37sm718134ljf.131.2021.06.15.10.06.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 10:06:47 -0700 (PDT)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, nikolay@nvidia.com,
        roopa@nvidia.com, jiapeng.chong@linux.alibaba.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net] rtnetlink: Fix regression in bridge VLAN configuration
In-Reply-To: <20210609111753.1739008-1-idosch@idosch.org>
References: <20210609111753.1739008-1-idosch@idosch.org>
Date:   Tue, 15 Jun 2021 19:06:46 +0200
Message-ID: <87zgvroy55.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 09, 2021 at 14:17, Ido Schimmel <idosch@idosch.org> wrote:
> Cited commit started returning errors when notification info is not
> filled by the bridge driver, resulting in the following regression:
>
>  # ip link add name br1 type bridge vlan_filtering 1
>  # bridge vlan add dev br1 vid 555 self pvid untagged
>  RTNETLINK answers: Invalid argument
>
> As long as the bridge driver does not fill notification info for the
> bridge device itself, an empty notification should not be considered as
> an error. This is explained in commit 59ccaaaa49b5 ("bridge: dont send
> notification when skb->len == 0 in rtnl_bridge_notify").
>
> Fix by removing the error and add a comment to avoid future bugs.
>
> Fixes: a8db57c1d285 ("rtnetlink: Fix missing error code in rtnl_bridge_notify()")
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: Nikolay Aleksandrov <nikolay@nvidia.com>

Fix does indeed solve the same problem I encountered myself yesterday,
and bisected today.  Tested successfully on a bridge setup with Marvell
88E6097 (DSA switch) for bridge offloading (not that it matters for this
particular fix).

Tested-by: Joachim Wiberg <troglobit@gmail.com>

Best regards
 /Joachim
