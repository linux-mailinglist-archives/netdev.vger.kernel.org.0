Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3795963CB9E
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 00:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236198AbiK2XNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 18:13:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233312AbiK2XNK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 18:13:10 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E45766D4BD;
        Tue, 29 Nov 2022 15:13:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669763587; x=1701299587;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=7tNHhFkjh3n5oBrKwNlDxAK0pyjU5usTlgw2G6E3UrM=;
  b=Bx4GOSZ+3IyZcp4EUVcXNL+M2A5zUfZ2rhBWJJmf1MAE+8E7uAVto9H4
   Nla2ExzgLmZnuIzs2WQpr+qt5XfOAt0nUz2CvXGo504tb4lvPbTvCxgtn
   P4AWq+zAC5zP6F2mw0Wo3Emqfoqa+UTUid5cIpSXPVj34cJx38EAfgsvF
   FMAT+fsnyTgQq2lW1vX+xU1Qucj4Eps9OmsD0XKIjLKnH/HOJkIxQ5/uk
   7y9zsQRGbT9pfx3hZ6/nHT+O+WOYLNluBEhCyftQUnCxUiKA9Wa+Hy6KY
   AkGLRE8kJ0WYbfA+W6toe8m1fb7mNQtptK/S5b7oWoFfpChOY5OMddU13
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,204,1665471600"; 
   d="scan'208";a="125706831"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Nov 2022 16:13:06 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 29 Nov 2022 16:13:02 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 29 Nov 2022 16:13:00 -0700
Message-ID: <8c3b48a2c1ae51e97b7701b122dfea1d095faf44.camel@microchip.com>
Subject: Re: [PATCH net-next] net: microchip: sparx5: Fix error handling in
 vcap_show_admin()
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Dan Carpenter <error27@gmail.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
CC:     Daniel Machon <daniel.machon@microchip.com>,
        <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Date:   Wed, 30 Nov 2022 00:13:00 +0100
In-Reply-To: <Y4XUUx9kzurBN+BV@kili>
References: <Y4XUUx9kzurBN+BV@kili>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.1 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dan,

Thanks for the change.  It looks good to me.

On Tue, 2022-11-29 at 12:43 +0300, Dan Carpenter wrote:
> [Some people who received this message don't often get email from
> error27@gmail.com. Learn why this is important at
> https://aka.ms/LearnAboutSenderIdentification=C2=A0]
>=20
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e
> content is safe
>=20
> If vcap_dup_rule() fails that leads to an error pointer dereference
> side the ca

Reviewed-by: Steen Hegelund <Steen.Hegelund@microchip.com>

BR
Steen
