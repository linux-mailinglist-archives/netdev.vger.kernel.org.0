Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99C7510DC34
	for <lists+netdev@lfdr.de>; Sat, 30 Nov 2019 03:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbfK3CvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Nov 2019 21:51:20 -0500
Received: from a27-11.smtp-out.us-west-2.amazonses.com ([54.240.27.11]:56352
        "EHLO a27-11.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727142AbfK3CvU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Nov 2019 21:51:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1575082279;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID;
        bh=rgnN/cHlY9yIEL0ptAF+Jq7dhmAxyr674IK0bFVsQaA=;
        b=Cso7yuV3yap/uH1YN559eN24nYpcOk10hVW6FFgr8Kl6MXZFqHkXHyVLxo0ECBJD
        4ObDq/0u5jlTQm28JsLX9PVtkl4Wklcyw3Rt80msQzpjQHu3uXc007VmeYCayx4LwEL
        lqWr1OwKWDd5UasxaWH4nLZ++XNv8tXwAb0vHkH4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1575082279;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID:Feedback-ID;
        bh=rgnN/cHlY9yIEL0ptAF+Jq7dhmAxyr674IK0bFVsQaA=;
        b=AyqRkJdC7Tx+rf5nHDC2UM+EoR3GaUbRLwQqeCiUURWxf2O50DlHDTV11DvUu0Gw
        SMuPpirR2V0LSSqoVCItUg5dM02dU+Q4e9TzLJilzfJhQDnfvyBQJlHd2tKV3N4U/C4
        cBfvAsWewNNqXxwLgQuA738bgoPoh4z17q8UjYlE=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED
        autolearn=unavailable autolearn_force=no version=3.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sat, 30 Nov 2019 02:51:19 +0000
From:   subashab@codeaurora.org
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Josh Hunt <johunt@akamai.com>
Cc:     Neal Cardwell <ncardwell@google.com>,
        Netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
Subject: Re: Crash when receiving FIN-ACK in TCP_FIN_WAIT1 state
In-Reply-To: <5a267a9d-2bf5-4978-b71d-0c8e71a64807@gmail.com>
References: <68ad6fb82c0edfb788c7ce1a3bdc851b@codeaurora.org>
 <CADVnQynFeJCpv4irANd8O63ck0ewUq66EDSHHRKdv-zieGZ+UA@mail.gmail.com>
 <f7a0507ce733dd722b1320622dfd1caa@codeaurora.org>
 <CADVnQy=SDgiFH57MUv5kNHSjD2Vsk+a-UD0yXQKGNGY-XLw5cw@mail.gmail.com>
 <2279a8988c3f37771dda5593b350d014@codeaurora.org>
 <CADVnQykjfjPNv6F1EtWWvBT0dZFgf1QPDdhNaCX3j3bFCkViwA@mail.gmail.com>
 <f9ae970c12616f61c6152ebe34019e2b@codeaurora.org>
 <CADVnQymqKpMh3iRfrdiAYjb+2ejKswk8vaZCY6EW4-3ppDnv_w@mail.gmail.com>
 <81ace6052228e12629f73724236ade63@codeaurora.org>
 <CADVnQymDSZb=K8R1Gv=RYDLawW9Ju1tuskkk8LZG4fm3yxyq3w@mail.gmail.com>
 <74827a046961422207515b1bb354101d@codeaurora.org>
 <827f0898-df46-0f05-980e-fffa5717641f@akamai.com>
 <cae50d97-5d19-7b35-0e82-630f905c1bf6@gmail.com>
 <5a267a9d-2bf5-4978-b71d-0c8e71a64807@gmail.com>
Message-ID: <0101016eba384308-7dd6b335-8b75-4890-8733-a4dde8064d11-000000@us-west-2.amazonses.com>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
X-SES-Outgoing: 2019.11.30-54.240.27.11
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>>> Since tcp_write_queue_purge() calls tcp_rtx_queue_purge() and we're 
>>> deleting everything in the retrans queue there, doesn't it make sense 
>>> to zero out all of those associated counters? Obviously clearing 
>>> sacked_out is helping here, but is there a reason to keep track of 
>>> lost_out, retrans_out, etc if retrans queue is now empty? Maybe 
>>> calling tcp_clear_retrans() from tcp_rtx_queue_purge() ?
>> 
>> First, I would like to understand if we hit this problem on current 
>> upstream kernels.
>> 
>> Maybe a backport forgot a dependency.
>> 
>> tcp_write_queue_purge() calls tcp_clear_all_retrans_hints(), not 
>> tcp_clear_retrans(),
>> this is probably for a reason.
>> 
>> Brute force clearing these fields might hide a serious bug.
>> 
> 
> I guess we are all too busy to get more understanding on this :/

Our test devices are on 4.19.x and it is not possible to switch to a 
newer
version. Perhaps Josh has seen this on a newer kernel.
