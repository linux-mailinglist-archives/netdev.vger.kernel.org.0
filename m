Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD45435B69
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 09:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231422AbhJUHMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 03:12:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:56218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231357AbhJUHMB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 03:12:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 759C7606A5;
        Thu, 21 Oct 2021 07:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634800185;
        bh=jSUySDz8lzTVjjSD+1bRdCp3Zigy7nDut3K7EhQ19Ss=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZgSZM0i0iMVGrkWnBIazW/Qx49Yz3PQWFlRDu8Vo0r8yKsOQLlI3jFLApU4vDCkr2
         cFdABA9S5CblrjvDriVFWzwrlw+PtWeJvCND32jOWTw5fbTgAJdxIS6guoYTON2TQg
         sfx0oAyWAkeDYgDzZddL2WjhUu35bKWBR8lETlRpXgHPZRSFM8K0LLNGlDzYXwn7Tl
         nd/c1YUBzK1zBnvRewtf//2EOg+2oyNjU5jRlgMm1L7cCc6M5CJWovTGoYKEe70uV/
         /qP3JBGBESFNNPGa6OtZ1uBc3Ke3Cfeo75PbvyjMAdwRLTDyCA2PxbbKenIFDqJbJJ
         8Y5uuVzfrIltw==
Date:   Thu, 21 Oct 2021 09:09:40 +0200
From:   Simon Horman <horms@kernel.org>
To:     Jesse Brandeburg <jesse.brandeburg@gmail.com>
Cc:     luo penghao <cgel.zte@gmail.com>,
        NetDEV list <netdev@vger.kernel.org>,
        Zeal Robot <zealci@zte.com.cn>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        intel-wired-lan@lists.osuosl.org, Jakub Kicinski <kuba@kernel.org>,
        luo penghao <luo.penghao@zte.com.cn>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [Intel-wired-lan] [PATCH linux-next] e1000: Remove redundant
 statement
Message-ID: <20211021070937.GA9814@kernel.org>
References: <20211018085305.853996-1-luo.penghao@zte.com.cn>
 <20211020092537.GF3935@kernel.org>
 <CAEuXFEzXSU-Ws6T_8TBVfgskh4VA14LmirFYSjdQpwtndfeeww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEuXFEzXSU-Ws6T_8TBVfgskh4VA14LmirFYSjdQpwtndfeeww@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 20, 2021 at 11:08:11AM -0700, Jesse Brandeburg wrote:
> Apologies for the duplicates, mail from my intel account going out
> through outlook.com is not being delivered.
> 
> On Wed, Oct 20, 2021 at 7:00 AM Simon Horman <horms@kernel.org> wrote:
> 
> > > Value stored to 'ctrl_reg' is never read.
> >
> > I agree this does seem to be the case.
> >
> > > Reported-by: Zeal Robot <zealci@zte.com.cn>
> > > Signed-off-by: luo penghao <luo.penghao@zte.com.cn>
> >
> > Reviewed-by: Simon Horman <horms@kernel.org>
> 
> Thanks for the review, but (davem/kuba) please do not apply.

Thanks, and sorry for misunderstanding the patch.

> 
> > > @@ -1215,8 +1215,6 @@ static int e1000_integrated_phy_loopback(struct e1000_adapter *adapter)
> > >               e1000_write_phy_reg(hw, PHY_CTRL, 0x8140);
> > >       }
> > >
> > > -     ctrl_reg = er32(CTRL);
> 
> Thanks for your patch, but this change is not safe. you're removing a
> read that could do two things. The first is that the read "flushes"
> the write just above to PCI (it's a PCI barrier), and the second is
> that the read can have some side effects.
> 
> If this change must be done, the code should be to remove the
> assignment to ctrl_reg, but leave the read, so the line would just
> look like:
>         er32(CTRL);
> 
> This will get rid of the warning and not change the flow from the
> hardware perspective.
> 
> > > -
> > >       /* force 1000, set loopback */
> > >       e1000_write_phy_reg(hw, PHY_CTRL, 0x4140);
> > >
> 
> Please do not apply this.
> 
