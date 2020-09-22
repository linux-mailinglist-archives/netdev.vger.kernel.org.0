Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2BF4273A90
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 08:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729143AbgIVGQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 02:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728686AbgIVGQA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 02:16:00 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B29AFC061755
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 23:16:00 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 0EC91587431B5; Tue, 22 Sep 2020 08:15:59 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 0BB4960DAC6DE;
        Tue, 22 Sep 2020 08:15:59 +0200 (CEST)
Date:   Tue, 22 Sep 2020 08:15:59 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Stephen Hemminger <stephen@networkplumber.org>
cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] build: avoid make jobserver warnings
In-Reply-To: <20200921171907.23d18b15@hermes.lan>
Message-ID: <nycvar.YFH.7.78.908.2009220812330.10964@n3.vanv.qr>
References: <20200921232231.11543-1-jengelh@inai.de> <20200921171907.23d18b15@hermes.lan>
User-Agent: Alpine 2.23 (LSU 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tuesday 2020-09-22 02:19, Stephen Hemminger wrote:
>> I observe:
>> 
>> 	» make -j8 CCOPTS=-ggdb3
>> 	lib
>> 	make[1]: warning: -j8 forced in submake: resetting jobserver mode.
>> 	make[1]: Nothing to be done for 'all'.
>> 	ip
>> 	make[1]: warning: -j8 forced in submake: resetting jobserver mode.
>> 	    CC       ipntable.o
>> 
>> MFLAGS is a historic variable of some kind; removing it fixes the
>> jobserver issue.
>
>MFLAGS is a way to pass flags from original make into the sub-make.

MAKEFLAGS and MFLAGS are already exported by make (${MAKE} is magic
methinks), so they need no explicit passing. You can check this by
adding something like 'echo ${MAKEFLAGS}' to the lib/Makefile
libnetlink.a target and then invoking e.g. `make -r` from the
toplevel, and notice how -r shows up again in the submake.
