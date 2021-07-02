Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0463B9FF9
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 13:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231952AbhGBLom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 07:44:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40413 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231950AbhGBLol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 07:44:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625226129;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h4fTVxwT0YGbBlnm0LY7mfLhhlD7ZJz2gTZLQx0lukk=;
        b=R75z5f35KfJqgz56p9AI0W3RuiBHF7Dr7UY7GByycnBkvzwbYzIa4YOWXuWctIrqVxIMVn
        OHF9RPx+/yCH+Ewb/lz6RFFLzFR5R9hOB/lbRPTsTbi+CBII9xRLty/Dpvk9ccXS8TQsg1
        7mM5ypEzF6/grBcsgW3YJczioR8Tk4Y=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-567-vOk4LzfxN3uOJbMrMo8ASw-1; Fri, 02 Jul 2021 07:42:08 -0400
X-MC-Unique: vOk4LzfxN3uOJbMrMo8ASw-1
Received: by mail-wr1-f69.google.com with SMTP id e13-20020a5d530d0000b0290126d989c76eso3795433wrv.18
        for <netdev@vger.kernel.org>; Fri, 02 Jul 2021 04:42:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=h4fTVxwT0YGbBlnm0LY7mfLhhlD7ZJz2gTZLQx0lukk=;
        b=n6hj5KzNYb4hWuc72MGS52NHq0qhJ52hEksMfMOHIYovhIWcK/0koFi3bZnjd7p8Ma
         fcS4LHIbKPqDfRR4hfvlWt1Qpm7cwDh07U8NYO2uIfI/Ajp8Yt5ItNLXhoAndmmDZOTR
         74bkJuZmItYOLFYjVwzkpguyiwc6dTHMFcirVAGGTBV+mb9x4BXnFI3WHExp/FcCIEeC
         QpF024bJWabmRSdCfPxTtUD+nN2g4YaOBYST9T8XORVchVFGSJkRTKMupdsYKDdrVh1f
         AOhQG+eGReAPgeDbAwJEKc8oCO1ux1XTa+L69lCsslGRJx8QhfhGeHIAPmqP+h1ArOLx
         iyRg==
X-Gm-Message-State: AOAM532A4ayU7Si3rXAIVr3T73ygTTN3hvR5kWk6+unBvLnOgHcbiFnj
        mDEXeYw3Pkiy73JNzIQSBncdHA8JOaaR3OADg/ajkCAXYc47V36uIR/eZ+I7EAj3uUGJXpQzylo
        XmJAFq+l09W2Oenp9
X-Received: by 2002:a7b:c2a2:: with SMTP id c2mr5008492wmk.89.1625226126815;
        Fri, 02 Jul 2021 04:42:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxWYuJGIGbYFRs7gC4LCE1k8CaBwN2PtmCW/QOzVqlx2uInbLjzu/GrMJi0BvnwfYQ8dz6lEA==
X-Received: by 2002:a7b:c2a2:: with SMTP id c2mr5008472wmk.89.1625226126642;
        Fri, 02 Jul 2021 04:42:06 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-171.dyn.eolo.it. [146.241.112.171])
        by smtp.gmail.com with ESMTPSA id t11sm3073597wrz.7.2021.07.02.04.42.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jul 2021 04:42:06 -0700 (PDT)
Message-ID: <39df657bee89e56c704782e0c061383d276d2f7c.camel@redhat.com>
Subject: Re: [regression] UDP recv data corruption
From:   Paolo Abeni <pabeni@redhat.com>
To:     Matthias Treydte <mt@waldheinz.de>
Cc:     stable@vger.kernel.org, netdev@vger.kernel.org,
        regressions@lists.linux.dev, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Ahern <dsahern@gmail.com>
Date:   Fri, 02 Jul 2021 13:42:05 +0200
In-Reply-To: <CA+FuTSc3POcZo0En3JBqRwq2+eF645_Cs4U-4nBmTs9FvjoVkg@mail.gmail.com>
References: <20210701124732.Horde.HT4urccbfqv0Nr1Aayuy0BM@mail.your-server.de>
         <38ddc0e8-ba27-279b-8b76-4062db6719c6@gmail.com>
         <CA+FuTSc3POcZo0En3JBqRwq2+eF645_Cs4U-4nBmTs9FvjoVkg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Thu, 2021-07-01 at 20:31 -0400, Willem de Bruijn wrote:
> On Thu, Jul 1, 2021 at 11:39 AM David Ahern <dsahern@gmail.com> wrote:
> > [ adding Paolo, author of 18f25dc39990 ]
> > 
> > On 7/1/21 4:47 AM, Matthias Treydte wrote:
> > > Hello,
> > > 
> > > we recently upgraded the Linux kernel from 5.11.21 to 5.12.12 in our
> > > video stream receiver appliance and noticed compression artifacts on
> > > video streams that were previously looking fine. We are receiving UDP
> > > multicast MPEG TS streams through an FFMpeg / libav layer which does the
> > > socket and lower level protocol handling. For affected kernels it spills
> > > the log with messages like
> > > 
> > > > [mpegts @ 0x7fa130000900] Packet corrupt (stream = 0, dts = 6870802195).
> > > > [mpegts @ 0x7fa11c000900] Packet corrupt (stream = 0, dts = 6870821068).
> > > 
> > > Bisecting identified commit 18f25dc399901426dff61e676ba603ff52c666f7 as
> > > the one introducing the problem in the mainline kernel. It was
> > > backported to the 5.12 series in
> > > 450687386cd16d081b58cd7a342acff370a96078. Some random observations which
> > > may help to understand what's going on:
> > > 
> > >    * the problem exists in Linux 5.13
> > >    * reverting that commit on top of 5.13 makes the problem go away
> > >    * Linux 5.10.45 is fine
> > >    * no relevant output in dmesg
> > >    * can be reproduced on different hardware (Intel, AMD, different
> > > NICs, ...)
> > >    * we do use the bonding driver on the systems (but I did not yet
> > > verify that this is related)
> > >    * we do not use vxlan (mentioned in the commit message)
> > >    * the relevant code in FFMpeg identifying packet corruption is here:
> > > 
> > > https://github.com/FFmpeg/FFmpeg/blob/master/libavformat/mpegts.c#L2758
> > > 
> > > And the bonding configuration:
> > > 
> > > # cat /proc/net/bonding/bond0
> > > Ethernet Channel Bonding Driver: v5.10.45
> > > 
> > > Bonding Mode: fault-tolerance (active-backup)
> > > Primary Slave: None
> > > Currently Active Slave: enp2s0
> > > MII Status: up
> > > MII Polling Interval (ms): 100
> > > Up Delay (ms): 0
> > > Down Delay (ms): 0
> > > Peer Notification Delay (ms): 0
> > > 
> > > Slave Interface: enp2s0
> > > MII Status: up
> > > Speed: 1000 Mbps
> > > Duplex: full
> > > Link Failure Count: 0
> > > Permanent HW addr: 80:ee:73:XX:XX:XX
> > > Slave queue ID: 0
> > > 
> > > Slave Interface: enp3s0
> > > MII Status: down
> > > Speed: Unknown
> > > Duplex: Unknown
> > > Link Failure Count: 0
> > > Permanent HW addr: 80:ee:73:XX:XX:XX
> > > Slave queue ID: 0
> > > 
> > > 
> > > If there is anything else I can do to help tracking this down please let
> > > me know.

Thank you for the report!

According to the above I would wild guess that the GRO layer is
wrongly/unexpectly aggregating some UDP packets, but I do agree with
Willem, it looks like the code pointed by the bisecting should not do
anything evil here, but I'm likely missing some items.

Could you please:
- tell how frequent is the pkt corruption, even a rough estimate of the
frequency.

- provide the features exposed by the relevant devices: 
ethtool -k <nic name>

- check, if possibly, how exactly the pkts are corrupted. Wrong size?
bad csum? what else?

- ideally a short pcap trace comprising the problematic packets would
be great!

Thanks!

Paolo

