Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6885EC8CF5
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 17:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728816AbfJBPdo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 2 Oct 2019 11:33:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42632 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728773AbfJBPdo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 11:33:44 -0400
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com [209.85.167.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 959D93E2AF
        for <netdev@vger.kernel.org>; Wed,  2 Oct 2019 15:33:43 +0000 (UTC)
Received: by mail-lf1-f71.google.com with SMTP id q3so3596415lfc.5
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 08:33:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=LCKwrKAoWbML0O4w4yJPs5h4i4YObo2bfFlauqfsO3U=;
        b=IYIDbNcC0n7ysZT2q+4pDxyiLKGo2qHdRNyhOmPbk5LJsFNVmaMKyRWQqPErIKuFau
         UZbfw0i8kFQAb652d8d3FH5z/bndRX9DoK/ExJkvDMCnReZSmIPOREwU6zTnj3byzMdf
         I2JLmydsL05i9CmFf3dzl0+gLoWeIahxhdovPC1vbz72U0KgNPuG69GdjDqeIgPPLiIM
         HMHB5I4P9ckjW/TBmInfm//hFyWDOgGe77ARqr4wxkTrWFaLuHnC07Z82C77qTMIbTQC
         wHImOPrBt1glsMCFIeXUJBw+6dxOHgv6dYcJTXHJ+s4EBcPlJEQ5Wv2pdfmSAB6oLIwk
         UgdQ==
X-Gm-Message-State: APjAAAWCVtOoIGxi6dijUljwTD64GxC638bezvqAg2xx9Dh9qSzUFQu8
        Ms6NLvgE+JpOWeA7bSzIuTWw3NGmKH3htuFgQZvSe9paHfoahfn6/EkgB/G44BXTxUSkJ+sHAEF
        eYGqXDxrBnLrtxZ31
X-Received: by 2002:a2e:96d5:: with SMTP id d21mr2792724ljj.187.1570030421839;
        Wed, 02 Oct 2019 08:33:41 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzKVPPIlQcxyjqhpxCJnQSGdEEC5ywGSjM5jBOYKIgB5+7evYkWdjosg5h1FIR5oaZQWQBRSA==
X-Received: by 2002:a2e:96d5:: with SMTP id d21mr2792710ljj.187.1570030421623;
        Wed, 02 Oct 2019 08:33:41 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id t4sm4891236lji.40.2019.10.02.08.33.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 08:33:40 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7A11218063D; Wed,  2 Oct 2019 17:33:39 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next 0/9] xdp: Support multiple programs on a single interface through chain calls
In-Reply-To: <alpine.LRH.2.20.1910021540270.24629@dhcp-10-175-191-98.vpn.oracle.com>
References: <157002302448.1302756.5727756706334050763.stgit@alrua-x1> <alpine.LRH.2.20.1910021540270.24629@dhcp-10-175-191-98.vpn.oracle.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 02 Oct 2019 17:33:39 +0200
Message-ID: <87bluzrwks.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alan Maguire <alan.maguire@oracle.com> writes:

> On Wed, 2 Oct 2019, Toke Høiland-Jørgensen wrote:
>
>> This series adds support for executing multiple XDP programs on a single
>> interface in sequence, through the use of chain calls, as discussed at the Linux
>> Plumbers Conference last month:
>> 
>> https://linuxplumbersconf.org/event/4/contributions/460/
>> 
>> # HIGH-LEVEL IDEA
>> 
>> The basic idea is to express the chain call sequence through a special map type,
>> which contains a mapping from a (program, return code) tuple to another program
>> to run in next in the sequence. Userspace can populate this map to express
>> arbitrary call sequences, and update the sequence by updating or replacing the
>> map.
>> 
>> The actual execution of the program sequence is done in bpf_prog_run_xdp(),
>> which will lookup the chain sequence map, and if found, will loop through calls
>> to BPF_PROG_RUN, looking up the next XDP program in the sequence based on the
>> previous program ID and return code.
>> 
>> An XDP chain call map can be installed on an interface by means of a new netlink
>> attribute containing an fd pointing to a chain call map. This can be supplied
>> along with the XDP prog fd, so that a chain map is always installed together
>> with an XDP program.
>> 
>
> This is great stuff Toke!

Thanks! :)

> One thing that wasn't immediately clear to me - and this may be just
> me - is the relationship between program behaviour for the XDP_DROP
> case and chain call execution. My initial thought was that a program
> in the chain XDP_DROP'ping the packet would terminate the call chain,
> but on looking at patch #4 it seems that the only way the call chain
> execution is terminated is if
>
> - XDP_ABORTED is returned from a program in the call chain; or

Yes. Not actually sure about this one...

> - the map entry for the next program (determined by the return value
>   of the current program) is empty; or

This will be the common exit condition, I expect

> - we run out of entries in the map

You mean if we run the iteration counter to zero, right?

> The return value of the last-executed program in the chain seems to be
> what determines packet processing behaviour after executing the chain
> (_DROP, _TX, _PASS, etc). So there's no way to both XDP_PASS and
> XDP_TX a packet from the same chain, right? Just want to make sure
> I've got the semantics correct. Thanks!

Yeah, you've got all this right. The chain call mechanism itself doesn't
change any of the underlying fundamentals of XDP. I.e., each packet gets
exactly one verdict.

For chaining actual XDP programs that do different things to the packet,
I expect that the most common use case will be to only run the next
program if the previous one returns XDP_PASS. That will make the most
semantic sense I think.

But there are also use cases where one would want to match on the other
return codes; such as packet capture, for instance, where one might
install a capture program that would carry forward the previous return
code, but do something to the packet (throw it out to userspace) first.

For the latter use case, the question is if we need to expose the
previous return code to the program when it runs. You can do things
without it (by just using a different program per return code), but it
may simplify things if we just expose the return code. However, since
this will also change the semantics for running programs, I decided to
leave that off for now.

-Toke
