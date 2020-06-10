Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74C761F5249
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 12:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbgFJK3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 06:29:47 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:59399 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728196AbgFJK3m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 06:29:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591784980;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GxKKu811+w7UaGJmYO5+6aGvvE5GsIhCJfPwnaN5ZHw=;
        b=YlDagj7pkm9niq3quVo9M3ATwJbnSbQyaXCYdXNpPGaE7VgXwQesK+b7+I0VUjha9coxGm
        pVOYNJsng4uha+F+L4G8PS6q8MjmpvOqaWxrBGkLvkazOqF8tyF9cpMcxHrY7sH2HchE60
        IrryPZk5KsMT2z33uV1zGFTZufdL6dY=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-469-7NAtnNAhO4Kje2CT4XcOaQ-1; Wed, 10 Jun 2020 06:29:39 -0400
X-MC-Unique: 7NAtnNAhO4Kje2CT4XcOaQ-1
Received: by mail-ej1-f70.google.com with SMTP id hj12so887600ejb.13
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 03:29:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=GxKKu811+w7UaGJmYO5+6aGvvE5GsIhCJfPwnaN5ZHw=;
        b=A+fkqT13J0cXisCnGJo5LpjAotdFFSRHG2lEOmIlGc0LZ/qncXXSgDJwc3g3tfM17q
         E7c6ztkPaa07BHJJQrUbQ/qIC+K/b6KbCyBusJmBoeOz4HJwmwXk3xyuix2kppZYq2E3
         q6q5IQ3aJ+QhBwEu4qq/wPX3qwlXadMLCUFk0MMSZh/jjkl02QQveOyDkhYULhSykPG0
         1MvlLpNpxqKpGNxa5w060plLaSo1h97IL7lTH5LB8nhBtQnMSne91z4O1veInxC3dgWZ
         fedcJtZsmAcerrnaHD+YoASW8ElsRXChNl5gT/R+C4B8ZDU1abGyl5LhhX0UQhd/BL7o
         cTjw==
X-Gm-Message-State: AOAM530rAlzGC7jxqyMeX2r+CtuRvSWou3y6RLk71Rregw2FqC5MXbP2
        NXSC6cZRJta8tqyEd6k93oMH0kVdqhy0VYj9P3xaT8XQVCFCL/VawkeokRhRdQC+V3CYLZuej06
        PgZN9Vy0hvehRrtJg
X-Received: by 2002:aa7:c2c7:: with SMTP id m7mr1843698edp.148.1591784977997;
        Wed, 10 Jun 2020 03:29:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyONuhGdwEjNVp5/MHeIQq2YqTGeloLAyIipufJxm6fFunXScnoP/l40GwW3brG4O37+LwACQ==
X-Received: by 2002:aa7:c2c7:: with SMTP id m7mr1843684edp.148.1591784977690;
        Wed, 10 Jun 2020 03:29:37 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id m2sm1072511ejg.7.2020.06.10.03.29.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2020 03:29:36 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 4670C1814F0; Wed, 10 Jun 2020 12:29:35 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        brouer@redhat.com
Subject: Re: [PATCHv4 bpf-next 1/2] xdp: add a new helper for dev map multicast support
In-Reply-To: <20200610122153.76d30e37@carbon>
References: <20200415085437.23028-1-liuhangbin@gmail.com> <20200526140539.4103528-1-liuhangbin@gmail.com> <20200526140539.4103528-2-liuhangbin@gmail.com> <20200610122153.76d30e37@carbon>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 10 Jun 2020 12:29:35 +0200
Message-ID: <87d0678b8w.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer <brouer@redhat.com> writes:

> On Tue, 26 May 2020 22:05:38 +0800
> Hangbin Liu <liuhangbin@gmail.com> wrote:
>
>> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
>> index a51d9fb7a359..ecc5c44a5bab 100644
>> --- a/kernel/bpf/devmap.c
>> +++ b/kernel/bpf/devmap.c
> [...]
>
>> +int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_rx,
>> +			  struct bpf_map *map, struct bpf_map *ex_map,
>> +			  bool exclude_ingress)
>> +{
>> +	struct bpf_dtab_netdev *obj = NULL;
>> +	struct xdp_frame *xdpf, *nxdpf;
>> +	struct net_device *dev;
>> +	bool first = true;
>> +	u32 key, next_key;
>> +	int err;
>> +
>> +	devmap_get_next_key(map, NULL, &key);
>> +
>> +	xdpf = convert_to_xdp_frame(xdp);
>> +	if (unlikely(!xdpf))
>> +		return -EOVERFLOW;
>> +
>> +	for (;;) {
>> +		switch (map->map_type) {
>> +		case BPF_MAP_TYPE_DEVMAP:
>> +			obj = __dev_map_lookup_elem(map, key);
>> +			break;
>> +		case BPF_MAP_TYPE_DEVMAP_HASH:
>> +			obj = __dev_map_hash_lookup_elem(map, key);
>> +			break;
>> +		default:
>> +			break;
>> +		}
>> +
>> +		if (!obj || dev_in_exclude_map(obj, ex_map,
>> +					       exclude_ingress ? dev_rx->ifindex : 0))
>> +			goto find_next;
>> +
>> +		dev = obj->dev;
>> +
>> +		if (!dev->netdev_ops->ndo_xdp_xmit)
>> +			goto find_next;
>> +
>> +		err = xdp_ok_fwd_dev(dev, xdp->data_end - xdp->data);
>> +		if (unlikely(err))
>> +			goto find_next;
>> +
>> +		if (!first) {
>> +			nxdpf = xdpf_clone(xdpf);
>> +			if (unlikely(!nxdpf))
>> +				return -ENOMEM;
>> +
>> +			bq_enqueue(dev, nxdpf, dev_rx);
>> +		} else {
>> +			bq_enqueue(dev, xdpf, dev_rx);
>
> This looks racy.  You enqueue the original frame, and then later
> xdpf_clone it.  The original frame might have been freed at that
> point.

This was actually my suggestion; on the assumption that bq_enqueue()
just puts the frame on a list that won't be flushed until we exit the
NAPI loop.

But I guess now that you mention it that bq_enqueue() may flush the
queue, so you're right that this won't work. Sorry about that, Hangbin :/

Jesper, the reason I suggested this was to avoid an "extra" copy (i.e.,
if we have two destinations, ideally we should only clone once instead
of twice). Got any clever ideas for a safe way to achieve this? :)

-Toke

