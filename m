Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9B739E763
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 14:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729491AbfH0MKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 08:10:38 -0400
Received: from www62.your-server.de ([213.133.104.62]:48712 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbfH0MKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 08:10:38 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1i2aJ2-00009a-HH; Tue, 27 Aug 2019 14:10:36 +0200
Received: from [2a02:120b:2c12:c120:71a0:62dd:894c:fd0e] (helo=pc-66.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1i2aJ2-0007ne-AJ; Tue, 27 Aug 2019 14:10:36 +0200
Subject: Re: BUG_ON in skb_segment, after bpf_skb_change_proto was applied
To:     Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        shmulik@metanetworks.com, eyal@metanetworks.com
References: <20190826170724.25ff616f@pixies>
 <94cd6f4d-09d4-11c0-64f4-bdc544bb3dcb@gmail.com>
 <20190827144218.5b098eac@pixies>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <88a3da53-fecc-0d8c-56dc-a4c3b0e11dfd@iogearbox.net>
Date:   Tue, 27 Aug 2019 14:10:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190827144218.5b098eac@pixies>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25554/Tue Aug 27 10:24:33 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/27/19 1:42 PM, Shmulik Ladkani wrote:
[...]
> - Another thing that puzzles me is that we hit the BUG_ON rather rarely
>    and cannot yet reproduce synthetically. If skb_segment's handling of
>    skbs with a frag_list (that have gso_size mangled) is broken, I'd expect
>    to hit this more often... Any ideas?
> 
> - Suppose going for a rewrite, care to elaborate what's exactly missing
>    in skb_segment's logic?
>    I must admit I do not fully understand all the different code flows in
>    this function, it seems to support many different input skbs - any
>    assistance is highly appreciated.

Given first point above wrt hitting rarely, it would be good to first get a
better understanding for writing a reproducer. Back then Yonghong added one
to the BPF kernel test suite [0], so it would be desirable to extend it for
the case you're hitting. Given NAT64 use-case is needed and used by multiple
parties, we should try to (fully) fix it generically.

Thanks,
Daniel

   [0] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=76db8087c4c991dcd17f5ea8ac0eafd0696ab450

> Shmulik
> 

