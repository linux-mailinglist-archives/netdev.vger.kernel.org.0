Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 472D0118F89
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 19:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbfLJSMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 13:12:40 -0500
Received: from a27-11.smtp-out.us-west-2.amazonses.com ([54.240.27.11]:38374
        "EHLO a27-11.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727603AbfLJSMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 13:12:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1576001559;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID;
        bh=PeuU04IX1bo3/KemWCk9u2DIVFl1r9dAF/cjfgh+P8U=;
        b=iyas+827JEOpVqaj3jR1Y9l6Sp7hNoq1Bl6WNGC9HeRFKArTClAJ8VIBBoc8JiEm
        8IDV7PYfaY6mM5RnvM+p7PvcOZAB9RB68ipr16sEhJcv/3npgFaugrWGeZE7Q1zZPO3
        uB18ivP2h+GxZ5XXU+bo6uhfdOixMozjXMs9+puc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1576001559;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID:Feedback-ID;
        bh=PeuU04IX1bo3/KemWCk9u2DIVFl1r9dAF/cjfgh+P8U=;
        b=EwHm+HemTo2WrWaoIbNfPuItclNJ21YFzu2q1ihxtlbZvOIv24t40pgatvjhmBKv
        T44lS9gpFEK1idK53WBs+u11piFdzAruQl8Q731Aep3Ja4qxTG02PfyUPE5dlEDCTi4
        AJjTOiFWgI4tzHfM2pY0+jc3tMOssrTJQYsT/hoY=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED
        autolearn=unavailable autolearn_force=no version=3.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 10 Dec 2019 18:12:39 +0000
From:   subashab@codeaurora.org
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Sean Tranchetti <stranche@codeaurora.org>,
        Eric Dumazet <edumazet@google.com>,
        Linux SCTP <linux-sctp@vger.kernel.org>
Subject: Re: [PATCH v2] net: introduce ip_local_unbindable_ports sysctl
In-Reply-To: <20191210091241.0c6df09e@cakuba.netronome.com>
References: <CAHo-OowKQPQj9UhjCND5SmTOergBXMHtEctJA_T0SKLO5yebSg@mail.gmail.com>
 <20191209224530.156283-1-zenczykowski@gmail.com>
 <20191209154216.7e19e0c0@cakuba.netronome.com>
 <CANP3RGe8zqa2V-PBjvACAJa2Hrd8z7BXUkks0KCrAtyeDjbsYw@mail.gmail.com>
 <20191209161835.7c455fc0@cakuba.netronome.com>
 <0101016eee9bf9b5-f5615781-f0a6-41c4-8e9d-ed694eccf07c-000000@us-west-2.amazonses.com>
 <20191210091241.0c6df09e@cakuba.netronome.com>
Message-ID: <0101016ef1035a6a-d3a8b345-600a-4e28-b3da-12fd2fac72d1-000000@us-west-2.amazonses.com>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
X-SES-Outgoing: 2019.12.10-54.240.27.11
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> It's a form of one, agreed, although let's be honest - someone reading
> the transparent proxy use case in the commit message will not think of
> a complex AP scenario, but rather of a locally configured transparent
> proxy with IPtables or sockets or such.

Transparent proxy could be implemented using eBPF + XDP and those don't
need sockets. However, in that case we do need to block those specific 
ports
to avoid messing with unrelated traffic.
