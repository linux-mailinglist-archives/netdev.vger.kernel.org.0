Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 382CB22B3D3
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 18:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729926AbgGWQnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 12:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727044AbgGWQnz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 12:43:55 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17EA6C0619DC;
        Thu, 23 Jul 2020 09:43:55 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id j10so4829867qtq.11;
        Thu, 23 Jul 2020 09:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MEzelzK6A1iR0Hq7ZpzeCYIL/zPgCeRTH83ADsVGxVg=;
        b=kX9ZDlrNi/NNtBhQdsixkzD+2djUYGtXWcT5dSG6iUJ9uAZDl3d6DMpXFQH6zNSXEy
         QJ9idstZlH1PlPtq8ZMZcuVDgEw+SWGRhlDOWItu0rti2XQrNeV0g1DJel1zfTcqLcM2
         nozFlKR2fi654peEjxpEkk8ralx/uwSHM3HH9j0dVZIHp5kBuwrKPlt2yZ3idTSmwd7t
         u7wMV1l85Wkyz6UHBb+Hul95XmPkmMi3I6V1dNxcdCJJcFlKcwtccMMubJAk1kp83uvY
         Ol2XIYLoEltNvBWDgwnh92J+ckXaEuPh62V8YRFCcaZF1OxXMtMGGSojmMOuc/KPS7tH
         KOfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MEzelzK6A1iR0Hq7ZpzeCYIL/zPgCeRTH83ADsVGxVg=;
        b=ZREUIngC6CKpxaSsELPweFNQdDn3CcsA3HuFGZZ33Bgdfw8GjK0QTxPN8ayo8WFboI
         wudKtmuLlLyFPxmSsAYGeoV4TdfD3C9HopDJrc+PG3aQI/1rs9lFgpY41tW9kOn4pofj
         fwthrXuKp+03rvQuzEDIjOqSOK3uL1URe6UULLHP8fAHZnvrfcMp0a9dtPkf90i+kxlJ
         A2AQDroA5wGmNwdUT8zaG3Odq190cfelIPxXCENC2QlMXZqejSGeLdH57io0AvUZ3p/5
         9z/j68NcEP6x5PEPEISU9h0xNC9dGV8BmYuo+F+xzywTL82XtEWmy9q2Tb2nrXXBsuNB
         Qd8w==
X-Gm-Message-State: AOAM532YPJhi9WuYvOQp2Z0lJD1e2jDyjNf4gA7w9SAKWb18jiunkf4O
        /PJ+VPnrvY4tw+FFLe3Mfg==
X-Google-Smtp-Source: ABdhPJypQVQ/7ruPg17P9HpCoEw1Fd2hBQjD42iQgBhKQA07at/5hrtKIBWajFHaziSgQDpC0GhOvA==
X-Received: by 2002:ac8:3528:: with SMTP id y37mr4281156qtb.308.1595522634257;
        Thu, 23 Jul 2020 09:43:54 -0700 (PDT)
Received: from PWN (c-76-119-149-155.hsd1.ma.comcast.net. [76.119.149.155])
        by smtp.gmail.com with ESMTPSA id t93sm2842529qtd.97.2020.07.23.09.43.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 09:43:53 -0700 (PDT)
Date:   Thu, 23 Jul 2020 12:43:51 -0400
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Joerg Reuter <jreuter@yaina.de>,
        Ralf Baechle <ralf@linux-mips.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        syzkaller-bugs@googlegroups.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Linux-kernel-mentees] [PATCH net] AX.25: Fix out-of-bounds read
 in ax25_connect()
Message-ID: <20200723164351.GA413286@PWN>
References: <20200722151901.350003-1-yepeilin.cs@gmail.com>
 <20200723142814.GQ2549@kadam>
 <20200723151355.GA412829@PWN>
 <20200723155057.GS2549@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200723155057.GS2549@kadam>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 23, 2020 at 06:50:58PM +0300, Dan Carpenter wrote:
> On Thu, Jul 23, 2020 at 11:13:55AM -0400, Peilin Ye wrote:
> > On Thu, Jul 23, 2020 at 05:28:15PM +0300, Dan Carpenter wrote:
> > > On Wed, Jul 22, 2020 at 11:19:01AM -0400, Peilin Ye wrote:
> > > > Checks on `addr_len` and `fsa->fsa_ax25.sax25_ndigis` are insufficient.
> > > > ax25_connect() can go out of bounds when `fsa->fsa_ax25.sax25_ndigis`
> > > > equals to 7 or 8. Fix it.
> > > > 
> > > > This issue has been reported as a KMSAN uninit-value bug, because in such
> > > > a case, ax25_connect() reaches into the uninitialized portion of the
> > > > `struct sockaddr_storage` statically allocated in __sys_connect().
> > > > 
> > > > It is safe to remove `fsa->fsa_ax25.sax25_ndigis > AX25_MAX_DIGIS` because
> > > > `addr_len` is guaranteed to be less than or equal to
> > > > `sizeof(struct full_sockaddr_ax25)`.
> > > > 
> > > > Reported-by: syzbot+c82752228ed975b0a623@syzkaller.appspotmail.com
> > > > Link: https://syzkaller.appspot.com/bug?id=55ef9d629f3b3d7d70b69558015b63b48d01af66
> > > > Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
> > > > ---
> > > >  net/ax25/af_ax25.c | 4 +++-
> > > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
> > > > index fd91cd34f25e..ef5bf116157a 100644
> > > > --- a/net/ax25/af_ax25.c
> > > > +++ b/net/ax25/af_ax25.c
> > > > @@ -1187,7 +1187,9 @@ static int __must_check ax25_connect(struct socket *sock,
> > > >  	if (addr_len > sizeof(struct sockaddr_ax25) &&
> > > >  	    fsa->fsa_ax25.sax25_ndigis != 0) {
> > > >  		/* Valid number of digipeaters ? */
> > > > -		if (fsa->fsa_ax25.sax25_ndigis < 1 || fsa->fsa_ax25.sax25_ndigis > AX25_MAX_DIGIS) {
> > > > +		if (fsa->fsa_ax25.sax25_ndigis < 1 ||
> > > > +		    addr_len < sizeof(struct sockaddr_ax25) +
> > > > +		    sizeof(ax25_address) * fsa->fsa_ax25.sax25_ndigis) {
> > > 
> > > The "sizeof(ax25_address) * fsa->fsa_ax25.sax25_ndigis" can have an
> > > integer overflow so you still need the
> > > "fsa->fsa_ax25.sax25_ndigis > AX25_MAX_DIGIS" check.
> > 
> > Thank you for fixing this up! I did some math but I didn't think of
> > that. Will be more careful when removing things.
> 
> No problem.  You had the right approach to look for ways to clean things
> up.
> 
> Your patches make me happy because you're trying to fix important bugs.

It is very encouraging to hear that! I will try to do what I can do.

Thank you,
Peilin Ye
