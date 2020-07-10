Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E408821B6F1
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 15:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728444AbgGJNqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 09:46:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728430AbgGJNqV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 09:46:21 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C75CC08C5CE;
        Fri, 10 Jul 2020 06:46:21 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id e4so4841353oib.1;
        Fri, 10 Jul 2020 06:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NxXD9qmVhxhNB7EGBXuIEpomT+ac3SpiE8Dhf0KPfIQ=;
        b=g1IWwpg49LgJmOk1mHmiA4h4Jtx+nVocFt5vvpTv7bo4Gu9aX2or8ZkNwmmWgtGbwt
         8/VeMGtxAHvyvcBEMX8m610oLFDSjg/kTZTnFI6MV3YeVdm0BMVOUDcDeCQy+ShrzxVP
         kUu9i2crVNqiQRtxGsdNE8tdsiKM6aSpNPJK3NK476AM3Qp4wNqVWmyZa9qYyJOvqWNv
         vJLIL3sK/dFfDVHSNRb+J27wj386tSuDECsXee7PdUnNFKk7jiZaSffptT+ZrTSXS/9I
         SiCG7wFVGH0Ac7Lf0og3tJckWDdlFp9oKYNGbtq3wDAP5Vl2fxGBLF0H55x8zNp5wmXO
         siqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NxXD9qmVhxhNB7EGBXuIEpomT+ac3SpiE8Dhf0KPfIQ=;
        b=QlKRAAFSJhS6liiL4jh74tDyqdB8jyk1owykTBVyOi7NwWGnL6A0rJLKh/7Z49JH5Z
         fmRWp+m/+Sp4qCWTUDaBS2ejZ5f6/S96QSedqLngFcZrHIgyx1pZsYNLN9XFrkU6Lqkx
         5Erj4Id3vxGvu9rk67TPA5g4DQad+hbsNr0YCjMxwYQqymhMfr+JbNKBFJqJdu1jWSKf
         jFVoZIOCjInAp+bIsVu0Wx/CJaPWfhGyiTuec1FdpiL63FcTy6GOQMTNPRD6vhv7lrUd
         HcQ9hV6ajY15iNKt2ukuIbbYAWdDOLfNKoFT7mS84WFmj3QCK9vsosUlAtM586vAdcsw
         SYeA==
X-Gm-Message-State: AOAM533T4Fm+UBaejBA6cbReQVgpmJVehxNRj0P7u3/qZKtVaWhvFUEN
        Kn0LGS/0liYOXhzpBCR1JXE=
X-Google-Smtp-Source: ABdhPJy8zJEz5z3Cn5cWzCcIHFmMYJT3mmJhSmIpsIMvyKgv0m0Sd+eC2LZ65RGMZ+njwJ/ljA7vfw==
X-Received: by 2002:aca:5c41:: with SMTP id q62mr4090093oib.148.1594388780657;
        Fri, 10 Jul 2020 06:46:20 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:94b4:214e:fabf:bc82? ([2601:282:803:7700:94b4:214e:fabf:bc82])
        by smtp.googlemail.com with ESMTPSA id j27sm1098712ots.7.2020.07.10.06.46.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jul 2020 06:46:19 -0700 (PDT)
Subject: Re: [PATCHv6 bpf-next 1/3] xdp: add a new helper for dev map
 multicast support
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
References: <20200701041938.862200-1-liuhangbin@gmail.com>
 <20200709013008.3900892-1-liuhangbin@gmail.com>
 <20200709013008.3900892-2-liuhangbin@gmail.com>
 <efcdf373-7add-cce1-17a3-03ddf38e0749@gmail.com>
 <20200710065535.GB2531@dhcp-12-153.nay.redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2212a795-4964-a828-4d63-92394585e684@gmail.com>
Date:   Fri, 10 Jul 2020 07:46:18 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200710065535.GB2531@dhcp-12-153.nay.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/10/20 12:55 AM, Hangbin Liu wrote:
> Hi David,
> On Thu, Jul 09, 2020 at 10:33:38AM -0600, David Ahern wrote:
>>> +bool dev_in_exclude_map(struct bpf_dtab_netdev *obj, struct bpf_map *map,
>>> +			int exclude_ifindex)
>>> +{
>>> +	struct bpf_dtab_netdev *ex_obj = NULL;
>>> +	u32 key, next_key;
>>> +	int err;
>>> +
>>> +	if (obj->dev->ifindex == exclude_ifindex)
>>> +		return true;
>>> +
>>> +	if (!map)
>>> +		return false;
>>> +
>>> +	err = devmap_get_next_key(map, NULL, &key);
>>> +	if (err)
>>> +		return false;
>>> +
>>> +	for (;;) {
>>> +		switch (map->map_type) {
>>> +		case BPF_MAP_TYPE_DEVMAP:
>>> +			ex_obj = __dev_map_lookup_elem(map, key);
>>> +			break;
>>> +		case BPF_MAP_TYPE_DEVMAP_HASH:
>>> +			ex_obj = __dev_map_hash_lookup_elem(map, key);
>>> +			break;
>>> +		default:
>>> +			break;
>>> +		}
>>> +
>>> +		if (ex_obj && ex_obj->dev->ifindex == obj->dev->ifindex)
>>
>> I'm probably missing something fundamental, but why do you need to walk
>> the keys? Why not just do a lookup on the device index?
> 
> This functions is to check if the device index is in exclude map.
> 
> The device indexes are stored as values in the map. The user could store
> the values by any key number. There is no way to lookup the device index
> directly unless loop the map and check each values we stored.

Right.

The point of DEVMAP_HASH is to allow map management where key == device
index (vs DEVMAP which for any non-trivial use case is going to require
key != device index). You could require the exclude map to be
DEVMAP_HASH and the key to be the index allowing you to do a direct
lookup. Having to roam the entire map looking for a match does not scale
and is going to have poor performance with increasing number of entries.
XDP is targeted at performance with expert level of control, so
constraints like this have to be part of the deal.
