Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 816AC2BBC0
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 23:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727423AbfE0VaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 17:30:20 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33653 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726772AbfE0VaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 17:30:16 -0400
Received: by mail-pf1-f195.google.com with SMTP id z28so10155959pfk.0
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 14:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=appneta.com; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=zNngeK9yJtL4OMcJcnUljk+BohYrdR732P1fa4qFReg=;
        b=hNS7mTMiHAcToRuZy/CqRVTAjlwwAdqaObVfvktLzLqIis8X1bgee8RPgyKCFK1dDP
         rodPjPc4JQ1dkSuFZaRxRe/9tCMg25t4Jfm3oXTUNhtzFj3s+7zhQG3RGjZZFWvSVWH+
         6rzHf1EdzdzeC8xfw+lWH9bESnRiX1dw1EnzQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=zNngeK9yJtL4OMcJcnUljk+BohYrdR732P1fa4qFReg=;
        b=By0EiDk0XY5bfZsTScGRcmUhGePjOZpl6n9cuTiKGeh449YgxIx81EowfFTbWKdI50
         8A5zCKH53pCcYr5CgaiHhW4cdt2iR88XKgpYz8N7cxEzr4W6IZmIEZqPSA1dDhSXPDcB
         XId2vKo9YDjpZPQnD+pxqLZzOTS8Ioa1n40ZnamHLKZcinLyb83ToO6ABLZzc7+r1M0G
         FKTLBYu3tC+agX8dOwcwW7W/yi3tGfHdF1krK3kSHaX+eiYjFEeP7kK8InfgCDDPjKGU
         WFBy11mJzrZI0hdrdZvxU/1lQWRQUnwTZnth3yde6BP+noZdhW2nD30vx4GtIqo/GPX9
         +lMA==
X-Gm-Message-State: APjAAAWRzI17bvi0RTz/kl8BTU/bPhpMecK0bOWh0+FrPNFhULsSjVjG
        dwBVbvpnbqBIciwU2wxbTSfo+g==
X-Google-Smtp-Source: APXvYqwtzk+/sYeL90Z+i4CKBSqOo//cfnFDZj2leAaAZ9G0Qq1WwUkYjNrFp3MOrZea4/Ynp+22+Q==
X-Received: by 2002:a63:184d:: with SMTP id 13mr8006876pgy.346.1558992615169;
        Mon, 27 May 2019 14:30:15 -0700 (PDT)
Received: from jltm109.jaalam.net (vancouver-a.appneta.com. [209.139.228.33])
        by smtp.gmail.com with ESMTPSA id g8sm356875pjp.17.2019.05.27.14.30.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 May 2019 14:30:14 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH net 4/4] net/udpgso_bench_tx: audit error queue
From:   Fred Klassen <fklassen@appneta.com>
In-Reply-To: <CAF=yD-KBNLr5KY-YQ1KMmZGCpYNefSJKaJkZNOwd8nRiedpQtA@mail.gmail.com>
Date:   Mon, 27 May 2019 14:30:11 -0700
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <879E5DA6-3A4F-4CE1-9DA5-480EE30109DE@appneta.com>
References: <20190523210651.80902-1-fklassen@appneta.com>
 <20190523210651.80902-5-fklassen@appneta.com>
 <CAF=yD-KBNLr5KY-YQ1KMmZGCpYNefSJKaJkZNOwd8nRiedpQtA@mail.gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Willem,

Thanks for spending so much time with me on this patch. I=E2=80=99m =
pretty
new to this, so I know I am making lots of mistakes. I have been
working on a v2 of the selftests in net-next, but want to review the
layout of the report before I submit (see below).

Also, I my v2 fix in net is still up for debate. In its current state, =
it
meets my application=E2=80=99s requirements, but may not meet all of =
yours.
I am still open to suggestions, but so far I don=E2=80=99t have an =
alternate
solution that doesn=E2=80=99t break what I need working.

I also have a question about submitting a fix in net and a related
enhancement in net-next. I feel I should be referencing the fix
in net in my net-next commit, but I don=E2=80=99t know how it should be
done. Any suggestions?   =20

> On May 23, 2019, at 2:56 PM, Willem de Bruijn =
<willemdebruijn.kernel@gmail.com> wrote:
>>=20
>> Example:
>>=20
>>    # ./udpgso_bench_tx -4uT -a -l5 -S 1472 -D 172.16.120.189
>>    udp tx:    492 MB/s     8354 calls/s   8354 msg/s
>>    udp tx:    477 MB/s     8106 calls/s   8106 msg/s
>>    udp tx:    488 MB/s     8288 calls/s   8288 msg/s
>>    udp tx:    882 MB/s    14975 calls/s  14975 msg/s
>>    Summary over 5.000 seconds ...
>>    sum udp tx:    696 MB/s      57696 calls (11539/s)  57696 msgs =
(11539/s)
>>    Tx Timestamps: received:     57696   errors: 0
>>=20
>> This can be useful in tracking loss of messages when under load. For =
example,
>> adding the '-z' option results in loss of TX timestamp messages:
>>=20
>>    # ./udpgso_bench_tx -4ucT -a -l5 -S 1472 -D 172.16.120.189 -p 3239 =
-z
>>    udp tx:    490 MB/s     8325 calls/s   8325 msg/s
>>    udp tx:    500 MB/s     8492 calls/s   8492 msg/s
>>    udp tx:    883 MB/s    14985 calls/s  14985 msg/s
>>    udp tx:    756 MB/s    12823 calls/s  12823 msg/s
>>    Summary over 5.000 seconds ...
>>    sum udp tx:    657 MB/s      54429 calls (10885/s)  54429 msgs =
(10885/s)
>>    Tx Timestamps: received:     34046   errors: 0
>>    Zerocopy acks: received:     54422   errors: 0
>=20
> This would probably also be more useful as regression test if it is in
> the form of a pass/fail test: if timestamps are requested and total
> count is zero, then the feature is broken and the process should exit
> with an error.

I have it set up as a pass/fail test. Below is a sample output of the
test, including a failure on IPv6 TCP Zerocopy audit (a failure that may
lead to a memory leak). I wanted to review the report with you before
I push up the v2 patch into net-next.

Are these extra tests what you were expecting? Is it OK that it =
doesn=E2=80=99t
flow well? Also, there is a failure about every 3rd time I run it,
indicating that some TX or Zerocopy messages are lost. Is that OK?=20

ipv4
tcp
tcp rx:  11665 MB/s   189014 calls/s
tcp tx:  11665 MB/s   197859 calls/s 197859 msg/s
tcp rx:  11706 MB/s   190749 calls/s
tcp tx:  11706 MB/s   198545 calls/s 198545 msg/s
tcp tx:  11653 MB/s   197645 calls/s 197645 msg/s
tcp rx:  11653 MB/s   189292 calls/s
tcp zerocopy
tcp rx:   6658 MB/s   111849 calls/s
tcp tx:   6658 MB/s   112940 calls/s 112940 msg/s
tcp tx:   6824 MB/s   115742 calls/s 115742 msg/s
tcp rx:   6824 MB/s   115711 calls/s
tcp rx:   6865 MB/s   116402 calls/s
tcp tx:   6865 MB/s   116440 calls/s 116440 msg/s
tcp zerocopy audit
tcp tx:   6646 MB/s   112729 calls/s 112729 msg/s
tcp rx:   6646 MB/s   111445 calls/s
tcp rx:   6672 MB/s   112833 calls/s
tcp tx:   6672 MB/s   113164 calls/s 113164 msg/s
tcp tx:   6624 MB/s   112355 calls/s 112355 msg/s
tcp rx:   6624 MB/s   110877 calls/s
Summary over 4.000 seconds...
sum tcp tx:   6813 MB/s     451402 calls (112850/s)     451402 msgs =
(112850/s)
Zerocopy acks:              451402 received                 0 errors
udp
udp rx:    914 MB/s   651407 calls/s
udp tx:    925 MB/s   659274 calls/s  15697 msg/s
udp rx:    919 MB/s   654859 calls/s
udp tx:    919 MB/s   654864 calls/s  15592 msg/s
udp rx:    914 MB/s   651668 calls/s
udp tx:    914 MB/s   651630 calls/s  15515 msg/s
udp rx:    918 MB/s   654642 calls/s
udp gso
udp rx:   2271 MB/s  1618319 calls/s
udp tx:   2515 MB/s    42658 calls/s  42658 msg/s
udp rx:   2337 MB/s  1665280 calls/s
udp tx:   2551 MB/s    43276 calls/s  43276 msg/s
udp rx:   2338 MB/s  1665792 calls/s
udp tx:   2557 MB/s    43384 calls/s  43384 msg/s
udp rx:   2339 MB/s  1666560 calls/s
udp gso zerocopy
udp rx:   1725 MB/s  1229087 calls/s
udp tx:   1840 MB/s    31219 calls/s  31219 msg/s
udp rx:   1850 MB/s  1318460 calls/s
udp tx:   1850 MB/s    31388 calls/s  31388 msg/s
udp rx:   1845 MB/s  1314428 calls/s
udp tx:   1845 MB/s    31299 calls/s  31299 msg/s
udp gso timestamp
udp rx:   2286 MB/s  1628928 calls/s
udp tx:   2446 MB/s    41499 calls/s  41499 msg/s
udp rx:   2354 MB/s  1677312 calls/s
udp tx:   2473 MB/s    41952 calls/s  41952 msg/s
udp rx:   2342 MB/s  1668864 calls/s
udp tx:   2471 MB/s    41925 calls/s  41925 msg/s
udp rx:   2333 MB/s  1662464 calls/s
udp gso zerocopy audit
udp rx:   1787 MB/s  1273481 calls/s
udp tx:   1832 MB/s    31082 calls/s  31082 msg/s
udp rx:   1881 MB/s  1340476 calls/s
udp tx:   1881 MB/s    31916 calls/s  31916 msg/s
udp rx:   1880 MB/s  1339880 calls/s
udp tx:   1881 MB/s    31904 calls/s  31904 msg/s
udp rx:   1881 MB/s  1340010 calls/s
Summary over 4.000 seconds...
sum udp tx:   1912 MB/s     126694 calls (31673/s)     126694 msgs =
(31673/s)
Zerocopy acks:              126694 received                 0 errors
udp gso timestamp audit
udp rx:   2259 MB/s  1609327 calls/s
udp tx:   2410 MB/s    40879 calls/s  40879 msg/s
udp rx:   2346 MB/s  1671168 calls/s
udp tx:   2446 MB/s    41491 calls/s  41491 msg/s
udp rx:   2358 MB/s  1680128 calls/s
udp tx:   2448 MB/s    41522 calls/s  41522 msg/s
udp rx:   2356 MB/s  1678848 calls/s
Summary over 4.000 seconds...
sum udp tx:   2494 MB/s     165276 calls (41319/s)     165276 msgs =
(41319/s)
Tx Timestamps:              165276 received                 0 errors
udp gso zerocopy timestamp audit
udp rx:   1658 MB/s  1181647 calls/s
udp tx:   1678 MB/s    28466 calls/s  28466 msg/s
udp rx:   1718 MB/s  1224010 calls/s
udp tx:   1718 MB/s    29146 calls/s  29146 msg/s
udp rx:   1718 MB/s  1224086 calls/s
udp tx:   1718 MB/s    29144 calls/s  29144 msg/s
udp rx:   1717 MB/s  1223464 calls/s
Summary over 4.000 seconds...
sum udp tx:   1747 MB/s     115771 calls (28942/s)     115771 msgs =
(28942/s)
Tx Timestamps:              115771 received                 0 errors
Zerocopy acks:              115771 received                 0 errors
ipv6
tcp
tcp tx:  11470 MB/s   194547 calls/s 194547 msg/s
tcp rx:  11470 MB/s   188442 calls/s
tcp tx:  11803 MB/s   200193 calls/s 200193 msg/s
tcp rx:  11803 MB/s   194526 calls/s
tcp tx:  11832 MB/s   200681 calls/s 200681 msg/s
tcp rx:  11832 MB/s   194459 calls/s
tcp zerocopy
tcp rx:   7482 MB/s    80176 calls/s
tcp tx:   7482 MB/s   126908 calls/s 126908 msg/s
tcp rx:   6641 MB/s   112609 calls/s
tcp tx:   6641 MB/s   112649 calls/s 112649 msg/s
tcp tx:   6584 MB/s   111683 calls/s 111683 msg/s
tcp rx:   6584 MB/s   111617 calls/s
tcp zerocopy audit
tcp tx:   6719 MB/s   113968 calls/s 113968 msg/s
tcp rx:   6719 MB/s   113893 calls/s
tcp rx:   6772 MB/s   114831 calls/s
tcp tx:   6772 MB/s   114872 calls/s 114872 msg/s
tcp tx:   6793 MB/s   115226 calls/s 115226 msg/s
tcp rx:   7075 MB/s   116595 calls/s
Summary over 4.000 seconds...
sum tcp tx:   6921 MB/s     458580 calls (114645/s)     458580 msgs =
(114645/s)
./udpgso_bench_tx: Unexpected number of Zerocopy completions:    458580 =
expected    458578 received
udp
udp rx:    833 MB/s   607639 calls/s
udp tx:    851 MB/s   621264 calls/s  14448 msg/s
udp rx:    860 MB/s   627246 calls/s
udp tx:    860 MB/s   627284 calls/s  14588 msg/s
udp rx:    862 MB/s   628718 calls/s
udp tx:    861 MB/s   628574 calls/s  14618 msg/s
udp rx:    863 MB/s   630058 calls/s
udp gso
udp rx:   2310 MB/s  1683314 calls/s
udp tx:   2472 MB/s    41931 calls/s  41931 msg/s
udp rx:   2343 MB/s  1708032 calls/s
udp tx:   2493 MB/s    42298 calls/s  42298 msg/s
udp rx:   2322 MB/s  1692160 calls/s
udp tx:   2496 MB/s    42347 calls/s  42347 msg/s
udp gso zerocopy
udp rx:   1752 MB/s  1278423 calls/s
udp tx:   1778 MB/s    30162 calls/s  30162 msg/s
udp rx:   1804 MB/s  1316058 calls/s
udp tx:   1804 MB/s    30605 calls/s  30605 msg/s
udp rx:   1807 MB/s  1318120 calls/s
udp tx:   1808 MB/s    30681 calls/s  30681 msg/s
udp rx:   1730 MB/s  1261819 calls/s
udp gso timestamp
udp rx:   2296 MB/s  1673728 calls/s
udp tx:   2375 MB/s    40284 calls/s  40284 msg/s
udp rx:   2334 MB/s  1701632 calls/s
udp tx:   2377 MB/s    40319 calls/s  40319 msg/s
udp rx:   2335 MB/s  1702093 calls/s
udp tx:   2377 MB/s    40319 calls/s  40319 msg/s
udp rx:   2336 MB/s  1702656 calls/s
udp gso zerocopy audit
udp rx:   1717 MB/s  1252554 calls/s
udp tx:   1759 MB/s    29839 calls/s  29839 msg/s
udp rx:   1811 MB/s  1321003 calls/s
udp tx:   1811 MB/s    30722 calls/s  30722 msg/s
udp rx:   1811 MB/s  1320917 calls/s
udp tx:   1811 MB/s    30719 calls/s  30719 msg/s
udp rx:   1810 MB/s  1320606 calls/s
Summary over 4.000 seconds...
sum udp tx:   1839 MB/s     121868 calls (30467/s)     121868 msgs =
(30467/s)
Zerocopy acks:              121868 received                 0 errors
udp gso timestamp audit
udp rx:   2231 MB/s  1626112 calls/s
udp tx:   2337 MB/s    39646 calls/s  39646 msg/s
udp rx:   2292 MB/s  1670400 calls/s
udp tx:   2365 MB/s    40122 calls/s  40122 msg/s
udp rx:   2287 MB/s  1666816 calls/s
udp tx:   2363 MB/s    40084 calls/s  40084 msg/s
udp rx:   2288 MB/s  1667840 calls/s
Summary over 4.000 seconds...
sum udp tx:   2412 MB/s     159818 calls (39954/s)     159818 msgs =
(39954/s)
Tx Timestamps:              159818 received                 0 errors
udp gso zerocopy timestamp audit
udp rx:   1592 MB/s  1161479 calls/s
udp tx:   1624 MB/s    27560 calls/s  27560 msg/s
udp rx:   1657 MB/s  1208472 calls/s
udp tx:   1656 MB/s    28103 calls/s  28103 msg/s
udp rx:   1653 MB/s  1206064 calls/s
udp tx:   1653 MB/s    28047 calls/s  28047 msg/s
udp rx:   1648 MB/s  1202151 calls/s
Summary over 4.000 seconds...
sum udp tx:   1683 MB/s     111556 calls (27889/s)     111556 msgs =
(27889/s)
Tx Timestamps:              111556 received                 0 errors
Zerocopy acks:              111556 received                 0 errors=
