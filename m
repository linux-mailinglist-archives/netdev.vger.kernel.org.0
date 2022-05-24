Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB88532907
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 13:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236643AbiEXLa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 07:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231184AbiEXLaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 07:30:25 -0400
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCF6487A33
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 04:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=d993qO1M6uJRVL7vFommU2cm1CrcueVdWyz7bnjmjWQ=; b=ZWOhwa8dIWaLynxqpKMd9oYmxi
        2jUo9cDHxRlrLja8c52bchWZrBfxNFTdhzuP0bfE9NuuS5HMke69wr63zyHuHAv65BHYQZDCHh1a7
        mU0SAhzkRS9+GoUURFV1S9VWSfJb/A9OoZ21lawBhLza0rTh+OgL+Ztcth0J1CzoXuUgMmHB56j8J
        SYp6X1/TbZDp+WtMBT0HFRE7TKcJXBxfdaxi3mGd84PKyYpig7eb5YtSLzIQKwqLylLNZMZP21aHu
        GkxapMb7JrnZrIdH8gC8HmvufHtIbDpt+6jzwqdhjGWKpzullwRzOGpmv2MAXJdK6UGTRTbotnh6F
        4C/oi6LuGn1Yukt70ZZT0iMhnkM94+Y5Bj8L6XcUO3Jg/GNPiqgF4F4JjLsUioYVhPacDFYCApIt8
        V6AVAl5FgX4Zduu4sy57baB/730X55lNgCsK3Js4ii4wfccjGiJ+TtzAvbdH4V+aD2DM7wDq/1v6B
        q6Cgz8wVHv7jtOtgxfW959SsSoffALZu7h6eK1X0IiTqAR4Ulmfo+SNxIIZv2VjsVAk7UkYFrZiUY
        bdID9VhoQBMeYfniLtIHahsT7jVRoDwf2ld9S2uJ0HBuCptc4SCSFjv83k5GL+ozRC8nUEP+kwi7F
        tvNG3hahP/KRMOkd0cv9mMyG1msj80ppyQO3mBBK0=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     Dominique Martinet <asmadeus@codewreck.org>,
        Nikolay Kichukov <nikolay@oldum.net>
Cc:     v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Greg Kurz <groug@kaod.org>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v4 00/12] remove msize limit in virtio transport
Date:   Tue, 24 May 2022 13:29:18 +0200
Message-ID: <2799122.FyIdJ7nTd3@silver>
In-Reply-To: <2380b79f721caf9e6b99aa680b9b29c76fd4e2f4.camel@oldum.net>
References: <cover.1640870037.git.linux_oss@crudebyte.com>
 <Ye6IaIqQcwAKv0vb@codewreck.org>
 <2380b79f721caf9e6b99aa680b9b29c76fd4e2f4.camel@oldum.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Dienstag, 24. Mai 2022 10:10:31 CEST Nikolay Kichukov wrote:
> Hello Dominique,
> 
> On Mon, 2022-01-24 at 20:07 +0900, Dominique Martinet wrote:
> > Nikolay Kichukov wrote on Mon, Jan 24, 2022 at 11:21:08AM +0100:
> > > It works, sorry for overlooking the 'known limitations' in the first
> > > place. When do we expect these patches to be merged upstream?
> > 
> > We're just starting a new development cycle for 5.18 while 5.17 is
> > stabilizing, so this mostly depends on the ability to check if a msize
> > given in parameter is valid as described in the first "STILL TO DO"
> > point listed in the cover letter.
> > 
> > I personally would be happy considering this series for this cycle
> > with
> > just a max msize of 4MB-8k and leave that further bump for later if
> > we're sure qemu will handle it.
> > We're still seeing a boost for that and the smaller buffers for small
> > messages will benefit all transport types, so that would get in in
> > roughly two months for 5.18-rc1, then another two months for 5.18 to
> > actually be released and start hitting production code.
> > 
> > 
> > I'm not sure when exactly but I'll run some tests with it as well and
> > redo a proper code review within the next few weeks, so we can get
> > this
> > in -next for a little while before the merge window.
> 
> Did you make it into 5.18? I see it just got released...

No, not yet. I can send a v5 as outlined above, including opt-out for the RDMA 
transport as Dominique noted, that wouldn't be much work for me.

However ATM I fear it would probably not help anybody, as we currently have 
two far more serious issues [1] regarding 9p's cache support introduced by the 
netfs changes: 

1. 9p cache enabled performs now worse than without any cache.

2. There are misbehaviours once in a while, as 9p cache opens FIDs in read-
only mode and once in a while then tries to write with those read-only FIDs 
which causes EBADF errors.

[1] https://lore.kernel.org/lkml/9591612.lsmsJCMaJN@silver/

Issue (2.) can probably be fixed by just opening the FIDs in RW mode, as 
suggested by Dominique. But for performance issue (1.) nobody had an idea yet.

Best regards,
Christian Schoenebeck


