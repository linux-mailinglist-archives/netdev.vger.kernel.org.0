Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4ED95812D6
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 14:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238643AbiGZMKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 08:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238087AbiGZMKE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 08:10:04 -0400
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 624902BB3B;
        Tue, 26 Jul 2022 05:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=qE9E//dP4gc/xOOwIwhfrlODHz+ESpUGR+JNi63mXEM=; b=R/anHNFW+YvnZqTxmBZ4X5KCCE
        w9mmbiT/KxL/PY7AkmL+4J7yoizv4Edtk/DEZSvzHXQ6Xrw54Xo3PNT2HWey4a9NVXeBEgb3gCqI0
        bRBGX0oVZCNff5b18jAlCh1Ezapg+LK29rRdb+lF/kb8hnyqKrAoCHWlgCjWc4tYEPaU1zFC8PMis
        MIAlxr03QCdoWtVl20M8VgxXO7WvmzQVE+vuzAldSiXly3gHCWcebF+pNgGlQw+z+sxnHJkkFJ0Z4
        eXL6sbdmk7bdJJwttajxl0psl5eIbnG/87cwkkk3w0l4tPow6I0pveCpRIeHdYDtyO1+a1wKyt84J
        KB5E+7Clr61Bib8Hewb4+R83aUVT9y5ErXdGU4kmC4svF1WTM4+qQvwimac6jqdzN/SM+UAbwQe+0
        nVP8dXFUXIEHRGhxpAds7qb8YJHuwz4zkkP2/+YG6RdcMQhM9KZ6xTb1772rzaLhprYuzqaL9AsJH
        YY5y0bqnKpmcoRJdTfL+r19avlE6JYcgaSjm6/N21miUWAm1HOc1+ASELHezsUzeGcjj0arm0ba/p
        RwUBpPsHY1TLzfZvAyjGKCTt0EUEcJ6XCFLNFACSH1N9FxRiS0SKiSGxFaRr1cVr3M9A7pWuZWq8y
        emuOo1+DxmLee/4PjvDGXexXc4TQFG5YHLOVa1dP8=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     asmadeus@codewreck.org, Dmitry Vyukov <dvyukov@google.com>
Cc:     Vlastimil Babka <vbabka@suse.cz>,
        syzbot <syzbot+5e28cdb7ebd0f2389ca4@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, davem@davemloft.net,
        edumazet@google.com, elver@google.com, ericvh@gmail.com,
        hdanton@sina.com, k.kahurani@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, lucho@ionkov.net,
        netdev@vger.kernel.org, pabeni@redhat.com, rientjes@google.com,
        syzkaller-bugs@googlegroups.com, torvalds@linux-foundation.org,
        v9fs-developer@lists.sourceforge.net
Subject: Re: [syzbot] WARNING in p9_client_destroy
Date:   Tue, 26 Jul 2022 14:09:37 +0200
Message-ID: <2916828.W3qMjvkFlE@silver>
In-Reply-To: <CACT4Y+Yx2MZ9KEX9gfm-LahQE4KaXX=u4RQBuj-1gS57KL0OSw@mail.gmail.com>
References: <000000000000e6917605e48ce2bf@google.com> <Yt6DjrMdIhpQmm7V@codewreck.org>
 <CACT4Y+Yx2MZ9KEX9gfm-LahQE4KaXX=u4RQBuj-1gS57KL0OSw@mail.gmail.com>
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

On Montag, 25. Juli 2022 14:45:08 CEST Dmitry Vyukov wrote:
> On Mon, 25 Jul 2022 at 13:51, <asmadeus@codewreck.org> wrote:
> > Vlastimil Babka wrote on Mon, Jul 25, 2022 at 12:15:24PM +0200:
> > > On 7/24/22 15:17, syzbot wrote:
> > > > syzbot has bisected this issue to:
> > > > 
> > > > commit 7302e91f39a81a9c2efcf4bc5749d18128366945
> > > > Author: Marco Elver <elver@google.com>
> > > > Date:   Fri Jan 14 22:03:58 2022 +0000
> > > > 
> > > >     mm/slab_common: use WARN() if cache still has objects on destroy
> > > 
> > > Just to state the obvious, bisection pointed to a commit that added the
> > > warning, but the reason for the warning would be that p9 is destroying a
> > > kmem_cache without freeing all the objects there first, and that would
> > > be
> > > true even before the commit.
> > 
> > Probably true from the moment that cache/idr was introduced... I've got
> > a couple of fixes in next but given syzcaller claims that's the tree it
> > was produced on I guess there can be more such leaks.
> > (well, the lines it sent in the backtrace yesterday don't match next,
> > but I wouldn't count on it)
> > 
> > If someone wants to have a look please feel free, I would bet the
> > problem is just that p9_fd_close() doesn't call or does something
> > equivalent to p9_conn_cancel() and there just are some requests that
> > haven't been sent yet when the mount is closed..
> > But I don't have/can/want to take the time to check right now as I
> > consider such a leak harmless enough, someone has to be root or
> > equivalent to do 9p mounts in most cases.
> 
> FWIW with KASAN we have allocation stacks for each heap object. So
> when KASAN is enabled that warning could list all live object
> allocation stacks.

With allocation stack you mean the backtrace/call stack at the point in time 
when the memory originally was acquired?

If the answer is yes, then sure, if someone had a chance to post those 
backtraces, then that would help us to take a closer look at where this leak 
might happen. Otherwise I fear it will end up among those other "lack of 
priority" issues.

Best regards,
Christian Schoenebeck


