Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA94E6E1290
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 18:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjDMQl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 12:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbjDMQl6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 12:41:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0BC49013
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 09:41:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DDAE63FE5
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 16:41:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67097C433EF;
        Thu, 13 Apr 2023 16:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681404116;
        bh=PhCMiBO5JarNQ+DEGA2CjLPDcOHebnQ58PwdgXKorZI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YUvjG1+GukuI/zijzJCFFJUW2/NWvL+FCoFKTMZnAC9czl/lUb3uX2c78q1pXNnHx
         Q0uUQyOeIkf3TihaVfjJXD9LBWsYVqEObF9K5rmALLAuxNvcJgcltOkjEhu06R9Pt3
         sfFMNc7WJMWATHU3w1RfYne6+VpQb+o4eqRcAhdSx4H/BbPfVFwj6cAgfILkg9Eo2o
         DxNox4He3vT7CGMSfFNoiUkQA0JOq+Qptme3hqhJHa7WIH8+GzyLv8000UOIhE9AV0
         Z4vTA2hH+lr9ZhWMUiVP3dj3oM8Z8b9KSmy5CMbGPObQpQ2N6SbGeQSH2TWTIuPYF5
         667sVXa37SCsQ==
Date:   Thu, 13 Apr 2023 09:41:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Liang Chen <liangchen.linux@gmail.com>
Cc:     ilias.apalodimas@linaro.org, edumazet@google.com, hawk@kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        alexander.duyck@gmail.com, linyunsheng@huawei.com
Subject: Re: [PATCH v5] skbuff: Fix a race between coalescing and releasing
 SKBs
Message-ID: <20230413094155.00ac0448@kernel.org>
In-Reply-To: <20230413090353.14448-1-liangchen.linux@gmail.com>
References: <20230413090353.14448-1-liangchen.linux@gmail.com>
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

On Thu, 13 Apr 2023 17:03:53 +0800 Liang Chen wrote:
> Commit 1effe8ca4e34 ("skbuff: fix coalescing for page_pool fragment
> recycling") allowed coalescing to proceed with non page pool page and page
> pool page when @from is cloned, i.e.

I think Alex is out for spring celebrations so let me take this 
in for today's PR. Thanks!
