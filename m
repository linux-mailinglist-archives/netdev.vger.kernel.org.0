Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 364F556C258
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 01:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239902AbiGHTnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 15:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238532AbiGHTnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 15:43:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2358813FAD
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 12:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657309423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZRvcEyBikV1fuKkjf8/FIQL8bf6qUSsx6qqnqqq9IP8=;
        b=BZ76FwgT7zY9ZWe4aXXl59B2dP02wMrwMef6JpOcroybEIFxCwTyjFRsPXOqF7KGx58ROu
        AreYzxrbYM7wXxuaN69WX0iryg8OLnR8MSNWoXqkPMnQZPkOSX8mihqlLhlap37mCPfcyW
        dEm9PMXmP1HwMxzaamhaeqwmqCPsXZg=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-374-GtggaDQnPV6v9mf7f2Pk6Q-1; Fri, 08 Jul 2022 15:43:42 -0400
X-MC-Unique: GtggaDQnPV6v9mf7f2Pk6Q-1
Received: by mail-qt1-f197.google.com with SMTP id x16-20020ac85f10000000b0031d3262f264so19567936qta.22
        for <netdev@vger.kernel.org>; Fri, 08 Jul 2022 12:43:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:content-transfer-encoding:user-agent:mime-version;
        bh=ZRvcEyBikV1fuKkjf8/FIQL8bf6qUSsx6qqnqqq9IP8=;
        b=67C2VQldhA6G9+dBbYhRN9OwCqCICGqGWdArZmq4bWQfLMadpYD276cPWZ6j6mUQA7
         lm2mj8C/kc8lMVM+DmqfyRxAqC871NBPAQhmJ64ZsuabWRDCcF1SSVNQbKLM6T/sin7n
         NEMntq0V3Su7+4up7jW7UexTmZez7yk6N78xiP82th3oXGvc7wU8+2yGJ+j2fazEx56g
         nw5vRvvF71TLZPj6lCGKDzUn35ADTEeQUNpkvs+MZoURO6ahcIpC7g5i/TemOWZdAiVZ
         m3OuYcFWVcInweJ2kLB8HSMcNb1o7g+6XgaFtBS3jrVbSqP4kFpKVfSesOKeHh1vVauC
         faNA==
X-Gm-Message-State: AJIora+wQgJ6QUiO15Fl63LafKJIwfwvKJEVF8oYp0pqEwZppsKdB+zC
        wFW8lYJHZa+s3ye3uNBAndcQPrBhywGHYve9EdLsV12ozAimMyBFeb8Th8I0ask6QSc2sjCCSiG
        MDwFMZsMPzOmFRrrU
X-Received: by 2002:a05:622a:134f:b0:317:cade:5551 with SMTP id w15-20020a05622a134f00b00317cade5551mr4418112qtk.445.1657309421632;
        Fri, 08 Jul 2022 12:43:41 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tVZcfBxrToeHT7ysSsp4WOwsEbugOvV/vI4cdDHdIqbGieXzfOsHl3Urur0nTqqJuy1sb2sw==
X-Received: by 2002:a05:622a:134f:b0:317:cade:5551 with SMTP id w15-20020a05622a134f00b00317cade5551mr4418089qtk.445.1657309421355;
        Fri, 08 Jul 2022 12:43:41 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id bp13-20020a05620a458d00b006af10bd3635sm30225651qkb.57.2022.07.08.12.43.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 12:43:41 -0700 (PDT)
Message-ID: <10963d58b011dbe42bf3b9ec69a010862f0d2638.camel@redhat.com>
Subject: Re: [PATCH v3 17/32] NFSD: Never call nfsd_file_gc() in foreground
 paths
From:   Jeff Layton <jlayton@redhat.com>
To:     Chuck Lever <chuck.lever@oracle.com>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     david@fromorbit.com, tgraf@suug.ch
Date:   Fri, 08 Jul 2022 15:43:40 -0400
In-Reply-To: <165730473096.28142.6742811495100296997.stgit@klimt.1015granger.net>
References: <165730437087.28142.6731645688073512500.stgit@klimt.1015granger.net>
         <165730473096.28142.6742811495100296997.stgit@klimt.1015granger.net>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-07-08 at 14:25 -0400, Chuck Lever wrote:
> The checks in nfsd_file_acquire() and nfsd_file_put() that directly
> invoke filecache garbage collection are intended to keep cache
> occupancy between a low- and high-watermark. The reason to limit the
> capacity of the filecache is to keep filecache lookups reasonably
> fast.
>=20
> However, invoking garbage collection at those points has some
> undesirable negative impacts. Files that are held open by NFSv4
> clients often push the occupancy of the filecache over these
> watermarks. At that point:
>=20
> - Every call to nfsd_file_acquire() and nfsd_file_put() results in
>   an LRU walk. This has the same effect on lookup latency as long
>   chains in the hash table.
> - Garbage collection will then run on every nfsd thread, causing a
>   lot of unnecessary lock contention.
> - Limiting cache capacity pushes out files used only by NFSv3
>   clients, which are the type of files the filecache is supposed to
>   help.
>=20
> To address those negative impacts, remove the direct calls to the
> garbage collector. Subsequent patches will address maintaining
> lookup efficiency as cache capacity increases.
>=20
> Suggested-by: Wang Yugui <wangyugui@e16-tech.com>
> Suggested-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> ---
>  fs/nfsd/filecache.c |   10 +---------
>  1 file changed, 1 insertion(+), 9 deletions(-)
>=20
> diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
> index bd6ba63f69ae..faa8588663d6 100644
> --- a/fs/nfsd/filecache.c
> +++ b/fs/nfsd/filecache.c
> @@ -29,8 +29,6 @@
>  #define NFSD_LAUNDRETTE_DELAY		     (2 * HZ)
> =20
>  #define NFSD_FILE_SHUTDOWN		     (1)
> -#define NFSD_FILE_LRU_THRESHOLD		     (4096UL)
> -#define NFSD_FILE_LRU_LIMIT		     (NFSD_FILE_LRU_THRESHOLD << 2)
> =20
>  /* We only care about NFSD_MAY_READ/WRITE for this cache */
>  #define NFSD_FILE_MAY_MASK	(NFSD_MAY_READ|NFSD_MAY_WRITE)
> @@ -66,8 +64,6 @@ static struct fsnotify_group		*nfsd_file_fsnotify_group=
;
>  static atomic_long_t			nfsd_filecache_count;
>  static struct delayed_work		nfsd_filecache_laundrette;
> =20
> -static void nfsd_file_gc(void);
> -
>  static void
>  nfsd_file_schedule_laundrette(void)
>  {
> @@ -350,9 +346,6 @@ nfsd_file_put(struct nfsd_file *nf)
>  		nfsd_file_schedule_laundrette();
>  	} else
>  		nfsd_file_put_noref(nf);
> -
> -	if (atomic_long_read(&nfsd_filecache_count) >=3D NFSD_FILE_LRU_LIMIT)
> -		nfsd_file_gc();

This may be addressed in later patches, but instead of just removing
these, would it be better to instead call
nfsd_file_schedule_laundrette() ?

>  }
> =20
>  struct nfsd_file *
> @@ -1075,8 +1068,7 @@ nfsd_do_file_acquire(struct svc_rqst *rqstp, struct=
 svc_fh *fhp,
>  	nfsd_file_hashtbl[hashval].nfb_maxcount =3D max(nfsd_file_hashtbl[hashv=
al].nfb_maxcount,
>  			nfsd_file_hashtbl[hashval].nfb_count);
>  	spin_unlock(&nfsd_file_hashtbl[hashval].nfb_lock);
> -	if (atomic_long_inc_return(&nfsd_filecache_count) >=3D NFSD_FILE_LRU_TH=
RESHOLD)
> -		nfsd_file_gc();
> +	atomic_long_inc(&nfsd_filecache_count);
> =20
>  	nf->nf_mark =3D nfsd_file_mark_find_or_create(nf);
>  	if (nf->nf_mark) {
>=20
>=20

--=20
Jeff Layton <jlayton@redhat.com>

