Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8665731AE
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 10:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235772AbiGMI5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 04:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235804AbiGMI47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 04:56:59 -0400
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC240EA149;
        Wed, 13 Jul 2022 01:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=Nu1POy7YkuNyZuJHgCV5LHCqiHV9ZZ729P8AmcVEC4E=; b=muDkd3U1IcxZQCX+U/CQIBkpxt
        ZU+gG6hyVSQXeQI8qgawE6oaFo3/0+Yf09PRRHlTBuTr3WDJrpc41F1R3S5fsfpl3CUyBW+mtKdur
        f8BqCWCkPs5vWnF1ffZ+zv/iCehxrjyyGk5SbzQD/J1BgTRXVwb8QsuIK09DO9qM+K1wrmlY/8TJr
        mo9Pb/LKje7h2TpmjXXJhPdRd10jf6xB7KxTqe2TL0wDvDwfzXX+aKHNMkiXQevS2C9vLRHMl/X5U
        RufnnNoz2I/kVQtw3aYlQeHmKWbBm8DypgMi3WvHN9A5cQqnhjEB26ekFuramQJadpXZdAFwkjQRR
        Y2yRtupuX2IN3yDJgk4iwZ8Kmk9PlbBFaqBI+sVFazLWGBYVyBo9GXdA9E6vCkzgCLK7/6xqM3hsF
        jRKP8EAt2QwXVjcaqdxmujWBvdCQ/XG63ZQ1U2DYzx+NkpCV830tKiwC48Uq0+w/G/rA/XsbQiw+q
        cdtKFjRalgmH2DqPo4lUGFBAcP8m69KAZR2NNwm3Jd4nQHLhrSEjkB+S2L7rC+EOCqTWAr7FprKQb
        4RHcmhGXOyYGtKNcmC9DbJ7n2gnTjFdy4pN9uE4xUyhi2GmeRC5QrJyNSdS0uupIArgXayiRGvuUj
        bEdoQt08cq7VRGsTM19JZemXVMpmvxnFiup4glWLE=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Nikolay Kichukov <nikolay@oldum.net>
Subject: Re: [PATCH v5 00/11] remove msize limit in virtio transport
Date:   Wed, 13 Jul 2022 10:54:47 +0200
Message-ID: <7468612.NupLhYsxyy@silver>
In-Reply-To: <Ys3j7KucZGdFkttA@codewreck.org>
References: <cover.1657636554.git.linux_oss@crudebyte.com>
 <Ys3j7KucZGdFkttA@codewreck.org>
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

On Dienstag, 12. Juli 2022 23:13:16 CEST Dominique Martinet wrote:
> Alright; anything I didn't reply to looks good to me.
> 
> Christian Schoenebeck wrote on Tue, Jul 12, 2022 at 04:35:54PM +0200:
> > OVERVIEW OF PATCHES:
> > 
> > * Patches 1..6 remove the msize limitation from the 'virtio' transport
> > 
> >   (i.e. the 9p 'virtio' transport itself actually supports >4MB now,
> >   tested
> >   successfully with an experimental QEMU version and some dirty 9p Linux
> >   client hacks up to msize=128MB).
> 
> I have no problem with this except for the small nitpicks I gave, but
> would be tempted to delay this part for one more cycle as it's really
> independant -- what do you think?

Yes, I would also postpone the virtio patches towards subsequent release 
cycle.

> > * Patch 7 limits msize for all transports to 4 MB for now as >4MB would
> > need> 
> >   more work on 9p client level (see commit log of patch 7 for details).
> > 
> > * Patches 8..11 tremendously reduce unnecessarily huge 9p message sizes
> > and
> > 
> >   therefore provide performance gain as well. So far, almost all 9p
> >   messages
> >   simply allocated message buffers exactly msize large, even for messages
> >   that actually just needed few bytes. So these patches make sense by
> >   themselves, independent of this overall series, however for this series
> >   even more, because the larger msize, the more this issue would have hurt
> >   otherwise.
> 
> time-wise we're getting close to the merge window already (probably in 2
> weeks), how confident are you in this?
> I can take patches 8..11 in -next now and probably find some time to
> test over next weekend, are we good?

Well, I have tested them thoroughly, but nevertheless IMO someone else than me 
should review patch 10 as well, and review whether the calculations for the 
individual message types are correct. That's a bit of spec dictionary lookup.

Best regards,
Christian Schoenebeck


