Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8864B9363
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 22:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235784AbiBPVz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 16:55:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiBPVz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 16:55:27 -0500
Received: from vps.slashdirt.org (vps.slashdirt.org [144.91.108.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 533651F465D;
        Wed, 16 Feb 2022 13:55:13 -0800 (PST)
Received: from smtpclient.apple (tardis.herebedragons.eu [171.22.3.161])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by vps.slashdirt.org (Postfix) with ESMTPSA id D7CE0602F9;
        Wed, 16 Feb 2022 22:55:11 +0100 (CET)
DMARC-Filter: OpenDMARC Filter v1.4.0 vps.slashdirt.org D7CE0602F9
Authentication-Results: vps.slashdirt.org; dmarc=fail (p=quarantine dis=none) header.from=slashdirt.org
DKIM-Filter: OpenDKIM Filter v2.11.0 vps.slashdirt.org D7CE0602F9
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=slashdirt.org; s=mail;
        t=1645048512; bh=v0qDUc+ItBsspfMJTkeG+1dEta7rV0qYjnK1c5Z/lho=;
        h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
        b=D7Ih8nLEDAJpiLAysBOiAchFMG3K9rdnRSoNG3AXfCfUYpGwPkDLKp8Y3Z0/OANEY
         qVUp74QTujBUKPfkzf0iAhhIDPJU6i5gzCX3aWCdWVP7OsX8LSwIvjmjrclRhNTKrw
         SLf0aCiKGILBGkRdmwNOem8EYwl4zLgedtW8bC60=
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.60.0.1.1\))
Subject: Re: [PATCH] ath10k: support bus and device specific API 1 BDF
 selection
From:   Thibaut <hacks@slashdirt.org>
In-Reply-To: <70a8dd7a-851d-686b-3134-50f21af0450c@gmail.com>
Date:   Wed, 16 Feb 2022 22:55:11 +0100
Cc:     Robert Marko <robimarko@gmail.com>, Kalle Valo <kvalo@kernel.org>,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <7DCB1B9A-D08E-4837-B2FE-6DA476B54B0D@slashdirt.org>
References: <20211009221711.2315352-1-robimarko@gmail.com>
 <163890036783.24891.8718291787865192280.kvalo@kernel.org>
 <CAOX2RU5mqUfPRDsQNSpVPdiz6sE_68KN5Ae+2bC_t1cQzdzgTA@mail.gmail.com>
 <09a27912-9ea4-fe75-df72-41ba0fa5fd4e@gmail.com>
 <CAOX2RU6qaZ7NkeRe1bukgH6OxXOPvJS=z9PRp=UYAxMfzwD2oQ@mail.gmail.com>
 <EC2778B3-B957-4F3F-B299-CC18805F8381@slashdirt.org>
 <CAOX2RU7FOdSuo2Jgo0i=8e-4bJwq7ahvQxLzQv_zNCz2HCTBwA@mail.gmail.com>
 <CAOX2RU7d9amMseczgp-PRzdOvrgBO4ZFM_+hTRSevCU85qT=kA@mail.gmail.com>
 <70a8dd7a-851d-686b-3134-50f21af0450c@gmail.com>
To:     Christian Lamparter <chunkeey@gmail.com>
X-Mailer: Apple Mail (2.3693.60.0.1.1)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NO_DNS_FOR_FROM,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> Le 16 f=C3=A9vr. 2022 =C3=A0 22:19, Christian Lamparter =
<chunkeey@gmail.com> a =C3=A9crit :
>=20
> Hi,
>=20
> On 16/02/2022 14:38, Robert Marko wrote:
>> Silent ping,
>> Does anybody have an opinion on this?
>=20
> As a fallback, I've cobbled together from the old scripts that
> "concat board.bin into a board-2.bin. Do this on the device
> in userspace on the fly" idea. This was successfully tested
> on one of the affected devices (MikroTik SXTsq 5 ac (RBSXTsqG-5acD))
> and should work for all MikroTik.
>=20
> "ipq40xx: dynamically build board-2.bin for Mikrotik"
> =
<https://git.openwrt.org/?p=3Dopenwrt/staging/chunkeey.git;a=3Dcommit;h=3D=
52f3407d94da62b99ba6c09f3663464cccd29b4f>
> (though I don't think this link will stay active for
> too long.)

IMHO Robert=E2=80=99s patch addresses an actual bug in ath10k whereby =
the driver sends the same devpath for two different devices when =
requesting board-1 BDF, which doesn=E2=80=99t seem right.

Your proposal is less straightforward than using unmodified board-1 data =
(as could be done if the above bug did not occur) and negates the =
previous efforts not to store this data on flash (using instead the =
kernel=E2=80=99s documented firmware sysfs loading facility - again =
possible without the above issue).

HTH
T-Bone=
