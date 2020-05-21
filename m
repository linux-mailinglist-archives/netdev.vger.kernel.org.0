Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6613E1DD02C
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 16:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728212AbgEUOg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 10:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726973AbgEUOg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 10:36:58 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E374C061A0E;
        Thu, 21 May 2020 07:36:58 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id x12so5596697qts.9;
        Thu, 21 May 2020 07:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rTic8LQJZFzI9/jLbTxrKbE0PiuGsUQcSqnWefT5qHo=;
        b=O9lYBNkCwkq13oToI9CFUojkTnClG+S8afJo3cKGe+79myunVFwo5A3q1+PPRTL8eA
         nCHFyEmSNs8SrEkDBLbmKUakCoZpOvJGJVC1veNRXiDwfMKvdOcv0DVbHYpAPvXmfaBq
         YLV1RTtB0QxY/T/WzQ52lDoyVPKLxT+7JjnsVSJ0zWkw1UoJ3x4CtGVTmqYYswws6wWZ
         OcP4+zUPa1MIakwYSUYPG6zD+eMQiy9wO4+ASkXJ+Y7Hv3mMGFTsaKQWcZ69kqF+uSF6
         paw5BHFeptRw4o67vELDOjagCfczGPFYFpNslD3AaMpPA3KAtI9lt5VF4dgjWkiCrET2
         nxeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rTic8LQJZFzI9/jLbTxrKbE0PiuGsUQcSqnWefT5qHo=;
        b=OUo2t3w0C/XVZscsKlseFnQvJaT7iV9w8dCFnXl/EEtFBdAzpzP0Vz37XiVba9SGuN
         ywjJNU5KTytLL1eusUfi6frS0axPLIT4giBYkWwmLlemYg6pPQSoOw4VE7BFTz0F8MF7
         7+GZrhSSW5qtwLcAct66mIKa16p+BFaobpFUEc7jkK927gP2z6p9zHQ2Mq+0EscKSUqG
         uljhOexlf4KYp7As9fuuIXZlMPYVod2+clKobg4vRBianfTm4UJx16TaD5oc1BZa8Ujl
         hYQF5mJt04bbkE5JboVCIqTaOYAkUUG0XRfUZLrhmvJp2pVSQpwi277Xy+JqrBcFEv/z
         VUDQ==
X-Gm-Message-State: AOAM533STBTf4Twj2l57ExhmNUwn+btj7LE1ERM3hyrWW+U4vzt7golA
        ACgiLeWMSW0AIOD+mal463foFfNw4cChlA==
X-Google-Smtp-Source: ABdhPJy4tKWDx/q/XFw5AKacPo5UtNJ3Z9vyMt9AvSfq3tpNMmgurmJleXX7jSj63qxTIU2CaURrZQ==
X-Received: by 2002:ac8:547:: with SMTP id c7mr10769135qth.168.1590071817080;
        Thu, 21 May 2020 07:36:57 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:b7f5:289f:a703:e466:2a27])
        by smtp.gmail.com with ESMTPSA id m7sm5012648qti.6.2020.05.21.07.36.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 07:36:56 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id B0E5BC0BEB; Thu, 21 May 2020 11:36:53 -0300 (-03)
Date:   Thu, 21 May 2020 11:36:53 -0300
From:   'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
To:     David Laight <David.Laight@aculab.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH net-next] sctp: Pull the user copies out of the
 individual sockopt functions.
Message-ID: <20200521143653.GA74252@localhost.localdomain>
References: <fd94b5e41a7c4edc8f743c56a04ed2c9@AcuMS.aculab.com>
 <20200521001725.GW2491@localhost.localdomain>
 <e777874fbd0e4ccb813e08145f3c3359@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e777874fbd0e4ccb813e08145f3c3359@AcuMS.aculab.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 21, 2020 at 07:32:14AM +0000, David Laight wrote:
> From: 'Marcelo Ricardo Leitner'
> > Sent: 21 May 2020 01:17
> > On Wed, May 20, 2020 at 03:08:13PM +0000, David Laight wrote:
> > ...
> > > Only SCTP_SOCKOPT_CONNECTX3 contains an indirect pointer.
> > > It is also the only getsockopt() that wants to return a buffer
> > > and an error code. It is also definitely abusing getsockopt().
> > ...
> > > @@ -1375,11 +1350,11 @@ struct compat_sctp_getaddrs_old {
> > >  #endif
> > >
> > >  static int sctp_getsockopt_connectx3(struct sock *sk, int len,
> > > -				     char __user *optval,
> > > -				     int __user *optlen)
> > > +				     struct sctp_getaddrs_old *param,
> > > +				     int *optlen)
> > >  {
> > > -	struct sctp_getaddrs_old param;
> > >  	sctp_assoc_t assoc_id = 0;
> > > +	struct sockaddr *addrs;
> > >  	int err = 0;
> > >
> > >  #ifdef CONFIG_COMPAT
> ..
> > >  	} else
> > >  #endif
> > >  	{
> > > -		if (len < sizeof(param))
> > > +		if (len < sizeof(*param))
> > >  			return -EINVAL;
> > > -		if (copy_from_user(&param, optval, sizeof(param)))
> > > -			return -EFAULT;
> > >  	}
> > >
> > > -	err = __sctp_setsockopt_connectx(sk, (struct sockaddr __user *)
> > > -					 param.addrs, param.addr_num,
> > > +	addrs = memdup_user(param->addrs, param->addr_num);
> > 
> > I'm staring at this for a while now but I don't get this memdup_user.
> > AFAICT, params->addrs is not __user anymore here, because
> > sctp_getsockopt() copied the whole thing already, no?
> > Also weird because it is being called from kernel_sctp_getsockopt(),
> > which now has no knowledge of __user buffers.
> > Maybe I didn't get something from the patch description.
> 
> The connectx3 sockopt buffer contains a pointer to the user buffer
> that contains the actual addresses.
> So a second copy_from_user() is needed.

Oh, I see now. Thanks.

> 
> This does mean that this option can only be actioned from userspace.
> 
> Kernel code can get the same functionality using one of the
> other interfaces to connectx().
> 
> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 
