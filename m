Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3723871B2
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 08:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241998AbhERGSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 02:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbhERGSg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 02:18:36 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38900C061573
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 23:17:18 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id c196so588253oib.9
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 23:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:thread-topic:thread-index:date:message-id
         :references:in-reply-to:accept-language:content-language
         :content-transfer-encoding:mime-version;
        bh=RSA/ZxGkyr3nkDJN4wQhryHpYRQRQ+wQQrYaMcM4VzI=;
        b=gAZhIS5nrlaX0lCmeQea3PZMBzW/hFW4qktvmX8bJgElWEum3ps9HnGkbLj5Al9Cmu
         LpBKzbuP9+DL7WLH6CRqQZSuaIpu4v5sPe61KyFImoQwiElzdwezU/Yf+28Nk6orsJmw
         WP/50WytfbmzTzuN7jP+RnDteHBkZ5EHHVBKdETcNSkQD3TvqVxI2KsWVkZbsX70yvGZ
         47BjRwDePwssF68wIuTlHjzjrox8gWI/yH3EupZJbE1F/lAdnACIMYEJohWbwypBld0E
         EKzc5EkGZHU9V56ccBJOBpNsv5CNqkXYbBpoa7iCFHpuNGXs5OP6x8AsCmugktMG/SO5
         bilA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:thread-topic:thread-index
         :date:message-id:references:in-reply-to:accept-language
         :content-language:content-transfer-encoding:mime-version;
        bh=RSA/ZxGkyr3nkDJN4wQhryHpYRQRQ+wQQrYaMcM4VzI=;
        b=eKrlynPX70OfFxNisgjWozu41Qqw7R7qM3xdfS75yDnqyB4/Y/2qoL+YR8g7+pdr+6
         VdK4mUDRPd/800WJH8VYIavQb3rZiCheKEQtys2H9E7hoEaO8cEd7jphnsNEoOp7dIyX
         ky45vpeBJH/TnZH/B+bQg68aWSAcGiU5/K/0hxs6ZDJrPwPp3cfhs+zPycnIxR+9YocN
         iiizqvcqdyCRepWiOC8Re6ZN75uk46zDgbd7skyaKA7VulGp9I/+bf3Nr/nCQQLPIO6a
         oHbdz3Gcum7pJEjTZoSG2MDYQ/0Q0yXWqR75zkJy4Gj2LApludCOmwAUwWcRm5tn+1vW
         NPZg==
X-Gm-Message-State: AOAM5322qdD1e5hq9vGYxV2OAVeKowWTTrH2bydODIAfeOL7V8CMLp/p
        9757SCLB9Kshsw88NaVLocA=
X-Google-Smtp-Source: ABdhPJwuNRbi4+CPeMbR8jDpXzGisuoxXmBeYZTASUVgxuAqsK8g0OF0nsDDfWPRGTJE5BeDCFf4XA==
X-Received: by 2002:aca:488f:: with SMTP id v137mr2672620oia.173.1621318637649;
        Mon, 17 May 2021 23:17:17 -0700 (PDT)
Received: from SY4P282MB2854.AUSP282.PROD.OUTLOOK.COM ([2603:1016:401:18d5::5])
        by smtp.gmail.com with ESMTPSA id z204sm3208696oia.2.2021.05.17.23.17.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 May 2021 23:17:17 -0700 (PDT)
From:   Jim Ma <majinjing3@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "borisp@nvidia.com" <borisp@nvidia.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] tls splice: check SPLICE_F_NONBLOCK instead of
 MSG_DONTWAIT
Thread-Topic: [PATCH] tls splice: check SPLICE_F_NONBLOCK instead of
 MSG_DONTWAIT
Thread-Index: ATNnYWE1J1P0o6+ifjtDU3DxYV1BWmUxLjIxxJ8OrAU=
X-MS-Exchange-MessageSentRepresentingType: 1
Date:   Tue, 18 May 2021 06:17:13 +0000
Message-ID: <SY4P282MB2854A31945CCBEA39B164CEEA72C9@SY4P282MB2854.AUSP282.PROD.OUTLOOK.COM>
References: <96f2e74095e655a401bb921062a6f09e94f8a57a.1620961779.git.majinjing3@gmail.com>
 <20210514122749.6dd15b9e@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20210514122749.6dd15b9e@kicinski-fedora-PC1C0HJN>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-Exchange-Organization-SCL: -1
X-MS-TNEF-Correlator: 
X-MS-Exchange-Organization-RecordReviewCfmType: 0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmtzIGZvciByZW1pbmRlci4NCkknbSBzdXJlIHRoYXQsIGZpeCBwYXRjaCBmaXhlczogYzQ2
MjM0ZWJiNGQxICgidGxzOiBSWCBwYXRoIGZvciBrdGxzIikNCg0K77u/IE9uIDIwMjEvNS8xOCwg
MDA6MDEsICJKYWt1YiBLaWNpbnNraSIgPGt1YmFAa2VybmVsLm9yZz4gd3JvdGU6DQoNCiAgICBP
biBTdW4sIDE2IE1heSAyMDIxIDA0OjU4OjExICswMDAwIEppbSBNYSB3cm90ZToNCiAgICA+IE5v
LCB0aGlzIHBhdGNoIGZpeCB1c2luZyBNU0dfKiBpbiBzcGxpY2UuDQogICAgPiANCiAgICA+IEkg
aGF2ZSB0ZXN0ZWQgcmVhZCwgd3JpdGUsIHNlbmRtc2csIHJlY3Ztc2cgZm90IHRscywgYW5kIHRy
eSB0bw0KICAgID4gaW1wbGVtZW50IHRscyBpbiBnb2xhbmcuIEluIGRldmVsb3AsIEkgaGF2ZSBm
b3VuZCB0aG9zZSBpc3N1ZXMgYW5kDQogICAgPiB0cnkgdG8gZml4IHRoZW0uDQoNCiAgICBUbyBi
ZSBjbGVhciB0aGUgRml4ZXMgdGFnIHBvaW50cyB0byB0aGUgY29tbWl0IHdoZXJlIHRoZSBpc3N1
ZSB3YXMNCiAgICBmaXJzdCBpbnRyb2R1Y2VkLiBBRkFJQ1QgdGhlIGlzc3VlIHdhcyB0aGVyZSBm
cm9tIHRoZSBzdGFydCwgdGhhdA0KICAgIGlzIGNvbW1pdCBjNDYyMzRlYmI0ZDEgKCJ0bHM6IFJY
IHBhdGggZm9yIGt0bHMiKS4gQXJlIHlvdSBzYXlpbmcgdGhhdCANCiAgICBpdCB1c2VkIHRvIHdv
cmsgaW4gdGhlIGJlZ2lubmluZyBhbmQgdGhlbiBhbm90aGVyIGNvbW1pdCBicm9rZSBpdD8NCg0K
ICAgIFdlIG5lZWQgdGhlIGZpeGVzIHRhZyB0byBiZSBhYmxlIHRvIHRlbGwgaG93IGZhciBiYWNr
IChpbiB0ZXJtcyBvZg0KICAgIExUUyByZWxlYXNlcykgdG8gYmFja3BvcnQuDQoNCiAgICA+IEFu
IG90aGVyIGlzc3VlLCB3aGVuIGJlZm9yZSBlbmFibGUgVExTX1JYIGluIGNsZWludCwgdGhlIHNl
cnZlciBzZW5kcw0KICAgID4gYSB0bHMgcmVjb3JkLCBjbGllbnQgd2lsbCByZWNlaXZlIGJhZCBt
ZXNzYWdlIG9yIG1lc3NhZ2UgdG9vIGxvbmcNCiAgICA+IGVycm9yLiBJJ20gdHJ5IHRvIGZpeCB0
aGlzIGlzc3VlLg0KDQogICAgUGxlYXNlIHJlcGx5IGFsbCBhbmQgZG9uJ3QgdG9wIHBvc3QuDQoN
Ck9uIDIwMjEvNS8xNSwgMDM6MjcsICJKYWt1YiBLaWNpbnNraSIgPGt1YmFAa2VybmVsLm9yZz4g
d3JvdGU6DQoNCiAgICBPbiBGcmksIDE0IE1heSAyMDIxIDExOjExOjAyICswODAwIEppbSBNYSB3
cm90ZToNCiAgICA+IEluIHRsc19zd19zcGxpY2VfcmVhZCwgY2hlY2tvdXQgTVNHXyogaXMgaW5h
cHByb3ByaWF0ZSwgc2hvdWxkIHVzZQ0KICAgID4gU1BMSUNFXyosIHVwZGF0ZSB0bHNfd2FpdF9k
YXRhIHRvIGFjY2VwdCBub25ibG9jayBhcmd1bWVudHMgaW5zdGVhZA0KICAgID4gb2YgZmxhZ3Mg
Zm9yIHJlY3Ztc2cgYW5kIHNwbGljZS4NCiAgICA+IA0KICAgID4gU2lnbmVkLW9mZi1ieTogSmlt
IE1hIDxtYWppbmppbmczQGdtYWlsLmNvbT4NCg0KICAgIEZpeGVzOiBjNDYyMzRlYmI0ZDEgKCJ0
bHM6IFJYIHBhdGggZm9yIGt0bHMiKQ0KDQogICAgcmlnaHQ/DQo=
