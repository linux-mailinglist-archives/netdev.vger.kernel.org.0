Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6D554B333
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 16:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbiFNO3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 10:29:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349328AbiFNO2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 10:28:24 -0400
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D3AF34BBE;
        Tue, 14 Jun 2022 07:28:22 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 99921C009; Tue, 14 Jun 2022 16:28:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1655216900; bh=yAoaM3WVMZZxJ+LV3cWyu5SL2IaFaK4FrSuNs/YyNhQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Fe26ntZMxrht4o7gA1fYpW51vtB2R+rnoapoPPwL38kNO4flg2zegOLVRaZCPncjp
         R+1hKVow633DVXnW2rqqRk5wKLslIrGjXpPDWCNB2VwwyZrwxzrhpXHUnS/rV7r44O
         tHUDUX+oVCSGSkEPbcRTXS/hKhGJLbNkSHuTym1UUXXwiwdaYk7DVrcAcOFuUhzqbl
         B+h9PPWJ+RljxRRXmTvhX3f6sxwgrIEPQD/b/rnzi4Gjm2Ly6zuvw9YaE+ZjVW31i0
         TGJx0NTeswofPTruqC6D9+kvhN33QzRIYdmi2riPikVigkQ7Ae/qliOYJ7952R7GYz
         I5KF96AdkBKCQ==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 50271C009;
        Tue, 14 Jun 2022 16:28:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1655216899; bh=yAoaM3WVMZZxJ+LV3cWyu5SL2IaFaK4FrSuNs/YyNhQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=4DP1tVmKf3k7VrOCUmSKlygxvN8WdSF+OPArFv5SIbtqUq8qT8OS/78jU+cc1PKLo
         4p7cmLbE+0Ewwb2jmiLTA98Mh+4EeIMdvhrp2e+kKwcBTTSS8Ndi6ayIspJV/sRHVc
         hI4LE+jPn9hYngfnkmohMMNku0G9LfpeMe0y62bAiaFZcHg54LUPV1v7alG8wZe60p
         r5wcJKnrUi+V8QMdX6RTn9mggIbTIIjwDydMsJoHPdNIJIbBleobXuSXh67OO9ULC8
         cQK49TUYg5vcmELBWRK3GzvVzmdYjpkpsvvqKyGabd97GLYviNOhMXCFz3TahHt8me
         METx1cr+9RrmQ==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 76306788;
        Tue, 14 Jun 2022 14:28:12 +0000 (UTC)
Date:   Tue, 14 Jun 2022 23:27:57 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Christian Schoenebeck <linux_oss@crudebyte.com>
Cc:     Tyler Hicks <tyhicks@linux.microsoft.com>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 04/06] 9p fid refcount: add p9_fid_get/put wrappers
Message-ID: <Yqia7Xr9WAgtZ6zr@codewreck.org>
References: <20220612085330.1451496-5-asmadeus@codewreck.org>
 <20220612234557.1559736-1-asmadeus@codewreck.org>
 <7044959.MN0D2SvuAq@silver>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7044959.MN0D2SvuAq@silver>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Thanks for the reviews :)

Christian Schoenebeck wrote on Tue, Jun 14, 2022 at 03:55:39PM +0200:
> On Montag, 13. Juni 2022 01:45:54 CEST Dominique Martinet wrote:
> > I was recently reminded that it is not clear that p9_client_clunk()
> > was actually just decrementing refcount and clunking only when that
> > reaches zero: make it clear through a set of helpers.
> > 
> > This will also allow instrumenting refcounting better for debugging
> > next patch, which is the reason these are not defined as static inline:
> > we won't be able to add trace events there...
> 
> Looks like you forgot to adjust the commit log sentence here, ...
> 
> > Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
> > ---
> > v1 -> v2: p9_fid_get/put are now static inline in .h
> 
> ... as the two functions are in fact static inlined in this v2 now.

Good point, will fix!


> > diff --git a/include/net/9p/client.h b/include/net/9p/client.h
> > index ec1d1706f43c..9fd38d674057 100644
> > --- a/include/net/9p/client.h
> > +++ b/include/net/9p/client.h
> > @@ -237,6 +237,24 @@ static inline int p9_req_try_get(struct p9_req_t *r)
> > 
> >  int p9_req_put(struct p9_req_t *r);
> > 
> > +static inline struct p9_fid *p9_fid_get(struct p9_fid *fid)
> > +{
> 
> Isn't this missing a check here?
> 
>     if (!fid)
>         return NULL;

It doesn't really make sense to get a null or error fid: whatever wants
to take a ref will error out first, so this didn't get a check unlike
put, which is nice to use without `if (fid && !IS_ERR(fid)) put(fid)`
all the time.


> 
> > +	refcount_inc(&fid->count);
> > +
> > +	return fid;
> > +}
> > +
> > +static inline int p9_fid_put(struct p9_fid *fid)
> > +{
> > +	if (!fid || IS_ERR(fid))
> > +		return 0;
> > +
> > +	if (!refcount_dec_and_test(&fid->count))
> > +		return 0;
> > +
> > +	return p9_client_clunk(fid);
> > +}
> > +
> 
> I don't know the common symbol name patterns in the Linux kernel for acquiring
> and releasing counted references are (if there is a common one at all), but I
> think those two functions deserve a short API comment to make it clear they
> belong together, i.e. that a p9_fid_get() call should be paired with
> subsequent p9_fid_put(). It's maybe just nitpicking, as the code is quite
> short and probably already speaks for itself.

I guess "but none of the other 50 functions do!" isn't a good reason not
to start, but it sure was enough to make me think it'd be silly to
document p9_fid_get/put right next to p9_req_get/put that don't have
their comment...
Better late than never though, I'll add something in v3.

As for common names you can see get/put in various places (kref_get/put,
of_node_get/put, pm_runime*_get/put) so I guess it's common enough.

> On the long-term I could imagine using automated, destructor based
> p9_fid_put() calls when leaving a block/function scope. That would simplify
> code a load and avoid leaks in future.

__attribute__(__cleanup__()) is nice but I've not seen any in linux
(looking again kcsan and locking selftests seem to be using it, I didn't
think it was allowed)...
Just making it clear goes a long way though, my last patch is a good
first step (inconditionally put'ing all fids at the end of functions and
NULLing fid pointers when stashing it in inode is pretty much what we'd
be doing if there were destructors), but I feel it's still not clear
which functions give a new ref or not cf. walk that can reuse the same
fid depending on its parameters.

I think making that clear would be a good next step for cleanup next
time there are problems and/or someone has time for it...
(But there are plenty of interesting things to check first, like the
performance regression with recent fscache perhaps...)

-- 
Dominique
