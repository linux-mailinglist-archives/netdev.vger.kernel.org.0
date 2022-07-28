Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F79D583711
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 04:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232869AbiG1ClY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 22:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234140AbiG1ClX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 22:41:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A57C542AEE
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 19:41:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 395A5617F2
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 02:41:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50F2CC433D6;
        Thu, 28 Jul 2022 02:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658976081;
        bh=XVaGzfS5WV3Lrurd9+yV27UJjnH4WXKoH8U7/JLZ5Pc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CKIDu8F5YjIVXyLrnWdfh3etY994TV5OowrciXi9MrYaA/SA5aeH+7djUejuvapVF
         Fq0edULCtgGJuMPbIQVZu+PfDu8s2GQMlQZgQbKfzVXrg3WjSoISEkuwhYlqiw4aVf
         LcsfXMD4hNz7dhhYA0NQf0OecpbsWwfk5hPqd83aWJYmyFByIqhaoOqyzPLjWALKu3
         Q1us6Lcwr7cWNbid2hOR7of3B3Js5T5tybd9StvnU6WmKNgR0LuNXpHo4dwSB/fy7s
         JErcYSm1jwDEUz+uJnA5zBcLHH2gPGeBv4jy8v9/dWfOK36WOv8dcrlAbH3bbAQvKU
         gFptKs7S98ETw==
Date:   Wed, 27 Jul 2022 19:41:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Subbaraya Sundeep <sbhatta@marvell.com>
Cc:     <davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
        <sgoutham@marvell.com>, <netdev@vger.kernel.org>,
        Harman Kalra <hkalra@marvell.com>
Subject: Re: [net v2 PATCH 2/5] octeontx2-af: suppress external profile
 loading warning
Message-ID: <20220727194120.62af8ee7@kernel.org>
In-Reply-To: <1658844682-12913-3-git-send-email-sbhatta@marvell.com>
References: <1658844682-12913-1-git-send-email-sbhatta@marvell.com>
        <1658844682-12913-3-git-send-email-sbhatta@marvell.com>
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

On Tue, 26 Jul 2022 19:41:19 +0530 Subbaraya Sundeep wrote:
> -	if (!request_firmware(&fw, kpu_profile, rvu->dev)) {
> +	if (!firmware_request_nowarn(&fw, kpu_profile, rvu->dev)) {

Consider switching to request_firmware_direct() in net-next.
I doubt you need the sysfs fallback, I think udev dropped 
the support for it.
