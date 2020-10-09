Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3AC288F26
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 18:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389876AbgJIQrs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 12:47:48 -0400
Received: from www62.your-server.de ([213.133.104.62]:56524 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389431AbgJIQrs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 12:47:48 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kQvYY-00055y-Kr; Fri, 09 Oct 2020 18:47:46 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kQvYY-0002ZS-BB; Fri, 09 Oct 2020 18:47:46 +0200
Subject: Re: [PATCH bpf-next V3 4/6] bpf: make it possible to identify BPF
 redirected SKBs
To:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com
References: <160216609656.882446.16642490462568561112.stgit@firesoul>
 <160216615767.882446.7384364280837100311.stgit@firesoul>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <40d7af61-6840-5473-79d7-ea935f6889f4@iogearbox.net>
Date:   Fri, 9 Oct 2020 18:47:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <160216615767.882446.7384364280837100311.stgit@firesoul>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25952/Fri Oct  9 15:52:40 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/8/20 4:09 PM, Jesper Dangaard Brouer wrote:
> This change makes it possible to identify SKBs that have been redirected
> by TC-BPF (cls_act). This is needed for a number of cases.
> 
> (1) For collaborating with driver ifb net_devices.
> (2) For avoiding starting generic-XDP prog on TC ingress redirect.
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

Not sure if anyone actually cares about ifb devices, but my worry is that the
generic XDP vs tc interaction has been as-is for quite some time so this change
in behavior could break in the wild.
