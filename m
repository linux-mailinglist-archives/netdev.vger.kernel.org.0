Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71CC1597C78
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 05:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242891AbiHRDwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 23:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240247AbiHRDwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 23:52:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC3F16527F;
        Wed, 17 Aug 2022 20:52:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DB1561542;
        Thu, 18 Aug 2022 03:52:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79D45C433D6;
        Thu, 18 Aug 2022 03:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660794758;
        bh=NSlez/1Y8KI9kkSJxWI8jwfTv3VmOAFhtcUY0bfupfk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=j2ZO9whBC0e2Fm6KyvLDdPeo34tA7YwXGmDJfOxL90rai22v4AwXxUzg7wUHtEM+Q
         z1zkLK/LRvkNnXQbcSZ5mccBcneYNc0xGOEOyrRSQRv6CH8sAkBM+X07jyXxSBEPgS
         alcRGtwemQEXBWjYHXgt85mQBsWqyQXHGDqpJHmAlh3Kl2AgdFzBn5U9FqCjW95cS4
         Gxxv8IY8t6kJzTwHJy4LX1scN0EYzhBUPW8XMBtr5WkVMx4ZG4KBU2VFOAnZkFlqRg
         ATjlIn6HUaWShLIqxW/3TN4G/bl4wyt5Rob+zzSbJWcsqntNzew/gnjLF7PiiNeyPb
         ktU5qo5YhXFcw==
Date:   Wed, 17 Aug 2022 20:52:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     cgel.zte@gmail.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xu.xin16@zte.com.cn
Subject: Re: [PATCH 0/2] Namespaceify two sysctls related with route
Message-ID: <20220817205237.3e701f0b@kernel.org>
In-Reply-To: <20220816022522.81772-1-xu.xin16@zte.com.cn>
References: <20220816022522.81772-1-xu.xin16@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Aug 2022 02:25:22 +0000 cgel.zte@gmail.com wrote:
> Different netns has different requirements on the setting of error_cost
> and error_burst, which are related with limiting the frequency of sending
> ICMP_DEST_UNREACH packets or outputing error message to dmesg.

Could you add a bit more detail about why you need this knob per netns?
The code looks fine, no objections there, what I'm confused by is that
we don't have this knob for IPv6. So is it somehow important enough for
v4 to be per-ns and yet not important enough to exist at all on v6?

Could you add Documentation in Documentation/admin-guide/sysctl/net.rst
while at it, and use READ_ONCE / WRITE_ONCE when accessing the sysctl?

Please make sure to CC the relevant maintainers. IP maintainers were
not CCed here. The get_maintainers script will tell you who to CC,
please use it.
