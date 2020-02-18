Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9F6163711
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 00:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbgBRXTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 18:19:47 -0500
Received: from www62.your-server.de ([213.133.104.62]:60420 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727862AbgBRXTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 18:19:47 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1j4C9Q-0001k5-Vl; Wed, 19 Feb 2020 00:19:37 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1j4C9Q-000D8S-Jm; Wed, 19 Feb 2020 00:19:36 +0100
Subject: Re: [RFC net-next] net: mvneta: align xdp stats naming scheme to mlx5
 driver
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, ilias.apalodimas@linaro.org,
        davem@davemloft.net, lorenzo.bianconi@redhat.com, andrew@lunn.ch,
        brouer@redhat.com, dsahern@kernel.org, bpf@vger.kernel.org
References: <526238d9bcc60500ed61da1a4af8b65af1af9583.1581984697.git.lorenzo@kernel.org>
 <20200218132921.46df7f8b@kicinski-fedora-PC1C0HJN> <87eeury1ph.fsf@toke.dk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <703ce998-e454-713c-fc7a-d5f1609146d8@iogearbox.net>
Date:   Wed, 19 Feb 2020 00:19:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <87eeury1ph.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.1/25727/Tue Feb 18 15:05:00 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/18/20 11:23 PM, Toke Høiland-Jørgensen wrote:
> Jakub Kicinski <kuba@kernel.org> writes:
>> On Tue, 18 Feb 2020 01:14:29 +0100 Lorenzo Bianconi wrote:
>>> Introduce "rx" prefix in the name scheme for xdp counters
>>> on rx path.
>>> Differentiate between XDP_TX and ndo_xdp_xmit counters
>>>
>>> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>>
>> Sorry for coming in late.
>>
>> I thought the ability to attach a BPF program to a fexit of another BPF
>> program will put an end to these unnecessary statistics. IOW I maintain
>> my position that there should be no ethtool stats for XDP.
>>
>> As discussed before real life BPF progs will maintain their own stats
>> at the granularity of their choosing, so we're just wasting datapath
>> cycles.

+1

>> The previous argument that the BPF prog stats are out of admin control
>> is no longer true with the fexit option (IIUC how that works).
> 
> So you're proposing an admin that wants to keep track of XDP has to
> (permantently?) attach an fexit program to every running XDP program and
> use that to keep statistics? But presumably he'd first need to discover
> that XDP is enabled; which the ethtool stats is a good hint for :)

Doesn't iproute2 clearly show that already via `ip l` that XDP is attached?
