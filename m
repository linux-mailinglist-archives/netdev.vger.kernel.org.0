Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57A6117C514
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 19:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbgCFSJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 13:09:30 -0500
Received: from mail-qv1-f67.google.com ([209.85.219.67]:42448 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgCFSJ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 13:09:29 -0500
Received: by mail-qv1-f67.google.com with SMTP id e7so1348538qvy.9;
        Fri, 06 Mar 2020 10:09:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XqmnoWxGYhvRpRQvm/LkWgDTT6TYNcRDSo11h7efasM=;
        b=RpP2n3g+oikJ67LYVOGABCmUvu+JMh7r+aEY0xbxhxemGd53Wo+//7CpgWvarUCiQm
         PgV7dvZhAMg5i4pkon7sZ9xubxNej2S0WzWVfq06UGeOhgftiOspWXkecyFezhLn8ndV
         E8J9lUTeWdMq+Jjr4PwVhyWveo5KVQVA1ZDd/Xr43XwaGKIn9DP9N2OUPW+aasz7J8Rr
         N2kOFgCz6DI7mFeADjfvpYi6wIhAr+njoP6N09kBzpicq2rW7BxTZLRKXNhOXL+F8zpn
         41HXfGs0lesR9ZXPsbQI/YbFYK/kebCjiq6xFsVoyIPl4RPTS65nijRS2xD8WtOXEs7h
         UbjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XqmnoWxGYhvRpRQvm/LkWgDTT6TYNcRDSo11h7efasM=;
        b=hg9ZKyLiu/+TMjIp2SFE+2jtVqQLTSravY6R78C/8nIfiuG4+ybttsX5Fmaru2esiv
         7+aJL56g0NAljI/vgLjOdTcHknSiZq22/lnLBLfXist1daLbqvZinUN0cThMkHqBCce4
         KgCfVBpTVpkFAM1iyEe0Qep9w5De2CBN1XSCcMMo2JxnS2XrwamdfbMgPBMbBhReQsUp
         5RA7v0dZF9cHvYJH9wf6vn8z+BtQxcZvxYybD1mbLOPJcQZOgsaCy619CL7V8sAy2e1J
         5UJN9Mwd93OpjeWzSevnyj3K3sccxYOBNOgdIYw0mRL3LW4muaMHSU0zW7nJyrOrOY6S
         ZQ9w==
X-Gm-Message-State: ANhLgQ32CbI6wF74DhR+a6fW9rmz3as0sHwqq4P6Waq0O1eepuDkhk0/
        AfFKWsY7aAgdxRHLYX6hXvQ=
X-Google-Smtp-Source: ADFU+vup7KypBKRBv7m2JZA0QvDEfgywgHPVN6UHaoh8ChEB+3PGgMrS8fTZUHpBYX35kragrSEcJg==
X-Received: by 2002:a05:6214:18f4:: with SMTP id ep20mr3995379qvb.76.1583518168967;
        Fri, 06 Mar 2020 10:09:28 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:3900:366a:948b:9628? ([2601:282:803:7700:3900:366a:948b:9628])
        by smtp.googlemail.com with ESMTPSA id g3sm2513184qke.89.2020.03.06.10.09.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Mar 2020 10:09:28 -0800 (PST)
Subject: Re: [PATCH bpf-next 0/3] Introduce pinnable bpf_link kernel
 abstraction
To:     Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
References: <87pndt4268.fsf@toke.dk>
 <ab2f98f6-c712-d8a2-1fd3-b39abbaa9f64@iogearbox.net>
 <ccbc1e49-45c1-858b-1ad5-ee503e0497f2@fb.com> <87k1413whq.fsf@toke.dk>
 <20200304043643.nqd2kzvabkrzlolh@ast-mbp> <87h7z44l3z.fsf@toke.dk>
 <20200304154757.3tydkiteg3vekyth@ast-mbp> <874kv33x60.fsf@toke.dk>
 <20200305163444.6e3w3u3a5ufphwhp@ast-mbp>
 <473a3e8a-03ea-636c-f054-3c960bf0fdbd@iogearbox.net>
 <20200305225027.nazs3gtlcw3gjjvn@ast-mbp>
 <7b674384-1131-59d4-ee2f-5a17824c1eca@iogearbox.net> <878skd3mw4.fsf@toke.dk>
 <374e23b6-572a-8dac-88cb-855069535917@iogearbox.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <38347de1-2564-0184-e126-218a5f2a4b95@gmail.com>
Date:   Fri, 6 Mar 2020 11:09:26 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <374e23b6-572a-8dac-88cb-855069535917@iogearbox.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/6/20 3:25 AM, Daniel Borkmann wrote:
>>
>> Presumably the XDP EGRESS hook that David Ahern is working on will make
>> this doable for XDP on veth as well?
> 
> I'm not sure I see a use-case for XDP egress for Cilium yet, but maybe
> I'm still
> lacking a clear picture on why one should use it. We currently use various
> layers where we orchestrate our BPF programs from the agent. XDP/rx on
> the phys
> nic on the one end, BPF sock progs attached to cgroups on the other end
> of the
> spectrum. The processing in between on virtual devices is mainly
> tc/BPF-based
> since everything is skb based anyway and more flexible also with
> interaction
> with the rest of the stack. There is also not this pain of having to
> linearize
> all the skbs, but at least there's a path to tackle that.
> 


{ veth-host } <----> { veth-container }

If you are currently putting an XDP program on veth-container, it is run
on the "Rx" of the packet from the host. That program is visible to the
container, but is managed by the host.

With XDP Tx you can put the same program on veth-host.

For containers, sure, maybe you don't care since you control all aspects
of the networking devices. For VMs, the host does not have access to or
control of the "other end" in the guest. Putting a program on the tap's
"Tx" side allows host managed, per-VM programs.
