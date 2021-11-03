Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3FB4448BF
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 20:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbhKCTMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 15:12:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42075 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229697AbhKCTMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 15:12:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635966584;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=K3iqx2sQ8T8FfrcXU/i5/Azps3cwJXhaoIE9HPwPWOw=;
        b=Cv495KPzXRtjCRDZDB/csaR7DQfl9GpVn0x4EpZJWdoLMJJpbyid2LQtzGNg8+bJfvjx0g
        ntmfa/ojkztH7UEZRe6ZiMMVMjJIuSWy6bck+cGphsUFn8cMRLGE6ZQYekyf90wAgXfWcI
        YnylsJqvKGPJLgIgcrZzFNUVw6mCFiU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-435-gqBBPnk7O5eiRaOE52GNdQ-1; Wed, 03 Nov 2021 15:09:43 -0400
X-MC-Unique: gqBBPnk7O5eiRaOE52GNdQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CB56BBAF80;
        Wed,  3 Nov 2021 19:09:41 +0000 (UTC)
Received: from asgard.redhat.com (unknown [10.36.110.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BCA18197FC;
        Wed,  3 Nov 2021 19:09:39 +0000 (UTC)
Date:   Wed, 3 Nov 2021 20:09:36 +0100
From:   Eugene Syromiatnikov <esyr@redhat.com>
To:     Jeremy Kerr <jk@codeconstruct.com.au>,
        Matt Johnston <matt@codeconstruct.com.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 0/2] MCTP sockaddr padding check/initialisation
 fixup
Message-ID: <cover.1635965993.git.esyr@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

This pair of patches introduces checks for padding fields of struct
sockaddr_mctp/sockaddr_mctp_ext to ease their re-use for possible
extensions in the future;  as well as zeroing of these fields
in the respective sockaddr filling routines.  While the first commit
is definitely an ABI breakage, it is proposed in hopes that the change
is made soon enough (the interface appeared only in Linux 5.15)
to avoid affecting any existing user space.

Eugene Syromiatnikov (2):
  mctp: handle the struct sockaddr_mctp padding fields
  mctp: handle the struct sockaddr_mctp_ext padding field

 net/mctp/af_mctp.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

--
v2:
 - Fixed the style of logical continuations, as noted by Jakub Kicinski.
 - Changed "Complements:" to "Fixes:" in commit messages, as it seems
   that it is the only commit message tag checkpatch.pl recognises.

v1: https://lore.kernel.org/netdev/cover.1635788968.git.esyr@redhat.com/
-- 
2.1.4

