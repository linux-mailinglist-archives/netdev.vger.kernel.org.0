Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 547D53E3F91
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 08:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233095AbhHIGNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 02:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233018AbhHIGNR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 02:13:17 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D04C0613CF;
        Sun,  8 Aug 2021 23:12:57 -0700 (PDT)
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1628489575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/3NW6B5sTs1+9zEsjoZtRxYM/tR7SbDBK3k+Xfo1Di0=;
        b=mS/qsNH3n9HXTzHpjXxWUxHgdUmpUBwaYZxkfIakWrbHFVL7BnOUGmLMS/4Twq2hRgU4w7
        00Ii9iLS8432iBV8JFZecrBCJlgQdpmBcklkRE0R/MZZ9+SuLJCoJZoJH7wi6Ws2KHlAe2
        DfXK/J/RqcSgympSnC22hmUXRnvnaAw=
Date:   Mon, 09 Aug 2021 06:12:55 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   yajun.deng@linux.dev
Message-ID: <489e6f1ce9f8de6fd8765d82e1e47827@linux.dev>
Subject: Re: [PATCH net-next] net: sock: add the case if sk is NULL
To:     "Jakub Kicinski" <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20210806061136.54e6926e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210806061136.54e6926e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210806063815.21541-1-yajun.deng@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

August 6, 2021 9:11 PM, "Jakub Kicinski" <kuba@kernel.org> wrote:=0A=0A> =
On Fri, 6 Aug 2021 14:38:15 +0800 Yajun Deng wrote:=0A> =0A>> Add the cas=
e if sk is NULL in sock_{put, hold},=0A>> The caller is free to use it.=
=0A>> =0A>> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>=0A> =0A> The=
 obvious complaint about this patch (and your previous netdev patch)=0A> =
is that you're spraying branches everywhere in the code. Sure, it may=0A=
=0ASorry for that, I'll be more normative in later submission.=0A> be oka=
y for free(), given how expensive of an operation that is but=0A> is havi=
ng refcounting functions accept NULL really the best practice?=0A> =0A> C=
an you give us examples in the kernel where that's the case?=0A=0A0   inc=
lude/net/neighbour.h         neigh_clone()=0A1   include/linux/cgroup.h  =
        get_cgroup_ns() and put_cgroup_ns()  (This is very similar to my =
submission)=0A2   include/linux/ipc_namespace.h   get_ipc_ns()=0A3   incl=
ude/linux/posix_acl.h       posix_acl_dup()=0A4   include/linux/pid.h    =
         get_pid()=0A5   include/linux/user_namespace.h  get_user_ns()
