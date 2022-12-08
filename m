Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6F0D64683F
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 05:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbiLHE1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 23:27:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbiLHE0x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 23:26:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 055AB950F5;
        Wed,  7 Dec 2022 20:26:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2D4AB822AE;
        Thu,  8 Dec 2022 04:26:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90F45C433D6;
        Thu,  8 Dec 2022 04:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670473598;
        bh=RyzXlE8FZTHRxWKOhSdmNe3GBd7LYFmC0GjbNRD4dFI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EAlJ8HWup9lLjccrdtk2rO2/h0aeRQ1dCjpZQW3WJypobdnXlHA4kywNRbtWBEEMT
         tsenPKgZ0t98glbch0KRy/JHlCt2eEHE+zgJd2lbbyRM88qfuWWwc3X8h34e/gDau6
         mZDSsZ0gTR+j/eHenEZd2cYlLCC2TH3dIj6GtWodWqfNFwZ2AkPnID297W8yjtUtEl
         YX3QpRBXHEyPTcpVeYSopgtkway0h9Sjm8sr+dAVLxi6KpUmx13h3ejhdzTUnh8q/R
         lzCaQBqhdcTOYP527gDB0P2OPkP3NQhaoIBXM+YNqI77Fm+hKuaM5g6ZFbPDSIKVgk
         AZFAREhVOXCew==
Date:   Wed, 7 Dec 2022 20:26:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 02/12] bpf: Rename
 bpf_{prog,map}_is_dev_bound to is_offloaded
Message-ID: <20221207202636.31b049a4@kernel.org>
In-Reply-To: <20221206024554.3826186-3-sdf@google.com>
References: <20221206024554.3826186-1-sdf@google.com>
        <20221206024554.3826186-3-sdf@google.com>
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

On Mon,  5 Dec 2022 18:45:44 -0800 Stanislav Fomichev wrote:
> BPF offloading infra will be reused to implement
> bound-but-not-offloaded bpf programs. Rename existing
> helpers for clarity. No functional changes.
> 
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Martin KaFai Lau <martin.lau@linux.dev>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Willem de Bruijn <willemb@google.com>
> Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> Cc: Anatoly Burakov <anatoly.burakov@intel.com>
> Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
> Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
> Cc: Maryam Tahhan <mtahhan@redhat.com>
> Cc: xdp-hints@xdp-project.net
> Cc: netdev@vger.kernel.org
> 
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
