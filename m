Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4F344D647
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 13:03:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233068AbhKKMF5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 11 Nov 2021 07:05:57 -0500
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:39363 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230358AbhKKMF4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 07:05:56 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-496-zNLbbm_ONsGnsxTgVhftdQ-1; Thu, 11 Nov 2021 07:03:02 -0500
X-MC-Unique: zNLbbm_ONsGnsxTgVhftdQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C3A8A1006AA1;
        Thu, 11 Nov 2021 12:03:01 +0000 (UTC)
Received: from hog.localdomain (unknown [10.39.192.210])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A14F41017CE3;
        Thu, 11 Nov 2021 12:03:00 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, Sabrina Dubroca <sd@queasysnail.net>
Subject: [RFC PATCH ipsec-next 0/6] xfrm: start adding netlink extack support
Date:   Thu, 11 Nov 2021 13:02:41 +0100
Message-Id: <cover.1636450303.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

XFRM states and policies are complex objects, and there are many
reasons why the kernel can reject userspace's request to create
one. This series makes it a bit clearer by providing extended ack
messages for policy creation.

A few other operations that reuse the same helper functions are also
getting partial extack support in this series. More patches will
follow to complete extack support, in particular for state creation.

Note: The policy->share attribute seems to be entirely ignored in the
kernel outside of checking its value in verify_newpolicy_info(). There
are some (very) old comments in copy_from_user_policy and
copy_to_user_policy suggesting that it should at least be copied
to/from userspace. I don't know what it was intended for.

Sabrina Dubroca (6):
  xfrm: propagate extack to all netlink doit handlers
  xfrm: add extack support to verify_newpolicy_info
  xfrm: add extack to verify_policy_dir
  xfrm: add extack to validate_tmpl
  xfrm: add extack to verify_policy_type
  xfrm: add extack to verify_sec_ctx_len

 net/xfrm/xfrm_user.c | 163 +++++++++++++++++++++++++++----------------
 1 file changed, 103 insertions(+), 60 deletions(-)

-- 
2.33.1

