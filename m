Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD0821254CE
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 22:36:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbfLRVgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 16:36:18 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:63693 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726561AbfLRVgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 16:36:17 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1576704977; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=jz1hBC1QzjAdrsTi63lO0dUhY3okgFOCKXlh3dYubsQ=;
 b=GOIzXdsXEYByLP/DJCBjp9dehasoE1yzhKpMnD6UFJ2XAsDREtjgHBWW6DpxxYl7i2FvVWJl
 X9oEwwyUNMEXr2GIWbtMqbTg3V9wnQH8P+qv+ehKmRKH2FgWO2Mkr7S0vIYaI7C3vCimkj8g
 mT5MOyqzofqgK/Y9I3s8e0HG/lU=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5dfa9bcb.7f32781c03e8-smtp-out-n03;
 Wed, 18 Dec 2019 21:36:11 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 33465C4479D; Wed, 18 Dec 2019 21:36:10 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: subashab)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CB754C43383;
        Wed, 18 Dec 2019 21:36:09 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 18 Dec 2019 14:36:09 -0700
From:   subashab@codeaurora.org
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     David Miller <davem@davemloft.net>, eric.dumazet@gmail.com,
        netdev@vger.kernel.org, mptcp@lists.01.org,
        netdev-owner@vger.kernel.org
Subject: Re: [PATCH net-next v3 07/11] tcp: Prevent coalesce/collapse when skb
 has MPTCP extensions
In-Reply-To: <alpine.OSX.2.21.1912181251550.32925@mjmartin-mac01.local>
References: <20191217203807.12579-1-mathew.j.martineau@linux.intel.com>
 <20191217203807.12579-8-mathew.j.martineau@linux.intel.com>
 <5fc0d4bd-5172-298d-6bbb-00f75c7c0dc9@gmail.com>
 <20191218.124510.1971632024371398726.davem@davemloft.net>
 <alpine.OSX.2.21.1912181251550.32925@mjmartin-mac01.local>
Message-ID: <6411d0366a6ec6a30f9dbf4117ea6d1f@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Ok, understood. Not every packet has this MPTCP extension data so
> coalescing was not always turned off, but given the importance of
> avoiding
> 
> this memory waste I'll confirm GRO behavior and work on maintaining
> coalesce/collapse with identical MPTCP extension data.
> 

Hi Mat

Are identical MPTCP extensions a common case?
AFAIK the data sequence number and the subflow sequence number change
per packet even in a single stream scenario.
