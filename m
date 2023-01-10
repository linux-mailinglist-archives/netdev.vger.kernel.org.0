Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1345663692
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 02:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbjAJBNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 20:13:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbjAJBNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 20:13:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3018F34764
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 17:13:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CC3B61474
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 01:13:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A68DC433EF;
        Tue, 10 Jan 2023 01:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673313229;
        bh=bMtMi88FJGwgegRR9IhTCoCpA6CtPDRgGQVATZImirc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UZZUBS0P9RXcQleyPYCxJy7KobNLv63xpNBRXwM2eutrk2Blr7h64QmfganTGBHEv
         MtNTHRCsgCrLGi3JF9DN4o/npNnL4I1oS4sKEJKjoecW45FXfOw9REBlF9OiTSmIP7
         ozEpj08j0XRr6f3B+dyUt+W8tGrYrqdRoslM8AqzhgEEsC2+lu3iZQwclst/JQFVs6
         PAHbXJX/AB4KbyHk41u5ybaJ5HLbrx71u8al8CGrRyyLPyqwyy8yOO3NoVAEl7xMsX
         7hqSNYfihSa9qurgHsAK9ya/FbnGkdtPtAh2MxZ7WjnO/43HwDwepp59ssK+EijhvR
         XQ78t55zcznQg==
Date:   Mon, 9 Jan 2023 17:13:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: Re: [patch net-next v3 00/11] devlink: features, linecard and
 reporters locking cleanup
Message-ID: <20230109171348.72c074ab@kernel.org>
In-Reply-To: <20230109183120.649825-1-jiri@resnulli.us>
References: <20230109183120.649825-1-jiri@resnulli.us>
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

On Mon,  9 Jan 2023 19:31:09 +0100 Jiri Pirko wrote:
> This patchset does not change functionality.
> 
> In the first patch, no longer needed devlink features are removed.
> 
> Patches 2-7 removes linecards and reporters locks and reference counting,
> converting them to be protected by devlink instance lock as the rest of
> the objects.
> 
> Patches 8 and 9 convert linecards and reporters dumpit callbacks to
> recently introduced devlink_nl_instance_iter_dump() infra.
> Patch 10 removes no longer needed devlink_dump_for_each_instance_get()
> helper.
> 
> The last patch adds assertion to devl_is_registered() as dependency on
> other locks is removed.

Other than the question patch 1, lgtm!
