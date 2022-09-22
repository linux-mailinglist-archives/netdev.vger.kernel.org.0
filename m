Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A88265E57AF
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 02:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiIVA7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 20:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiIVA7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 20:59:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 505EA1147;
        Wed, 21 Sep 2022 17:59:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D567462BC0;
        Thu, 22 Sep 2022 00:59:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4338C433C1;
        Thu, 22 Sep 2022 00:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663808392;
        bh=o/4V1K6XXLAgCB50Zj6lJROrgfPJp9ayWQB6Bk2ACTU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QCj6vsX01N1ZFOgO4nhq2F+Dj7zXXKiwsjSbZgYn7jagLPtiKl8OOoh1VOvlO8aLD
         oJuC8tlFTEccz3XD6YoflNCmlYizEw7wvcrEndLJe5bG37uOiTWY+0myQhXtOMyJud
         VhfB7uB1tt87adnh7Xntk7HC1mrJh5c7aezoYlMhfa5sMQ3ebbYqQvQKD76AZhuWiV
         RJ0Jc2APtcdjaae4O2JyWpa1ZgAhkg4n7q9ZSdRVvvk4QjQQAYla0LvDHQ/jPrpkoG
         ZsFq9fGrAiRuWQxQaV+lpg28/PKxV3EdLBQBYXHlTriB/sX2d/0FCl91JX4IXzrlxz
         mRGrad6o6ohdA==
Date:   Wed, 21 Sep 2022 17:59:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     davem@davemloft.net, robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 5/7] tsnep: Add EtherType RX flow
 classification support
Message-ID: <20220921175950.6d256ffa@kernel.org>
In-Reply-To: <20220915203638.42917-6-gerhard@engleder-embedded.com>
References: <20220915203638.42917-1-gerhard@engleder-embedded.com>
        <20220915203638.42917-6-gerhard@engleder-embedded.com>
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

On Thu, 15 Sep 2022 22:36:35 +0200 Gerhard Engleder wrote:
> +	if (!rule) {
> +		mutex_unlock(&adapter->rxnfc_lock);
> +
> +		return -EINVAL;

nit: maybe -ENOENT in cases when rule was not found?
