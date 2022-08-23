Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF78159ED0B
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 22:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234048AbiHWUEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 16:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiHWUE0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 16:04:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B30A979FD;
        Tue, 23 Aug 2022 12:18:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7AB83B820CD;
        Tue, 23 Aug 2022 19:18:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BFADC433C1;
        Tue, 23 Aug 2022 19:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661282334;
        bh=qHgYjwQ0IFCKw3QUfPb1X9CZu1omMNElbC3qjvwe1EA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QrHBPNoiI2xu0EpP4R9o0QbgxzFgJkk1OKc1MEklL0SobO/2CLb/d9JWPyTWJJlL1
         uHlrxKYnNhzkLQgmOs/GnWE/OtFKwJzKxhHVsyjxYR8mjRgbLkyzAvixoVbP4KM1ro
         hkzzbN+dmxByP9yfj6vHESJngWNjix5dkXVvDSiXr6YoFUzpclqMyqKPIXpVC31qQ0
         w76lw67AJZdlcBKInQekVt8ExhTPDd0aDHF8wkho8J/hf+U4aLRkBM+A2g8NK8tR9u
         dyX+nPEjveunyBjGOxX1fMdutxBBbsiSS/BCaQneTsCm/M2rTcWP1nTTiI8tlaC+dd
         mJwEh9cOw0UQA==
Date:   Tue, 23 Aug 2022 12:18:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
Subject: Re: [PATCH net-next v4 0/9] vsock: updates for SO_RCVLOWAT handling
Message-ID: <20220823121852.1fde7917@kernel.org>
In-Reply-To: <YwUnAhWauSFSJX+g@fedora>
References: <de41de4c-0345-34d7-7c36-4345258b7ba8@sberdevices.ru>
        <YwUnAhWauSFSJX+g@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Aug 2022 15:14:10 -0400 Stefan Hajnoczi wrote:
> Stefano will be online again on Monday. I suggest we wait for him to
> review this series. If it's urgent, please let me know and I'll take a
> look.

It was already applied, sorry about that. But please continue with
review as if it wasn't. We'll just revert based on Stefano's feedback
as needed.
