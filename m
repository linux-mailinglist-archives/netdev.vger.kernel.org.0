Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 926D9107E81
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 14:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbfKWN14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 08:27:56 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23646 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726451AbfKWN14 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 08:27:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574515675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1MhDMEUxEmLEu7SdbOLTeWFaemHMbwohR9S2GAxlfJc=;
        b=JLEM0CcfYbk2iNx823wfmpelH+D7K4yrpXGpQmBEjGQ9N/cbVurZKJw6ckykFC1Rj2T3CV
        UcbGQFHJDNQS2OpcKOSOBRYG5lxRw9K1ivc7d+x3co+ZAw4FNcX7ioDhrgbVkKI9tBjHvD
        pz7ydrfcpjgkgy7MKK3nFppoNUApOK0=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-141-geVkkUVSMFOHeunH6gbMHQ-1; Sat, 23 Nov 2019 08:27:52 -0500
Received: by mail-lf1-f71.google.com with SMTP id i29so386379lfc.18
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 05:27:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=1MhDMEUxEmLEu7SdbOLTeWFaemHMbwohR9S2GAxlfJc=;
        b=A8qHGLLu7IRg1brkMHgey1b/fLxIqVmq0RcycbgPg4ycpobgRdileFJAzfHhuBPk5r
         Y/w01FbyAOw1LOTU2rH8sHLZaMTFZUAvd+gpsyqQLwrMSd6ZH2imeiP862i9DXl0CusR
         bUC+9gvfML0vtPaXL3q2a/I4s/csI7AiYoJDGm35Dg4MZ08mBM+CeKA42iGZ2YGmtHrH
         qRIDkT2KntPz1vK9euj0cXhJzdEXTYupl0qx0ax+FR3Ae7YhtaxlUeGzbkmzhCU4eJv5
         MjetEaDCZt0opIrU47mC2NKYElOVAzgpKOobjvBYemsrZ6aSZmPj4D4RTwt7k5bZUFDs
         uJ/g==
X-Gm-Message-State: APjAAAWqZffB1+C3XZ/lyKbd7sTeavg3699RWQ7/uCBtzJoA6wLR+j0q
        U8mBxdjIKNK0JkQ7UElO21cOaV29f5hekk3fx9NA/AwaoKXqGPNrvcWM9buj6VFhe1Zw34CxfLU
        /VRZU0E0+lgBR5vAq
X-Received: by 2002:a2e:81c1:: with SMTP id s1mr15526271ljg.83.1574515670782;
        Sat, 23 Nov 2019 05:27:50 -0800 (PST)
X-Google-Smtp-Source: APXvYqx5nzlKINiVfwlKaf0OgiL3Qij3eb+qHaBBD3Fs37/vwKXs2FUrPuQjM1M+jsA+0DEZCDxxHg==
X-Received: by 2002:a2e:81c1:: with SMTP id s1mr15526258ljg.83.1574515670608;
        Sat, 23 Nov 2019 05:27:50 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id a8sm705792lfi.50.2019.11.23.05.27.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 05:27:49 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 047371818BF; Sat, 23 Nov 2019 14:27:48 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "xdp-newbies\@vger.kernel.org" <xdp-newbies@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: error loading xdp program on virtio nic
In-Reply-To: <1fc9364a-ab96-e085-1fc5-9ed29f43f815@gmail.com>
References: <c484126f-c156-2a17-b47d-06d08121c38b@gmail.com> <89f56317-5955-e692-fcf0-ee876aae068b@redhat.com> <3dc7b9d8-bcb2-1a90-630e-681cbf0f1ace@gmail.com> <18659bd0-432e-f317-fa8a-b5670a91c5b9@redhat.com> <f7b8df14-ef7f-be76-a990-b9d71139bcaa@gmail.com> <20191121072625.3573368f@carbon> <4686849f-f3b8-dd1d-0fe4-3c176a37b67a@redhat.com> <df4ae5e7-3f79-fd28-ea2e-43612ff61e6f@gmail.com> <f7b19bae-a9cf-d4bf-7eee-bfe644d87946@redhat.com> <8324a37e-5507-2ae6-53f6-949c842537e0@gmail.com> <20191122175749.47728e42@carbon> <1fc9364a-ab96-e085-1fc5-9ed29f43f815@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 23 Nov 2019 14:27:48 +0100
Message-ID: <87k17q3ep7.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: geVkkUVSMFOHeunH6gbMHQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@gmail.com> writes:

> On 11/22/19 9:57 AM, Jesper Dangaard Brouer wrote:
>> Implementation wise, I would not add flags to xdp_buff / xdp_md.
>> Instead I propose in[1] slide 46, that the verifier should detect the
>> XDP features used by a BPF-prog.  If you XDP prog doesn't use e.g.
>> XDP_TX, then you should be allowed to run it on a virtio_net device
>> with less queue configured, right?
>
> Thanks for the reference and yes, that is the goal: allow XDP in the
> most use cases possible. e.g., Why limit XDP_DROP which requires no
> resources because XDP_TX does not work?
>
> I agree a flag in the api is an ugly way to allow it. For the verifier
> approach, you mean add an internal flag (e.g., bitmask of return codes)
> that the program uses and the NIC driver can check at attach time?

Yes, that's more or less what we've discussed. With the actual set of
flags, and the API for the driver (new ndo?) TBD. Suggestions welcome; I
anticipate this is something Jesper and I need to circle back to soonish
in any case (unless someone beats us to it!).

-Toke

