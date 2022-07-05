Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE39D56775B
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 21:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbiGETJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 15:09:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbiGETJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 15:09:08 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403C515FE8;
        Tue,  5 Jul 2022 12:09:07 -0700 (PDT)
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1o8nuc-000GK3-BY; Tue, 05 Jul 2022 21:08:42 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1o8nub-000Vkd-MV; Tue, 05 Jul 2022 21:08:41 +0200
Subject: Re: [xdp-hints] Re: [PATCH RFC bpf-next 00/52] bpf, xdp: introduce
 and use Generic Hints/metadata
To:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        brouer@redhat.com, John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Yajun Deng <yajun.deng@linux.dev>,
        Willem de Bruijn <willemb@google.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xdp-hints@xdp-project.net
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
 <62bbedf07f44a_2181420830@john.notmuch> <87iloja8ly.fsf@toke.dk>
 <20220704154440.7567-1-alexandr.lobakin@intel.com>
 <0cd3fd67-e179-7c27-a74f-255a05359941@redhat.com>
 <20220705143838.19500-1-alexandr.lobakin@intel.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <dac999ed-be85-1e3b-138c-d31ef674d5d9@iogearbox.net>
Date:   Tue, 5 Jul 2022 21:08:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220705143838.19500-1-alexandr.lobakin@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26594/Tue Jul  5 09:24:14 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/5/22 4:38 PM, Alexander Lobakin wrote:
> From: Jesper Dangaard Brouer <jbrouer@redhat.com>
> Date: Mon, 4 Jul 2022 19:13:53 +0200
[...]
>> I have looked at the code in your GitHub tree, and decided that it was
>> an over-engineered approach IMHO.  Also simply being 52 commits deep
>> without having posted this incrementally upstream were also a
>> non-starter for me, as this isn't the way-to-work upstream.
> 
> So Ingo announced recently that he has a series of 2300+ patches
> to try to fix include hell. Now he's preparing to submit them by
> batches/series. Look at this RFC as at an announce. "Hey folks,
> I have a bunch of stuff and will be submitting it soon, but I'm
> posting the whole changeset here, so you could take a look or
> give it a try before it's actually started being posted".
> All this is mentioned in the cover letter as well. What is the
> problem? Ok, next time I can not do any announces and just start
> posting series if it made such misunderstandings.

I would suggest to please calm down first. No offense, but above example
with the 2300+ patches is not a great one. There is no way any mortal
would be able to review them, not even thinking about the cycles spent
around rebasing, merge conflict resolution or bugs they may contain.
Anyway, that aside..

Your series essentially starts out with ...

   The series adds ability to pass different frame
   details/parameters/parameters used by most of NICs and the kernel
   stack (in skbs), not essential, but highly wanted, such as:

   * checksum value, status (Rx) or command (Tx);
   * hash value and type/level (Rx);
   * queue number (Rx);
   * timestamps;
   * and so on.

... so my initial question would be whether in this context there has
been done research / analysis of how this can speed up /real world/
production applications such as Katran L4LB [0], for example? What is
the speedup you observed with it by utilizing the fields from meta data?

Thanks,
Daniel

   [0] https://github.com/facebookincubator/katran
