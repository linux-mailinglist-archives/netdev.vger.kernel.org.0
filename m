Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21241E6B5D
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 04:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbfJ1DQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Oct 2019 23:16:48 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:38419 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726711AbfJ1DQr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Oct 2019 23:16:47 -0400
Received: by mail-io1-f66.google.com with SMTP id u8so9097076iom.5;
        Sun, 27 Oct 2019 20:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aqAqtrPtaQ6SOYmf4+7ZtG8UMxXeG76gJLsRBVsOpfY=;
        b=kJkeQLjgwySWAlgE8Q5Gbq/6tuaBeAA1QvXD3s0dmIEz8BS99gduUlmUgQyZCmprN8
         S0NladyzZwKaQBZfcAn08zwj00XMhISXvUMLlmTk6JGYeivb84UEfsPFLbJNPtxJ5NlX
         iTqWz9B4A5kuM0QNu1Y9yGtVUTpW+Lj4RP030YoSIf6J6kdfhspZ3TjYGZpFvWEtjkxP
         62SUtI44rtbOHACsTWLjDABmunBSBcpi4MAbYXwouUoAGXBmZGxK8/ivgK8QjTDa2oki
         VAyFwGgLoGAVm9fGVh7qqOafa6T8n8tVgjmNqHY4o0U08IO4WwDnOKocT/2tJcqdx4W2
         VgOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aqAqtrPtaQ6SOYmf4+7ZtG8UMxXeG76gJLsRBVsOpfY=;
        b=bcHD1ffQ/KKgS2QZk+nnHiQ3ok0FLYQcKcMLY8FddBZmKff3AXe77RqUzagX03BklZ
         ndigo3mannOTpHezOBE2WP8QBoiPUp8ES0pc3Nltn0npB6+oxjbc+JNyZJ8ibOKaHfzZ
         15ilJw1GbZkj5EBq16CqOXy6hbNKaD3xKmJpuwFixRtKVHuvS8qRFvl9f3OTEjm/TQTz
         jGcKjMOVj9mYk58NSIGoYeZBOAwOf/NOawclypMujsXOzDoVY3SrYQxYNr9UreSx21/G
         XLNK1J98hKCwq3jgT4L+pOoWoAcRKlUa1VugdEVh1kmmW6gmfPZUp515I02HiM1DbWJ+
         krrg==
X-Gm-Message-State: APjAAAX7c3RaqdJ/RIvTmhoquavqYvreEXU6tU+aGpPyVd/3Hgqv588z
        UpcGhiQChVZKHIKnAKnf+Hk=
X-Google-Smtp-Source: APXvYqwpz/txjnYaIF2QPrUDMnRkFRB0pWdNykXTjbHChVA+/IutmJCkl6OPT+7RgTuNLBGHHPiIJw==
X-Received: by 2002:a5e:d707:: with SMTP id v7mr16397874iom.226.1572232605632;
        Sun, 27 Oct 2019 20:16:45 -0700 (PDT)
Received: from dahern-DO-MB.local ([2601:284:8202:10b0:9e2:b1b6:1e7e:b71e])
        by smtp.googlemail.com with ESMTPSA id f25sm1305021ila.71.2019.10.27.20.16.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 27 Oct 2019 20:16:44 -0700 (PDT)
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
 <87zhhmrz7w.fsf@toke.dk>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <47f1a7e2-0d3a-e324-20c5-ba3aed216ddf@gmail.com>
Date:   Sun, 27 Oct 2019 21:16:42 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <87zhhmrz7w.fsf@toke.dk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/27/19 9:21 AM, Toke Høiland-Jørgensen wrote:
> Rather, what we should be doing is exposing the functionality through
> helpers so XDP can hook into the data structures already present in the
> kernel and make decisions based on what is contained there. We already
> have that for routing; L2 bridging, and some kind of connection
> tracking, are obvious contenders for similar additions.

The way OVS is coded and expected to flow (ovs_vport_receive ->
ovs_dp_process_packet -> ovs_execute_actions -> do_execute_actions) I do
not see any way to refactor it to expose a hook to XDP. But, if the use
case is not doing anything big with OVS (e.g., just ACLs and forwarding)
that is easy to replicate in XDP - but then that means duplicate data
and code.

Linux bridge on the other hand seems fairly straightforward to refactor.
One helper is needed to convert ingress <port,mac,vlan> to an L2 device
(and needs to consider stacked devices) and then a second one to access
the fdb for that device.

Either way, bypassing the bridge has mixed results: latency improves but
throughput takes a hit (no GRO).
