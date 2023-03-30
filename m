Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 856256CFBD0
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 08:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbjC3Gph (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 02:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjC3Gpg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 02:45:36 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2381855AA
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 23:45:23 -0700 (PDT)
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id E48BB3F236
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 06:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1680158716;
        bh=eftD3dmnNwFBwTmBDsmqihY2E6nG3qiDoQJcGHY96UE=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=C/f3XQaqwtcV2NcoW7M/gPgpps6kjgjbnYVNsiaPvKu1m3KvQrAT/tEsqj7QO7gzZ
         IvW3n+Kbxktk/ecGxiAPDr1Iu/hJ6pO665Sz007To7LbgeIiawRYKSJKtpYYzKSyoB
         2DeKyPES9A8MMcH8aCeItl6RJhKPgfuFjo8Gt9PbwxqYIF8zTKtmHeE3XRztw0SNle
         dg7NbATmN4FtPrqkEwYV95cvQI8hU1PimE6Bk6PMTLGudl+eti7Fcf4Q7XlnbGDAmZ
         rO4B75hwrnsXQjua3bdUJvtXsYw3+VHuYMD1DJ2EOUhHk+MRNdL0V+Geqc1dFkB9xU
         rYOokVgTgWS7w==
Received: by mail-ed1-f71.google.com with SMTP id t26-20020a50d71a000000b005003c5087caso25457023edi.1
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 23:45:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680158716; x=1682750716;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eftD3dmnNwFBwTmBDsmqihY2E6nG3qiDoQJcGHY96UE=;
        b=LVIBDh88SX5PeUP2GUUNMR4HR4ySZGmdsxcVKfTQqLs6ZAMWK/wxALn14Jdi5Eubpl
         vyzYKEwRqvqzGTeMCCZRtmCp0PKbP4CzrZkuhvu9P7GFpnvdUrzHZc15uhG8Yf8Q3rBp
         Rhq4ECfh4qC4393WAprVuBxkJXvWU8oXuaTwdSH+HYdExzZOTpsILoFlNYUScebIQc+8
         6vRCAdQTvMxYkMFDb6xnb8hQq7exyB12n6O813HpDRVvGx/T1dPNU54C6W8j4m0lkzS6
         wiUyLzdpmkHfA++rKKU01y8e+XVzJ2A8OK5MLm9fCoEqtxmaoSJHqGcahK1v04LtfMJ5
         CrgQ==
X-Gm-Message-State: AAQBX9ceM3clqfQ3i6Fga4uBq2NlL2uHTvZwlWbEs4LDSrBUuHWdMt9J
        ZIV+hLG8evjocRVdb6ORpO72Ma8GMkGRaH2fFoKGPPy+6rT0zvrJ9mFpA5GmeqYyJAnHIcH2/BN
        rTuYEFnRyewlKqA7TwGUb6nOeVPwBvCDQdWLuOGmrug==
X-Received: by 2002:a17:906:ca4a:b0:92b:e330:a79e with SMTP id jx10-20020a170906ca4a00b0092be330a79emr5319828ejb.29.1680158716470;
        Wed, 29 Mar 2023 23:45:16 -0700 (PDT)
X-Google-Smtp-Source: AKy350aySfCTmBIObUPn9E4fSuQ33rPMkemNREfZQNbI+2Rs3eXHnxXvUVit1AAXDrhIDeV64cDQ1A==
X-Received: by 2002:a17:906:ca4a:b0:92b:e330:a79e with SMTP id jx10-20020a170906ca4a00b0092be330a79emr5319810ejb.29.1680158716195;
        Wed, 29 Mar 2023 23:45:16 -0700 (PDT)
Received: from localhost (host-79-33-132-140.retail.telecomitalia.it. [79.33.132.140])
        by smtp.gmail.com with ESMTPSA id xe12-20020a170907318c00b00946c5da4d32sm2693466ejb.40.2023.03.29.23.45.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 23:45:15 -0700 (PDT)
Date:   Thu, 30 Mar 2023 08:45:15 +0200
From:   Andrea Righi <andrea.righi@canonical.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     "Drewek, Wojciech" <wojciech.drewek@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: selftests: net: l2tp.sh regression starting with 6.1-rc1
Message-ID: <ZCUv+8tbH3H5tZKe@righiandr-XPS-13-7390>
References: <ZCQt7hmodtUaBlCP@righiandr-XPS-13-7390>
 <MW4PR11MB57763144FE1BE9756FD3176BFD899@MW4PR11MB5776.namprd11.prod.outlook.com>
 <ZCRYpDehyDxsrnfi@debian>
 <MW4PR11MB5776F1B04976CB59D9FE41BFFD899@MW4PR11MB5776.namprd11.prod.outlook.com>
 <ZCRsxERSZiGf5H5e@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCRsxERSZiGf5H5e@debian>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 06:52:20PM +0200, Guillaume Nault wrote:
> On Wed, Mar 29, 2023 at 03:39:13PM +0000, Drewek, Wojciech wrote:
> > 
> > 
> > > -----Original Message-----
> > > -MODULE_ALIAS_NET_PF_PROTO_TYPE(PF_INET6, 2, IPPROTO_L2TP);
> > > -MODULE_ALIAS_NET_PF_PROTO(PF_INET6, IPPROTO_L2TP);
> > > +MODULE_ALIAS_NET_PF_PROTO_TYPE(PF_INET6, 2, 115 /* IPPROTO_L2TP */);
> > > +MODULE_ALIAS_NET_PF_PROTO(PF_INET6, 115 /* IPPROTO_L2TP */);
> > 
> > Btw, am I blind or the alias with type was wrong the whole time?
> > pf goes first, then proto and type at the end according to the definition of MODULE_ALIAS_NET_PF_PROTO_TYPE
> > and here type (2) is 2nd and proto (115) is 3rd
> 
> You're not blind :). The MODULE_ALIAS_NET_PF_PROTO_TYPE(...) is indeed
> wrong. Auto-loading the l2tp_ip and l2tp_ip6 modules only worked
> because of the extra MODULE_ALIAS_NET_PF_PROTO() declaration (as
> inet_create() and inet6_create() fallback to "net-pf-%d-proto-%d" if
> "net-pf-%d-proto-%d-type-%d" fails).

At this point I think using 115 directly is probably the best solution,
that is also what we do already with SOCK_DGRAM, but I would just update
the comment up above, instead of adding the inline comments.

Something like this maybe:

---

From: Andrea Righi <andrea.righi@canonical.com>
Subject: [PATCH] l2tp: generate correct module alias strings

Commit 65b32f801bfb ("uapi: move IPPROTO_L2TP to in.h") moved the
definition of IPPROTO_L2TP from a define to an enum, but since
__stringify doesn't work properly with enums, we ended up breaking the
modalias strings for the l2tp modules:

 $ modinfo l2tp_ip l2tp_ip6 | grep alias
 alias:          net-pf-2-proto-IPPROTO_L2TP
 alias:          net-pf-2-proto-2-type-IPPROTO_L2TP
 alias:          net-pf-10-proto-IPPROTO_L2TP
 alias:          net-pf-10-proto-2-type-IPPROTO_L2TP

Use the resolved number directly in MODULE_ALIAS_*() macros (as we
already do with SOCK_DGRAM) to fix the alias strings:

$ modinfo l2tp_ip l2tp_ip6 | grep alias
alias:          net-pf-2-proto-115
alias:          net-pf-2-proto-115-type-2
alias:          net-pf-10-proto-115
alias:          net-pf-10-proto-115-type-2

Moreover, fix the ordering of the parameters passed to
MODULE_ALIAS_NET_PF_PROTO_TYPE() by switching proto and type.

Fixes: 65b32f801bfb ("uapi: move IPPROTO_L2TP to in.h")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
---
 net/l2tp/l2tp_ip.c  | 8 ++++----
 net/l2tp/l2tp_ip6.c | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/l2tp/l2tp_ip.c b/net/l2tp/l2tp_ip.c
index 4db5a554bdbd..41a74fc84ca1 100644
--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -677,8 +677,8 @@ MODULE_AUTHOR("James Chapman <jchapman@katalix.com>");
 MODULE_DESCRIPTION("L2TP over IP");
 MODULE_VERSION("1.0");
 
-/* Use the value of SOCK_DGRAM (2) directory, because __stringify doesn't like
- * enums
+/* Use the values of SOCK_DGRAM (2) as type and IPPROTO_L2TP (115) as protocol,
+ * because __stringify doesn't like enums
  */
-MODULE_ALIAS_NET_PF_PROTO_TYPE(PF_INET, 2, IPPROTO_L2TP);
-MODULE_ALIAS_NET_PF_PROTO(PF_INET, IPPROTO_L2TP);
+MODULE_ALIAS_NET_PF_PROTO_TYPE(PF_INET, 115, 2);
+MODULE_ALIAS_NET_PF_PROTO(PF_INET, 115);
diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
index 2478aa60145f..5137ea1861ce 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -806,8 +806,8 @@ MODULE_AUTHOR("Chris Elston <celston@katalix.com>");
 MODULE_DESCRIPTION("L2TP IP encapsulation for IPv6");
 MODULE_VERSION("1.0");
 
-/* Use the value of SOCK_DGRAM (2) directory, because __stringify doesn't like
- * enums
+/* Use the values of SOCK_DGRAM (2) as type and IPPROTO_L2TP (115) as protocol,
+ * because __stringify doesn't like enums
  */
-MODULE_ALIAS_NET_PF_PROTO_TYPE(PF_INET6, 2, IPPROTO_L2TP);
-MODULE_ALIAS_NET_PF_PROTO(PF_INET6, IPPROTO_L2TP);
+MODULE_ALIAS_NET_PF_PROTO_TYPE(PF_INET6, 115, 2);
+MODULE_ALIAS_NET_PF_PROTO(PF_INET6, 115);
-- 
2.39.2

