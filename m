Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2EBB51A4F3
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 18:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353084AbiEDQMn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 4 May 2022 12:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353073AbiEDQMl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 12:12:41 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7D03927FD6
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 09:09:03 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-304-235WxlwhNjKFdg4Xv28oCg-1; Wed, 04 May 2022 17:08:18 +0100
X-MC-Unique: 235WxlwhNjKFdg4Xv28oCg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.32; Wed, 4 May 2022 17:08:15 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.033; Wed, 4 May 2022 17:08:15 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Kees Cook' <keescook@chromium.org>,
        Johannes Berg <johannes@sipsolutions.net>
CC:     "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Keith Packard <keithp@keithp.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Daniel Axtens <dja@axtens.net>,
        Dan Williams <dan.j.williams@intel.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Tadeusz Struk <tadeusz.struk@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Gabbasov <andrew_gabbasov@mentor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Gross <agross@kernel.org>,
        Andy Lavr <andy.lavr@gmail.com>,
        Arend van Spriel <aspriel@gmail.com>,
        "Baowen Zheng" <baowen.zheng@corigine.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Bradley Grove <linuxdrivers@attotech.com>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        Christian Brauner <brauner@kernel.org>,
        =?iso-8859-1?Q?Christian_G=F6ttsche?= <cgzones@googlemail.com>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Chris Zankel <chris@zankel.net>,
        Cong Wang <cong.wang@bytedance.com>,
        "David Gow" <davidgow@google.com>,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "Dmitry Kasatkin" <dmitry.kasatkin@gmail.com>,
        Eli Cohen <elic@nvidia.com>,
        "Eric Dumazet" <edumazet@google.com>,
        Eric Paris <eparis@parisplace.org>,
        "Eugeniu Rosca" <erosca@de.adit-jv.com>,
        Felipe Balbi <balbi@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "Hante Meuleman" <hante.meuleman@broadcom.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hulk Robot <hulkci@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        James Morris <jmorris@namei.org>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        John Keeping <john@metanate.com>,
        Juergen Gross <jgross@suse.com>, Kalle Valo <kvalo@kernel.org>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "kunit-dev@googlegroups.com" <kunit-dev@googlegroups.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        "Lars-Peter Clausen" <lars@metafoo.de>,
        Lee Jones <lee.jones@linaro.org>,
        Leon Romanovsky <leon@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux1394-devel@lists.sourceforge.net" 
        <linux1394-devel@lists.sourceforge.net>,
        "linux-afs@lists.infradead.org" <linux-afs@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        Loic Poulain <loic.poulain@linaro.org>,
        Louis Peens <louis.peens@corigine.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        "Luiz Augusto von Dentz" <luiz.dentz@gmail.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Mark Brown <broonie@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Max Filippov" <jcmvbkbc@gmail.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Nathan Chancellor <nathan@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        =?iso-8859-1?Q?Nuno_S=E1?= <nuno.sa@analog.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        "Rich Felker" <dalias@aerifal.cx>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        "SHA-cyfmac-dev-list@infineon.com" <SHA-cyfmac-dev-list@infineon.com>,
        Simon Horman <simon.horman@corigine.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Takashi Iwai <tiwai@suse.com>, Tom Rix <trix@redhat.com>,
        Udipto Goswami <quic_ugoswami@quicinc.com>,
        "wcn36xx@lists.infradead.org" <wcn36xx@lists.infradead.org>,
        Wei Liu <wei.liu@kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        Xiu Jianfeng <xiujianfeng@huawei.com>,
        "Yang Yingliang" <yangyingliang@huawei.com>
Subject: RE: [PATCH 02/32] Introduce flexible array struct memcpy() helpers
Thread-Topic: [PATCH 02/32] Introduce flexible array struct memcpy() helpers
Thread-Index: AQHYX80GRJFxZRupFEigWcMQWGiaSK0O4MfQ
Date:   Wed, 4 May 2022 16:08:15 +0000
Message-ID: <bc2efc31d25e4f42a98f0a5d7a8ad88a@AcuMS.aculab.com>
References: <20220504014440.3697851-1-keescook@chromium.org>
 <20220504014440.3697851-3-keescook@chromium.org>
 <d3b73d80f66325fdfaf2d1f00ea97ab3db03146a.camel@sipsolutions.net>
 <202205040819.DEA70BD@keescook>
In-Reply-To: <202205040819.DEA70BD@keescook>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kees Cook
> Sent: 04 May 2022 16:38
...
> > >     struct something *instance = NULL;
> > >     int rc;
> > >
> > >     rc = mem_to_flex_dup(&instance, byte_array, count, GFP_KERNEL);
> > >     if (rc)
> > >         return rc;
> >
> > This seems rather awkward, having to set it to NULL, then checking rc
> > (and possibly needing a separate variable for it), etc.
> 
> I think the errno return is completely required. I had an earlier version
> of this that was much more like a drop-in replacement for memcpy that
> would just truncate or panic, and when I had it all together, I could
> just imagine hearing Linus telling me to start over because it was unsafe
> (truncation may be just as bad as overflow) and disruptive ("never BUG"),
> and that it should be recoverable. So, I rewrote it all to return a
> __must_check errno.
> 
> Requiring instance to be NULL is debatable, but I feel pretty strongly
> about it because it does handle a class of mistakes (resource leaks),
> and it's not much of a burden to require a known-good starting state.

Why not make it look like malloc() since it seems to be malloc().
That gives a much better calling convention.
Passing pointers and integers by reference can generate horrid code.
(Mostly because it stops the compiler keeping values in registers.)

If you want the type information inside the 'function'
use a #define so that the use is:

	mem_to_flex_dup(instance, byte_array, count, GFP_KERNEL);
	if (!instance)
		return ...
(or use ERR_PTR() etc).

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

