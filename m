Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA2BA15A571
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 10:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728926AbgBLJ5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 04:57:01 -0500
Received: from smtp2.axis.com ([195.60.68.18]:42037 "EHLO smtp2.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728745AbgBLJ5B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Feb 2020 04:57:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; l=789; q=dns/txt; s=axis-central1;
  t=1581501421; x=1613037421;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=q14WuvPzXGRi8UR5yHYhZpOy+zA4EB3WOsMdi49JbeY=;
  b=JYq7+O0jKzDn378SMHs8I5ub9yI8K6P6LV8MfeNIGAqLXfZe5Sm8hVqT
   FGzcrmGC1d1gonPB6yEXUMAGlRUd8KfL/iGLqk/hbbnSyxngPlnRRmOeT
   htlf9hPSoNUweO6116IhIN9p79cuh7d8oX+DYWxf9USr/fwpwI/4/7vxM
   eONCJi9XsTbDgT8ZHlm77wrDZCySaB1U+fb45i6YpaeZtjuNVhG5bFJls
   tVD5e7FH9OxW1jxfA+KEZXhRL3iv0hnqhFT9M9Zq/SjXOlBMYsEnX2uZI
   cQHRaxAHECbnVmzfSL2KVraG3IYGQScyBQoJcC+Pj9SqF23lEY6+3BZq6
   w==;
IronPort-SDR: 7lXDnhOrMxhab03866KUi9pn9BeRgT0xwRz0DFSLmQhvCYbyTV4DO/Bc0us0aNSO5K78WreaTb
 oR0H4Yn+pWMLHFqBoXCQaYmRmTx7nvvnvCcSqfJy4hGYqbXBatXY4oXFCc+odM5yYu3+AH6WE4
 vXnKqrar+P5XyoXyWmV4J2lcpm25gSmWknGZ5V/PH7zZEtvGkgBSnzT5bb+ecE00nlxzNGMDFD
 /dg+aFyF65HSdcTcDqXTcrbgF+SVDgSr5lkXi8RFw3Uu2PXFpwO1zhK3EtW6OLWXVOSK8jprzz
 8IQ=
X-IronPort-AV: E=Sophos;i="5.70,428,1574118000"; 
   d="scan'208";a="5190707"
From:   =?iso-8859-1?Q?Per_F=F6rlin?= <Per.Forlin@axis.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "john@phrozen.org" <john@phrozen.org>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
Subject: [Question] net: dsa: tag_qca: QCA tag and headroom size?
Thread-Topic: [Question] net: dsa: tag_qca: QCA tag and headroom size?
Thread-Index: AQHV4YqjsBkgaUILIE2xIc9Wj2Kh/Q==
Date:   Wed, 12 Feb 2020 09:57:00 +0000
Message-ID: <1581501418212.84729@axis.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.0.5.60]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,=0A=
=0A=
---=0A=
 net/dsa/tag_qca.c | 2 +-=0A=
 1 file changed, 1 insertion(+), 1 deletion(-)=0A=
=0A=
diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c=0A=
index c8a128c9e5e0..70db7c909f74 100644=0A=
--- a/net/dsa/tag_qca.c=0A=
+++ b/net/dsa/tag_qca.c=0A=
@@ -33,7 +33,7 @@ static struct sk_buff *qca_tag_xmit(struct sk_buff *skb, =
struct net_device *dev)=0A=
 	struct dsa_port *dp =3D dsa_slave_to_port(dev);=0A=
 	u16 *phdr, hdr;=0A=
 =0A=
-	if (skb_cow_head(skb, 0) < 0)=0A=
>  Is it really safe to assume there is enough headroom for the QCA tag?=0A=
=0A=
+	if (skb_cow_head(skb, QCA_HDR_LEN) < 0)=0A=
> My proposal. Specify QCA tag size to make sure there is headroom.=0A=
=0A=
 		return NULL;=0A=
 =0A=
 	skb_push(skb, QCA_HDR_LEN);=0A=
-- =0A=
2.11.0=0A=
