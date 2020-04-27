Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6A7C1BAD56
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 20:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgD0S61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 14:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726696AbgD0S60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 14:58:26 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3A4DC0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 11:58:26 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id w18so9109435qvs.3
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 11:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ckQLZexUMR8Vfa34JEod/15aKPBHs+odAHdpuRVYQMw=;
        b=lCTnd/YURGoa8wQTt5Ry7K/NnrL7Wp9JCnj7zXGu5QSzruR95HZuZ562EIhy7zc4Ve
         r2jxmVcDu+TKvzfaZGjjOz8asjo/MG6aTFobaigQ2lIR4Sn4IB61nkkADt8IsOv/hlsa
         4zJFczPcLnpXpQUGKSCgv9zU8xhQMvY9Cykp+R1KCt5hZ1dPv60C18+xbQyY7d36UGdZ
         2sO3FtdmnVZH8wBGdX2K6wFrbP3gEhYzzpuMEaGfVEnq4ePdxW4l70zJLrpcIFtSy+CE
         i7hVI7CNHpqDr6JvNughzRXZgS89QqmVZHf/SEry7t81C8WS6qweyjUQAY6Vuc+w7FJf
         p+9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ckQLZexUMR8Vfa34JEod/15aKPBHs+odAHdpuRVYQMw=;
        b=HyhjKlYIdQqEg8/teRZnG49RuTfKgd1XUljlEG+w3bmUFsUrtXNnkaJ6st5vi1budf
         DV7+x6stxkifN57D4Ww4UudXSi7yoebIilZQYBvmZ8JwQIh9AlJ/QIbTtnZJhCxlJcgd
         aOsi2B8d7jmrW1YKipXdIJ+5BxQ6B2v93ziqcauT4W9C+oitqQH9kIDbvmdzFj9Wwogz
         XgqryXGu57it4KIFLJukpUMLed9tH63wMla/qjJxYT6iyfNxmrdeh7Hd3IO7LTs5xiGc
         a/9WJsILYO62zgmVdPdTfR3qOZZSuXBZQUhuXkWM72ioth+k50ZRNMAvz2rWvBh080+U
         aB+g==
X-Gm-Message-State: AGi0PuYAuzOjHmOZ/sOJo8LydHOKhiG116mIGej1q0RQ3NNHeEcH4kxn
        esEOzIU9u/atef8T694t49g=
X-Google-Smtp-Source: APiQypJiLwYobGXggzP4ZsQJGVNLzAFk4x2eaKRAORO1sAJNQ/e8wlyEX05yXqS2QYMx66uOazPYsg==
X-Received: by 2002:a0c:f012:: with SMTP id z18mr24006506qvk.42.1588013906006;
        Mon, 27 Apr 2020 11:58:26 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:a88f:52f9:794e:3c1? ([2601:282:803:7700:a88f:52f9:794e:3c1])
        by smtp.googlemail.com with ESMTPSA id t67sm11359675qka.17.2020.04.27.11.58.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2020 11:58:24 -0700 (PDT)
Subject: Re: [PATCH v3 bpf-next 00/15] net: Add support for XDP in egress path
To:     John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com
References: <20200424201428.89514-1-dsahern@kernel.org>
 <5ea7239c8df43_a372ad3a5ecc5b82c@john-XPS-13-9370.notmuch>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <16b923bc-5e2f-624d-2e14-ddf6836d16f6@gmail.com>
Date:   Mon, 27 Apr 2020 12:58:22 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <5ea7239c8df43_a372ad3a5ecc5b82c@john-XPS-13-9370.notmuch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/27/20 12:25 PM, John Fastabend wrote:
> David Ahern wrote:
>> From: David Ahern <dsahern@gmail.com>
>>
>> This series adds support for XDP in the egress path by introducing
>> a new XDP attachment type, BPF_XDP_EGRESS, and adding a UAPI to
>> if_link.h for attaching the program to a netdevice and reporting
>> the program. bpf programs can be run on all packets in the Tx path -
>> skbs or redirected xdp frames. The intent is to emulate the current
>> RX path for XDP as much as possible to maintain consistency and
>> symmetry in the 2 paths with their APIs.
>>
>> This is a missing primitive for XDP allowing solutions to build small,
>> targeted programs properly distributed in the networking path allowing,
>> for example, an egress firewall/ACL/traffic verification or packet
>> manipulation and encapping an entire ethernet frame whether it is
>> locally generated traffic, forwarded via the slow path (ie., full
>> stack processing) or xdp redirected frames.
> 
> I'm still a bit unsure why the BPF programs would not push logic into
> ingress XDP program + skb egress. Is there a case where that does not
> work or is it mostly about ease of use for some use case?

host and VMs.

Some packets take the XDP fast path (known unicast traffic redirected
from host ingress to VM tap or from one VM tap to another VM tap); some
packets take the slow path. Regardless of path, each VM can have its own
per-VM data  (e.g., ingress ACL). With XDP egress programs getting both
packet formats, that per-VM ACL config only needs to be in 1 place -
egress program map.

> 
> Do we have overhead performance numbers? I'm wondering how close the
> redirect case with these TX hooks are vs redirect without TX hooks.
> The main reason I ask is if it slows performance down by more than say
> 5% (sort of made up number, but point is some N%) then I don't think
> we would recommend using it.

Toke ran some tests:
"On a test using xdp_redirect_map from samples/bpf, which gets 8.15 Mpps
normally, loading an XDP egress program on the target interface drops
performance to 7.55 Mpps. So ~600k pps, or ~9.5ns overhead for the
egress program."

###

If XDP redirect gives a 2-4x speedup over skb path but the existence of
an egress program takes away ~8-10% of that speedup, it is still an
overall huge win in performance with a much simpler design, architecture
and lifecycle management of per-VM data.

> 
>>
>> Nothing about running a program in the Tx path requires driver specific
>> resources like the Rx path has. Thus, programs can be run in core
>> code and attached to the net_device struct similar to skb mode. The
>> egress attach is done using the new XDP_FLAGS_EGRESS_MODE flag, and
>> is reported by the kernel using the XDP_ATTACHED_EGRESS_CORE attach
>> flag with IFLA_XDP_EGRESS_PROG_ID making the api similar to existing
>> APIs for XDP.
>>
>> The locations chosen to run the egress program - __netdev_start_xmit
>> before the call to ndo_start_xmit and bq_xmit_all before invoking
>> ndo_xdp_xmit - allow follow on patch sets to handle tx queueing and
>> setting the queue index if multi-queue with consistency in handling
>> both packet formats.
>>
>> A few of the patches trace back to work done on offloading programs
>> from a VM by Jason Wang and Prashant Bole.
> 
> The idea for offloading VM programs would be to take a BPF program
> from the VM somehow out of band or over mgmt interface and load it
> into the egress hook of virtio?

The latest thought is for programs to run in the vhost thread. Offloaded
programs for a guest should run in process context where the cycles can
be associated with the VM.

> 
> Code LGTM other than a couple suggestions on the test side but I'm
> missing something on the use case picture.

thanks for the review.
