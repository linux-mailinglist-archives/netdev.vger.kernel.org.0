Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE4F510BE2C
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 22:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730302AbfK0VeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 16:34:18 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:38736 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729803AbfK0VeQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 16:34:16 -0500
Received: by mail-lf1-f66.google.com with SMTP id r14so2095091lfm.5
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 13:34:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=a2lCQIrL6y65H2mjNmVoy68p4ew2rDjgqL/n+hCYEX4=;
        b=E/x35jKj0rQiv/WVf+kyP4FvpGxrR/8rpXB51P2LiTkU5j5462kR96HyeCIEqB0a0P
         TyUGtxg9CoIZBwPIOqGqcvyqg90xKVn/YOscTf9ymG3xTYzQTFyq1QeV8dOX0uNj7i/J
         nC5OQ2vGDgsM7WcUkSQVhW7PEOPabSjcMHxto=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=a2lCQIrL6y65H2mjNmVoy68p4ew2rDjgqL/n+hCYEX4=;
        b=HyPgdcuKSO2vXosSxVD+bGAplM7ooWlYqHR2epUCPFoIiXEc89Kk3Pkgv27hcI5mGS
         d4XXKlSYlR7it2z4QKqtSofdmYNyFWaN0XBgvFuK8sPCtPSiX9s3WBIAEK5ehmVeAeUQ
         KLeoc63hzeqAVbq+8Tk76WPIUyyNxl+AD09QnT7GEYP1tN/MBYIRNkO46nVJEmlE+apl
         BHN4OTXEaUiNAt87/a1G7WnOSUWjv4kkHX9JyMaa+nKxpyIGzhNtrYyQRMJcZABrYb8N
         cKEHNF6dDIvfQyLHYgQkNT39eWg07GhuEivuHV3UpLMAbw7WAPXuczNq0TLL8wablBPg
         J90Q==
X-Gm-Message-State: APjAAAW6dsP5WUtWCkM8vXF1Xcq5qOcEeWpdUT6uyZQ5mV0BL1fendRs
        hH8AVCDYMypXhY9+SDdymIJqzg==
X-Google-Smtp-Source: APXvYqxmpVKNv2C5AaLbEx8E3parZMDzUXqEpEumL/y7JDqdYh/bA60RPQYO7WBLMytvqZh/tH5Sgg==
X-Received: by 2002:ac2:5616:: with SMTP id v22mr20006108lfd.84.1574890453569;
        Wed, 27 Nov 2019 13:34:13 -0800 (PST)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id a18sm7647269ljp.33.2019.11.27.13.34.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 13:34:12 -0800 (PST)
References: <20191123110751.6729-1-jakub@cloudflare.com> <20191123110751.6729-6-jakub@cloudflare.com> <20191125012440.crbufwpokttx67du@ast-mbp.dhcp.thefacebook.com> <5ddb55c87d06c_79e12b0ab99325bc69@john-XPS-13-9370.notmuch> <87o8x0nsra.fsf@cloudflare.com> <20191125220709.jqywizwbr3xwsazi@kafai-mbp> <87imn6ogke.fsf@cloudflare.com> <20191126190301.quwvjihpdzfjhdbe@kafai-mbp.dhcp.thefacebook.com>
User-agent: mu4e 1.1.0; emacs 26.1
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Martin Lau <kafai@fb.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "bpf\@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team\@cloudflare.com" <kernel-team@cloudflare.com>
Subject: Re: [PATCH bpf-next 5/8] bpf: Allow selecting reuseport socket from a SOCKMAP
In-reply-to: <20191126190301.quwvjihpdzfjhdbe@kafai-mbp.dhcp.thefacebook.com>
Date:   Wed, 27 Nov 2019 22:34:10 +0100
Message-ID: <87blsxngvh.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 26, 2019 at 08:03 PM CET, Martin Lau wrote:
> On Tue, Nov 26, 2019 at 03:30:57PM +0100, Jakub Sitnicki wrote:
>> On Mon, Nov 25, 2019 at 11:07 PM CET, Martin Lau wrote:
>> > On Mon, Nov 25, 2019 at 11:40:41AM +0100, Jakub Sitnicki wrote:

[...]

>> I agree, it's not obvious. When I first saw this check in
>> reuseport_array_update_check it got me puzzled too. I should have added
>> an explanatory comment there.
>>
>> Thing is we're not matching on just TCP_LISTEN. REUSEPORT_SOCKARRAY
>> allows selecting a connected UDP socket as a target as well. It takes
>> some effort to set up but it's possible even if obscure.
> How about this instead:
> if (!reuse)
>  	/* reuseport_array only has sk that has non NULL sk_reuseport_cb.
> 	 * The only (!reuse) case here is, the sk has already been removed from
> 	 * reuseport_array, so treat it as -ENOENT.
> 	 *
> 	 * Other maps (e.g. sock_map) do not provide this guarantee and the sk may
> 	 * never be in the reuseport to begin with.
> 	 */
> 	return map->map_type == BPF_MAP_TYPE_REUSEPORT_SOCKARRAY ? -ENOENT : -EINVAL;

Right, apart from established TCP sockets we must not select a listening
socket that's not in a reuseport group either. This covers both
cases. Clever. Thanks for the suggestion.

>
>>
>> > Note that the SOCK_RCU_FREE check at the 'slow-path'
>> > reuseport_array_update_check() is because reuseport_array does depend on
>> > call_rcu(&sk->sk_rcu,...) to work, e.g. the reuseport_array
>> > does not hold the sk_refcnt.
>>
>> Oh, so it's not only about socket state like I thought.
>>
>> This raises the question - does REUSEPORT_SOCKARRAY allow storing
>> connected UDP sockets by design or is it a happy accident? It doesn't
>> seem particularly useful.
> Not by design/accident on the REUSEPORT_SOCKARRAY side ;)
>
> The intention of REUSEPORT_SOCKARRAY is to allow sk that can be added to
> reuse->socks[].

Ah, makes sense. REUSEPORT_SOCKARRAY had to mimic reuseport groups.

-Jakub
