Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 657A564D5F8
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 05:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiLOEs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 23:48:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbiLOEs5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 23:48:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C11137F8F;
        Wed, 14 Dec 2022 20:48:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 486B4B81A26;
        Thu, 15 Dec 2022 04:48:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 362ACC433EF;
        Thu, 15 Dec 2022 04:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671079732;
        bh=n5a5d/H8ulIQkozqDLE2F1ns4k/z46ZF4QvyLXMqdDQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XK1xQmL18+qWIY+/FcJKpt+gq2m/riva7HjLNyOcyNyeXv8J3PmrpIfbQql6W968p
         TbEv8eTFDkBQRkXGlqEF6A4CStSWrNVeaXsI1bqaq7K88SMEMB2+QF8ZFe0JZLMPr1
         aJqOKv1+akB+vk2+NA35Ww2bVX7Uf3aQLb3zFk1mxsl2mYtGF495YK01glOYsA9afM
         fwMT4u7B3n83W8ym/zT5rvUWGdFC7o/g64TtNZG/8jfe5XstNUJncsdcBkcM7oKXXr
         6LXvE7WXh7cexR3JHmpArKWcYNxCs2Pu9oeOZdb+yVDnHWpWsByBG+sSv1Ujyy9aba
         8L6K7++v6ji8Q==
Date:   Wed, 14 Dec 2022 20:48:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Decotigny <decot+git@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nikolay Aleksandrov <razor@blackwall.org>,
        David Ahern <dsahern@kernel.org>,
        "Denis V. Lunev" <den@openvz.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Chen Zhongjin <chenzhongjin@huawei.com>,
        David Decotigny <ddecotig@google.com>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>,
        Thomas Zeitlhofer <thomas.zeitlhofer+lkml@ze-it.at>
Subject: Re: [PATCH v1 1/1] net: neigh: persist proxy config across link
 flaps
Message-ID: <20221214204851.2102ba31@kernel.org>
In-Reply-To: <20221213073801.361500-1-decot+git@google.com>
References: <20221213073801.361500-1-decot+git@google.com>
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

On Mon, 12 Dec 2022 23:38:01 -0800 David Decotigny wrote:
> From: David Decotigny <ddecotig@google.com>
> 
> Without this patch, the 'ip neigh add proxy' config is lost when the
> cable or peer disappear, ie. when the link goes down while staying
> admin up. When the link comes back, the config is never recovered.
> 
> This patch makes sure that such an nd proxy config survives a switch
> or cable issue.

Hm, how does this square with the spirit of 859bd2ef1fc11 ?

Would be great to hear from David, IDK if he's around or off until 
next year.
