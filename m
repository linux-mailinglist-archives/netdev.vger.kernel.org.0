Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1731C27D650
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 21:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728311AbgI2TA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 15:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728215AbgI2TA6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 15:00:58 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADE65C061755;
        Tue, 29 Sep 2020 12:00:58 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id l126so5516727pfd.5;
        Tue, 29 Sep 2020 12:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2WMLi/ye2wCNTqdWZL7Ir6k8sUI+7vs5Ma1GzkhV4oY=;
        b=lNX0QxbMp5YTgYayAU+ZSPQLkcGvRYd8NBBaM+vHq9iMbpV0U3Gppk1VTcoqZUMzCr
         aqyNCkuab4uijG+PoKIx6rSiUL+Dk9hEqR6vqhFZcaKirgpCHP3vJ43Bpy2hbZSmAw7Z
         E1uYWuTtHoXP5ul6FfoGtCYLdYZZzm0SN8OfEuSb8gl+dQPHsYCZTR3LxlsIT/DhfOOg
         DxTCgQ4SuMZWoIP5ujNS9c3RoL675axzS6I0fSSRV/yW69Lw5GvYdfxT2P5yHTUkbpaw
         8IXkp4Kws9G382jtP5fgMkuH5sAMiA6D+ZCAclyPBrBFpg3dQZ5Z4Z7VvZoS1MzHLP3G
         Tv9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2WMLi/ye2wCNTqdWZL7Ir6k8sUI+7vs5Ma1GzkhV4oY=;
        b=a3zDKCHLaLk9/zxHStlTDphQQuZrVBZBK1aGIZZi72PnAnRqyOXqttIW8AbTbnVhcF
         wQH401nQDkzAaed2QVBjiDZZ+HipbgD8FBBuoPqAf864Tdb3JaKOijmSXkSUYTZG9VlR
         QeBVbZ+pDxh0btpa0d0Q9LDJoLAmtrE6jzAEOv50mhXqCkjItLO/Lkv67mjYLQuTykXX
         eWfB6EZKCfPA1pY6+rdhgc5khetNejcrxAdBRY2b2lwGP07ZhCu2fq4ysGsusdFOAoFr
         p1PZUrUEE6Ei1+aFcyKKf289GRSilaXjslJJdXwN5F8APmqcwXvtFN5NjEjrURtSsPZ3
         aZQw==
X-Gm-Message-State: AOAM533nKIgjHfxbM0PQiPpH+3HHn+wkA93zddk8f+9FmJHF0zIgzAME
        6+hzSGw4ENlcVsBQgBmMWKE=
X-Google-Smtp-Source: ABdhPJzUAa1K9h7HsRpR500nmAICNI0XWqjz9QZ+kK3cK98YaozBgxF0oHtH3arMtOdNp+/IV06x8w==
X-Received: by 2002:a17:902:704a:b029:d2:950a:d816 with SMTP id h10-20020a170902704ab02900d2950ad816mr4580636plt.74.1601406058187;
        Tue, 29 Sep 2020 12:00:58 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:d27])
        by smtp.gmail.com with ESMTPSA id x9sm6351638pfj.96.2020.09.29.12.00.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 12:00:57 -0700 (PDT)
Date:   Tue, 29 Sep 2020 12:00:54 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Song Liu <songliubraving@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com, ast@kernel.org,
        john.fastabend@gmail.com, kpsingh@chromium.org
Subject: Re: [PATCH bpf-next 1/2] bpf: introduce BPF_F_SHARE_PE for perf
 event array
Message-ID: <20200929190054.4a2chcuxuvicndtu@ast-mbp.dhcp.thefacebook.com>
References: <20200929084750.419168-1-songliubraving@fb.com>
 <20200929084750.419168-2-songliubraving@fb.com>
 <04ba2027-a5ad-d715-ffc8-67f13e40f2d2@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04ba2027-a5ad-d715-ffc8-67f13e40f2d2@iogearbox.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 04:02:10PM +0200, Daniel Borkmann wrote:
> > +
> > +/* Share perf_event among processes */
> > +	BPF_F_SHARE_PE		= (1U << 11),
> 
> nit but given UAPI: maybe name into something more self-descriptive
> like BPF_F_SHAREABLE_EVENT ?

I'm not happy with either name.
It's not about sharing and not really about perf event.
I think the current behavior of perf_event_array is unusual and surprising.
Sadly we cannot fix it without breaking user space, so flag is needed.
How about BPF_F_STICKY_OBJECTS or BPF_F_PRESERVE_OBJECTS
or the same with s/OBJECTS/FILES/ ?

> > +static void perf_event_fd_array_map_free(struct bpf_map *map)
> > +{
> > +	struct bpf_event_entry *ee;
> > +	struct bpf_array *array;
> > +	int i;
> > +
> > +	if ((map->map_flags & BPF_F_SHARE_PE) == 0) {
> > +		fd_array_map_free(map);
> > +		return;
> > +	}
> > +
> > +	array = container_of(map, struct bpf_array, map);
> > +	for (i = 0; i < array->map.max_entries; i++) {
> > +		ee = READ_ONCE(array->ptrs[i]);
> > +		if (ee)
> > +			fd_array_map_delete_elem(map, &i);
> > +	}
> > +	bpf_map_area_free(array);
> 
> Why not simplify into:
> 
> 	if (map->map_flags & BPF_F_SHAREABLE_EVENT)
> 		bpf_fd_array_map_clear(map);
> 	fd_array_map_free(map);

+1

> > +}
> > +
> >   static void *prog_fd_array_get_ptr(struct bpf_map *map,
> >   				   struct file *map_file, int fd)
> >   {
> > @@ -1134,6 +1158,9 @@ static void perf_event_fd_array_release(struct bpf_map *map,
> >   	struct bpf_event_entry *ee;
> >   	int i;

add empty line pls.

> > +	if (map->map_flags & BPF_F_SHARE_PE)
> > +		return;
> > +
