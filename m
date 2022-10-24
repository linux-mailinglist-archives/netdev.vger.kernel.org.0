Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E928660B6C8
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 21:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233005AbiJXTKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 15:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233023AbiJXTKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 15:10:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D99FA15FEB;
        Mon, 24 Oct 2022 10:49:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C7A0B81978;
        Mon, 24 Oct 2022 17:29:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 770B3C433D6;
        Mon, 24 Oct 2022 17:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666632594;
        bh=vIPEuadz4wBsNJCFqsj4+XK0Nga5/XK3St4OhCu66q8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Vqbn2KpF0tIBYJ0lsKaDWCn/FTOR6Cz+nEnB5lyV1oqFKOhHzKQpQpyTsqgzwq4Sz
         tIZAQiO8GHgwG0IaWg04BRtTYuHtN0IP+Eu0iX9LUGENdEzixFclrZMQaBGYEkCMUf
         0+MoUqAqC3WFsMhn42eTddAi0sA9EHuMs+9aYxAMEgHvLjuYiCEodQyQYEJGrEtoBS
         4T9NVzus9ybYohS2ivNmZy/OfSfZitHC9aZilVXzx9HHfZytrSf+KhceqkjbL71eUt
         KlXqiB3xAfA8q0vxUkV+/08vnUtUt4ruTB3M0WemVwe534owiGkeVLepWfK5GIkSQE
         XlaMFhwEsKiXg==
Date:   Mon, 24 Oct 2022 10:29:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "KaiLong Wang" <wangkailong@jari.cn>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: replace ternary operator with min()
Message-ID: <20221024102953.1ecc15f0@kernel.org>
In-Reply-To: <4e5c1182.347.18404f42721.Coremail.wangkailong@jari.cn>
References: <4e5c1182.347.18404f42721.Coremail.wangkailong@jari.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 23 Oct 2022 21:07:00 +0800 (GMT+08:00) KaiLong Wang wrote:
> Fix the following coccicheck warning:
> 
> net/ipv4/igmp.c:2621: WARNING opportunity for min()
> net/ipv4/igmp.c:2574: WARNING opportunity for min()
> net/ipv4/ip_sockglue.c:285: WARNING opportunity for min()
> 
> Signed-off-by: KaiLong Wang <wangkailong@jari.cn>

Please don't send coccicheck fixes for net and drivers/net.
(And I mean *you* specifically shouldn't send them since you 
don't even build test the fix.)
