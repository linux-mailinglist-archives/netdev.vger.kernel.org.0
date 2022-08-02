Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE825875E0
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 05:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235506AbiHBDSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 23:18:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231535AbiHBDSk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 23:18:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B86F422D5;
        Mon,  1 Aug 2022 20:18:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 984DFB81993;
        Tue,  2 Aug 2022 03:18:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2A90C433C1;
        Tue,  2 Aug 2022 03:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659410315;
        bh=Z7/VGcA7gFQVK1Wgj1jcPP84BZehqajH/txf1dOs4rY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=d2m3X4Ujj0q97QHkKSAe6YqYG4a1lftUG1dFUbFuK1up+FIWPuCI0XuFUISJShZZd
         M3Ja/W6RkdeeSGlUhB9NhI5ywv/5pkrIJMN+TKpC3Sks81JOlJLusMDtoKscN031ul
         fm/8Eyrif9nNvNxVIZpTbcDvQAowGPovY22m23ViXINJ+hp90d5NpIDw5dcgxWUCnm
         CMNlSzmU6Q8Z0PPjjTywXJD18Ph/NY8srjHR0hv2QmYp+f2b5Tn8GzKf/ywtOyTzRp
         oqwoHDZSdXDp8OeMlyrmREFAg8rCngdq3orM8oQxC2xyLmlWFFTw0cklGjMmbCaIPK
         hVCo6x9BSIb/A==
Date:   Mon, 1 Aug 2022 20:18:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vadim Pasternak <vadimp@nvidia.com>
Cc:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH 1/2] Revert "mlxsw: core: Use different get_trend()
 callbacks for different thermal zones"
Message-ID: <20220801201833.79dd5171@kernel.org>
In-Reply-To: <BN9PR12MB5381C2B144840EB0D7390610AF9A9@BN9PR12MB5381.namprd12.prod.outlook.com>
References: <20220801095622.949079-1-daniel.lezcano@linaro.org>
        <BN9PR12MB5381C2B144840EB0D7390610AF9A9@BN9PR12MB5381.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 1 Aug 2022 11:13:36 +0000 Vadim Pasternak wrote:
> > This reverts commit 2dc2f760052da4925482ecdcdc5c94d4a599153c.
> > 
> > As discussed in the thread:
> > 
> > https://lore.kernel.org/all/f3c62ebe-7d59-c537-a010-
> > bff366c8aeba@linaro.org/
> > 
> > the feature provided by commits 2dc2f760052da and 6f73862fabd93 is
> > actually already handled by the thermal framework via the cooling device
> > state aggregation, thus all this code is pointless.
> > 
> > No conflict happened when reverting the patch.  
> 
> I am sorry, I didn't run emulation yet to validate this change.
> Will do it in tomorrow and will send ACK if it is OK.

We'll also need a rebase on top of net-next, the patch as is does not
apply to either of the networking trees.
