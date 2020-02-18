Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD85016212B
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 07:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbgBRGzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 01:55:41 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:34632 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbgBRGzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 01:55:41 -0500
Received: by mail-lf1-f66.google.com with SMTP id l18so13685800lfc.1
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 22:55:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iR40Pui0oXMELNuBKY7gkeoebMPelbh7IMg3628HWFc=;
        b=M5UNyemHqzgQxT7eCjbABatQ5mYzbxuM3M4BayV8zIs2AQxejTpMp2ox/HgBHlPRi/
         YpZQ5/PU1tB/HLBU5ikBRdiMWnLmlTRIrZ45xarZXlu6gGtmBkSF83s/zRRVbHcIoHQo
         qOHAICITXz52w8nNvQL1RN7835VZeWkr0V+QsAH1My5xW4Rg9eoTX4tkMvVxDDc1BYHl
         fIj4K3xNRWiZDHdgOkWi21eG6QNumxqIMbidjx9jwsL5yh/BfqjTvhUAXddla6oINCeH
         LHKLndbFAc+R/VPRpPdbAryU8GOCnq+npSbA2mByazYy6LVq/uY9HPMD6fMQIGqquQuu
         bXJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iR40Pui0oXMELNuBKY7gkeoebMPelbh7IMg3628HWFc=;
        b=HENrSE6uQE1UZ4hQXpZzfehaUQQ8uDZ3YpVJKattkmTrqBFQRolkVwDKgzbjdMZSB4
         UMt4ln9B00a5pT5OOCJITdAhf39BsAvhYxfcIBJXO56mGyBkQT/AXm7R82HbCR94XsUV
         LMOQOC/8dyVAblxm6XeBOrT1goQucGopFXxIXX5DG/X7okLwL8lik4ysn+x86/yOaEWI
         TP/bpT/X4bCm1Sx8BZYU0xwVNYLgloxKPFKQH6aOpt1jMl9lgr/jQgJDAqp46RY4oAip
         NV6kBXDG+FTKfDXF+pcpN+EodgGxV7bB+fk/3V++iRD1F0bSbGoxpe56eJOXrINwnQDH
         iT7g==
X-Gm-Message-State: APjAAAUWbBB/B+7zrLIkcQBXn1P5/0l4wrymB9CXvKVSg1MUculvsiNk
        4V3pdLZ0xjYNhLlmhvVBjrU=
X-Google-Smtp-Source: APXvYqwwdxN3dvADft8S7YR1ZibnlgBK6Wx8W87pBahwmf+wd04U+n8U+NLVK8pGeUs6xPfAzWL0Xw==
X-Received: by 2002:a19:cb17:: with SMTP id b23mr9805626lfg.201.1582008938956;
        Mon, 17 Feb 2020 22:55:38 -0800 (PST)
Received: from elitebook.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id f19sm1779093ljj.50.2020.02.17.22.55.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2020 22:55:38 -0800 (PST)
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Re: Regression: net/ipv6/mld running system out of memory (not a
 leak)
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Jo-Philipp Wich <jo@mein.io>
References: <CACna6rwD_tnYagOPs2i=1jOJhnzS5ueiQSpMf23TdTycFtwOYQ@mail.gmail.com>
 <20200212082434.GM2159@dhcp-12-139.nay.redhat.com>
 <2bc4f125-db14-734d-724e-4028b863eca2@gmail.com>
 <20200212100813.GN2159@dhcp-12-139.nay.redhat.com>
Message-ID: <954a388a-5a9a-1554-ddb3-133e82208a03@gmail.com>
Date:   Tue, 18 Feb 2020 07:55:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200212100813.GN2159@dhcp-12-139.nay.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm sorry for a late reply, I spent that time for switching my devices
to some newer kernel. I wanted to make sure we are not chasing a bug
that's long time fixed now.

This problem still exists in the 5.4.18.

On Wed, 12 Feb 2020 at 11:08, Hangbin Liu <liuhangbin@gmail.com> wrote:
> On Wed, Feb 12, 2020 at 09:49:02AM +0100, Rafał Miłecki wrote:
> > On 12.02.2020 09:24, Hangbin Liu wrote:
> > > Thanks for the report. Although you said this is not a memory leak. Maybe
> > > you can try a84d01647989 ("mld: fix memory leak in mld_del_delrec()").
> >
> > Thanks, that commit was also pointed by Eric and I verified it was
> > backported as:
> > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-4.9.y&id=df9c0f8a15c283b3339ef636642d3769f8fbc434
> >
> > So it must be some other bug affecting me.
>
> Hmm, I'm surprised that IGMP works for you, as it requires enable IPv6
> forwarding. Do you have a lot IPv6 multicast groups on your device?

The thing is I don't really use IPv6. There are some single IPv6 packets
in my network (e.g. MDNS packets) but nothing significant.

For my testing purposes I access my access points using ssh and it's the
only real traffic. There are no wireless devices connected to my testing
devices. They are just running monitor mode interfaces without any real
traffic.

Monitor interfaces have
	type = ARPHRD_IEEE80211_RADIOTAP
and skbs have
	skb->pkt_type = PACKET_OTHERHOST
	skb->protocol = htons(ETH_P_802_2)
that also shouldn't trigger any IPv6 traffic in the kernel AFAIU.


 > What dose `ip maddr list` show?

# ip maddr list
1:      lo
         inet  224.0.0.1
         inet6 ff02::1
         inet6 ff01::1
2:      eth0
         link  33:33:00:00:00:01
         link  33:33:00:00:00:02 users 2
         link  01:00:5e:00:00:01 users 2
         link  33:33:ff:7a:fc:80
         link  33:33:ff:00:00:00
         inet  224.0.0.1
         inet6 ff02::1:ff00:0
         inet6 ff02::1:ff7a:fc80
         inet6 ff05::2
         inet6 ff01::2
         inet6 ff02::2
         inet6 ff02::1
         inet6 ff01::1
3:      eth1
         link  33:33:00:00:00:01
         link  33:33:00:00:00:02 users 2
         inet6 ff05::2
         inet6 ff01::2
         inet6 ff02::2
         inet6 ff02::1
         inet6 ff01::1
4:      eth2
         link  33:33:00:00:00:01
         link  33:33:00:00:00:02 users 2
         inet6 ff05::2
         inet6 ff01::2
         inet6 ff02::2
         inet6 ff02::1
         inet6 ff01::1
5:      wlan0
         link  01:00:5e:00:00:01
         link  33:33:00:00:00:02 users 2
         link  33:33:00:00:00:01
         link  33:33:ff:7a:fc:81
         link  33:33:ff:00:00:00
         inet  224.0.0.1
         inet6 ff02::1:ff00:0
         inet6 ff02::1:ff7a:fc81
         inet6 ff05::2
         inet6 ff01::2
         inet6 ff02::2
         inet6 ff02::1
         inet6 ff01::1
6:      wlan1
         link  01:00:5e:00:00:01
         link  33:33:00:00:00:02 users 2
         link  33:33:00:00:00:01
         link  33:33:ff:7a:fc:88
         link  33:33:ff:00:00:00
         inet  224.0.0.1
         inet6 ff02::1:ff00:0
         inet6 ff02::1:ff7a:fc88
         inet6 ff05::2
         inet6 ff01::2
         inet6 ff02::2
         inet6 ff02::1
         inet6 ff01::1
7:      br-lan
         link  33:33:00:00:00:01
         link  33:33:00:00:00:02
         link  01:00:5e:00:00:01
         link  33:33:ff:7a:fc:80
         link  33:33:ff:00:00:00
         inet  224.0.0.1
         inet6 ff02::1:ff00:0
         inet6 ff02::1:ff7a:fc80
         inet6 ff02::2
         inet6 ff02::1
         inet6 ff01::1
8:      eth0.1
         link  01:00:5e:00:00:01 users 2
         inet  224.0.0.1
         inet6 ff02::2
         inet6 ff02::1
         inet6 ff01::1
9:      mon-phy0
         inet  224.0.0.1
         inet6 ff02::2
         inet6 ff02::1
         inet6 ff01::1
10:     mon-phy1
         inet6 ff02::2
         inet6 ff02::1
         inet6 ff01::1
