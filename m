Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3401D8BDC
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 01:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbgERXwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 19:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbgERXwp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 19:52:45 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3A20C061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 16:52:44 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id v4so9740568qte.3
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 16:52:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+vme55Nk9DOCLM9YnTliGrJP2klXCm4X/3Uu8Ue3yuI=;
        b=ua3/SeRBgzGQXFlW6F9t6nstq9QOxH415Y27La2CBQJCX0ghcjIu61DH7YneHnOA42
         F8T9tiRwVm1VFR61+Y01wOIqQJ17lrbvG4IFB0ZJGrzYBxiMBF2pfpV3SEOrl7EI/xQd
         bDJ27UqVRv5djuJvlj6XJifvBPnconXOlN9CgJRNLk06JIRGHATVmO+C04RyLRTHUnlA
         FTjQ6s+xgCeOeharp44p41BZ0ihV5ndR/79OGlgO/Bk4Bxv+60W+DZRIi7YlyYwiTqI3
         TV5oCOnv6wf0USUPNGzt3tmqJSf3L8eqUE/iYKrczSkM9H4Ovo9/X0ni4Ph/oiRD/K8s
         u3kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+vme55Nk9DOCLM9YnTliGrJP2klXCm4X/3Uu8Ue3yuI=;
        b=pJqWMCOOFgVxYAU3kjcfDukWCtrVGQDe1/d9tk7j1XT84C1d9nZQ4TaYGbVAm1+4+0
         6xBuShXfxYT57mBYEfFrd/WCZXyG6zoUbnY1sNm24OxhrnJ0sh2d78i1xAIb56LZo5tQ
         w4eKqceqMru6D9RV6wLsJDG20xhLiEF+HkJX8p7orHic/HGQhBICfNkRq596nucaShc7
         WkuCIeR3jiRtN3GtmGTQACd5PPdkv+FM+ITO3th9FWGiux5jNVdyPT0Dc1IyRo33KrDp
         DUJaWopzUm2A4qNfNyoe2NIzj7Y+jWrEMdpDcgvKEBipPI2yS2f2/YMnSqhOWFYYkks0
         QHYg==
X-Gm-Message-State: AOAM531pbpF0TuBkcTQB52ERizDIVmI3EHOzJqaLp20x/O3VrySCd8Ff
        4kI4cC4XQ5YP60IXMRyFNsY=
X-Google-Smtp-Source: ABdhPJwhXp8EuZMWP61Rt5lcYyXMgcUC0yQyvJob4yGfnpPYsx6oPveFDi0cWAl/d99Pek3wlsXh4g==
X-Received: by 2002:ac8:3ae6:: with SMTP id x93mr17943845qte.355.1589845964103;
        Mon, 18 May 2020 16:52:44 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:c5f3:7fed:e95c:6b74? ([2601:282:803:7700:c5f3:7fed:e95c:6b74])
        by smtp.googlemail.com with ESMTPSA id w14sm10498819qtt.82.2020.05.18.16.52.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2020 16:52:43 -0700 (PDT)
Subject: Re: [PATCH v5 bpf-next 00/11] net: Add support for XDP in egress path
To:     John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, brouer@redhat.com,
        daniel@iogearbox.net, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
References: <20200513014607.40418-1-dsahern@kernel.org>
 <87sgg4t8ro.fsf@toke.dk> <54fc70be-fce9-5fd2-79f3-b88317527c6b@gmail.com>
 <5ebf1d9cdc146_141a2acf80de25b892@john-XPS-13-9370.notmuch>
 <2148cc16-4988-5866-cb64-0a4f3d290a23@gmail.com>
 <5ec2cfa49a8d7_1c562afa67bea5b47c@john-XPS-13-9370.notmuch>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <cdd04862-dafd-080e-e90e-5161e568bac3@gmail.com>
Date:   Mon, 18 May 2020 17:52:41 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <5ec2cfa49a8d7_1c562afa67bea5b47c@john-XPS-13-9370.notmuch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/18/20 12:10 PM, John Fastabend wrote:
>>
>> host ingress to VM is one use case; VM to VM on the same host is another.
> 
> But host ingress to VM would still work with tail calls because the XDP
> packet came from another XDP program. At least that is how I understand
> it.
> 
> VM to VM case, again using tail calls on the sending VM ingress hook
> would work also.

understood. I realize I can attach the program array all around, I just
see that as complex control plane / performance hit depending on how the
programs are wired up.

>>
>> With respect to lifecycle management of the programs and the data,
>> putting VM specific programs and maps on VM specific taps simplifies
>> management. VM terminates, taps are deleted, programs and maps
>> disappear. So no validator thread needed to handle stray data / programs
>> from the inevitable cleanup problems when everything is lumped into 1
>> program / map or even array of programs and maps.
> 
> OK. Also presumably you already have a hook into this event to insert
> the tc filter programs so its probably a natural hook for mgmt.

For VMs there is no reason to have an skb at all, so no tc filter program.

> 
>>
>> To me the distributed approach is the simplest and best. The program on
>> the host nics can be stupid simple; no packet parsing beyond the
>> ethernet header. It's job is just a traffic demuxer very much like a
>> switch. All VM logic and data is local to the VM's interfaces.
> 
> IMO it seems more natural and efficient to use a tail call. But, I
> can see how if the ingress program is a l2/l3 switch and the VM hook
> is a l2/l3 filter it feels more like a switch+firewall layout we
> would normally use on a "real" (v)switch. Also I think the above point
> where cleanup is free because of the tap tear down is a win.

exactly. To the VM. the host is part of the network. The host should be
passing the packets as fast and as simply as possible from ingress nic
to vm. It can be done completely as xdp frames and doing so reduces the
CPU cycles per packet in the host (yes, there are caveats to that
statement).

VM to host nic, and VM to VM have their own challenges which need to be
tackled next.

But the end goal is to have all VM traffic touched by the host as xdp
frames and without creating a complex control plane. The distributed
approach is much simpler and cleaner - and seems to follow what Cilium
is doing to a degree, or that is my interpretation of

"By attaching to the TC ingress hook of the host side of this veth pair
Cilium can monitor and enforce policy on all traffic exiting a
container. By attaching a BPF program to the veth pair associated with
each container and routing all network traffic to the host side virtual
devices with another BPF program attached to the tc ingress hook as well
Cilium can monitor and enforce policy on all traffic entering or exiting
the node."

https://docs.cilium.io/en/v1.7/architecture/
