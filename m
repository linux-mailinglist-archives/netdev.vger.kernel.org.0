Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9BA551C3CD
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 17:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381254AbiEEPZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 11:25:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232495AbiEEPZd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 11:25:33 -0400
X-Greylist: delayed 338 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 05 May 2022 08:21:52 PDT
Received: from elaine.keithp.com (home.keithp.com [63.227.221.253])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91427554A8;
        Thu,  5 May 2022 08:21:52 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by elaine.keithp.com (Postfix) with ESMTP id 373F23F3296A;
        Thu,  5 May 2022 08:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=keithp.com; s=mail;
        t=1651763774; bh=O3aXJOWYxVTqOu3VmcXxOiZZOhMrUjqY/t6cXMT24+E=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=M3zB+WUy+cYZq4HgtgtbfmLljWbRpIeJ5Zkg9r1D71YqvPlgOkiQ4tXheXCRGUa8+
         RMuby4CqFAMCoPUIrwdzYTZDTf78io+RFFo6OcdGBDUFDZRaGhZfKKcTtwdj7WCFy4
         6tn6om4NwF6owZoCYEHNTlN4dA5iODmOFbhrxNDmu4q/fHHXFfSRYzNqzWEthWHBp3
         hB3E0o3k1G8NwFJfKh9rQpVZYZLwPg6CF6he0rk/+KFPQLpotGYN+CgB1L7QQOYecl
         ymeV9rACfLcKoB95CZdy6K628IEeM8t07ROlSN+X9O0IbQydzX/BQ3xj9k+MYZwzPf
         UxJC+uQh0iuJw==
X-Virus-Scanned: Debian amavisd-new at keithp.com
Received: from elaine.keithp.com ([127.0.0.1])
        by localhost (elaine.keithp.com [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id AExLuWAu_LJ4; Thu,  5 May 2022 08:16:13 -0700 (PDT)
Received: from keithp.com (koto.keithp.com [192.168.11.2])
        by elaine.keithp.com (Postfix) with ESMTPSA id 046443F32465;
        Thu,  5 May 2022 08:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=keithp.com; s=mail;
        t=1651763773; bh=O3aXJOWYxVTqOu3VmcXxOiZZOhMrUjqY/t6cXMT24+E=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=krSTvH+KcMYcsYiJs+brgDawkHD6ep7gtAt/7ImbSH+PVnVS6n5TIWQoiUP+PjBfQ
         TTV9zZEzFSNSLzQmSsEIJT24ancVfic/4tw1+i19H4UqIv2Soci174vL3i+L8WgOn3
         3GAVx4Wwdu1vRPL7EVqx5qPLOOTreMDXIScBgNd+X5AcHfMZWw538tPrPoKpSSqHZH
         dCLZclbzdDsdQUL6m86l3cbny8WccVcefFqv7gslHwR8P3ZsfbW/X+4PLXD3hTeyro
         XMqcEagdrGN5NURX0L6R0oPpkf8LkkkUJo0DYZf6b68EQ+TuLV1TgvwIq/q3gwMiYO
         4YgvEK7vCGplw==
Received: by keithp.com (Postfix, from userid 1000)
        id 4874D1E601B9; Thu,  5 May 2022 08:16:12 -0700 (PDT)
From:   Keith Packard <keithp@keithp.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Kees Cook <keescook@chromium.org>
Cc:     "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Daniel Axtens <dja@axtens.net>,
        Dan Williams <dan.j.williams@intel.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Tadeusz Struk <tadeusz.struk@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        alsa-devel@alsa-project.org, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Gabbasov <andrew_gabbasov@mentor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Gross <agross@kernel.org>,
        Andy Lavr <andy.lavr@gmail.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Bradley Grove <linuxdrivers@attotech.com>,
        brcm80211-dev-list.pdl@broadcom.com,
        Christian Brauner <brauner@kernel.org>,
        Christian =?utf-8?Q?G=C3=B6ttsche?= <cgzones@googlemail.com>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Chris Zankel <chris@zankel.net>,
        Cong Wang <cong.wang@bytedance.com>,
        David Gow <davidgow@google.com>,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        devicetree@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        Eli Cohen <elic@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Paris <eparis@parisplace.org>,
        Eugeniu Rosca <erosca@de.adit-jv.com>,
        Felipe Balbi <balbi@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
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
        keyrings@vger.kernel.org, kunit-dev@googlegroups.com,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Lee Jones <lee.jones@linaro.org>,
        Leon Romanovsky <leon@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux1394-devel@lists.sourceforge.net,
        linux-afs@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-xtensa@linux-xtensa.org, llvm@lists.linux.dev,
        Loic Poulain <loic.poulain@linaro.org>,
        Louis Peens <louis.peens@corigine.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Mark Brown <broonie@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Nathan Chancellor <nathan@kernel.org>, netdev@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nuno =?utf-8?Q?S=C3=A1?= <nuno.sa@analog.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Rich Felker <dalias@aerifal.cx>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, selinux@vger.kernel.org,
        "Serge E. Hallyn" <serge@hallyn.com>,
        SHA-cyfmac-dev-list@infineon.com,
        Simon Horman <simon.horman@corigine.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Takashi Iwai <tiwai@suse.com>, Tom Rix <trix@redhat.com>,
        Udipto Goswami <quic_ugoswami@quicinc.com>,
        wcn36xx@lists.infradead.org, Wei Liu <wei.liu@kernel.org>,
        xen-devel@lists.xenproject.org,
        Xiu Jianfeng <xiujianfeng@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: Re: [PATCH 02/32] Introduce flexible array struct memcpy() helpers
In-Reply-To: <970a674df04271b5fd1971b495c6b11a996c20c2.camel@sipsolutions.net>
References: <20220504014440.3697851-1-keescook@chromium.org>
 <20220504014440.3697851-3-keescook@chromium.org>
 <d3b73d80f66325fdfaf2d1f00ea97ab3db03146a.camel@sipsolutions.net>
 <202205040819.DEA70BD@keescook>
 <970a674df04271b5fd1971b495c6b11a996c20c2.camel@sipsolutions.net>
Date:   Thu, 05 May 2022 08:16:11 -0700
Message-ID: <871qx8qabo.fsf@keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Johannes Berg <johannes@sipsolutions.net> writes:

> Yeah, dunno, I guess I'm slightly more on the side of not requiring it,
> since we don't do the same for kmalloc() etc. and probably really
> wouldn't want to add kmalloc_s() that does it ;-)

I suspect the number of bugs this catches will be small, but they'll be
in places where the flow of control is complicated. What we want is to
know that there's no "real" value already present. I'd love it if we
could make the macro declare a new name (yeah, I know, mixing
declarations and code).

Of course, we could also end up with people writing a wrapping macro
that sets the variable to NULL before invoking the underlying macro...

=2D-=20
=2Dkeith

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEw4O3eCVWE9/bQJ2R2yIaaQAAABEFAmJz6jsACgkQ2yIaaQAA
ABGQAg/+NFgE01jSUQAsZc8G2KY9qfifpQ5rzrWtedUNXoOhcAo33tvPHnED0AxP
Q4MXv/X4TRCTOD/5aBjZeKgy9I9G2jYbZq9iYf5uaD9zIECpE5XyznDZzo15cWBE
B+W7olq9dqiARf6CuwNpYCjB8zv2ubR42c+faTCJNM63owpN9xpGT/7OEbE0HoKg
TawmusqNU2nOkT82kjh1iVoK0BbmPSATiKkCH9ZpUVQYOQvsyieFtAlQREms/pip
ccnHssDAaV1dgAg2NlKDzU30XA3rIIsfX+v3Bh+CWoj77Az7IO8+/V+nmNm5GHyy
bs8LUQY3Z7/otHyGVfjVN9eU6LcEvstr7tOPLWxF0h+YxJk12uKhUZnmt4NisYrL
uOcx/MC4y6tx9+kdn1U5KoV+O/ekhW/N/WwYcE6YUYZeol3Ahpve77B7uzLbwyOj
TMLF83DtVqGLwl1y5mdKUfdeUeYhVMYo+eaq0ChKHdYdKj9ra2BaL1oiTc3lKqVW
FdHX7C9qLA4LsTzfuDiEQDOrnwMDXhvtQrysTOjlQLIcivarCfxIKQw0co8Vubug
sceCDXCr5qY2cCr51YqbDSVqEXK5Dos7IGlIyIlZH0YCktIbgOGTEPZDcidplXy2
LWWWFIK6Viz1AgjSRxRU24qmTbFCFLZdboKDuzsCHG8HDByLmNM=
=BTwc
-----END PGP SIGNATURE-----
--=-=-=--
