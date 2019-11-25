Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98EA2109481
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 20:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725992AbfKYT7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 14:59:08 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:42892 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbfKYT7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 14:59:07 -0500
Received: by mail-lj1-f193.google.com with SMTP id n5so17355809ljc.9
        for <netdev@vger.kernel.org>; Mon, 25 Nov 2019 11:59:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=A4jqgVIR6VNAvMxyV6ichR7Fy/TnhgwZTc6amRTOv5s=;
        b=Y7XgFrO56MPihAkQ5ZKaruoM7nfR3CsulqITenQ67fTMpRR85Rm0yd0MQUCK4eKjsK
         ryth9ETli44ncDe3yi6Rh7ykFNMLi64oSqfyxB9LjlXAWj+VTRfU4zIpR0nk+AOfgfTM
         5KeNfB2Fln7NPMu67EXouiiKq8kJoViUxnoihqOr48N3N31YG1dttYvtyO84d6Z5qalf
         5jgmWXsYg3dPwQB/LQ1oe88ej3Kkb18pctyoSRmaPlhVomP/bFtRLwt12ACqL1YMZVOK
         CayF45MKNjaRFxCBdro8JPo0vMAkmdmjVNgZ+sj6JEY7WSpL8RzBgxECeM6uW1h9BlG4
         uS5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=A4jqgVIR6VNAvMxyV6ichR7Fy/TnhgwZTc6amRTOv5s=;
        b=I1cMJgjFE+WdxeKnIvCqoncufStyHMFJSyhHYYsJs4W7I44uZa593Nin6OT1QfWFER
         GG+wowD3+ot31ZwChio2f7KGyR0pmsYAXykOYK9cUdnddnNVBE5VGVYjSpyCRNUw9D59
         5eVUT7XvuXmRkrm2BqhP0rgIik3dRafG0n5Z4B3Lz64CP4UeztbiaLm6JHOWebQpBFIp
         /86TX9Bhlu9oWP3GvO3pmszd59v0B4eMW3cLaXGnPMJPS+jyTOCyr7d4K2AbwzUiyd9z
         MRHNWlXUpMXwX971IRTrDCuy3M+qssUqmy5bes3NLRBSUarjlf7qI6rAOlfKDcQPVaJg
         7YZQ==
X-Gm-Message-State: APjAAAWzltWEeMOEoO5UhnU6D2tzlLBfQPQBLo/6oqhgSBwOz+nRsXDH
        QAyUT/caS4sBDh85Oy+7S9aoBw==
X-Google-Smtp-Source: APXvYqxGJ6+qNFsTS8o7zjFy2pY0u4RckSWcIqqeezd8RbjQ022dtwbkcDnFUsfWtOB8Vdmrp9Lbog==
X-Received: by 2002:a2e:91d5:: with SMTP id u21mr24145545ljg.32.1574711945887;
        Mon, 25 Nov 2019 11:59:05 -0800 (PST)
Received: from cakuba.hsd1.ca.comcast.net ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id l8sm4488446ljj.96.2019.11.25.11.59.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2019 11:59:05 -0800 (PST)
Date:   Mon, 25 Nov 2019 11:58:52 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     daniel@iogearbox.net, borisp@mellanox.com, aviadye@mellanox.com,
        netdev@vger.kernel.org,
        syzbot+df0d4ec12332661dd1f9@syzkaller.appspotmail.com
Subject: Re: [RFC net] net/tls: clear SG markings on encryption error
Message-ID: <20191125115852.3a131812@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <5dd8d805af315_3cdc2b06f70e05b490@john-XPS-13-9370.notmuch>
References: <20191122214553.20982-1-jakub.kicinski@netronome.com>
        <20191122143624.5b82b1d0@cakuba.netronome.com>
        <5dd8d805af315_3cdc2b06f70e05b490@john-XPS-13-9370.notmuch>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Nov 2019 22:56:05 -0800, John Fastabend wrote:
> Jakub Kicinski wrote:
> > On Fri, 22 Nov 2019 13:45:53 -0800, Jakub Kicinski wrote:  
> > > Also there's at least one more bug in this piece of code, TLS 1.3
> > > can't assume there's at least one free SG entry.  
> > 
> > And I don't see any place where the front and back of the SG circular
> > buffer are actually chained :( This:  
> 
> The easiest way to generate a message that needs to be chained is to
> use cork but we haven't yet enabled cork. However, there is one case
> with the use of apply, pass, and drop that I think this case could
> also be generated. I'll add a test for it and a fix. This case should
> only be hit when using with BPF and programs using apply/cork.
> 
> I have the patches for cork support on a branch as well so we should
> probably just send those out.
> 
> > 
> > static inline void sk_msg_init(struct sk_msg *msg)
> > {
> > 	BUILD_BUG_ON(ARRAY_SIZE(msg->sg.data) - 1 != MAX_MSG_FRAGS);
> > 	memset(msg, 0, sizeof(*msg));
> > 	sg_init_marker(msg->sg.data, MAX_MSG_FRAGS);
> > }
> > 
> > looks questionable as well, we shouldn't mark MAX_MSG_FRAGS as the end,
> > we don't know where the end is going to be..  
> 
> We use end->MAX_MSG_FRAGS and size==0 to indicate an fresh sk_msg. This
> should only ever be called to initialize a msg never afterwards.
> 
> > 
> > diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
> > index 6cb077b646a5..6c6ce6f90e7d 100644
> > --- a/include/linux/skmsg.h
> > +++ b/include/linux/skmsg.h
> > @@ -173,9 +173,8 @@ static inline void sk_msg_clear_meta(struct sk_msg *msg)
> >  
> >  static inline void sk_msg_init(struct sk_msg *msg)
> >  {
> > -       BUILD_BUG_ON(ARRAY_SIZE(msg->sg.data) - 1 != MAX_MSG_FRAGS);
> >         memset(msg, 0, sizeof(*msg));
> > -       sg_init_marker(msg->sg.data, MAX_MSG_FRAGS);
> > +       sg_chain(msg->sg.data, ARRAY_SIZE(msg->sg.data), msg->sg.data);
> >  }
> >    
> 
> I don't think we want to chain these here. We could drop the init
> marker part but its handy when reading sg values.
> 
> >  static inline void sk_msg_xfer(struct sk_msg *dst, struct sk_msg *src,
> > 
> > Hm?  
> 
> Nice catch on the missing chaining we dropped across various revisions
> and rebases of the code. Without cork support our test cases don't hit
> it now.

I see, thanks for the explanation! I'll leave fixing the chaining to
you, then.
