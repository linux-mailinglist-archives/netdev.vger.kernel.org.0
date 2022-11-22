Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C895633154
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 01:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbiKVA1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 19:27:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiKVA1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 19:27:31 -0500
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0FC22D1;
        Mon, 21 Nov 2022 16:27:25 -0800 (PST)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 4C412C022; Tue, 22 Nov 2022 01:27:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1669076851; bh=XrOQACgMrecjPO16pG0TFXbX+miDFWcwlW4S6clOamg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oxKFuMemii2R52+Y5DMfeLoIPtcLBcJdk0AZEJ55H1AM4U0/hF0yPgxuSJs/Z1uFj
         jU3gwt+4q5+f9z8ryxSOZFBDmPnJp2Vf+qet+1gNBVZWEzinltHx6qHKtY8KX51zaq
         7ofET890O1b6AtBiFSwT3S9ThAXypZgkMr64LG6/RwA2THAkZPuUSjQ0iobDS9nn3K
         PckoSoC/5Zz3sPJg3kBfdctsoV3Sp8ydEeOpPO1gQAFRUlhkPQsQbmITozrAfjmUg6
         pYCp0xKSAAPZX5ZcCHflZETv66h2gPnLcVcywg8tbQLaTn8zC0A/FxxNNJW0Ap6vBM
         u0cQp0D8jejvQ==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 87D35C009;
        Tue, 22 Nov 2022 01:27:26 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1669076850; bh=XrOQACgMrecjPO16pG0TFXbX+miDFWcwlW4S6clOamg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O3HeiSmug+iHNoI/dhaQCza0ylMPDJDtSMhLQrVS1aOgZNsF0RjbqKfgksuKPBY5X
         UjoyCJBYXTXTYdrhvVcG7FJkdaHRTYsf2FkbBLniUFwrgEOXa16ARnx0Al6dEJ0xCY
         Ud5xl6/tjdKdUNcTVCzYYwtVanr9RHgjXRxuXQP5GNQu/AZiPHoCTK2ELr8Me+S6Df
         7oVd9Y/zzLGvC1gana7mJSh1VfRmg6vYZHLXeFO7SQyh32fOnl0n/1I1aQk2+y9eAr
         w3a1d74k3YU+NtByfGVbtvblTP8//AvL20HGNOAal+cLoMRPOH7x+nxr33ro7P0TjC
         rk7zBWD11endw==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id caa503a5;
        Tue, 22 Nov 2022 00:27:17 +0000 (UTC)
Date:   Tue, 22 Nov 2022 09:27:02 +0900
From:   asmadeus@codewreck.org
To:     Ye Bin <yebin@huaweicloud.com>
Cc:     ericvh@gmail.com, lucho@ionkov.net, linux_oss@crudebyte.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yebin10@huawei.com
Subject: Re: [PATCH 0/5] Fix error handle in 'rdma_request()'
Message-ID: <Y3wXVkp4ne7JQGWQ@codewreck.org>
References: <20221121080049.3850133-1-yebin@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221121080049.3850133-1-yebin@huaweicloud.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ye Bin wrote on Mon, Nov 21, 2022 at 04:00:44PM +0800:
> Ye Bin (5):

Thanks for these patches.
The commit messages are a bit difficult, but code changes mostly look
good to me -- I'll do a proper review when I can find time to test.

Just one question first: do you have RDMA hardware at huawei and/or
actually use this, or is it all static analysis fixes ?
(regardless of whether these problems actually happened with that
hardware, I'd like to know if this has had a first round of test or not)
-- 
Dominique
