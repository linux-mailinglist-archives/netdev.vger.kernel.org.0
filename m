Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38BD7573399
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 11:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234699AbiGMJ4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 05:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230398AbiGMJ4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 05:56:30 -0400
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A49B8EBF;
        Wed, 13 Jul 2022 02:56:30 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id BD48EC01E; Wed, 13 Jul 2022 11:56:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1657706188; bh=pjiAEa60Alkw3UWG+MQjG9CTRo60uCCBhIdRs0otWFc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oWmdA5i9zqTEWirP6yj0ZQ3tI3n/29ATEa6esdIR5yvp+HITlzHeZDdnhHCUQUJQ3
         FmCJH4GdJAYSJ3KP5H6961KfFSk/4PQZkZjlBvIvMn1Wg/foE8TYp6EzjLls1OrgfP
         Rp+O+p+nIoJ0wtGMYNFwmv3kuKVaztM2Rmww0apJCX2vbXKH0JaEebdnwOMLlJKNKy
         CbGBO4reBCOoTXx7bucrX3VKfo0cP5kxUOhRqq8yBZGgEAOVIFGcrrcHpjyURCZQ0p
         S69LhEvNNr9PhuQ+zsJUeiiBwjXJdab0pGmLbW8Od3TykW0XgEIscpPQ/cClMT1ViP
         9tUSyiZNkvQrA==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id D8981C009;
        Wed, 13 Jul 2022 11:56:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1657706188; bh=pjiAEa60Alkw3UWG+MQjG9CTRo60uCCBhIdRs0otWFc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oWmdA5i9zqTEWirP6yj0ZQ3tI3n/29ATEa6esdIR5yvp+HITlzHeZDdnhHCUQUJQ3
         FmCJH4GdJAYSJ3KP5H6961KfFSk/4PQZkZjlBvIvMn1Wg/foE8TYp6EzjLls1OrgfP
         Rp+O+p+nIoJ0wtGMYNFwmv3kuKVaztM2Rmww0apJCX2vbXKH0JaEebdnwOMLlJKNKy
         CbGBO4reBCOoTXx7bucrX3VKfo0cP5kxUOhRqq8yBZGgEAOVIFGcrrcHpjyURCZQ0p
         S69LhEvNNr9PhuQ+zsJUeiiBwjXJdab0pGmLbW8Od3TykW0XgEIscpPQ/cClMT1ViP
         9tUSyiZNkvQrA==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 1435d5b7;
        Wed, 13 Jul 2022 09:56:23 +0000 (UTC)
Date:   Wed, 13 Jul 2022 18:56:08 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Christian Schoenebeck <linux_oss@crudebyte.com>
Cc:     Latchesar Ionkov <lucho@ionkov.net>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net,
        Nikolay Kichukov <nikolay@oldum.net>
Subject: Re: [V9fs-developer] [PATCH v5 11/11] net/9p: allocate appropriate
 reduced message buffers
Message-ID: <Ys6WuOh2MaicETuw@codewreck.org>
References: <cover.1657636554.git.linux_oss@crudebyte.com>
 <Ys3jjg52EIyITPua@codewreck.org>
 <4284956.GYXQZuIPEp@silver>
 <1998718.eTOXZt5M9a@silver>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1998718.eTOXZt5M9a@silver>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christian Schoenebeck wrote on Wed, Jul 13, 2022 at 11:29:13AM +0200:
> > As this flag is going to be very RDMA-transport specific, I'm still
> > scratching my head for a good name though.
> 
> Or, instead of inventing some exotic flag name, maybe introducing an enum for 
> the individual 9p transport types?

That works for me as well

--
Dominique
