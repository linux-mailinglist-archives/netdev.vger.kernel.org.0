Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51DE865EA97
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 13:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233090AbjAEMVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 07:21:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233087AbjAEMU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 07:20:58 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E10F3B50;
        Thu,  5 Jan 2023 04:20:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1672921254; x=1704457254;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=RQ0vLIR5pT7xk4w5z244JQYpAMLL7GKJR/rZtUZ1qZQ=;
  b=sDi/D4AjOb+tP1AGfnNRMVNKi+4iPfjB8fMPJG4+v73InztU+IV4tTvL
   cSgbwj2i/QH/PsLJZk08zAyWn1f+gCkZtr4OfBYbpQWgiJpOjYxs9Qw6s
   5NDr80q6QhwG4l6FnF34uOd6Vb+mGvynMuBSY0IX1OiHF0EyUUq0EyFF8
   o0zgOuv3KQJsyPNMO3+B08kn/Q0oAE819u49UQRvhyy0frt9HrDicgzeM
   UHu7k5Nnp5tivNHbE4EHKP53wJWhDKJEfJBpEtxW3rBUCh1QGJxALUM8y
   LfxrCgi3gEsjekCCxrP5PZd1zeGtJ5jhR2XHaTURm5Rgs2rNUdfAimGCx
   w==;
X-IronPort-AV: E=Sophos;i="5.96,302,1665471600"; 
   d="scan'208";a="130942519"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Jan 2023 05:20:53 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 5 Jan 2023 05:20:49 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Thu, 5 Jan 2023 05:20:46 -0700
Message-ID: <f5758ec0ee377aec26440f31d82812aa19dbfba8.camel@microchip.com>
Subject: Re: [PATCH net-next 2/8] net: microchip: sparx5: Reset VCAP counter
 for new rules
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Dan Carpenter <error27@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        <UNGLinuxDriver@microchip.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Casper Andersson <casper.casan@gmail.com>,
        "Russell King" <rmk+kernel@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        "Nathan Huckleberry" <nhuck@google.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Daniel Machon" <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Date:   Thu, 5 Jan 2023 13:20:45 +0100
In-Reply-To: <Y7atTB9r07M+ZUC0@kadam>
References: <20230105081335.1261636-1-steen.hegelund@microchip.com>
         <20230105081335.1261636-3-steen.hegelund@microchip.com>
         <Y7aT8xGOCfvC/U0a@kadam>
         <7fa8ea30beffcb9256422f7a474a8be7d5791f5a.camel@microchip.com>
         <Y7atTB9r07M+ZUC0@kadam>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.2 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dan,

On Thu, 2023-01-05 at 13:58 +0300, Dan Carpenter wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e
> content is safe
>=20
> [ Email re-arranged because I screwed up - dan]
>=20
> On Thu, Jan 05, 2023 at 11:43:17AM +0100, Steen Hegelund wrote:
>=20
> > This series was first sent to net, but the response was that I should g=
o
> > into
> > net-next instead, so it is really a first version in net-next.
> >=20
> > What was your question?=C2=A0 I was not able to find it...
>=20
> Ugh...=C2=A0 Oauth2 code (mutt/msmtp) silently ate my email.=C2=A0 Sorry.
>=20
> > > > @@ -1833,6 +1834,8 @@ int vcap_add_rule(struct vcap_rule *rule)
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D vcap_write_rule(ri);
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret)
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 pr_err("%s:%d: rule write error: %d\n", __func__,
> > > > __LINE__,
> > > > ret);
>=20
> There should be a "goto out;" after the pr_err().

Indeed - You are right.  I will add that in the next series.

>=20
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0 /* Set the counter to zero */
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D vcap_write_counter(ri, &ctr);
> > > > =C2=A0out:
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mutex_unlock(&ri->admin->lock);
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
> > >=20
>=20
> regards,
> dan carpenter
>=20

Thanks for the feedback.

BR
Steen
