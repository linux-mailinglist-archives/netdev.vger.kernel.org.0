Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C69951010D
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 16:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351796AbiDZO6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 10:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351791AbiDZO6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 10:58:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF38E1409E;
        Tue, 26 Apr 2022 07:55:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78F0A614ED;
        Tue, 26 Apr 2022 14:55:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79D7BC385AA;
        Tue, 26 Apr 2022 14:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650984901;
        bh=me9iCcOuTJq+2PqZc4Jh4npbdVCsacbBRf9z6+gdqqk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Fq9hilMCAJ9Rwa8FPT5daWcr97ssuASl+lSc8iGSkdyweVTInpfT9bvtS2m6xq7PW
         TC8nluVb3QnvFByfp4Ei8BJqnJSBrKDSETcw6YDJ/CKnRVkYlh0RZJ9kGxojrzN4Rz
         fkrMJd5qGeG/yU3l7kmqOHAMSnlGCKcwsXGm1Mj4eRXiiQp5yfQOXWphT95sbPJ86e
         KZNRiIZsBq+RgD5cpH6RL3HE85LRrRKAkdsrw5yUuNJ20N9e2EREBy4VjA4LyTNdJA
         /vpiDNG8S4KLXVAb29UdlnQ3wUurVw+vPZ+0z+xj7P5OBB+HEGSMgcoLrZlf4oPey3
         KMCPwev+alVJg==
Date:   Tue, 26 Apr 2022 07:55:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Chuck Lever <chuck.lever@oracle.com>, netdev@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ak@tempesta-tech.com, borisp@nvidia.com, simo@redhat.com
Subject: Re: [PATCH RFC 4/5] net/tls: Add support for PF_TLSH (a TLS
 handshake listener)
Message-ID: <20220426075500.34776cd5@kernel.org>
In-Reply-To: <66077b73-c1a4-d2ae-c8e4-3e19e9053171@suse.de>
References: <165030051838.5073.8699008789153780301.stgit@oracle-102.nfsv4.dev>
        <165030059051.5073.16723746870370826608.stgit@oracle-102.nfsv4.dev>
        <20220425101459.15484d17@kernel.org>
        <66077b73-c1a4-d2ae-c8e4-3e19e9053171@suse.de>
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

On Tue, 26 Apr 2022 11:43:37 +0200 Hannes Reinecke wrote:
> > Create the socket in user space, do all the handshakes you need there
> > and then pass it to the kernel.  This is how NBD + TLS works.  Scales
> > better and requires much less kernel code.
> >   
> But we can't, as the existing mechanisms (at least for NVMe) creates the 
> socket in-kernel.
> Having to create the socket in userspace would require a completely new 
> interface for nvme and will not be backwards compatible.
> Not to mention having to rework the nvme driver to accept sockets from 
> userspace instead of creating them internally.
> 
> With this approach we can keep existing infrastructure, and can get a 
> common implementation for either transport.

You add 1.5kLoC and require running a user space agent, surely you're
adding new interfaces and are not backward-compatible already.

I don't understand your argument, maybe you could rephrase / dumb it
down for me?
