Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB074958A3
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 04:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233598AbiAUDrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 22:47:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232662AbiAUDrj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 22:47:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E31C061574;
        Thu, 20 Jan 2022 19:47:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4DEDB81EBD;
        Fri, 21 Jan 2022 03:47:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D172EC340E1;
        Fri, 21 Jan 2022 03:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642736855;
        bh=YDuyQkVmbuc2qf5yPjTcF9uLN8no0wj1OEdJl9khO5o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FUOKjZhJNMMxQrUmpHwb1nEsx06Q87ZendqFezA1/yWcTBDIsDEKwnY84wkcPVRSb
         mO0Zvzpp5VmHU7F9xEIq+wEBdvZRYhM4FbynFjvakxsKqwePBbvxCJcX1wOmwo1hyi
         PpR5EAiBoP+wZ4ZOm/prMWoaLwSsxi2YpNEq1ErxDqFSJqbOAxn2aHvhiHzfATtGsj
         C1unOWwH+ckzWw5Fb3TA+udGZ/qwwPpc57z8oC1FM3/KBR3hmysYP98m9rsvqtUxYR
         aPXNP9aWD7EAXIaoSRtFj0KPvysJ/FNV+0Sw3yDevIvktdapWM3gDxVAzMxZYe3QpX
         w4ZRilrVRoGEA==
Date:   Thu, 20 Jan 2022 19:47:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     ycaibb <ycaibb@gmail.com>
Cc:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH] ipv4: fix lock leaks
Message-ID: <20220120194733.6a8b13e6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220121031108.4813-1-ycaibb@gmail.com>
References: <20220121031108.4813-1-ycaibb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Jan 2022 11:11:08 +0800 ycaibb wrote:
>  			if (seq_sk_match(seq, sk))
> +				spin_unlock_bh(lock);
>  				return sk;

Heh, also you're missing brackets so this is patently buggy.
