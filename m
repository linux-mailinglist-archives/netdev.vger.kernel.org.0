Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0367A948
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 15:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730677AbfG3NS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 09:18:28 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:39428 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729404AbfG3NS2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 09:18:28 -0400
Received: by mail-qk1-f195.google.com with SMTP id w190so46521374qkc.6
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 06:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ewsU2Iz9ZvWQ7yxtRP3AUwr1AgiOeqjo56vMzVcYHuo=;
        b=rtRmgbLtKNxNy3El0o5zpb7dxbyqN5faJ2ERC0XTB0O9iOe4Q7bnA5JLOFdQ9pUacw
         foT2sL1Sm3yuo4K/TDrl21zgBfHB/ba0tn/ibvUzjj2CG22EmQmBt0DCTOi5b439RnC8
         BEv8KBVmahympZOaKlES3v4AV+ixec1z9hBAgAd0jRMSCy4fa9Q6PsCWB5KAmp9kh4CK
         TJC6XfihMHU5ZBbHLW7WUdBLieLLk+e9s6zaoRDvVsLaxahAtIEXD2NE9x5h1r6R/ypu
         zcyPIaHVlj+NizORmMKtWnAwXEkbHFAltyBrpFeCcaa8DDjdUW/7IqJZQqAJ/Gubgo8J
         VmbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ewsU2Iz9ZvWQ7yxtRP3AUwr1AgiOeqjo56vMzVcYHuo=;
        b=PN7P9EsWQLArR6qsL1zZgwams4PwqlbZKD57SosTQr1PPvwghMS0gC015WPWFLIHLy
         5PAMqImYmZhkxjmECRkOVuWRuwVpOf4FNwGEiURPgOuTdlPECakq7LqYuNoBMEFVGjdj
         a84cU8BSiiAYm7LV0aaVY40PgGKZOTSJO3BFRS0lEhjTDLPxAlzh3OMQDBf5PhslaIPM
         Wpv636RIVBbVEyUaJdvTBhKdUsmonrzi+lwMYAA6++M7kbHrZ6Eh/EsGg7wPuFfT69OG
         r+Xh5bojiw/IAVHgVsKgxlAO8VuatEmbEB1MYUjtuxecplQn04sbtkT2wzeoB6TbSoAK
         4ivg==
X-Gm-Message-State: APjAAAXRwm7Ct5er6O7W9Eg/Di/pg8ixD9ExzlJ/QwYsyqy4F+bfiqY2
        CXwQT3Y/sZQyMD6vYlrBdzaUGA==
X-Google-Smtp-Source: APXvYqz4e7NmVI/4iejFlWWPdB49DwIlIfmJBMGUkQb+rhBNDLlrPJ9/lD2SOVjYXpnER+IkI+BGzA==
X-Received: by 2002:a37:490d:: with SMTP id w13mr71871178qka.179.1564492707191;
        Tue, 30 Jul 2019 06:18:27 -0700 (PDT)
Received: from dhcp-41-57.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id t2sm36523130qth.33.2019.07.30.06.18.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 06:18:26 -0700 (PDT)
Message-ID: <1564492704.11067.28.camel@lca.pw>
Subject: Re: [PATCH] net/socket: fix GCC8+ Wpacked-not-aligned warnings
From:   Qian Cai <cai@lca.pw>
To:     David Laight <David.Laight@ACULAB.COM>,
        "davem@davemloft.net" <davem@davemloft.net>
Cc:     "vyasevich@gmail.com" <vyasevich@gmail.com>,
        "nhorman@tuxdriver.com" <nhorman@tuxdriver.com>,
        "marcelo.leitner@gmail.com" <marcelo.leitner@gmail.com>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Tue, 30 Jul 2019 09:18:24 -0400
In-Reply-To: <91237fd501de4ab895305c4d5666d822@AcuMS.aculab.com>
References: <1564431838-23051-1-git-send-email-cai@lca.pw>
         <91237fd501de4ab895305c4d5666d822@AcuMS.aculab.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6 (3.22.6-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-07-30 at 09:01 +0000, David Laight wrote:
> From: Qian Cai
> > Sent: 29 July 2019 21:24
> 
> ..
> > To fix this, "struct sockaddr_storage" needs to be aligned to 4-byte as
> > it is only used in those packed sctp structure which is part of UAPI,
> > and "struct __kernel_sockaddr_storage" is used in some other
> > places of UAPI that need not to change alignments in order to not
> > breaking userspace.
> > 
> > One option is use typedef between "sockaddr_storage" and
> > "__kernel_sockaddr_storage" but it needs to change 35 or 370 lines of
> > codes. The other option is to duplicate this simple 2-field structure to
> > have a separate "struct sockaddr_storage" so it can use a different
> > alignment than "__kernel_sockaddr_storage". Also the structure seems
> > stable enough, so it will be low-maintenance to update two structures in
> > the future in case of changes.
> 
> Does it all work if the 8 byte alignment is implicit, not explicit?
> For instance if unnamed union and struct are used eg:
> 
> struct sockaddr_storage {
> 	union {
> 		void * __ptr;  /* Force alignment */
> 		struct {
> 			__kernel_sa_family_t	ss_family;		/*
> address family */
> 			/* Following field(s) are implementation specific */
> 			char	__data[_K_SS_MAXSIZE - sizeof(unsigned
> short)];
> 					/* space to achieve desired size, */
> 					/* _SS_MAXSIZE value minus size of
> ss_family */
> 		};
> 	};
> };
> 
> I suspect unnamed unions and structs have to be allowed by the compiler.

I believe this will suffer the same problem in that will break UAPI,

https://lore.kernel.org/lkml/20190726213045.GL6204@localhost.localdomain/
