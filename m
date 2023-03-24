Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A01846C76CC
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 06:05:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbjCXFFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 01:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjCXFFd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 01:05:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34F102886C
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 22:05:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEADB6294E
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 05:05:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D783DC433EF;
        Fri, 24 Mar 2023 05:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679634332;
        bh=jk/AQqczroYcj/NV4MqSPCNlKLfRWVCq+u3EsCW03zc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ck6SkR7LkB8Jn+gQjlss5n3N1Dg80xrknXYy8FMHQCz3Uy5Pfot47QgO+PggN1ohO
         0v8vQNlL2reaFt9po+pWqxXZwGwL0CT1mIjpURfhAsl3/Y95I3EoL5erR3+2+en5lo
         o8WSTJHwL20gDOcLDftl85B5prWpZlHwFiMtdudrFggkYYbU8AtPjYN9olOZGFt7PL
         IY879NHh1NvFB/i0cfrZ9rhWip6JyYVUQxvz8J4TLOqQzoYT1R9Lo/bfwefIDjv24a
         442EPM7FdQiX4eIYw33xTeokAAhhIO9Vs7S0wE7mJlN8lWEW1CSw7DIZzHpn8ZInAY
         O44jUh0pdi1wQ==
Date:   Thu, 23 Mar 2023 22:05:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <edward.cree@amd.com>
Cc:     <linux-net-drivers@amd.com>, <davem@davemloft.net>,
        <pabeni@redhat.com>, <edumazet@google.com>,
        Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <habetsm.xilinx@gmail.com>, <michal.swiatkowski@linux.intel.com>
Subject: Re: [PATCH net-next v2 5/6] sfc: add code to register and
 unregister encap matches
Message-ID: <20230323220530.0d979b62@kernel.org>
In-Reply-To: <57c4e599df3fff7bf678c1813445bd6016c6db79.1679603051.git.ecree.xilinx@gmail.com>
References: <cover.1679603051.git.ecree.xilinx@gmail.com>
        <57c4e599df3fff7bf678c1813445bd6016c6db79.1679603051.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Mar 2023 20:45:13 +0000 edward.cree@amd.com wrote:
> +__always_unused
> +static int efx_tc_flower_record_encap_match(struct efx_nic *efx,
> +					    struct efx_tc_match *match,
> +					    enum efx_encap_type type,
> +					    struct netlink_ext_ack *extack)
> +{
> +	struct efx_tc_encap_match *encap, *old;
> +	bool ipv6;
> +	int rc;

clang sayeth 

drivers/net/ethernet/sfc/tc.c:414:43: warning: variable 'ipv6' is uninitialized when used here [-Wuninitialized]
        rc = efx_mae_check_encap_match_caps(efx, ipv6, extack);
                                                 ^~~~
drivers/net/ethernet/sfc/tc.c:356:11: note: initialize the variable 'ipv6' to silence this warning
        bool ipv6;
                 ^
                  = 0
