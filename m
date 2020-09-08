Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBCAA261766
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 19:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731389AbgIHRdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 13:33:12 -0400
Received: from a27-187.smtp-out.us-west-2.amazonses.com ([54.240.27.187]:33420
        "EHLO a27-187.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731315AbgIHQPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 12:15:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1599566566;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=A0Pg1JJyx96lY6kzESsukz/fsFFg2QJ+mjpfboIMRWc=;
        b=CasPNC+KAQLq7fbQs/ZX016E5VPiGOgnU5TVmOk/j+oOml3iVfZzlrrRGQNCL5s6
        Zt56vN2zlw9t3LNw+4h9zWKeNgznCXpYEEb4Y18bGnI7I7HUFZE9g/fNHKOEvMsq5+p
        LA9GVvP7LhuxaGQrvBo6wCCfCA9EStK1YF3KzOB8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=hsbnp7p3ensaochzwyq5wwmceodymuwv; d=amazonses.com; t=1599566566;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Feedback-ID;
        bh=A0Pg1JJyx96lY6kzESsukz/fsFFg2QJ+mjpfboIMRWc=;
        b=YYzpdjFd4DrmPd7BeZp/TFeYAFS64CzYDs38adPNVsTPlEJoF1WGt/twkFHnsUpW
        KzOAMQX2IPMZM+HFFzNjdSK1hw2DfdbXaqiRv0MdpJcSsaIDkCxIx9FL4DWZttXwmwW
        08METUWReBt9Dt3nxeDNIhXDmKAGTfxTLJgYE/Ks=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8FD10C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>
Subject: Re: [PATCH 16/28] wireless: marvell: mwifiex: init: Move 'tos_to_tid_inv' to where it's used
References: <20200819072402.3085022-17-lee.jones@linaro.org>
        <20200831155151.0DCB5C4339C@smtp.codeaurora.org>
        <20200908084953.GJ4400@dell>
Date:   Tue, 8 Sep 2020 12:02:46 +0000
In-Reply-To: <20200908084953.GJ4400@dell> (Lee Jones's message of "Tue, 8 Sep
        2020 09:49:53 +0100")
Message-ID: <010101746d98d281-78bf23c9-db60-486f-ada9-fec0467131a4-000000@us-west-2.amazonses.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SES-Outgoing: 2020.09.08-54.240.27.187
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lee Jones <lee.jones@linaro.org> writes:

> On Mon, 31 Aug 2020, Kalle Valo wrote:
>
>> Lee Jones <lee.jones@linaro.org> wrote:
>>=20
>> > 'tos_to_tid_inv' is only used in 2 of 17 files it's current being
>> > included into.
>> >=20
>> > Fixes the following W=3D1 kernel build warning(s):
>> >=20
>> >  In file included from drivers/net/wireless/marvell/mwifiex/main.c:23:
>> >  In file included from drivers/net/wireless/marvell/mwifiex/cmdevt.c:2=
6:
>> >  In file included from drivers/net/wireless/marvell/mwifiex/util.c:25:
>> >  In file included from drivers/net/wireless/marvell/mwifiex/txrx.c:25:
>> >  In file included from drivers/net/wireless/marvell/mwifiex/11n.c:25:
>> >  In file included from drivers/net/wireless/marvell/mwifiex/wmm.c:25:
>> >  In file included from drivers/net/wireless/marvell/mwifiex/11n_aggr.c=
:25:
>> >  In file included from drivers/net/wireless/marvell/mwifiex/11n_rxreor=
der.c:25:
>> >  In file included from drivers/net/wireless/marvell/mwifiex/join.c:25:
>> >  In file included from drivers/net/wireless/marvell/mwifiex/sta_cmd.c:=
25:
>> >  In file included from drivers/net/wireless/marvell/mwifiex/sta_ioctl.=
c:25:
>> >  In file included from drivers/net/wireless/marvell/mwifiex/sta_event.=
c:25:
>> >  In file included from drivers/net/wireless/marvell/mwifiex/uap_txrx.c=
:23:
>> >  In file included from drivers/net/wireless/marvell/mwifiex/sdio.c:27:
>> >  In file included from drivers/net/wireless/marvell/mwifiex/sta_tx.c:2=
5:
>> >  drivers/net/wireless/marvell/mwifiex/wmm.h:41:17: warning:
>> > =E2=80=98tos_to_tid_inv=E2=80=99 defined but not used [-Wunused-const-=
variable=3D]
>> >  41 | static const u8 tos_to_tid_inv[] =3D {
>> >=20
>> >  NB: Snipped for brevity
>> >=20
>> > Cc: Amitkumar Karwar <amitkarwar@gmail.com>
>> > Cc: Ganapathi Bhat <ganapathi.bhat@nxp.com>
>> > Cc: Xinming Hu <huxinming820@gmail.com>
>> > Cc: Kalle Valo <kvalo@codeaurora.org>
>> > Cc: "David S. Miller" <davem@davemloft.net>
>> > Cc: Jakub Kicinski <kuba@kernel.org>
>> > Cc: linux-wireless@vger.kernel.org
>> > Cc: netdev@vger.kernel.org
>> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
>>=20
>> The patch creates two duplicate arrays, this makes it worse than it was
>> before.
>
> We have a choice (and you don't like either of them). :)
>
> Either add the variable into the file(s) they are used or tell the
> compiler that it's okay for other files to declare but not used them
> (mark as __maybe_unused).
>
> What is your preferred solution?

Yue already sent a patch for this (at least I think so, not 100% sure if
this is the same case):

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next=
.git/commit/?id=3Dd56ee19a148edaa9972ca12f817e395ba436078b

But that's the solution I like :) There's only one array and it's shared
by all the users.

--=20
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
