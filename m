Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEFDF21AFC7
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 08:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbgGJGzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 02:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbgGJGzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 02:55:47 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58346C08C5CE;
        Thu,  9 Jul 2020 23:55:47 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id gc15so4204623pjb.0;
        Thu, 09 Jul 2020 23:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=m7J+5fWbfHLSjL8FL/BgpUL9aWwY4tbBywxsUb2oYnE=;
        b=TVOLstZk5tezPm7jqLmtBh7yyXX9f1WhVQEcsMvDb5YmRwD6JTOvD3Vt93iq4a+scK
         71VnQjsPv4AUk90Rikn/2O3X9x7iPQjH22ZrG/QlX9jI9djzpJWGWvwlP+B5VvWf5iQ6
         K2nGSUBMozAN0KFlxCH2pwRF8ywz5jeiZnkFASroIsGTuieVRmdS8cMgF8bAcE7Qwiws
         g5qOUeoGNnksOgOtGfnHhqzHDvjDq3Km3M9R/xte+ksa3MlPTvnI024xGjQINtuu/+oQ
         eh6qgWceofmwCf1nG+sZ9jK2DmORCzX8l7yNYdcxLtKqIyI94jqcmCRDDDfVhHN8Ja6d
         b7DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=m7J+5fWbfHLSjL8FL/BgpUL9aWwY4tbBywxsUb2oYnE=;
        b=s1wfYDQgie0K7p0cedkFUU9TZ2MWNoPY/W5iNAqLYH7zVSPAHG61M8yH5UpbTLbH/y
         PXtR0jxPGESxWkLqIAHfg4PvNREo4HDlhqNnVPfFI0obUfJ+iT/Wd2LehG/nWH3PBC5I
         N9BNE0yjT5tDdjq3j8dlgXbEeBv/CetYfbY0FM91kdFjMzcMeegKgnPi25qdpakz0wWo
         mgjqRB/3OAAR8S3g8bDvfXeQn4287Xj4NBAheioxarzDkfXTdXceHyCisphPoVL8TYWd
         4Af6pHBIu4inQoDl/772HMdd6nI13A/3qGlHRjwFttYbNN1tNaVXuobGrDjooMttu5g2
         c3hQ==
X-Gm-Message-State: AOAM532W+ooVnxNVkkGuEGLF62L0mCTdUtdx7naMathi8dWmCN7Eg6gB
        QIPo9Dg7ScY2fJK/gRxQbeM=
X-Google-Smtp-Source: ABdhPJz5Zw0hWUIzNuBlgqwU0CNTCtrIEGssysPFYBha+uCVLuVO+4vArDkh7FJ2npvs0L3KLRpKwA==
X-Received: by 2002:a17:902:b714:: with SMTP id d20mr45116972pls.318.1594364146866;
        Thu, 09 Jul 2020 23:55:46 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y6sm4989646pfp.7.2020.07.09.23.55.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 23:55:46 -0700 (PDT)
Date:   Fri, 10 Jul 2020 14:55:35 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: Re: [PATCHv6 bpf-next 1/3] xdp: add a new helper for dev map
 multicast support
Message-ID: <20200710065535.GB2531@dhcp-12-153.nay.redhat.com>
References: <20200701041938.862200-1-liuhangbin@gmail.com>
 <20200709013008.3900892-1-liuhangbin@gmail.com>
 <20200709013008.3900892-2-liuhangbin@gmail.com>
 <efcdf373-7add-cce1-17a3-03ddf38e0749@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <efcdf373-7add-cce1-17a3-03ddf38e0749@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,
On Thu, Jul 09, 2020 at 10:33:38AM -0600, David Ahern wrote:
> > +bool dev_in_exclude_map(struct bpf_dtab_netdev *obj, struct bpf_map *map,
> > +			int exclude_ifindex)
> > +{
> > +	struct bpf_dtab_netdev *ex_obj = NULL;
> > +	u32 key, next_key;
> > +	int err;
> > +
> > +	if (obj->dev->ifindex == exclude_ifindex)
> > +		return true;
> > +
> > +	if (!map)
> > +		return false;
> > +
> > +	err = devmap_get_next_key(map, NULL, &key);
> > +	if (err)
> > +		return false;
> > +
> > +	for (;;) {
> > +		switch (map->map_type) {
> > +		case BPF_MAP_TYPE_DEVMAP:
> > +			ex_obj = __dev_map_lookup_elem(map, key);
> > +			break;
> > +		case BPF_MAP_TYPE_DEVMAP_HASH:
> > +			ex_obj = __dev_map_hash_lookup_elem(map, key);
> > +			break;
> > +		default:
> > +			break;
> > +		}
> > +
> > +		if (ex_obj && ex_obj->dev->ifindex == obj->dev->ifindex)
> 
> I'm probably missing something fundamental, but why do you need to walk
> the keys? Why not just do a lookup on the device index?

This functions is to check if the device index is in exclude map.

The device indexes are stored as values in the map. The user could store
the values by any key number. There is no way to lookup the device index
directly unless loop the map and check each values we stored.

Is there a map feature which could get an exact value directly?

> > +BPF_CALL_3(bpf_xdp_redirect_map_multi, struct bpf_map *, map,
> > +	   struct bpf_map *, ex_map, u64, flags)
> > +{
> > +	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
> > +
> > +	if (unlikely(!map || flags > BPF_F_EXCLUDE_INGRESS))
> 
> If flags is a bitfield, the check should be:
>     flags & ~BPF_F_EXCLUDE_INGRESS

Thanks for the tips, I will fix it.

Cheers
Hangbin
