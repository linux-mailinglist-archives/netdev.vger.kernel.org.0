Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C99C654D2C5
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 22:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245697AbiFOUjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 16:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236585AbiFOUjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 16:39:16 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E21113F8A4
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 13:39:14 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id c11-20020a17090a4d0b00b001e4e081d525so1892569pjg.7
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 13:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc:content-transfer-encoding;
        bh=39LfOahOWBeznqRLsmc0XNeidpa6Y7IwGuuTQ+sNseU=;
        b=GHuxGEOysxz8flQI6TwxR3lQ7faLVTXmWuSJLd9OXuI+gXxsIsumlwaMTnW5DUyOzR
         TWCZqZMpziq1Ysu4nFYm2y49TqLvISRdc2WkUT2ejVGEmf+WVzua0jHfyOTXbaSz5/CQ
         TlhJDzi59xcrioxFYQYvhfezpj3DHDzsx/b9SXb+D6OwedCBmU+aM5dLcK2g9dTiotDR
         u6wxnVlPORFECR1p6r5Tx6aaL9+3r7wts7R/Cs37dZN+LMn3pp+qSagnHs3LPrITD7Zp
         icP37sMWQxTL57sAXJ/C2x24uozogM420bVPxEd59tMf9qBOMPgDVnFeilRtJMCDgBID
         0xuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc:content-transfer-encoding;
        bh=39LfOahOWBeznqRLsmc0XNeidpa6Y7IwGuuTQ+sNseU=;
        b=RhA0/ArOm4P0orYdiVdeVkNndceDOwbr1X9Zl8Q8oEkOkeTQgE7pgw7Uf+PSzU0Set
         /dJ4Rb92FDWatWvNKeSwjaptqdwR21zZpwRORK8MBGMWHFhyR/NpPO9NkZ/LwulkbGlQ
         rkPMt/jFY0M6ZZ/YvTi9yAwOaMLjj2V9QsLjuCge7zI2qDEAoiP8t+ZFlYRIm6/Wlj7R
         EGOxz8FCOR14Af1uGyXP46xFSIQFuH87gdSGJfsg2WukJMLPQVwkkH3NwDXd2/tA4dCF
         gQHV5v6oKgEuN0jeKmfcDhKW45/WBlCjBgFFG9kMnmMDmqwYIrtGR8TnDIYAcAhIjM+e
         0iMA==
X-Gm-Message-State: AJIora/leBJDVHSzlM4X01P7+Lo7JDHb9vAqOdGCHk5M0bAbB4Xc4klS
        q7W//iVr/FxlcdqZ/Aird7YihKA=
X-Google-Smtp-Source: AGRyM1tgc2AGGdSSDwOwbtM/nMgWQP9YKZBj1ztN16bLvGDO1/l9RcVNtwXkyAEQFi8H5A8QN35DWoU=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a05:6a00:410a:b0:51e:6fc6:e4da with SMTP id
 bu10-20020a056a00410a00b0051e6fc6e4damr1380745pfb.84.1655325554401; Wed, 15
 Jun 2022 13:39:14 -0700 (PDT)
Date:   Wed, 15 Jun 2022 13:39:12 -0700
In-Reply-To: <YqpB+7pDwyOk20Cp@google.com>
Message-Id: <YqpDcD6vkZZfWH4L@google.com>
Mime-Version: 1.0
References: <CAHo-Ooy+8O16k0oyMGHaAcmLm_Pfo=Ju4moTc95kRp2Z6itBcg@mail.gmail.com>
 <CANP3RGed9Vbu=8HfLyNs9zwA=biqgyew=+2tVxC6BAx2ktzNxA@mail.gmail.com>
 <CAADnVQKBqjowbGsSuc2g8yP9MBANhsroB+dhJep93cnx_EmNow@mail.gmail.com>
 <CANP3RGcZ4NULOwe+nwxfxsDPSXAUo50hWyN9Sb5b_d=kfDg=qg@mail.gmail.com>
 <YqodE5lxUCt6ojIw@google.com> <YqpAYcvM9DakTjWL@google.com> <YqpB+7pDwyOk20Cp@google.com>
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

T24gMDYvMTUsIFN0YW5pc2xhdiBGb21pY2hldiB3cm90ZToNCj4gT24gMDYvMTUsIFN0YW5pc2xh
diBGb21pY2hldiB3cm90ZToNCj4gPiBPbiAwNi8xNSwgc2RmQGdvb2dsZS5jb20gd3JvdGU6DQo+
ID4gPiBPbiAwNi8xNSwgTWFjaWVqIMW7ZW5jenlrb3dza2kgd3JvdGU6DQo+ID4gPiA+IE9uIFdl
ZCwgSnVuIDE1LCAyMDIyIGF0IDEwOjM4IEFNIEFsZXhlaSBTdGFyb3ZvaXRvdg0KPiA+ID4gPiA8
YWxleGVpLnN0YXJvdm9pdG92QGdtYWlsLmNvbT4gd3JvdGU6DQo+ID4gPiA+ID4NCj4gPiA+ID4g
PiBPbiBXZWQsIEp1biAxNSwgMjAyMiBhdCA5OjU3IEFNIE1hY2llaiDFu2VuY3p5a293c2tpICAN
Cj4gPG1hemVAZ29vZ2xlLmNvbT4NCj4gPiA+ID4gd3JvdGU6DQo+ID4gPiA+ID4gPiA+DQo+ID4g
PiA+ID4gPiA+IEkndmUgY29uZmlybWVkIHZhbmlsbGEgNS4xOC4wIGlzIGJyb2tlbiwgYW5kIGFs
bCBpdCB0YWtlcyBpcw0KPiA+ID4gPiA+ID4gPiBjaGVycnlwaWNraW5nIHRoYXQgc3BlY2lmaWMg
c3RhYmxlIDUuMTgueCBwYXRjaCBbDQo+ID4gPiA+ID4gPiA+IDcxMGE4OTg5YjRiNDA2NzkwM2Y1
YjYxMzE0ZWRhNDkxNjY3YjZhYjMgXSB0byBmaXggYmVoYXZpb3VyLg0KPiA+ID4gPiA+IC4uLg0K
PiA+ID4gPiA+ID4gYjhiZDNlZTE5NzFkMWVkYmM1M2NmMzIyYzE0OWNhMDIyNzQ3MmU1NiB0aGlz
IGlzIHdoZXJlIHdlIGFkZGVkDQo+ID4gPiA+IEVGQVVMVCBpbiA1LjE2DQo+ID4gPiA+ID4NCj4g
PiA+ID4gPiBUaGVyZSBhcmUgbm8gc3VjaCBzaGEtcyBpbiB0aGUgdXBzdHJlYW0ga2VybmVsLg0K
PiA+ID4gPiA+IFNvcnJ5IHdlIGNhbm5vdCBoZWxwIHdpdGggZGVidWdnaW5nIG9mIGFuZHJvaWQg
a2VybmVscy4NCj4gPiA+DQo+ID4gPiA+IFllcywgc2RmQCBxdW90ZWQgdGhlIHdyb25nIHNoYTEs
IGl0J3MgYSBjbGVhbiBjaGVycnlwaWNrIHRvIGFuDQo+ID4gPiA+IGludGVybmFsIGJyYW5jaCBv
Zg0KPiA+ID4gPiAnYnBmOiBBZGQgY2dyb3VwIGhlbHBlcnMgYnBmX3tnZXQsc2V0fV9yZXR2YWwg
dG8gZ2V0L3NldCBzeXNjYWxsICANCj4gcmV0dXJuDQo+ID4gPiA+IHZhbHVlJw0KPiA+ID4gPiBj
b21taXQgYjQ0MTIzYjRhM2RjYWQ0NjY0ZDNhMGY3MmMwMTFmZmQ0YzljNGQ5My4NCj4gPiA+DQo+
ID4gPiA+ICANCj4gaHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9n
aXQvc3RhYmxlL2xpbnV4LmdpdC9jb21taXQvP2g9bGludXgtNS4xNi55JmlkPWI0NDEyM2I0YTNk
Y2FkNDY2NGQzYTBmNzJjMDExZmZkNGM5YzRkOTMNCj4gPiA+DQo+ID4gPiA+IEFueXdheSwgSSB0
aGluayBpdCdzIHVucmVsYXRlZCAtIG9yIGF0IGxlYXN0IG5vdCB0aGUgaW1tZWRpYXRlIHJvb3Qg
IA0KPiBjYXVzZS4NCj4gPiA+DQo+ID4gPiA+IEFsc28gdGhlcmUncyAqbm8qIEFuZHJvaWQga2Vy
bmVscyBpbnZvbHZlZCBoZXJlLg0KPiA+ID4gPiBUaGlzIGlzIHRoZSBhbmRyb2lkIG5ldCB0ZXN0
cyBmYWlsaW5nIG9uIHZhbmlsbGEgNS4xOCBhbmQgcGFzc2luZyBvbg0KPiA+ID4gPiA1LjE4LjMu
DQo+ID4gPg0KPiA+ID4gWWVhaCwgc29ycnksIGRpZG4ndCBtZWFuIHRvIHNlbmQgdGhvc2Ugb3V0
c2lkZSA6LSkNCj4gPiA+DQo+ID4gPiBBdHRhY2hlZCB1bi1hbmRyb2lkLWlmaWVkIHRlc3RjYXNl
LiBQYXNzZXMgb24gYnBmLW5leHQsIHRyeWluZyB0byBzZWUNCj4gPiA+IHdoYXQgaGFwcGVucyBv
biB2YW5pbGxhIDUuMTguIFdpbGwgdXBkYXRlIG9uY2UgSSBnZXQgbW9yZSBkYXRhLi4NCj4gPg0K
PiA+IEkndmUgYmlzZWN0ZWQgdGhlIG9yaWdpbmFsIGlzc3VlIHRvOg0KPiA+DQo+ID4gYjQ0MTIz
YjRhM2RjICgiYnBmOiBBZGQgY2dyb3VwIGhlbHBlcnMgYnBmX3tnZXQsc2V0fV9yZXR2YWwgdG8g
Z2V0L3NldA0KPiA+IHN5c2NhbGwgcmV0dXJuIHZhbHVlIikNCj4gPg0KPiA+IEFuZCBJIGJlbGll
dmUgaXQncyB0aGVzZSB0d28gbGluZXMgZnJvbSB0aGUgb3JpZ2luYWwgcGF0Y2g6DQo+ID4NCj4g
PiAgI2RlZmluZSBCUEZfUFJPR19DR1JPVVBfSU5FVF9FR1JFU1NfUlVOX0FSUkFZKGFycmF5LCBj
dHgsIGZ1bmMpCQlcDQo+ID4gIAkoewkJCQkJCVwNCj4gPiBAQCAtMTM5OCwxMCArMTM5OCwxMiBA
QCBvdXQ6DQo+ID4gIAkJdTMyIF9yZXQ7CQkJCVwNCj4gPiAgCQlfcmV0ID0gQlBGX1BST0dfUlVO
X0FSUkFZX0NHX0ZMQUdTKGFycmF5LCBjdHgsIGZ1bmMsIDAsICZfZmxhZ3MpOyBcDQo+ID4gIAkJ
X2NuID0gX2ZsYWdzICYgQlBGX1JFVF9TRVRfQ047CQlcDQo+ID4gKwkJaWYgKF9yZXQgJiYgIUlT
X0VSUl9WQUxVRSgobG9uZylfcmV0KSkJXA0KPiA+ICsJCQlfcmV0ID0gLUVGQVVMVDsJDQo+ID4N
Cj4gPiBfcmV0IGlzIHUzMiBhbmQgcmV0IGdldHMgLTEgKGZmZmZmZmZmKS4gSVNfRVJSX1ZBTFVF
KChsb25nKWZmZmZmZmZmKSAgDQo+IHJldHVybnMNCj4gPiBmYWxzZSBpbiB0aGlzIGNhc2UgYmVj
YXVzZSBpdCBkb2Vzbid0IHNpZ24tZXhwYW5kIHRoZSBhcmd1bWVudCBhbmQgIA0KPiBpbnRlcm5h
bGx5DQo+ID4gZG9lcyBmZmZmX2ZmZmYgPj0gZmZmZl9mZmZmX2ZmZmZfZjAwMSBjb21wYXJpc29u
Lg0KPiA+DQo+ID4gSSdsbCB0cnkgdG8gc2VlIHdoYXQgSSd2ZSBjaGFuZ2VkIGluIG15IHVucmVs
YXRlZCBwYXRjaCB0byBmaXggaXQuIEJ1dCAgDQo+IEkgdGhpbmsNCj4gPiB3ZSBzaG91bGQgYXVk
aXQgYWxsIHRoZXNlIElTX0VSUl9WQUxVRSgobG9uZylfcmV0KSByZWdhcmRsZXNzOyB0aGV5ICAN
Cj4gZG9uJ3QNCj4gPiBzZWVtIHRvIHdvcmsgdGhlIHdheSB3ZSB3YW50IHRoZW0gdG8uLi4NCg0K
PiBPaywgYW5kIG15IHBhdGNoIGZpeGVzIGl0IGJlY2F1c2UgSSdtIHJlcGxhY2luZyAndTMyIF9y
ZXQnIHdpdGggJ2ludCByZXQnLg0KDQo+IFNvLCBiYXNpY2FsbHksIHdpdGggdTMyIF9yZXQgd2Ug
aGF2ZSB0byBkbyBJU19FUlJfVkFMVUUoKGxvbmcpKGludClfcmV0KS4NCg0KPiBTaWdoLi4NCg0K
QW5kIHRvIGZvbGxvdyB1cCBvbiB0aGF0LCB0aGUgb3RoZXIgdHdvIHBsYWNlcyB3ZSBoYXZlIGFy
ZSBmaW5lOg0KDQpJU19FUlJfVkFMVUUoKGxvbmcpcnVuX2N0eC5yZXR2YWwpKQ0KDQpydW5fY3R4
LnJldHZhbCBpcyBhbiBpbnQuDQo=
