Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 929591D09E7
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 09:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729840AbgEMH1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 03:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728490AbgEMH1t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 03:27:49 -0400
Received: from forwardcorp1p.mail.yandex.net (forwardcorp1p.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b6:217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3B01C061A0C;
        Wed, 13 May 2020 00:27:48 -0700 (PDT)
Received: from mxbackcorp2j.mail.yandex.net (mxbackcorp2j.mail.yandex.net [IPv6:2a02:6b8:0:1619::119])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id E3AF62E1454;
        Wed, 13 May 2020 10:27:43 +0300 (MSK)
Received: from localhost (localhost [::1])
        by mxbackcorp2j.mail.yandex.net (mxbackcorp/Yandex) with ESMTP id KFpMUGJ3fY-RhXSFNkK;
        Wed, 13 May 2020 10:27:43 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1589354863; bh=fqTiNo7qgWHswfMQuWMsYkNbunOtZFsc+gVHEJqehuM=;
        h=Subject:In-Reply-To:Cc:Date:References:To:From:Message-Id;
        b=JWdpHWOZZIaiOXsS0PqNcPWXouB+6R7VLJw+CpzqnlvlBpv1KCr0rctlRYuF4Gur9
         0J5KL+MM0M5lDsGGVlQvj7ve3qxTh+bvHOrwiukVzOi+3uhOnbkIlQnNVpl3gjP2fV
         o6JLQjeikub1PL99IcjMO4mpe/rkBLlvdv5gyCQM=
Authentication-Results: mxbackcorp2j.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
X-Yandex-Sender-Uid: 1120000000093952
X-Yandex-Avir: 1
Received: from mxbackcorp1g.mail.yandex.net (localhost [::1])
        by mxbackcorp1g.mail.yandex.net with LMTP id SxxvUWXl5z-KQyWRy6P
        for <zeil@yandex-team.ru>; Wed, 13 May 2020 10:27:33 +0300
Received: by iva4-6d0ca09d92db.qloud-c.yandex.net with HTTP;
        Wed, 13 May 2020 10:27:32 +0300
From:   =?utf-8?B?0JTQvNC40YLRgNC40Lkg0K/QutGD0L3QuNC9?= 
        <zeil@yandex-team.ru>
To:     David Ahern <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>
In-Reply-To: <42814b4f-dc95-d246-47a4-2b8c46dd607e@gmail.com>
References: <20200509165202.17959-1-zeil@yandex-team.ru> <42814b4f-dc95-d246-47a4-2b8c46dd607e@gmail.com>
Subject: Re: [PATCH iproute2-next v2 1/3] ss: introduce cgroup2 cache and helper functions
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date:   Wed, 13 May 2020 10:27:42 +0300
Message-Id: <25511589354341@mail.yandex-team.ru>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=utf-8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



13.05.2020, 05:03, "David Ahern" <dsahern@gmail.com>:
> On 5/9/20 10:52 AM, Dmitry Yakunin wrote:
>>  This patch prepares infrastructure for matching sockets by cgroups.
>>  Two helper functions are added for transformation between cgroup v2 ID
>>  and pathname. Cgroup v2 cache is implemented as hash table indexed by ID.
>>  This cache is needed for faster lookups of socket cgroup.
>>
>>  v2:
>>    - style fixes (David Ahern)
>
> you missed my other comment about this set. Running this new command on
> a kernel without support should give the user a better error message
> than a string of Invalid arguments:
>
> $ uname -r
> 5.3.0-51-generic
>
> $ ss -a cgroup /sys/fs/cgroup/unified
> RTNETLINK answers: Invalid argument
> RTNETLINK answers: Invalid argument
> RTNETLINK answers: Invalid argument
> RTNETLINK answers: Invalid argument
> RTNETLINK answers: Invalid argument
> RTNETLINK answers: Invalid argument
> RTNETLINK answers: Invalid argument
> RTNETLINK answers: Invalid argument
> RTNETLINK answers: Invalid argument

No, i didn't miss your comment. This patchset was extended with the third patch which includes bytecode filter checking.
