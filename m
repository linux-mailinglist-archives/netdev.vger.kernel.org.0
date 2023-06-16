Return-Path: <netdev+bounces-11447-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D60D733267
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 15:42:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CBF51281788
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 13:42:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0172171D0;
	Fri, 16 Jun 2023 13:42:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE581113
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 13:42:13 +0000 (UTC)
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 711C62120;
	Fri, 16 Jun 2023 06:41:56 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1b515ec39feso1543315ad.0;
        Fri, 16 Jun 2023 06:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686922916; x=1689514916;
        h=content-transfer-encoding:mime-version:references:in-reply-to:from
         :subject:cc:to:message-id:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ev1ai99dKs7hams1foqOhKxON/kJVjL0xwqO5+JmSEQ=;
        b=bhhDJTbUByVdYrVQKy/32qYee40KBH8zFmLtyl3gxJO19qT13rO37x6dMPln2GlZYX
         cEJZ1GquBR773PJHkLmagpfV5qE37lcObGmCSmNirme7JaP/2fnU1zLc8lm2FxEspvmB
         E+aLMBj4KoHDHsaY5EqvlcJLK27CgJ1YnwMeC67W5NDrrnSUHf96Af0Y1lncFrHYG/DW
         y9q3DMtPsgHNJuPeafXqVtHoEWU1DSIqRBSXThD6pMuV4LQkzeyex6Yi4jRVHoizpdXI
         wfxBWmH3+XpTSdGoHqpEpjzKZ/cZXRyRQiWk/QFz7JGlDbopx068ytfhJP3lAf3yShY9
         ja0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686922916; x=1689514916;
        h=content-transfer-encoding:mime-version:references:in-reply-to:from
         :subject:cc:to:message-id:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Ev1ai99dKs7hams1foqOhKxON/kJVjL0xwqO5+JmSEQ=;
        b=W/Rw60hffH2pAN7bJuViShNZFq8tiQzTxTS6dBob55EI4PiAHzeV1jZzbeNhowTwy3
         Nxfw+SNtsyUguK0N1OfouehCD8+gJODjh8e2rJerDhUZOjmVNzIfSfWks5CJ/rIKfpoG
         98uBkhDYztmrmBcckwUGP++8mxrK++sRwWkKcAlyENj1X0D1rk2xNjdHmAFOXut/r04T
         I669VHY+SW6nBUtpP5i3lttaX6KJwMtY7pBMpAtQ/5UC7OfgxpaoAofHd/fPxiSFv9VA
         n9pyD9hlE2QAkfBBR0fcnKwqcAyhRsgN3Ep7BILjZWaTj9bmS89dmRHcH9ezJgOp2Ygm
         YGDg==
X-Gm-Message-State: AC+VfDzzdjc2Qymrw2X2kotl7gpDmvC0OPYuSc7gEZdOI5fqZUY9PzHA
	6olL9PiSO4WIeVoB0m1oBaUuAbiYjhXKxY45
X-Google-Smtp-Source: ACHHUZ5TMxV93USDx19COqox8hOJSC+80dzlElWhB03MWbc+3D/W3HgTvi0ASrv8uYc0qwJbRW6kdA==
X-Received: by 2002:a17:903:32c4:b0:1b0:3cda:6351 with SMTP id i4-20020a17090332c400b001b03cda6351mr2426854plr.0.1686922915803;
        Fri, 16 Jun 2023 06:41:55 -0700 (PDT)
Received: from localhost (ec2-54-68-170-188.us-west-2.compute.amazonaws.com. [54.68.170.188])
        by smtp.gmail.com with ESMTPSA id d6-20020a170902854600b001b3acbde983sm11717401plo.3.2023.06.16.06.41.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 06:41:55 -0700 (PDT)
Date: Fri, 16 Jun 2023 22:41:54 +0900 (JST)
Message-Id: <20230616.224154.2201573912759629956.ubuntu@gmail.com>
To: miguel.ojeda.sandonis@gmail.com
Cc: fujita.tomonori@gmail.com, kuba@kernel.org, netdev@vger.kernel.org,
 rust-for-linux@vger.kernel.org, aliceryhl@google.com, andrew@lunn.ch
Subject: Re: [PATCH 0/5] Rust abstractions for network device drivers
From: FUJITA Tomonori <fujita.tomonori@gmail.com>
In-Reply-To: <CANiq72mAHv8ozBsZ9-ax9kY8OfESFAc462CxrKNv0gC3r0=Xmg@mail.gmail.com>
References: <20230615191931.4e4751ac@kernel.org>
	<20230616.211821.1815408081024606989.ubuntu@gmail.com>
	<CANiq72mAHv8ozBsZ9-ax9kY8OfESFAc462CxrKNv0gC3r0=Xmg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

SGksDQoNCk9uIEZyaSwgMTYgSnVuIDIwMjMgMTU6MjM6MDEgKzAyMDANCk1pZ3VlbCBPamVkYSA8
bWlndWVsLm9qZWRhLnNhbmRvbmlzQGdtYWlsLmNvbT4gd3JvdGU6DQoNCj4gT24gRnJpLCBKdW4g
MTYsIDIwMjMgYXQgMjoxOOKAr1BNIEZVSklUQSBUb21vbm9yaQ0KPiA8ZnVqaXRhLnRvbW9ub3Jp
QGdtYWlsLmNvbT4gd3JvdGU6DQo+Pg0KPj4gQXMgZmFyIGFzIEkga25vdywgbm8gc3Vic3lzdGVt
IGhhcyBhY2NlcHRlZCBSdXN0IGJpbmRpbmdzIHlldC4NCj4gDQo+IEZvciBhYnN0cmFjdGlvbnMg
aW4gZ2VuZXJhbCAoc2VlIG15IHByZXZpb3VzIHJlcGx5IGZvciAicmVhbCBIVyINCj4gZXRjLiks
IHRoZSBLVW5pdCBzdWJzeXN0ZW0gWzFdIHdoaWNoIGlzIG9uYm9hcmQgYW5kIHRha2luZyBzb21l
DQo+IHBhdGNoZXMgdGhyb3VnaCB0aGVpciB0cmVlIC8gb3duZXJzaGlwIG9mIHRoZSBjb2RlLg0K
PiANCj4gWzFdIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL3J1c3QtZm9yLWxpbnV4L0NBQlZnT1Nu
cHJ2eHppLXo0MktGak9ac2lSVXY3dTdFMnBvVkdKTm1UZlMyT1U0eDRBQUBtYWlsLmdtYWlsLmNv
bS8NCj4gDQo+PiBSZXBsYWNpbmcgdGhlIGV4aXN0aW5nIEMgZHJpdmVyIGZvciByZWFsIEhXIHdp
dGggUnVzdCBuZXcgb25lIGRvZXNuJ3QNCj4+IG1ha2Ugc2Vuc2UsIHJpZ2h0PyBTbyBhIG5lY2Vz
c2FyeSBjb25kaXRpb24gb2YgZ2V0dGluZyBSdXN0IGJpbmRpbmdzDQo+PiBmb3IgYSBzdWJzeXN0
ZW0gYWNjZXB0ZWQgaXMgdGhhdCBhIEhXIHZlcm5kb3IgaW1wbGVtZW50cyBib3RoIGEgZHJpdmVy
DQo+PiBhbmQgYmluZGluZ3MgZm9yIHRoZWlyIG5ldyBIVz8NCj4gDQo+IE5vdCBuZWNlc3Nhcmls
eS4gSXQgaXMgdHJ1ZSB0aGF0LCBpbiBnZW5lcmFsLCB0aGUga2VybmVsIGRvZXMgbm90DQo+IHdh
bnQvYWNjZXB0IGR1cGxpY2F0ZSBpbXBsZW1lbnRhdGlvbnMuDQo+IA0KPiBIb3dldmVyLCB0aGlz
IGlzIGEgYml0IG9mIGEgc3BlY2lhbCBzaXR1YXRpb24sIGFuZCB0aGVyZSBtYXkgYmUgc29tZQ0K
PiByZWFzb25zIHRvIGFsbG93IGZvciBpdCBpbiBhIGdpdmVuIHN1YnN5c3RlbS4gRm9yIGluc3Rh
bmNlOg0KPiANCj4gICAtIFRoZSBuZWVkIHRvIGV4cGVyaW1lbnQgd2l0aCBSdXN0Lg0KPiANCj4g
ICAtIFRvIGhhdmUgYW4gYWN0dWFsIGluLXRyZWUgdXNlciB0aGF0IGFsbG93cyB0byBkZXZlbG9w
IHRoZQ0KPiBhYnN0cmFjdGlvbnMgZm9yIGEgc3Vic3lzdGVtLCBzbyB0aGF0IGxhdGVyIHRoZXkg
YXJlIHJlYWR5IHRvIGJlIHVzZWQNCj4gZm9yIGZ1dHVyZSwgYWN0dWFsIG5ldyBkcml2ZXJzLg0K
PiANCj4gICAtIFBlbmRpbmcgcmVkZXNpZ25zOiBzb21ldGltZXMgc3Vic3lzdGVtcyBtYXkgaGF2
ZSBhDQo+IHJlZGVzaWduL3JlZmFjdG9yL2V4cGVyaW1lbnQgdGhhdCB0aGV5IGhhdmUgd2FudGVk
IHRvIGRvIGZvciBhIHdoaWxlLA0KPiBzbyB0aGV5IG1heSB0YWtlIHRoZSBjaGFuY2UgdG8gYWxz
byB0cnkgdG8gd3JpdGUgaXQgaW4gUnVzdCBhbnl3YXkuIE9mDQo+IGNvdXJzZSwgdGhhdCBjb3Vs
ZCBjb25mbGF0ZSB0d28gZXhwZXJpbWVudHMsIGJ1dC4uLiA6KQ0KPiANCj4gICAtIFNlY3VyaXR5
OiB0aGVyZSBtYXkgYmUgc29tZSBtb2R1bGVzIHRoYXQgaGF2ZSBiZWVuIHByb2JsZW1hdGljIGlu
DQo+IHRoZSBwYXN0IChlc3BlY2lhbGx5IGlmIGR1ZSB0byBtZW1vcnkgc2FmZXR5IGlzc3VlcyAv
IGRhdGEgcmFjZXMpLCBhbmQNCj4gdGhlIHN1YnN5c3RlbSBtYXkgYmUgd2lsbGluZyB0byBhY2Nl
cHQgYSBwYXJhbGxlbCBpbXBsZW1lbnRhdGlvbiB0bw0KPiBzZWUgaWYgaXQgd291bGQgYmUgYW4g
aW1wcm92ZW1lbnQgdGhhbmtzIHRvIFJ1c3QncyBwcm9wZXJ0aWVzLg0KDQpZZWFoLCBJIGtub3cg
OikgQnV0IHdoYXQgSSB3YW50IHRvIGtub3cgaXMgaWYgdGhlcmUgYXJlIHN1Y2ggcmVhc29ucw0K
Zm9yIG5ldGRldiBzdWJzeXN0ZW0sIGEgbmVjZXNzYXJ5IGNvbmRpdGlvbiBvZiBnZXR0aW5nIFJ1
c3QgYmluZGluZ3MNCmFjY2VwdGVkIGZvciB0aGUgbmV0ZGV2IG1haW50YWluZXJzLg0KDQp0aGFu
a3MsDQoNCg0KDQo=

