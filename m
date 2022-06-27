Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4112355CD5E
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236863AbiF0R7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 13:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233706AbiF0R7K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 13:59:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE6AB4BE
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 10:59:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A11C61426
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 17:59:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84ECCC3411D;
        Mon, 27 Jun 2022 17:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656352748;
        bh=BBjkXE1yy/QTfN7G20TyIIJbkIYGg0wvtGtR0YwDMag=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lwe8u8KCWA42Wd5GiCuNQrfU6Wo/JRsr+PU4Qr3EZl6M4K6ZH8uzTerOzJDyHTBOR
         9eJh975RH4/usyLi5qHueCJ4R64DMRXJR1g6ZNRfgByROe1H5O1cBotgjuacPMmV85
         7/rnq4tPSAm3kcY2GFs9EFAqD6qWrcRaVbespmjEWnI3G1cG/TaOsjvVKvKDF+9oXt
         a24Mm/g9AKj2V8gUJR48TzSncxoY6ZCAnyIQekfClkqXW8lDZBZMkJb4ypn9enaktP
         tINZkNOkyj7cD6GsPPbuTKqNZ/HviJRGaH5HZUecsTUAB8o8cDoG9Qow5ReVC/8f7x
         PWZQJUyE+VYuw==
Date:   Mon, 27 Jun 2022 10:58:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pavel Emelyanov <xemul@openvz.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 net] af_unix: Do not call kmemdup() for init_net's
 sysctl table.
Message-ID: <20220627105859.3ffec11a@kernel.org>
In-Reply-To: <871qvbwf2o.fsf@email.froward.int.ebiederm.org>
References: <20220626082331.36119-1-kuniyu@amazon.com>
        <871qvbwf2o.fsf@email.froward.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 26 Jun 2022 11:43:27 -0500 Eric W. Biederman wrote:
> Kuniyuki Iwashima <kuniyu@amazon.com> writes:
> 
> > While setting up init_net's sysctl table, we need not duplicate the global
> > table and can use it directly.  
> 
> Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> I am not quite certain the savings of a single entry table justivies
> the complexity.  But the looks correct.

Yeah, the commit message is a little sparse. The "why" is not addressed.
Could you add more details to explain the motivation?
