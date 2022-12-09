Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D737648687
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 17:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbiLIQeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 11:34:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiLIQeT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 11:34:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F2F7720A
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 08:34:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BD0EB82785
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 16:34:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63DD3C433EF;
        Fri,  9 Dec 2022 16:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670603655;
        bh=LcoCY2/p6vLZBiPVrQpjHYeN+HYYqSMWhdzAQTEqwXU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ybnjg3sGCftGQoE2nGaTAY1LKn0FUAagfEcWVMrTlf/UQk6HLX5jYyD47c7qDM+QQ
         0pPOC3NUFrfWL28mZ71LOml9sNiLUUgaSTUNc4dAr/TIWPvEV+lNUON9yiCc020qt9
         EE46UkuoMTZa2NFYQ0wek8Eq+WgzxK3poBI1VPiotTdIS7e966XiGs5EPkVydAEp/n
         Vkw8CuAZ/RSY98y5bpyQsOjqroBBw7IC3PnDK+q+xh/to7qGnXO34dbkCdKQAPGJkG
         0Z7DfJ5UL6VowQFqTC8ytVj6N+MCA+RJAPVr/hlB27PY9ZQLs6xBXD5n6/mpYbJI4Y
         vjDpL4JbLlEsQ==
Date:   Fri, 9 Dec 2022 08:34:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>
Subject: Re: [net-next 14/15] net/mlx5: SRIOV, Add 802.1ad VST support
Message-ID: <20221209083414.4f6f1aac@kernel.org>
In-Reply-To: <Y5LCE57xAaMQqOYd@x130>
References: <20221203221337.29267-1-saeed@kernel.org>
        <20221203221337.29267-15-saeed@kernel.org>
        <20221206203414.1eaf417b@kernel.org>
        <Y5AitsGhZdOdc/Fm@x130>
        <20221207092517.3320f4b4@kernel.org>
        <Y5GgNlYbZOiH3H6t@x130>
        <20221208170459.538917da@kernel.org>
        <Y5KWJYBij3bzg5hU@x130>
        <20221208180442.2b2452fb@kernel.org>
        <Y5LCE57xAaMQqOYd@x130>
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

On Thu, 8 Dec 2022 21:05:23 -0800 Saeed Mahameed wrote:
> >I see, but that's the fix? Uniformly drop?
> >Start stacking with just .1q?
> >Auto-select the ethtype for .1ad if there's already a tag?  
> 
> push the vst .1q tag. keep original tags intact.
> per policy we won't have .1ad support :( .. 

Yup, stacking another .1q sounds okay to me.
Not exactly standard-compliant but I bet there's already a device out
there which does exactly this so meh..
