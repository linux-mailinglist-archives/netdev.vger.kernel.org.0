Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52AE66D8B8B
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 02:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232656AbjDFAPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 20:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231429AbjDFAPp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 20:15:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F7A2E57
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 17:15:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0BAC0621BA
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 00:15:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19EA3C433EF;
        Thu,  6 Apr 2023 00:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680740143;
        bh=P6kLU1Jv518kc29jvGldEU8lsgqrP1ucB0Ra37+Dsas=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NIHoz2SOEcVawb6tMUIyRCy5BwTbUvmmhLekty1hLCliZzDmB2WmfBUR/ZgtIvrJM
         i0Za5wllyEw33Wlym64iFOvb2flih+XMyMQCIk1/3+n72poipqeXQnvqL/x99k1RjT
         jx3fQ3CSOFhJ647R5VRc6xpiISTNgaKHurTYP647bV278QHtSlvwn2H6419MXKv5hn
         6VfuiQQuLhh4goqL/NNETFZ9BEv1o+UkLAFiRP5r8ow3Z4M8G/8oKMbXEqiO945AS6
         CxvQ2kDNw7VHvily0tQZ9rHQNbgpsyz8jlr+f7WFPGqhYWoCq+YjcZ4N6fvlab74fM
         RXCMsHwh0yYdA==
Date:   Wed, 5 Apr 2023 17:15:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        netdev@vger.kernel.org, Ahmed Zaki <ahmed.zaki@intel.com>,
        Rafal Romanowski <rafal.romanowski@intel.com>
Subject: Re: [PATCH net 1/2] iavf: refactor VLAN filter states
Message-ID: <20230405171542.3bba2cc8@kernel.org>
In-Reply-To: <20230404172523.451026-2-anthony.l.nguyen@intel.com>
References: <20230404172523.451026-1-anthony.l.nguyen@intel.com>
        <20230404172523.451026-2-anthony.l.nguyen@intel.com>
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

On Tue,  4 Apr 2023 10:25:21 -0700 Tony Nguyen wrote:
> +	__IAVF_VLAN_INVALID,
> +	__IAVF_VLAN_ADD,	/* filter needs to be added */
> +	__IAVF_VLAN_IS_NEW,	/* filter is new, wait for PF answer */
> +	__IAVF_VLAN_ACTIVE,	/* filter is accepted by PF */
> +	__IAVF_VLAN_REMOVE,	/* filter needs to be removed */

Why the leading underscores?
