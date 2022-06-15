Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13EFB54D29F
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 22:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346105AbiFOUdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 16:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345719AbiFOUdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 16:33:03 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79DCDB7D2
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 13:33:01 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id g129-20020a636b87000000b00401b8392ac8so7005264pgc.4
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 13:33:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc:content-transfer-encoding;
        bh=ujy1VXrGiTM/BmY5p8pRWYHVBuEl168+JBaa8y5LA0A=;
        b=PD/m4DFXJwTrxvic97HQ7cwOhj3nj0GzhsCiyfRs9dsKkIsBfgZgNnl5XUh62j9N7d
         UL09PcSOOgWO5DQ/djJ0yQmDNjLGlW71u1U61Usuvw5e7aj0bhrMmG8EsOiznvE0/hIs
         DqgX9/YNWWjDE5qcn2Of4oPylqLcsvkPxoTQ5mkoO74yN98Yp6ajPk1W4AFW/kQkTIzR
         N4/ThJJbRcyAtBwb4vcRiPtBox6EajXd53Xs4nXXWlfVPsbUWreMkNWwashfkSGRNftA
         6jaUl1r3XRmaR+/AqhD7pCyJAu73vyygEnmfmzCtsxBaAOQhFLkphQnqHATGBMylEBCB
         uU+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc:content-transfer-encoding;
        bh=ujy1VXrGiTM/BmY5p8pRWYHVBuEl168+JBaa8y5LA0A=;
        b=dtF1g3wL929c/YpNLC6QuzGiyFgE2KUbqkShEwRIqhu3n4qgk04WO55DB57PpZVCzi
         P0D6EQXcGX+/WftQPfDaQcsbHBM398H6Du0LwJjNt2roNkUr4TzIDZYx7fpjbT4B55DI
         7S0m0ltHAtmOl+phFz417u8YfMHbI28QOHySnW3FVRTne+OU64XSvq26PFcbkeHD64IJ
         1CoG9yyn3KSGiYPhlwNBEwi0fsiFY8T5bpFg7mlQTXFwxPn5jqf3OoE4P0TPW5MLXkB4
         Y3O3C9EOZFWuxsOH1DakkpIOItiz1eK+INfdwYUyn0EpiiWKZS7Ns0tUuv/WMDxIKdOB
         H/bw==
X-Gm-Message-State: AJIora/Iu0CjXRGvmjlZbKNK51CPyeDr+vRmkhBRfYYCOQ8k1uFh5Ywv
        URQgW+yfOoCP2YhaF6dcf3q8nQU=
X-Google-Smtp-Source: AGRyM1veZtXzpqCj6Claz81umVhIeeolB3JmZKX43SUKoYJlg2NmfDL234+byW10I7nsqwEsd7PuIyw=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a05:6a00:14cb:b0:51c:3f31:b60e with SMTP id
 w11-20020a056a0014cb00b0051c3f31b60emr1357046pfu.27.1655325180864; Wed, 15
 Jun 2022 13:33:00 -0700 (PDT)
Date:   Wed, 15 Jun 2022 13:32:59 -0700
In-Reply-To: <YqpAYcvM9DakTjWL@google.com>
Message-Id: <YqpB+7pDwyOk20Cp@google.com>
Mime-Version: 1.0
References: <CAHo-Ooy+8O16k0oyMGHaAcmLm_Pfo=Ju4moTc95kRp2Z6itBcg@mail.gmail.com>
 <CANP3RGed9Vbu=8HfLyNs9zwA=biqgyew=+2tVxC6BAx2ktzNxA@mail.gmail.com>
 <CAADnVQKBqjowbGsSuc2g8yP9MBANhsroB+dhJep93cnx_EmNow@mail.gmail.com>
 <CANP3RGcZ4NULOwe+nwxfxsDPSXAUo50hWyN9Sb5b_d=kfDg=qg@mail.gmail.com>
 <YqodE5lxUCt6ojIw@google.com> <YqpAYcvM9DakTjWL@google.com>
Subject: Re: Curious bpf regression in 5.18 already fixed in stable 5.18.3
From:   sdf@google.com
To:     "Maciej =?utf-8?Q?=C5=BBenczykowski?=" <maze@google.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Linux NetDev <netdev@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Sasha Levin <sashal@kernel.org>,
        Carlos Llamas <cmllamas@google.com>, zhuyifei@google.com
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

T24gMDYvMTUsIFN0YW5pc2xhdiBGb21pY2hldiB3cm90ZToNCj4gT24gMDYvMTUsIHNkZkBnb29n
bGUuY29tIHdyb3RlOg0KPiA+IE9uIDA2LzE1LCBNYWNpZWogxbtlbmN6eWtvd3NraSB3cm90ZToN
Cj4gPiA+IE9uIFdlZCwgSnVuIDE1LCAyMDIyIGF0IDEwOjM4IEFNIEFsZXhlaSBTdGFyb3ZvaXRv
dg0KPiA+ID4gPGFsZXhlaS5zdGFyb3ZvaXRvdkBnbWFpbC5jb20+IHdyb3RlOg0KPiA+ID4gPg0K
PiA+ID4gPiBPbiBXZWQsIEp1biAxNSwgMjAyMiBhdCA5OjU3IEFNIE1hY2llaiDFu2VuY3p5a293
c2tpICANCj4gPG1hemVAZ29vZ2xlLmNvbT4NCj4gPiA+IHdyb3RlOg0KPiA+ID4gPiA+ID4NCj4g
PiA+ID4gPiA+IEkndmUgY29uZmlybWVkIHZhbmlsbGEgNS4xOC4wIGlzIGJyb2tlbiwgYW5kIGFs
bCBpdCB0YWtlcyBpcw0KPiA+ID4gPiA+ID4gY2hlcnJ5cGlja2luZyB0aGF0IHNwZWNpZmljIHN0
YWJsZSA1LjE4LnggcGF0Y2ggWw0KPiA+ID4gPiA+ID4gNzEwYTg5ODliNGI0MDY3OTAzZjViNjEz
MTRlZGE0OTE2NjdiNmFiMyBdIHRvIGZpeCBiZWhhdmlvdXIuDQo+ID4gPiA+IC4uLg0KPiA+ID4g
PiA+IGI4YmQzZWUxOTcxZDFlZGJjNTNjZjMyMmMxNDljYTAyMjc0NzJlNTYgdGhpcyBpcyB3aGVy
ZSB3ZSBhZGRlZA0KPiA+ID4gRUZBVUxUIGluIDUuMTYNCj4gPiA+ID4NCj4gPiA+ID4gVGhlcmUg
YXJlIG5vIHN1Y2ggc2hhLXMgaW4gdGhlIHVwc3RyZWFtIGtlcm5lbC4NCj4gPiA+ID4gU29ycnkg
d2UgY2Fubm90IGhlbHAgd2l0aCBkZWJ1Z2dpbmcgb2YgYW5kcm9pZCBrZXJuZWxzLg0KPiA+DQo+
ID4gPiBZZXMsIHNkZkAgcXVvdGVkIHRoZSB3cm9uZyBzaGExLCBpdCdzIGEgY2xlYW4gY2hlcnJ5
cGljayB0byBhbg0KPiA+ID4gaW50ZXJuYWwgYnJhbmNoIG9mDQo+ID4gPiAnYnBmOiBBZGQgY2dy
b3VwIGhlbHBlcnMgYnBmX3tnZXQsc2V0fV9yZXR2YWwgdG8gZ2V0L3NldCBzeXNjYWxsICANCj4g
cmV0dXJuDQo+ID4gPiB2YWx1ZScNCj4gPiA+IGNvbW1pdCBiNDQxMjNiNGEzZGNhZDQ2NjRkM2Ew
ZjcyYzAxMWZmZDRjOWM0ZDkzLg0KPiA+DQo+ID4gPiAgDQo+IGh0dHBzOi8vZ2l0Lmtlcm5lbC5v
cmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3N0YWJsZS9saW51eC5naXQvY29tbWl0Lz9oPWxp
bnV4LTUuMTYueSZpZD1iNDQxMjNiNGEzZGNhZDQ2NjRkM2EwZjcyYzAxMWZmZDRjOWM0ZDkzDQo+
ID4NCj4gPiA+IEFueXdheSwgSSB0aGluayBpdCdzIHVucmVsYXRlZCAtIG9yIGF0IGxlYXN0IG5v
dCB0aGUgaW1tZWRpYXRlIHJvb3QgIA0KPiBjYXVzZS4NCj4gPg0KPiA+ID4gQWxzbyB0aGVyZSdz
ICpubyogQW5kcm9pZCBrZXJuZWxzIGludm9sdmVkIGhlcmUuDQo+ID4gPiBUaGlzIGlzIHRoZSBh
bmRyb2lkIG5ldCB0ZXN0cyBmYWlsaW5nIG9uIHZhbmlsbGEgNS4xOCBhbmQgcGFzc2luZyBvbg0K
PiA+ID4gNS4xOC4zLg0KPiA+DQo+ID4gWWVhaCwgc29ycnksIGRpZG4ndCBtZWFuIHRvIHNlbmQg
dGhvc2Ugb3V0c2lkZSA6LSkNCj4gPg0KPiA+IEF0dGFjaGVkIHVuLWFuZHJvaWQtaWZpZWQgdGVz
dGNhc2UuIFBhc3NlcyBvbiBicGYtbmV4dCwgdHJ5aW5nIHRvIHNlZQ0KPiA+IHdoYXQgaGFwcGVu
cyBvbiB2YW5pbGxhIDUuMTguIFdpbGwgdXBkYXRlIG9uY2UgSSBnZXQgbW9yZSBkYXRhLi4NCg0K
PiBJJ3ZlIGJpc2VjdGVkIHRoZSBvcmlnaW5hbCBpc3N1ZSB0bzoNCg0KPiBiNDQxMjNiNGEzZGMg
KCJicGY6IEFkZCBjZ3JvdXAgaGVscGVycyBicGZfe2dldCxzZXR9X3JldHZhbCB0byBnZXQvc2V0
DQo+IHN5c2NhbGwgcmV0dXJuIHZhbHVlIikNCg0KPiBBbmQgSSBiZWxpZXZlIGl0J3MgdGhlc2Ug
dHdvIGxpbmVzIGZyb20gdGhlIG9yaWdpbmFsIHBhdGNoOg0KDQo+ICAgI2RlZmluZSBCUEZfUFJP
R19DR1JPVVBfSU5FVF9FR1JFU1NfUlVOX0FSUkFZKGFycmF5LCBjdHgsIGZ1bmMpCQlcDQo+ICAg
CSh7CQkJCQkJXA0KPiBAQCAtMTM5OCwxMCArMTM5OCwxMiBAQCBvdXQ6DQo+ICAgCQl1MzIgX3Jl
dDsJCQkJXA0KPiAgIAkJX3JldCA9IEJQRl9QUk9HX1JVTl9BUlJBWV9DR19GTEFHUyhhcnJheSwg
Y3R4LCBmdW5jLCAwLCAmX2ZsYWdzKTsgXA0KPiAgIAkJX2NuID0gX2ZsYWdzICYgQlBGX1JFVF9T
RVRfQ047CQlcDQo+ICsJCWlmIChfcmV0ICYmICFJU19FUlJfVkFMVUUoKGxvbmcpX3JldCkpCVwN
Cj4gKwkJCV9yZXQgPSAtRUZBVUxUOwkNCg0KPiBfcmV0IGlzIHUzMiBhbmQgcmV0IGdldHMgLTEg
KGZmZmZmZmZmKS4gSVNfRVJSX1ZBTFVFKChsb25nKWZmZmZmZmZmKSAgDQo+IHJldHVybnMNCj4g
ZmFsc2UgaW4gdGhpcyBjYXNlIGJlY2F1c2UgaXQgZG9lc24ndCBzaWduLWV4cGFuZCB0aGUgYXJn
dW1lbnQgYW5kICANCj4gaW50ZXJuYWxseQ0KPiBkb2VzIGZmZmZfZmZmZiA+PSBmZmZmX2ZmZmZf
ZmZmZl9mMDAxIGNvbXBhcmlzb24uDQoNCj4gSSdsbCB0cnkgdG8gc2VlIHdoYXQgSSd2ZSBjaGFu
Z2VkIGluIG15IHVucmVsYXRlZCBwYXRjaCB0byBmaXggaXQuIEJ1dCBJICANCj4gdGhpbmsNCj4g
d2Ugc2hvdWxkIGF1ZGl0IGFsbCB0aGVzZSBJU19FUlJfVkFMVUUoKGxvbmcpX3JldCkgcmVnYXJk
bGVzczsgdGhleSBkb24ndA0KPiBzZWVtIHRvIHdvcmsgdGhlIHdheSB3ZSB3YW50IHRoZW0gdG8u
Li4NCg0KT2ssIGFuZCBteSBwYXRjaCBmaXhlcyBpdCBiZWNhdXNlIEknbSByZXBsYWNpbmcgJ3Uz
MiBfcmV0JyB3aXRoICdpbnQgcmV0Jy4NCg0KU28sIGJhc2ljYWxseSwgd2l0aCB1MzIgX3JldCB3
ZSBoYXZlIHRvIGRvIElTX0VSUl9WQUxVRSgobG9uZykoaW50KV9yZXQpLg0KDQpTaWdoLi4NCg==
