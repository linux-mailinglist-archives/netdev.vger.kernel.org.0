Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5CF29471E
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 06:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725794AbgJUEEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 00:04:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:56780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725790AbgJUEEf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 00:04:35 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F5EF21D6C;
        Wed, 21 Oct 2020 04:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603253075;
        bh=nCbkDvvMcAJEtnodf/6GIE/g2/O5m8VeefTaXNT/a7k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Aszh5W0z9gOQaNBNZa3bEubK2nWiTvEZoyFxMj/t+rlgXBlurC4acSK8vntfFk4UK
         rSRbUqbzO8muBx0fz6e3gN5/uzKJb7krSnfYTmS41ixO65Qg8A80yFtdgZTeDM2Vol
         i6oeYUV69h6Iv2TTbMYaSG1iQEDBI6MEpwDfGPrI=
Date:   Tue, 20 Oct 2020 21:04:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Guillaume Nault <gnault@redhat.com>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, Po Liu <Po.Liu@nxp.com>
Subject: Re: [PATCH net] net/sched: act_gate: Unlock ->tcfa_lock in
 tc_setup_flow_action()
Message-ID: <20201020210433.12e26ca3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAM_iQpXEPshoMYc5hkePa85T-H5uP3EGfHFRSDDqYrLuuB-bbg@mail.gmail.com>
References: <12f60e385584c52c22863701c0185e40ab08a7a7.1603207948.git.gnault@redhat.com>
        <CAM_iQpXEPshoMYc5hkePa85T-H5uP3EGfHFRSDDqYrLuuB-bbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Oct 2020 17:37:22 -0700 Cong Wang wrote:
> On Tue, Oct 20, 2020 at 8:34 AM Guillaume Nault <gnault@redhat.com> wrote:
> >
> > We need to jump to the "err_out_locked" label when
> > tcf_gate_get_entries() fails. Otherwise, tc_setup_flow_action() exits
> > with ->tcfa_lock still held.
> >
> > Fixes: d29bdd69ecdd ("net: schedule: add action gate offloading")
> > Signed-off-by: Guillaume Nault <gnault@redhat.com>  
> 
> Looks like the err_out label can be just removed after this patch?
> If any compiler complains, you have to fix it in v2, otherwise can be in a
> separate patch.
> 
> Other than this,
> 
> Acked-by: Cong Wang <xiyou.wangcong@gmail.com>

Applied, thank you!
