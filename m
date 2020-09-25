Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E79E8278CDF
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 17:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729141AbgIYPf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 11:35:58 -0400
Received: from www62.your-server.de ([213.133.104.62]:50646 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726990AbgIYPf6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 11:35:58 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kLplL-0007eW-Sb; Fri, 25 Sep 2020 17:35:55 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kLplL-000UEH-NU; Fri, 25 Sep 2020 17:35:55 +0200
Subject: Re: [PATCH bpf-next 1/6] bpf: add classid helper only based on
 skb->sk
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     ast@kernel.org, john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <cover.1600967205.git.daniel@iogearbox.net>
 <2e761d23d591a9536eaa3ecd4be8d78c99f00964.1600967205.git.daniel@iogearbox.net>
 <20200925074620.4ad50dcc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <13e379a3-11d9-3c38-4f0e-13b181189209@iogearbox.net>
Date:   Fri, 25 Sep 2020 17:35:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200925074620.4ad50dcc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25938/Fri Sep 25 15:54:20 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/25/20 4:46 PM, Jakub Kicinski wrote:
> On Thu, 24 Sep 2020 20:21:22 +0200 Daniel Borkmann wrote:
>> Similarly to 5a52ae4e32a6 ("bpf: Allow to retrieve cgroup v1 classid
>> from v2 hooks"), add a helper to retrieve cgroup v1 classid solely
>> based on the skb->sk, so it can be used as key as part of BPF map
>> lookups out of tc from host ns, in particular given the skb->sk is
>> retained these days when crossing net ns thanks to 9c4c325252c5
>> ("skbuff: preserve sock reference when scrubbing the skb."). This
>> is similar to bpf_skb_cgroup_id() which implements the same for v2.
>> Kubernetes ecosystem is still operating on v1 however, hence net_cls
>> needs to be used there until this can be dropped in with the v2
>> helper of bpf_skb_cgroup_id().
>>
>> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> 
> FWIW lot's of whitespace warnings from checkpatch --strict about
> comments having spaces before tabs here.

Expected given the way the UAPI helper comment is formatted / done in
order to then render the man page. So it's formatted the same way as
the other helper descriptions.

Thanks,
Daniel
