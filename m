Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3AAB122103
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 01:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727696AbfLQA7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 19:59:48 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45524 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726670AbfLQA7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 19:59:48 -0500
Received: by mail-pf1-f195.google.com with SMTP id 2so6554641pfg.12;
        Mon, 16 Dec 2019 16:59:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=z+U3mtb5B8o3nMoErvNMR/T0p7amiYHbrwq0mw7E9ew=;
        b=Z1SwPo9iS7off19v/IGRCKqd6Ep97ohWpywllJdALTsD8ML7E+N+AkhzgM64v2AL3C
         H5PirixmJhPKitLQbxx6tK5i4bM0fX72RRg5c8wv4ZYIidPEHiaIWVo3AUDVlQjCbhbj
         KTsdmRNCMlWxdBaMWgRPXdLOOgubzbsO6CPdcPB5kEmfnmo3XE7Tv1Zn/Aa6cZhFNnFz
         F0b4bY9m/z0aitCMgOthnXHx60tMtpKARNFpNzaOGKjgiOFOdzXcabhRNRph1WmVGz7m
         0Tr2r/GjGEoFlgGGJ5OMLvnWVtFFCQKgypop5LoZzVncOuGBFchecX3qWN+n8wtdLGfP
         F18w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=z+U3mtb5B8o3nMoErvNMR/T0p7amiYHbrwq0mw7E9ew=;
        b=Wemk5kbkQQTtdcFHt3F6ZNUDTbTggWTa8NmdeUScusyxOpsqGldZVwLm1K3vV8Bd/l
         GTrI6i5BR4kVz6YEMl6dUJGWhUuxL8I+6aMVjiGhCPKI3Em9Bc6bdC45nHkEpeJY52ec
         3sjRVuCiOyqMBizM1CPjYN7mCFNfbF15bGC/a2LMD0yow1V/oN2s5G8Ln+QQpgIKGUyj
         oO+HE6HbdgMUuCtQwJ3JRvwgia9re6PXOoF+HbBPueAl4r/0aUw3tlp6WIGT+Fdkf7rU
         UiNXRjQJbImgTMUfRaBcGw2h5B6a5OQpRI6O66i5QRhcW5i2LQSHrMeRoiobJewYBmXm
         d9Ow==
X-Gm-Message-State: APjAAAW4dBAKpj070AkhdMSV6zhq07gFj4lE95Zjc7VWxhsByZBTKrhE
        QgE2ePhN0ga88bXt1sZZzD4wtjfW
X-Google-Smtp-Source: APXvYqxj9oz2N8CVGVdCAdu3gfGeU6umT5UJ43qpbRzriLeZl6OW0LkaR58EnmSvr4NYpYeqGBEWtQ==
X-Received: by 2002:a62:6001:: with SMTP id u1mr19633977pfb.158.1576544387579;
        Mon, 16 Dec 2019 16:59:47 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::1:48aa])
        by smtp.gmail.com with ESMTPSA id m9sm24604672pff.38.2019.12.16.16.59.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Dec 2019 16:59:46 -0800 (PST)
Date:   Mon, 16 Dec 2019 16:59:45 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Ido Schimmel <idosch@idosch.org>
Subject: Re: [RFC PATCH bpf-next] xdp: Add tracepoint on XDP program return
Message-ID: <20191217005944.s3mayy473ldlnldl@ast-mbp.dhcp.thefacebook.com>
References: <20191216152715.711308-1-toke@redhat.com>
 <CAJ+HfNhYG_hzuFzX5sAH7ReotLtZWTP_9D2jA_iVMg+jUtXXCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJ+HfNhYG_hzuFzX5sAH7ReotLtZWTP_9D2jA_iVMg+jUtXXCw@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 16, 2019 at 07:17:59PM +0100, Björn Töpel wrote:
> On Mon, 16 Dec 2019 at 16:28, Toke Høiland-Jørgensen <toke@redhat.com> wrote:
> >
> > This adds a new tracepoint, xdp_prog_return, which is triggered at every
> > XDP program return. This was first discussed back in August[0] as a way to
> > hook XDP into the kernel drop_monitor framework, to have a one-stop place
> > to find all packet drops in the system.
> >
> > Because trace/events/xdp.h includes filter.h, some ifdef guarding is needed
> > to be able to use the tracepoint from bpf_prog_run_xdp(). If anyone has any
> > ideas for how to improve on this, please to speak up. Sending this RFC
> > because of this issue, and to get some feedback from Ido on whether this
> > tracepoint has enough data for drop_monitor usage.
> >
> 
> I get that it would be useful, but can it be solved with BPF tracing
> (i.e. tracing BPF with BPF)? It would be neat not adding another
> tracepoint in the fast-path...

That was my question as well.
Here is an example from Eelco:
https://lore.kernel.org/bpf/78D7857B-82E4-42BC-85E1-E3D7C97BF840@redhat.com/
BPF_TRACE_2("fexit/xdp_prog_simple", trace_on_exit,
             struct xdp_buff*, xdp, int, ret)
{
     bpf_debug("fexit: [ifindex = %u, queue =  %u, ret = %d]\n",
               xdp->rxq->dev->ifindex, xdp->rxq->queue_index, ret);

     return 0;
}
'ret' is return code from xdp program.
Such approach is per xdp program, but cheaper when not enabled
and faster when it's triggering comparing to static tracepoint.
Anything missing there that you'd like to see?

