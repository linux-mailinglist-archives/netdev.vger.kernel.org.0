Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9DF46223EB
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 07:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbiKIGUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 01:20:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiKIGUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 01:20:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFF82192AC;
        Tue,  8 Nov 2022 22:20:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93FD7617B5;
        Wed,  9 Nov 2022 06:20:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50948C433C1;
        Wed,  9 Nov 2022 06:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667974845;
        bh=dKFpnds2QZnHEuUszSzqFnzr+lmRVa3tqB84C8bjztQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EAmUGUkv+/N41kLRHevX9LCZBxMfalbTkh6rUgrEIYh+n1CW3AXx6SbxZueKNxvy6
         7COuOy1ayvGhVyPtH9D2Sx2XtqeipsgN42Mz7F58eZcQ7ne5JM759ff8k0iE+pw049
         hzwcEl0sUrPXxLVie1oLi2e2DgcEOANk7DKNzHC4fNj1Eafn2kC0467u3K3knoTUZv
         hvbhf/u1T2PSJLSgMMVSpwexyCF0wtp/5s2ZhNjeSZ+Mfkg9jCcFjZcEtVTAHAoQrn
         YSBXYlHohAp2EQjhmmZzk8u1cPzjecWbMlUKtaqhtgsCW6EfmQESg1rMiZ4IvCT58h
         851KNro5pvbtg==
Date:   Wed, 9 Nov 2022 08:20:42 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Long Li <longli@microsoft.com>
Cc:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        Ajay Sharma <sharmaajay@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [Patch v10 01/12] net: mana: Add support for auxiliary device
Message-ID: <Y2tGukmMbtOq1CWy@unreal>
References: <1667502990-2559-1-git-send-email-longli@linuxonhyperv.com>
 <1667502990-2559-2-git-send-email-longli@linuxonhyperv.com>
 <Y2qrd/BbrZUokitA@unreal>
 <PH7PR21MB3263700CCC9EC16FF7EA937BCE3F9@PH7PR21MB3263.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH7PR21MB3263700CCC9EC16FF7EA937BCE3F9@PH7PR21MB3263.namprd21.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 08, 2022 at 09:33:21PM +0000, Long Li wrote:
> 
> > > int mana_probe(struct gdma_dev *gd, bool resuming)
> > >  				break;
> > >  		}
> > >  	}
> > > +
> > > +	err = add_adev(gd);
> > >  out:
> > >  	if (err)
> > >  		mana_remove(gd, false);
> > > @@ -2189,6 +2267,10 @@ void mana_remove(struct gdma_dev *gd, bool
> > suspending)
> > >  	int err;
> > >  	int i;
> > >
> > > +	/* adev currently doesn't support suspending, always remove it */
> > > +	if (gd->adev)
> > 
> > This condition is always true, isn't it?
> 
> I think the check is necessary. mana_probe() will call mana_remove() if it fails to
> add this adev to gd. If this is the case, we can't call remove_adev().

I'm sad to hear that. It is so anti-pattern to hide error unwind in one global function.
But ok, it is already there, so let's take this series as is.

Thanks

> 
> Thanks,
> Long
