Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8EEF5F596F
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 19:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbiJER4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 13:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbiJER4r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 13:56:47 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 309FD78BCE
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 10:56:46 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id q17-20020a25f911000000b006bcc33faa7bso16463300ybe.4
        for <netdev@vger.kernel.org>; Wed, 05 Oct 2022 10:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2X3fG6D6cXnzhkFiPRU1setr5jl+OiAwzFhoXUs00mU=;
        b=m+OezHN53kMhx7UOKpMSs4pVaBy43abQV5loa4CLbl6/kkKfja5Wt0AJPEriujA0+s
         Y/RaP2EDBjihHPVTsq9vr0RezvG8Ma8hz4/2azA6BbztCsgDhtZwy7B5J3jcnJCefv8Q
         hOGLGuD0TAKlJA1FreZVZc2xsIRgX1H9YtAfNn/RCgNJ2yU742C9KH2IoCgmBdBlwaB2
         LTScf95/F84W6+knMeailfgfzME5bm+3KzKUAAOIEcClubg/M0NXO0Di4Rg6KzzEhMB+
         GQ4ffdhV+FwqiW+cA3gJmYcjOxhYmhM/bW/vcPNFUkMjgVRQiYREN5v8Xxbm9h4W/sNY
         KFPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2X3fG6D6cXnzhkFiPRU1setr5jl+OiAwzFhoXUs00mU=;
        b=aqyHmjwQyBL0NurFJ9LhxBkdJf0/w9OR1zJkND00puLxkJp1Wew74qf3rsd/IFHN0N
         6YDb3n8w3qH3NzINeZ8sJb/hmay6wkMafQytcdhIgermF2o4R5+Pbj3/wNgW3zRagGPs
         vS39wjIBNqLtp5HgKwvfCbsse0gCXpCbHQbFhmoAC+Qtorr/dT/dale8oMxDF+phoqKu
         H1v9VwVKntsI9IdYqLQZt0oJan4P9DjoQxCVyHJPpH5vpw2SsqPEC2VQSTT5bzyiVeyV
         7ztHbTZV0OWzv5d2Az8Wgrf1uJuj2q00DLnpyCHdxvDrSSGRjBzyvGkrZidXX5qPYbUN
         /tcg==
X-Gm-Message-State: ACrzQf0pLSEZ4pWU8svjJKfzGpkK8m78rqr+lFLplRLxYLoYOAKUbocZ
        HrROxpI8HwarusJcNZTfYDt0jrY=
X-Google-Smtp-Source: AMsMyM7FqogwXeno1iHyGSOgnPG6dmRkhitixk24e+XdCmUylzqlFQ/XXLz2qHX+V77s3lhgXjJhe80=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a25:e649:0:b0:6be:2d89:c84c with SMTP id
 d70-20020a25e649000000b006be2d89c84cmr1021921ybh.508.1664992604583; Wed, 05
 Oct 2022 10:56:44 -0700 (PDT)
Date:   Wed, 5 Oct 2022 10:56:43 -0700
In-Reply-To: <dd7b7afd-755b-e980-02b1-cfde0dad1236@iogearbox.net>
Mime-Version: 1.0
References: <20221004231143.19190-1-daniel@iogearbox.net> <20221004231143.19190-2-daniel@iogearbox.net>
 <YzzWDqAmN5DRTupQ@google.com> <dd7b7afd-755b-e980-02b1-cfde0dad1236@iogearbox.net>
Message-ID: <Yz3FW/H06XS5toBo@google.com>
Subject: Re: [PATCH bpf-next 01/10] bpf: Add initial fd-based API to attach tc
 BPF programs
From:   sdf@google.com
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, razor@blackwall.org, ast@kernel.org,
        andrii@kernel.org, martin.lau@linux.dev, john.fastabend@gmail.com,
        joannelkoong@gmail.com, memxor@gmail.com, toke@redhat.com,
        joe@cilium.io, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvMDUsIERhbmllbCBCb3JrbWFubiB3cm90ZToNCj4gT24gMTAvNS8yMiAyOjU1IEFNLCBz
ZGZAZ29vZ2xlLmNvbSB3cm90ZToNCj4gPiBPbiAxMC8wNSwgRGFuaWVsIEJvcmttYW5uIHdyb3Rl
Og0KPiBbLi4uXQ0KPiA+DQo+ID4gVGhlIHNlcmllcyBsb29rcyBleGNpdGluZywgaGF2ZW4ndCBo
YWQgYSBjaGFuY2UgdG8gbG9vayBkZWVwbHksIHdpbGwgdHJ5DQo+ID4gdG8gZmluZCBzb21lIHRp
bWUgdGhpcyB3ZWVrLg0KDQo+IEdyZWF0LCB0aGFua3MhDQoNCj4gPiBXZSd2ZSBjaGF0dGVkIGJy
aWVmbHkgYWJvdXQgcHJpb3JpdHkgZHVyaW5nIHRoZSB0YWxrLCBsZXQncyBtYXliZSAgDQo+IGRp
c2N1c3MNCj4gPiBpdCBoZXJlIG1vcmU/DQo+ID4NCj4gPiBJLCBhcyBhIHVzZXIsIHN0aWxsIHJl
YWxseSBoYXZlIG5vIGNsdWUgYWJvdXQgd2hhdCBwcmlvcml0eSB0byB1c2UuDQo+ID4gV2UgaGF2
ZSB0aGlzIHByb2JsZW0gYXQgdGMsIGFuZCB3ZSdsbCBzZWVtaW5nbHkgaGF2ZSB0aGUgc2FtZSBw
cm9ibGVtDQo+ID4gaGVyZT8gSSBndWVzcyBpdCdzIGV2ZW4gbW9yZSByZWxldmFudCBpbiBrOHMg
YmVjYXVzZSBpbnRlcm5hbGx5IGF0IEcgd2UNCj4gPiBjYW4gY29udHJvbCB0aGUgdXNlcnMuDQo+
ID4NCj4gPiBJcyBpdCB3b3J0aCBhdCBsZWFzdCB0cnlpbmcgdG8gcHJvdmlkZSBzb21lIGRlZmF1
bHQgYmFuZHMgLyBndWlkYW5jZT8NCj4gPg0KPiA+IEZvciBleGFtcGxlLCBoYXZpbmcgU0VDKCd0
Yy9pbmdyZXNzJykgcmVjZWl2ZSBhdHRhY2hfcHJpb3JpdHk9MTI0IGJ5DQo+ID4gZGVmYXVsdD8g
TWF5YmUgd2UgY2FuIGV2ZW4gaGF2ZSBzb21ldGhpbmcgbGlrZSAndGMvaW5ncmVzc19maXJzdCcg
Z2V0DQo+ID4gYXR0YWNoX3ByaW9yaXR5PTEgYW5kICd0Yy9pbmdyZXNzX2xhc3QnIHdpdGggYXR0
YWNoX3ByaW9yaXR5PTI1ND8NCj4gPiAodGhlIG5hbWVzIGFyZSBhcmJpdHJhcnksIHdlIGNhbiBk
byBzb21ldGhpbmcgYmV0dGVyKQ0KPiA+DQo+ID4gaW5ncmVzc19maXJzdC9pbmdyZXNzX2xhc3Qg
Y2FuIGJlIHVzZWQgYnkgc29tZSBtb25pdG9yaW5nIGpvYnMuIFRoZSByZXN0DQo+ID4gY2FuIHVz
ZSBkZWZhdWx0IDEyNC4gSWYgc29tZWJvZHkgcmVhbGx5IG5lZWRzIGEgY3VzdG9tIHByaW9yaXR5
LCB0aGVuICANCj4gdGhleQ0KPiA+IGNhbiBtYW51YWxseSB1c2Ugc29tZXRoaW5nIGFyb3VuZCAx
MjQvMiBpZiB0aGV5IG5lZWQgdG8gdHJpZ2dlciBiZWZvcmUgIA0KPiB0aGUNCj4gPiAnZGVmYXVs
dCcgcHJpb3JpdHkgb3IgMTI0KzEyNC8yIGlmIHRoZXkgd2FudCB0byB0cmlnZ2VyIGFmdGVyPw0K
PiA+DQo+ID4gVGhvdWdodHM/IElzIGl0IHdvcnRoIGl0PyBEbyB3ZSBjYXJlPw0KDQo+IEkgdGhp
bmsgZ3VpZGFuY2UgaXMgbmVlZGVkLCB5ZXMsIEkgY2FuIGFkZCBhIGZldyBwYXJhZ3JhcGhzIHRv
IHRoZSBsaWJicGYNCj4gaGVhZGVyIGZpbGUgd2hlcmUgd2UgYWxzbyBoYXZlIHRoZSB0YyBCUEYg
bGluayBBUEkuIEkgaGFkIGEgYnJpZWYgIA0KPiBkaXNjdXNzaW9uDQo+IGFyb3VuZCB0aGlzIGFs
c28gd2l0aCBkZXZlbG9wZXJzIGZyb20gZGF0YWRvZyBhcyB0aGV5IGFsc28gdXNlIHRoZSBpbmZy
YQ0KPiB2aWEgdGMgQlBGLiBPdmVyYWxsLCBpdHMgYSBoYXJkIHByb2JsZW0sIGFuZCBJIGRvbid0
IHRoaW5rIHRoZXJlJ3MgYSBnb29kDQo+IGdlbmVyaWMgc29sdXRpb24uIFRoZSAnKl9sYXN0JyBp
cyBpbXBsaWVkIGJ5IHByaW89MCwgc28gdGhhdCBrZXJuZWwgYXV0by0NCj4gYWxsb2NhdGVzIGl0
LCBhbmQgZm9yIGxpYmJwZiB3ZSBjb3VsZCBhZGQgYW4gQVBJIGZvciBpdCB3aGVyZSB0aGUgdXNl
cg0KPiBkb2VzIG5vdCBuZWVkIHRvIHNwZWNpZnkgcHJpbyBzcGVjaWZpY2FsbHkuIFRoZSAnYXBw
ZW5kaW5nJyBpcyByZWFzb25hYmxlDQo+IHRvIG1lIGdpdmVuIGlmIGFuIGFwcGxpY2F0aW9uIGV4
cGxpY2l0bHkgcmVxdWVzdHMgdG8gYmUgYWRkZWQgYXMgZmlyc3QNCj4gKGFuZCBlLmcuIGVuZm9y
Y2VzIHBvbGljeSB0aHJvdWdoIHRjIEJQRiksIGJ1dCBzb21lIG90aGVyIDNyZCBwYXJ0eSAgDQo+
IGFwcGxpY2F0aW9uDQo+IHByZXBlbmRzIGl0c2VsZiBhcyBmaXJzdCwgaXQgY2FuIGJ5cGFzcyB0
aGUgZm9ybWVyLCB3aGljaCB3b3VsZCBiZSB0b28gIA0KPiBlYXN5DQo+IHRvIHNob290IHlvdXJz
ZWxmIGluIHRoZSBmb290LiBPdmVyYWxsIHRoZSBpc3N1ZSBpbiB0YyBsYW5kIGlzIHRoYXQgIA0K
PiBvcmRlcmluZw0KPiBtYXR0ZXJzLCBza2IgcGFja2V0IGRhdGEgY291bGQgYmUgbWFuZ2xlZCAo
ZS5nLiBJUHMgTkFUZWQpLCBza2IgZmllbGRzIGNhbg0KPiBiZSBtYW5nbGVkLCBhbmQgd2UgY2Fu
IGhhdmUgcmVkaXJlY3QgYWN0aW9ucyAoZGV2IEEgdnMuIEIpOyB0aGUgb25seSB3YXkgIA0KPiBJ
J2QNCj4gc2VlIHdlcmUgdGhpcyBpcyBwb3NzaWJsZSBpZiBzb21ld2hhdCB2ZXJpZmllciBjYW4g
YW5ub3RhdGUgdGhlIHByb2cgd2hlbg0KPiBpdCBkaWRuJ3Qgb2JzZXJ2ZSBhbnkgd3JpdGVzIHRv
IHNrYiwgYW5kIG5vIHJlZGlyZWN0IHdhcyBpbiBwbGF5LiBUaGVuICANCj4geW91J3ZlDQo+IGtp
bmQgb2YgcmVwbGljYXRlZCB0aGUgY29uc3RyYWludHMgc2ltaWxhciB0byB0cmFjaW5nIHdoZXJl
IHRoZSBhdHRhY2htZW50DQo+IGNhbiBzYXkgdGhhdCBvcmRlcmluZyBkb2Vzbid0IG1hdHRlciBp
ZiBhbGwgdGhlIHByb2dzIGFyZSBpbiBzYW1lIHN0eWxlLg0KPiBPdGhlcndpc2UsIGV4cGxpY2l0
IGNvcnBvcmF0aW9uIGlzIG5lZWRlZCBhcyBpcyB0b2RheSB3aXRoIHJlc3Qgb2YgdGMgKG9yDQo+
IGFzIFRva2UgZGlkIGluIGxpYnhkcCkgd2l0aCBtdWx0aS1hdHRhY2guIEluIHRoZSBzcGVjaWZp
YyBjYXNlIEkgbWVudGlvbmVkDQo+IGF0IExQQywgaXQgY2FuIGJlIG1hZGUgdG8gd29yayBnaXZl
biBvbmUgb2YgdGhlIHR3byBpcyBvbmx5IG9ic2VydmluZyAgDQo+IHRyYWZmaWMNCj4gYXQgdGhl
IGxheWVyLCBlLmcuIGl0IGNvdWxkIGdldCBwcmVwZW5kZWQgaWYgdGhlcmUgaXMgZ3VhcmFudGVl
IHRoYXQgYWxsDQo+IHJldHVybiBjb2RlcyBhcmUgdGNfYWN0X3Vuc3BlYyBzbyB0aGF0IHRoZXJl
IGlzIG5vIGJ5cGFzcyBhbmQgdGhlbiB5b3UnbGwNCj4gc2VlIGFsbCB0cmFmZmljIG9yIGFwcGVu
ZGVkIHRvIHNlZSBvbmx5IHRyYWZmaWMgd2hpY2ggbWFkZSBpdCBwYXN0IHRoZQ0KPiBwb2xpY3ku
IFNvIGl0IGFsbCBkZXBlbmRzIG9uIHRoZSBhcHBsaWNhdGlvbnMgaW5zdGFsbGluZyBwcm9ncmFt
cywgYnV0IHRvDQo+IHNvbHZlIGl0IGdlbmVyaWNhbGx5IGlzIG5vdCBwb3NzaWJsZSBnaXZlbiBv
cmRlcmluZyBhbmQgY29uZmxpY3RpbmcgIA0KPiBhY3Rpb25zLg0KPiBTbywgaW1obywgYW4gX2Fw
cGVuZCgpIEFQSSBmb3IgbGliYnBmIGNhbiBiZSBhZGRlZCBhbG9uZyB3aXRoIGd1aWRhbmNlIGZv
cg0KPiBkZXZlbG9wZXJzIHdoZW4gdG8gdXNlIF9hcHBlbmQoKSB2cyBleHBsaWNpdCBwcmlvLg0K
DQpBZ3JlZWQsIGl0J3MgYSBoYXJkIHByb2JsZW0gdG8gc29sdmUsIGVzcGVjaWFsbHkgZnJvbSB0
aGUga2VybmVsIHNpZGUuDQpJZGVhbGx5LCBhcyBUb2tlIG1lbnRpb25zIG9uIHRoZSBzaWRlIHRo
cmVhZCwgdGhlcmUgc2hvdWxkIGJlIHNvbWUga2luZA0Kb2Ygc3lzdGVtIGRhZW1vbiBvciBzb21l
IG90aGVyIHBsYWNlIHdoZXJlIHRoZSBvcmRlcmluZyBpcyBkZXNjcmliZWQuDQpCdXQgbGV0J3Mg
c3RhcnQgd2l0aCBhdCBsZWFzdCBzb21lIGd1aWRhbmNlIG9uIHRoZSBjdXJyZW50IHByaW8uDQoN
Ck1pZ2h0IGJlIGFsc28gYSBnb29kIGlkZWEgdG8gbmFycm93IGRvd24gdGhlIHByaW8gcmFuZ2Ug
dG8gMC02NWsgZm9yDQpub3c/IE1heWJlIGluIHRoZSBmdXR1cmUgd2UnbGwgaGF2ZSBzb21lIHNw
ZWNpYWwgUFJJT19NT05JVE9SSU5HX0JFRk9SRV9BTEwNCmFuZCBQUklPX01PTklUT1JJTkdfQUZU
RVJfQUxMIHRoYXQgdHJpZ2dlciByZWdhcmRsZXNzIG9mIFRDX0FDVF9VTlNQRUM/DQpJIGFncmVl
IHdpdGggVG9rZSB0aGF0IGl0J3MgYW5vdGhlciBwcm9ibGVtIHdpdGggdGhlIGN1cnJlbnQgYWN0
aW9uIGJhc2VkDQpjaGFpbnMgdGhhdCdzIHdvcnRoIHNvbHZpbmcgc29tZWhvdyAoY29tcGFyZWQg
dG8sIHNheSwgY2dyb3VwIHByb2dyYW1zKS4NCg0KPiBUaGFua3MsDQo+IERhbmllbA0KDQo+ID4g
PiDvv73vv73vv73vv73vv70gfTsNCj4gPg0KPiA+ID4g77+977+977+977+977+9IHN0cnVjdCB7
IC8qIGFub255bW91cyBzdHJ1Y3QgdXNlZCBieSBCUEZfUFJPR19URVNUX1JVTiBjb21tYW5kICAN
Cj4gKi8NCj4gPiA+IEBAIC0xNDUyLDcgKzE0NjAsMTAgQEAgdW5pb24gYnBmX2F0dHIgew0KPiA+
ID4g77+977+977+977+977+9IH0gaW5mbzsNCj4gPg0KPiA+ID4g77+977+977+977+977+9IHN0
cnVjdCB7IC8qIGFub255bW91cyBzdHJ1Y3QgdXNlZCBieSBCUEZfUFJPR19RVUVSWSBjb21tYW5k
ICovDQo+ID4gPiAt77+977+977+977+977+977+977+9IF9fdTMy77+977+977+977+977+977+9
77+9IHRhcmdldF9mZDvvv73vv73vv70gLyogY29udGFpbmVyIG9iamVjdCB0byBxdWVyeSAqLw0K
PiA+ID4gK++/ve+/ve+/ve+/ve+/ve+/ve+/vSB1bmlvbiB7DQo+ID4gPiAr77+977+977+977+9
77+977+977+977+977+977+977+9IF9fdTMy77+977+977+9IHRhcmdldF9mZDvvv73vv73vv70g
LyogY29udGFpbmVyIG9iamVjdCB0byBxdWVyeSAqLw0KPiA+ID4gK++/ve+/ve+/ve+/ve+/ve+/
ve+/ve+/ve+/ve+/ve+/vSBfX3UzMu+/ve+/ve+/vSB0YXJnZXRfaWZpbmRleDsgLyogdGFyZ2V0
IGlmaW5kZXggKi8NCg==
