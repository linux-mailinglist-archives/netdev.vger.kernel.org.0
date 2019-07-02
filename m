Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 229125D515
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 19:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbfGBRNo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 13:13:44 -0400
Received: from mout.web.de ([212.227.17.11]:38069 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbfGBRNn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 13:13:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1562087600;
        bh=HU5FXk40QRKcYQ9SzlcxZMhA3l2n86LAoxEGEzow2JU=;
        h=X-UI-Sender-Class:To:Cc:From:Subject:Date;
        b=P28yauJCosmojjyG1KH/6XoU8TcjePdWycBfT+xWm2EGG8rsXTpkZFTizB6HWs2Jw
         TzzlD5QtEl76o1MuEuuRJKegnvcOQldS8/fON5HSjxqSxDiyz3qaEyrjm2OUu1PKIh
         CqIAluWpezbjuyfsb5gnfu/ANyQDqFnfKIT5Kjg0=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([78.48.11.114]) by smtp.web.de (mrweb103
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0MVLak-1i2oEL4A1u-00Yg7Q; Tue, 02
 Jul 2019 19:13:20 +0200
To:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From:   Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] bpf: Replace a seq_printf() call by seq_puts() in
 btf_enum_seq_show()
Openpgp: preference=signencrypt
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <93898abe-9a7d-0c64-0856-094b62e07ba2@web.de>
Date:   Tue, 2 Jul 2019 19:13:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:kEtCetZXnEUrky7o2+tQM3lHhgomErDKiEk1JuN4iHyfXuzQO42
 LXc/IE97bAV6aMfBb0B9krSoq+xxeSrDhcAXY7wsEuA5Ms4kyt7s/gJAoI0qfFYAOy2TFf6
 KBJs1n+bBnYBYEf7FgL5SHTM0kzPRMVngLVap5JldOefU0ymiUnOx4ol45lORO4g7563L5r
 Kvceef9TeO5M5xXXfGi+w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:pTUlLO6a2SI=:5HuKsNrIfYApJysC+twQEI
 mMT+u7gByoSHXCBLiuGD31g3SxP9GEvoVV+JedpPxQNxR2OBDAMDe4r2YQcztX9uA8SOjo/ug
 F0HzFDEGatAG3wTMXAVx1YMUh3wl7lr34Xibrl+Nq2XaDrGOJq+TYHJBFB8qJv8JKC6mZ3O1c
 L8fWyP+bZRCnDWJlZ73KP42ISQNcZpr69LQzXuyjgTxLEb2X0Pdsm2KvgagM//ehDXoax6m19
 Zt2e4HWhatVLS627Ad6H4FIptnPJ5UTW379SCi8qP0ISoSnNEyEYDNOdUY69iJqHCK94fZXZ7
 Ks7WaJ3VDQPHX18HcGKl8ddNPHVEACz5CSmBAVJ2DwsNNnOlWrYO8rJ+Wz9H8kKlw5YbhD7iS
 r2eX0nzsV8UUdlq1uqGot/yIFvLNjtce1szXJ6DIr2lY7qUCALOcfBbLlGDjGQH8dwtkcUFsc
 whg8x34N4Mn31O3Fr96FKeiwMetMiYGfjTU1WVk6566sWnsvZc6aMqXXz/1tZZ2Um2g53r1sV
 ZCyOmzYTX32FZQwIOUbVG4gL1NH0i9SxuMOJOY2ThHxRLXU64qZBP2omS0cCjZcMXEuJOLy2+
 vfiilo3diXJI7o9zD/lKu90RwQSwnHHcQm1m5UNIt/7P9M3e+ZvohENw/cL617c23h6BnoYMp
 IZZ2+uqIYDFmYAA/7G/PEX/k6RVKhl2gNgF3Wk0lBz6bmSz0dPmspFZ6fzpLIP3pkFKolZ1qX
 jVCyg9eX58+xofT3qDp4ec3S5u9z1yq66kmBBjX98XNTtr61tHXP12yLevvfdZYcP9XtNnKZh
 eCom3KniMqU6dQSwpDORkrbf/JXfNJGVqy6wJi0SNz1O1wHGVsZz97YDhRDYPqq1HagvDGEDy
 NcswN+wbc9pUqJT5/Aw6d4H6497A9dK+0rRBoymVaROdM/sIAWdM9rcEnHH/eTvXVAInKrxdu
 WjW3epkSWUzZNK3Sl3q6Oy3FogFPd1aK6ac5YH6vALJBu1XIsNi0AHY5zbhRWMwFJvBWlkdPm
 QmRjJRKv8mVMK4Ee2dGt2nOY0jYbD79iwqSd7QCxrOgAhWYjlTyk39n3YbfgAzYRjbzmSOhL3
 XgFk8N6heABLLmLow1sNKdVAgZLGkard2Vu
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 2 Jul 2019 19:04:08 +0200

A string which did not contain a data format specification should be put
into a sequence. Thus use the corresponding function =E2=80=9Cseq_puts=E2=
=80=9D.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 kernel/bpf/btf.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 546ebee39e2a..679a19968f29 100644
=2D-- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -2426,9 +2426,8 @@ static void btf_enum_seq_show(const struct btf *btf,=
 const struct btf_type *t,

 	for (i =3D 0; i < nr_enums; i++) {
 		if (v =3D=3D enums[i].val) {
-			seq_printf(m, "%s",
-				   __btf_name_by_offset(btf,
-							enums[i].name_off));
+			seq_puts(m,
+				 __btf_name_by_offset(btf, enums[i].name_off));
 			return;
 		}
 	}
=2D-
2.22.0

