Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 235513E1F0E
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 00:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241760AbhHEW5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 18:57:34 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:46636 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231774AbhHEW5d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 18:57:33 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1628204238; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=+oiWRBEi29CxlfRL913uVrFZXuGYQNC+mqOWA5JBRk8=;
 b=Q+12luPo/JyDrX0jvP/ZFNHeCrMNWjAoi0yyGnG/cleb9S5KUpqdspxalhgkHTSfD1ulf8kO
 mNzPpYF7tpcenxu+plJUqEEnTmwgypm5H0jfzKegs3OWyX7kVoC38QMtOM+Tr1GxNy4cAP3Y
 cb5IM+IEWLQ5fFXblrqL4U3LHxI=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 610c6cbf041a739c4624c949 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 05 Aug 2021 22:57:03
 GMT
Sender: subashab=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 9AD76C43460; Thu,  5 Aug 2021 22:57:02 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: subashab)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E7B3DC433F1;
        Thu,  5 Aug 2021 22:57:00 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 05 Aug 2021 16:57:00 -0600
From:   subashab@codeaurora.org
To:     Aleksander Morgado <aleksander@aleksander.es>
Cc:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Daniele Palmas <dnlplm@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        stranche@codeaurora.org
Subject: Re: RMNET QMAP data aggregation with size greater than 16384
In-Reply-To: <CAAP7ucK7EeBPJHt9XFp7bd5cGXtH5w2VGgh3yD7OA9SYd5JkJw@mail.gmail.com>
References: <CAAP7ucKuS9p_hkR5gMWiM984Hvt09iNQEt32tCFDCT5p0fqg4Q@mail.gmail.com>
 <c0e14605e9bc650aca26b8c3920e9aba@codeaurora.org>
 <CAAP7ucK7EeBPJHt9XFp7bd5cGXtH5w2VGgh3yD7OA9SYd5JkJw@mail.gmail.com>
Message-ID: <77b850933d9af8ddbc21f5908ca0764d@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I may be mistaken then in how this should be setup when using rmnet.
> For the qmi_wwan case using add_mux/del_mux (Daniele correct me if
> wrong!), we do need to configure the MTU of the master interface to be
> equal to the aggregation data size reported via QMI WDA before
> creating any mux link; see
> http://paldan.altervista.org/linux-qmap-qmi_wwan-multiple-pdn-setup/
> 
> I ended up doing the same here for the rmnet case; but if it's not
> needed I can definitely change that. I do recall that I originally had
> left the master MTU untouched in the rmnet case and users had issues,
> and increasing it to the aggregation size solved that; I assume that's
> because the MTU should have been increased to accommodate the extra
> MAP header as you said. How much more size does it need on top of the
> 1500 bytes?

You need to use an additional 4 bytes for MAPv1 and 8 bytes for 
MAPv4/v5.

--
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
Forum,
a Linux Foundation Collaborative Project
