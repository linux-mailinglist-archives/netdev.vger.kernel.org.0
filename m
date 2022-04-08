Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4404F9E02
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 22:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239393AbiDHULC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 16:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239385AbiDHUK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 16:10:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 25AEE13CC6
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 13:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649448531;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=X34v9srajCg/j9QKK4DR7vgFmdCgZsanh/0V3kdx5P8=;
        b=XR0HFiIh9ECisE22p+7eBxW9we3IDyJfOGnQVoxuO4lP5rgnSdGYfUF5OTJEfJ50Pk3k8e
        Oy+FcGozcFOBdYZpBEzi282s+czDjqSPuXDNZpqcFT9qe7fhGVEOCeG3RHF1Ykj62JS1DM
        PC7zh3lFniaILNLqbU1yDy5Lb7X3ok0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-357-bGXj6JI5PCWNK4XZrOoJXA-1; Fri, 08 Apr 2022 16:08:50 -0400
X-MC-Unique: bGXj6JI5PCWNK4XZrOoJXA-1
Received: by mail-wm1-f71.google.com with SMTP id f12-20020a05600c154c00b0038ea9ed0a4aso1001326wmg.1
        for <netdev@vger.kernel.org>; Fri, 08 Apr 2022 13:08:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=X34v9srajCg/j9QKK4DR7vgFmdCgZsanh/0V3kdx5P8=;
        b=vl2xSk2ypynEnJHFtkiJCYsAM4sfkmcddDgsrYE4RpUag9vDtalgZRBvmVy8eflEew
         JfDhDy7PwTyR6zwAnazt/32DF+rOS2TBa535U1GLL4g4cL0OeNMJQ+Z44aTc6B5ud4fi
         38hWOHFryiWQMGo5YWI3nvV2C6WTyZAmGykSnmixBpMSypDPnVogk+/K+ArqSnr057PQ
         SwCrLK1F8PrXS5+ed+d+FGZPTbct/oU/n0bBBS5t47+s3uMFHsHGRT5n7ViDbkMcaGQp
         V0iXg0KVnxbYbNWy2M6eejtBV+UfE3SG/oFy7Lg8+k9oTf9D5HexegBvWMHFAzO7wWLG
         4+7g==
X-Gm-Message-State: AOAM532aVmS2LLinasw5jhDOZMWV5PwJdkg7Yo4TFV/6UlFne7uz/LZX
        7T31M0LebSJM//ZdTiQ2qT6Bv+CcRP3At07sqftedPsHtmibwzlFlbSfVhjBMbGKwrOZhlsEUJi
        4LofkTvruBngPHiJC
X-Received: by 2002:a5d:6c68:0:b0:205:a0ee:c871 with SMTP id r8-20020a5d6c68000000b00205a0eec871mr15612926wrz.526.1649448528934;
        Fri, 08 Apr 2022 13:08:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxVmNg6TC/cM/LsUviXzO+9N+mdtP4Ojbir/jQ5EDPtC/yywny4FeQu4abK6fmuimFE2i31Gw==
X-Received: by 2002:a5d:6c68:0:b0:205:a0ee:c871 with SMTP id r8-20020a5d6c68000000b00205a0eec871mr15612912wrz.526.1649448528771;
        Fri, 08 Apr 2022 13:08:48 -0700 (PDT)
Received: from debian.home (2a01cb058d3818005c1e4a7b0f47339f.ipv6.abo.wanadoo.fr. [2a01:cb05:8d38:1800:5c1e:4a7b:f47:339f])
        by smtp.gmail.com with ESMTPSA id k9-20020adfb349000000b00206101fc58fsm14547065wrd.110.2022.04.08.13.08.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 13:08:48 -0700 (PDT)
Date:   Fri, 8 Apr 2022 22:08:46 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Taras Chornyi <tchornyi@marvell.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH net-next 4/5] mlxsw: Use dscp_t in struct mlxsw_sp_fib4_entry
Message-ID: <f7a376abaebd90e07853498c084ea2282ff1744f.1649445279.git.gnault@redhat.com>
References: <cover.1649445279.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1649445279.git.gnault@redhat.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new dscp_t type to replace the tos field of struct
mlxsw_sp_fib4_entry. This ensures ECN bits are ignored and makes it
compatible with the dscp fields of fib_entry_notifier_info and
fib_rt_info.

This also allows sparse to flag potential incorrect uses of DSCP and
ECN bits.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c    | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 1c451d648302..dc820d9f2696 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -508,7 +508,7 @@ struct mlxsw_sp_fib4_entry {
 	struct mlxsw_sp_fib_entry common;
 	struct fib_info *fi;
 	u32 tb_id;
-	u8 tos;
+	dscp_t dscp;
 	u8 type;
 };
 
@@ -5560,7 +5560,7 @@ mlxsw_sp_fib4_entry_should_offload(const struct mlxsw_sp_fib_entry *fib_entry)
 
 	fib4_entry = container_of(fib_entry, struct mlxsw_sp_fib4_entry,
 				  common);
-	return !fib4_entry->tos;
+	return !fib4_entry->dscp;
 }
 
 static bool
@@ -5646,7 +5646,7 @@ mlxsw_sp_fib4_entry_hw_flags_set(struct mlxsw_sp *mlxsw_sp,
 	fri.tb_id = fib4_entry->tb_id;
 	fri.dst = cpu_to_be32(*p_dst);
 	fri.dst_len = dst_len;
-	fri.dscp = inet_dsfield_to_dscp(fib4_entry->tos);
+	fri.dscp = fib4_entry->dscp;
 	fri.type = fib4_entry->type;
 	fri.offload = should_offload;
 	fri.trap = !should_offload;
@@ -5669,7 +5669,7 @@ mlxsw_sp_fib4_entry_hw_flags_clear(struct mlxsw_sp *mlxsw_sp,
 	fri.tb_id = fib4_entry->tb_id;
 	fri.dst = cpu_to_be32(*p_dst);
 	fri.dst_len = dst_len;
-	fri.dscp = inet_dsfield_to_dscp(fib4_entry->tos);
+	fri.dscp = fib4_entry->dscp;
 	fri.type = fib4_entry->type;
 	fri.offload = false;
 	fri.trap = false;
@@ -6251,7 +6251,7 @@ mlxsw_sp_fib4_entry_create(struct mlxsw_sp *mlxsw_sp,
 	fib_info_hold(fib4_entry->fi);
 	fib4_entry->tb_id = fen_info->tb_id;
 	fib4_entry->type = fen_info->type;
-	fib4_entry->tos = inet_dscp_to_dsfield(fen_info->dscp);
+	fib4_entry->dscp = fen_info->dscp;
 
 	fib_entry->fib_node = fib_node;
 
@@ -6305,7 +6305,7 @@ mlxsw_sp_fib4_entry_lookup(struct mlxsw_sp *mlxsw_sp,
 	fib4_entry = container_of(fib_node->fib_entry,
 				  struct mlxsw_sp_fib4_entry, common);
 	if (fib4_entry->tb_id == fen_info->tb_id &&
-	    fib4_entry->tos == inet_dscp_to_dsfield(fen_info->dscp) &&
+	    fib4_entry->dscp == fen_info->dscp &&
 	    fib4_entry->type == fen_info->type &&
 	    fib4_entry->fi == fen_info->fi)
 		return fib4_entry;
-- 
2.21.3

