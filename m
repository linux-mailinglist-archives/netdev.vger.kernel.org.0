Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3C692778E
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 09:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbfEWH6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 03:58:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47904 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725814AbfEWH6X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 03:58:23 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8AF6B308FBAF;
        Thu, 23 May 2019 07:58:23 +0000 (UTC)
Received: from localhost (ovpn-112-18.ams2.redhat.com [10.36.112.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E4E4068D3D;
        Thu, 23 May 2019 07:58:21 +0000 (UTC)
Date:   Thu, 23 May 2019 09:58:17 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net-next] selftests: pmtu: Simplify cleanup and
 namespace names
Message-ID: <20190523095817.45ca9cae@redhat.com>
In-Reply-To: <20190522191106.15789-1-dsahern@kernel.org>
References: <20190522191106.15789-1-dsahern@kernel.org>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Thu, 23 May 2019 07:58:23 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Wed, 22 May 2019 12:11:06 -0700
David Ahern <dsahern@kernel.org> wrote:

> From: David Ahern <dsahern@gmail.com>
> 
> The point of the pause-on-fail argument is to leave the setup as is after
> a test fails to allow a user to debug why it failed. Move the cleanup
> after posting the result to the user to make it so.
> 
> Random names for the namespaces are not user friendly when trying to
> debug a failure. Make them simpler and more direct for the tests. Run
> cleanup at the beginning to ensure they are cleaned up if they already
> exist.

The reasons for picking per-instance unique names were:

- one can run multiple instances of the script in parallel. I
  couldn't trigger any bug this way *so far*, though

- cleanup might fail because of e.g. device reference count leaks (this
  happened quite frequently in the past), which are anyway visible in
  kernel logs. Unique names avoid the need to reboot

Sure, it's a trade-off with usability, and I also see the value of
having fixed names, so I'm fine with this too. I just wanted to make
sure you considered these points.

By the way, the comment to nsname() (that I would keep, it's still
somewhat convenient) is now inconsistent.

-- 
Stefano
