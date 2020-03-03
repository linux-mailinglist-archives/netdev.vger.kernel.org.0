Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45440178484
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 22:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732262AbgCCVFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 16:05:08 -0500
Received: from www62.your-server.de ([213.133.104.62]:39888 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729880AbgCCVFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 16:05:08 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1j9Eim-00068r-G7; Tue, 03 Mar 2020 22:04:56 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1j9Eim-000Iju-3A; Tue, 03 Mar 2020 22:04:56 +0100
Subject: Re: [PATCH v4] netdev attribute to control xdpgeneric skb
 linearization
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Luigi Rizzo <lrizzo@google.com>,
        Network Development <netdev@vger.kernel.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        David Miller <davem@davemloft.net>, hawk@kernel.org,
        "Jubran, Samih" <sameehj@amazon.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, ast@kernel.org,
        bpf@vger.kernel.org
References: <20200228105435.75298-1-lrizzo@google.com>
 <20200228110043.2771fddb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CA+FuTSfd80pZroxtqZDsTeEz4FaronC=pdgjeaBBfYqqi5HiyQ@mail.gmail.com>
 <3c27d9c0-eb17-b20f-2d10-01f3bdf8c0d6@iogearbox.net>
 <20200303125020.2baef01b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <abe8f703-d239-2444-99a0-c94dd53f478a@iogearbox.net>
Date:   Tue, 3 Mar 2020 22:04:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200303125020.2baef01b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25740/Tue Mar  3 13:12:16 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/3/20 9:50 PM, Jakub Kicinski wrote:
> On Tue, 3 Mar 2020 20:46:55 +0100 Daniel Borkmann wrote:
>> Thus, when the data/data_end test fails in generic XDP, the user can
>> call e.g. bpf_xdp_pull_data(xdp, 64) to make sure we pull in as much as
>> is needed w/o full linearization and once done the data/data_end can be
>> repeated to proceed. Native XDP will leave xdp->rxq->skb as NULL, but
>> later we could perhaps reuse the same bpf_xdp_pull_data() helper for
>> native with skb-less backing. Thoughts?
> 
> I'm curious why we consider a xdpgeneric-only addition. Is attaching
> a cls_bpf program noticeably slower than xdpgeneric?

Yeah, agree, I'm curious about that part as well.

Thanks,
Daniel
