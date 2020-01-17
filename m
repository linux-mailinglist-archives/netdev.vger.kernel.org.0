Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 012B2140B4B
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 14:45:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbgAQNoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 08:44:06 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45481 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726752AbgAQNoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 08:44:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579268645;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=snDQstAj42jtMtoDqSt/QDcFelJMyaziDn2qIbHISRI=;
        b=Mzbxgt4vYsVCEi59xaZiRfE5+toxgIiqNMRuLJImWdM5yj+evc5sBYNYTyD0dzqV+5x/o+
        gjsrbcSo92oDMDc0gXfjhjZOOfRe/SQVK811IYO5yGr1IziZnoIv+cPA+ke3kOWJ80ao6G
        Ak0mDan19BaCJ32E2Dqx9UB1eLhfE/s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-38-RCfq0exQNKKmCZ0U_0GiTA-1; Fri, 17 Jan 2020 08:44:03 -0500
X-MC-Unique: RCfq0exQNKKmCZ0U_0GiTA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 38F058D6502
        for <netdev@vger.kernel.org>; Fri, 17 Jan 2020 13:44:01 +0000 (UTC)
Received: from lap.dom.ain (dhcp-24-164.fab.redhat.com [10.33.24.164])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DF7D280895
        for <netdev@vger.kernel.org>; Fri, 17 Jan 2020 13:44:00 +0000 (UTC)
Subject: Re: [PATCH net-next v3] openvswitch: add TTL decrement action
To:     netdev@vger.kernel.org
References: <20200115164030.56045-1-mcroce@redhat.com>
From:   Jeremy Harris <jgh@redhat.com>
Autocrypt: addr=jgh@redhat.com; prefer-encrypt=mutual; keydata=
 mQENBFWABsQBCADTFfb9EHGGiDel/iFzU0ag1RuoHfL/09z1y7iQlLynOAQTRRNwCWezmqpD
 p6zDFOf1Ldp0EdEQtUXva5g2lm3o56o+mnXrEQr11uZIcsfGIck7yV/y/17I7ApgXMPg/mcj
 ifOTM9C7+Ptghf3jUhj4ErYMFQLelBGEZZifnnAoHLOEAH70DENCI08PfYRRG6lZDB09nPW7
 vVG8RbRUWjQyxQUWwXuq4gQohSFDqF4NE8zDHE/DgPJ/yFy+wFr2ab90DsE7vOYb42y95keK
 tTBp98/Y7/2xbzi8EYrXC+291dwZELMHnYLF5sO/fDcrDdwrde2cbZ+wtpJwtSYPNvVxABEB
 AAG0HkplcmVteSBIYXJyaXMgPGpnaEByZWRoYXQuY29tPokBTgQTAQgAOBYhBKmG86a9Y3fY
 cwlY3rzljIzkHzLfBQJeFjLkAhsDBQsJCAcCBhUKCQgLAgQWAgMBAh4BAheAAAoJELzljIzk
 HzLfAa8IAMbrIA28i3/L3+Wl24vNnO01kM5vgvC+4EFMop2ChBcGF8xJpTHB9Iwrq+oyRhgU
 BH6Z9c7jRivEmre+vA5G12im0bgGXZug8Qr62Eufn+YseX51Mdb0ryRX94jniAheN/CUBZNS
 pQQUUrwywABlD52LhCYQjjeUCS+FWoveQUQqMfH5H56vF61jP9frdza7NjEwHBJhhly0eL70
 inub88WdHoGyqsa87oqr2hgwhkF90I2RBJijIZmOtbPds+CbiRsaEh//d5n9vZyH6abnfmRh
 pxlzt3a8OPFI820X4YrF+o7vnRxza2Xg/sVkIUvU0wUQKqpQ3qxVUsRtkVamqyS5AQ0EVYAG
 xAEIAOmEsdopOhG5H8TtMd6sGIKMNq3AJoRM4o5NjbNEFClpDfan8XZcgYtLwJzbv6CtlIpD
 plfRk3js74AXIUcXwMf3QhdkWklHdFvzOBdPyOctfTwMzfV4QJkedHMWEaU6arpYBSWoHcYo
 I9QJjZzh5NFfKhcu15PGtcJiiPjnL9ia+VmuWicE2M8EDIeI78s3P5Xt9m02w3s39caucttx
 018135IPUQ2ZssnxG/LKbGC5PIH+Rr0l2MccihAQnovXroHeGF8Iem3yILQY9mS2L0gyXQ2g
 nTb2MmbcmrWoRx4QGfkflAwafoWrriJfBOw7VMw1TClbHymO9XvBUjGMjxkAEQEAAYkBHwQY
 AQIACQUCVYAGxAIbDAAKCRC85YyM5B8y303oB/wJLYJOsxAV2GQYS0FeYviJ8PxQcWQFEEaY
 zxkvZ9ZQFNldPyat1Ew4rq1w+cpZoK9a8qvSSe33vSP8PICAWYfyGA6LfJy2KAV5xUOOOKUB
 4IkyrfyzW1gpiIsNsF0da12QD24dnCreV93dDFwQQ7dBqZAX507uHyAA5eUb6mjzseb4TTDP
 izAgHz5LfsnOvH267QtIUN8kJMr5MgoZrlSfwvE/HKr1aec0OHvbMrsGJGJ2T+zjQpw2h3zc
 0zgef+xsZ/ItryxLQXcwTRL6hxIw6K79kcc6LCktg1vBMnuy1nEayuC5Z5P0/5qbFsD9iUr3
 kt52y3C835Zwdnt374Cu
Message-ID: <f3c001e1-8963-536d-4158-3ce16ad5de69@redhat.com>
Date:   Fri, 17 Jan 2020 13:43:59 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200115164030.56045-1-mcroce@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/01/2020 16:40, Matteo Croce wrote:
> New action to decrement TTL instead of setting it to a fixed value.
> This action will decrement the TTL and, in case of expired TTL, drop it
> or execute an action passed via a nested attribute.
> The default TTL expired action is to drop the packet.

On drop, will it emit an ICMP?
-- 
Cheers,
  Jeremy

