Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE3293FC2FF
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 08:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238470AbhHaGul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 02:50:41 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:11451 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238062AbhHaGuk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 02:50:40 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1630392585; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=89LNhb/AkuU7G1W1T3OrP3YeHtcd/PEwZicaCEUM8BI=; b=cAejUQb8u14fI3vPA5kiSD53DrVOH7wB7WZSh8EtH7gLf/B8s/CPKRipPvDXEUXENFn3S3GR
 pGDXk7CwE77WFTR70IQHZAdim/FvPTUY2h5ESiThKUHzCHLFMzQZj1pQU9S8zjN7NNKkbrGd
 3hl8iiBllALQOK67z3efr5SpoD0=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 612dd0f089cdb620616e1173 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 31 Aug 2021 06:49:20
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 88E11C43618; Tue, 31 Aug 2021 06:49:20 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0A126C4338F;
        Tue, 31 Aug 2021 06:49:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 0A126C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     "Coelho\, Luciano" <luciano.coelho@intel.com>
Cc:     "jmforbes\@linuxtx.org" <jmforbes@linuxtx.org>,
        "yj99.shin\@samsung.com" <yj99.shin@samsung.com>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "Berg\, Johannes" <johannes.berg@intel.com>,
        "Baruch\, Yaara" <yaara.baruch@intel.com>,
        "ihab.zhaika\@intel.com" <ihab.zhaika@intel.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kuba\@kernel.org" <kuba@kernel.org>,
        "Gottlieb\, Matti" <matti.gottlieb@intel.com>,
        "Grumbach\, Emmanuel" <emmanuel.grumbach@intel.com>,
        "jh80.chung\@samsung.com" <jh80.chung@samsung.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] iwlwifi Add support for ax201 in Samsung Galaxy Book Flex2 Alpha
References: <20210702223155.1981510-1-jforbes@fedoraproject.org>
        <CGME20210709173244epcas1p3ea6488202595e182d45f59fcba695e0a@epcas1p3.samsung.com>
        <CAFxkdApGUeGdg4=rH=iC2SK58FO6yzbFiq3uSFMFTyZsDQ5j5w@mail.gmail.com>
        <8c55c7c9-a5ae-3b0e-8a0f-8954a8da7e7b@samsung.com>
        <94edb3c4-43a6-1031-8431-2befb0eca2bf@samsung.com>
        <87ilzyudk0.fsf@codeaurora.org>
        <CAFxkdArjsp4YxYWYZ_qW7UsNobzodKOaNJqKTHpPf5RmtT+Rww@mail.gmail.com>
        <ddcb88a3f6614ef6138b68375a22fbba1b068ff3.camel@intel.com>
Date:   Tue, 31 Aug 2021 09:49:13 +0300
In-Reply-To: <ddcb88a3f6614ef6138b68375a22fbba1b068ff3.camel@intel.com>
        (Luciano Coelho's message of "Tue, 31 Aug 2021 06:36:15 +0000")
Message-ID: <87wno22jo6.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Coelho, Luciano" <luciano.coelho@intel.com> writes:

> On Wed, 2021-08-25 at 13:07 -0500, Justin Forbes wrote:
>> On Sat, Aug 21, 2021 at 8:34 AM Kalle Valo <kvalo@codeaurora.org> wrote:
>> > 
>> > Jaehoon Chung <jh80.chung@samsung.com> writes:
>> > 
>> > > Hi
>> > > 
>> > > On 8/9/21 8:09 AM, Jaehoon Chung wrote:
>> > > > Hi
>> > > > 
>> > > > On 7/10/21 2:32 AM, Justin Forbes wrote:
>> > > > > On Fri, Jul 2, 2021 at 5:32 PM Justin M. Forbes
>> > > > > <jforbes@fedoraproject.org> wrote:
>> > > > > > 
>> > > > > > The Samsung Galaxy Book Flex2 Alpha uses an ax201 with the ID a0f0/6074.
>> > > > > > This works fine with the existing driver once it knows to claim it.
>> > > > > > Simple patch to add the device.
>> > > > > > 
>> > > > > > Signed-off-by: Justin M. Forbes <jforbes@fedoraproject.org>
>> > > 
>> > > If this patch is merged, can this patch be also applied on stable tree?
>> > 
>> > Luca, what should we do with this patch?
>> > 
>> > --
>> > https://patchwork.kernel.org/project/linux-wireless/list/
>> > 
>> > https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
>> 
>> 
>> Is that to imply that there is an issue with the submission?  Happy to
>> fix any problems, but it would nice to get this in soon.  I know the
>> 5.14 merge window was already opened when I sent it, but the 5.15 MR
>> is opening soon.  Hardware is definitely shipping and in users hands.
>
> Sorry for the delay here.  This fell between the cracks.
>
> Kalle can you apply this directly to your tree? I'll assign it to you.

Ok, I'll queue this to v5.15.

> And, if possible, add the cc-stable tag so it gets picked up. :)

Ok.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
