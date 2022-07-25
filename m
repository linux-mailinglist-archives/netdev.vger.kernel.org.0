Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 316775800BF
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 16:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234629AbiGYObn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 10:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235198AbiGYObm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 10:31:42 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C35AAE0D9
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 07:31:41 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id i205-20020a1c3bd6000000b003a2fa488efdso3754940wma.4
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 07:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NLgMl3DrugPZ8RbHPgrSGm9F8IPwIYTU5UgW6M92CPM=;
        b=s2bl6qwF1AJUNo+Yb+dGRnBG8YIUI2+azMc9GwkpBY1lPtacEhK41PtkCs7z/hECnU
         pdQXDQFcaERx65eVxTPx86+qam4gThF82mEXV2sZVYEyTIJoIEs43fBOmg+MzMzaReu9
         VYKF1jEs2h/BNgcBAq1Y+DXhX/h2iwbBNuPGRJQ6FMRv8dORBNfyo/5ScBC621BRI658
         dmpHzyy46LTN4WKO4J6143Tp6x3FeF/+f/kxgTLOKk8G15OrI/Ho3DRoT1sCC4UHIpzJ
         +19cOj3u5sfz7bOH2LnPOaQjrDbud0rx03tsWdwPsf+rEUyZsdCcOkuAeZSmKckC96Wr
         ouaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NLgMl3DrugPZ8RbHPgrSGm9F8IPwIYTU5UgW6M92CPM=;
        b=7G+xasEpXqT9bIrKwDpRp0r8ux34V/gwCLTGxRgvLs+JXCTGP/oXaEBzuxq24WSNFp
         SmCW+vciuC4HtCZ+MV7RziN0Iyp/gn50/49WHWd/KdV2ocEgZxBnjddwC5iHQ7AbWmSb
         dQh/TldmwT0ejdO575xYnWLPnTeXju5S97TYutg4eTdjpU8jv74i36MnIvbeBQ87tXZ6
         isaCV8ErwOWSp8IU2g+l2PAXdcvQs0b9H0wtCECZUCvONIUWba1b/Ga2wCGJcJdOcFbP
         5A5awXWQ0+e0aoHWiZh3imvl7SAMS52MfGcMw0A0161uf0BxxmT2zINsQYIfc9T9aQpp
         cf3w==
X-Gm-Message-State: AJIora8R4QuLJu6Yug7UxJANRiQ6/eJv/sWHhGL4a4AD+br6MmE/HSzw
        4EfI/e9Lz1cQzTm9JhW0Z96w
X-Google-Smtp-Source: AGRyM1so26EZeGHMsXB+PNCerdHirkQM03vHgsy+0JJKJL88foAnlKkmkyRBMZaFNDu0nVUtVpaT3Q==
X-Received: by 2002:a05:600c:3b29:b0:3a3:1fa6:768 with SMTP id m41-20020a05600c3b2900b003a31fa60768mr8867870wms.193.1658759500305;
        Mon, 25 Jul 2022 07:31:40 -0700 (PDT)
Received: from Mem (pop.92-184-116-22.mobile.abo.orange.fr. [92.184.116.22])
        by smtp.gmail.com with ESMTPSA id z11-20020a05600c0a0b00b003a17ab4e7c8sm22262167wmp.39.2022.07.25.07.31.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 07:31:40 -0700 (PDT)
Date:   Mon, 25 Jul 2022 16:31:37 +0200
From:   Paul Chaignon <paul@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <martin.lau@linux.dev>,
        John Fastabend <john.fastabend@gmail.com>,
        Kaixi Fan <fankaixi.li@bytedance.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Yonghong Song <yhs@fb.com>
Subject: [PATCH bpf-next v3 1/5] ip_tunnels: Add new flow flags field to
 ip_tunnel_key
Message-ID: <f8bfd4983bd06685a59b1e3ba76ca27496f51ef3.1658759380.git.paul@isovalent.com>
References: <cover.1658759380.git.paul@isovalent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1658759380.git.paul@isovalent.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit extends the ip_tunnel_key struct with a new field for the
flow flags, to pass them to the route lookups. This new field will be
populated and used in subsequent commits.

Acked-by: Martin KaFai Lau <kafai@fb.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Paul Chaignon <paul@isovalent.com>
---
 include/net/ip_tunnels.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index 20db95055db3..63fac94f9ace 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -54,6 +54,7 @@ struct ip_tunnel_key {
 	__be32			label;		/* Flow Label for IPv6 */
 	__be16			tp_src;
 	__be16			tp_dst;
+	__u8			flow_flags;
 };
 
 /* Flags for ip_tunnel_info mode. */
-- 
2.25.1

