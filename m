Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96A5E1EEC78
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 22:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730063AbgFDUxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 16:53:54 -0400
Received: from www62.your-server.de ([213.133.104.62]:45388 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729582AbgFDUxx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 16:53:53 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jgwrq-0003cj-HJ; Thu, 04 Jun 2020 22:53:38 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jgwrq-00093o-1k; Thu, 04 Jun 2020 22:53:38 +0200
Subject: Re: [PATCH bpf v2] bpf: fix unused-var without NETDEVICES
To:     Song Liu <song@kernel.org>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>, fejes@inf.elte.hu,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
References: <CAADnVQ+k7+fQmuNQL=GLLaGUvd5+zZN6GViy-oP7Sfq7aQVG1Q@mail.gmail.com>
 <20200603190347.2310320-1-matthieu.baerts@tessares.net>
 <CAPhsuW6HtiLQdvyK8tHEH80xeurvQqdaYpFgdhd=yb5hDkB7VA@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <94837ee2-3dcc-41ef-e932-0c6d1285156d@iogearbox.net>
Date:   Thu, 4 Jun 2020 22:53:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAPhsuW6HtiLQdvyK8tHEH80xeurvQqdaYpFgdhd=yb5hDkB7VA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25833/Thu Jun  4 14:45:29 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/3/20 10:45 PM, Song Liu wrote:
> On Wed, Jun 3, 2020 at 12:05 PM Matthieu Baerts
> <matthieu.baerts@tessares.net> wrote:
>>
>> A recent commit added new variables only used if CONFIG_NETDEVICES is
>> set. A simple fix would be to only declare these variables if the same
>> condition is valid but Alexei suggested an even simpler solution:
>>
>>      since CONFIG_NETDEVICES doesn't change anything in .h I think the
>>      best is to remove #ifdef CONFIG_NETDEVICES from net/core/filter.c
>>      and rely on sock_bindtoindex() returning ENOPROTOOPT in the extreme
>>      case of oddly configured kernels.
>>
>> Fixes: 70c58997c1e8 ("bpf: Allow SO_BINDTODEVICE opt in bpf_setsockopt")
>> Suggested-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
>> Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> 
> Acked-by: Song Liu <songliubraving@fb.com>

Applied, thanks!
