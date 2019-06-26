Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2BB056D71
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 17:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728423AbfFZPOg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 26 Jun 2019 11:14:36 -0400
Received: from mail-ed1-f54.google.com ([209.85.208.54]:45711 "EHLO
        mail-ed1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727959AbfFZPOf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 11:14:35 -0400
Received: by mail-ed1-f54.google.com with SMTP id a14so3826508edv.12
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 08:14:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=M366rKkt5ha/CiMBZW0a1OAroYMcNQ6gNLU/efFnQ+o=;
        b=VJJ9jezUrviG99I1CRUTArNcWaIQz4QmfmHRFi5nvgyw4bfmLdvIHGWGvr4o+mHF3u
         xynol/KSdg4ATxMSzlUblnbsqArjeI48Dtp1gaslfijc8ZHH/u1S89jw7FGq5EO8ueCN
         VbEYHjKX0sAzUKMgtBiYqdvyaFuROoSjMOkECVjmiikoUsvg6gL8QLN2aouj+Pt3iQMp
         umUddx2JjiTjFFkZbxsDyVt4U6XJBVfpoGobsv1jd28eQr5RYjh7Q0c3uArYgkyxRnFa
         Za0LScBlOZQCf0Ojg+nItLO4716dN61slT2VRV37bPoiKcKH1pQjGohYa7oih3b8GxDd
         n50g==
X-Gm-Message-State: APjAAAVBMkdvIJBEiefdsX1IZ1BBgyJQt/ttVccTgnXsQf+94DbPEhPh
        5IWxnstmzyCAuIJPfNZJBGJlbA==
X-Google-Smtp-Source: APXvYqzxBdIpc3m2/QPoftwdKMrnnV+q0z+awsUupPb6zDzM7D1dgNWUc5ziQYAei4JFOEbLnmRXHw==
X-Received: by 2002:a05:6402:1557:: with SMTP id p23mr5840280edx.207.1561562073581;
        Wed, 26 Jun 2019 08:14:33 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id b6sm342797ejk.27.2019.06.26.08.14.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 26 Jun 2019 08:14:32 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 6051F181CA7; Wed, 26 Jun 2019 17:14:32 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     "Machulsky\, Zorik" <zorik@amazon.com>,
        "Jubran\, Samih" <sameehj@amazon.com>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "Woodhouse\, David" <dwmw@amazon.co.uk>,
        "Matushevsky\, Alexander" <matua@amazon.com>,
        "Bshara\, Saeed" <saeedb@amazon.com>,
        "Wilson\, Matt" <msw@amazon.com>,
        "Liguori\, Anthony" <aliguori@amazon.com>,
        "Bshara\, Nafea" <nafea@amazon.com>,
        "Tzalik\, Guy" <gtzalik@amazon.com>,
        "Belgazal\, Netanel" <netanel@amazon.com>,
        "Saidi\, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt\, Benjamin" <benh@amazon.com>,
        "Kiyanovski\, Arthur" <akiyano@amazon.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "xdp-newbies\@vger.kernel.org" <xdp-newbies@vger.kernel.org>,
        brouer@redhat.com
Subject: Re: XDP multi-buffer incl. jumbo-frames (Was: [RFC V1 net-next 1/1] net: ena: implement XDP drop support)
In-Reply-To: <20190626164059.4a9511cf@carbon>
References: <20190623070649.18447-1-sameehj@amazon.com> <20190623070649.18447-2-sameehj@amazon.com> <20190623162133.6b7f24e1@carbon> <A658E65E-93D2-4F10-823D-CC25B081C1B7@amazon.com> <20190626103829.5360ef2d@carbon> <87a7e4d0nj.fsf@toke.dk> <20190626164059.4a9511cf@carbon>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 26 Jun 2019 17:14:32 +0200
Message-ID: <87ef3gbcpz.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer <brouer@redhat.com> writes:

> On Wed, 26 Jun 2019 13:52:16 +0200
> Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>
>> Jesper Dangaard Brouer <brouer@redhat.com> writes:
>> 
>> > On Tue, 25 Jun 2019 03:19:22 +0000
>> > "Machulsky, Zorik" <zorik@amazon.com> wrote:
>> >  
>> >> ﻿On 6/23/19, 7:21 AM, "Jesper Dangaard Brouer" <brouer@redhat.com> wrote:
>> >> 
>> >>     On Sun, 23 Jun 2019 10:06:49 +0300 <sameehj@amazon.com> wrote:
>> >>       
>> >>     > This commit implements the basic functionality of drop/pass logic in the
>> >>     > ena driver.    
>> >>     
>> >>     Usually we require a driver to implement all the XDP return codes,
>> >>     before we accept it.  But as Daniel and I discussed with Zorik during
>> >>     NetConf[1], we are going to make an exception and accept the driver
>> >>     if you also implement XDP_TX.
>> >>     
>> >>     As we trust that Zorik/Amazon will follow and implement XDP_REDIRECT
>> >>     later, given he/you wants AF_XDP support which requires XDP_REDIRECT.
>> >> 
>> >> Jesper, thanks for your comments and very helpful discussion during
>> >> NetConf! That's the plan, as we agreed. From our side I would like to
>> >> reiterate again the importance of multi-buffer support by xdp frame.
>> >> We would really prefer not to see our MTU shrinking because of xdp
>> >> support.     
>> >
>> > Okay we really need to make a serious attempt to find a way to support
>> > multi-buffer packets with XDP. With the important criteria of not
>> > hurting performance of the single-buffer per packet design.
>> >
>> > I've created a design document[2], that I will update based on our
>> > discussions: [2] https://github.com/xdp-project/xdp-project/blob/master/areas/core/xdp-multi-buffer01-design.org
>> >
>> > The use-case that really convinced me was Eric's packet header-split.
>> >
>> >
>> > Lets refresh: Why XDP don't have multi-buffer support:
>> >
>> > XDP is designed for maximum performance, which is why certain driver-level
>> > use-cases were not supported, like multi-buffer packets (like jumbo-frames).
>> > As it e.g. complicated the driver RX-loop and memory model handling.
>> >
>> > The single buffer per packet design, is also tied into eBPF Direct-Access
>> > (DA) to packet data, which can only be allowed if the packet memory is in
>> > contiguous memory.  This DA feature is essential for XDP performance.
>> >
>> >
>> > One way forward is to define that XDP only get access to the first
>> > packet buffer, and it cannot see subsequent buffers. For XDP_TX and
>> > XDP_REDIRECT to work then XDP still need to carry pointers (plus
>> > len+offset) to the other buffers, which is 16 bytes per extra buffer.  
>> 
>> Yeah, I think this would be reasonable. As long as we can have a
>> metadata field with the full length + still give XDP programs the
>> ability to truncate the packet (i.e., discard the subsequent pages)
>
> You touch upon some interesting complications already:
>
> 1. It is valuable for XDP bpf_prog to know "full" length?
>    (if so, then we need to extend xdp ctx with info)
>
>  But if we need to know the full length, when the first-buffer is
>  processed. Then realize that this affect the drivers RX-loop, because
>  then we need to "collect" all the buffers before we can know the
>  length (although some HW provide this in first descriptor).
>
>  We likely have to change drivers RX-loop anyhow, as XDP_TX and
>  XDP_REDIRECT will also need to "collect" all buffers before the packet
>  can be forwarded. (Although this could potentially happen later in
>  driver loop when it meet/find the End-Of-Packet descriptor bit).

A few more points (mostly thinking out loud here):

- In any case we probably need to loop through the subsequent
  descriptors in all cases, right? (i.e., if we run XDP on first
  segment, and that returns DROP, the rest that are part of the packet
  still need to be discarded). So we may as well delay XDP execution
  until we have the whole packet?

- Will this allow us to run XDP on hardware-assembled GRO super-packets?

-Toke
