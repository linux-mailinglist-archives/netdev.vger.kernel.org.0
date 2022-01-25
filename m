Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92B0A49AF47
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 10:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1455913AbiAYJHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 04:07:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1455290AbiAYJDz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 04:03:55 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B30BEC061340
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 00:45:20 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id j2so61138558edj.8
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 00:45:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oldum-net.20210112.gappssmtp.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=BOQOqH5qvYEg34AeA2SYgpWItGQXG0S/+HKsMOf6FpA=;
        b=TtEq2UIv3nNdDjJntCxnWLN9j0i44Y0n09H1knH5DmO4BdsaeU8eFUcJNo+3vuAbxO
         YJT+PVD0h7UJiuNFbokN/BB1gwqwhiLFFG8KSQjknkNH8vSSN/tLFldACC5faKTPebW5
         noJ7fAS7+ZJR/Trvy2sUxoidQHapw5yX4bY2BfPQ7RmsQ45/W5bH/wPGz2v+0VnFf3kx
         WT276mKeOnRgBGpBCSGzqCHN0mVMevgGAJhB8d30U9tERPyzzx5dhvSLeEBkQgPXCtG1
         3BZtpzZJnCkQ3CqAePEPcm6+VI+KhBbQD3Fm9fey/U9CuJQ9NNYn737xuSZH3vwyDuOQ
         Ltng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=BOQOqH5qvYEg34AeA2SYgpWItGQXG0S/+HKsMOf6FpA=;
        b=B6mjWYvGluJge2Z9iyj3DXDUANmCiIbV/7Le1mkbcPy3sl3aX36EHKU5TdJsBFS3FR
         UzawgdbNZd0eH054DL1ildWuKhA+I+lJOBKwwlJdgwFM1buuSgYh5cGzihayYgy8BfdN
         cBdKdEqFnr5cvTbu9WgO9Sx5e0QPAjVngIER+lMT1D1ze3gCf51iQBQB8aNQ21Aa/Hd5
         hF1RpJeaRJa+nMLh/VGRyAc/NB3hQc2noc8NcbRyktfkKuCzPe6vufpC0o1/adpgI6dB
         TOHTV3NAL7EwNP186VZk8lNGeorPidywQOMfTVrLSJBscZUC+aZazUrIRdQDJRgfPGd8
         EU2A==
X-Gm-Message-State: AOAM532Jg7gK+YNcnuPj5RbbyeSsica0s1tXkE6McGXLXrtGxPSWTHeW
        4VILp+d0GpXLLSSOiBLoRrA3D/NmG5zacAqiNRo=
X-Google-Smtp-Source: ABdhPJxsRNxrndfrnyrBh4PBOcneWl1CYwZfMNxVhp94uwuk+O3gg98rita8cZBDAOr2bQe+qllFlA==
X-Received: by 2002:a05:6402:2750:: with SMTP id z16mr18205933edd.242.1643100319072;
        Tue, 25 Jan 2022 00:45:19 -0800 (PST)
Received: from [10.1.0.200] (external.oldum.net. [82.161.240.76])
        by smtp.googlemail.com with ESMTPSA id co19sm7881894edb.7.2022.01.25.00.45.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 00:45:18 -0800 (PST)
Message-ID: <31207345df2f8bf53fe3ee444806b6aa873d9e31.camel@oldum.net>
Subject: Re: [PATCH v4 00/12] remove msize limit in virtio transport
From:   Nikolay Kichukov <nikolay@oldum.net>
To:     Christian Schoenebeck <linux_oss@crudebyte.com>,
        Dominique Martinet <asmadeus@codewreck.org>
Cc:     v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Greg Kurz <groug@kaod.org>, Vivek Goyal <vgoyal@redhat.com>,
        garlick.jim@gmail.com
Date:   Tue, 25 Jan 2022 09:45:08 +0100
In-Reply-To: <22204794.ZpPF1Y2lYg@silver>
References: <cover.1640870037.git.linux_oss@crudebyte.com>
         <5111aae45d30df13e42073b0af4f16caf9bc79f0.camel@oldum.net>
         <Ye6IaIqQcwAKv0vb@codewreck.org> <22204794.ZpPF1Y2lYg@silver>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-01-24 at 12:57 +0100, Christian Schoenebeck wrote:
> Besides QEMU, what other 9p server implementations are actually out
> there, and 
> how would they behave on this? A test on their side would definitely
> be a good 
> idea.
diod is a 9p network server, if these patches are purely virtio
transport specific, I believe they should not affect it. Here is the
source code for diod:
https://github.com/chaos/diod

Jim Garlick maintains it, added to CC here.

