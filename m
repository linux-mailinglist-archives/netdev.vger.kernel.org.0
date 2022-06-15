Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D65C354D27E
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 22:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243356AbiFOU0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 16:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235568AbiFOU0N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 16:26:13 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 007915252A
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 13:26:11 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-3175d2c4beaso15112687b3.10
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 13:26:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc:content-transfer-encoding;
        bh=c4vJ9F4RUqydpkYcTxY+nie+eEJvDNr5fBTNv3Yvpn8=;
        b=OLGnCavk8OlJCcND4aEW4fUS6FExhYPMNVZrY8ehyi9VvK8mpglblNs9RXsKt6tmLh
         776q67KMmP3G9ox7aggWGf6ciPEcMG5gaDg9bnfb6v8qMTS3m7WFuquQFH5p4ekluobg
         sSFV1D86dU/s5Z+gtEIajyWkcBSBV6HR0jpXRgkaKopwFHAGcRDx6r8kj6VIYq0qobPL
         wiD4Dla7rIpBEx3RWQxfIZ1L+HeNqAcSVmLXa0GzYqjTox2Rjl5qnKx/lOGzdYaVE+fW
         ba+BWsDKKViwwp8wJhHwH+qszOagnZsbmHHKzZqKD9O+WfujBMPkNMvNiRgcYCncxQLT
         ciog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc:content-transfer-encoding;
        bh=c4vJ9F4RUqydpkYcTxY+nie+eEJvDNr5fBTNv3Yvpn8=;
        b=N+c2wRLz/myGARAYGMuIYgi7pSjrR0ZbjPnE7W+3o9a84+zkzt9E/reHlyCQMdTbAQ
         Sbi/IlI7xBlTGrfvQXCwrX3kZr/YLyOLQzoEse/CKwpcnBOQ7SeM1qIJuyiM7+OEpJXD
         XTH9J8xHxjSuwbgNJVMkDBHQ2NSMboMtCMuwVAhsKzGymAFtpiidt4G6vOFDQGUq1c6v
         +kFdXHTuWemCsWGJHHt+qrtS+oIFxqml/i0OX0umHGsXFX2ChRFD0DqOSaCxDs8sOCGn
         xz6k8NBAJ/JgSC3o98nXEdOeTHaa99V0s0s0J5LV8OuIFmxybvH1AE5o7CrPVlrOBYmE
         ANtg==
X-Gm-Message-State: AJIora99ZW1qaC4dUggUynYncEm6ICrb3TTP0aNFbOROaqPz2yg+fUEZ
        Bp/Ah0sRm2Md7CV+POPajkXgTcg=
X-Google-Smtp-Source: AGRyM1vnrMJ/JOoQG74ngLx7eZ6zEHpQeI55cUvJDyFTfl6agbpspFVR0Lv7plmUY5tcGBPFLhLslf4=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a81:b8c:0:b0:30c:a798:3786 with SMTP id
 134-20020a810b8c000000b0030ca7983786mr1645989ywl.69.1655324771131; Wed, 15
 Jun 2022 13:26:11 -0700 (PDT)
Date:   Wed, 15 Jun 2022 13:26:09 -0700
In-Reply-To: <YqodE5lxUCt6ojIw@google.com>
Message-Id: <YqpAYcvM9DakTjWL@google.com>
Mime-Version: 1.0
References: <CAHo-Ooy+8O16k0oyMGHaAcmLm_Pfo=Ju4moTc95kRp2Z6itBcg@mail.gmail.com>
 <CANP3RGed9Vbu=8HfLyNs9zwA=biqgyew=+2tVxC6BAx2ktzNxA@mail.gmail.com>
 <CAADnVQKBqjowbGsSuc2g8yP9MBANhsroB+dhJep93cnx_EmNow@mail.gmail.com>
 <CANP3RGcZ4NULOwe+nwxfxsDPSXAUo50hWyN9Sb5b_d=kfDg=qg@mail.gmail.com> <YqodE5lxUCt6ojIw@google.com>
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDYvMTUsIHNkZkBnb29nbGUuY29tIHdyb3RlOg0KPiBPbiAwNi8xNSwgTWFjaWVqIMW7ZW5j
enlrb3dza2kgd3JvdGU6DQo+ID4gT24gV2VkLCBKdW4gMTUsIDIwMjIgYXQgMTA6MzggQU0gQWxl
eGVpIFN0YXJvdm9pdG92DQo+ID4gPGFsZXhlaS5zdGFyb3ZvaXRvdkBnbWFpbC5jb20+IHdyb3Rl
Og0KPiA+ID4NCj4gPiA+IE9uIFdlZCwgSnVuIDE1LCAyMDIyIGF0IDk6NTcgQU0gTWFjaWVqIMW7
ZW5jenlrb3dza2kgPG1hemVAZ29vZ2xlLmNvbT4NCj4gPiB3cm90ZToNCj4gPiA+ID4gPg0KPiA+
ID4gPiA+IEkndmUgY29uZmlybWVkIHZhbmlsbGEgNS4xOC4wIGlzIGJyb2tlbiwgYW5kIGFsbCBp
dCB0YWtlcyBpcw0KPiA+ID4gPiA+IGNoZXJyeXBpY2tpbmcgdGhhdCBzcGVjaWZpYyBzdGFibGUg
NS4xOC54IHBhdGNoIFsNCj4gPiA+ID4gPiA3MTBhODk4OWI0YjQwNjc5MDNmNWI2MTMxNGVkYTQ5
MTY2N2I2YWIzIF0gdG8gZml4IGJlaGF2aW91ci4NCj4gPiA+IC4uLg0KPiA+ID4gPiBiOGJkM2Vl
MTk3MWQxZWRiYzUzY2YzMjJjMTQ5Y2EwMjI3NDcyZTU2IHRoaXMgaXMgd2hlcmUgd2UgYWRkZWQN
Cj4gPiBFRkFVTFQgaW4gNS4xNg0KPiA+ID4NCj4gPiA+IFRoZXJlIGFyZSBubyBzdWNoIHNoYS1z
IGluIHRoZSB1cHN0cmVhbSBrZXJuZWwuDQo+ID4gPiBTb3JyeSB3ZSBjYW5ub3QgaGVscCB3aXRo
IGRlYnVnZ2luZyBvZiBhbmRyb2lkIGtlcm5lbHMuDQoNCj4gPiBZZXMsIHNkZkAgcXVvdGVkIHRo
ZSB3cm9uZyBzaGExLCBpdCdzIGEgY2xlYW4gY2hlcnJ5cGljayB0byBhbg0KPiA+IGludGVybmFs
IGJyYW5jaCBvZg0KPiA+ICdicGY6IEFkZCBjZ3JvdXAgaGVscGVycyBicGZfe2dldCxzZXR9X3Jl
dHZhbCB0byBnZXQvc2V0IHN5c2NhbGwgcmV0dXJuDQo+ID4gdmFsdWUnDQo+ID4gY29tbWl0IGI0
NDEyM2I0YTNkY2FkNDY2NGQzYTBmNzJjMDExZmZkNGM5YzRkOTMuDQoNCj4gPiAgDQo+IGh0dHBz
Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3N0YWJsZS9saW51eC5n
aXQvY29tbWl0Lz9oPWxpbnV4LTUuMTYueSZpZD1iNDQxMjNiNGEzZGNhZDQ2NjRkM2EwZjcyYzAx
MWZmZDRjOWM0ZDkzDQoNCj4gPiBBbnl3YXksIEkgdGhpbmsgaXQncyB1bnJlbGF0ZWQgLSBvciBh
dCBsZWFzdCBub3QgdGhlIGltbWVkaWF0ZSByb290ICANCj4gY2F1c2UuDQoNCj4gPiBBbHNvIHRo
ZXJlJ3MgKm5vKiBBbmRyb2lkIGtlcm5lbHMgaW52b2x2ZWQgaGVyZS4NCj4gPiBUaGlzIGlzIHRo
ZSBhbmRyb2lkIG5ldCB0ZXN0cyBmYWlsaW5nIG9uIHZhbmlsbGEgNS4xOCBhbmQgcGFzc2luZyBv
bg0KPiA+IDUuMTguMy4NCg0KPiBZZWFoLCBzb3JyeSwgZGlkbid0IG1lYW4gdG8gc2VuZCB0aG9z
ZSBvdXRzaWRlIDotKQ0KDQo+IEF0dGFjaGVkIHVuLWFuZHJvaWQtaWZpZWQgdGVzdGNhc2UuIFBh
c3NlcyBvbiBicGYtbmV4dCwgdHJ5aW5nIHRvIHNlZQ0KPiB3aGF0IGhhcHBlbnMgb24gdmFuaWxs
YSA1LjE4LiBXaWxsIHVwZGF0ZSBvbmNlIEkgZ2V0IG1vcmUgZGF0YS4uDQoNCkkndmUgYmlzZWN0
ZWQgdGhlIG9yaWdpbmFsIGlzc3VlIHRvOg0KDQpiNDQxMjNiNGEzZGMgKCJicGY6IEFkZCBjZ3Jv
dXAgaGVscGVycyBicGZfe2dldCxzZXR9X3JldHZhbCB0byBnZXQvc2V0DQpzeXNjYWxsIHJldHVy
biB2YWx1ZSIpDQoNCkFuZCBJIGJlbGlldmUgaXQncyB0aGVzZSB0d28gbGluZXMgZnJvbSB0aGUg
b3JpZ2luYWwgcGF0Y2g6DQoNCiAgI2RlZmluZSBCUEZfUFJPR19DR1JPVVBfSU5FVF9FR1JFU1Nf
UlVOX0FSUkFZKGFycmF5LCBjdHgsIGZ1bmMpCQlcDQogIAkoewkJCQkJCVwNCkBAIC0xMzk4LDEw
ICsxMzk4LDEyIEBAIG91dDoNCiAgCQl1MzIgX3JldDsJCQkJXA0KICAJCV9yZXQgPSBCUEZfUFJP
R19SVU5fQVJSQVlfQ0dfRkxBR1MoYXJyYXksIGN0eCwgZnVuYywgMCwgJl9mbGFncyk7IFwNCiAg
CQlfY24gPSBfZmxhZ3MgJiBCUEZfUkVUX1NFVF9DTjsJCVwNCisJCWlmIChfcmV0ICYmICFJU19F
UlJfVkFMVUUoKGxvbmcpX3JldCkpCVwNCisJCQlfcmV0ID0gLUVGQVVMVDsJDQoNCl9yZXQgaXMg
dTMyIGFuZCByZXQgZ2V0cyAtMSAoZmZmZmZmZmYpLiBJU19FUlJfVkFMVUUoKGxvbmcpZmZmZmZm
ZmYpIHJldHVybnMNCmZhbHNlIGluIHRoaXMgY2FzZSBiZWNhdXNlIGl0IGRvZXNuJ3Qgc2lnbi1l
eHBhbmQgdGhlIGFyZ3VtZW50IGFuZCAgDQppbnRlcm5hbGx5DQpkb2VzIGZmZmZfZmZmZiA+PSBm
ZmZmX2ZmZmZfZmZmZl9mMDAxIGNvbXBhcmlzb24uDQoNCkknbGwgdHJ5IHRvIHNlZSB3aGF0IEkn
dmUgY2hhbmdlZCBpbiBteSB1bnJlbGF0ZWQgcGF0Y2ggdG8gZml4IGl0LiBCdXQgSSAgDQp0aGlu
aw0Kd2Ugc2hvdWxkIGF1ZGl0IGFsbCB0aGVzZSBJU19FUlJfVkFMVUUoKGxvbmcpX3JldCkgcmVn
YXJkbGVzczsgdGhleSBkb24ndA0Kc2VlbSB0byB3b3JrIHRoZSB3YXkgd2Ugd2FudCB0aGVtIHRv
Li4uDQo=
