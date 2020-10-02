Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F73C281EA7
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 00:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725768AbgJBWxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 18:53:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbgJBWxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 18:53:14 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D363C0613D0;
        Fri,  2 Oct 2020 15:53:14 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E48B911E4981C;
        Fri,  2 Oct 2020 15:36:25 -0700 (PDT)
Date:   Fri, 02 Oct 2020 15:53:12 -0700 (PDT)
Message-Id: <20201002.155312.133560326274339745.davem@davemloft.net>
To:     stephen@networkplumber.org
Cc:     jarod@redhat.com, linux-kernel@vger.kernel.org,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        kuba@kernel.org, tadavis@lbl.gov, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 6/6] bonding: make Kconfig toggle to
 disable legacy interfaces
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201002121317.474c95f0@hermes.local>
References: <20201002174001.3012643-1-jarod@redhat.com>
        <20201002174001.3012643-7-jarod@redhat.com>
        <20201002121317.474c95f0@hermes.local>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 02 Oct 2020 15:36:26 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Hemminger <stephen@networkplumber.org>
Date: Fri, 2 Oct 2020 12:13:17 -0700

> On Fri,  2 Oct 2020 13:40:01 -0400
> Jarod Wilson <jarod@redhat.com> wrote:
> 
>> By default, enable retaining all user-facing API that includes the use of
>> master and slave, but add a Kconfig knob that allows those that wish to
>> remove it entirely do so in one shot.
> 
> This is problematic. You are printing both old and new values.
> Also every distribution will have to enable it.
> 
> This looks like too much of change to users.

Agreed, no Kconfig knob.

Keep everything during the deprecation period, then you can kill off
the old names at the end of the deprecation period.

I don't want to create a situation where distribution X lists as a
"feature" that they are able to enable this Kconfig value even though
it breaks UAPI for legacy external code out there.

That's the wrong way to go about this and creates the wrong incentive
system.

I also agree that you can't change the docs to stop mentioning the old
names.  It's almost like we are pretending we aren't doing the
transition and that only the new names matter.  The old names matter
and must therefore be acknowledged, exist, and be referencable in the
documentation until the end of the deprecation period.  You can mark
them "(DEPRECATED)" or similar, but they can't be removed just yet.

Thank you.
