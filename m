Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 390A62A28C
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 05:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbfEYDVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 23:21:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57716 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726425AbfEYDVu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 23:21:50 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 015C8308424C;
        Sat, 25 May 2019 03:21:50 +0000 (UTC)
Received: from Hades.local (dhcp-17-185.bos.redhat.com [10.18.17.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A4D13503EF;
        Sat, 25 May 2019 03:21:48 +0000 (UTC)
Subject: Re: [PATCH net] bonding/802.3ad: fix slave link initialization
 transition states
To:     =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS1?=
         =?UTF-8?B?4KS+4KSwKQ==?= <maheshb@google.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     linux-kernel@vger.kernel.org, Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-netdev <netdev@vger.kernel.org>,
        Heesoon Kim <Heesoon.Kim@stratus.com>
References: <20190524134928.16834-1-jarod@redhat.com>
 <30882.1558732616@famine>
 <CAF2d9jhGmsaOZsDWNFihsD4EuEVq9s0xwY22d+FuhBz=A2JpKA@mail.gmail.com>
From:   Jarod Wilson <jarod@redhat.com>
Message-ID: <ab368b61-226e-0353-6481-18a5e289419d@redhat.com>
Date:   Fri, 24 May 2019 23:21:47 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CAF2d9jhGmsaOZsDWNFihsD4EuEVq9s0xwY22d+FuhBz=A2JpKA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Sat, 25 May 2019 03:21:50 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/24/19 6:38 PM, Mahesh Bandewar (महेश बंडेवार) wrote:
> On Fri, May 24, 2019 at 2:17 PM Jay Vosburgh <jay.vosburgh@canonical.com> wrote:
>>
>> Jarod Wilson <jarod@redhat.com> wrote:
>>
>>> Once in a while, with just the right timing, 802.3ad slaves will fail to
>>> properly initialize, winding up in a weird state, with a partner system
>>> mac address of 00:00:00:00:00:00. This started happening after a fix to
>>> properly track link_failure_count tracking, where an 802.3ad slave that
>>> reported itself as link up in the miimon code, but wasn't able to get a
>>> valid speed/duplex, started getting set to BOND_LINK_FAIL instead of
>>> BOND_LINK_DOWN. That was the proper thing to do for the general "my link
>>> went down" case, but has created a link initialization race that can put
>>> the interface in this odd state.
>>
> Are there any notification consequences because of this change?

No, there shouldn't be, it just makes initial link-up cleaner, 
everything during runtime once the link is initialized should remain the 
same.

-- 
Jarod Wilson
jarod@redhat.com
