Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF752D15E2
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 17:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726016AbgLGQXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 11:23:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726035AbgLGQXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 11:23:43 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E597C061793
        for <netdev@vger.kernel.org>; Mon,  7 Dec 2020 08:23:03 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id r17so12664231ilo.11
        for <netdev@vger.kernel.org>; Mon, 07 Dec 2020 08:23:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=RLakMiBjCoOYKyzZFq79kUYyOZCs6r9GTHNMlIsCCEg=;
        b=sS4ACL4uzNdvOp9dlmMKjWl2w+KiflKWrg8i0tQ+fkvJA0efxe/CirbYfgbokq1ZAm
         3HU2e8EXGThY1LWMTS/jXMv9CkvAMTrZqeGEsah0akkF9GxvuAhAyxg/qxghaa2GGXQu
         bqHFTLZOV7vzvEwR/s4fyuG1jjYiTaZDH/85y3HktEXjZfkBl7gHSdkPa11i1SCGCG2p
         sJ3AVXq0ftiBsXCUfAsJGQQx1eyfYI/hg1/UqgPN0wBZKdLf4ucSWpf/M1DodV1DTeJ9
         N/BdcHBC9Fem2tZkTdeVp1HEPSZWMg5Jn5ymo4venotSDXnQ8ETgaVzsB3tERfpdvwS3
         VJMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=RLakMiBjCoOYKyzZFq79kUYyOZCs6r9GTHNMlIsCCEg=;
        b=mdq8qt98+pKTZy7t3UX8jz/yRmFe9cYHT8PIiCHHJKRzETjKCkavicLiHZHwinFmYA
         gN5Vmi2GeRTn+jNBy7hJnmnGxVkBhm27i21Vh6jrpkIXKT0APYiGyUM0sU9u6hCuRL74
         jjqSP67lxaRFdIL2xSLIA4+lPP37kYc04OWW4Htz49eOfeAfc+kbbdRgU/vNJ3UvGpc4
         KMYtZjlohOQnR+y5VZazfpwv/FAgFDcFpDpdRMAj34P6FV1UFtC8S34V5A2pakFwcFiu
         fOWvKVOyto54t3Cbk5+aw5HxZXCcslNB7dYralM0pf2wg2Keuy1gIwOBVBg2QQE2Odl+
         Vyvw==
X-Gm-Message-State: AOAM530bD4Bj2LKgerXa7Id5TyYao7G+fkYyXcN5Se/gWS/QhIMCGszP
        Jf5hwZ54dWqDxN1TjesuHW5PZ0anBLNSjWEdvssTbHKh0T+e0g==
X-Google-Smtp-Source: ABdhPJyhgrWvctUCqw924PbsjT90CPA2wurjKfWFYTlFN7Pz46WnMW5/2nbcfD1gI2WuzRIjrriWHliuIcDA4dpKiS0=
X-Received: by 2002:a92:9f59:: with SMTP id u86mr22040429ili.205.1607358182183;
 Mon, 07 Dec 2020 08:23:02 -0800 (PST)
MIME-Version: 1.0
References: <20201204180622.14285-1-abuehaze@amazon.com> <44E3AA29-F033-4B8E-A1BC-E38824B5B1E3@amazon.com>
 <CANn89iJgJQfOeNr9aZHb+_Vozgd9v4S87Kf4iV=mKhuPDGLkEg@mail.gmail.com>
 <3F02FF08-EDA6-4DFD-8D93-479A5B05E25A@amazon.com> <CANn89iL_5QFGQLzxxLyqfNMGiV2wF4CbkY==x5Sh5vqKOTgFtw@mail.gmail.com>
 <781BA871-5D3D-4C89-9629-81345CC41C5C@amazon.com>
In-Reply-To: <781BA871-5D3D-4C89-9629-81345CC41C5C@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 7 Dec 2020 17:22:50 +0100
Message-ID: <CANn89iK1G-YMWo07uByfUwrrK8QPvQPeFrRG1vJhB_OhJo7v2A@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: optimise receiver buffer autotuning
 initialisation for high latency connections
To:     "Mohamed Abuelfotoh, Hazem" <abuehaze@amazon.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "ycheng@google.com" <ycheng@google.com>,
        "ncardwell@google.com" <ncardwell@google.com>,
        "weiwan@google.com" <weiwan@google.com>,
        "Strohman, Andy" <astroh@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 7, 2020 at 5:09 PM Mohamed Abuelfotoh, Hazem
<abuehaze@amazon.com> wrote:
>
>     >Since I can not reproduce this problem with another NIC on x86, I
>     >really wonder if this is not an issue with ENA driver on PowerPC
>     >perhaps ?
>
>
> I am able to reproduce it on x86 based EC2 instances using ENA  or  Xen n=
etfront or Intel ixgbevf driver on the receiver so it's not specific to ENA=
, we were able to easily reproduce it between 2 VMs running in virtual box =
on the same physical host considering the environment requirements I mentio=
ned in my first e-mail.
>
> What's the RTT between the sender & receiver in your reproduction? Are yo=
u using bbr on the sender side?


100ms RTT

Which exact version of linux kernel are you using ?



>
> Thank you.
>
> Hazem
>
> =EF=BB=BFOn 07/12/2020, 15:26, "Eric Dumazet" <edumazet@google.com> wrote=
:
>
>     CAUTION: This email originated from outside of the organization. Do n=
ot click links or open attachments unless you can confirm the sender and kn=
ow the content is safe.
>
>
>
>     On Sat, Dec 5, 2020 at 1:03 PM Mohamed Abuelfotoh, Hazem
>     <abuehaze@amazon.com> wrote:
>     >
>     > Unfortunately few things are missing in this report.
>     >
>     >     What is the RTT between hosts in your test ?
>     >      >>>>>RTT in my test is 162 msec, but I am able to reproduce it=
 with lower RTTs for example I could see the issue downloading from google =
  endpoint with RTT of 16.7 msec, as mentioned in my previous e-mail the is=
sue is reproducible whenever RTT exceeded 12msec given that    the sender i=
s using bbr.
>     >
>     >         RTT between hosts where I run the iperf test.
>     >         # ping 54.199.163.187
>     >         PING 54.199.163.187 (54.199.163.187) 56(84) bytes of data.
>     >         64 bytes from 54.199.163.187: icmp_seq=3D1 ttl=3D33 time=3D=
162 ms
>     >         64 bytes from 54.199.163.187: icmp_seq=3D2 ttl=3D33 time=3D=
162 ms
>     >         64 bytes from 54.199.163.187: icmp_seq=3D3 ttl=3D33 time=3D=
162 ms
>     >         64 bytes from 54.199.163.187: icmp_seq=3D4 ttl=3D33 time=3D=
162 ms
>     >
>     >         RTT between my EC2 instances and google endpoint.
>     >         # ping 172.217.4.240
>     >         PING 172.217.4.240 (172.217.4.240) 56(84) bytes of data.
>     >         64 bytes from 172.217.4.240: icmp_seq=3D1 ttl=3D101 time=3D=
16.7 ms
>     >         64 bytes from 172.217.4.240: icmp_seq=3D2 ttl=3D101 time=3D=
16.7 ms
>     >         64 bytes from 172.217.4.240: icmp_seq=3D3 ttl=3D101 time=3D=
16.7 ms
>     >         64 bytes from 172.217.4.240: icmp_seq=3D4 ttl=3D101 time=3D=
16.7 ms
>     >
>     >     What driver is used at the receiving side ?
>     >       >>>>>>I am using ENA driver version version: 2.2.10g on the r=
eceiver with scatter gathering enabled.
>     >
>     >         # ethtool -k eth0 | grep scatter-gather
>     >         scatter-gather: on
>     >                 tx-scatter-gather: on
>     >                 tx-scatter-gather-fraglist: off [fixed]
>
>     This ethtool output refers to TX scatter gather, which is not relevan=
t
>     for this bug.
>
>     I see ENA driver might use 16 KB per incoming packet (if ENA_PAGE_SIZ=
E is 16 KB)
>
>     Since I can not reproduce this problem with another NIC on x86, I
>     really wonder if this is not an issue with ENA driver on PowerPC
>     perhaps ?
>
>
>
>
> Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembou=
rg, R.C.S. Luxembourg B186284
>
> Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlin=
gton Road, Dublin 4, Ireland, branch registration number 908705
>
>
