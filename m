Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D482ADE110
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 01:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbfJTXPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 19:15:50 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:48930 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726565AbfJTXPu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 19:15:50 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id CED8E6032D; Sun, 20 Oct 2019 23:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571613349;
        bh=c64NO6vKDvjO0uVxCKEkz2cYaCyPkwDUeC+2lovbnmc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=opf4Bug1SY8v/fxODeHuE4w6+hUJRAXlBFcbiQgPPDOFGIC8t886p922K5a19sXKq
         OLX2ZDB2e/E8tTGflr23X6N9fRQV6gXaUokbzQCb1YkwHVe9/YoaN9wnLV3yaUz27e
         7cOGLgTDFdcecYyBAAK8swpwZ02+GCmIz/9GJUig=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 47564602DC;
        Sun, 20 Oct 2019 23:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571613349;
        bh=c64NO6vKDvjO0uVxCKEkz2cYaCyPkwDUeC+2lovbnmc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=opf4Bug1SY8v/fxODeHuE4w6+hUJRAXlBFcbiQgPPDOFGIC8t886p922K5a19sXKq
         OLX2ZDB2e/E8tTGflr23X6N9fRQV6gXaUokbzQCb1YkwHVe9/YoaN9wnLV3yaUz27e
         7cOGLgTDFdcecYyBAAK8swpwZ02+GCmIz/9GJUig=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 20 Oct 2019 17:15:49 -0600
From:   Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Netdev <netdev@vger.kernel.org>, Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: Crash when receiving FIN-ACK in TCP_FIN_WAIT1 state
In-Reply-To: <CADVnQynFeJCpv4irANd8O63ck0ewUq66EDSHHRKdv-zieGZ+UA@mail.gmail.com>
References: <68ad6fb82c0edfb788c7ce1a3bdc851b@codeaurora.org>
 <CADVnQynFeJCpv4irANd8O63ck0ewUq66EDSHHRKdv-zieGZ+UA@mail.gmail.com>
Message-ID: <f7a0507ce733dd722b1320622dfd1caa@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hmm. Random related thought while searching for a possible cause: I
> wonder if tcp_write_queue_purge() should clear tp->highest_sack (and
> possibly tp->sacked_out)? The tcp_write_queue_purge() code is careful
> to call  tcp_clear_all_retrans_hints(tcp_sk(sk)) and I would imagine
> that similar considerations would imply that we should clear at least
> tp->highest_sack?
> 
> neal

Hi Neal

If the socket is in FIN-WAIT1, does that mean that all the segments
corresponding to SACK blocks are sent and ACKed already?

tp->sacked_out is non zero in all these crashes (is the SACK information
possibly invalid or stale here?).

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
