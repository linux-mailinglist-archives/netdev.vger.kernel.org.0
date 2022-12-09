Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF376647D3A
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 06:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbiLIFYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 00:24:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiLIFYo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 00:24:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 561C872870;
        Thu,  8 Dec 2022 21:24:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12297B827A3;
        Fri,  9 Dec 2022 05:24:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 905B4C433F0;
        Fri,  9 Dec 2022 05:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670563480;
        bh=l6X9ReiMPyE+az/ynxYJ+y9nV9wLSGN0chZF99FBGHg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nUshCn7fke74bdCIOhWKHo4xqPceq5KzthQGVZBydqTtNiRjxafSWCyi+EX0IpUS1
         vYNHTLMxcSeZWu1aqDSlXniOHwN75xFyRsU2yl4zxMpsI38+HjiiBsY2Q8pH+ScVdr
         oZ5+VnloW24/Nngn8/LrLuIDvHJKb0FFd1H2W0jKg/roAU4cFI1zgUT5nohR8y9udM
         s1/Y8T5uCzm1jRumurB3sieCJuEbncFqIWBZmj/TnmxIRZuS7km84rBwK8HRuTQCsQ
         tT2lkGc33dww2CvoPKDCUy15z0+aDY6oGCecrXzH+xefgT6/P6wn38vD9q+KVdousS
         oYnGAxgOG3vcQ==
Date:   Thu, 8 Dec 2022 21:24:38 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [xdp-hints] Re: [PATCH bpf-next v3 11/12] mlx5: Support RX XDP
 metadata
Message-ID: <Y5LGlgpxpzSu701h@x130>
References: <20221206024554.3826186-1-sdf@google.com>
 <20221206024554.3826186-12-sdf@google.com>
 <875yellcx6.fsf@toke.dk>
 <CAKH8qBv7nWdknuf3ap_ekpAhMgvtmoJhZ3-HRuL8Wv70SBWMSQ@mail.gmail.com>
 <87359pl9zy.fsf@toke.dk>
 <CAADnVQ+=71Y+ypQTOgFTJWY7w3YOUdY39is4vpo3aou11=eMmw@mail.gmail.com>
 <87tu25ju77.fsf@toke.dk>
 <CAADnVQ+MyE280Q-7iw2Y-P6qGs4xcDML-tUrXEv_EQTmeESVaQ@mail.gmail.com>
 <87o7sdjt20.fsf@toke.dk>
 <CAKH8qBswBu7QAWySWOYK4X41mwpdBj0z=6A9WBHjVYQFq9Pzjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKH8qBswBu7QAWySWOYK4X41mwpdBj0z=6A9WBHjVYQFq9Pzjw@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08 Dec 18:57, Stanislav Fomichev wrote:
>On Thu, Dec 8, 2022 at 4:54 PM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>>
>> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>>
>> > On Thu, Dec 8, 2022 at 4:29 PM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>> >>
>> >> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>> >>
>> >> > On Thu, Dec 8, 2022 at 4:02 PM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>> >> >>
>> >> >> Stanislav Fomichev <sdf@google.com> writes:
>> >> >>
>> >> >> > On Thu, Dec 8, 2022 at 2:59 PM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>> >> >> >>
>> >> >> >> Stanislav Fomichev <sdf@google.com> writes:
>> >> >> >>
>> >> >> >> > From: Toke Høiland-Jørgensen <toke@redhat.com>
>> >> >> >> >
>> >> >> >> > Support RX hash and timestamp metadata kfuncs. We need to pass in the cqe
>> >> >> >> > pointer to the mlx5e_skb_from* functions so it can be retrieved from the
>> >> >> >> > XDP ctx to do this.
>> >> >> >>
>> >> >> >> So I finally managed to get enough ducks in row to actually benchmark
>> >> >> >> this. With the caveat that I suddenly can't get the timestamp support to
>> >> >> >> work (it was working in an earlier version, but now
>> >> >> >> timestamp_supported() just returns false). I'm not sure if this is an
>> >> >> >> issue with the enablement patch, or if I just haven't gotten the
>> >> >> >> hardware configured properly. I'll investigate some more, but figured
>> >> >> >> I'd post these results now:
>> >> >> >>
>> >> >> >> Baseline XDP_DROP:         25,678,262 pps / 38.94 ns/pkt
>> >> >> >> XDP_DROP + read metadata:  23,924,109 pps / 41.80 ns/pkt
>> >> >> >> Overhead:                   1,754,153 pps /  2.86 ns/pkt
>> >> >> >>
>> >> >> >> As per the above, this is with calling three kfuncs/pkt
>> >> >> >> (metadata_supported(), rx_hash_supported() and rx_hash()). So that's
>> >> >> >> ~0.95 ns per function call, which is a bit less, but not far off from
>> >> >> >> the ~1.2 ns that I'm used to. The tests where I accidentally called the
>> >> >> >> default kfuncs cut off ~1.3 ns for one less kfunc call, so it's
>> >> >> >> definitely in that ballpark.
>> >> >> >>
>> >> >> >> I'm not doing anything with the data, just reading it into an on-stack
>> >> >> >> buffer, so this is the smallest possible delta from just getting the
>> >> >> >> data out of the driver. I did confirm that the call instructions are
>> >> >> >> still in the BPF program bytecode when it's dumped back out from the
>> >> >> >> kernel.
>> >> >> >>
>> >> >> >> -Toke
>> >> >> >>
>> >> >> >
>> >> >> > Oh, that's great, thanks for running the numbers! Will definitely
>> >> >> > reference them in v4!
>> >> >> > Presumably, we should be able to at least unroll most of the
>> >> >> > _supported callbacks if we want, they should be relatively easy; but
>> >> >> > the numbers look fine as is?
>> >> >>
>> >> >> Well, this is for one (and a half) piece of metadata. If we extrapolate
>> >> >> it adds up quickly. Say we add csum and vlan tags, say, and maybe
>> >> >> another callback to get the type of hash (l3/l4). Those would probably
>> >> >> be relevant for most packets in a fairly common setup. Extrapolating
>> >> >> from the ~1 ns/call figure, that's 8 ns/pkt, which is 20% of the
>> >> >> baseline of 39 ns.
>> >> >>
>> >> >> So in that sense I still think unrolling makes sense. At least for the
>> >> >> _supported() calls, as eating a whole function call just for that is
>> >> >> probably a bit much (which I think was also Jakub's point in a sibling
>> >> >> thread somewhere).
>> >> >
>> >> > imo the overhead is tiny enough that we can wait until
>> >> > generic 'kfunc inlining' infra is ready.
>> >> >
>> >> > We're planning to dual-compile some_kernel_file.c
>> >> > into native arch and into bpf arch.
>> >> > Then the verifier will automatically inline bpf asm
>> >> > of corresponding kfunc.
>> >>
>> >> Is that "planning" or "actively working on"? Just trying to get a sense
>> >> of the time frames here, as this sounds neat, but also something that
>> >> could potentially require quite a bit of fiddling with the build system
>> >> to get to work? :)
>> >
>> > "planning", but regardless how long it takes I'd rather not
>> > add any more tech debt in the form of manual bpf asm generation.
>> > We have too much of it already: gen_lookup, convert_ctx_access, etc.
>>
>> Right, I'm no fan of the manual ASM stuff either. However, if we're
>> stuck with the function call overhead for the foreseeable future, maybe
>> we should think about other ways of cutting down the number of function
>> calls needed?
>>
>> One thing I can think of is to get rid of the individual _supported()
>> kfuncs and instead have a single one that lets you query multiple
>> features at once, like:
>>
>> __u64 features_supported, features_wanted = XDP_META_RX_HASH | XDP_META_TIMESTAMP;
>>
>> features_supported = bpf_xdp_metadata_query_features(ctx, features_wanted);
>>
>> if (features_supported & XDP_META_RX_HASH)
>>   hash = bpf_xdp_metadata_rx_hash(ctx);
>>
>> ...etc
>
>I'm not too happy about having the bitmasks tbh :-(
>If we want to get rid of the cost of those _supported calls, maybe we
>can do some kind of libbpf-like probing? That would require loading a
>program + waiting for some packet though :-(
>
>Or maybe they can just be cached for now?
>
>if (unlikely(!got_first_packet)) {
>  have_hash = bpf_xdp_metadata_rx_hash_supported();
>  have_timestamp = bpf_xdp_metadata_rx_timestamp_supported();
>  got_first_packet = true;
>}

hash/timestap/csum is per packet .. vlan as well depending how you look at
it..

Sorry I haven't been following the progress of xdp meta data, but why did
we drop the idea of btf and driver copying metdata in front of the xdp
frame ?

hopefully future HW generations will do that for free .. 

if btf is the problem then each vendor can provide a bpf func(s) that would
parse the metdata inside of the xdp/bpf prog domain to help programs
extract the vendor specific data.. 


>
>if (have_hash) {}
>if (have_timestamp) {}
>
>That should hopefully work until generic inlining infra?
>
>> -Toke
>>
