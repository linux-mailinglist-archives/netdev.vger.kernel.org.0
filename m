Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00DF01510CD
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 21:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgBCUNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 15:13:32 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60784 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726201AbgBCUNc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 15:13:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580760811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xK+r17NMpXey58lzz03eVjTCUJasxqDIx7Zb8cmeDUI=;
        b=hun9Hg9EGTq+/oxpaybdLY1ylY3pR5SzkDdE5Tgh5P8VSDFrI98rJERcyZF20L8ZcFPd1X
        W2wTc3mk34Kwu4KZDPHkmrgC4ZGj/ztGIEzdggd2gS0+QD+FtnUmIPQQrjcJcAgOyPDZMX
        iNb5WbXdXU9iTSQU0sZNruJDcFnJgbs=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-bBucunDAPOilV7gUDzUZVg-1; Mon, 03 Feb 2020 15:13:28 -0500
X-MC-Unique: bBucunDAPOilV7gUDzUZVg-1
Received: by mail-lj1-f200.google.com with SMTP id z2so4379002ljh.16
        for <netdev@vger.kernel.org>; Mon, 03 Feb 2020 12:13:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=xK+r17NMpXey58lzz03eVjTCUJasxqDIx7Zb8cmeDUI=;
        b=LH7wU3YbMp92uY6VJJEMTHPoYmhlEm3c0vp62MHyFv71LZFvHSoXjta9AVmCjqjgjW
         KPn3hMr+gov+TFegUaR75kr4sqixdO7AjghhJjVEgw+B55+0+oA/BPuu7vRtNf6lRlrX
         COsqoVQ2XZ7YjOZnlcwgqjiAm3gmWHmTtYJw7rGTHbNtH5er3Y6a75SXSzJcsNku2SNS
         i6LBNv6/dwTZpQS6/IPdf6fEkcVof0w2Dz/Oj9jchezFD5Q/60DqDN1QSaFr78UkeIeS
         HUlyPcPrLEGcVkV1Jl7v89HWFLdBJcHjbxfjZuzWOEvB5tQYVPZE3ojyD0FGz0CXFhkr
         mi5g==
X-Gm-Message-State: APjAAAWXF7mnN/iN1ISNvuWr822lRgFwhu0bQoUB49qmM6/t/Cbm07wx
        GQ092LqU+1jUbCyNWV+WnXPZYhpyTpRhf3SBdSjpLuZicgHijJDAl0L1vdkHHf2RoZ6rdi9xJZB
        l+I4DCSYmxcRgIc6J
X-Received: by 2002:a19:7b0a:: with SMTP id w10mr12914082lfc.90.1580760806728;
        Mon, 03 Feb 2020 12:13:26 -0800 (PST)
X-Google-Smtp-Source: APXvYqwUWcbfekPcyx10Ujto7/4Qq6XWJeemzs0nFWCNv5c3gREodVHWGGvyUh+3Cu5afsfjV2itxw==
X-Received: by 2002:a19:7b0a:: with SMTP id w10mr12914062lfc.90.1580760806532;
        Mon, 03 Feb 2020 12:13:26 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id u15sm9534884lfl.87.2020.02.03.12.13.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2020 12:13:25 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id ADCFD1800A2; Mon,  3 Feb 2020 21:13:24 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@gmail.com>, David Ahern <dsahern@kernel.org>,
        netdev@vger.kernel.org, prashantbhole.linux@gmail.com,
        jasowang@redhat.com, davem@davemloft.net, brouer@redhat.com,
        mst@redhat.com, toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH bpf-next 03/12] net: Add IFLA_XDP_EGRESS for XDP programs in the egress path
In-Reply-To: <20200201201508.63141689@cakuba.hsd1.ca.comcast.net>
References: <20200123014210.38412-1-dsahern@kernel.org> <20200123014210.38412-4-dsahern@kernel.org> <87tv4m9zio.fsf@toke.dk> <335b624a-655a-c0c6-ca27-102e6dac790b@gmail.com> <20200124072128.4fcb4bd1@cakuba> <87o8usg92d.fsf@toke.dk> <1d84d8be-6812-d63a-97ca-ebc68cc266b9@gmail.com> <20200126141141.0b773aba@cakuba> <33f233a9-88b4-a75a-d1e5-fbbda21f9546@gmail.com> <20200127061623.1cf42cd0@cakuba> <252acf50-91ff-fdc5-3ce1-491a02de07c6@gmail.com> <20200128055752.617aebc7@cakuba> <87ftfue0mw.fsf@toke.dk> <20200201090800.47b38d2b@cakuba.hsd1.ca.comcast.net> <87sgjucbuf.fsf@toke.dk> <20200201201508.63141689@cakuba.hsd1.ca.comcast.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 03 Feb 2020 21:13:24 +0100
Message-ID: <87zhdzbfa3.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Oops, I see I forgot to reply to this bit:

>> Yeah, but having the low-level details available to the XDP program
>> (such as HW queue occupancy for the egress hook) is one of the benefits
>> of XDP, isn't it?
>
> I think I glossed over the hope for having access to HW queue occupancy
> - what exactly are you after? 
>
> I don't think one can get anything beyond a BQL type granularity.
> Reading over PCIe is out of question, device write back on high
> granularity would burn through way too much bus throughput.

This was Jesper's idea originally, so maybe he can explain better; but
as I understood it, he basically wanted to expose the same information
that BQL has to eBPF. Making it possible for an eBPF program to either
(re-)implement BQL with its own custom policy, or react to HWQ pressure
in some other way, such as by load balancing to another interface.

-Toke

