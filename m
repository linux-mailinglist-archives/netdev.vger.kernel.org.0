Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13BF83EAFF8
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 08:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238662AbhHMGV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 02:21:56 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:32333 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238729AbhHMGVz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 02:21:55 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1628835689; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=4+iKR9+0/pW2ueWFGJTZDLwHoBAxyYuwkXX2P7R2ceY=;
 b=NPCcKvF2/XPdCxGO5qg9EWydmG6BFEQpBCNMvGphxTH+JD/FzTUFnvYbde2ZSYs8sFVIvLNs
 KL+Xr9Bdqh02U15kzOir0UFLBXIC2TT6AsshJnpzM2oPir4uhDoi/S1I5j+d63fl5PVR0dm4
 Bw0cMUOJGRPmSColp90hEDGfADM=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 61160f62b14e7e2ecb40bde9 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 13 Aug 2021 06:21:22
 GMT
Sender: subashab=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 90A1FC43460; Fri, 13 Aug 2021 06:21:22 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: subashab)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 189B4C433D3;
        Fri, 13 Aug 2021 06:21:21 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 13 Aug 2021 00:21:21 -0600
From:   subashab@codeaurora.org
To:     Daniele Palmas <dnlplm@gmail.com>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Cc:     Aleksander Morgado <aleksander@aleksander.es>,
        Network Development <netdev@vger.kernel.org>,
        Sean Tranchetti <stranche@codeaurora.org>
Subject: Re: RMNET QMAP data aggregation with size greater than 16384
In-Reply-To: <CAGRyCJEekOwNwdtzMoW7LYGzDDcaoDdc-n5L+rJ9LgfbckFzXQ@mail.gmail.com>
References: <CAAP7ucKuS9p_hkR5gMWiM984Hvt09iNQEt32tCFDCT5p0fqg4Q@mail.gmail.com>
 <c0e14605e9bc650aca26b8c3920e9aba@codeaurora.org>
 <CAAP7ucK7EeBPJHt9XFp7bd5cGXtH5w2VGgh3yD7OA9SYd5JkJw@mail.gmail.com>
 <77b850933d9af8ddbc21f5908ca0764d@codeaurora.org>
 <CAAP7ucJRbg58Yqcx-qFFUuu=_=3Ss1HE1ZW4XGrm0KsSXnwdmA@mail.gmail.com>
 <13972ac97ffe7a10fd85fe03dc84dc02@codeaurora.org>
 <87bl6aqrat.fsf@miraculix.mork.no>
 <CAAP7ucLDFPMG08syrcnKKrX-+MS4_-tpPzZSfMOD6_7G-zq4gQ@mail.gmail.com>
 <2c2d1204842f457bb0d0b2c4cd58847d@codeaurora.org>
 <87sfzlplr2.fsf@miraculix.mork.no>
 <394353d6f31303c64b0d26bc5268aca7@codeaurora.org>
 <CAGRyCJEekOwNwdtzMoW7LYGzDDcaoDdc-n5L+rJ9LgfbckFzXQ@mail.gmail.com>
Message-ID: <7aac9ee90376e4757e5f2ebc4948ebed@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Just an heads-up that when I proposed that urb size there were doubts
> about the value (see
> https://patchwork.ozlabs.org/project/netdev/patch/20200909091302.20992-1-dnlplm@gmail.com/#2523774
> and
> https://patchwork.ozlabs.org/project/netdev/patch/20200909091302.20992-1-dnlplm@gmail.com/#2523958):
> it is true that this time you are setting the size just when qmap is
> enabled, but I think that Carl's comment about low-cat chipsets could
> still apply.
> 
> Thanks,
> Daniele
> 

Thanks for bringing this up.

Looks like a tunable would be needed to satisfy all users.
Perhaps we can use 32k as default in mux and passthrough mode but allow 
for changes
there if needed through a sysfs.

--
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
Forum,
a Linux Foundation Collaborative Project
