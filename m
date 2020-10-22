Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56DDA2958E8
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 09:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505853AbgJVHRJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 03:17:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395378AbgJVHRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 03:17:08 -0400
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65080C0613CE
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 00:17:08 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4CGzFZ56QSzQkmG;
        Thu, 22 Oct 2020 09:17:06 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1603351024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ug2CBdXi+IU0HHkAe0yIn+KGSS02zAaJNIRRu7EDAjI=;
        b=TEwYLHay5L1Cy274wnRLyV7e6EH7ULaFRefnvn5EyNFyk1gmP0GT48sAQl98QYAkucsKkR
        MlMrR/537daY8vc0NEJQoiOuzLNYMO5ypKUPrFV4RB+I2l1w47Q+DC1CyJVzMz70avGJSq
        fmHexabRzl1pE3dnS2tB1DjUhc1TdvY3EPFM5QGcAgNBh9vJTfs/qTOEOq8ffQ0kN/1cmB
        XgmOQhDn/SQmolhscGexM7Vzj0pMUVAQ5Nn0LemTOlf0U2ONvxejh/5bxRPjo+G9jx1Jhs
        6lTd3KHq5oq68HSFu/XLmlAdVo9dmSfVLArIBxls2UL+VvPvnUaH+aZ5oN5xYw==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter03.heinlein-hosting.de (spamfilter03.heinlein-hosting.de [80.241.56.117]) (amavisd-new, port 10030)
        with ESMTP id LisDRXWP8wFP; Thu, 22 Oct 2020 09:17:03 +0200 (CEST)
Date:   Thu, 22 Oct 2020 09:16:58 +0200
In-Reply-To: <20201021171101.60a7bd38@hermes.local>
References: <20201020114141.53391942@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <877drkk4qu.fsf@nvidia.com> <20201021112838.3026a648@hermes.local> <873627jg2d.fsf@nvidia.com> <20201021171101.60a7bd38@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH iproute2-next 15/15] dcb: Add a subtool for the DCB ETS object
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        dsahern@gmail.com, john.fastabend@gmail.com, jiri@nvidia.com,
        idosch@nvidia.com
From:   Petr Machata <me@pmachata.org>
Message-ID: <AE43B7AF-6B32-4FFB-B111-6D63C843EE03@pmachata.org>
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -5.32 / 15.00 / 15.00
X-Rspamd-Queue-Id: 59E311709
X-Rspamd-UID: 61049b
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On October 22, 2020 2:11:01 AM GMT+02:00, Stephen Hemminger <stephen@netwo=
rkplumber=2Eorg> wrote:
>On Thu, 22 Oct 2020 01:48:58 +0200
>Petr Machata <me@pmachata=2Eorg> wrote:
>
>> Stephen Hemminger <stephen@networkplumber=2Eorg> writes:
>>=20
>> > On Tue, 20 Oct 2020 22:43:37 +0200
>> > Petr Machata <me@pmachata=2Eorg> wrote:
>> > =20
>> >> Jakub Kicinski <kuba@kernel=2Eorg> writes:
>> >> =20
>> >> > On Tue, 20 Oct 2020 02:58:23 +0200 Petr Machata wrote: =20
>> >> >> +static void dcb_ets_print_cbs(FILE *fp, const struct ieee_ets
>*ets)
>> >> >> +{
>> >> >> +	print_string(PRINT_ANY, "cbs", "cbs %s ", ets->cbs ? "on" :
>"off");
>> >> >> +} =20
>> >> >
>> >> > I'd personally lean in the direction ethtool is taking and try
>to limit
>> >> > string values in json output as much as possible=2E This would be
>a good
>> >> > fit for bool=2E =20
>> >>
>> >> Yep, makes sense=2E The value is not user-toggleable, so the on /
>off
>> >> there is just arbitrary=2E
>> >>
>> >> I'll consider it for "willing" as well=2E That one is
>user-toggleable, and
>> >> the "on" / "off" makes sense for consistency with the command
>line=2E But
>> >> that doesn't mean it can't be a boolean in JSON=2E =20
>> >
>> > There are three ways of representing a boolean=2E You chose the
>worst=2E
>> > Option 1: is to use a json null value to indicate presence=2E
>> >       this works well for a flag=2E
>> > Option 2: is to use json bool=2E
>> > 	this looks awkward in non-json output
>> > Option 3: is to use a string
>> >      	but this makes the string output something harder to consume
>> > 	in json=2E =20
>>=20
>> What seems to be used commonly for these on/off toggles is the
>following
>> pattern:
>>=20
>> 	print_string(PRINT_FP, NULL, "willing %s ", ets->willing ? "on" :
>"off");
>> 	print_bool(PRINT_JSON, "willing", NULL, true);
>>=20
>> That way the JSON output is easy to query and the FP output is
>obvious
>> and compatible with the command line=2E Does that work for you?
>
>Yes, that is hybrid, maybe it should be a helper function?

Yep, I'll do the same dance as for the other helpers in the patch set=2E C=
urrently this is cut and pasted all over the place=2E
