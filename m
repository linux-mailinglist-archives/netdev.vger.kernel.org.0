Return-Path: <netdev+bounces-4942-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E8F6870F4D5
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 13:10:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0AF2528125F
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 11:10:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FFA5171B9;
	Wed, 24 May 2023 11:10:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F195D1FB1
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 11:10:15 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C3BA3
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 04:10:14 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F257022188;
	Wed, 24 May 2023 11:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1684926613; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a/exLOh4Thl64jRt8+cw03rVVkDIJ7D9XDa2/wt2AxQ=;
	b=J+aLx5PTuaxvTPOBIjenNJwN6XI/g8/TPsZqJx/d7MSJGFtI66CzBgWTAhGOyYGRUdjvvI
	rb48nPwSy5iE2bZo04pgHRyoEbPW2suuSw78cwfFglskefnjHa75UZgDrbMo4jytwCcCzi
	9AUsl5cYWygZok7XB6nR8dALdMhdRO4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1684926613;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a/exLOh4Thl64jRt8+cw03rVVkDIJ7D9XDa2/wt2AxQ=;
	b=avtG7zFrhNWzrPwMf4sgf2SCRcWnUk0FChu3cMWmVIdH1W/HQPTqRNfEKseO5Zv63dlaQF
	P59lmDH6TQk042CQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 39530133E6;
	Wed, 24 May 2023 11:10:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id 9CFWDJTwbWSXOgAAMHmgww
	(envelope-from <jdelvare@suse.de>); Wed, 24 May 2023 11:10:12 +0000
Date: Wed, 24 May 2023 13:10:11 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= <u.kleine-koenig@pengutronix.de>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>, Vladimir Oltean
 <olteanv@gmail.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Corey Minyard <cminyard@mvista.com>, Peter Senna Tschudin
 <peter.senna@gmail.com>, Kang Chen <void0red@gmail.com>, "David S. Miller"
 <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Shang XiaoJing
 <shangxiaojing@huawei.com>, Rob Herring <robh@kernel.org>, Michael Walle
 <michael@walle.cc>, Benjamin Mugnier <benjamin.mugnier@foss.st.com>, Marek
 =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>, Petr Machata <petrm@nvidia.com>,
 Hans Verkuil <hverkuil-cisco@xs4all.nl>, Luca Ceresoli
 <luca.ceresoli@bootlin.com>, Jonathan Cameron
 <Jonathan.Cameron@huawei.com>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Jeremy Kerr <jk@codeconstruct.com.au>,
 Sebastian Reichel <sebastian.reichel@collabora.com>, Adrien Grassein
 <adrien.grassein@gmail.com>, Javier Martinez Canillas <javierm@redhat.com>,
 netdev@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH net-next] nfc: Switch i2c drivers back to use .probe()
Message-ID: <20230524131011.0d948017@endymion.delvare>
In-Reply-To: <20230520172104.359597-1-u.kleine-koenig@pengutronix.de>
References: <20230520172104.359597-1-u.kleine-koenig@pengutronix.de>
Organization: SUSE Linux
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.34; x86_64-suse-linux-gnu)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, 20 May 2023 19:21:04 +0200, Uwe Kleine-K=C3=B6nig wrote:
> After commit b8a1a4cd5a98 ("i2c: Provide a temporary .probe_new()
> call-back type"), all drivers being converted to .probe_new() and then
> 03c835f498b5 ("i2c: Switch .probe() to not take an id parameter")
> convert back to (the new) .probe() to be able to eventually drop
> .probe_new() from struct i2c_driver.
>=20
> Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
> ---
> Hello,
>=20
> this patch was generated using coccinelle, but I aligned the result to
> the per-file indention.
>=20
> This is one patch for the whole iio subsystem. if you want it split per

s/iio/nfc/

> driver for improved patch count numbers, please tell me.
>=20
> This currently fits on top of 6.4-rc1 and next/master. If you apply it
> somewhere else and get conflicts, feel free to just drop the files with
> conflicts from this patch and apply anyhow. I'll care about the fallout
> later then.
>=20
> Best regards
> Uwe
>=20
>  drivers/nfc/fdp/i2c.c       | 2 +-
>  drivers/nfc/microread/i2c.c | 2 +-
>  drivers/nfc/nfcmrvl/i2c.c   | 2 +-
>  drivers/nfc/nxp-nci/i2c.c   | 2 +-
>  drivers/nfc/pn533/i2c.c     | 2 +-
>  drivers/nfc/pn544/i2c.c     | 2 +-
>  drivers/nfc/s3fwrn5/i2c.c   | 2 +-
>  drivers/nfc/st-nci/i2c.c    | 2 +-
>  drivers/nfc/st21nfca/i2c.c  | 2 +-
>  9 files changed, 9 insertions(+), 9 deletions(-)
> (...)

Reviewed-by: Jean Delvare <jdelvare@suse.de>

--=20
Jean Delvare
SUSE L3 Support

