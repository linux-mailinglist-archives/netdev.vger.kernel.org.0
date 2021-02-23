Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74BFA322BB2
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 14:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232214AbhBWNuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 08:50:11 -0500
Received: from smtp12.skoda.cz ([185.50.127.89]:56805 "EHLO smtp12.skoda.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231691AbhBWNuG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 08:50:06 -0500
X-Greylist: delayed 941 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Feb 2021 08:50:04 EST
DKIM-Signature: v=1; a=rsa-sha256; d=skoda.cz; s=plzenjune2020; c=relaxed/simple;
        q=dns/txt; i=@skoda.cz; t=1614087219; x=1614692019;
        h=From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=7ZQDfKGGCiBiEL/pEL2HvZlD/dKwZryjoGshAiR5XAs=;
        b=e1YNaysN3NTB7yd/jqq0DoqZVevQaa4Em9k1H6WBaz4GSElzLGD848H+HQyziu7u
        KRuktMpwHq1aJlHGdrL3f2FUC2QzWBtqlNlw85dAand59yryn7JFRVF3Lo2nbEXI
        zcHFytRQZKfhBCIeRq+jqTJ327sVuwBS8VTDYLkye8Q=;
X-AuditID: 0a2aa12f-ba1d87000000c140-eb-603504334fbd
Received: from srv-exch-01.skoda.cz (srv-exch-01.skoda.cz [10.42.11.91])
        (using TLS with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by smtp12.skoda.cz (Mail Gateway) with SMTP id 11.F0.49472.33405306; Tue, 23 Feb 2021 14:33:39 +0100 (CET)
Received: from srv-exch-02.skoda.cz (10.42.11.92) by srv-exch-01.skoda.cz
 (10.42.11.91) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 23 Feb
 2021 14:33:39 +0100
Received: from srv-exch-02.skoda.cz ([fe80::a9b8:e60e:44d3:758d]) by
 srv-exch-02.skoda.cz ([fe80::a9b8:e60e:44d3:758d%3]) with mapi id
 15.01.2176.002; Tue, 23 Feb 2021 14:33:39 +0100
From:   =?iso-8859-2?Q?Vin=B9_Karel?= <karel.vins@skoda.cz>
To:     "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>
Subject: High (200+) XFRM interface count performance problem (throughput)
Thread-Topic: High (200+) XFRM interface count performance problem
 (throughput)
Thread-Index: AdcJ50F1lPQSKBMETcCSnfXvuoqLXg==
Date:   Tue, 23 Feb 2021 13:33:39 +0000
Message-ID: <63259d1978cb4a80889ccec40528ee80@skoda.cz>
Accept-Language: cs-CZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.42.12.26]
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA3VUe0xTZxTnawtcC9+4XF6HjupoNjfR4SgQdTNuMWFxLFvYJlnQOVrgjnb0
        td6WiSwLoBmOTKJEHW1hFFwlkJiQsrAHPmYFeaiQZTKVZc5ljCJOndTsFZF9ty8uJPvvfL/f
        +Z3vd84936XEjCdGRmkNFtZsUOsUUVKJNCNm59PZklzVM/1DT24870x+AW3zuVcWoB3SzWWs
        TlvJmtdvUUk1d1qaok1XondfO2KuQXujGtAKCugc8Dj6ohuQlGLoYyKoOXAUBQ5eBJfnLkYG
        Dt8gaG0+QdIoKoreBM46Ha9OpDfA+Z7BSD5OoPPBea5Bwqck0q+B63BlICUTbvR3+C+T0E/A
        gfkaER9jIm264BDzMaLlcPJjH+JjMZ0Ck1NtooA5Gj4/OS4OxElw89eHkYF4Fcz19IgD+Zkw
        PWqXBOK1cLz9ljhQPx5GbFOSgyjBLihrF0jsAoldIHEiSTeK4/QWU5Yyk6swlqkzS/e4kX/Q
        7eu/Qqdd5R4kopAH1SNKpEjCl6pyVMwjJcayKo2a0xSbrTqWUyTikYhcFYPDcIlVV6GQYTMi
        aEIYNbDvczrWQj6mYiX+912likkJc5yVM2lLtUYrV2w164i245i+WKDlrCV6LcdpjQYPAkpM
        roz6iRTAZeqqPazZGDDiQY9SEkUKPuMlJulytYWtYFkTaw6xR8n3UgD28bbizWw5u/sdrc4S
        4okwv4sXChl/J3KcfSlLxSQLCUEz6VhpJjqZkF7WjxyjiIiIpRWELYmoFR5Uh6hY0ljBPCmG
        OZNaz2nLg9YSsHaBoLEh1G8rFa8WkU6YECiwJMcqPRlPcohaZic1YIdZpENWRlE7og7ebO0Q
        U2cHP+sQMxKD0cDKUvAMfxXNCzRWQ3hmsmRc3Z2tYuIEBO9Nlobt08RwkgBftCd7DHPPEVWq
        gF3qkOi9Z5VL9YsmZ5GL7CQZips3FUv+D4uTYvAMv4sxQdA/KMAb+cT4ICaYUxrO0fHXBJll
        YwLsSh17O6xbNKB0IfKSbZFw1emNggbftWj4e2IUQ0v9j3EEq4+HXqcXYLjHlQb/tI3LoXnC
        sQqGnQ/TYWTg/hqYnP1zHeyzjSnBNty5Fab6b2yFtvFvX4LrF+dfgZnrX7wKbscvBfBz395C
        aLl7qhDcf/1eCA8m/ygEX9ftN+FIi6MIrp44VwQLdftVMOaYVcNHtWOlMNDXaoTGOo8R7nR9
        Ypnld0pEdkqh4R8LZ1FbhDs1pFXyOxVEgzu1mX+YTAhcslO3tP6dClL/t1NhOjQtWQ1yFbTm
        zkR2rr1nOz3lGr2yH73R6/7yw2rlvcv6XvrrvAHfWztf/4CS7sj3JmVsGTwzfarze1XVhXWl
        d3+rLN6VlQ7H440zsk56vLbx8cbm5/PbmIldedq27vfyXlz4bu529VDnfdOmbuezDz415TdZ
        M9ZsO7Sh6PAP22sqVj/1cq1t+z65QsJp1FkZYjOn/g8z5pH6VQYAAA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I would like to ask you for help or advise.

I'm testing setup with higher number of XFRM interfaces and I'm facing thro=
ughput degradation with a growing number of created XFRM interfaces - not c=
oncurrent tunnels established but only XFRM interfaces created - even in DO=
WN state.
Issue is only unidirectional - from "client" to "vpn hub". Throughput for t=
raffic from hub to client is not affected.

XFRM interface created with:
for i in {1..500}; do link add ipsec$i type xfrm dev ens224 if_id $i  ; don=
e

I'm testing with iperf3 with 1 client connected - from client to hub:
2 interfaces - 1.36 Gbps
100 interfaces - 1.35 Gbps
200 interfaces - 1.19 Gbps
300 interfaces - 0.98 Gbps
500 interfaces - 0.71 Gbps

Throughput from hub to client is around 1.4 Gbps in all cases.

1 CPU core is 100%

Linux v-hub 5.4.0-65-generic #73-Ubuntu SMP Mon Jan 18 17:25:17 UTC 2021 x8=
6_64 x86_64 x86_64 GNU/Linux

Thank you.

Regards
Karel Vins
