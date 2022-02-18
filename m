Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 036C74BB0D0
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 05:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbiBREkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 23:40:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbiBREkI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 23:40:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2EC9251E70
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 20:39:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C068B82499
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 04:39:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F28EBC340E9;
        Fri, 18 Feb 2022 04:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645159190;
        bh=3ENLfIxlWOCUKfzQXf7s9f6vSwbc6pM/GeB6iggU4OQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uipD/YuGsZW1YX1N44KJaiCB6gqIXyoSa2rAX6HPIt7uJTxv+PzDTXmT//2L9p4Y9
         7zrpcW0mJXwpQRGO1buYSG+r1nIcmG351FJVYmYBpZIv2mEcjfzJQwP4eMw6jUoe5P
         AlvARDKZ/pCvTu24RUqVQBqU6cHoYqvS5/LcyvjOZqwSR3TQx5V4hxIKt6EFT1SJj0
         xaMVFpWwMEQEQQN6+iy/qnBWp8RrLislNx9w/icCWITNDrFl1Ceea0yw2A2w3qHr/J
         PTRj55/0kNX+WMJufo1ZnjZaDBtbvKsyh8OiOWgkohZjwlW8AmJiqTz1jOpIcl+odr
         FWIbQ/+LtWSQA==
Date:   Thu, 17 Feb 2022 20:39:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: Re: [PATCH net-next 2/6] nfp: add support to offload tc action to
 hardware
Message-ID: <20220217203948.7eb7835e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220217105652.14451-3-simon.horman@corigine.com>
References: <20220217105652.14451-1-simon.horman@corigine.com>
        <20220217105652.14451-3-simon.horman@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Feb 2022 11:56:48 +0100 Simon Horman wrote:
> +	if (add)
> +		return 0;
> +	else
> +		return -EOPNOTSUPP;

	return add ? 0 : -EOPNOTSUPP;

or at least remove the else, everything after if () return; is in an
'else' branch.
