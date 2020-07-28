Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF203231047
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 18:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731742AbgG1Q72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 12:59:28 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:55227 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731728AbgG1Q71 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 12:59:27 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1595955566; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: Date: Subject: In-Reply-To: References: Cc:
 To: From: Sender; bh=N8+BlcHePeCs/+hf2+RN1tVqgqYvQtxvpdrZJOj+nmk=; b=S/C6gMjq4Jn6Dnv3P4FmeVm9Dt7XzB2hexzx2T2mLv2dFCaY6N7jovuIxg7lnwV4hoTUWfsM
 hKGDrYOvSjYeOb5VDL9lhuiZgLOXyC/IR1nEOIyaF5y4fmUdiHP2MfAyTN9C5pIipnqxt6vu
 OHZJiZ4GRWAqX/8Xpj5o+UwK5Ok=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n19.prod.us-west-2.postgun.com with SMTP id
 5f20595f298a38b616c2cc28 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 28 Jul 2020 16:59:11
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B36EAC433AD; Tue, 28 Jul 2020 16:59:11 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from Pillair (unknown [49.205.240.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: pillair)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6DFAAC433C6;
        Tue, 28 Jul 2020 16:59:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6DFAAC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=pillair@codeaurora.org
From:   "Rakesh Pillai" <pillair@codeaurora.org>
To:     "'David Laight'" <David.Laight@ACULAB.COM>,
        "'Sebastian Gottschall'" <s.gottschall@dd-wrt.com>,
        "'Hillf Danton'" <hdanton@sina.com>
Cc:     "'Andrew Lunn'" <andrew@lunn.ch>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ath10k@lists.infradead.org>, <dianders@chromium.org>,
        "'Markus Elfring'" <Markus.Elfring@web.de>, <evgreen@chromium.org>,
        <kuba@kernel.org>, <johannes@sipsolutions.net>,
        <davem@davemloft.net>, <kvalo@codeaurora.org>
References: <1595351666-28193-1-git-send-email-pillair@codeaurora.org> <20200721172514.GT1339445@lunn.ch> <20200725081633.7432-1-hdanton@sina.com> <8359a849-2b8a-c842-a501-c6cb6966e345@dd-wrt.com> <20200725145728.10556-1-hdanton@sina.com> <2664182a-1d03-998d-8eff-8478174a310a@dd-wrt.com> <cb54c2746a3d4ce695e3bda8b576b40e@AcuMS.aculab.com>
In-Reply-To: <cb54c2746a3d4ce695e3bda8b576b40e@AcuMS.aculab.com>
Subject: RE: [RFC 0/7] Add support to process rx packets in thread
Date:   Tue, 28 Jul 2020 22:29:02 +0530
Message-ID: <001001d66500$69a58970$3cf09c50$@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Content-Language: en-us
Thread-Index: AQG1Bu1FBYi7G1oVhHY/01uT1gSslwJNiRkqApu6+hkBXSQ6awJoRsl8AqlHfdQCIFt2Taj0MByg
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: David Laight <David.Laight@ACULAB.COM>
> Sent: Sunday, July 26, 2020 4:46 PM
> To: 'Sebastian Gottschall' <s.gottschall@dd-wrt.com>; Hillf Danton
> <hdanton@sina.com>
> Cc: Andrew Lunn <andrew@lunn.ch>; Rakesh Pillai =
<pillair@codeaurora.org>;
> netdev@vger.kernel.org; linux-wireless@vger.kernel.org; linux-
> kernel@vger.kernel.org; ath10k@lists.infradead.org;
> dianders@chromium.org; Markus Elfring <Markus.Elfring@web.de>;
> evgreen@chromium.org; kuba@kernel.org; johannes@sipsolutions.net;
> davem@davemloft.net; kvalo@codeaurora.org
> Subject: RE: [RFC 0/7] Add support to process rx packets in thread
>=20
> From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
> > Sent: 25 July 2020 16:42
> > >> i agree. i just can say that i tested this patch recently due =
this
> > >> discussion here. and it can be changed by sysfs. but it doesnt =
work for
> > >> wifi drivers which are mainly using dummy netdev devices. for =
this i
> > >> made a small patch to get them working using napi_set_threaded
> manually
> > >> hardcoded in the drivers. (see patch bellow)
>=20
> > > By CONFIG_THREADED_NAPI, there is no need to consider what you did
> here
> > > in the napi core because device drivers know better and are =
responsible
> > > for it before calling napi_schedule(n).
>=20
> > yeah. but that approach will not work for some cases. some stupid
> > drivers are using locking context in the napi poll function.
> > in that case the performance will runto shit. i discovered this with =
the
> > mvneta eth driver (marvell) and mt76 tx polling (rx  works)
> > for mvneta is will cause very high latencies and packet drops. for =
mt76
> > it causes packet stop. doesnt work simply (on all cases no crashes)
> > so the threading will only work for drivers which are compatible =
with
> > that approach. it cannot be used as drop in replacement from my =
point of
> > view.
> > its all a question of the driver design
>=20
> Why should it make (much) difference whether the napi callbacks (etc)
> are done in the context of the interrupted process or that of a
> specific kernel thread.
> The process flags (or whatever) can even be set so that it appears
> to be the expected 'softint' context.
>=20
> In any case running NAPI from a thread will just show up the next
> piece of code that runs for ages in softint context.
> I think I've seen the tail end of memory being freed under rcu
> finally happening under softint and taking absolutely ages.
>=20
> 	David
>=20

Hi All,

Is the threaded NAPI change posted to kernel ?=20
Is the conclusion of this discussion that " we cannot use threads for =
processing packets " ??


> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes,
> MK1 1PT, UK
> Registration No: 1397386 (Wales)

