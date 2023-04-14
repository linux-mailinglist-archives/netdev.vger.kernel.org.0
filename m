Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 408DB6E1909
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 02:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbjDNAc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 20:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjDNAc2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 20:32:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE57B7;
        Thu, 13 Apr 2023 17:32:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0EFA6154A;
        Fri, 14 Apr 2023 00:32:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54A45C433EF;
        Fri, 14 Apr 2023 00:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681432345;
        bh=VqUT0h3T9DoBGpj4454pVSsU484YratLmvipr0uxCkE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=bhMNyx/rbBdmZNmBaSVTQITczQgOV7Rzh4tDnCe1rMQL+6sIJAZY5fQtGQ9STmYLD
         Tsl3D97zNWpR9q2PqNOp4NpCmf2J6DgBSu83ps6f0CTSFqQZhfgSSJIrZmJbjTJXz4
         csE7BJdrRsIUEG1sedjspDYgXNwxknODTQszWqY9dv1CRSAKv2gCpXhGN0VqQLoN/E
         ciJenZukBmMuWAAiAieB1s1mYEIw8qbo9mHDjn9+NTMyL3CQafhZ98hwcUOIggHoZs
         SUCBFKZxxgwLQRJGlCBnPg0gAZgcy3AgwxCopNErI/QqccdZNSRFfGVsPFnLYoMc9b
         8rpaSO0PVQjCg==
Message-ID: <a3e202ed-a50f-2a0f-082b-ec0313be096e@kernel.org>
Date:   Thu, 13 Apr 2023 18:32:24 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.1
Subject: Re: [PATCH net-next v2] net/ipv6: silence 'passing zero to ERR_PTR()'
 warning
Content-Language: en-US
To:     Haoyi Liu <iccccc@hust.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     hust-os-kernel-patches@googlegroups.com, yalongz@hust.edu.cn,
        error27@gmail.com, Dongliang Mu <dzm91@hust.edu.cn>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230413101005.7504-1-iccccc@hust.edu.cn>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20230413101005.7504-1-iccccc@hust.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/13/23 4:10 AM, Haoyi Liu wrote:
> Smatch complains that if xfrm_lookup() returns NULL then this does a
> weird thing with "err":

xfrm_lookup is a wrapper around xfrm_lookup_with_ifid which returns
either either a valid dst or ERR_PTR(err).

