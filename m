Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC364C673A
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 11:44:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234827AbiB1Kog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 05:44:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiB1Koe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 05:44:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC9A6387AC;
        Mon, 28 Feb 2022 02:43:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3DAB3B80FD4;
        Mon, 28 Feb 2022 10:43:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C84BC340E7;
        Mon, 28 Feb 2022 10:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646045032;
        bh=q6N/NvoiVt/nRwHbH0HFmIxbGn9klhqF/V7IKGiwFlw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vLHZSPnM3sfCqvs3Yak3CaQI5vmbppmheBQVr+BGlw8fSOsioZaPEsa77JwL7gaqP
         4ixSK+FSSn5bJVlKUFg4iRfNvZFJEZIssyklXKaH9JKX+G6ogcq5OSZKgLcHdeUwhi
         IIkOFM7T4Qu0BbbkonLGusGnY8lhGdNk3vWEqGok=
Date:   Mon, 28 Feb 2022 11:43:49 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     Mimi Zohar <zohar@linux.ibm.com>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "revest@chromium.org" <revest@chromium.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/6] bpf-lsm: Extend interoperability with IMA
Message-ID: <YhynZby+AyA/PuBU@kroah.com>
References: <20220215124042.186506-1-roberto.sassu@huawei.com>
 <408a96085814b2578486b2859e63ff906f5e5876.camel@linux.ibm.com>
 <5117c79227ce4b9d97e193fd8fb59ba2@huawei.com>
 <223d9eedc03f68cfa4f1624c4673e844e29da7d5.camel@linux.ibm.com>
 <6a838878fdb3430b8e1d3e47aab7f22b@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a838878fdb3430b8e1d3e47aab7f22b@huawei.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 28, 2022 at 09:12:35AM +0000, Roberto Sassu wrote:
> > From: Roberto Sassu
> > Sent: Monday, February 28, 2022 10:08 AM
> > > From: Mimi Zohar [mailto:zohar@linux.ibm.com]
> > > Sent: Friday, February 25, 2022 8:11 PM
> > > On Fri, 2022-02-25 at 08:41 +0000, Roberto Sassu wrote:
> > > > > From: Mimi Zohar [mailto:zohar@linux.ibm.com]
> > > > > Sent: Friday, February 25, 2022 1:22 AM
> > > > > Hi Roberto,
> > > > >
> > > > > On Tue, 2022-02-15 at 13:40 +0100, Roberto Sassu wrote:
> > > > > > Extend the interoperability with IMA, to give wider flexibility for the
> > > > > > implementation of integrity-focused LSMs based on eBPF.
> > > > >
> > > > > I've previously requested adding eBPF module measurements and signature
> > > > > verification support in IMA.  There seemed to be some interest, but
> > > > > nothing has been posted.
> > > >
> > > > Hi Mimi
> > > >
> > > > for my use case, DIGLIM eBPF, IMA integrity verification is
> > > > needed until the binary carrying the eBPF program is executed
> > > > as the init process. I've been thinking to use an appended
> > > > signature to overcome the limitation of lack of xattrs in the
> > > > initial ram disk.
> > >
> > > I would still like to see xattrs supported in the initial ram disk.
> > > Assuming you're still interested in pursuing it, someone would need to
> > > review and upstream it.  Greg?
> > 
> > I could revise this work. However, since appended signatures
> > would work too, I would propose to extend this appraisal
> > mode to executables, if it is fine for you.
> 
> Regarding this patch set, I kindly ask if you could accept it,
> after I make the changes suggested.
> 
> The changes are simple, and waiting another kernel cycle
> seems too long.

3 months is not a long time, get it right first, there is no deadline
here.

thanks,

greg k-h
