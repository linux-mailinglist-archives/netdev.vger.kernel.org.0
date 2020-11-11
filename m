Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF0572AEC3E
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 09:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbgKKIoZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 03:44:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbgKKIoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 03:44:25 -0500
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13634C0613D1;
        Wed, 11 Nov 2020 00:44:25 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id c80so1382108oib.2;
        Wed, 11 Nov 2020 00:44:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=GyaO1AHIAlGfaJnK3xh9cZOwKj12+iROWxxZfZcT5xs=;
        b=UyYRgxPhiunzjBmjZk5B4uqsjjXDmLusG7ZDGcfmdhKTpoy+oguFb+3IRdX11jFEIs
         tvXK1oAkeyJftvP3kLLbmU7hz4UHkXkz5v9GrMTLui1iQH3xP6Qh79EPvX3SumFGxbyj
         4rJZNjL90uaCvbuDVsXu0MbLAfk01tlORtfV4jAjuT9l2gN/ippXpAcdiMv99Jf/IEfc
         LSxZwwtf/VxiDs3D6CH4RbHF2Gmlf3/HnLENXvb99OWWXbpk8dBvrcNYPTZDpLzJJfZ9
         m/KJw9m0q59xIQCgsRL8cNYXJdPnes7LEZ1XD+xlKJ6nbFNzNM0HbeZR1Q2wV+7DnkmW
         eSyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=GyaO1AHIAlGfaJnK3xh9cZOwKj12+iROWxxZfZcT5xs=;
        b=EIGefdh4ttUxe6RXMxhxegcj5hGCgUnqDlAZOogn5ptM6LBsFM8hf1NInBkRXqJOFT
         NdhpeecILPoeWVl25otsMs8JlWOCn6x6HSaNMMbJqCPkaQDVpyRx49Wi4yEeOpH0tp8p
         L/78fg5ZoogT9r3Tyy+JyWDpXcR0SNR3rJsKn9wiOR5t2UYfLMBz1XZhqWlY1a/iU52d
         gn5UKy/vlCp3zDSozBRQZjrFsRuoacVx/N1YokFtsAUJWTFJcLxc+Q3R03nA4nN3GJT1
         NLyOSaEANVP6f8AYB1FRbDyWKsPFZu69Pmqh+uNRHSjYm1JblompZyY/z60CxsH9JpZN
         U9Yw==
X-Gm-Message-State: AOAM532A8EvbB9zydtcVlwibM8OpASvS2moeZ7Ovh3mRcq+K0aOdlhg3
        /pzp9734pBC3Po/vezRHDic=
X-Google-Smtp-Source: ABdhPJwgQ5jasCs+Jkut86nYIRpZqG+RTcpgGh3dOQytDjhXu4Ro5BPy/q8A435990iZiL4xjD51gQ==
X-Received: by 2002:aca:5383:: with SMTP id h125mr1483132oib.179.1605084264528;
        Wed, 11 Nov 2020 00:44:24 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id q17sm399618oos.34.2020.11.11.00.44.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 00:44:23 -0800 (PST)
Date:   Wed, 11 Nov 2020 00:44:15 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     "wanghai (M)" <wanghai38@huawei.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     quentin@isovalent.com, mrostecki@opensuse.org, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andrii@kernel.org, kpsingh@chromium.org,
        toke@redhat.com, danieltimlee@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <5faba45f90ac8_bb260208e0@john-XPS-13-9370.notmuch>
In-Reply-To: <52cbaf9b-0680-6a4d-8d42-cd5f6d7f5714@huawei.com>
References: <20201110014637.6055-1-wanghai38@huawei.com>
 <5faa18319b71_3e187208f@john-XPS-13-9370.notmuch>
 <52cbaf9b-0680-6a4d-8d42-cd5f6d7f5714@huawei.com>
Subject: Re: [PATCH v2 bpf] tools: bpftool: Add missing close before bpftool
 net attach exit
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

d2FuZ2hhaSAoTSkgd3JvdGU6Cj4gCj4g5ZyoIDIwMjAvMTEvMTAgMTI6MzMs
IEpvaG4gRmFzdGFiZW5kIOWGmemBkzoKPiA+IFdhbmcgSGFpIHdyb3RlOgo+
ID4+IHByb2dmZCBpcyBjcmVhdGVkIGJ5IHByb2dfcGFyc2VfZmQoKSwgYmVm
b3JlICdicGZ0b29sIG5ldCBhdHRhY2gnIGV4aXQsCj4gPj4gaXQgc2hvdWxk
IGJlIGNsb3NlZC4KPiA+Pgo+ID4+IEZpeGVzOiAwNDk0OWNjYzI3M2UgKCJ0
b29sczogYnBmdG9vbDogYWRkIG5ldCBhdHRhY2ggY29tbWFuZCB0byBhdHRh
Y2ggWERQIG9uIGludGVyZmFjZSIpCj4gPj4gU2lnbmVkLW9mZi1ieTogV2Fu
ZyBIYWkgPHdhbmdoYWkzOEBodWF3ZWkuY29tPgo+ID4+IC0tLQoKWy4uLl0K
Cj4gPiBBbHRlcm5hdGl2ZWx5IHdlIGNvdWxkIGFkZCBhbiAnZXJyID0gMCcg
aGVyZSwgYnV0IGFib3ZlIHNob3VsZCBuZXZlcgo+ID4gcmV0dXJuIGEgdmFs
dWUgPjAgYXMgZmFyIGFzIEkgY2FuIHNlZS4KPiBJdCdzIHRydWUgdGhhdCAn
ZXJyID4gMCcgZG9lc24ndCBleGlzdCBjdXJyZW50bHkgLCBidXQgYWRkaW5n
ICdlcnIgPSAwJyAKPiB3b3VsZCBtYWtlIHRoZSBjb2RlIGNsZWFyZXIuIFRo
YW5rcyBmb3IgeW91ciBhZHZpY2UuCj4gPj4gK2NsZWFudXA6Cj4gPj4gKwlj
bG9zZShwcm9nZmQpOwo+ID4+ICsJcmV0dXJuIGVycjsKPiA+PiAgIH0KPiA+
PiAgIAo+ID4+ICAgc3RhdGljIGludCBkb19kZXRhY2goaW50IGFyZ2MsIGNo
YXIgKiphcmd2KQo+ID4+IC0tIAo+ID4+IDIuMTcuMQo+ID4+Cj4gQ2FuIGl0
IGJlIGZpeGVkIGxpa2UgdGhpcz8KPiAKPiAtLS0gYS90b29scy9icGYvYnBm
dG9vbC9uZXQuYwo+ICsrKyBiL3Rvb2xzL2JwZi9icGZ0b29sL25ldC5jCj4g
QEAgLTU3OCw4ICs1NzgsOCBAQCBzdGF0aWMgaW50IGRvX2F0dGFjaChpbnQg
YXJnYywgY2hhciAqKmFyZ3YpCj4gCj4gIMKgwqDCoMKgwqDCoMKgIGlmaW5k
ZXggPSBuZXRfcGFyc2VfZGV2KCZhcmdjLCAmYXJndik7Cj4gIMKgwqDCoMKg
wqDCoMKgIGlmIChpZmluZGV4IDwgMSkgewo+IC3CoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIGNsb3NlKHByb2dmZCk7Cj4gLcKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgcmV0dXJuIC1FSU5WQUw7Cj4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgZXJyID0gLUVJTlZBTDsKPiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCBnb3RvIGNsZWFudXA7Cj4gIMKgwqDCoMKg
wqDCoMKgIH0KPiAKPiAgwqDCoMKgwqDCoMKgwqAgaWYgKGFyZ2MpIHsKPiBA
QCAtNTg3LDggKzU4Nyw4IEBAIHN0YXRpYyBpbnQgZG9fYXR0YWNoKGludCBh
cmdjLCBjaGFyICoqYXJndikKPiAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBvdmVyd3JpdGUgPSB0cnVlOwo+ICDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfSBlbHNlIHsKPiAgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBw
X2VycigiZXhwZWN0ZWQgJ292ZXJ3cml0ZScsIGdvdDogJyVzJz8iLCAqYXJn
dik7Cj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIGNsb3NlKHByb2dmZCk7Cj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiAtRUlOVkFMOwo+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBl
cnIgPSAtRUlOVkFMOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBnb3RvIGNsZWFudXA7Cj4gIMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCB9Cj4gIMKgwqDCoMKgwqDCoMKgIH0KPiAK
PiBAQCAtNTk3LDE2ICs1OTcsMTkgQEAgc3RhdGljIGludCBkb19hdHRhY2go
aW50IGFyZ2MsIGNoYXIgKiphcmd2KQo+ICDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgZXJyID0gZG9fYXR0YWNoX2RldGFjaF94ZHAocHJvZ2Zk
LCBhdHRhY2hfdHlwZSwgaWZpbmRleCwKPiAgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIG92ZXJ3cml0ZSk7Cj4gCj4gLcKgwqDC
oMKgwqDCoCBpZiAoZXJyIDwgMCkgewo+ICvCoMKgwqDCoMKgwqAgaWYgKGVy
cikgewo+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcF9lcnIo
ImludGVyZmFjZSAlcyBhdHRhY2ggZmFpbGVkOiAlcyIsCj4gIMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBhdHRhY2hfdHlw
ZV9zdHJpbmdzW2F0dGFjaF90eXBlXSwgc3RyZXJyb3IoLWVycikpOwo+IC3C
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiBlcnI7Cj4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZ290byBjbGVhbnVwOwo+ICDC
oMKgwqDCoMKgwqDCoCB9Cj4gCj4gIMKgwqDCoMKgwqDCoMKgIGlmIChqc29u
X291dHB1dCkKPiAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGpz
b253X251bGwoanNvbl93dHIpOwo+IAo+IC3CoMKgwqDCoMKgwqAgcmV0dXJu
IDA7Cj4gK8KgwqDCoMKgwqDCoCByZXQgPSAwOwo+ICtjbGVhbnVwOgo+ICvC
oMKgwqDCoMKgwqAgY2xvc2UocHJvZ2ZkKTsKPiArwqDCoMKgwqDCoMKgIHJl
dHVybiBlcnI7Cj4gIMKgfQo+IAoKTEdUTS4gU2VuZCBhIHYzLg==
