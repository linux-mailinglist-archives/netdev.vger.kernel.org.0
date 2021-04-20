Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31D533660C0
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 22:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233801AbhDTUTw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 16:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233619AbhDTUTs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 16:19:48 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60F21C06174A;
        Tue, 20 Apr 2021 13:19:14 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id u8so29606747qtq.12;
        Tue, 20 Apr 2021 13:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3aoyr7J7H1kwl6iSNttniCwp/a0ZmjyBqIeXMA4B4Dg=;
        b=NOISXkAQA7bEbeT0xGrX8VL/VI9urvd2PjyiBeertwEHg+uvbTtxpO+2PF4vEgMtnM
         trpUjXcsw8iSu7MdFp4wbSsiYTClUXklOGOmuCqVMUIy9+eVD4LWr71MBL5eh7/VNlxq
         X1VHW+S4/NIsbB+N93+fZ03SjPSZjWo03t+l//21g1dSo9/vgjatwkUQsBwBwG+AtGo8
         gtUsqP2muaMsREh2d0ndI5hK60WMlzXv18XZoBfgXzNhGN/kDdOhjk1TK1wFAsawau9m
         uBGFYjDYisffhd6RgXCW7ioE3P7SubB2X9eBAzxqjwdojlQfuPt7jWmh7wxCUdWnAngC
         4fag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3aoyr7J7H1kwl6iSNttniCwp/a0ZmjyBqIeXMA4B4Dg=;
        b=aByi39Cpl39u9O4CARV55EYGApkAhO6VT5qgjDjzzB3Fh1Lnm3v4EXZE5z5kueqnuh
         JRvcTKQWUS510xj/VgXL/f2hQtajJAkigoYYGOaOicf0n+ImAoNskthqr6DnFpERFnnW
         cXYogxCLP7wvjWNS2jDv93iiUraswGzbOGI2/X/WsJLQhhLRuVhPFPe0+VQve1siPlRF
         2obvAmbjNWz/W7W7n3zbkVKjjtK0JCyS63xRgXsycY2Gq+vn+kh2HurRkbUDO3uDOce7
         d8doyUilMOIUcNzOCZhcLF3ygbxovsd9X7qXFAf3V2blDr1It1kMDbokjQrE8pu2DDor
         76Fw==
X-Gm-Message-State: AOAM532uUZmaxkeKlgCm6i3qOmRjfEnhP0zXHZG6QBftAV833NFQK/pE
        aWVcq7tHVTZcHm2HBhUN44k=
X-Google-Smtp-Source: ABdhPJxrKnSXz+C8dLYWedlfhLMuSxi+VpACG//Ksa+d2CrpPFTw5wMhKzZ4CaQ9O5iTeSyty2pRLw==
X-Received: by 2002:a05:622a:1445:: with SMTP id v5mr18357521qtx.82.1618949952946;
        Tue, 20 Apr 2021 13:19:12 -0700 (PDT)
Received: from horizon.localdomain ([177.220.172.96])
        by smtp.gmail.com with ESMTPSA id y29sm12439352qtm.13.2021.04.20.13.19.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 13:19:12 -0700 (PDT)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id F3537C07BF; Tue, 20 Apr 2021 17:19:09 -0300 (-03)
Date:   Tue, 20 Apr 2021 17:19:09 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH RESEND][next] sctp: Fix fall-through warnings for Clang
Message-ID: <YH83PToOAiYfHPH3@horizon.localdomain>
References: <20210305090717.GA139387@embeddedor>
 <91fcca0d-c986-f88e-4a0d-4590de6a5985@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91fcca0d-c986-f88e-4a0d-4590de6a5985@embeddedor.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 03:09:24PM -0500, Gustavo A. R. Silva wrote:
> Hi all,
> 
> Friendly ping: who can take this, please?

It would go via net/net-next tree, but I can't find this one on
patchwork. Just the previous version.

http://patchwork.ozlabs.org/project/netdev/list/?series=&submitter=&state=*&q=sctp%3A+Fix+fall-through+warnings+for+Clang&archive=both&delegate=

I can, however, find it in the archives.

https://lore.kernel.org/netdev/20210305090717.GA139387%40embeddedor/T/

Dave and Jakub will know better.

  Marcelo
