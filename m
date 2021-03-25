Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1970A348D4D
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 10:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbhCYJqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 05:46:14 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:54628 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbhCYJqF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 05:46:05 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1616665565; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: Date: Subject: In-Reply-To: References: Cc:
 To: From: Sender; bh=xLZMPOc+Bf0JSFPQICytoPaldsUvFtyL1tpTNNRZGmo=; b=fgEDhRe1Rsg9SJr4BWLHu0GCxHolNL4f4qNsTKjOwrffA2IXarxBHJl+AXPmB/CgdTiOx93U
 lejPjg08n9x9VD/QWdlndiocjpA9L6C2B2UTc+mx2yKxZn2fpA+90cqQEfuw+9a92kGiChhU
 MULi2KZtT8YwCGx3a8sdrbOHuOc=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 605c5bd12b0e10a0ba26d3fa (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 25 Mar 2021 09:45:53
 GMT
Sender: pillair=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C9E29C433ED; Thu, 25 Mar 2021 09:45:53 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        PDS_BAD_THREAD_QP_64,SPF_FAIL,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from Pillair (unknown [103.149.159.141])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: pillair)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 770E0C433CA;
        Thu, 25 Mar 2021 09:45:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 770E0C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=pillair@codeaurora.org
From:   "Rakesh Pillai" <pillair@codeaurora.org>
To:     "'Felix Fietkau'" <nbd@nbd.name>,
        "'Ben Greear'" <greearb@candelatech.com>,
        "'Brian Norris'" <briannorris@chromium.org>
Cc:     "'Johannes Berg'" <johannes@sipsolutions.net>,
        "'Rajkumar Manoharan'" <rmanohar@codeaurora.org>,
        "'ath10k'" <ath10k@lists.infradead.org>,
        "'linux-wireless'" <linux-wireless@vger.kernel.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Kalle Valo'" <kvalo@codeaurora.org>,
        "'David S. Miller'" <davem@davemloft.net>,
        "'Jakub Kicinski'" <kuba@kernel.org>, <netdev@vger.kernel.org>,
        "'Doug Anderson'" <dianders@chromium.org>,
        "'Evan Green'" <evgreen@chromium.org>
References: <1595351666-28193-1-git-send-email-pillair@codeaurora.org> <1595351666-28193-3-git-send-email-pillair@codeaurora.org> <13573549c277b34d4c87c471ff1a7060@codeaurora.org> <d79ae05e-e75a-de2f-f2e3-bc73637e1501@nbd.name> <04d7301d5ad7555a0377c7df530ad8522fc00f77.camel@sipsolutions.net> <1f2726ff-8ba9-5278-0ec6-b80be475ea98@nbd.name> <06a4f84b-a0d4-3f90-40bb-f02f365460ec@candelatech.com> <CA+ASDXOotYHmtqOvSwBES6_95bnbAbEu6F7gQ5TjacJWUKdaPw@mail.gmail.com> <47d8be60-14ce-0223-bdf3-c34dc2451945@candelatech.com> <633feaed-7f34-15d3-1899-81eb1d6ae14f@nbd.name>
In-Reply-To: <633feaed-7f34-15d3-1899-81eb1d6ae14f@nbd.name>
Subject: RE: [RFC 2/7] ath10k: Add support to process rx packet in thread
Date:   Thu, 25 Mar 2021 15:15:44 +0530
Message-ID: <003701d7215b$a44ae030$ece0a090$@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQG1Bu1FBYi7G1oVhHY/01uT1gSslwH2O/GCAtCmWRoBYxlAVQH0T8LwAZ17l3YBXZ7u8AIxJEyGAbYhhCACZ7wzuKpNZQxQ
Content-Language: en-us
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Felix Fietkau <nbd@nbd.name>
> Sent: Tuesday, March 23, 2021 1:16 PM
> To: Ben Greear <greearb@candelatech.com>; Brian Norris
> <briannorris@chromium.org>
> Cc: Johannes Berg <johannes@sipsolutions.net>; Rajkumar Manoharan
> <rmanohar@codeaurora.org>; Rakesh Pillai <pillair@codeaurora.org>; =
ath10k
> <ath10k@lists.infradead.org>; linux-wireless <linux-
> wireless@vger.kernel.org>; Linux Kernel =
<linux-kernel@vger.kernel.org>;
> Kalle Valo <kvalo@codeaurora.org>; David S. Miller
> <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>;
> netdev@vger.kernel.org; Doug Anderson <dianders@chromium.org>; Evan
> Green <evgreen@chromium.org>
> Subject: Re: [RFC 2/7] ath10k: Add support to process rx packet in =
thread
>=20
>=20
> On 2021-03-23 04:01, Ben Greear wrote:
> > On 3/22/21 6:20 PM, Brian Norris wrote:
> >> On Mon, Mar 22, 2021 at 4:58 PM Ben Greear
> <greearb@candelatech.com> wrote:
> >>> On 7/22/20 6:00 AM, Felix Fietkau wrote:
> >>>> On 2020-07-22 14:55, Johannes Berg wrote:
> >>>>> On Wed, 2020-07-22 at 14:27 +0200, Felix Fietkau wrote:
> >>>>>
> >>>>>> I'm considering testing a different approach (with mt76 =
initially):
> >>>>>> - Add a mac80211 rx function that puts processed skbs into a =
list
> >>>>>> instead of handing them to the network stack directly.
> >>>>>
> >>>>> Would this be *after* all the mac80211 processing, i.e. in place =
of the
> >>>>> rx-up-to-stack?
> >>>> Yes, it would run all the rx handlers normally and then put the
> >>>> resulting skbs into a list instead of calling netif_receive_skb =
or
> >>>> napi_gro_frags.
> >>>
> >>> Whatever came of this?  I realized I'm running Felix's patch since =
his mt76
> >>> driver needs it.  Any chance it will go upstream?
> >>
> >> If you're asking about $subject (moving NAPI/RX to a thread), this
> >> landed upstream recently:
> >> =
http://git.kernel.org/linus/adbb4fb028452b1b0488a1a7b66ab856cdf20715
> >>
> >> It needs a bit of coaxing to work on a WiFi driver (including: WiFi
> >> drivers tend to have a different netdev for NAPI than they expose =
to
> >> /sys/class/net/), but it's there.
> >>
> >> I'm not sure if people had something else in mind in the stuff =
you're
> >> quoting though.
> >
> > No, I got it confused with something Felix did:
> >
> > https://github.com/greearb/mt76/blob/master/patches/0001-net-add-
> support-for-threaded-NAPI-polling.patch
> >
> > Maybe the NAPI/RX to a thread thing superceded Felix's patch?
> Yes, it did and it's in linux-next already.
> I sent the following change to make mt76 use it:
> https://github.com/nbd168/wireless/commit/1d4ff31437e5aaa999bd7a

Hi Felix / Ben,

In case of ath10k (snoc based targets), we have a lot of processing in =
the NAPI context.
Even moving this to threaded NAPI is not helping much due to the load.

Breaking the tasks into multiple context (with the patch series I =
posted) is helping in improving the throughput.
With the current rx_thread based approach, the rx processing is broken =
into two parallel contexts
1) reaping the packets from the HW
2) processing these packets list and handing it over to mac80211 (and =
later to the network stack)

This is the primary reason for choosing the rx thread approach.

Thanks,
Rakesh.

>=20
> - Felix

