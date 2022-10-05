Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D35C5F5A14
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 20:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbiJESrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 14:47:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231448AbiJESrc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 14:47:32 -0400
Received: from mail-oo1-xc49.google.com (mail-oo1-xc49.google.com [IPv6:2607:f8b0:4864:20::c49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 544626AEB3
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 11:47:31 -0700 (PDT)
Received: by mail-oo1-xc49.google.com with SMTP id i25-20020a4a6f59000000b004758bda2303so9179313oof.0
        for <netdev@vger.kernel.org>; Wed, 05 Oct 2022 11:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uIKaJQNDEBXQ5LIRD/exdnAwcdr6TfQKmZqIUyKLjOM=;
        b=rHSRB6g40vaZtXc17qUTKitpFwMzv7gj9BZpIWxsgodxP1VAVZT4ivwx9Ylp9Awxqw
         YuBmaTl9yN7s4jAmQm5p5CwjxTpCBr+HErqNQwOz+07dVwG3jkf1d4GE+pR0HUijubri
         Lfmvqs0WaSsDG0cW4dBz2gdQUoXb4/+MTRJUBt7wgSUVaNqNLnLtvz1ynSJDcRRq2N1C
         gWMSYJtYcLzpTjqhofDBHQsZyT/s77lc64WI1JiFIAbs/Iat/u4m5ry+HQ6C4G2rQD66
         wbe+X3M0tmj6LmAd5Hwc6TvF6kvHqPqN4nMcD2GWg+f6iQXNlzNvF+6Ci9iHrWJ33KZ2
         rIPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uIKaJQNDEBXQ5LIRD/exdnAwcdr6TfQKmZqIUyKLjOM=;
        b=2Oe37eGd1sm+nB2YvkzWZ/avhOMTkYfXAc6atmt1KnEn53fOvi9zwPxt26biRoNklR
         uwaMoSHoNNvFMvyI0HGXx0Yv8esgYIMOqJWDFH+IG9YLe3cC3nntVuvPuplUVFYwhG0S
         oHomKlQABrn4kicjUMxC6P4hOqgLVbKqk1STmhwPimJKosHk3tJyMFKZZ/LJU5D9GsdQ
         I3c+f/xzP3/0qKwbIDr7iUjcj08OJE5T6+edkXpMbyUsrZulVM9AvxAeOP/U8p98SqFH
         5NgipIuGK32MsFlnRmPEkaYj/h62XJzSVsw3R1sI1ysFN2dqpnp6DMj1Y2h2imX1scAo
         nC4g==
X-Gm-Message-State: ACrzQf2Fl/jixTXlkziLhPjbQc2v9ODKHz0KK13OQlQZplBfNjooETtv
        Sr8rfpEmOssnqlKL9I81IIumsrs=
X-Google-Smtp-Source: AMsMyM5ahHExplZ1c4fVpOzfrE+gidsGifNA21yAtFKDYj17RnlHJkdEY4AyGUfWpzptxnPNMCHhYPo=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a05:6808:1648:b0:333:45ae:3777 with SMTP id
 az8-20020a056808164800b0033345ae3777mr3064229oib.4.1664995650686; Wed, 05 Oct
 2022 11:47:30 -0700 (PDT)
Date:   Wed, 5 Oct 2022 11:47:29 -0700
In-Reply-To: <87h70iinzc.fsf@toke.dk>
Mime-Version: 1.0
References: <166256538687.1434226.15760041133601409770.stgit@firesoul>
 <Yzt2YhbCBe8fYHWQ@google.com> <35fcfb25-583a-e923-6eee-e8bbcc19db17@redhat.com>
 <CAKH8qBuYVk7QwVOSYrhMNnaKFKGd7M9bopDyNp6-SnN6hSeTDQ@mail.gmail.com>
 <5ccff6fa-0d50-c436-b891-ab797fe7e3c4@linux.dev> <20221004175952.6e4aade7@kernel.org>
 <CAKH8qBtdAeHqbWa33yO-MMgC2+h2qehFn8Y_C6ZC1=YsjQS-Bw@mail.gmail.com> <87h70iinzc.fsf@toke.dk>
Message-ID: <Yz3RQbh2TocpnuX0@google.com>
Subject: Re: [xdp-hints] Re: [PATCH RFCv2 bpf-next 00/18] XDP-hints: XDP
 gaining access to HW offload hints via BTF
From:   sdf@google.com
To:     "Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?=" <toke@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        brouer@redhat.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        xdp-hints@xdp-project.net, larysa.zaremba@intel.com,
        memxor@gmail.com, Lorenzo Bianconi <lorenzo@kernel.org>,
        mtahhan@redhat.com,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        dave@dtucker.co.uk, Magnus Karlsson <magnus.karlsson@intel.com>,
        bjorn@kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvMDUsIFRva2UgSO+/vWlsYW5kLUrvv71yZ2Vuc2VuIHdyb3RlOg0KPiBTdGFuaXNsYXYg
Rm9taWNoZXYgPHNkZkBnb29nbGUuY29tPiB3cml0ZXM6DQoNCj4gPiBPbiBUdWUsIE9jdCA0LCAy
MDIyIGF0IDU6NTkgUE0gSmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz4gd3JvdGU6DQo+
ID4+DQo+ID4+IE9uIFR1ZSwgNCBPY3QgMjAyMiAxNzoyNTo1MSAtMDcwMCBNYXJ0aW4gS2FGYWkg
TGF1IHdyb3RlOg0KPiA+PiA+IEEgaW50ZW50aW9uYWxseSB3aWxkIHF1ZXN0aW9uLCB3aGF0IGRv
ZXMgaXQgdGFrZSBmb3IgdGhlIGRyaXZlciB0byAgDQo+IHJldHVybiB0aGUNCj4gPj4gPiBoaW50
cy4gIElzIHRoZSByeF9kZXNjIGFuZCByeF9xdWV1ZSBlbm91Z2g/ICBXaGVuIHRoZSB4ZHAgcHJv
ZyBpcyAgDQo+IGNhbGxpbmcgYQ0KPiA+PiA+IGtmdW5jL2JwZi1oZWxwZXIsIGxpa2UgJ2h3dHN0
YW1wID0gYnBmX3hkcF9nZXRfaHd0c3RhbXAoKScsIGNhbiB0aGUgIA0KPiBkcml2ZXINCj4gPj4g
PiByZXBsYWNlIGl0IHdpdGggc29tZSBpbmxpbmUgYnBmIGNvZGUgKGxpa2UgaG93IHRoZSBpbmxp
bmUgY29kZSBpcyAgDQo+IGdlbmVyYXRlZCBmb3INCj4gPj4gPiB0aGUgbWFwX2xvb2t1cCBoZWxw
ZXIpLiAgVGhlIHhkcCBwcm9nIGNhbiB0aGVuIHN0b3JlIHRoZSBod3N0YW1wIGluICANCj4gdGhl
IG1ldGENCj4gPj4gPiBhcmVhIGluIGFueSBsYXlvdXQgaXQgd2FudHMuDQo+ID4+DQo+ID4+IFNp
bmNlIHlvdSBtZW50aW9uZWQgaXQuLi4gRldJVyB0aGF0IHdhcyBhbHdheXMgbXkgcHJlZmVyZW5j
ZSByYXRoZXIgIA0KPiB0aGFuDQo+ID4+IHRoZSBCVEYgbWFnaWMgOikgIFRoZSBqaXRlZCBpbWFn
ZSB3b3VsZCBoYXZlIHRvIGJlIHBlci1kcml2ZXIgbGlrZSB3ZQ0KPiA+PiBkbyBmb3IgQlBGIG9m
ZmxvYWQgYnV0IHRoYXQncyBlYXN5IHRvIGRvIGZyb20gdGhlIHRlY2huaWNhbA0KPiA+PiBwZXJz
cGVjdGl2ZSAoSSBkb3VidCBtYW55IGRlcGxveW1lbnRzIGJpbmQgdGhlIHNhbWUgcHJvZyB0byBt
dWx0aXBsZQ0KPiA+PiBIVyBkZXZpY2VzKS4uDQo+ID4NCj4gPiArMSwgc291bmRzIGxpa2UgYSBn
b29kIGFsdGVybmF0aXZlIChnb3QgeW91ciByZXBseSB3aGlsZSB0eXBpbmcpDQo+ID4gSSdtIG5v
dCB0b28gdmVyc2VkIGluIHRoZSByeF9kZXNjL3J4X3F1ZXVlIGFyZWEsIGJ1dCBzZWVtcyBsaWtl
IHdvcnN0DQo+ID4gY2FzZSB0aGF0IGJwZl94ZHBfZ2V0X2h3dHN0YW1wIGNhbiBwcm9iYWJseSBy
ZWNlaXZlIGEgeGRwX21kIGN0eCBhbmQNCj4gPiBwYXJzZSBpdCBvdXQgZnJvbSB0aGUgcHJlLXBv
cHVsYXRlZCBtZXRhZGF0YT8NCj4gPg0KPiA+IEJ0dywgZG8gd2UgYWxzbyBuZWVkIHRvIHRoaW5r
IGFib3V0IHRoZSByZWRpcmVjdCBjYXNlPyBXaGF0IGhhcHBlbnMNCj4gPiB3aGVuIEkgcmVkaXJl
Y3Qgb25lIGZyYW1lIGZyb20gYSBkZXZpY2UgQSB3aXRoIG9uZSBtZXRhZGF0YSBmb3JtYXQgdG8N
Cj4gPiBhIGRldmljZSBCIHdpdGggYW5vdGhlcj8NCg0KPiBZZXMsIHdlIGFic29sdXRlbHkgZG8h
IEluIGZhY3QsIHRvIG1lIHRoaXMgKHJlZGlyZWN0cykgaXMgdGhlIG1haW4NCj4gcmVhc29uIHdo
eSB3ZSBuZWVkIHRoZSBJRCBpbiB0aGUgcGFja2V0IGluIHRoZSBmaXJzdCBwbGFjZTogd2hlbiBy
dW5uaW5nDQo+IG9uIChzYXkpIGEgdmV0aCwgYW4gWERQIHByb2dyYW0gbmVlZHMgdG8gYmUgYWJs
ZSB0byBkZWFsIHdpdGggcGFja2V0cw0KPiBmcm9tIG11bHRpcGxlIHBoeXNpY2FsIE5JQ3MuDQoN
Cj4gQXMgZmFyIGFzIEFQSSBpcyBjb25jZXJuZWQsIG15IGhvcGUgd2FzIHRoYXQgd2UgY291bGQg
c29sdmUgdGhpcyB3aXRoIGENCj4gQ08tUkUgbGlrZSBhcHByb2FjaCB3aGVyZSB0aGUgcHJvZ3Jh
bSBhdXRob3IganVzdCB3cml0ZXMgc29tZXRoaW5nIGxpa2U6DQoNCj4gaHdfdHN0YW1wID0gYnBm
X2dldF94ZHBfaGludCgiaHdfdHN0YW1wIiwgdTY0KTsNCg0KPiBhbmQgYnBmX2dldF94ZHBfaGlu
dCgpIGlzIHJlYWxseSBhIG1hY3JvIChvciBhIHNwZWNpYWwga2luZCBvZg0KPiByZWxvY2F0aW9u
PykgYW5kIGxpYmJwZiB3b3VsZCBkbyB0aGUgZm9sbG93aW5nIG9uIGxvYWQ6DQoNCj4gLSBxdWVy
eSB0aGUga2VybmVsIEJURiBmb3IgYWxsIHBvc3NpYmxlIHhkcF9oaW50IHN0cnVjdHMNCj4gLSBm
aWd1cmUgb3V0IHdoaWNoIG9mIHRoZW0gaGF2ZSBhbiAndTY0IGh3X3RzdGFtcCcgbWVtYmVyDQo+
IC0gZ2VuZXJhdGUgdGhlIG5lY2Vzc2FyeSBjb25kaXRpb25hbHMgLyBqdW1wIHRhYmxlIHRvIGRp
c2FtYmlndWF0ZSBvbg0KPiAgICB0aGUgQlRGX0lEIGluIHRoZSBwYWNrZXQNCg0KDQo+IE5vdywg
aWYgdGhpcyBpcyBiZXR0ZXIgZG9uZSBieSBhIGtmdW5jIEknbSBub3QgdGVycmlibHkgb3Bwb3Nl
ZCB0byB0aGF0DQo+IGVpdGhlciwgYnV0IEknbSBub3Qgc3VyZSBpdCdzIGFjdHVhbGx5IGJldHRl
ci9lYXNpZXIgdG8gZG8gaW4gdGhlIGtlcm5lbA0KPiB0aGFuIGluIGxpYmJwZiBhdCBsb2FkIHRp
bWU/DQoNClJlcGxpZWQgaW4gdGhlIG90aGVyIHRocmVhZCwgYnV0IHRvIHJlaXRlcmF0ZSBoZXJl
OiB0aGVuIGJ0Zl9pZCBpbiB0aGUNCm1ldGFkYXRhIGhhcyB0byBzdGF5IGFuZCB3ZSBlaXRoZXIg
cHJlLWdlbmVyYXRlIHRob3NlIGJwZl9nZXRfeGRwX2hpbnQoKQ0KYXQgbGliYnBmIG9yIGF0IGtm
dW5jIGxvYWQgdGltZSBsZXZlbCBhcyB5b3UgbWVudGlvbi4NCg0KQnV0IHRoZSBwcm9ncmFtIGVz
c2VudGlhbGx5IGhhcyB0byBoYW5kbGUgYWxsIHBvc3NpYmxlIGhpbnRzJyBidGYgaWRzIHRocm93
bg0KYXQgaXQgYnkgdGhlIHN5c3RlbS4gTm90IHN1cmUgYWJvdXQgdGhlIHBlcmZvcm1hbmNlIGlu
IHRoaXMgY2FzZSA6LS8NCk1heWJlIHRoYXQncyBzb21ldGhpbmcgdGhhdCBjYW4gYmUgaGlkZGVu
IGJlaGluZCAiSSBtaWdodCByZWNlaXZlIGZvcndhcmRlZA0KcGFja2V0cyBhbmQgSSBrbm93IGhv
dyB0byBoYW5kbGUgYWxsIG1ldGFkYXRhIGZvcm1hdCIgZmxhZz8gQnkgZGVmYXVsdCwNCndlJ2xs
IHByZS1nZW5lcmF0ZSBwYXJzaW5nIG9ubHkgZm9yIHRoYXQgc3BlY2lmaWMgZGV2aWNlPw0K
