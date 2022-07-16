Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8FB576D37
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 11:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232157AbiGPJyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 05:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiGPJyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 05:54:39 -0400
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C60BE00C;
        Sat, 16 Jul 2022 02:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=GA5oE+W/bwGhbahSm4RvG4PVxOwv8L+ex/kt0Pn3hT8=; b=fFO9l0uw/uTwB+tqGvHipuxlqN
        GSIUkkssehpqjJ/e4noi4vPnshdggGeYB94HH1A64Q+qtb0yUCTCOjBudKJFLwvuVFDSwSoXEZmOu
        ysHnupcxGDDa+16pcqSG1qHRRS7bcPseISLSQSQqbFO9Cfu1Uiz3ovzWjJ6q78lO13g6MQJZTbeXd
        xtXuD5yjhL8AVRj058exssU1+5NcPQ+qgMG/BbJdRDayDwmtY9hZX6hmDtRUw74F1zveaY+7nf101
        ywyXoqNf25DzYzdumwCHsLllGUMJf/nkKadvDtEBewG3YWKRNBUdfHaMekt2225vKDG6oz4kUFQ49
        Ubg4DhIjCIkBqiWUcd3WOo/LwOT13RWashEuya7duNyq2H3782SzsSUirVCGs8N2VegUwC/dv3Yb4
        kZghelwxYzT8UGsqOLq40HnTRAfRNdJe9jBXrANOYuPHSwJqzdJcQ0nQ3T2XREHitTCSRpge0MUIJ
        6n/esUfiBxASqmaZWEgcvehOg7sYx8Hfpkr1rmnABLdaLQwX1Q3X0s4BoO5l0b5siIrjaD7qh73DZ
        KP2YEfv/T55GfRCuZDDEuX6FifI69/AZqK0LiE7q2AfeIdkIutaGY06mxfrbCdWfS3/GcoSl3JI9y
        z9sk5rIzJfdcxyvf2EuBRxz8+bUfX/N3H4wagTk4A=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Nikolay Kichukov <nikolay@oldum.net>
Subject: Re: [PATCH v6 00/11] remove msize limit in virtio transport
Date:   Sat, 16 Jul 2022 11:54:29 +0200
Message-ID: <6713865.4mp09fW1HV@silver>
In-Reply-To: <YtH4M9GvVdAsSCz2@codewreck.org>
References: <cover.1657920926.git.linux_oss@crudebyte.com>
 <YtHqlVx9/joj+AXH@codewreck.org> <YtH4M9GvVdAsSCz2@codewreck.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Samstag, 16. Juli 2022 01:28:51 CEST Dominique Martinet wrote:
> Dominique Martinet wrote on Sat, Jul 16, 2022 at 07:30:45AM +0900:
> > Christian Schoenebeck wrote on Fri, Jul 15, 2022 at 11:35:26PM +0200:
> > > * Patches 7..11 tremendously reduce unnecessarily huge 9p message sizes
> > > and
> > > 
> > >   therefore provide performance gain as well. So far, almost all 9p
> > >   messages
> > >   simply allocated message buffers exactly msize large, even for
> > >   messages
> > >   that actually just needed few bytes. So these patches make sense by
> > >   themselves, independent of this overall series, however for this
> > >   series
> > >   even more, because the larger msize, the more this issue would have
> > >   hurt
> > >   otherwise.
> > 
> > Unless they got stuck somewhere the mails are missing patches 10 and 11,
> > one too many 0s to git send-email ?
> 
> nevermind, they just got in after 1h30... I thought it'd been 1h since
> the first mails because the first ones were already 50 mins late and I
> hadn't noticed! I wonder where they're stuck, that's the time
> lizzy.crudebyte.com received them and it filters earlier headers so
> probably between you and it?

Certainly an outbound SMTP greylisting delay, i.e. lack of karma. Sometimes my 
patches make it to lists after 3 hours. I haven't figured out though why some 
patches within the same series arrive significantly faster than certain other 
ones, which is especially weird when that happens not in order they were sent.

> ohwell.
> 
> > I'll do a quick review from github commit meanwhile
> 
> Looks good to me, I'll try to get some tcp/rdma testing done this
> weekend and stash them up to next

Great, thanks!

> --
> Dominique




