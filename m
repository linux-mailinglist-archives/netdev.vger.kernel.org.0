Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A290B4885FE
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 21:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232824AbiAHUtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 15:49:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:20587 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232641AbiAHUtt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 15:49:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641674988;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ntWXCZ0zQqxqP5Huo89Rt3JcytilS4abkDUzM44/CDw=;
        b=T5XnBnk9/RLcOCa4J5oNoOInQsB0iNCwMMrrxrkL+ERf7QhVgNb8lWlHctQt6iMHPvcQt7
        RCfjJ553Of9xIdiEq35MaOAzb1TRorMAqp2yx6TpRaEMTqSBEpxNnm7FA/piXYuFd69Icr
        Bj9+M4pMPMs+g/sbJWMil02O4rPU6As=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-177-LE_sAXC8NaGLRpeFLpdZyQ-1; Sat, 08 Jan 2022 15:49:47 -0500
X-MC-Unique: LE_sAXC8NaGLRpeFLpdZyQ-1
Received: by mail-ed1-f72.google.com with SMTP id z8-20020a056402274800b003f8580bfb99so7251411edd.11
        for <netdev@vger.kernel.org>; Sat, 08 Jan 2022 12:49:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=ntWXCZ0zQqxqP5Huo89Rt3JcytilS4abkDUzM44/CDw=;
        b=i+KL9gW58e9uUf5uadj+O9cQN4JXMHoa0VJp03zsD8vIRbRdxqcYLcLn8MyJu47DX1
         b8t87Z2Mq3UBAl8FW9BxC5DMy58LMKrCQplAf7G/l8UFpj9BknRKReazGQGXEfyuqCu+
         rladr2E7ur014tbHyK4Jt3B4xMCHHzF1LB20DUx2PSQSu0C6VmBYK8nZeFdjigY1ejjh
         xjmv+DBBf39Owe5NzAq54Q1F6S0uBvfjksMTlezumWXMPuj6LNWEJXac3j1tnpdF7x4f
         BTbdNASF2JKztAkA5HEkxmPeN/Kt7886p6TZR9Du1QXVLc4TixIZjPbX1346jN2th1x6
         sTsQ==
X-Gm-Message-State: AOAM532ss18e5IY8DvF+aEVm+bzXcI4GCN9ITdVcWNMdILY7uTSVkarp
        moN7NaKysvf+35IC5zk7IkOWa+e6P0wr/aRh5j8Q63hYxwzSEi4jlV+yjy+KxvsX78ifuG4cMNM
        nFs0o5GJvdH9P3gyO
X-Received: by 2002:a05:6402:34ca:: with SMTP id w10mr66408589edc.106.1641673186598;
        Sat, 08 Jan 2022 12:19:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyFddTMrlHD0e5Tu9X/R343LKoyfXwZWg4G6FoZBSbHBzKmZDMMz1lo46gl6AgIXwgY7cfzAg==
X-Received: by 2002:a05:6402:34ca:: with SMTP id w10mr66408546edc.106.1641673185497;
        Sat, 08 Jan 2022 12:19:45 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id c8sm1121981edu.60.2022.01.08.12.19.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Jan 2022 12:19:43 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 071A5181F2A; Sat,  8 Jan 2022 21:19:41 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v7 1/3] bpf: Add "live packet" mode for XDP in
 bpf_prog_run()
In-Reply-To: <CAADnVQLWjbm03-3NHYyEx98tWRN68LSaOd3R9fjJoHY5cYoEJg@mail.gmail.com>
References: <20220107215438.321922-1-toke@redhat.com>
 <20220107215438.321922-2-toke@redhat.com>
 <CAADnVQ+uftgnRQa5nvG4FTJga_=_FMAGxuiPB3O=AFKfEdOg=A@mail.gmail.com>
 <87pmp28iwe.fsf@toke.dk>
 <CAADnVQLWjbm03-3NHYyEx98tWRN68LSaOd3R9fjJoHY5cYoEJg@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 08 Jan 2022 21:19:41 +0100
Message-ID: <87mtk67zfm.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Sat, Jan 8, 2022 at 5:19 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>>
>> Sure, can do. Doesn't look like BPF_PROG_RUN is documented in there at
>> all, so guess I can start such a document :)
>
> prog_run was simple enough.
> This live packet mode is a different level of complexity.
> Just look at the length of this thread.
> We keep finding implementation details that will be relevant
> to anyone trying to use this interface.
> They all will become part of uapi.

Sure, totally fine with documenting it. Just seems to me the most
obvious place to put this is in a new
Documentation/bpf/prog_test_run.rst file with a short introduction about
the general BPF_PROG_RUN mechanism, and then a subsection dedicated to
this facility.

Or would you rather I create something like
Documentation/bpf/xdp_live_packets.rst ?

>> > Another question comes to mind:
>> > What happens when a program modifies the packet?
>> > Does it mean that the 2nd frame will see the modified data?
>> > It will not, right?
>> > It's the page pool size of packets that will be inited the same way
>> > at the beginning. Which is NAPI_POLL_WEIGHT * 2 =3D=3D 128 packets.
>> > Why this number?
>>
>> Yes, you're right: the next run won't see the modified packet data. The
>> 128 pages is because we run the program loop in batches of 64 (like NAPI
>> does, the fact that TEST_XDP_BATCH and NAPI_POLL_WEIGHT are the same is
>> not a coincidence).
>>
>> We need 2x because we want enough pages so we can keep running without
>> allocating more, and the first batch can still be in flight on a
>> different CPU while we're processing batch 2.
>>
>> I experimented with different values, and 128 was the minimum size that
>> didn't have a significant negative impact on performance, and above that
>> saw diminishing returns.
>
> I guess it's ok-ish to get stuck with 128.
> It will be uapi that we cannot change though.
> Are you comfortable with that?

UAPI in what sense? I'm thinking of documenting it like:

"The packet data being supplied as data_in to BPF_PROG_RUN will be used
 for the initial run of the XDP program. However, when running the
 program multiple times (with repeat > 1), only the packet *bounds*
 (i.e., the data, data_end and data_meta pointers) will be reset on each
 invocation, the packet data itself won't be rewritten. The pages
 backing the packets are recycled, but the order depends on the path the
 packet takes through the kernel, making it hard to predict when a
 particular modified page makes it back to the XDP program. In practice,
 this means that if the XDP program modifies the packet payload before
 sending out the packet, it has to be prepared to deal with subsequent
 invocations seeing either the initial data or the already-modified
 packet, in arbitrary order."

I don't think this makes any promises about any particular size of the
page pool, so how does it constitute UAPI?

>> > Should it be configurable?
>> > Then the user can say: init N packets with this one pattern
>> > and the program will know that exactly N invocation will be
>> > with the same data, but N+1 it will see the 1st packet again
>> > that potentially was modified by the program.
>> > Is it accurate?
>>
>> I thought about making it configurable, but the trouble is that it's not
>> quite as straight-forward as the first N packets being "pristine": it
>> depends on what happens to the packet afterwards:
>>
>> On XDP_DROP, the page will be recycled immediately, whereas on
>> XDP_{TX,REDIRECT} it will go through the egress driver after sitting in
>> the bulk queue for a little while, so you can get reordering compared to
>> the original execution order.
>>
>> On XDP_PASS the kernel will release the page entirely from the pool when
>> building an skb, so you'll never see that particular page again (and
>> eventually page_pool will allocate a new batch that will be
>> re-initialised to the original value).
>
> That all makes sense. Thanks for explaining.
> Please document it and update the selftest.
> Looks like XDP_DROP is not tested.
> Single packet TX and REDIRECT is imo too weak to give
> confidence that the mechanism will not explode with millions of
> packets.

OK, will do.

>> If we do want to support a "pristine data" mode, I think the least
>> cumbersome way would be to add a flag that would make the kernel
>> re-initialise the packet data before every program invocation. The
>> reason I didn't do this was because I didn't have a use case for it. The
>> traffic generator use case only rewrites a tiny bit of the packet
>> header, and it's just as easy to just keep rewriting it without assuming
>> a particular previous value. And there's also the possibility of just
>> calling bpf_prog_run() multiple times from userspace with a lower number
>> of repetitions...
>>
>> I'm not opposed to adding such a flag if you think it would be useful,
>> though. WDYT?
>
> reinit doesn't feel necessary.
> How one would use this interface to send N different packets?
> The api provides an interface for only one.

By having the XDP program react appropriately. E.g., here is the XDP
program used by the trafficgen tool to cycle through UDP ports when
sending out the packets - it just reads the current value and updates
based on that, so it doesn't matter if it sees the initial page or one
it already modified:

const volatile __u16 port_start;
const volatile __u16 port_range;
volatile __u16 next_port =3D 0;

SEC("xdp")
int xdp_redirect_update_port(struct xdp_md *ctx)
{
	void *data_end =3D (void *)(long)ctx->data_end;
	void *data =3D (void *)(long)ctx->data;
	__u16 cur_port, cksum_diff;
	struct udphdr *hdr;

	hdr =3D data + (sizeof(struct ethhdr) + sizeof(struct ipv6hdr));
	if (hdr + 1 > data_end)
		return XDP_ABORTED;

	cur_port =3D bpf_ntohs(hdr->dest);
	cksum_diff =3D next_port - cur_port;
	if (cksum_diff) {
		hdr->check =3D bpf_htons(~(~bpf_ntohs(hdr->check) + cksum_diff));
		hdr->dest =3D bpf_htons(next_port);
	}
	if (next_port++ >=3D port_start + port_range - 1)
		next_port =3D port_start;

	return bpf_redirect(ifindex_out, 0);
}

You could do something similar with a whole packet header or payload; or
you could even populate a map with the full-size packets and copy that
in based on a counter.

> It will be copied 128 times, but the prog_run call with repeat=3D1
> will invoke bpf prog only once, right?
> So technically doing N prog_run commands with different data
> and repeat=3D1 will achieve the result, right?
> But it's not efficient, since 128 pages and 128 copies will be
> performed each time.
> May be there is a use case for configurable page_pool size?

Hmm, we could size the page_pool as min(repeat, 128) to avoid the extra
copies when they won't be used?

Another question seeing as the merge window is imminent: How do you feel
about merging this before the merge window? I can resubmit before it
opens with the updated selftest and documentation, and we can deal with
any tweaks during the -rcs; or would you rather postpone the whole
thing until the next cycle?

-Toke

