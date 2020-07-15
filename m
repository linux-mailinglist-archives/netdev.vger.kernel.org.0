Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA24220CE0
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 14:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730344AbgGOMZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 08:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729198AbgGOMZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 08:25:27 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E553C061755;
        Wed, 15 Jul 2020 05:25:27 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id n5so2999989pgf.7;
        Wed, 15 Jul 2020 05:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=TI7B6uM5uAGiHWQ7sW+RUED1scSbU7lrfz9lYsJ7uGo=;
        b=ZZOSLzlcXTNm4W3OZMnWVr1+NbaMIUUE5yV17q0Y4hA0+t/z3V/DgbwxNjZOanbfyT
         P15BKhmOYeyEwe470CDsq1Gmh6KVZS/rD5dYEZuEMdGlTgsy6fo7YM200mud4SzH0dKV
         Twpms/NYERwpRJ6Ld0N5HYqT1I6kHrXeygLJDKG2Q8CELbHJQV2VnDQAeVhue0RIsuat
         RwI94CIbd26kZyjPO5k3PiVHO9N2kVxFvayyhowf1O+k+27pYy67195muiwxWYZ9bJT/
         1LHiFDhF4SsTASoAzJLfMth+rvMP+4v18E1coy83mkD42/yd8buYrKmlRZ9NdRpeyVSC
         y/xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=TI7B6uM5uAGiHWQ7sW+RUED1scSbU7lrfz9lYsJ7uGo=;
        b=gBGGk3SSV1ZL3UwRXAbvPs+VkvSLphAreun5o0HKKdEHcs2Vs32Eh7YEW8laEhDRSR
         /eIHj3hDBwUMYW4afeAQ5GuXhi7UvsW/dkmxX71dZPs77mO4YRF9+xLmtkbG8LoBXY2d
         QPzCzgmKRq9hYiIUKLSDZVfsDnDo5NBoPYwZ+1JTI4fZowdkDvhtzx5RPlku7DMxk7w6
         dfjvhzHoRDM6S5soeIpNmqKl8IrVy2M6BSvHsVy8xysU6usURVug2iXWNcK66DL5yW7f
         O5mz11rby7cenWdI3sfcUUSPU+qhrzdha4ICiK6XCrdiH1GcVdMTpdwO3rLfkWcMUX+B
         /yxA==
X-Gm-Message-State: AOAM533kjgi999nYml5/rSTUTrJ9gwAxuwdq55aIuDf2hgv5i2nFUhOs
        ZIgOsa3AtsrC1xailftjwCs=
X-Google-Smtp-Source: ABdhPJy7yjmLA5XbVF7NyUuQoRirQ+f/S9NyKNnFW9PIFnpMFMxa9S5xH582iGEeSOVO1gAN4T5gDw==
X-Received: by 2002:a63:b18:: with SMTP id 24mr8235755pgl.406.1594815926662;
        Wed, 15 Jul 2020 05:25:26 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o2sm2121381pfh.160.2020.07.15.05.25.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 05:25:25 -0700 (PDT)
Date:   Wed, 15 Jul 2020 20:25:14 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: Re: [PATCHv7 bpf-next 1/3] xdp: add a new helper for dev map
 multicast support
Message-ID: <20200715122514.GG2531@dhcp-12-153.nay.redhat.com>
References: <20200709013008.3900892-1-liuhangbin@gmail.com>
 <20200714063257.1694964-1-liuhangbin@gmail.com>
 <20200714063257.1694964-2-liuhangbin@gmail.com>
 <87imepg3xt.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87imepg3xt.fsf@toke.dk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 14, 2020 at 11:52:14PM +0200, Toke Høiland-Jørgensen wrote:
> > +bool dev_in_exclude_map(struct bpf_dtab_netdev *obj, struct bpf_map *map,
> > +			int exclude_ifindex)
> > +{
> > +	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
> > +	struct bpf_dtab_netdev *dev;
> > +	struct hlist_head *head;
> > +	int i = 0;
> > +
> > +	if (obj->dev->ifindex == exclude_ifindex)
> > +		return true;
> > +
> > +	if (!map || map->map_type != BPF_MAP_TYPE_DEVMAP_HASH)
> > +		return false;
> 
> The map type should probably be checked earlier and the whole operation
> aborted if it is wrong...

Yes, I have already checked it in the helper, there should no need to double
check. I will remove this check.

> 
> > +
> > +	for (; i < dtab->n_buckets; i++) {
> > +		head = dev_map_index_hash(dtab, i);
> > +
> > +		dev = hlist_entry_safe(rcu_dereference_raw(hlist_first_rcu(head)),
> > +					    struct bpf_dtab_netdev,
> > +					    index_hlist);
> > +
> > +		if (dev && dev->idx == exclude_ifindex)
> > +			return true;
> > +	}
> 
> This looks broken; why are you iterating through the buckets? Shouldn't
> this just be something like:
> 
> return __dev_map_hash_lookup_elem(map, obj->dev->ifindex) != NULL;

Ah, yes, I forgot this. I will update the code.

Thanks
Hangbin
