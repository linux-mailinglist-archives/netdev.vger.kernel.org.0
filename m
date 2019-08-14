Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D5098D66A
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 16:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726585AbfHNOlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 10:41:37 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:39198 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfHNOlh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 10:41:37 -0400
Received: by mail-qk1-f193.google.com with SMTP id 125so9669957qkl.6
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 07:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=wuELjlzk0W97on7ppjrVzsjRvp67peBZ1mBSicXJi+s=;
        b=dvhgdzV2fXm8SD8NEIlAG1bkBfXR/PV9D6iB725DTFxqBBFW1N15u5P1ZfyIdAJTiI
         B5CyM53w8f+QjSK6ayq0a92LFPbj13/i4ReJ4L4vMdRjlrmTIfeDhHK3MFAXam7b1qHv
         VYRT0K01nA8ceU+voZ3+R04zNIHuSaEOEUthnhIaFcRgMi4T/bmRVF4h0B3zgAWuVhMT
         FQ1MAcNXbEAQ36l959ZgRxd4LlMJ0KQYz44KmTzg1cgR19F+e040nw/F2Mmk+lEu6Jo/
         Gaym2mxodguaFqHdlcV05Z1CYhuouWBejZyV7CEQJF9aPuZY8NcWaok4dRr4o6KcRa3Z
         0gBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=wuELjlzk0W97on7ppjrVzsjRvp67peBZ1mBSicXJi+s=;
        b=g8AEdiL79p3/xfEPK2Xu3qAvc9g21y/CoMJJuUH0i3MZMQ4gJrYT/i7iKErPL01xuS
         WIfpP4Lzy6w/7yUsKNZNk0yzmTBD5ewLozjg1s3NCPxi5IDwfBE0MwJfxGuYEOUJEZ3r
         p4tedEiMneHAedNsettR7Mjiq19mUD+TOfuo2U52ctENGVP3uImX9MmYQ8bgzezpd/uq
         dJw3OQxDIgxeZ9/z+kghMz37V/IZB67nu/figO7CXjtUR/voDMJE+dmR1Kxkn/aayktZ
         Lj0ee4VCZb5j4X7mOl0YCv7s/rwjbFxtIZt30X1FujXjwGRA2FKqFBmQJmj39Qle/XVc
         KXFw==
X-Gm-Message-State: APjAAAUkQoPALV2Lh4rjpO+ZQBG/jUxGNj7fBxkXCbKOubUOW38oWTU2
        YtKp875UE+pTYoIU+JvUr+7VQp2j
X-Google-Smtp-Source: APXvYqwhfRN/HAkCiX/fGLnouYU9IZtajSjxtdxkyW0lfk1n/vnP5gruNm8JXlRRqQYoYJPSjEgXEw==
X-Received: by 2002:a37:680e:: with SMTP id d14mr38938770qkc.207.1565793696023;
        Wed, 14 Aug 2019 07:41:36 -0700 (PDT)
Received: from localhost.localdomain ([177.220.172.117])
        by smtp.gmail.com with ESMTPSA id b1sm23535668qkk.8.2019.08.14.07.41.34
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 14 Aug 2019 07:41:35 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id CAE49C0A43; Wed, 14 Aug 2019 11:41:32 -0300 (-03)
Date:   Wed, 14 Aug 2019 11:41:32 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Bernd <ecki@zusammenkunft.net>
Cc:     Neal Cardwell <ncardwell@google.com>,
        netdev <netdev@vger.kernel.org>, edumazet@google.com
Subject: Re: [PATCH net 2/4] tcp: tcp_fragment() should apply sane memory
 limits
Message-ID: <20190814144132.GA2869@localhost.localdomain>
References: <CABOR3+yUiu1BzCojFQFADUKc5BT2-Ew_j7KFNpjP8WoMYZ+SMA@mail.gmail.com>
 <CADVnQy=dvmksVaDu61+w-qtv2g_iNbWPFgbSJDtx9QaasmHonw@mail.gmail.com>
 <CABOR3+zQ0yfbcon6bv5TXrrAomoWLxy101iEXqBycDTrhytDiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABOR3+zQ0yfbcon6bv5TXrrAomoWLxy101iEXqBycDTrhytDiA@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 02, 2019 at 09:58:12PM +0200, Bernd wrote:
> 2019-08-02 21:14 GMT+02:00, Neal Cardwell <ncardwell@google.com>:
> > What's the exact kernel version you are using?
> 
> It is the RHEL errata kernel 3.10.0-957.21.3.el7 (rhsa-2019:1481), i
> need to check if there is a newer one.

FWIW, this one doesn't have the patch below.

  Marcelo

> 
> > Eric submitted a patch recently that may address your issue:
> >    tcp: be more careful in tcp_fragment()
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git/commit/?id=b617158dc096709d8600c53b6052144d12b89fab
> >
> > Would you be able to test your workload with that commit
> > cherry-picked, and see if the issue still occurs?
> 
> It only happens on a customer system in production up to now, so most
> likely not.
> 
> > That commit was targeted to many stable releases, so you may be able
> > to pick up that fix from a stable branch.
> 
> The only thing which is a bit strange, this is a Java client, and I am
> pretty sure we don’t set a small SO_SNDBUF, if anything it is
> increased (I need to verify that).
> 
> Not to worry, I guess I can now with your helpful pointer sort that
> out with Redhat.
> 
> gruss
> Bernd
> 
