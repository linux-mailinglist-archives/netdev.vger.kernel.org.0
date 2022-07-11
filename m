Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EBB45700F6
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 13:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbiGKLns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 07:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbiGKLnI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 07:43:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E716AF59
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 04:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657539551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LOA7kEZ3folD818e0Y8AmWFf5bCD69ISD0WD8TsPgww=;
        b=hzRVbhcYpR/czCwydP2qOW4Usz2YFFY5+Ru9ipejkOLgipb4RV9n5aBpQXLEzdsgViw6nV
        yaq2q84hOFy1WNPka8YSVOsnifTDCEbOA1nO7WtVScCjK/L6h7D0Ju4CCuEHD8IcFjjRtp
        0UptcYqCoNDCRlSYb0wI8CX6r4iTSW8=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-79-kwV6tv5TOBCWpHMI1dBTwA-1; Mon, 11 Jul 2022 07:39:09 -0400
X-MC-Unique: kwV6tv5TOBCWpHMI1dBTwA-1
Received: by mail-qk1-f197.google.com with SMTP id k9-20020a05620a414900b006b58d6a89f2so1567661qko.2
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 04:39:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:content-transfer-encoding:user-agent:mime-version;
        bh=LOA7kEZ3folD818e0Y8AmWFf5bCD69ISD0WD8TsPgww=;
        b=kii05Xes1TZ9+zKWV3f7Yw3scuJD380+lujsuGYkhBEPZuSuROWwlj/C3rg18/8HNb
         AZx3zRn2Sjca7nlTQ9O/bEgF2RM7TwobALS8wQqL5JdycV0YXYBMQT3KsyndXgIZSYrn
         eviX0ymAT+c6/iGIG82/bY5iQONkX4OBnO0kxSA0Ha/S07QXJO9gl5+GvXpCeSJlDgRJ
         rfGPxsVnlPnEBAM1iyKhvdRhLFcEwA2axJ3WgMyYMGTLVX5KhzWkld+QWVbiwbMjO+11
         lQl9JJEidoOk6ehrS9Lvpg1HPA9buWgS1pXTk9XxEzXbk9gSTZbbSatFPgGmVvDtfI04
         PRyA==
X-Gm-Message-State: AJIora9sciBJgv4AQFwUYEGeNw7osT+9ZT8zJfp5PRqb0rgctVlhYukH
        iwDPSXhVFHWt2aaDAKb3azcuRTNwM3NcuIMapIEZ/an49R558ujlfOl0K6R/zn70YpCFBIa1twG
        xxTSYVfe8/zO2qWZL
X-Received: by 2002:a37:444c:0:b0:6b5:5bd1:6668 with SMTP id r73-20020a37444c000000b006b55bd16668mr10822262qka.596.1657539549397;
        Mon, 11 Jul 2022 04:39:09 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1srpD9v/iWY1V6DTlk4G8DeqEvbH2l7jysSJGUeT90q1+ypWm86fqZZUNSR6RgKvE7AbiVLug==
X-Received: by 2002:a37:444c:0:b0:6b5:5bd1:6668 with SMTP id r73-20020a37444c000000b006b55bd16668mr10822255qka.596.1657539549124;
        Mon, 11 Jul 2022 04:39:09 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id u36-20020a05622a19a400b003196e8eda26sm5107343qtc.69.2022.07.11.04.39.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 04:39:08 -0700 (PDT)
Message-ID: <33688832c658a15d35af6321030f8ebd98cfea8a.camel@redhat.com>
Subject: Re: [PATCH v3 15/32] NFSD: Leave open files out of the filecache LRU
From:   Jeff Layton <jlayton@redhat.com>
To:     Chuck Lever III <chuck.lever@oracle.com>
Cc:     Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "tgraf@suug.ch" <tgraf@suug.ch>
Date:   Mon, 11 Jul 2022 07:39:07 -0400
In-Reply-To: <BC4E1A0C-1404-4C50-ADD0-3999DEE01066@oracle.com>
References: <165730437087.28142.6731645688073512500.stgit@klimt.1015granger.net>
         <165730471781.28142.13547044100953437563.stgit@klimt.1015granger.net>
         <2af895fcbdaeab04773cbce275ca7a6d59b879cf.camel@redhat.com>
         <BC4E1A0C-1404-4C50-ADD0-3999DEE01066@oracle.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2022-07-09 at 20:45 +0000, Chuck Lever III wrote:
>=20
> > On Jul 8, 2022, at 3:29 PM, Jeff Layton <jlayton@redhat.com> wrote:
> >=20
> > On Fri, 2022-07-08 at 14:25 -0400, Chuck Lever wrote:
> > > There have been reports of problems when running fstests generic/531
> > > against Linux NFS servers with NFSv4. The NFS server that hosts the
> > > test's SCRATCH_DEV suffers from CPU soft lock-ups during the test.
> > > Analysis shows that:
> > >=20
> > > fs/nfsd/filecache.c
> > > 482 ret =3D list_lru_walk(&nfsd_file_lru,
> > > 483 nfsd_file_lru_cb,
> > > 484 &head, LONG_MAX);
> > >=20
> > > causes nfsd_file_gc() to walk the entire length of the filecache LRU
> > > list every time it is called (which is quite frequently). The walk
> > > holds a spinlock the entire time that prevents other nfsd threads
> > > from accessing the filecache.
> > >=20
> > > What's more, for NFSv4 workloads, none of the items that are visited
> > > during this walk may be evicted, since they are all files that are
> > > held OPEN by NFS clients.
> > >=20
> > > Address this by ensuring that open files are not kept on the LRU
> > > list.
> > >=20
> > > Reported-by: Frank van der Linden <fllinden@amazon.com>
> > > Reported-by: Wang Yugui <wangyugui@e16-tech.com>
> > > Link: https://bugzilla.linux-nfs.org/show_bug.cgi?id=3D386
> > > Suggested-by: Trond Myklebust <trond.myklebust@hammerspace.com>
> > > Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> > > ---
> > > fs/nfsd/filecache.c | 24 +++++++++++++++++++-----
> > > fs/nfsd/trace.h | 2 ++
> > > 2 files changed, 21 insertions(+), 5 deletions(-)
> > >=20
> > > diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
> > > index 37373b012276..6e9e186334ab 100644
> > > --- a/fs/nfsd/filecache.c
> > > +++ b/fs/nfsd/filecache.c
> > > @@ -269,6 +269,7 @@ nfsd_file_flush(struct nfsd_file *nf)
> > >=20
> > > static void nfsd_file_lru_add(struct nfsd_file *nf)
> > > {
> > > +	set_bit(NFSD_FILE_REFERENCED, &nf->nf_flags);
> > > 	if (list_lru_add(&nfsd_file_lru, &nf->nf_lru))
> > > 		trace_nfsd_file_lru_add(nf);
> > > }
> > > @@ -298,7 +299,6 @@ nfsd_file_unhash(struct nfsd_file *nf)
> > > {
> > > 	if (test_and_clear_bit(NFSD_FILE_HASHED, &nf->nf_flags)) {
> > > 		nfsd_file_do_unhash(nf);
> > > -		nfsd_file_lru_remove(nf);
> > > 		return true;
> > > 	}
> > > 	return false;
> > > @@ -319,6 +319,7 @@ nfsd_file_unhash_and_release_locked(struct nfsd_f=
ile *nf, struct list_head *disp
> > > 	if (refcount_dec_not_one(&nf->nf_ref))
> > > 		return true;
> > >=20
> > > +	nfsd_file_lru_remove(nf);
> > > 	list_add(&nf->nf_lru, dispose);
> > > 	return true;
> > > }
> > > @@ -330,6 +331,7 @@ nfsd_file_put_noref(struct nfsd_file *nf)
> > >=20
> > > 	if (refcount_dec_and_test(&nf->nf_ref)) {
> > > 		WARN_ON(test_bit(NFSD_FILE_HASHED, &nf->nf_flags));
> > > +		nfsd_file_lru_remove(nf);
> > > 		nfsd_file_free(nf);
> > > 	}
> > > }
> > > @@ -339,7 +341,7 @@ nfsd_file_put(struct nfsd_file *nf)
> > > {
> > > 	might_sleep();
> > >=20
> > > -	set_bit(NFSD_FILE_REFERENCED, &nf->nf_flags);
> > > +	nfsd_file_lru_add(nf);
> >=20
> > Do you really want to add this on every put? I would have thought you'd
> > only want to do this on a 2->1 nf_ref transition.
>=20
> My measurements indicate that 2->1 is the common case, so checking
> that this is /not/ a 2->1 transition doesn't confer much if any
> benefit.
>=20
> Under load, I don't see any contention on the LRU locks, which is
> where I'd expect to see a problem if this design were not efficient.
>=20
>=20

Fair enough. I guess the idea is to throw it onto the LRU and the
scanner will just (eventually) take it off again without reaping it.

You can add my Reviewed-by: to this one as well.


> > > 	if (test_bit(NFSD_FILE_HASHED, &nf->nf_flags) =3D=3D 0) {
> > > 		nfsd_file_flush(nf);
> > > 		nfsd_file_put_noref(nf);
> > > @@ -439,8 +441,18 @@ nfsd_file_dispose_list_delayed(struct list_head =
*dispose)
> > > 	}
> > > }
> > >=20
> > > -/*
> > > +/**
> > > + * nfsd_file_lru_cb - Examine an entry on the LRU list
> > > + * @item: LRU entry to examine
> > > + * @lru: controlling LRU
> > > + * @lock: LRU list lock (unused)
> > > + * @arg: dispose list
> > > + *
> > > * Note this can deadlock with nfsd_file_cache_purge.
> > > + *
> > > + * Return values:
> > > + * %LRU_REMOVED: @item was removed from the LRU
> > > + * %LRU_SKIP: @item cannot be evicted
> > > */
> > > static enum lru_status
> > > nfsd_file_lru_cb(struct list_head *item, struct list_lru_one *lru,
> > > @@ -462,8 +474,9 @@ nfsd_file_lru_cb(struct list_head *item, struct l=
ist_lru_one *lru,
> > > 	 * That order is deliberate to ensure that we can do this locklessly=
.
> > > 	 */
> > > 	if (refcount_read(&nf->nf_ref) > 1) {
> > > +		list_lru_isolate(lru, &nf->nf_lru);
> > > 		trace_nfsd_file_gc_in_use(nf);
> > > -		return LRU_SKIP;
> > > +		return LRU_REMOVED;
> >=20
> > Interesting. So you wait until the LRU scanner runs to remove these
> > entries? I expected to see you do this in nfsd_file_get, but this does
> > seem likely to be more efficient.
> >=20
> > > 	}
> > >=20
> > > 	/*
> > > @@ -1020,6 +1033,7 @@ nfsd_do_file_acquire(struct svc_rqst *rqstp, st=
ruct svc_fh *fhp,
> > > 		goto retry;
> > > 	}
> > >=20
> > > +	nfsd_file_lru_remove(nf);
> > > 	this_cpu_inc(nfsd_file_cache_hits);
> > >=20
> > > 	if (!(may_flags & NFSD_MAY_NOT_BREAK_LEASE)) {
> > > @@ -1055,7 +1069,6 @@ nfsd_do_file_acquire(struct svc_rqst *rqstp, st=
ruct svc_fh *fhp,
> > > 	refcount_inc(&nf->nf_ref);
> > > 	__set_bit(NFSD_FILE_HASHED, &nf->nf_flags);
> > > 	__set_bit(NFSD_FILE_PENDING, &nf->nf_flags);
> > > -	nfsd_file_lru_add(nf);
> > > 	hlist_add_head_rcu(&nf->nf_node, &nfsd_file_hashtbl[hashval].nfb_hea=
d);
> > > 	++nfsd_file_hashtbl[hashval].nfb_count;
> > > 	nfsd_file_hashtbl[hashval].nfb_maxcount =3D max(nfsd_file_hashtbl[ha=
shval].nfb_maxcount,
> > > @@ -1080,6 +1093,7 @@ nfsd_do_file_acquire(struct svc_rqst *rqstp, st=
ruct svc_fh *fhp,
> > > 	 */
> > > 	if (status !=3D nfs_ok || inode->i_nlink =3D=3D 0) {
> > > 		bool do_free;
> > > +		nfsd_file_lru_remove(nf);
> > > 		spin_lock(&nfsd_file_hashtbl[hashval].nfb_lock);
> > > 		do_free =3D nfsd_file_unhash(nf);
> > > 		spin_unlock(&nfsd_file_hashtbl[hashval].nfb_lock);
> > > diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
> > > index 1cc1133371eb..54082b868b72 100644
> > > --- a/fs/nfsd/trace.h
> > > +++ b/fs/nfsd/trace.h
> > > @@ -929,7 +929,9 @@ DEFINE_EVENT(nfsd_file_gc_class, name,					\
> > > 	TP_ARGS(nf))
> > >=20
> > > DEFINE_NFSD_FILE_GC_EVENT(nfsd_file_lru_add);
> > > +DEFINE_NFSD_FILE_GC_EVENT(nfsd_file_lru_add_disposed);
> > > DEFINE_NFSD_FILE_GC_EVENT(nfsd_file_lru_del);
> > > +DEFINE_NFSD_FILE_GC_EVENT(nfsd_file_lru_del_disposed);
> > > DEFINE_NFSD_FILE_GC_EVENT(nfsd_file_gc_in_use);
> > > DEFINE_NFSD_FILE_GC_EVENT(nfsd_file_gc_writeback);
> > > DEFINE_NFSD_FILE_GC_EVENT(nfsd_file_gc_referenced);
> > >=20
> > >=20
> >=20
> > --=20
> > Jeff Layton <jlayton@redhat.com>
>=20
> --
> Chuck Lever
>=20
>=20
>=20

--=20
Jeff Layton <jlayton@redhat.com>

