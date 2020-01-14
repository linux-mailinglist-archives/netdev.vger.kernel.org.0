Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2AE13B54A
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 23:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728769AbgANWZc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 17:25:32 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:32747 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727102AbgANWZb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 17:25:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579040730;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fhOb3ZDUKVi/MfPVczaYvu6x5kxbozdWvRtuuACunbY=;
        b=QjRe55BY26l6FpUabdDytoJXYOtJaELhkLArMIhkxGZyIwc6UPXKIEA3EUVQX+oMS2guy9
        YvK3fiHZTNgB78fsL/EK0blovMP20oxnym3DVoqWCr8QW5qnoDSDzZH92kgX0hXbMEljZB
        RGcaLU6izIXtjCFU7IWuffJmwifenkc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-RFCFlmnFNymhiP8fGZXSaw-1; Tue, 14 Jan 2020 17:25:29 -0500
X-MC-Unique: RFCFlmnFNymhiP8fGZXSaw-1
Received: by mail-wr1-f72.google.com with SMTP id o6so7081929wrp.8
        for <netdev@vger.kernel.org>; Tue, 14 Jan 2020 14:25:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fhOb3ZDUKVi/MfPVczaYvu6x5kxbozdWvRtuuACunbY=;
        b=JF6jvshN4vl4Y+T1NsN+yL73+GgpH+JmpXYlVCa5Gg/XYw7zLf3AYz1U95XR1Hs6wb
         Ynuu6JNr+RX5NZzAyTf4bpem2KnN2ggZ2mFYEtgq+n7m6hSQC4OUcbsurr+17YPXAyCb
         EBh7psYhxmAA51jnrmRlemzR4/7S6j9RMKM4rbxG9ckmzGX6LO6a5ScpmYkNMs5GFRUP
         sunftf76w2zzpVK/iXoFAiU06lRHbi6+QtdxFWxsfLqTds5pFZJWo+RfJbmdoK/JLGkg
         m6UfupJfxIugeaq5jvbiwqGhWEhf7nUZ8Vqvd0H1gQVL5GmDDRfIJD4Hzo6KpLCJi+t7
         +vTg==
X-Gm-Message-State: APjAAAV4wLRvrXHd2Bsryg92MbjejPkNaS+PtZ4xbqeTggAucbnNBUmL
        Ua4akw0cIN9WHCI8xeML2ZfQdPbtK95l78Gejb0mjLp7CgEal1RU1IbxyA1qrsz9HRAG+nylzHx
        fcWWgN2VwOkzjkMj9
X-Received: by 2002:a5d:608e:: with SMTP id w14mr28334049wrt.256.1579040724526;
        Tue, 14 Jan 2020 14:25:24 -0800 (PST)
X-Google-Smtp-Source: APXvYqyizWEzvPT9J54nm+PKTvh2KnUWsddAFwC/VCfA/FsIeIxzeqY3/YRLyjrBccTCVWzpTyGgaA==
X-Received: by 2002:a5d:608e:: with SMTP id w14mr28334031wrt.256.1579040724301;
        Tue, 14 Jan 2020 14:25:24 -0800 (PST)
Received: from linux.home (2a01cb058a4e7100d3814d1912515f67.ipv6.abo.wanadoo.fr. [2a01:cb05:8a4e:7100:d381:4d19:1251:5f67])
        by smtp.gmail.com with ESMTPSA id k16sm22049632wru.0.2020.01.14.14.25.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2020 14:25:23 -0800 (PST)
Date:   Tue, 14 Jan 2020 23:25:22 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH net-next 1/2] netns: Parse NETNSA_FD and NETNSA_PID as signed
 integers
Message-ID: <0f37c946179b082bf1c5e34d2cfdd9223979ea83.1579040200.git.gnault@redhat.com>
References: <cover.1579040200.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1579040200.git.gnault@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These attributes represent signed values (file descriptors and PIDs).
Make that clear in nla_policy.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 net/core/net_namespace.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 6412c1fbfcb5..85c565571c1c 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -706,8 +706,8 @@ static struct pernet_operations __net_initdata net_ns_ops = {
 static const struct nla_policy rtnl_net_policy[NETNSA_MAX + 1] = {
 	[NETNSA_NONE]		= { .type = NLA_UNSPEC },
 	[NETNSA_NSID]		= { .type = NLA_S32 },
-	[NETNSA_PID]		= { .type = NLA_U32 },
-	[NETNSA_FD]		= { .type = NLA_U32 },
+	[NETNSA_PID]		= { .type = NLA_S32 },
+	[NETNSA_FD]		= { .type = NLA_S32 },
 	[NETNSA_TARGET_NSID]	= { .type = NLA_S32 },
 };
 
@@ -731,10 +731,10 @@ static int rtnl_net_newid(struct sk_buff *skb, struct nlmsghdr *nlh,
 	nsid = nla_get_s32(tb[NETNSA_NSID]);
 
 	if (tb[NETNSA_PID]) {
-		peer = get_net_ns_by_pid(nla_get_u32(tb[NETNSA_PID]));
+		peer = get_net_ns_by_pid(nla_get_s32(tb[NETNSA_PID]));
 		nla = tb[NETNSA_PID];
 	} else if (tb[NETNSA_FD]) {
-		peer = get_net_ns_by_fd(nla_get_u32(tb[NETNSA_FD]));
+		peer = get_net_ns_by_fd(nla_get_s32(tb[NETNSA_FD]));
 		nla = tb[NETNSA_FD];
 	} else {
 		NL_SET_ERR_MSG(extack, "Peer netns reference is missing");
@@ -874,10 +874,10 @@ static int rtnl_net_getid(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (err < 0)
 		return err;
 	if (tb[NETNSA_PID]) {
-		peer = get_net_ns_by_pid(nla_get_u32(tb[NETNSA_PID]));
+		peer = get_net_ns_by_pid(nla_get_s32(tb[NETNSA_PID]));
 		nla = tb[NETNSA_PID];
 	} else if (tb[NETNSA_FD]) {
-		peer = get_net_ns_by_fd(nla_get_u32(tb[NETNSA_FD]));
+		peer = get_net_ns_by_fd(nla_get_s32(tb[NETNSA_FD]));
 		nla = tb[NETNSA_FD];
 	} else if (tb[NETNSA_NSID]) {
 		peer = get_net_ns_by_id(net, nla_get_s32(tb[NETNSA_NSID]));
-- 
2.21.1

