Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 946CA6D745
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 01:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbfGRX3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 19:29:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57158 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbfGRX33 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 19:29:29 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D0A7C1528C8AF;
        Thu, 18 Jul 2019 16:29:28 -0700 (PDT)
Date:   Thu, 18 Jul 2019 16:29:28 -0700 (PDT)
Message-Id: <20190718.162928.124906203979938369.davem@davemloft.net>
To:     cai@lca.pw
Cc:     morbo@google.com, ndesaulniers@google.com, jyknight@google.com,
        sathya.perla@broadcom.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        arnd@arndb.de, dhowells@redhat.com, hpa@zytor.com,
        netdev@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, natechancellor@gmail.com
Subject: Re: [PATCH] be2net: fix adapter->big_page_size miscaculation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <75B428FC-734C-4B15-B1A7-A3FC5F9F2FE5@lca.pw>
References: <CAKwvOdkCfqfpJYYX+iu2nLCUUkeDorDdVP3e7koB9NYsRwgCNw@mail.gmail.com>
        <CAGG=3QUvdwJs1wW1w+5Mord-qFLa=_WkjTsiZuwGfcjkoEJGNQ@mail.gmail.com>
        <75B428FC-734C-4B15-B1A7-A3FC5F9F2FE5@lca.pw>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 18 Jul 2019 16:29:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qian Cai <cai@lca.pw>
Date: Thu, 18 Jul 2019 19:26:47 -0400

> 
> 
>> On Jul 18, 2019, at 5:21 PM, Bill Wendling <morbo@google.com> wrote:
>> 
>> [My previous response was marked as spam...]
>> 
>> Top-of-tree clang says that it's const:
>> 
>> $ gcc a.c -O2 && ./a.out
>> a is a const.
>> 
>> $ clang a.c -O2 && ./a.out
>> a is a const.
> 
> 
> I used clang-7.0.1. So, this is getting worse where both GCC and clang will start to suffer the
> same problem.

Then rewrite the module parameter macros such that the non-constness
is evident to all compilers regardless of version.

That is the place to fix this, otherwise we will just be adding hacks
all over the place rather than in just one spot.

Thanks.
