Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE5ECEA891
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 02:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbfJaBRt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 21:17:49 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:36572 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbfJaBRt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 21:17:49 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 23F9460863; Thu, 31 Oct 2019 01:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572484668;
        bh=xvX9FQAQf1Jsj+fz5Pnr9yzEbLlr9wOf9WoZOs0N+cA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KrC/swMA5PVeOVALC/ksHHKzjCUZBt3pmLovDoDBdVJZZd0I5vJPyIql6Xh/Lwet8
         SOVXJpBo5Y/uQ9wU9j8HDpuNArIcF4530i6cILuQYZpYZkpCg1qhenqRCrbm7oCHx6
         gGX6U3P8hxGuloA29l7m953sVTtjdYoDUNx5F3YQ=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id AD748602F0;
        Thu, 31 Oct 2019 01:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572484667;
        bh=xvX9FQAQf1Jsj+fz5Pnr9yzEbLlr9wOf9WoZOs0N+cA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ot6FQNs3+zm1w8OceUWe59dfB2CvUlbwqL9o9LMv4WJVuFUhjAHF0HVDtPi9UQm91
         4VrQw6HwQPy6xCPX5XSywETdP6TXs0bYcpuTqYsltXoxstG+mEcCxX+k+hNBaJLMSq
         ILKQwbj50sefKR7PfwVfkjDvMVea7eC+5aDJlXxw=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 30 Oct 2019 19:17:47 -0600
From:   Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Neal Cardwell <ncardwell@google.com>,
        Netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
Subject: Re: Crash when receiving FIN-ACK in TCP_FIN_WAIT1 state
In-Reply-To: <8d24cb15-7c55-523f-b783-49f18913d03f@gmail.com>
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
 <8d24cb15-7c55-523f-b783-49f18913d03f@gmail.com>
Message-ID: <5ee9ebbcb16af5292db11cfd8a9aec7a@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> What is this wqp_called exactly ?

This was just a debug to ensure that tcp_write_queue_purge()
was called. In case the same crash was seen with the patch,
this bit would atleast tell whether this function was invoked or not.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
