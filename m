Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5AD4859F3
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 07:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731054AbfHHFnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 01:43:31 -0400
Received: from outbound.smtp.vt.edu ([198.82.183.121]:60020 "EHLO
        omr2.cc.vt.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731022AbfHHFna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 01:43:30 -0400
Received: from mr3.cc.vt.edu (mr3.cc.vt.edu [IPv6:2607:b400:92:8500:0:7f:b804:6b0a])
        by omr2.cc.vt.edu (8.14.4/8.14.4) with ESMTP id x785hTZ6007801
        for <netdev@vger.kernel.org>; Thu, 8 Aug 2019 01:43:30 -0400
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
        by mr3.cc.vt.edu (8.14.7/8.14.7) with ESMTP id x785hOcV014747
        for <netdev@vger.kernel.org>; Thu, 8 Aug 2019 01:43:29 -0400
Received: by mail-qt1-f197.google.com with SMTP id l9so84280723qtu.12
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 22:43:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:mime-version:date
         :message-id;
        bh=c6yvSjRSPSPtd7WKVRhn/33mlt2UI1aeE4hr0QgnAWg=;
        b=s53ch8IEDAs8tZJvv5iJy4mBcYjNkMMrMMAmwdSiQz7p6W+hW99e5oRVE5GB1wCAsp
         2Yj54/pE/onn7eodt/hbCNz+0nkUk2ZhUmj75HP1QqzkXzb3j2a88klnsux5cFV4Z3Af
         l0uaFoWiNnG1zE+p8u6EZ7HveCrdcAFEMt/GvHhb7CcFf9l/LLMRdA9aYi0FMLeKMU5z
         7YMq6A8p3v+HEOkGy+Uv6NWD+OYYNUaMrk330A1jFSqkR+hQIve7u+QElhHD4yUFrZ3T
         /6bQXe5HezxmSdUzgvbO7UGfI1cJw6cI5uqH2CrGCWTB94AQmEEoJJcJPh+fL/bwmmYr
         IHWQ==
X-Gm-Message-State: APjAAAXW6DCKR/eJox6hvsp66jQ3a6EsOuKjLUekoP2VG9mMalaz0jep
        wt86C44GgPLF+C4QMOOZn5eLJnkEsgzwNw1numcBfYlIuF4BI7V1Pqs8hCyzNRhpsrUGU3Ct/gk
        lr84TUSg20eKj/FGyEaC0t6Lm1sQ=
X-Received: by 2002:a37:dcc7:: with SMTP id v190mr12012689qki.169.1565243004367;
        Wed, 07 Aug 2019 22:43:24 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzKldRnyI5SL9XuBns9hAd6WuyGhSYe29+X/2gQVf84YuCE8HdYQj3/BaWF8ziX92uInHbLyQ==
X-Received: by 2002:a37:dcc7:: with SMTP id v190mr12012675qki.169.1565243004139;
        Wed, 07 Aug 2019 22:43:24 -0700 (PDT)
Received: from turing-police ([2601:5c0:c001:4341::359])
        by smtp.gmail.com with ESMTPSA id h18sm36284621qkj.134.2019.08.07.22.43.22
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 07 Aug 2019 22:43:23 -0700 (PDT)
From:   "Valdis =?utf-8?Q?Kl=c4=93tnieks?=" <valdis.kletnieks@vt.edu>
X-Google-Original-From: "Valdis =?utf-8?Q?Kl=c4=93tnieks?=" <Valdis.Kletnieks@vt.edu>
X-Mailer: exmh version 2.9.0 11/07/2018 with nmh-1.7+dev
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net/netfilter/nf_nat_proto.c - make tables static
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date:   Thu, 08 Aug 2019 01:43:22 -0400
Message-ID: <55481.1565243002@turing-police>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sparse warns about two tables not being declared.

  CHECK   net/netfilter/nf_nat_proto.c
net/netfilter/nf_nat_proto.c:725:26: warning: symbol 'nf_nat_ipv4_ops' was not declared. Should it be static?
net/netfilter/nf_nat_proto.c:964:26: warning: symbol 'nf_nat_ipv6_ops' was not declared. Should it be static?

And in fact they can indeed be static.

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>

diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
index 7ac733ebd060..0a59c14b5177 100644
--- a/net/netfilter/nf_nat_proto.c
+++ b/net/netfilter/nf_nat_proto.c
@@ -722,7 +722,7 @@ nf_nat_ipv4_local_fn(void *priv, struct sk_buff *skb,
 	return ret;
 }
 
-const struct nf_hook_ops nf_nat_ipv4_ops[] = {
+static const struct nf_hook_ops nf_nat_ipv4_ops[] = {
 	/* Before packet filtering, change destination */
 	{
 		.hook		= nf_nat_ipv4_in,
@@ -961,7 +961,7 @@ nf_nat_ipv6_local_fn(void *priv, struct sk_buff *skb,
 	return ret;
 }
 
-const struct nf_hook_ops nf_nat_ipv6_ops[] = {
+static const struct nf_hook_ops nf_nat_ipv6_ops[] = {
 	/* Before packet filtering, change destination */
 	{
 		.hook		= nf_nat_ipv6_in,

