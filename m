Return-Path: <netdev+bounces-5934-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 00904713671
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 22:46:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E265028151C
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 20:46:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05CC917AA5;
	Sat, 27 May 2023 20:46:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2A114A91
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 20:46:42 +0000 (UTC)
Received: from mout.web.de (mout.web.de [212.227.15.4])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39135AC;
	Sat, 27 May 2023 13:46:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de; s=s29768273;
	t=1685220387; i=spasswolf@web.de;
	bh=XWibsJx1YJWrvyn917MRnpNsKgmfIeD/gR4idkU5SBI=;
	h=X-UI-Sender-Class:Subject:From:To:Cc:Date;
	b=QswUvaKcvlfm8HGmtJPrBVzDQmp2v0iYjBfPW/Y9kBWkq/vFhpa9/upIPLSJDLUvA
	 5N7rwU7ESo56vKdRZ67VcQxpFe067B3SbhfdpZtev+m3YtCNLu210QU+XRdEu9vQ78
	 gukPOihNK7e/SOvfQJoVJoQKwuZNU63YTv9+v3Tzy7VbRoJz/a2P/0OIjeLGQWbDhz
	 5+S5B4Uv0bFwMym7EojaCIU1B5HAma52yHiZ0sfkDI6Eu9JdlTc7WSAD8Wz0PV+vWC
	 3Pq7YE7YJe0NMOI6w7CDR7ASSJANUEJirLM4xjIc/ONTFOTnp+fTNntcVkHCNyr4bM
	 TPTpzUaXcKUPw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.0.101] ([176.198.191.160]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MPaMQ-1pgPkf35M2-00MvdR; Sat, 27
 May 2023 22:46:27 +0200
Message-ID: <7ae8af63b1254ab51d45c870e7942f0e3dc15b1e.camel@web.de>
Subject: [PATCH net] net: ipa: Use the correct value for IPA_STATUS_SIZE
From: Bert Karwatzki <spasswolf@web.de>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>,  Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
 <pabeni@redhat.com>
Cc: elder@linaro.org, netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
  linux-kernel@vger.kernel.org
Date: Sat, 27 May 2023 22:46:25 +0200
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-2 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Provags-ID: V03:K1:WzzljHKLMxZlZFbFaFNZREr/ziuHQOR5eZa5NtwND9WrUbHkFOF
 IBabxYZQ8cTHy+MmtFd3yULB2u+oIUAbrTEi6ERKrjR7SXmcM+HjB5wOymWtK56YWb3IujF
 i0yUaPs2BF6KhGHmTRIjfXJTgUxo2O1VS2MXUNX8hsY7vhedGhh8uc+i2ZvzCz1ODPBviTU
 8sFsb4rfHv+rzpvLex4GA==
UI-OutboundReport: notjunk:1;M01:P0:/isRWyVWTdQ=;wxuixlXgl9SeBwxuBGzOqJQZdwJ
 xjOKQTucDMeRZo5aiTobbISTPq/SC7IwUl3fuOY+DjLSJAcgIWFwzuh5zKoUm3y0pXPK7fjOG
 RHqJJiwX1oed5EqEVurKHA7HBsi6r2RgGyqU+njkIKyg0QQADjjkuXPrKw4ByDhRrxRr01AgX
 +x/Gck+LgHK7t8PN6kAtjZepTFOWU+0+i4udSBmTEekx/3kLtJg8nuuXvPEwL606Kv+TN8Y4s
 T/jKINECUwo8VJGbgAutlUmKnZ2WehnXe5h4dYu6dtMB9YHrinHSOYXlGFgY8+IUWTJ5Gq1wm
 zltaBKsxy4T9OYWQ/DdhYH1Ui9OvxijXBaFbKrhew/jKtCHaHSfGIEOkMHPxYGiS0QvOyNMfP
 1NOeBXjdUIsHivPRAAoYfqTmZS/cUhuc4DYrQFYOt7Ixb/iR/Sq645mmgdSzAqx4J32++uliK
 6YG9YdHqFIW0bd5uxfOhr5Auie1Oy49aHJsbXjuBI9KrkpCBLg5rT0xR/p7Nm+3/Einl9cLGE
 Cc/rW/J0qCDEMfcBIDVsdjdsXV73/RAD1WgTnPjR2elVPEFHQZ9OvTaAEEcfr8xHkuy3M0GR3
 lxJVMidslNH07h9u3czi9ZMbZHl/n2lyxhDqqOBIz5tNjPxv51C+ahqwIRtucJxLQTsrpE3E9
 s86InQJ67Vg8NwS3aitT+oJEv9IAl3L0smmE6FXyP2u/5Ocq9nzjmGDAoYo1FCd7A970ERdOv
 x4bXD4wljKACDyrSSzTlni1cfKrjWG0BwJl2ORHRrlJ/zIynPCKLyd+0smZpo2qSyfiDgs+k9
 5uN/0JsZzF/iR9T32x6XJmoY7u2dMH6zVaCE0s0GFdQ8Wbbp5bewyi9Pj7pk82sYY+1enFCPB
 bPtHyP5Mf5W55ESKsf5Emee6aS37pQEU8IYmWcxTzkEcaAv4Gv9XILAifcu0KN2XMAxolcMzw
 ABzhwREg+roGOp5fOnJTBTtlLp8=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

commit b8dc7d0eea5a7709bb534f1b3ca70d2d7de0b42c introduced
IPA_STATUS_SIZE as a replacement for the size of the removed struct
ipa_status. sizeof(struct ipa_status) was sizeof(__le32[8]), use this
as IPA_STATUS_SIZE.

From 0623148733819bb5d3648b1ed404d57c8b6b31d8 Mon Sep 17 00:00:00 2001
From: Bert Karwatzki <spasswolf@web.de>
Date: Sat, 27 May 2023 22:16:52 +0200
Subject: [PATCH] Use the correct value for IPA_STATUS_SIZE.
IPA_STATUS_SIZE
 was introduced in commit b8dc7d0eea5a7709bb534f1b3ca70d2d7de0b42c as a
 replacment for the size of the removed struct ipa_status which had
size =3D
 sizeof(__le32[8]).

Signed-off-by: Bert Karwatzki <spasswolf@web.de>
---
 drivers/net/ipa/ipa_endpoint.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c
b/drivers/net/ipa/ipa_endpoint.c
index 2ee80ed140b7..afa1d56d9095 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -119,7 +119,7 @@ enum ipa_status_field_id {
 };
=20
 /* Size in bytes of an IPA packet status structure */
-#define IPA_STATUS_SIZE			sizeof(__le32[4])
+#define IPA_STATUS_SIZE			sizeof(__le32[8])
=20
 /* IPA status structure decoder; looks up field values for a structure
*/
 static u32 ipa_status_extract(struct ipa *ipa, const void *data,
--=20
2.40.1

Bert Karwatzki


