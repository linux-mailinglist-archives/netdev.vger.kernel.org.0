Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A140E188E31
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 20:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbgCQTnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 15:43:00 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:54205 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726847AbgCQTm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 15:42:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584474177;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=TLh7fxXRQ0dpTKGNzTwR3rofoc+DNuOkh1kniQaCX2c=;
        b=NKKaynpEaE8uqzZ75kCZn94mBE/C/Sv/W+TDWQntCfoc/UdGtJGVgcvjhKyGjQcAXCAGrs
        1yjuj4S28PItp7LnnOkYuuxNcQaOVYBDhkK55zw70jbciIPZMeEG3ks2TrHx1x6/+oEPee
        J5t3T1AhM+uOG34nu65TOIhfAXmooLk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-2XksrESOO-SPPeqVQnymNg-1; Tue, 17 Mar 2020 15:42:52 -0400
X-MC-Unique: 2XksrESOO-SPPeqVQnymNg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 22C14107B7D9;
        Tue, 17 Mar 2020 19:42:48 +0000 (UTC)
Received: from llong.com (ovpn-115-15.rdu2.redhat.com [10.10.115.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DF55910016EB;
        Tue, 17 Mar 2020 19:42:43 +0000 (UTC)
From:   Waiman Long <longman@redhat.com>
To:     David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     keyrings@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-integrity@vger.kernel.org, netdev@vger.kernel.org,
        linux-afs@lists.infradead.org, Sumit Garg <sumit.garg@linaro.org>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Eric Biggers <ebiggers@google.com>,
        Chris von Recklinghausen <crecklin@redhat.com>,
        Waiman Long <longman@redhat.com>
Subject: [PATCH v4 3/4] KEYS: Remove __user annotation from dns_resolver_read()
Date:   Tue, 17 Mar 2020 15:41:39 -0400
Message-Id: <20200317194140.6031-4-longman@redhat.com>
In-Reply-To: <20200317194140.6031-1-longman@redhat.com>
References: <20200317194140.6031-1-longman@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the keyctl_read_key() has been modified to use a temporary kernel
buffer to read out the key data instead of passing in the user-supplied
buffer directly, there is no need to use the __user annotation for
dns_resolver_read().

Signed-off-by: Waiman Long <longman@redhat.com>
---
 net/dns_resolver/dns_key.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dns_resolver/dns_key.c b/net/dns_resolver/dns_key.c
index 3e1a90669006..ad53eb31d40f 100644
--- a/net/dns_resolver/dns_key.c
+++ b/net/dns_resolver/dns_key.c
@@ -302,7 +302,7 @@ static void dns_resolver_describe(const struct key *key, struct seq_file *m)
  * - the key's semaphore is read-locked
  */
 static long dns_resolver_read(const struct key *key,
-			      char __user *buffer, size_t buflen)
+			      char *buffer, size_t buflen)
 {
 	int err = PTR_ERR(key->payload.data[dns_key_error]);
 
-- 
2.18.1

