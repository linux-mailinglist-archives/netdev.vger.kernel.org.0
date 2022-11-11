Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2933A625922
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 12:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbiKKLON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 06:14:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbiKKLOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 06:14:12 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED7C67116
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 03:14:11 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id v17so4021128plo.1
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 03:14:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=VmJDvO1lfEtA7+PtzvhWficvtWZQoX/Dri3rKNGcY7s=;
        b=l67nM6JIsAq8NrsH4/5VlwedJYeT1mUwcK/WdBePb5V7Hu2SqR0YaXw20or/reouGB
         ncu8Z2oGtVCFgrDV5VBD2PcJA+RS6hUCoWgPdpVkny00Jw3Tc0yHznTLM4e0VFPDWq5r
         /HUHSfVPX8R9PBSN2lPOKR5a+SXdcRDUOJGZpDhINcd4W5TkQDalHc1tVgSYi/3LYqDn
         FNRL+YDZwwv7pZjouP2ytPAytpqamoB4RuEZIcXX/uMUaLWs0JXmQwmcV6rnoY+uj7GB
         wu59h5m5tFmQefjSV6LFEPKQCW2hXrJeCWSTQmabM4Fgq21EnR7LTojr+B+Sc8w+OahU
         6M+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VmJDvO1lfEtA7+PtzvhWficvtWZQoX/Dri3rKNGcY7s=;
        b=Hb/dVQXZJugFV4te32jCdC+MGcLeaj/rYdGF37A+qw7elR16yyQaGGIHBYpNRPYMLN
         dBYnnb2ryGjfhdzTF99KXTwr799NznKp3WlMc+sYSdq3xJl7+/ILOZSKzf/9X6BrSJ3D
         yMii4E8+JzXrJMZ3RrwQXgpu5yJWsWcqRr64+9xtIo7wx2wH5BbpGwmhNcuNZADTiL2/
         ZAGN4BJVHtIQ6TUK/rjZjFnUYLfVIIT+4uLnoNWJzglzwNalLOF74a0I5uPqYRvFerVL
         s7LKWF34WCiHdAzuyQS9sYR8EojEPWChbSDmfstH3WuuxBEXk+Kmodl0zbcMLw5vfP3V
         hwaw==
X-Gm-Message-State: ANoB5pl18Q854orzhdp+NZJIzfaAzVHTFsslXlgQIYureEoJEDV8AOi1
        0/eXAXi8uxgj4DeWzVUQ7/EASBsJ+5nakVy3anM=
X-Google-Smtp-Source: AA0mqf6qrwgFRM5aRQvvCRj2ghzsgC1xNNq/+lK9DTFcHozH2w09x6WGZeIRZ0cM7AmZQgsCzyiOVrY6hbnRlt5w3go=
X-Received: by 2002:a17:902:aa88:b0:188:75bb:36d4 with SMTP id
 d8-20020a170902aa8800b0018875bb36d4mr1850582plr.55.1668165250842; Fri, 11 Nov
 2022 03:14:10 -0800 (PST)
MIME-Version: 1.0
References: <20221110124345.3901389-1-festevam@gmail.com> <20221110125322.c436jqyplxuzdvcl@skbuf>
In-Reply-To: <20221110125322.c436jqyplxuzdvcl@skbuf>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Fri, 11 Nov 2022 08:13:56 -0300
Message-ID: <CAOMZO5D9shR2WB+83UPOvs-CaRg7rmaZ-USokPu0K+jtvB2EYw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Allow hwstamping on the
 master port
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, andrew@lunn.ch, netdev@vger.kernel.org,
        =?UTF-8?Q?Steffen_B=C3=A4tz?= <steffen@innosonix.de>,
        Fabio Estevam <festevam@denx.de>
Content-Type: multipart/mixed; boundary="00000000000034d92605ed2ffdf5"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000034d92605ed2ffdf5
Content-Type: text/plain; charset="UTF-8"

Hi Vladimir,

On Thu, Nov 10, 2022 at 9:53 AM Vladimir Oltean <olteanv@gmail.com> wrote:

> NACK.
>
> Please extend dsa_master_ioctl() to "see through" the dp->ds->ops->port_hwtstamp_get()
> pointer, similar to what dsa_port_can_configure_learning() does. Create
> a fake struct ifreq, call port_hwtstamp_get(), see if it returned
> -EOPNOTSUPP, and wrap that into a dsa_port_supports_hwtstamp() function,
> and call that instead of the current simplistic checks for the function
> pointers.

I tried to implement what you suggested in the attached patch, but I
am not sure it is correct.

If it doesn't work, please cook a patch so we can try it.

I am not familiar with the DSA code, sorry.

Thanks

--00000000000034d92605ed2ffdf5
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-net-dsa-Introduce-dsa_port_supports_hwtstamp.patch"
Content-Disposition: attachment; 
	filename="0001-net-dsa-Introduce-dsa_port_supports_hwtstamp.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lacehqd40>
X-Attachment-Id: f_lacehqd40

RnJvbSA2ZjQ1OTY4ZGQyZTQ1ODU4MThlYTZhY2Y4NDIwYmZlZDM4MjQ2NjA0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBGYWJpbyBFc3RldmFtIDxmZXN0ZXZhbUBkZW54LmRlPgpEYXRl
OiBUaHUsIDEwIE5vdiAyMDIyIDE4OjUwOjU5IC0wMzAwClN1YmplY3Q6IFtQQVRDSCBuZXQtbmV4
dF0gbmV0OiBkc2E6IEludHJvZHVjZSBkc2FfcG9ydF9zdXBwb3J0c19od3RzdGFtcCgpCgpDdXJy
ZW50bHksIGR1cmluZyBTSU9DR0hXVFNUQU1QL1NJT0NTSFdUU1RBTVAgaW9jdGwgb3BlcmF0aW9u
cywgdGhlCmNyaXRlcmlhIGZvciBkZWNpZGluZyB3aGV0aGVyIFBUUCBvcGVyYXRpb25zIG9uIHRo
ZSBtYXN0ZXIgcG9ydCBpcyBhbGxvd2VkCm9yIG5vdCBpcyBzaW1wbHkgYmFzZWQgb24gdGhlIHBy
ZXNlbmNlIG9mIHRoZSBwb3J0X2h3dHN0YW1wX2dldC9zZXQoKQpvcGVyYXRpb25zLgoKVGhpcyBp
cyBub3QgYSByb2J1c3QgbWV0aG9kIGJlY2F1c2Ugb24gdGhlIG12ODhlNnh4eCBkcml2ZXIsIGZv
ciBleGFtcGxlLAp0aGUgcG9ydF9od3RzdGFtcF9nZXQoKS9zZXQoKSBob29rcyBhcmUgYWx3YXlz
IGltcGxlbWVudGVkLgoKRXZlbiB3aGVuIENPTkZJR19ORVRfRFNBX01WODhFNlhYWF9QVFAgaXMg
ZGlzYWJsZWQgdGhlcmUgYXJlIHN0aWxsIHN0dWIKaW1wbGVtZW50YXRpb25zIGZvciB0aGVzZSBm
dW5jdGlvbnMgdGhhdCByZXR1cm4gLUVPUE5PVFNVUFAuCgpJbnN0ZWFkIG9mIHJlbHlpbmcgb24g
dGhlIHByZXNlbmNlIG9mIHBvcnRfaHd0c3RhbXBfZ2V0L3NldCgpLCBpbnRyb2R1Y2UKdGhlIGRz
YV9wb3J0X3N1cHBvcnRzX2h3dHN0YW1wKCkgZnVuY3Rpb24sIHdoaWNoIGNoZWNrcyB0aGUgcmV0
dXJuCnZhbHVlIG9mIHBvcnRfaHd0c3RhbXBfZ2V0L3NldCgpIHRvIGRlY2lkZS4KCldpdGhvdXQg
dGhpcyBjaGFuZ2U6CgogIyBod3N0YW1wX2N0bCAtaSBldGgwClNJT0NHSFdUU1RBTVAgZmFpbGVk
OiBEZXZpY2Ugb3IgcmVzb3VyY2UgYnVzeQoKV2l0aCB0aGlzIGNoYW5nZSBhcHBsaWVkLCBpdCBp
cyBwb3NzaWJsZSB0byBzZXQgYW5kIGdldCB0aGUgdGltZXN0YW1waW5nCm9wdGlvbnM6CgogIyBo
d3N0YW1wX2N0bCAtaSBldGgwCmN1cnJlbnQgc2V0dGluZ3M6CnR4X3R5cGUgMApyeF9maWx0ZXIg
MAoKICMgaHdzdGFtcF9jdGwgLWkgZXRoMCAtciAxIC10IDEKY3VycmVudCBzZXR0aW5nczoKdHhf
dHlwZSAwCnJ4X2ZpbHRlciAwCm5ldyBzZXR0aW5nczoKdHhfdHlwZSAxCnJ4X2ZpbHRlciAxCgpU
ZXN0ZWQgb24gYSBjdXN0b20gaS5NWDhNTiBib2FyZCB3aXRoIGEgODhFNjMyMCBzd2l0Y2guCgpT
aWduZWQtb2ZmLWJ5OiBGYWJpbyBFc3RldmFtIDxmZXN0ZXZhbUBkZW54LmRlPgotLS0KIG5ldC9k
c2EvbWFzdGVyLmMgfCA0MCArKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0t
CiAxIGZpbGUgY2hhbmdlZCwgMjggaW5zZXJ0aW9ucygrKSwgMTIgZGVsZXRpb25zKC0pCgpkaWZm
IC0tZ2l0IGEvbmV0L2RzYS9tYXN0ZXIuYyBiL25ldC9kc2EvbWFzdGVyLmMKaW5kZXggMjg1MWU0
NGM0Y2YwLi5mMDc4ZGI0NGE4YjMgMTAwNjQ0Ci0tLSBhL25ldC9kc2EvbWFzdGVyLmMKKysrIGIv
bmV0L2RzYS9tYXN0ZXIuYwpAQCAtMTg3LDI5ICsxODcsNDUgQEAgc3RhdGljIHZvaWQgZHNhX21h
c3Rlcl9nZXRfc3RyaW5ncyhzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LCB1aW50MzJfdCBzdHJpbmdz
ZXQsCiAJfQogfQogCi1zdGF0aWMgaW50IGRzYV9tYXN0ZXJfaW9jdGwoc3RydWN0IG5ldF9kZXZp
Y2UgKmRldiwgc3RydWN0IGlmcmVxICppZnIsIGludCBjbWQpCitzdGF0aWMgYm9vbCBkc2FfcG9y
dF9zdXBwb3J0c19od3RzdGFtcChzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LCBzdHJ1Y3QgaWZyZXEg
KmlmciwgaW50IGNtZCkKIHsKIAlzdHJ1Y3QgZHNhX3BvcnQgKmNwdV9kcCA9IGRldi0+ZHNhX3B0
cjsKIAlzdHJ1Y3QgZHNhX3N3aXRjaCAqZHMgPSBjcHVfZHAtPmRzOwotCXN0cnVjdCBkc2Ffc3dp
dGNoX3RyZWUgKmRzdDsKKwlpbnQgcG9ydCA9IGNwdV9kcC0+aW5kZXg7CiAJaW50IGVyciA9IC1F
T1BOT1RTVVBQOwotCXN0cnVjdCBkc2FfcG9ydCAqZHA7Ci0KLQlkc3QgPSBkcy0+ZHN0OwogCiAJ
c3dpdGNoIChjbWQpIHsKIAljYXNlIFNJT0NHSFdUU1RBTVA6CisJCWlmIChkcy0+b3BzLT5wb3J0
X2h3dHN0YW1wX2dldCkgeworCQkJZXJyID0gZHMtPm9wcy0+cG9ydF9od3RzdGFtcF9nZXQoZHMs
IHBvcnQsIGlmcik7CisJCQlpZiAoZXJyID09IC1FT1BOT1RTVVBQKQorCQkJCXJldHVybiBmYWxz
ZTsKKwkJfQorCQlicmVhazsKIAljYXNlIFNJT0NTSFdUU1RBTVA6Ci0JCS8qIERlbnkgUFRQIG9w
ZXJhdGlvbnMgb24gbWFzdGVyIGlmIHRoZXJlIGlzIGF0IGxlYXN0IG9uZQotCQkgKiBzd2l0Y2gg
aW4gdGhlIHRyZWUgdGhhdCBpcyBQVFAgY2FwYWJsZS4KLQkJICovCi0JCWxpc3RfZm9yX2VhY2hf
ZW50cnkoZHAsICZkc3QtPnBvcnRzLCBsaXN0KQotCQkJaWYgKGRwLT5kcy0+b3BzLT5wb3J0X2h3
dHN0YW1wX2dldCB8fAotCQkJICAgIGRwLT5kcy0+b3BzLT5wb3J0X2h3dHN0YW1wX3NldCkKLQkJ
CQlyZXR1cm4gLUVCVVNZOworCQlpZiAoZHMtPm9wcy0+cG9ydF9od3RzdGFtcF9zZXQpIHsKKwkJ
CWVyciA9IGRzLT5vcHMtPnBvcnRfaHd0c3RhbXBfc2V0KGRzLCBwb3J0LCBpZnIpOworCQkJaWYg
KGVyciA9PSAtRU9QTk9UU1VQUCkKKwkJCQlyZXR1cm4gZmFsc2U7CisJCX0KIAkJYnJlYWs7CiAJ
fQogCisJcmV0dXJuICEhZXJyOworfQorCitzdGF0aWMgaW50IGRzYV9tYXN0ZXJfaW9jdGwoc3Ry
dWN0IG5ldF9kZXZpY2UgKmRldiwgc3RydWN0IGlmcmVxICppZnIsIGludCBjbWQpCit7CisJc3Ry
dWN0IGRzYV9wb3J0ICpjcHVfZHAgPSBkZXYtPmRzYV9wdHI7CisJc3RydWN0IGRzYV9zd2l0Y2gg
KmRzID0gY3B1X2RwLT5kczsKKwlzdHJ1Y3QgZHNhX3N3aXRjaF90cmVlICpkc3Q7CisJaW50IGVy
ciA9IC1FT1BOT1RTVVBQOworCisJZHN0ID0gZHMtPmRzdDsKKworCWlmIChkc2FfcG9ydF9zdXBw
b3J0c19od3RzdGFtcChkZXYsIGlmciwgY21kKSkKKwkJcmV0dXJuIC1FQlVTWTsKKwogCWlmIChk
ZXYtPm5ldGRldl9vcHMtPm5kb19ldGhfaW9jdGwpCiAJCWVyciA9IGRldi0+bmV0ZGV2X29wcy0+
bmRvX2V0aF9pb2N0bChkZXYsIGlmciwgY21kKTsKIAotLSAKMi4yNS4xCgo=
--00000000000034d92605ed2ffdf5--
