Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3B53E78EA
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 20:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729580AbfJ1TGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 15:06:01 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38207 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727664AbfJ1TGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 15:06:01 -0400
Received: by mail-pg1-f195.google.com with SMTP id w3so7531188pgt.5;
        Mon, 28 Oct 2019 12:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5h2PU41fFxWFYJuJOkyzXIIJnTs6zaZYKkn4ZROqqSg=;
        b=p+EX8RYWhBQKAKVmJCQ5zKWxGxvgDpwT2DQ/rdk5UHQ6H8W2HM4cPLmlyTTt4q7W9B
         eqo3MBW9yacRFdTkdUiLPhPpavaqAhVdKdEWXYC/mObwQjiK6cTvoP2Xwt1NcGrjjXWm
         J+LneOHvwuKPL7cW29rXA8zcdXl93Cb3/OcOvw5VxwO87s+CNsVSj84C22Wqf/1+TVym
         b538n84c1TmoctrmSX3qpDuRmpZeOOb1OX3xfzO33P7HuEeYoUTqNkKu3N21qWusbCEE
         duQu/2/MUNVprBDAYgGrjjB0RhgrTaoGZJmqQcKT2BbC930IeRUGUpYuIpLAoKSnrWhB
         gSUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5h2PU41fFxWFYJuJOkyzXIIJnTs6zaZYKkn4ZROqqSg=;
        b=ZTGsLQVzKgYaAhEiQU7T11+zeMEG+v3YsuoCIpJMb1ZoObwdR/GJ+WDkyWaEGXcQna
         b1/o9xlrv8sAT4A1WxYDLCfC320DFA2afyWUV6HXKGZQVuFBKtzBNYUCtOCBNzloWUh6
         RXvQhGeYcUWq9m6oB32H/KZicIlSOAg1NladH9lZt4UuushIRKqBysXgmZ4//mwNMp3u
         PoSAMKuB4xUBxKMqYVjJtRLpZKdiDDRAyKIl26eYpA39rAs87NqobN4L0fJxVwPlbjvu
         DcFtZfXKFx4vLxnpjeJ4o2C5xiRtHO9S4Opi2DIZfDnUTudasgwINWRpPniVUSMDGaeo
         oXNw==
X-Gm-Message-State: APjAAAU2laEzOrffPnv0adkRxxlr+zggJ+N3R0lc6/N4lFsVAXos/7nR
        9nem9FFERhVSTDNWsD0thp0=
X-Google-Smtp-Source: APXvYqwu3nA2QMraZIgSQyihZMGbtrLDRa8knzEtR1m5gcL2PG6adcebntoSLXqcMLxi6CmHQKecVg==
X-Received: by 2002:aa7:8210:: with SMTP id k16mr22125721pfi.84.1572289560396;
        Mon, 28 Oct 2019 12:06:00 -0700 (PDT)
Received: from dahern-DO-MB.local ([2601:284:8202:10b0:9e2:b1b6:1e7e:b71e])
        by smtp.googlemail.com with ESMTPSA id t15sm7159414pfh.31.2019.10.28.12.05.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Oct 2019 12:05:59 -0700 (PDT)
Subject: Re: [RFC PATCH v2 bpf-next 00/15] xdp_flow: Flow offload to XDP
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Pravin B Shelar <pshelar@ovn.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        William Tu <u9012063@gmail.com>,
        Stanislav Fomichev <sdf@fomichev.me>
References: <20191018040748.30593-1-toshiaki.makita1@gmail.com>
 <5da9d8c125fd4_31cf2adc704105c456@john-XPS-13-9370.notmuch>
 <22e6652c-e635-4349-c863-255d6c1c548b@gmail.com>
 <5daf34614a4af_30ac2b1cb5d205bce4@john-XPS-13-9370.notmuch>
 <87h840oese.fsf@toke.dk>
 <5db128153c75_549d2affde7825b85e@john-XPS-13-9370.notmuch>
 <87sgniladm.fsf@toke.dk> <a7f3d86b-c83c-7b0d-c426-684b8dfe4344@gmail.com>
 <87zhhmrz7w.fsf@toke.dk> <47f1a7e2-0d3a-e324-20c5-ba3aed216ddf@gmail.com>
 <87o8y1s1vn.fsf@toke.dk>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e6fb6738-429d-d8bf-0380-eeb2ff4735dc@gmail.com>
Date:   Mon, 28 Oct 2019 13:05:56 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <87o8y1s1vn.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/28/19 2:36 AM, Toke Høiland-Jørgensen wrote:
> 
>> Linux bridge on the other hand seems fairly straightforward to
>> refactor. One helper is needed to convert ingress <port,mac,vlan> to
>> an L2 device (and needs to consider stacked devices) and then a second
>> one to access the fdb for that device.
> 
> Why not just a single lookup like what you did for routing? Not too
> familiar with the routing code...

The current code for routing only works for forwarding across ports
without vlans or other upper level devices. That is a very limited use
case and needs to be extended for VLANs and bonds (I have a POC for both).

The API is setup for the extra layers:

struct bpf_fib_lookup {
    ...
    /* input: L3 device index for lookup
     * output: device index from FIB lookup
     */
    __u32   ifindex;
   ...

For bridging, certainly step 1 is the same - define a bpf_fdb_lookup
struct and helper that takes on L2 device index and returns a
<port,vlan> pair.

However, this thread is about bridging with VMs / containers. A viable
solution for this use case MUST handle both vlans and bonds.
