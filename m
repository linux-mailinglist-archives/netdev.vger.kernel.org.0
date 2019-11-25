Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D65871092D0
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 18:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729109AbfKYR3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 12:29:19 -0500
Received: from a27-186.smtp-out.us-west-2.amazonses.com ([54.240.27.186]:57984
        "EHLO a27-186.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727149AbfKYR3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 12:29:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1574702957;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type;
        bh=YGxyjgeS8/AEtrpSlYcsQEiI9LqqetcZJg/UdNfHDUE=;
        b=RYVo7n7ytyfuBi/pUlNlr8F9BMqZOqfPfRcu7/UmkQGNthtf1VZF1FqC7sihTSM6
        17obVoRIRZV7Fnwp1BCiZNRQL+8OyT6nuRjUxRPghh0iszno31RENw27Sc6Ag5Vi1TV
        v+488+Dd4gMUCDeLigXTLV82NSjmvflke2aiA6QM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1574702957;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type:Feedback-ID;
        bh=YGxyjgeS8/AEtrpSlYcsQEiI9LqqetcZJg/UdNfHDUE=;
        b=EGuFiWp1prXFDB1RTt1O8Q3RgU6BLHOP6QDDNhSLQgXTe2xi0FPGCdm/AU+sm1Sl
        XgiVsG/1V4+bsb4X2pt5Ly6HDQcPjDWypacKAc2V6qGBb3Citg6v+9nXDSJqaLT2VOS
        MPeuTgzag34qhls01SztJgmN6GfX9/4hKQk1B2mg=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C8B86C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     Phong Tran <tranmanphong@gmail.com>, jakub.kicinski@netronome.com,
        davem@davemloft.net, luciano.coelho@intel.com,
        shahar.s.matityahu@intel.com, johannes.berg@intel.com,
        emmanuel.grumbach@intel.com, sara.sharon@intel.com,
        yhchuang@realtek.com, yuehaibing@huawei.com, pkshih@realtek.com,
        arend.vanspriel@broadcom.com, rafal@milecki.pl,
        franky.lin@broadcom.com, pieter-paul.giesberts@broadcom.com,
        p.figiel@camlintechnologies.com, Wright.Feng@cypress.com,
        keescook@chromium.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] drivers: net: b43legacy: Fix -Wcast-function-type
References: <20191125150215.29263-1-tranmanphong@gmail.com>
        <07e73c3b-b1fa-c389-c1c0-80b73e4c1774@lwfinger.net>
Date:   Mon, 25 Nov 2019 17:29:17 +0000
In-Reply-To: <07e73c3b-b1fa-c389-c1c0-80b73e4c1774@lwfinger.net> (Larry
        Finger's message of "Mon, 25 Nov 2019 11:26:31 -0600")
Message-ID: <0101016ea39c44f3-d94591a5-99e7-4b11-82ee-fd6f953c5db3-000000@us-west-2.amazonses.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-SES-Outgoing: 2019.11.25-54.240.27.186
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Larry Finger <Larry.Finger@lwfinger.net> writes:

> On 11/25/19 9:02 AM, Phong Tran wrote:
>> correct usage prototype of callback in tasklet_init().
>> Report by https://github.com/KSPP/linux/issues/20
>>
>> Signed-off-by: Phong Tran <tranmanphong@gmail.com>
>> ---
>
> This patch was submitted yesterday as "[PATCH 3/5] drivers: net:
> b43legacy: Fix -Wcast-function-type". Why was it submitted twice?

Jakub asked to split them:

https://patchwork.kernel.org/cover/11259087/

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
