Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8B4A599078
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 00:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241253AbiHRW0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 18:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231636AbiHRW0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 18:26:49 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5816DB7C8
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 15:26:48 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-3282fe8f48fso47748187b3.17
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 15:26:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:references
         :mime-version:message-id:in-reply-to:date:from:to:cc;
        bh=3dzEz+5ooRgF8avkdH5VBLX03uYb6EZoCcAZ4RgNj3M=;
        b=J7le2A97tgVl5q7PpsABbx48wBSzPyb6BcGwIRyACy/+lbWdlStt3NA1zcyRRoISqe
         GeL0+ZMc+0EsfdcfUVNhebSHON85oXdNq4xpld9Z7V7jZ0EPgTF/8lLH7X/zxLnhY/ag
         HHKf247HOtuIXvlP5I6UlBEd0f9ft5RImLJp2sTprxVhucnYKzjgewj2HUXyYpW+VslS
         ylDZ70zbcbK1eSaVBFJ83JgCgkFnGhIM1xWqVjM+BkLdOvbqydlZ5/e43oT4W0nI+uz5
         kfMuo9eXbmldzQMAWQv272QvedY2X7+7fh2rMcXr3S/yCwX//u1oZpQr9uuweNYwRioe
         E3Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:references
         :mime-version:message-id:in-reply-to:date:x-gm-message-state:from:to
         :cc;
        bh=3dzEz+5ooRgF8avkdH5VBLX03uYb6EZoCcAZ4RgNj3M=;
        b=7Ztt1N3fdflWrMSXQfTZwef9bz34tQLqr92m1jgq4bC4V8f3grO9soaYV1AYXHjQoS
         7pddfq+lZHPQwItkJmbRicN+KdGGok/T2qZP9/1AWgvttG85k7sR/powOdtnbqE2eHPx
         gA42su6WiDZ/TMls3jc0GrvsPB09LsOXOgLysgoTQp6m3WAJqEi/UiBhRdjylQG9c4xo
         +0cm2WPQGPOrSbCoCunJiYMSZeelshBY7zMTCLPsWGtVjkIfI770lVU+/gjNJIt+VaBy
         L36uSSX9EYIRihkGYE+f7JfIU4J/4YwCvXFo8lnl2WPpXE2xLwKcn08Ja87HYfc4NIsJ
         F/Dg==
X-Gm-Message-State: ACgBeo3RTRBxL80gCuegLQJN6rB9K+464TNNNAEAk6YIhF9oXdj9tgbi
        RNti8zksfYXzAFw09JI8TirfavU=
X-Google-Smtp-Source: AA6agR5C6XwltfPiKv7SrmdBRHA2hnAxOseB8BnK81AojTjhOkR0KA+cby/+3KRkWICykBX92j42lQ8=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a81:db10:0:b0:324:f418:1f33 with SMTP id
 u16-20020a81db10000000b00324f4181f33mr5031341ywm.212.1660861608120; Thu, 18
 Aug 2022 15:26:48 -0700 (PDT)
Date:   Thu, 18 Aug 2022 15:26:46 -0700
In-Reply-To: <20220818165906.64450-1-toke@redhat.com>
Message-Id: <Yv68pgkL++uD0a6e@google.com>
Mime-Version: 1.0
References: <20220818165906.64450-1-toke@redhat.com>
Subject: Re: [PATCH bpf-next 0/3] A couple of small refactorings of BPF
 program call sites
From:   sdf@google.com
To:     "Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?=" <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "=?iso-8859-1?Q?Bj=F6rn_T=F6pel?=" <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDgvMTgsIFRva2UgSO+/vWlsYW5kLUrvv71yZ2Vuc2VuIHdyb3RlOg0KPiBTdGFuaXNsYXYg
c3VnZ2VzdGVkWzBdIHRoYXQgdGhlc2Ugc21hbGwgcmVmYWN0b3JpbmdzIGNvdWxkIGJlIHNwbGl0
IG91dCAgDQo+IGZyb20gdGhlDQo+IFhEUCBxdWV1ZWluZyBSRkMgc2VyaWVzIGFuZCBtZXJnZWQg
c2VwYXJhdGVseS4gVGhlIGZpcnN0IGNoYW5nZSBpcyBhIHNtYWxsDQo+IHJlcGFja2luZyBvZiBz
dHJ1Y3Qgc29mdG5ldF9kYXRhLCB0aGUgb3RoZXJzIGNoYW5nZSB0aGUgQlBGIGNhbGwgc2l0ZXMg
dG8NCj4gc3VwcG9ydCBmdWxsIDY0LWJpdCB2YWx1ZXMgYXMgYXJndW1lbnRzIHRvIGJwZl9yZWRp
cmVjdF9tYXAoKSBhbmQgYXMgdGhlICANCj4gcmV0dXJuDQo+IHZhbHVlIG9mIGEgQlBGIHByb2dy
YW0sIHJlbHlpbmcgb24gdGhlIGZhY3QgdGhhdCBCUEYgcmVnaXN0ZXJzIGFyZSBhbHdheXMgIA0K
PiA2NC1iaXQNCj4gd2lkZSB0byBtYWludGFpbiBiYWNrd2FyZHMgY29tcGF0aWJpbGl0eS4NCg0K
PiBQbGVhc2Ugc2VlIHRoZSBpbmRpdmlkdWFsIHBhdGNoZXMgZm9yIGRldGFpbHMuDQoNCj4gWzBd
ICANCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvci9DQUtIOHFCdGRua3U3U3RjUS1TYW1hZHZB
Rj09RFJ1TExaTzk0eU9SMVdKOUJnPXVYMXdAbWFpbC5nbWFpbC5jb20NCg0KTG9va3MgbGlrZSBh
IG5pY2UgY2xlYW51cCB0byBtZToNClJldmlld2VkLWJ5OiBTdGFuaXNsYXYgRm9taWNoZXYgPHNk
ZkBnb29nbGUuY29tPg0KDQpDYW4geW91IHNoYXJlIG1vcmUgb24gdGhpcyBjb21tZW50Pw0KDQov
KiBGb3Igc29tZSBhcmNoaXRlY3R1cmVzLCB3ZSBuZWVkIHRvIGRvIG1vZHVsdXMgaW4gMzItYml0
IHdpZHRoICovDQoNClNvbWUgLSB3aGljaCBvbmVzPyBBbmQgd2h5IGRvIHRoZXkgbmVlZCBpdCB0
byBiZSAzMi1iaXQ/DQoNCj4gS3VtYXIgS2FydGlrZXlhIER3aXZlZGkgKDEpOg0KPiAgICBicGY6
IFVzZSA2NC1iaXQgcmV0dXJuIHZhbHVlIGZvciBicGZfcHJvZ19ydW4NCg0KPiBUb2tlIEjvv71p
bGFuZC1K77+9cmdlbnNlbiAoMik6DQo+ICAgIGRldjogTW92ZSByZWNlaXZlZF9ycHMgY291bnRl
ciBuZXh0IHRvIFJQUyBtZW1iZXJzIGluIHNvZnRuZXQgZGF0YQ0KPiAgICBicGY6IEV4cGFuZCBt
YXAga2V5IGFyZ3VtZW50IG9mIGJwZl9yZWRpcmVjdF9tYXAgdG8gdTY0DQoNCj4gICBpbmNsdWRl
L2xpbnV4L2JwZi1jZ3JvdXAuaCB8IDEyICsrKysrLS0tLS0NCj4gICBpbmNsdWRlL2xpbnV4L2Jw
Zi5oICAgICAgICB8IDE2ICsrKysrKy0tLS0tLS0NCj4gICBpbmNsdWRlL2xpbnV4L2ZpbHRlci5o
ICAgICB8IDQ2ICsrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0tDQo+ICAgaW5j
bHVkZS9saW51eC9uZXRkZXZpY2UuaCAgfCAgMiArLQ0KPiAgIGluY2x1ZGUvdWFwaS9saW51eC9i
cGYuaCAgIHwgIDIgKy0NCj4gICBrZXJuZWwvYnBmL2Nncm91cC5jICAgICAgICB8IDEyICsrKysr
LS0tLS0NCj4gICBrZXJuZWwvYnBmL2NvcmUuYyAgICAgICAgICB8IDE0ICsrKysrKy0tLS0tLQ0K
PiAgIGtlcm5lbC9icGYvY3B1bWFwLmMgICAgICAgIHwgIDQgKystLQ0KPiAgIGtlcm5lbC9icGYv
ZGV2bWFwLmMgICAgICAgIHwgIDQgKystLQ0KPiAgIGtlcm5lbC9icGYvb2ZmbG9hZC5jICAgICAg
IHwgIDQgKystLQ0KPiAgIGtlcm5lbC9icGYvdmVyaWZpZXIuYyAgICAgIHwgIDIgKy0NCj4gICBu
ZXQvYnBmL3Rlc3RfcnVuLmMgICAgICAgICB8IDIxICsrKysrKysrKy0tLS0tLS0tDQo+ICAgbmV0
L2NvcmUvZmlsdGVyLmMgICAgICAgICAgfCAgNCArKy0tDQo+ICAgbmV0L3BhY2tldC9hZl9wYWNr
ZXQuYyAgICAgfCAgNyArKysrLS0NCj4gICBuZXQveGRwL3hza21hcC5jICAgICAgICAgICB8ICA0
ICsrLS0NCj4gICAxNSBmaWxlcyBjaGFuZ2VkLCA4MCBpbnNlcnRpb25zKCspLCA3NCBkZWxldGlv
bnMoLSkNCg0KPiAtLQ0KPiAyLjM3LjINCg0K
