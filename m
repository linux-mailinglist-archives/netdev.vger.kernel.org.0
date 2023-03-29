Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE8866CECDB
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 17:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbjC2P1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 11:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjC2P1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 11:27:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11D49423A
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 08:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680103594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SAnxWyj0HF9TEubrZktRdlGHxAtmrUsyKhC4L4EWNXM=;
        b=J99tV4Kxsp5kFgfpSaz5U6W2K7BJNsnhbpL2dj3j6I0clQUHKPHhS7sX4F1GkxLb+tdohm
        sol4cXg/ZL+RWNMnsxBCembRne+aSUMwjisQnLsCl+2z6X7w0SzQDcvtjs21UcBXKF8eH9
        66tovxXbs4phfdxENtLZms9z/yWLyBI=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-290-9Kj15huUNJuJerGrpyDtOQ-1; Wed, 29 Mar 2023 11:26:32 -0400
X-MC-Unique: 9Kj15huUNJuJerGrpyDtOQ-1
Received: by mail-qt1-f199.google.com with SMTP id t15-20020a05622a180f00b003e37dd114e3so10463120qtc.10
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 08:26:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680103592;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SAnxWyj0HF9TEubrZktRdlGHxAtmrUsyKhC4L4EWNXM=;
        b=kO123HdjGmWU2oVAXyqY7OVXwgUwWYWBvgvBU8ZHTjmqeQxxAZhud3brIQ9OGW80Ke
         dZ5M0l8eqvSK+clDZseIb2qhIGdYP+ET3OucMwpDCEMWBtytQi43EU8CUGAehkqhc14k
         4W22GYbBnRXJoufzvCxr2FnQrdLDflMZGygRJB+9GBfb/qzZbmDZ6TtAbi09zfgt1f/u
         F+hSVfB/tLSpZ4Qa2ZwYiof0VgPOxDrQgdHu/Q0CZi5E+IzWDiNSewXssShybhW+OMNd
         Z5XL8JqKNi0OEnWLnDnOZKnsOGWD4uLWg7eBLU5JkP3WU8SACAwjx/UD1+RYgQCP9ErJ
         2V0Q==
X-Gm-Message-State: AAQBX9cD2/DpJfNnXFYKv+tI17/W7imY0ZHUDFZcd1nwYE90OjJf257P
        Ob6IjPLPhaWiYTcTBeFMSUE9qy1lt5HOOhU8OwVaF6XV8fu2Q9weLe3AzQ3zpGVTtDKgzuHResQ
        NUiVdtoFmuRJMeuiT
X-Received: by 2002:a05:6214:f2a:b0:56f:6f5:502d with SMTP id iw10-20020a0562140f2a00b0056f06f5502dmr36639203qvb.17.1680103592521;
        Wed, 29 Mar 2023 08:26:32 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZxaJpZFi0+xc75lnJXuaPFS/Zb38h55Zo17Ek0671TiLDS8tLVTYiz2aCcRZGy84C6wQK1HQ==
X-Received: by 2002:a05:6214:f2a:b0:56f:6f5:502d with SMTP id iw10-20020a0562140f2a00b0056f06f5502dmr36639169qvb.17.1680103592263;
        Wed, 29 Mar 2023 08:26:32 -0700 (PDT)
Received: from debian (2a01cb058918ce00e2c03839ebb8a46a.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:e2c0:3839:ebb8:a46a])
        by smtp.gmail.com with ESMTPSA id dm40-20020a05620a1d6800b0074411b03972sm5862181qkb.51.2023.03.29.08.26.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 08:26:31 -0700 (PDT)
Date:   Wed, 29 Mar 2023 17:26:28 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     "Drewek, Wojciech" <wojciech.drewek@intel.com>
Cc:     Andrea Righi <andrea.righi@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: selftests: net: l2tp.sh regression starting with 6.1-rc1
Message-ID: <ZCRYpDehyDxsrnfi@debian>
References: <ZCQt7hmodtUaBlCP@righiandr-XPS-13-7390>
 <MW4PR11MB57763144FE1BE9756FD3176BFD899@MW4PR11MB5776.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW4PR11MB57763144FE1BE9756FD3176BFD899@MW4PR11MB5776.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 02:16:37PM +0000, Drewek, Wojciech wrote:
> Hi,
> 
> Modifying UAPI was not a good idea although the patch should not break userspace (related discussion [1]).
> We could revert this patch with one additional change (include l2tp.h in net/sched/cls_flower.c) but then again,
> modifying UAPI. This patch was mostly cosmetic anyway.
> Second option is to try to fix the automatic load. I'm not an expert but I think
> MODULE_ALIAS_NET_PF_PROTO macro is somehow responsible for that. I noticed some comments saying that
> "__stringify doesn't like enums" (this macro is using _stringify) and my patch defined IPPROTO_L2TP in enum.
> We can just replace IPPROTO_L2TP with 115 (where this macro is used) in order to fix this.
> I'm going to give it a try and will let you know.

Yes, the modules aliases now have symbolic names:

$ modinfo l2tp_ip l2tp_ip6 | grep alias
alias:          net-pf-2-proto-IPPROTO_L2TP
alias:          net-pf-2-proto-2-type-IPPROTO_L2TP
alias:          net-pf-10-proto-IPPROTO_L2TP
alias:          net-pf-10-proto-2-type-IPPROTO_L2TP

Therefore, 'request_module("net-pf-%d-proto-%d-type-%d")' can't find
them.

My personal preference is for the second option: fix module loading by
using plain numbers in MODULE_ALIAS_*. We can always keep the symbolic
names in comments.

---- >8 ----

diff --git a/net/l2tp/l2tp_ip.c b/net/l2tp/l2tp_ip.c
index 4db5a554bdbd..afe94a390ef0 100644
--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -680,5 +680,5 @@ MODULE_VERSION("1.0");
 /* Use the value of SOCK_DGRAM (2) directory, because __stringify doesn't like
  * enums
  */
-MODULE_ALIAS_NET_PF_PROTO_TYPE(PF_INET, 2, IPPROTO_L2TP);
-MODULE_ALIAS_NET_PF_PROTO(PF_INET, IPPROTO_L2TP);
+MODULE_ALIAS_NET_PF_PROTO_TYPE(PF_INET, 2, 115 /* IPPROTO_L2TP */);
+MODULE_ALIAS_NET_PF_PROTO(PF_INET, 115 /* IPPROTO_L2TP */);
diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
index 2478aa60145f..65d106b41951 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -809,5 +809,5 @@ MODULE_VERSION("1.0");
 /* Use the value of SOCK_DGRAM (2) directory, because __stringify doesn't like
  * enums
  */
-MODULE_ALIAS_NET_PF_PROTO_TYPE(PF_INET6, 2, IPPROTO_L2TP);
-MODULE_ALIAS_NET_PF_PROTO(PF_INET6, IPPROTO_L2TP);
+MODULE_ALIAS_NET_PF_PROTO_TYPE(PF_INET6, 2, 115 /* IPPROTO_L2TP */);
+MODULE_ALIAS_NET_PF_PROTO(PF_INET6, 115 /* IPPROTO_L2TP */);

