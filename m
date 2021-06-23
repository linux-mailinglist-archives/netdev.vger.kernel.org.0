Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A86B23B1CBE
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 16:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbhFWOnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 10:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbhFWOnH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 10:43:07 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1838C061574;
        Wed, 23 Jun 2021 07:40:48 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id t4-20020a9d66c40000b029045e885b18deso2142517otm.6;
        Wed, 23 Jun 2021 07:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fZp9GFv1Y32dPfDYJUQ+Hjn4kcZZuuZO6DiDbSv0gI0=;
        b=VGwX2fpuAL8HcxuzjXJoFwFSiduKXCaNSjIz0Q3hRQke9xmA6TJ8k+UgsDhV9X+pdr
         nOaRfY4oAWgm01FXTx4S9xYZWpBasej7/yhki4iSR2PWhL7nEKpQj3e1u1yoPVfmcEpa
         5qXtWYk8zxoH/nrnorzIOG8l27Lnnt+GpliGjTEHkO+UgX7EJDH3GK7Z5UYZgIbiYoMP
         GNdkKpjThDHsq7T3lWKpIg0mzwKVwXPt00Z1pp2RTIWIxTR93YUY2IDyiYMS6CkpfFA4
         eub+xJbjddn3+Hxsmwa7R8jYdKice5fYIo5O5Bg/zJSTrJxzS9wMlyB7wp0ShRQxMzTc
         7FLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fZp9GFv1Y32dPfDYJUQ+Hjn4kcZZuuZO6DiDbSv0gI0=;
        b=qdkHuyHpWGzTjogQCb0cCmtGfdwwc5x3G2nFGjImd0lhsajBdBiHIe0GdvZ7sf0wRf
         ipirI4oHlzGDvnMIqol561LHU3AWfquqFNrWOBXOfGIvUHJnm7LRSK0ubJfO/SCyyHu/
         q5Yujyds/dxJTufkKMHmJfkm4NNF44ApXL0xsUP4hc2euU3y9HMxwikhozbIN7KdX6DZ
         a52aB6J2VMAZ14F3O52WsTGr0Xd58I+xBl0dGQSjBRqCJyfd78RyvPkVRAjhoP8JxqRI
         qOd0qtKlEgELojjkLWccZOC2ddB79f90YM9S1JF6n15XHZ6KEjV9UEhVyIeGA0XNJ9pv
         PusA==
X-Gm-Message-State: AOAM531dLJ4Oip8WAmAlhfgk301VMq21+DEbZmQcB6EYQVTcMAuTVNm2
        gSsqgB21kGO2hSZkfNBMX1Y=
X-Google-Smtp-Source: ABdhPJzlZZ3UIY8sTy3RvZV+W7TagsqfcfExs3ckPqExZPkBPh2FDiJ9edvT2Z1kHoZjVTp4FQc+Mw==
X-Received: by 2002:a05:6830:1d63:: with SMTP id l3mr222604oti.108.1624459248314;
        Wed, 23 Jun 2021 07:40:48 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id n72sm112757oig.5.2021.06.23.07.40.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 07:40:47 -0700 (PDT)
Subject: Re: [PATCH v9 bpf-next 00/14] mvneta: introduce XDP multi-buffer
 support
To:     John Fastabend <john.fastabend@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        sameehj@amazon.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com
References: <cover.1623674025.git.lorenzo@kernel.org>
 <60d26fcdbd5c7_1342e208f6@john-XPS-13-9370.notmuch>
 <efe4fcfa-087b-e025-a371-269ef36a3e86@gmail.com>
 <60d2cb1fd2bf9_2052b20886@john-XPS-13-9370.notmuch>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <9710dfc6-94f6-b0bd-5ac8-4e7dbfa54e7e@gmail.com>
Date:   Wed, 23 Jun 2021 08:40:44 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <60d2cb1fd2bf9_2052b20886@john-XPS-13-9370.notmuch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/22/21 11:48 PM, John Fastabend wrote:
> David Ahern wrote:
>> On 6/22/21 5:18 PM, John Fastabend wrote:
>>> At this point I don't think we can have a partial implementation. At
>>> the moment we have packet capture applications and protocol parsers
>>> running in production. If we allow this to go in staged we are going
>>> to break those applications that make the fundamental assumption they
>>> have access to all the data in the packet.
>>
>> What about cases like netgpu where headers are accessible but data is
>> not (e.g., gpu memory)? If the API indicates limited buffer access, is
>> that sufficient?
> 
> I never consider netgpus and I guess I don't fully understand the
> architecture to say. But, I would try to argue that an XDP API
> should allow XDP to reach into the payload of these GPU packets as well.
> Of course it might be slow.

AIUI S/W on the host can not access gpu memory, so that is not a
possibility at all.

Another use case is DDP and ZC. Mellanox has a proposal for NVME (with
intentions to extend to iscsi) to do direct data placement. This is
really just an example of zerocopy (and netgpu has morphed into zctap
with current prototype working for host memory) which will become more
prominent. XDP programs accessing memory already mapped to user space
will be racy.

To me these proposals suggest a trend and one that XDP APIs should be
ready to handle - like indicating limited access or specifying length
that can be accessed.


> 
> I'm not really convinced just indicating its a limited buffer is enough.
> I think we want to be able to read/write any byte in the packet. I see
> two ways to do it,
> 
>   /* xdp_pull_data moves data and data_end pointers into the frag
>    * containing the byte offset start.
>    *
>    * returns negative value on error otherwise returns offset of
>    * data pointer into payload.
>    */
>   int xdp_pull_data(int start)
> 
> This would be a helper call to push the xdp->data{_end} pointers into
> the correct frag and then normal verification should work. From my
> side this works because I can always find the next frag by starting
> at 'xdp_pull_data(xdp->data_end+1)'. And by returning offset we can
> always figure out where we are in the payload. This is the easiest
> thing I could come up with. And hopefully for _most_ cases the bytes
> we need are in the initial data. Also I don't see how extending tail
> works without something like this.
> 
> My other thought, but requires some verifier work would be to extend
> 'struct xdp_md' with a frags[] pointer.
> 
>  struct xdp_md {
>    __u32 data;
>    __u32 data_end;
>    __u32 data_meta;
>    /* metadata stuff */
>   struct _xdp_md frags[] 
>   __u32 frags_end;
>  }
> 
> Then a XDP program could read access a frag like so,
> 
>   if (i < xdp->frags_end) {
>      frag = xdp->frags[i];
>      if (offset + hdr_size < frag->data_end)
>          memcpy(dst, frag->data[offset], hdr_size);
>   }
> 
> The nice bit about above is you avoid the call, but maybe it doesn't
> matter if you are already looking into frags pps is probably not at
> 64B sizes anyways.
> 
> My main concern here is we hit a case where the driver doesn't pull in
> the bytes we need and then we are stuck without a workaround. The helper
> looks fairly straightforward to me could we try that?
> 
> Also I thought we had another driver in the works? Any ideas where
> that went...
> 
> Last, I'll add thanks for working on this everyone.
> 
> .John
> 

