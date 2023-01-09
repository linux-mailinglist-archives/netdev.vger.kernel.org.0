Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 463226630FA
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 21:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237378AbjAIUKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 15:10:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237271AbjAIUKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 15:10:36 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF281142
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 12:10:33 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 1923740199;
        Mon,  9 Jan 2023 20:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1673295032; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hfw0moAkv9QqXHtmvz5TDv45LztWhjPhdLj354lDRxc=;
        b=wJzx1FOK1Kiuuzpde+KCadSvKk3fwS53BZ1/rJXbiVY1CPmquzvU6SVSet6CXcNuVhAu9H
        QXp1fXwgjYaMuDB3xKyn84MgmIlbj2GnFYl3jDnCsAl56NU+ZgP0cPWbdOU1aEU9IqCRxD
        4w0BBXB8c9itcEVCR6nBg6u/sstLSkY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1673295032;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hfw0moAkv9QqXHtmvz5TDv45LztWhjPhdLj354lDRxc=;
        b=cHDD20+q/U8E7dP8Zxf4HQaYdzsSkPYdD1C9mBY3PPRarGY2W6CfZ5ruKW2koZqVgJtIfM
        AJShIqPKNlNnDoAQ==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id EF6D22C141;
        Mon,  9 Jan 2023 20:10:31 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 8F42D6052E; Mon,  9 Jan 2023 21:10:29 +0100 (CET)
Date:   Mon, 9 Jan 2023 21:10:29 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     "Mogilappagari, Sudheer" <sudheer.mogilappagari@intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH ethtool-next v4 2/2] netlink: add netlink handler for get
 rss (-x)
Message-ID: <20230109201029.4nkwzixlhq2v5rzt@lion.mk-sys.cz>
References: <20221229011243.1527945-1-sudheer.mogilappagari@intel.com>
 <20221229011243.1527945-3-sudheer.mogilappagari@intel.com>
 <20230102163326.4b982650@kernel.org>
 <IA1PR11MB62668007BA5BA017F5B46708E4FB9@IA1PR11MB6266.namprd11.prod.outlook.com>
 <20230106134133.75f76043@kernel.org>
 <IA1PR11MB62667E12E921F5D2D56637DBE4FE9@IA1PR11MB6266.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <IA1PR11MB62667E12E921F5D2D56637DBE4FE9@IA1PR11MB6266.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 09, 2023 at 06:07:45PM +0000, Mogilappagari, Sudheer wrote:
> > -----Original Message-----
> > From: Jakub Kicinski <kuba@kernel.org>
> > Sent: Friday, January 6, 2023 1:42 PM
> > To: Mogilappagari, Sudheer <sudheer.mogilappagari@intel.com>
> > Cc: netdev@vger.kernel.org; mkubecek@suse.cz; andrew@lunn.ch;
> > Samudrala, Sridhar <sridhar.samudrala@intel.com>; Nguyen, Anthony L
> > <anthony.l.nguyen@intel.com>
> > Subject: Re: [PATCH ethtool-next v4 2/2] netlink: add netlink handler
> > for get rss (-x)
[...]
> > No no, look how the strings for hfunc names are fetched - they are
> > fetched over a different socket, right?
> 
> global_stringset is using nlctx->ethnl2_socket. Are you suggesting use
> of it for fetching channels info too ? 
> 
> ret = netlink_init_ethnl2_socket(nlctx);
> ...
> hash_funcs = global_stringset(ETH_SS_RSS_HASH_FUNCS, nlctx->ethnl2_socket);

The purpose of the second socket is to allow sending another request
while we are still processing the data from the main request so that we
cannot reuse the primary socket.

In this case, if we do not support dumps (and do not intend to), we
could technically send both request through the same socket (one after
the other) but I think it would be easier to use ethnl2_socket for the
auxiliary request anyway.

Michal
