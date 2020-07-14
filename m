Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E00A821FDBC
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 21:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729211AbgGNTtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 15:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbgGNTtR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 15:49:17 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CC49C061755
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 12:49:17 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id cv18so1231653pjb.1
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 12:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HtgiMTgHklnXAcb0ZNHZMxKbpDUEYM54tNaxLXkisrU=;
        b=Xvqp2fU5zXeBSkm/qdd/fjx9sAdUGJ4fXYBR1EMvydMFam+LLWQNfunjICMES41gB0
         FjklNYBEQHLdPuFWwUkY+Xt6USY8ZreftETRzIjDvgUQfV7vhLF5TKtSOGS5FvZObma9
         sjDTYspp+xTgj5dJlcaZuv4UHGrKTIDMhL4f5FUlcJ86tiVIARwLOCHBUhTOZhSQiLtg
         oSQ613oucxT7A0cVEGu4xMhP9L+rmFkpaQUIsBX4jNAI51I/OfjgEHdSUghGqMzK1s1U
         oDjbPvu92eceoRrFfk+c1sYZkc3xAaIjXPnJNGbLyN+nax370vxeuI+Qe4YZ8hBGkUrU
         AOog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HtgiMTgHklnXAcb0ZNHZMxKbpDUEYM54tNaxLXkisrU=;
        b=nA51/17xS/4mG9S8/C/e5B4ixbGjWSjBzta+gZCEly0pF4q5Io5xxSVvtcHQMvgaVm
         fgkDs07d6hZxmS7/ksLOBfS9GxIzo3NJxfsqvI+Gx6Xq//rBXJK1h5bvpeQvYJBulvFo
         WcgmvbtqyvyV78szieK0p+Afb+AV0s4vX47BrpihpgzsxUWHVBF15Hk+xKXHbVZJ93BI
         fSzs+I0naPiqShhSACbZzb9EUrASW9AlO00OZidmSAM5oeHPbLLjVLhoiFjAmp4mdsSg
         wZlu6JPQGOKjuRpwS/FoY08+ZZZhMZWm/P+gFoy67v52hfDA1+ahpSSbLgJ1q1ljUi9r
         K7Bg==
X-Gm-Message-State: AOAM531g3JN+cTEEiXcrCOkSgpppPwGPOOrcbsOOyv108IbCVv+Ps/1h
        XZV3LGpqz5EQdvAt9BzI3Bg=
X-Google-Smtp-Source: ABdhPJzzLdt/bOzmV/p/o4AXsOiHHZXv8DXyOdy0tTSCsExhsTfoR8w4q140awPj8VmKV4DjtTKfSQ==
X-Received: by 2002:a17:90a:3a81:: with SMTP id b1mr6441674pjc.217.1594756156971;
        Tue, 14 Jul 2020 12:49:16 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:96f0])
        by smtp.gmail.com with ESMTPSA id g18sm15472pfi.141.2020.07.14.12.49.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 12:49:16 -0700 (PDT)
Date:   Tue, 14 Jul 2020 12:49:13 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        OSS Drivers <oss-drivers@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        ajit.khaparde@broadcom.com, sriharsha.basavapatna@broadcom.com,
        somnath.kotur@broadcom.com, Tom Lendacky <thomas.lendacky@amd.com>,
        Ariel Elior <aelior@marvell.com>, skalluru@marvell.com,
        vishal@chelsio.com, benve@cisco.com, _govind@gmx.com,
        dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        anthony.l.nguyen@intel.com, GR-everest-linux-l2@marvell.com,
        shshaikh@marvell.com, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com
Subject: Re: [PATCH net-next v3 01/12] nfp: convert to new udp_tunnel_nic
 infra
Message-ID: <20200714194913.tomcepscj6er2asr@ast-mbp.dhcp.thefacebook.com>
References: <20200714191830.694674-1-kuba@kernel.org>
 <20200714191830.694674-2-kuba@kernel.org>
 <CAADnVQJYQFy+xdfPY6FSHgUvL-YZy=tZ4w0TU=d4wXCJTU7R1Q@mail.gmail.com>
 <20200714124537.46d708fc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200714124537.46d708fc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 14, 2020 at 12:45:37PM -0700, Jakub Kicinski wrote:
> On Tue, 14 Jul 2020 12:24:10 -0700 Alexei Starovoitov wrote:
> > On Tue, Jul 14, 2020 at 12:20 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > NFP conversion is pretty straightforward. We want to be able
> > > to sleep, and only get callbacks when the device is open.
> > >
> > > NFP did not ask for port replay when ports were removed, now
> > > new infra will provide this feature for free.
> > >
> > > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > > Reviewed-by: Simon Horman <simon.horman@netronome.com>  
> > 
> > I received this patch at least 3 times in the last couple of days.
> > Every time gmail marks it as new and I keep archiving it.
> > Is it just me  ?
> 
> It's v3, that'd add up.

ahh. gmail subj said [PATCH ... v1 ...],
but mutt says [PATCH ... v3 ...].
oh no thanks gmail.
