Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BDAE5A1E32
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 03:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243798AbiHZBce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 21:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiHZBcd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 21:32:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF6BB69F53
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 18:32:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6529AB8092A
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 01:32:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB833C433D7;
        Fri, 26 Aug 2022 01:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661477550;
        bh=O9nH+bP+FkGqSMFpVue9GdA60fXQFPaWc1svb/IQKlA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U3X7ttJzaL5SvbBsZrJa0OKcdStsyPyTCJ1kdGPKTOuJcb5/bK810bwWNJYRRsdYj
         qwUsZkusFk4YBRF7tfAaphztYru2oR5UwA42AKx4CXAle0qQQHDAkuKLmyqnqsXn17
         ko9Hy1mB1/noLmz3APn0z7S19FR0Pxhftv+uzVF0uVrTJiv9CukIu5ET1nsEzjHEMs
         tBB1kfM4ahSPbkar2SgSkAoA+9o64jfTWh5D6f3Z0ZVVIiUg7p1Hy8wxvloKYth7SL
         ZPa6j4tV/zO/vo4sYoZOb6/Kwj1Gcm8xvdwdUkGqQLMJZs2XFGKnGzvGAiABTWc6+y
         bIuhg1X+m8Rqg==
Date:   Thu, 25 Aug 2022 18:32:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?w43DsWlnbw==?= Huguet <ihuguet@redhat.com>
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 2/3] sfc: support PTP over IPv6/UDP
Message-ID: <20220825183229.447ee747@kernel.org>
In-Reply-To: <20220825090242.12848-3-ihuguet@redhat.com>
References: <20220819082001.15439-1-ihuguet@redhat.com>
        <20220825090242.12848-1-ihuguet@redhat.com>
        <20220825090242.12848-3-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Aug 2022 11:02:41 +0200 =C3=8D=C3=B1igo Huguet wrote:
> -static int efx_ptp_insert_ipv4_filter(struct efx_nic *efx, u16 port)
> +static inline void efx_ptp_init_filter(struct efx_nic *efx,
> +				       struct efx_filter_spec *rxfilter)

No static inline in sources unless you actually checked and the
compiler does something stupid (pls mention it in the commit message=20
in that case).

> +static inline int
> +efx_filter_set_ipv6_local(struct efx_filter_spec *spec, u8 proto,
> +			  const struct in6_addr *host, __be16 port)

also - unclear why this is defined in the header
