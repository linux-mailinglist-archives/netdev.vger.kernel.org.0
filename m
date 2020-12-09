Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 216562D46FC
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 17:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731322AbgLIQl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 11:41:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56508 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730729AbgLIQls (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 11:41:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607532021;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+jGrHAn9GUIrs8Ra1rFpgmHTiOEDLJjF3aG6CIDIa+8=;
        b=HARCd2KzJQ26JPgtlWlPz8JD8xhxGTB3hCQEVxguoGt/Es0UPeas53dwzJTGoMQO/8n1a6
        pJFwrN1ibn91xhAicLeftwPvfFn2o0+AfIwreovnmNhgdq3cGmp5DEtA5O/3IwUhHBGNnc
        bJJEoi8nVBi9CYAwKE+qMXPdfiLtVGo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-123-Xw7fU_jeN6CrNVj7y2t1kw-1; Wed, 09 Dec 2020 11:40:17 -0500
X-MC-Unique: Xw7fU_jeN6CrNVj7y2t1kw-1
Received: by mail-wm1-f72.google.com with SMTP id u123so555192wmu.5
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 08:40:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=+jGrHAn9GUIrs8Ra1rFpgmHTiOEDLJjF3aG6CIDIa+8=;
        b=CSeC4P6S0UQ9kZzm5V6jktZ4DJGdkdbKWNFWYQqxRdHlPjo9kn+lvLNynor4Lk4t+O
         94rc8xkpFVTMkgrT+V70uTCdypR2DNZQJD1WCkI9PcDJowpqMP8hqiqEF557hgPMp7kJ
         ypbbt885ywQzySP5Q1XcHWobIb0zqbNFF2iSXBDXEWCQBET53gTPnh0+qBo3xOggJ8kj
         a2q36HENyhK32T3aufHkDQqnkMzcz7M73ak4ORtfcws6mi/6TFY7JNTkHdSJRVMmpcD6
         TbAJJplgys9fUuSvZXGbdmLzIwwkS6LsjM8xHBIYq2Mj5/dn1yl+YcynP9v6DMHf01Ps
         Ktpw==
X-Gm-Message-State: AOAM533Pw/bZL//Scb7SY7cdPbJecJMywMVkV+GwvWFCV+haG9CR3cTX
        OufwYVSiuKWh8gyZNBD5TyKwBcvmPt8g2i8GOjcdBGZzKaFU5hlgeJyni4ppPLt5irZVCmnlGi3
        5FVt2Tbofps5t3hNF
X-Received: by 2002:a1c:309:: with SMTP id 9mr3622928wmd.80.1607532015909;
        Wed, 09 Dec 2020 08:40:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxKiRyP/pwQqvg7FbWGR99gfbi/awWLui2V+X/U0Gp/xDTPN3vypnb2UTe2id7W8nuQMU1GKQ==
X-Received: by 2002:a1c:309:: with SMTP id 9mr3622921wmd.80.1607532015760;
        Wed, 09 Dec 2020 08:40:15 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id x17sm4191476wro.40.2020.12.09.08.40.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 08:40:14 -0800 (PST)
Date:   Wed, 9 Dec 2020 17:40:13 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Martin Zaharinov <micron10@gmail.com>
Cc:     "linux-kernel@vger kernel. org" <linux-kernel@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
Subject: Re: Urgent: BUG: PPP ioctl Transport endpoint is not connected
Message-ID: <20201209164013.GA21199@linux.home>
References: <83C781EB-5D66-426E-A216-E1B846A3EC8A@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <83C781EB-5D66-426E-A216-E1B846A3EC8A@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 09, 2020 at 04:47:52PM +0200, Martin Zaharinov wrote:
> Hi All
> 
> I have problem with latest kernel release 
> And the problem is base on this late problem :
> 
> 
> https://www.mail-archive.com/search?l=netdev@vger.kernel.org&q=subject:%22Re%5C%3A+ppp%5C%2Fpppoe%2C+still+panic+4.15.3+in+ppp_push%22&o=newest&f=1
> 
> I have same problem in kernel 5.6 > now I use kernel 5.9.13 and have same problem.
> 
> 
> In kernel 5.9.13 now don’t have any crashes in dimes but in one moment accel service stop with defunct and in log have many of this line :
> 
> 
> error: vlan608: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> error: vlan617: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> error: vlan679: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> 
> In one moment connected user bump double or triple and after that service defunct and need wait to drop all session to start .
> 
> I talk with accel-ppp team and they said this is kernel related problem and to back to kernel 4.14 there is not this problem.
> 
> Problem is come after kernel 4.15 > and not have solution to this moment.

I'm sorry, I don't understand.
Do you mean that v4.14 worked fine (no crash, no ioctl() error)?
Did the problem start appearing in v4.15? Or did v4.15 work and the
problem appeared in v4.16?

> Please help to find the problem.
> 
> Last time in link I see is make changes in ppp_generic.c 
> 
> ppp_lock(ppp);
>         spin_lock_bh(&pch->downl);
>         if (!pch->chan) {
>                 /* Don't connect unregistered channels */
>                 spin_unlock_bh(&pch->downl);
>                 ppp_unlock(ppp);
>                 ret = -ENOTCONN;
>                 goto outl;
>         }
>         spin_unlock_bh(&pch->downl);
> 
> 
> But this fix only to don’t display error and freeze system 
> The problem is stay and is to big.

Do you use accel-ppp's unit-cache option? Does the problem go away if
you stop using it?

> 
> Please help to fix.
> 
> 
> 

