Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C81313DC67
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 14:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbgAPNvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 08:51:47 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:37060 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726366AbgAPNvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 08:51:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579182706;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HSQVRIo5T/T5M3nGFCM1g0cRJLehKx87k0xRn1tRw/I=;
        b=ZYWAfvKDohGkTHmWZEDryq2LBUc0nRGKlOs0dwL+zqn5bHq8b4hS815INZPq+r1S3u2I2L
        9HVeaumoxWFfBw4tHh/nhj0Ym7yHWrTIWaex+sVlAH5oQWAkb0AoLHLIMMr4HmKzewB9vY
        uMbETr2GyVdIvuAsZNQP/5E/xd+3lpw=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-gec_Vb8gONu6kDKcNF700A-1; Thu, 16 Jan 2020 08:51:45 -0500
X-MC-Unique: gec_Vb8gONu6kDKcNF700A-1
Received: by mail-lj1-f198.google.com with SMTP id g10so4239100ljg.8
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 05:51:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=HSQVRIo5T/T5M3nGFCM1g0cRJLehKx87k0xRn1tRw/I=;
        b=gRHZeEUkIH37WZXmt4pVv2Io7jaQVXiyJfRF5SkdGiB52dNIr/HiV8yEOEiGHP0GZc
         h22wOlpknFGSuhzCXfYer8T7xHt55rD00zuTV61B4QKVCTE0sDpgXn05UoqpT6q/ZBGG
         kOMzlh/eFH4sGyvT3bY02E4+jLVYCgtit6v5Xw39IAJ/l3+bLFrRUOtPpH0xUN4Aii87
         AZcjKGFtVV0Q+eYN6lvo//7LEq85OC2gRjTOJE6o1v0TL3cAIGd5Uct1jaEhMp9fD8zD
         a4CWEdVg+BLUvIQ/wm7IF85FZdfExpOqjIY8s4kIk/hKoB+P3vjQjuqtovqfqJuRAaEG
         bweg==
X-Gm-Message-State: APjAAAW208aO7sFKOmwNy0PlS4qs00pqSc/vzbh9nIwHAcitmsa3j0Oe
        b/1UbBlQoZGWOxDt0PXl2rTmd8quIqRWHrj97xBybUURaUqs4JLv1FRWTvXgkqDpLxukm0U7/iE
        ODoS1rCZfzIeq+8Wb
X-Received: by 2002:a2e:9f17:: with SMTP id u23mr2468600ljk.112.1579182703568;
        Thu, 16 Jan 2020 05:51:43 -0800 (PST)
X-Google-Smtp-Source: APXvYqx5xWH2dF5z9n9RENXRXJOekRF4nc4sEZeF/z5EVeEgZaDID+Q1VUd2+8YwPCybuhIS5I/IHQ==
X-Received: by 2002:a2e:9f17:: with SMTP id u23mr2468585ljk.112.1579182703425;
        Thu, 16 Jan 2020 05:51:43 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id b6sm10570279lfq.11.2020.01.16.05.51.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 05:51:42 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 375971804D6; Thu, 16 Jan 2020 14:51:41 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>, brouer@redhat.com
Subject: Re: [PATCH bpf-next v2 1/2] xdp: Move devmap bulk queue into struct net_device
In-Reply-To: <20200116122400.499c2b1e@carbon>
References: <157893905455.861394.14341695989510022302.stgit@toke.dk> <157893905569.861394.457637639114847149.stgit@toke.dk> <20200115211734.2dfcffd4@carbon> <87imlctlo6.fsf@toke.dk> <20200116122400.499c2b1e@carbon>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 16 Jan 2020 14:51:41 +0100
Message-ID: <87lfq7se4y.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer <brouer@redhat.com> writes:

> On Wed, 15 Jan 2020 23:11:21 +0100
> Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:
>
>> Jesper Dangaard Brouer <brouer@redhat.com> writes:
>>=20
>> > On Mon, 13 Jan 2020 19:10:55 +0100
>> > Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:
>> >=20=20
>> >> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
>> >> index da9c832fc5c8..030d125c3839 100644
>> >> --- a/kernel/bpf/devmap.c
>> >> +++ b/kernel/bpf/devmap.c=20=20
>> > [...]=20=20
>> >> @@ -346,8 +340,7 @@ static int bq_xmit_all(struct xdp_bulk_queue *bq,=
 u32 flags)
>> >>  out:
>> >>  	bq->count =3D 0;
>> >>=20=20
>> >> -	trace_xdp_devmap_xmit(&obj->dtab->map, obj->idx,
>> >> -			      sent, drops, bq->dev_rx, dev, err);
>> >> +	trace_xdp_devmap_xmit(NULL, 0, sent, drops, bq->dev_rx, dev, err);=
=20=20
>> >
>> > Hmm ... I don't like that we lose the map_id and map_index identifier.
>> > This is part of our troubleshooting interface.=20=20
>>=20
>> Hmm, I guess I can take another look at whether there's a way to avoid
>> that. Any ideas?
>
> Looking at the code and the other tracepoints...
>
> I will actually suggest to remove these two arguments, because the
> trace_xdp_redirect_map tracepoint also contains the ifindex'es, and to
> troubleshoot people can record both tracepoints and do the correlation
> themselves.
>
> When changing the tracepoint I would like to keep member 'drops' and
> 'sent' at the same struct offsets.  As our xdp_monitor example reads
> these and I hope we can kept it working this way.
>
> I've coded it up, and tested it.  The new xdp_monitor will work on
> older kernels, but the old xdp_monitor will fail attaching on newer
> kernels. I think this is fair enough, as we are backwards compatible.

SGTM - thanks! I'll respin and include this :)

-Toke

