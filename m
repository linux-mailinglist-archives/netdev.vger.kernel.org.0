Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7D834EA511
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 04:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbiC2CTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 22:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbiC2CTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 22:19:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97FBC1B84FE;
        Mon, 28 Mar 2022 19:17:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B878612D8;
        Tue, 29 Mar 2022 02:17:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C682CC340EC;
        Tue, 29 Mar 2022 02:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648520275;
        bh=x6LGrekP+vzDseqjbaDHBzEuyMampza0o4ZGpkRkiAE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=l36SLPy15kB/fZ1ZD5S9OBSjzyvVgoU266cA1YELubgImIwZKpfhabut5SEqcv7/y
         Kl9WqbXDFIZxtrts7T5DzMjVOYSRYSqisqXC/Ee4JJmyCsIqUSGx3EE8xPBHeBILIs
         ENLY1J/d4boH2QLgkUyHWLUVrY7SB6Pk4LmGx6s2QVSqfV8H3vtImGFxSrU5ekEe0S
         JBp6xbKXYnoOMfYZrXObTxxitNK4CbnPNTudCdbCV71cdPFDp7GjFBqSr33vb6S4Fk
         1tiqzBvn7Si/ohMO2eRXpIBkcXCUYuXlv/BPcuSNr5h/ubvmXfMa0PHaFy/VxWhEnF
         t2rF52GXlvBTA==
Date:   Mon, 28 Mar 2022 19:17:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexandra Winter <wintera@linux.ibm.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>
Subject: Re: [PATCH net-next 1/1] veth: Support bonding events
Message-ID: <20220328191753.33b1910e@kernel.org>
In-Reply-To: <20220328081417.1427666-2-wintera@linux.ibm.com>
References: <20220328081417.1427666-1-wintera@linux.ibm.com>
        <20220328081417.1427666-2-wintera@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Mar 2022 10:14:17 +0200 Alexandra Winter wrote:
> +static bool _is_veth(const struct net_device *dev)

netif_is_veth()?

> +{
> +	return (dev->netdev_ops->ndo_open == veth_open);

Why compare ndo_open and not entire netdev_ops or rtnl_link_ops?

> +}

