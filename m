Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D16126C216D
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 20:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbjCTTat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 15:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230505AbjCTTaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 15:30:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E708A35ECF;
        Mon, 20 Mar 2023 12:23:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75D80B80E6A;
        Mon, 20 Mar 2023 19:23:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7C15C433A4;
        Mon, 20 Mar 2023 19:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679340181;
        bh=vkF3QD62amBgoPh4i94h9beuIiU4KaszT+7Pe44kVEo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CsDcu8cyyBVELLUeeFTzCuUy/+XIBukIRTPeRd4EdsxEOk+WV/wITcTLifeiM8npe
         w1zzuNyCd4yhLbUZG1ieDcrf8Rsb+VRiZwVhduhN6w3bHgjNhmQKG4qWlBiq5+noLb
         5OETWPIdOVdgfjtQY1cA0YXwcAVB4RKJglBjg9drpJHHmFMMjEuLBKbCMl9MHSpT7k
         Elpx7r3HDcGIBkCHfaHgWtUVHbAbAWv7hVd0zdWiIfx3eYcDVXgjqXcnuZ5eBk83+C
         E/LmxvKZIqHs00qfbAClwEO25eWPgkvNfT8xNOPRnP6308FMJyuxuytzaC3/3/Olz/
         5+ZQpJ/qqtVDQ==
Date:   Mon, 20 Mar 2023 12:22:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     patchwork-bot+netdevbpf@kernel.org
Cc:     Zheng Wang <zyytlz.wz@163.com>, timur@kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        hackerzheng666@gmail.com, 1395428693sheep@gmail.com,
        alex000young@gmail.com
Subject: Re: [PATCH net v2] net: qcom/emac: Fix use after free bug in
 emac_remove due to  race condition
Message-ID: <20230320122259.6f6ddc81@kernel.org>
In-Reply-To: <167930401750.16850.14731742864962914143.git-patchwork-notify@kernel.org>
References: <20230318080526.785457-1-zyytlz.wz@163.com>
        <167930401750.16850.14731742864962914143.git-patchwork-notify@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Mar 2023 09:20:17 +0000 patchwork-bot+netdevbpf@kernel.org
wrote:
> Here is the summary with links:
>   - [net,v2] net: qcom/emac: Fix use after free bug in emac_remove due to race condition
>     https://git.kernel.org/netdev/net/c/6b6bc5b8bd2d

Don't think this is correct FWIW, randomly shutting things down without
holding any locks and before unregister_netdev() is called has got to
be racy. Oh, eh.
