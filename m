Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD24589EC1
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 17:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239861AbiHDPfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 11:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234809AbiHDPfO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 11:35:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0C3111B
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 08:35:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4909F61376
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 15:35:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BAAAC4347C;
        Thu,  4 Aug 2022 15:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659627309;
        bh=o9clG3Klii3bN3MDbqNoHS8jcJSY9uPPybH6LyMgMTQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=L9ndqXj8npPFuXcoyZMN3suLDxJTAP3bqEScPOAWMVxSUku0xu0AvXLT1VAR/y7FB
         V706O8Z5rfMbnqUIMl4GfnkToxaD8l+5QjEvspDXO+odKzVd5KJKPR5TWRQAFQRPYP
         bQgwwJHGmcYfH9W2lBmL0ks26l4wq4KEcU4s4Hbt7pPe3HcgTgZYW0pwoxuiMfOf12
         4nr3c99q6yC6G2fJUbd/PM+MhzKPMVPa47Y+7xMwOX/qifPGZhFrVQDEb8xq2q7pcz
         0DaWVreeaBYxPJejMBiJX+Sao/dcOyhtxGG3hXafX8OYpxiyUmLWmtppEcQIaj+CP9
         VJS65BzLsMdGA==
Date:   Thu, 4 Aug 2022 08:35:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru,
        Ran Rozenstein <ranro@nvidia.com>,
        "gal@nvidia.com" <gal@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v3 7/7] tls: rx: do not use the standard
 strparser
Message-ID: <20220804083508.3631071e@kernel.org>
In-Reply-To: <61de09de-b988-3097-05a8-fd6053b9288a@gmail.com>
References: <20220722235033.2594446-1-kuba@kernel.org>
        <20220722235033.2594446-8-kuba@kernel.org>
        <84406eec-289b-edde-759a-cf0b2c39c150@gmail.com>
        <20220803182432.363b0c04@kernel.org>
        <61de09de-b988-3097-05a8-fd6053b9288a@gmail.com>
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

On Thu, 4 Aug 2022 11:05:18 +0300 Tariq Toukan wrote:
> >   	trace_tls_device_decrypted(sk, tcp_sk(sk)->copied_seq - rxm->full_len,  
> 
> Now we see a different trace:
> 
> ------------[ cut here ]------------
> WARNING: CPU: 4 PID: 45887 at net/tls/tls_strp.c:53 

Is this with 1.2 or 1.3?
