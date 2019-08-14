Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E59568D43B
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 15:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727558AbfHNNI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 09:08:58 -0400
Received: from mx.0dd.nl ([5.2.79.48]:33924 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725800AbfHNNI6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 09:08:58 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id DF9A65FA49;
        Wed, 14 Aug 2019 15:08:56 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key) header.d=vdorst.com header.i=@vdorst.com header.b="oSpMeUu1";
        dkim-atps=neutral
Received: from www (www.vdorst.com [192.168.2.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.vdorst.com (Postfix) with ESMTPSA id 958251D70740;
        Wed, 14 Aug 2019 15:08:56 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com 958251D70740
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1565788136;
        bh=rCkI1Ci3GvdZbWGszkVHAA9IspgxN9Ks7fBmasSUZus=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oSpMeUu1TDmNTautXoqLW1xI80hWC7AEBfpNIdM0Or1pj6/oBgxHh/uIWoeEJrjQh
         Cgl8lECyruHdQJGjvHrdm+rlO2mH9QsxXJ5Bm/1BcDcupE7zat5dptZ04yLzWa8hUI
         BT8Xyw/qnKOfJAtCL6RX94kIlKjUS/lt2UE3ONShdpA1QI5W+Glk9Sj5rj+RZUmYUV
         qgZFLjCmaILM+lwMk2JLlCNxRWF6DlQgjnmX9ZZhQwFD/NIj1l5MUlZB418Y9pLIBO
         lkpa8+7Yv52eFP6Antx0KaPpDHEh7F2skK9fuIcKipttXTuY660EFF1CmFnAP37zn2
         aHknJEmHKT7XA==
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1]) by
 www.vdorst.com (Horde Framework) with HTTPS; Wed, 14 Aug 2019 13:08:56 +0000
Date:   Wed, 14 Aug 2019 13:08:56 +0000
Message-ID: <20190814130856.Horde.wzHL8_VRawJ8NIIk--BD18e@www.vdorst.com>
From:   =?utf-8?b?UmVuw6k=?= van Dorst <opensource@vdorst.com>
To:     Stefan Roese <sr@denx.de>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        Sean Wang <sean.wang@mediatek.com>,
        John Crispin <john@phrozen.org>,
        Daniel Golle <daniel@makrotopia.org>
Subject: Re: [PATCH] net: ethernet: mediatek: Add MT7628/88 SoC support
References: <20190717125345.Horde.JcDE_nBChPFDDjEgIRfPSl3@www.vdorst.com>
 <a92d7207-80b2-e88d-d869-64c9758ef1da@denx.de>
 <20190814092621.Horde.epvj8zK96-aCiV70YB5Q7II@www.vdorst.com>
 <3ff9a0fc-f5ff-3798-4409-ed5b900e0b05@denx.de>
In-Reply-To: <3ff9a0fc-f5ff-3798-4409-ed5b900e0b05@denx.de>
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stefan,

Quoting Stefan Roese <sr@denx.de>:

> Hi Rene,
>
> On 14.08.19 11:26, René van Dorst wrote:

<snip>

>> Great, Thanks for addressing this issue.
>>
>> I hope we can collaborate to also support mt76x8 in my PHYLINK  
>> patches [0][1].
>> I am close to posting V2 of the patches but I am currently waiting on some
>> fiber modules to test the changes better.
>
> I do have a "hackish" DSA driver for the integrated switch (ESW) in my
> tree. If time permits, I'll work on upstreaming this one as well. And
> yes, hopefully we can collaborate on your PHYLINK work too.

It is not only the switch driver but also the Mediatek ethernet driver that is
converted to PHYLINK. So we have a conflict in each others work.

I don't no what the right way is to go but I was thinking about 2 options

1. Lets say your work goes in first. I rebase my patches on your changes.
    We collaborate to create an extra PHYLINK patch ontop of my work  
for your SOC.
2. My patches goes in first and you adapt your patches to that.

What do you think?

I have latest changes here [0].

Also my modules did arrive so I can test my changes.

> Thanks,
> Stefan

Greats,

René

[0]  
https://github.com/vDorst/linux-1/commits/net-next-phylink-upstream-mediatek

