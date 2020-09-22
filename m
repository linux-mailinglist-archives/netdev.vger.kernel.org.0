Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66ADA274D8C
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 01:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbgIVX56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 19:57:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726641AbgIVX56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 19:57:58 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C15C061755
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 16:57:57 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id b17so2224673pji.1
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 16:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UUwnFF7QmNNp5H+NZc1j/iwnXMpp4nssQG2Rc6932DU=;
        b=z2IfbCkEjjRyTdQCP+S+iS84oCtiVcYwOD8DQxgoeqlKknSEH3HpbskM/Y2YmslNEI
         VEjNmcB30Hb3iEtoRpcv26WSEF0w2v44rGqBpwjSCS1MlYjOyeucuvwX9W3iOiARIbkb
         dyM2ToNyjq7Ep/YMFRQ1FR6XOwfcs2zTByEX1GFGuPcMDoAzQcRqIz33bOtXcE0Pdph6
         pD96t01m7awVEfNT+IhSKODqDcI8GjBVbulr+6O08nG1Imtjwg9b9kfDOD7JohzDByA3
         vdSRgpe5R05Aurib8o26vFTa7sIqNsRqjOvj0izOx9gXhZ6SVMxz67EtqSPYZMRULFs/
         QPBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UUwnFF7QmNNp5H+NZc1j/iwnXMpp4nssQG2Rc6932DU=;
        b=JM0fsCYEX7G60rfsikj0Zy168F1ih+1Qv64SZKQ88Eb2EAdVV4b89MnUngiGEqb/3v
         Oj4pjlWIfnTSwu+Ve8O/87TxlbBO1yEeSDcXZAxTrUKmtkX+X4PAvxl2+AuVVE4IIQ69
         ErD5n7ZUHQYM0dmWCIzfyjIf60/bcQp10SiouX4h/r+Kv+dioc/9iGUNeN96qpHkW/Yx
         HLjCJ1ob9tZDmyDRkpo/pT44rGw7qPgOGr1vKgIfl0oTQutvNHExXCPpzF7tneLvTCEv
         yMPRmwqVIqGWdmp32ybQ7CZec4TIuTynXtJJcbcPwTQMBVWAWWh2kbDiw9ay2iex+Tb/
         0xDw==
X-Gm-Message-State: AOAM531uR0Xrq9H3DGC/hEjs3N6/oD9na/igDE+g+BaVOiXkwq7sO763
        U+AC/t7nfzh9J/+lkzNtZUT1KefUwR//wQ==
X-Google-Smtp-Source: ABdhPJy4BXNR7PkthCM3YdGbbhSBvv8r5yPgGrnQgLgQJIYe+ataLadN7Pu9am67xrt6LqrYlaqoFw==
X-Received: by 2002:a17:90a:aa94:: with SMTP id l20mr5663501pjq.95.1600819077352;
        Tue, 22 Sep 2020 16:57:57 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id a18sm15029846pgw.50.2020.09.22.16.57.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 16:57:57 -0700 (PDT)
Date:   Tue, 22 Sep 2020 16:57:49 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jan Engelhardt <jengelh@inai.de>, netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] ip: do not exit if RTM_GETNSID failed
Message-ID: <20200922165749.3fb72ad6@hermes.lan>
In-Reply-To: <7214fc31-42f4-2a47-0f01-426bed14711d@gmail.com>
References: <20200921235318.14001-1-jengelh@inai.de>
        <20200921172232.7c51b6b7@hermes.lan>
        <nycvar.YFH.7.78.908.2009220817270.10964@n3.vanv.qr>
        <7214fc31-42f4-2a47-0f01-426bed14711d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Sep 2020 17:16:46 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 9/22/20 12:28 AM, Jan Engelhardt wrote:
> > 
> > On Tuesday 2020-09-22 02:22, Stephen Hemminger wrote:  
> >> Jan Engelhardt <jengelh@inai.de> wrote:
> >>  
> >>> `ip addr` when run under qemu-user-riscv64, fails. This likely is
> >>> due to qemu-5.1 not doing translation of RTM_GETNSID calls.
> >>>
> >>> 2: host0@if5: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
> >>>     link/ether 5a:44:da:1a:c4:0b brd ff:ff:ff:ff:ff:ff
> >>> request send failed: Operation not supported
> >>>
> >>> Treat the situation similar to an absence of procfs.
> >>>
> >>> Signed-off-by: Jan Engelhardt <jengelh@inai.de>  
> >>
> >> Not a good idea to hide a platform bug in ip command.
> >> When you do this, you risk creating all sorts of issues for people that
> >> run ip commands in container environments where the send is rejected (perhaps by SELinux)
> >> and then things go off into a different failure.  
> > 
> > In the very same function you do
> > 
> >   fd = open("/proc/self/ns/net", O_RDONLY);
> > 
> > which equally hides a potential platform bug (namely, forgetting to
> > mount /proc in a chroot, or in case SELinux was improperly set-up).
> > Why is this measured two different ways?
> > 
> >   
> 
> I think checking for EOPNOTSUPP error is more appropriate than ignoring
> all errors.
> 

Right, checking for not supported makes sense, but permission denied
is different.
