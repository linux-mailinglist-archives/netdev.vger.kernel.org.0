Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD983BA1F5
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 16:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233009AbhGBOJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 10:09:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55926 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232997AbhGBOJB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 10:09:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625234789;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m6Mna86YdcQ7UWi1VsRKdRyxdiO+RtsBgfouscqciX0=;
        b=ZtBsL+kGZYeQ/q4JK9M9j0Y0fITUHAwJQaguvwlKe013dlWcCUBT+G6qYXDykQcz/AwLMs
        xvZQUH0u9oeCFSgKsHj2viACpD7lWWuJmBfUyqUNDn2AhguGa2OnPT7Yp8/C3ksBnlQZ8V
        Yo24yNRgc1zVvQaBIc1cQt0nOKI+MsM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-0GWvYdqlNPmzbxK0flr9ag-1; Fri, 02 Jul 2021 10:06:27 -0400
X-MC-Unique: 0GWvYdqlNPmzbxK0flr9ag-1
Received: by mail-wr1-f72.google.com with SMTP id d9-20020adffbc90000b029011a3b249b10so3915182wrs.3
        for <netdev@vger.kernel.org>; Fri, 02 Jul 2021 07:06:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=m6Mna86YdcQ7UWi1VsRKdRyxdiO+RtsBgfouscqciX0=;
        b=Fj3pPPV6AFAEAtmiStHeOJsYt6cXRIqrN1oaZVINXS+/54UjKgwWbEw+5DXHcR+d/6
         gbpHe1hdwZn6QTChQXsW8pbrX/pVQqA/YRUF8nbrY00fsVFbcUfmTqkyBnqEDhsRCTbd
         9hZUY+RtwnUR8QE07kXC4iGLr40BzewoZX9vDtsGypo+PgD2fjNgihaprL0wN/a16qxo
         EePx6MBsaU1V6qXLadab7VCdHiOUtG+HA/xCVsdB4Xjs9QcN4JyPwHmP6F93DFFnTW1P
         KWRGBNP8V+L8HLXsGqEHIYbRBhjlJ7FiH0EjxHqKz3igdNJ5tPIlfNEu/ChEDR4mtPzd
         tyJg==
X-Gm-Message-State: AOAM5320m7F/pRn5XjuJ1tIX7ZUDBzhpGJsSLMhbsOq0c16/xJhwDPm5
        qAQY1Ek7RmONeIcXd6H7B3KVFhJNncsKjwQ+cOV+zv7JqBpUIL/1sKNIYoPDWuXsaLatLu8gC2H
        putc2Uxe9bvJhbDCI
X-Received: by 2002:a5d:4a8d:: with SMTP id o13mr6117832wrq.241.1625234786021;
        Fri, 02 Jul 2021 07:06:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwA9TE3RJu3zzU4nu2KP8KMTfpIvvr1FHhaBi2SGdvArpcNv2wIeUwcMCsHztpsb/Ars/QDNw==
X-Received: by 2002:a5d:4a8d:: with SMTP id o13mr6117786wrq.241.1625234785778;
        Fri, 02 Jul 2021 07:06:25 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-171.dyn.eolo.it. [146.241.112.171])
        by smtp.gmail.com with ESMTPSA id p7sm3337907wrr.68.2021.07.02.07.06.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jul 2021 07:06:25 -0700 (PDT)
Message-ID: <6c6eee2832c658d689895aa9585fd30f54ab3ed9.camel@redhat.com>
Subject: Re: [regression] UDP recv data corruption
From:   Paolo Abeni <pabeni@redhat.com>
To:     Matthias Treydte <mt@waldheinz.de>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>, stable@vger.kernel.org,
        netdev@vger.kernel.org, regressions@lists.linux.dev,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org
Date:   Fri, 02 Jul 2021 16:06:24 +0200
In-Reply-To: <20210702143642.Horde.PFbG3LFNTZ3wp0TYiBRGsCM@mail.your-server.de>
References: <20210701124732.Horde.HT4urccbfqv0Nr1Aayuy0BM@mail.your-server.de>
         <38ddc0e8-ba27-279b-8b76-4062db6719c6@gmail.com>
         <CA+FuTSc3POcZo0En3JBqRwq2+eF645_Cs4U-4nBmTs9FvjoVkg@mail.gmail.com>
         <20210702143642.Horde.PFbG3LFNTZ3wp0TYiBRGsCM@mail.your-server.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Fri, 2021-07-02 at 14:36 +0200, Matthias Treydte wrote:
> And to answer Paolo's questions from his mail to the list (@Paolo: I'm  
> not subscribed, please also send to me directly so I don't miss your mail)

(yup, that is what I did ?!?)

> > Could you please:
> > - tell how frequent is the pkt corruption, even a rough estimate of the
> > frequency.
> 
> # journalctl --since "5min ago" | grep "Packet corrupt" | wc -l
> 167
> 
> So there are 167 detected failures in 5 minutes, while the system is receiving
> at a moderate rate of about 900 pkts/s (according to Prometheus' node exporter
> at least, but seems about right)

Intersting. The relevant UDP GRO features are already off, and this
happens infrequently. Something is happening on a per packet basis, I
can't guess what.

It looks like you should be able to collect more info WRT the packet
corruption enabling debug logging at ffmpeg level, but I guess that
will flood the logfile.

If you have the kernel debuginfo and the 'perf' tool available, could
you please try:

perf probe -a 'udp_gro_receive sk sk->__sk_common.skc_dport'
perf probe -a 'udp_gro_receive_segment'

# neet to wait until at least a pkt corruption happens, 10 second
# should be more then enough
perf record -a -e probe:udp_gro_receive -e probe:udp_gro_receive_segment sleep 10

perf script | gzip > perf_script.gz

and share the above? I fear it could be too big for the ML, feel free
to send it directly to me.

> Next I'll try to capture some broken packets and reply in a separate mail,
> I'll have to figure out a good way to do this first.

Looks like there is corrupted packet every ~2K UDP ones. If you capture
a few thousends consecutive ones, than wireshark should probably help
finding the suspicious ones.

Thanks!

Paolo

