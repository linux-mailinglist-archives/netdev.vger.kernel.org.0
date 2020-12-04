Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD9112CF6B3
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 23:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgLDWUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 17:20:49 -0500
Received: from www62.your-server.de ([213.133.104.62]:36586 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgLDWUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 17:20:49 -0500
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1klJQi-0000Ap-GR; Fri, 04 Dec 2020 23:19:56 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1klJQi-000WQ1-4q; Fri, 04 Dec 2020 23:19:56 +0100
Subject: Re: [PATCH v2 bpf 1/5] net: ethtool: add xdp properties flag set
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     alardam@gmail.com, magnus.karlsson@intel.com,
        bjorn.topel@intel.com, andrii.nakryiko@gmail.com, kuba@kernel.org,
        ast@kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        john.fastabend@gmail.com, hawk@kernel.org,
        jonathan.lemon@gmail.com, bpf@vger.kernel.org,
        jeffrey.t.kirsher@intel.com, maciejromanfijalkowski@gmail.com,
        intel-wired-lan@lists.osuosl.org,
        Marek Majtyka <marekx.majtyka@intel.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
References: <20201204102901.109709-1-marekx.majtyka@intel.com>
 <20201204102901.109709-2-marekx.majtyka@intel.com> <878sad933c.fsf@toke.dk>
 <20201204124618.GA23696@ranger.igk.intel.com>
 <048bd986-2e05-ee5b-2c03-cd8c473f6636@iogearbox.net> <87pn3p7aiv.fsf@toke.dk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <eb305a4f-c189-6b32-f718-6e709ef0fa55@iogearbox.net>
Date:   Fri, 4 Dec 2020 23:19:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <87pn3p7aiv.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26007/Thu Dec  3 14:13:31 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/4/20 6:20 PM, Toke Høiland-Jørgensen wrote:
> Daniel Borkmann <daniel@iogearbox.net> writes:
[...]
>> We tried to standardize on a minimum guaranteed amount, but unfortunately not
>> everyone seems to implement it, but I think it would be very useful to query
>> this from application side, for example, consider that an app inserts a BPF
>> prog at XDP doing custom encap shortly before XDP_TX so it would be useful to
>> know which of the different encaps it implements are realistically possible on
>> the underlying XDP supported dev.
> 
> How many distinct values are there in reality? Enough to express this in
> a few flags (XDP_HEADROOM_128, XDP_HEADROOM_192, etc?), or does it need
> an additional field to get the exact value? If we implement the latter
> we also run the risk of people actually implementing all sorts of weird
> values, whereas if we constrain it to a few distinct values it's easier
> to push back against adding new values (as it'll be obvious from the
> addition of new flags).

It's not everywhere straight forward to determine unfortunately, see also [0,1]
as some data points where Jesper looked into in the past, so in some cases it
might differ depending on the build/runtime config..

   [0] https://lore.kernel.org/bpf/158945314698.97035.5286827951225578467.stgit@firesoul/
   [1] https://lore.kernel.org/bpf/158945346494.97035.12809400414566061815.stgit@firesoul/
