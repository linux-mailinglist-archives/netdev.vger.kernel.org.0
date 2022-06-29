Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7FF15605F0
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 18:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbiF2Qer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 12:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbiF2Qeq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 12:34:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECCEF2ED76;
        Wed, 29 Jun 2022 09:34:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 944CC61CC9;
        Wed, 29 Jun 2022 16:34:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECB63C34114;
        Wed, 29 Jun 2022 16:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656520485;
        bh=sFETOlgQpy9AOtXsqkIBLwAzXJA3N7SbWK2htFFpod4=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=CwSA1DDZbxtpffCPw7RONM05jSVQih1yJlYiH1+2sOckkrXu4HrZ+vG16N2gI4Ztw
         q8yv8hACvHaNqdek8TGLXgDz6g9NCQC6IynBCDq3zAKhSo2E6+A9W0HWNhOsyCh88G
         3O6JZFqs9zevcfps9aJhBHSxFvQHaoMe1XMKNiStcnKtUaNHNTR2SDFsWsEIiCsIgW
         w3L6RI0MJ61ph5CFFS4+o4+mOfhgMLK6nCmOkbOkrnLCLWpdJq7/zCUH7PuUPF1iRL
         myuN/9jPx8UsOIPnnuaHo/QRgZTWO8jjAbZS8gKC6IXmLUEZBcP5NumrwkiEN+q6SI
         uJO6m6L0XbDRg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 76CC25C0E5F; Wed, 29 Jun 2022 09:34:44 -0700 (PDT)
Date:   Wed, 29 Jun 2022 09:34:44 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Todd Kjos <tkjos@android.com>,
        Martijn Coenen <maco@android.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Christian Brauner <brauner@kernel.org>,
        Hridya Valsaraju <hridya@google.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Theodore Ts'o <tytso@mit.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Alex Xu (Hello71)" <alex_y_xu@yahoo.ca>,
        Paolo Abeni <pabeni@redhat.com>, Rob Herring <robh@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Neeraj Upadhyay <quic_neeraju@quicinc.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        wireguard@lists.zx2c4.com, netdev@vger.kernel.org,
        rcu@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] remove CONFIG_ANDROID
Message-ID: <20220629163444.GG1790663@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20220629150102.1582425-1-hch@lst.de>
 <20220629150102.1582425-2-hch@lst.de>
 <Yrx5Lt7jrk5BiHXx@zx2c4.com>
 <20220629161020.GA24891@lst.de>
 <Yrx6EVHtroXeEZGp@zx2c4.com>
 <20220629161527.GA24978@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220629161527.GA24978@lst.de>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 29, 2022 at 06:15:27PM +0200, Christoph Hellwig wrote:
> On Wed, Jun 29, 2022 at 06:13:05PM +0200, Jason A. Donenfeld wrote:
> > Good! It sounds like you're starting to develop opinions on the matter.
> 
> No, I provide facts.  Look at both the definition of the symbol, and
> various distribution kernel that enabled it and think hard if they run
> on "Android" hardware.  Not just primarily, but at all.

So you are OK if your patch is accepted, and then CONFIG_ANDROID is
re-introduced but used only for building kernels intended to run on
Android systems?

Asking for a friend.  ;-)

							Thanx, Paul
