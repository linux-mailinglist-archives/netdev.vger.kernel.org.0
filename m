Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 703EA558910
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 21:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiFWTeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 15:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbiFWTde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 15:33:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F8E34EDFA;
        Thu, 23 Jun 2022 12:14:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA2E4B824BD;
        Thu, 23 Jun 2022 19:14:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BD72C341C0;
        Thu, 23 Jun 2022 19:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656011670;
        bh=wC/mFFOXrER8itkfHbAsJlzoussVbkCh7WfuQkWX524=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Uuir36EaxLJoFbQNhTM3TJD0TQfF9zlezPxAKPYt05pIDsPDlyU9JhpvtPJceomx+
         EBCHpxQgx59JsnVOVGJAnjEM5tAdsD+fzelCIqHSbMd7vyjGkMYJG7Qocuw9cJaZRb
         JvalXj+2PXrN2eSOqaJMSyPrfDmtFB7JlvWesQPR4saJpgDirsRxf1j67tCsz2fsk8
         0/V3GUER1ZlLysdquV50C0YuYlOUwzRTKBxtTjkp7jg94n4RXRwn9XrvCSmy7VoQQZ
         b/4YjlLKtmx23DzBdNYYN5gN8udxWdt5B7wAW6S3z/KTjLa37cFV8PfNKRVA6V31OJ
         8X3w4AOIj5f3g==
Date:   Thu, 23 Jun 2022 12:14:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jianglei Nie <niejianglei2021@163.com>
Cc:     linux@armlinux.org.uk, andrew@lunn.ch, hkallweit1@gmail.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: sfp: fix memory leak in sfp_probe()
Message-ID: <20220623121421.3bc054d2@kernel.org>
In-Reply-To: <20220623070914.1781700-1-niejianglei2021@163.com>
References: <20220623070914.1781700-1-niejianglei2021@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Jun 2022 15:09:14 +0800 Jianglei Nie wrote:
> sfp_probe() allocates a memory chunk from sfp with sfp_alloc(), when
> devm_add_action() fails, sfp is not freed, which leads to a memory leak.
> 
> We should free the sfp with sfp_cleanup() when devm_add_action() fails.

.. and please add a Fixes tag
