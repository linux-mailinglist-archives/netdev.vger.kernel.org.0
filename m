Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4729B375D1F
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 00:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbhEFWTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 18:19:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:49824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230149AbhEFWTh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 May 2021 18:19:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B57AF610FB;
        Thu,  6 May 2021 22:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620339519;
        bh=moYcWiXkqsm4OEY0Y+ce0dc9XDnqWECoUMVjQ3vnMg4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lT8RObx207KMdC2wQvZeyAkfo4pLrAWa8YSyetB/KCcJsbJNuSVK/01umyeyv2G11
         5cK6kK8CVUMH1zN2fp6OL+LeqAHPrgDkXWvDFaIT0yBMW7LRKHSC9Qn0oyBOJBkPr1
         egXhkLFBvLLqeLoYqS04epJi2X+V2ehv6dtLaUMjNbYALLa+sZbGmOS+9ETEfXLsaL
         gk3Si3kFGlZgLxJpD8hZZ4+An9ljYQwweEqNZiwZW6E0nUXy1Fu+cS9YRK/EQVBvSE
         F3Pb5IR2YGPSXL3ylW5wocEJheg8GeC0pTYMTnKgOsCUDGKSM986Ecw0PW7oCNX+oU
         4jhuzlPk3aYmA==
Date:   Thu, 6 May 2021 15:18:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yannick Vignon <yannick.vignon@oss.nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Taehee Yoo <ap420073@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>, netdev@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        sebastien.laveze@oss.nxp.com,
        Yannick Vignon <yannick.vignon@nxp.com>
Subject: Re: [RFC PATCH net-next v1 0/2] Threaded NAPI configurability
Message-ID: <20210506151837.27373dc3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210506172021.7327-1-yannick.vignon@oss.nxp.com>
References: <20210506172021.7327-1-yannick.vignon@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  6 May 2021 19:20:19 +0200 Yannick Vignon wrote:
> The purpose of these 2 patches is to be able to configure the scheduling
> properties (e.g. affinity, priority...) of the NAPI threads more easily
> at run-time, based on the hardware queues each thread is handling.
> The main goal is really to expose which thread does what, as the current
> naming doesn't exactly make that clear.
> 
> Posting this as an RFC in case people have different opinions on how to
> do that.

WQ <-> CQ <-> irq <-> napi mapping needs an exhaustive netlink
interface. We've been saying this for a while. Neither hard coded
naming schemes nor one-off sysfs files are a great idea IMHO.
