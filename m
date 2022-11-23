Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 108376369C0
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 20:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239065AbiKWTRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 14:17:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239946AbiKWTRR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 14:17:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D80FC5611;
        Wed, 23 Nov 2022 11:17:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BCAAB81F28;
        Wed, 23 Nov 2022 19:17:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06FEBC433D6;
        Wed, 23 Nov 2022 19:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669231033;
        bh=RdOWIKFgH2np1ctDV/eZoQ+NtT5Cm6zsg4hnh0svOto=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WVEWPdZR8K0svlzOZbXCh/Y1XOO16xVJL2NPgX/6EOSQQ5iHwkS0oouOF80dS2c64
         IMKOlrE8WEvM1zlADtaHBsJjFepLxg8kyXFSaodXu3mqAGvO9wPG+Zo26uCQzsAcJX
         apQu3tUvqIf+vwkRNIM/bJgChEM2h8DaXJDPaOx5aq+t3wd2VPQE/HDbRBJGvtTk6H
         jfh5Fn/F8xpr1zXmHTtobRsM0oKo8ib51cD4IsRuymzy6vCogkyrNuV3FP1oXJhpSP
         U2Erw9AU/fcNTu+VR6uzQ0qRyDQQ+ZYiAsPyy1GmKaIT5FT7cytQod8pZwGIzRzNc9
         HU5GY0Z4R4MEg==
Date:   Wed, 23 Nov 2022 11:17:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
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
Subject: Re: [xdp-hints] [PATCH bpf-next v2 8/8] selftests/bpf: Simple
 program to dump XDP RX metadata
Message-ID: <20221123111712.1da24f54@kernel.org>
In-Reply-To: <CAKH8qBsSFg+3ULN-+aqabXZJRVwPtq9P71d0VZCuT2tMrx4DHw@mail.gmail.com>
References: <20221121182552.2152891-1-sdf@google.com>
        <20221121182552.2152891-9-sdf@google.com>
        <877czlvj9x.fsf@toke.dk>
        <CAKH8qBsSFg+3ULN-+aqabXZJRVwPtq9P71d0VZCuT2tMrx4DHw@mail.gmail.com>
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

On Wed, 23 Nov 2022 10:29:23 -0800 Stanislav Fomichev wrote:
> > return ch.rx_count ?: ch.combined_count;
> >
> > works though :)  
> 
> Perfect, will do the same :-) Thank you for running and testing!

The correct value is ch.rx_count + ch.combined_count

We've been over this many times, I thought it was coded up in libbpf
but I don't see it now :S
