Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73DD36BBE0F
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 21:40:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbjCOUkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 16:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbjCOUku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 16:40:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7840D64250;
        Wed, 15 Mar 2023 13:40:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19DE9B81EBB;
        Wed, 15 Mar 2023 20:40:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F78FC433EF;
        Wed, 15 Mar 2023 20:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678912846;
        bh=l5detRYfrET4iKvXBcMEX0M/eeoI/uj2ilCZSlWZI4E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HnkZdEv8X3LdGjTRUrPY/KI0A5bkFE5ousTuzqe82yjgwoTs1hnoFhVPWpPULcDqZ
         eBux7xJhaOEDQVfJObqadPfV9ek+/AXN07G3NXhqhKb7QLE6lOV6oy5OMofy+QADgR
         uT3A8EvBQCJyOiCnnp6MrvyrK2Kmcph8F3/48PVxOP+x/3GT49CH7Tn2GH5ArZjTtc
         BSogI9ApxNTjkQBfDUkfdxmzf69ulBUnWpJMxQ6bQ9hAoBNwyoFQUfzi39g0NEp0jb
         jsWqd/WgYAJAuNrzMSKmTWBgbbpTATTYGnQfiA1JngYfbMzjcBNb6DZpbYyJO/9Mfx
         1TR2hpImPetow==
Date:   Wed, 15 Mar 2023 13:40:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     Kai <KaiShen@linux.alibaba.com>, kgraul@linux.ibm.com,
        wenjia@linux.ibm.com, jaka@linux.ibm.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next v4] net/smc: Use percpu ref for wr tx reference
Message-ID: <20230315134045.2daeffa4@kernel.org>
In-Reply-To: <ZBGBWafISbzBapnq@TONYMAC-ALIBABA.local>
References: <20230313060425.115939-1-KaiShen@linux.alibaba.com>
        <20230315003440.23674405@kernel.org>
        <ZBGBWafISbzBapnq@TONYMAC-ALIBABA.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Mar 2023 16:27:05 +0800 Tony Lu wrote:
> > You're missing a --- separator here, try to apply this patch with 
> > git am :/  
> 
> There is another commit ce7ca794712f ("net/smc: fix fallback failed
> while sendmsg with fastopen") that has been merged that also has this
> problem. Maybe we can add some scripts to check this?

Good idea, checkpatch is probably the right place to complain?
A check along the lines of "if Sign-off-by: has been seen, no
empty lines are allowed until ---"?
Would you be willing to try to code that up and send it to the
checkpatch maintainer? If they refuse we can create a local
check just for networking in our on scripts.
