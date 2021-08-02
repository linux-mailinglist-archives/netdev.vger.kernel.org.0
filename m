Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 147813DDB2C
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 16:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234173AbhHBOhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 10:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233925AbhHBOhM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 10:37:12 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D665C06175F;
        Mon,  2 Aug 2021 07:37:02 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id o2-20020a9d22020000b0290462f0ab0800so17636882ota.11;
        Mon, 02 Aug 2021 07:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language;
        bh=MVihtTuA4GiAmhxLEdqXX0x3qDJAycEKyff1M1mOmzE=;
        b=iwiHE2v6rzLdyqVWJ8qHNSPAlQFvTykcpRJUOrB2J1zrELK+7id2tk8/z2WsiLLewD
         rhe1T14LEksKLE/LU8Lm3Fe012fGmlyWdeNGS2y5z0ZmFntfOE8D854RwAw5idf9ZHkZ
         MjskMp/JOX7bxrY56/6xjZ1UTknrJAVv0wjw4lR0sTzwF2yPRWPAKN0r5k6qEJs3Dcgd
         EmfWNYWTPcD5uj8MiYmteWBn4NSinjgD6lf5kqRaiWVutyKBBUG49k/XfcQDUqwPUe1+
         mRgMpwDty2sTzIo4Dhh14Qxndob4AqQMIJP1jG9CS1+HNG9IIRJJJjTLfxR7chm0xAB9
         PVoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=MVihtTuA4GiAmhxLEdqXX0x3qDJAycEKyff1M1mOmzE=;
        b=LhsxdPGnPgWsUWiZZHkE/dp6PaS6vgX7Nfs2hyI764yb9l9M1oTlYyFWc3so3x3TpR
         e3XQ1mBIFjRG/pb7E+k0SKDeU4JIqJ/mZavMoG/eCzarSk4+ad8l62vN1h6/E39vS3eB
         sHZ00nhp7SlGQoSv6PphqrFnJnpQEp5eNF67IvTKqQmwVGtR5XcJp7MgofB0asY70QhZ
         G+TpJ31mHI353Qh6CIt4My+RTfFCB/m7RhZ7FcLCQXJeIsOffVbJ07uG00RV//6BuEQL
         10jAJo7PC1dT0g2T1ywuW49WzFXpNZtjvICFCRnKSCcSHnFQjxhmCPbyfpnOQGpPKGFr
         TRAg==
X-Gm-Message-State: AOAM533ecdTmLxOHhFHYoWBGlh2ph4LddBlNmLlxtFbARbOuXzKPl0o/
        CNkiMPej/75D5gq80XgwQ58=
X-Google-Smtp-Source: ABdhPJwXcoJN6DOZUBcmWtVEqTI7xkkCwHTK8QlSb1QAbKgo1kGJusER2Yf+XXVpKtqZlw//Mg2uaA==
X-Received: by 2002:a05:6830:19ca:: with SMTP id p10mr12148684otp.267.1627915021624;
        Mon, 02 Aug 2021 07:37:01 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.27])
        by smtp.googlemail.com with ESMTPSA id h187sm1803676oif.48.2021.08.02.07.37.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Aug 2021 07:37:01 -0700 (PDT)
Subject: Re: [PATCH] net: convert fib_treeref from int to refcount_t
To:     Ioana Ciornei <ciorneiioana@gmail.com>,
        Yajun Deng <yajun.deng@linux.dev>
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net
References: <20210729071350.28919-1-yajun.deng@linux.dev>
 <20210802133727.bml3be3tpjgld45j@skbuf>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2033809a-1a07-1f5d-7732-f10f6e094f3d@gmail.com>
Date:   Mon, 2 Aug 2021 08:36:59 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210802133727.bml3be3tpjgld45j@skbuf>
Content-Type: multipart/mixed;
 boundary="------------28DC582A340025063863F4C4"
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------28DC582A340025063863F4C4
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 8/2/21 7:37 AM, Ioana Ciornei wrote:
> Unfortunately, with this patch applied I get into the following WARNINGs
> when booting over NFS:

Can you test the attached?

Thanks,

--------------28DC582A340025063863F4C4
Content-Type: text/plain; charset=UTF-8; x-mac-type="0"; x-mac-creator="0";
 name="0001-ipv4-Fix-refcount-warning-for-new-fib_info.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="0001-ipv4-Fix-refcount-warning-for-new-fib_info.patch"

RnJvbSBlYzlkMTY5ZWIzM2U2YTY1ZGI2NDE3OTI4MjFjYzZhMjU5ZWQ5MzYyIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBEYXZpZCBBaGVybiA8ZHNhaGVybkBrZXJuZWwub3Jn
PgpEYXRlOiBNb24sIDIgQXVnIDIwMjEgMDg6Mjk6MjYgLTA2MDAKU3ViamVjdDogW1BBVENI
IG5ldC1uZXh0XSBpcHY0OiBGaXggcmVmY291bnQgd2FybmluZyBmb3IgbmV3IGZpYl9pbmZv
CgpJb2FuYSByZXBvcnRlZCBhIHJlZmNvdW50IHdhcm5pbmcgd2hlbiBib290aW5nIG92ZXIg
TkZTOgoKWyAgICA1LjA0MjUzMl0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0t
LS0tClsgICAgNS4wNDcxODRdIHJlZmNvdW50X3Q6IGFkZGl0aW9uIG9uIDA7IHVzZS1hZnRl
ci1mcmVlLgpbICAgIDUuMDUyMzI0XSBXQVJOSU5HOiBDUFU6IDcgUElEOiAxIGF0IGxpYi9y
ZWZjb3VudC5jOjI1IHJlZmNvdW50X3dhcm5fc2F0dXJhdGUrMHhhNC8weDE1MAouLi4KWyAg
ICA1LjE2NzIwMV0gQ2FsbCB0cmFjZToKWyAgICA1LjE2OTYzNV0gIHJlZmNvdW50X3dhcm5f
c2F0dXJhdGUrMHhhNC8weDE1MApbICAgIDUuMTc0MDY3XSAgZmliX2NyZWF0ZV9pbmZvKzB4
YzAwLzB4YzkwClsgICAgNS4xNzc5ODJdICBmaWJfdGFibGVfaW5zZXJ0KzB4OGMvMHg2MjAK
WyAgICA1LjE4MTg5M10gIGZpYl9tYWdpYy5pc3JhLjArMHgxMTAvMHgxMWMKWyAgICA1LjE4
NTg5MV0gIGZpYl9hZGRfaWZhZGRyKzB4YjgvMHgxOTAKWyAgICA1LjE4OTYyOV0gIGZpYl9p
bmV0YWRkcl9ldmVudCsweDhjLzB4MTQwCgpmaWJfdHJlZXJlZiBuZWVkcyB0byBiZSBzZXQg
YWZ0ZXIga3phbGxvYy4gVGhlIG9sZCBjb2RlIGhhZCBhICsrIHdoaWNoCmxlZCB0byB0aGUg
Y29uZnVzaW9uIHdoZW4gdGhlIGludCB3YXMgcmVwbGFjZWQgYnkgYSByZWZjb3VudF90LgoK
Rml4ZXM6IDc5OTc2ODkyZjdlYSAoIm5ldDogY29udmVydCBmaWJfdHJlZXJlZiBmcm9tIGlu
dCB0byByZWZjb3VudF90IikKU2lnbmVkLW9mZi1ieTogRGF2aWQgQWhlcm4gPGRzYWhlcm5A
a2VybmVsLm9yZz4KUmVwb3J0ZWQtYnk6IElvYW5hIENpb3JuZWkgPGNpb3JuZWlpb2FuYUBn
bWFpbC5jb20+CkNjOiBZYWp1biBEZW5nIDx5YWp1bi5kZW5nQGxpbnV4LmRldj4KLS0tCiBu
ZXQvaXB2NC9maWJfc2VtYW50aWNzLmMgfCAyICstCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNl
cnRpb24oKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9uZXQvaXB2NC9maWJfc2Vt
YW50aWNzLmMgYi9uZXQvaXB2NC9maWJfc2VtYW50aWNzLmMKaW5kZXggZmExOWY0Y2RmM2E0
Li5mMjlmZWI3NzcyZGEgMTAwNjQ0Ci0tLSBhL25ldC9pcHY0L2ZpYl9zZW1hbnRpY3MuYwor
KysgYi9uZXQvaXB2NC9maWJfc2VtYW50aWNzLmMKQEAgLTE1NTEsNyArMTU1MSw3IEBAIHN0
cnVjdCBmaWJfaW5mbyAqZmliX2NyZWF0ZV9pbmZvKHN0cnVjdCBmaWJfY29uZmlnICpjZmcs
CiAJCXJldHVybiBvZmk7CiAJfQogCi0JcmVmY291bnRfaW5jKCZmaS0+ZmliX3RyZWVyZWYp
OworCXJlZmNvdW50X3NldCgmZmktPmZpYl90cmVlcmVmLCAxKTsKIAlyZWZjb3VudF9zZXQo
JmZpLT5maWJfY2xudHJlZiwgMSk7CiAJc3Bpbl9sb2NrX2JoKCZmaWJfaW5mb19sb2NrKTsK
IAlobGlzdF9hZGRfaGVhZCgmZmktPmZpYl9oYXNoLAotLSAKMi4yNC4zIChBcHBsZSBHaXQt
MTI4KQoK
--------------28DC582A340025063863F4C4--
