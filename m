Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98C9450E69D
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 19:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242494AbiDYROf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 13:14:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232474AbiDYROe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 13:14:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45ED213DD7;
        Mon, 25 Apr 2022 10:11:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E976BB8185B;
        Mon, 25 Apr 2022 17:11:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31CC6C385A7;
        Mon, 25 Apr 2022 17:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650906687;
        bh=+bgp0PfSTA56OI/cMQNiiWX7cdawrhm8C4d75Ow+If4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KYWt7eUYGSFAvr/Q6cedy60WfBDeIUGU5kVNpwszBm1hC4HazvvJ37RtMC3sUrw3m
         XTICnlfapX5xfG8Kpf2GKjCpg4ZYW9N05NyzJ7JIG+rvm/CG0YiTqanDmom4e5kPnZ
         f29mybYSk/SUUCCT7h79rmWanjEyeWH+HrzYgyW6pwiUjbtRnhc7QkWsV5+hb6+BOH
         qD3IFU2pasMZgbStcsIKbzzT7nJKMyl6tmTBDJzKgorW3txcyOhKeI6a9hB2f5O+It
         1+p4uKQrKi1WgdTvZuw2BQrolj3tu16PD4Tf0ieZGmDNNsjxmRHQzkn/PJoQyQnPVc
         0rlhgf+IrkuvQ==
Date:   Mon, 25 Apr 2022 10:11:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chuck Lever <chuck.lever@oracle.com>
Cc:     netdev@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-cifs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ak@tempesta-tech.com,
        borisp@nvidia.com, simo@redhat.com
Subject: Re: [PATCH RFC 2/5] tls: build proto after context has been
 initialized
Message-ID: <20220425101126.0efa9f51@kernel.org>
In-Reply-To: <165030057652.5073.10364318727607743572.stgit@oracle-102.nfsv4.dev>
References: <165030051838.5073.8699008789153780301.stgit@oracle-102.nfsv4.dev>
        <165030057652.5073.10364318727607743572.stgit@oracle-102.nfsv4.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Apr 2022 12:49:36 -0400 Chuck Lever wrote:
> From: Hannes Reinecke <hare@suse.de>
> 
> We have to build the proto ops only after the context has been
> initialized, as otherwise we might crash when I/O is ongoing
> during initialisation.

Can you say more about the crash you see? protos are not used until 
at least one socket calls update_sk_prot().
