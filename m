Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D17C10932A
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 18:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729242AbfKYR4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 12:56:04 -0500
Received: from a27-11.smtp-out.us-west-2.amazonses.com ([54.240.27.11]:53792
        "EHLO a27-11.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725823AbfKYR4E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 12:56:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1574704563;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type;
        bh=IrTYOqMqEOxm64GeOhR8U6dXnIpA0jutoDa4mZ0DD3k=;
        b=Rw8lPNsipmCaUViAQtvN0xjhd9Tica/Ps+4FAvItNFhKPy1+T60FDFKkDny+Cin5
        BwdRDWH3NphC+KI96IBiBcNNra3R5EJo31mOtlJyDq4F8TgyDgZDMBppoK5cmOtVFr4
        73QbtYLZ+YF5NYmIH3omYUjMoZMZMjRwSGVfiG/0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1574704563;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type:Feedback-ID;
        bh=IrTYOqMqEOxm64GeOhR8U6dXnIpA0jutoDa4mZ0DD3k=;
        b=R1A2l2zQbt8Yay4Sc1/PrD+T1iWZc74BW6q8s4B91JS/8Pe6fQQEwaOMOd12Ay5k
        F83QwYvYWOXblkjis5lXTX0CT0J5/ZnrfCiGkZvpvJDIghpd6Pc+XrQ6usvN6mtmxSx
        TXEyhdZzLl6S9xZzXoVOYLt+AZm3HQ2ATf62yGvQ=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 33D0FC433CB
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
Subject: Re: [PATCH 2/3] drivers: net: intel: Fix -Wcast-function-type
References: <20191125150215.29263-1-tranmanphong@gmail.com>
        <20191125150215.29263-2-tranmanphong@gmail.com>
        <61fa4ef5-e4fc-c20c-9e20-158bcdf61cbb@lwfinger.net>
Date:   Mon, 25 Nov 2019 17:56:03 +0000
In-Reply-To: <61fa4ef5-e4fc-c20c-9e20-158bcdf61cbb@lwfinger.net> (Larry
        Finger's message of "Mon, 25 Nov 2019 11:30:47 -0600")
Message-ID: <0101016ea3b4c45e-39ce3a65-7fba-4bf6-a788-ba579c1ea122-000000@us-west-2.amazonses.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-SES-Outgoing: 2019.11.25-54.240.27.11
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
>>   drivers/net/wireless/intel/ipw2x00/ipw2100.c   | 7 ++++---
>>   drivers/net/wireless/intel/ipw2x00/ipw2200.c   | 5 +++--
>>   drivers/net/wireless/intel/iwlegacy/3945-mac.c | 5 +++--
>>   drivers/net/wireless/intel/iwlegacy/4965-mac.c | 5 +++--
>>   4 files changed, 13 insertions(+), 9 deletions(-)
>
> This patch is "fixing" three different drivers and should be split
> into at least two parts. To be consistent with previous practices, the
> subject for the two should be "intel: ipw2100: ...." and "intel:
> iwlegacy: ...."

Actually, please drop even "intel:". So "ipw2x00: " and "iwlegacy: " is
enough.


-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
