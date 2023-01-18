Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 568F7670F8B
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 02:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbjARBHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 20:07:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjARBHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 20:07:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E71D4B88B;
        Tue, 17 Jan 2023 16:58:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA38F615A9;
        Wed, 18 Jan 2023 00:58:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 274D8C433EF;
        Wed, 18 Jan 2023 00:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674003486;
        bh=wXGvhpjsTJaidPvLSv6kMt4Cg9G8YdRR9e5sVriyHis=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HeZ3N+eMQcA+aA3DkAM0Je/rQ2PdXhZZ0jzYpE7luOv31va8EDz8WVXJJux6nVLpV
         VP40nsuqTuRj64vQElVJ0jg5y2MCExOfPkKPnXZ2cw9V8X4nbFINuEGjKKIDIK61lV
         dLvDje5bARFynorpmLAVk7vSKIw2dFXLo2033Dorp3ETx0cDjCVlKqcxbslw2X/l2u
         llqgAfTh+L1NTAUi1kpyTUG3R+pmAAa7l50tD949ZpwXOayBq5vFobPGQvD2nvsXZ0
         b0nNKGPjDzG6/9wvA5A6fxNm46tlV4G97YxKNyrka/2R5WVbZrwoZq3KewjAuuRpyG
         6Koz9Gv8/Oy5w==
Date:   Tue, 17 Jan 2023 16:58:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        hawk@kernel.org, pabeni@redhat.com, edumazet@google.com,
        toke@redhat.com, memxor@gmail.com, alardam@gmail.com,
        saeedm@nvidia.com, anthony.l.nguyen@intel.com, gospo@broadcom.com,
        vladimir.oltean@nxp.com, nbd@nbd.name, john@phrozen.org,
        leon@kernel.org, simon.horman@corigine.com, aelior@marvell.com,
        christophe.jaillet@wanadoo.fr, ecree.xilinx@gmail.com,
        mst@redhat.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, intel-wired-lan@lists.osuosl.org,
        lorenzo.bianconi@redhat.com
Subject: Re: [RFC v2 bpf-next 5/7] libbpf: add API to get XDP/XSK supported
 features
Message-ID: <20230117165804.65118609@kernel.org>
In-Reply-To: <e58d34cd95e39caf0efb25951bc2da9948c6f486.1673710867.git.lorenzo@kernel.org>
References: <cover.1673710866.git.lorenzo@kernel.org>
        <e58d34cd95e39caf0efb25951bc2da9948c6f486.1673710867.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 14 Jan 2023 16:54:35 +0100 Lorenzo Bianconi wrote:
> +	struct nlattr *na = (struct nlattr *)(NLMSG_DATA(nh) + GENL_HDRLEN);
> +
> +	na = (struct nlattr *)((void *)na + NLA_ALIGN(na->nla_len));
> +	if (na->nla_type == CTRL_ATTR_FAMILY_ID) {

Assuming layout of attributes within a message is a hard no-no.
