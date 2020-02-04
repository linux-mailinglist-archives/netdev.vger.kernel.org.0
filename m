Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75E681518E5
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 11:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgBDKfU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 05:35:20 -0500
Received: from mx2.suse.de ([195.135.220.15]:49090 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726364AbgBDKfU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Feb 2020 05:35:20 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 00132AAC2;
        Tue,  4 Feb 2020 10:35:17 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Tue, 04 Feb 2020 11:35:16 +0100
From:   Roman Penyaev <rpenyaev@suse.de>
To:     =?UTF-8?Q?Max_Neunh=C3=B6ffer?= <max@arangodb.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Christopher Kohlhoff <chris.kohlhoff@clearpool.io>,
        lars@arangodb.com
Subject: Re: epoll_wait misses edge-triggered eventfd events: bug in Linux 5.3
 and 5.4
In-Reply-To: <F0CB2FAC-A6F7-4B72-BC27-413DCF35E256@arangodb.com>
References: <20200131135730.ezwtgxddjpuczpwy@tux>
 <20200201121647.62914697@cakuba.hsd1.ca.comcast.net>
 <20200203151536.caf6n4b2ymvtssmh@tux>
 <5a16db1f2983ab105b99121ce0737d11@suse.de>
 <F0CB2FAC-A6F7-4B72-BC27-413DCF35E256@arangodb.com>
Message-ID: <d4d188512ea84f243310dd9464922a82@suse.de>
X-Sender: rpenyaev@suse.de
User-Agent: Roundcube Webmail
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-02-03 22:03, Max Neunhöffer wrote:
> Hi Roman,
> 
> Thanks for your quick response. This sounds fantastic!
> 
> The epollbug.c program was originally written by my colleague Lars
> Maier and then modified by me and subsequently by Chris Kohlhoff. Note
> that the bugzilla bug report contains altogether three variants which
> test epoll_wait/epoll_ctl in three different ways. It might be
> sensible to take all three variants for the test suite.

I checked 3 variants, they do same things: epoll_ctl() races against
epoll_wait(), and this is exactly the bug reproduction, regardless
actual read() from a file descriptor or EPOLLET flag set.

> I cannot imagine that any of the three authors would object to this, I
> definitely do not, the other two are on Cc in this email and can speak
> for themselves.

I adapted the logic from epollbug.c and included it into 
epoll_wakeup_test.c
test suite, you should have received the email: "[PATCH 3/3] kselftest:
introduce new epoll test case".  Please, take a look or ask your 
colleague
to take a look. If no objections - then fine, leave as is.

Thanks.

--
Roman

