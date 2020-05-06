Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 282741C6DDD
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 12:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728193AbgEFKAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 06:00:16 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48159 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728180AbgEFKAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 06:00:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588759214;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/yse9wAFbwsOqetKh7+VqeIgo2g7MYDJ2PL6VXMxg4M=;
        b=KjuVd09WMQymiv3yMZ5wiHi+kFZd6EHiV3D+OrpAFizYf4uHLkTESliVPf/75kBsUF6Sq3
        c6WTIOV9nAGWi9EO//X8D2GHlQ/AWDYTBBgpSNUby9X2FfhlhEs8FIhlaiidOiZiDpP36P
        C7uxdo5BRJa/qN8ym95hQyu+7U3a5p4=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-38-ysbHEEf0OWuYploySXjnAg-1; Wed, 06 May 2020 06:00:12 -0400
X-MC-Unique: ysbHEEf0OWuYploySXjnAg-1
Received: by mail-lf1-f69.google.com with SMTP id n13so647361lfb.2
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 03:00:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=/yse9wAFbwsOqetKh7+VqeIgo2g7MYDJ2PL6VXMxg4M=;
        b=T+eWNMFpFZZjlLgcRVcvLCwJVjcwC51NWVtE/zwsTwgDZh8yMkvLwU/qp9ReZdyXS9
         uMLVUF4mIYRTHYLPLUm9h2cHjNEEqr7eHbahhp1ZQ30Mn0LstcGlHtmovfeMUDOVXPnH
         5Ck8iymowjb6ax8pP30r2Y/A/MeSViSDgPtLK0zGTzUsLi2N81g0kP9m9LhkZdHHk8Ok
         MJvC1cDJCv3Ye6lDPXk36LnP+VpD+5eNb4IZyB+udEd5qAjOe5xk55c2dCFawISkftK/
         U2Ou+sDEf4km+mfqvcDsQcowuV4hJNoG8x4oKq50Ql8aSYBenrDl3uhKnIDaDNUMx93N
         FDNg==
X-Gm-Message-State: AGi0PuYxoFlMsCYhEDmJIRRvtBUilH4ft3iHrxcDJnQp20FnonKFLFEf
        WAhIV9TW0OUge0acu2HXFXswzAL8Ko93F/kWdFQpKARW6Jyqvowp86YBPxdUh2XZyjJmyqKi0Fs
        3wXShd883CXlKbj1Y
X-Received: by 2002:a2e:b44c:: with SMTP id o12mr4155061ljm.240.1588759210648;
        Wed, 06 May 2020 03:00:10 -0700 (PDT)
X-Google-Smtp-Source: APiQypJjrdVlse6+XhdtFOp7b+xVLAVkd268Hj8ENL2WCItSnQ1F9AdFYzvYU5bD1DpxIluXSr+Ymg==
X-Received: by 2002:a2e:b44c:: with SMTP id o12mr4155036ljm.240.1588759210322;
        Wed, 06 May 2020 03:00:10 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id b4sm1229877lfo.33.2020.05.06.03.00.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 03:00:09 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 789851804E9; Wed,  6 May 2020 12:00:08 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: Re: [RFC PATCHv2 bpf-next 1/2] xdp: add a new helper for dev map multicast support
In-Reply-To: <20200506091442.GA102436@dhcp-12-153.nay.redhat.com>
References: <20200415085437.23028-1-liuhangbin@gmail.com> <20200424085610.10047-1-liuhangbin@gmail.com> <20200424085610.10047-2-liuhangbin@gmail.com> <87r1wd2bqu.fsf@toke.dk> <20200506091442.GA102436@dhcp-12-153.nay.redhat.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 06 May 2020 12:00:08 +0200
Message-ID: <874kstmlhz.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu <liuhangbin@gmail.com> writes:

> Hi Toke,
>
> Thanks for your review, please see replies below.
>
> On Fri, Apr 24, 2020 at 04:34:49PM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> >
>> > The general data path is kept in net/core/filter.c. The native data
>> > path is in kernel/bpf/devmap.c so we can use direct calls to
>> > get better performace.
>>=20
>> Got any performance numbers? :)
>
> No, I haven't test the performance. Do you have any suggestions about how
> to test it? I'd like to try forwarding pkts to 10+ ports. But I don't know
> how to test the throughput. I don't think netperf or iperf supports
> this.

What I usually do when benchmarking XDP_REDIRECT is to just use pktgen
(samples/pktgen in the kernel source tree) on another machine,
specifically, like this:

./pktgen_sample03_burst_single_flow.sh  -i enp1s0f1 -d 10.70.2.2 -m ec:0d:9=
a:db:11:35 -t 4  -s 64

(adjust iface, IP and MAC address to your system, of course). That'll
flood the target machine with small UDP packets. On that machine, I then
run the 'xdp_redirect_map' program from samples/bpf. The bpf program
used by that sample will update an internal counter for every packet,
and the userspace prints it out, which gives you the performance (in
PPS). So just modifying that sample to using your new multicast helper
(and comparing it to regular REDIRECT to a single device) would be a
first approximation of a performance test.

[...]

>> > +	devmap_get_next_key(map, NULL, &key);
>> > +
>> > +	for (;;) {
>>=20
>> I wonder if we should require DEVMAP_HASH maps to be indexed by ifindex
>> to avoid the loop?
>
> I guess it's not easy to force user to index the map by ifindex.

Well, the way to 'force the user' is just to assume that this is the
case, and if the map is filled in wrong, things just won't work ;)

>> > +	xdpf =3D convert_to_xdp_frame(xdp);
>> > +	if (unlikely(!xdpf))
>> > +		return -EOVERFLOW;
>>=20
>> You do a clone for each map entry below, so I think you end up leaking
>> this initial xdpf? Also, you'll end up with one clone more than
>> necessary - redirecting to two interfaces should only require 1 clone,
>> you're doing 2.
>
> We don't know which is the latest one. So we need to keep the initial
> for clone. Is it enough to call xdp_release_frame() after the for
> loop?

You could do something like:

bool first =3D true;
for (;;) {

[...]

           if (!first) {
   		nxdpf =3D xdpf_clone(xdpf);
   		if (unlikely(!nxdpf))
   			return -ENOMEM;
   		bq_enqueue(dev, nxdpf, dev_rx);
           } else {
   		bq_enqueue(dev, xdpf, dev_rx);
   		first =3D false;
           }
}

/* didn't find anywhere to forward to, free buf */
if (first)
   xdp_return_frame_rx_napi(xdpf);



[...]

>> This duplication bugs me; maybe we should try to consolidate the generic
>> and native XDP code paths?
>
> Yes, I have tried to combine these two functions together. But one is gen=
eric
> code path and another is XDP code patch. One use skb_clone and another
> use xdpf_clone(). There are also some extra checks for XDP code. So maybe
> we'd better just keep it as it is.

Yeah, guess it may not be as simple as I'd like it to be ;)
Let's keep it this way for now at least; we can always consolidate in a
separate patch series.

-Toke

