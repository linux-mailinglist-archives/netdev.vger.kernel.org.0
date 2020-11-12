Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA5F2B0E93
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 20:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbgKLT4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 14:56:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726702AbgKLT4i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 14:56:38 -0500
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3FA0C0613D1;
        Thu, 12 Nov 2020 11:56:38 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id z16so6785971otq.6;
        Thu, 12 Nov 2020 11:56:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=qrpnM0BYCJho3ra0z2DRCUpe/Zqh4HIOiqiHUbFj3dg=;
        b=RV+6nhQNi/9xMhCCo9vBgxu5JdIU8qBXgt/PCyVCfBKM8lEVWF7Zd0eLOJcmNURuYF
         dmV9Q02Q2f0gn9DqeuPlE5hHEhtMJ/h/og0plU6A1iHPjbwgwEUFArYYb6xKYtAvxBUa
         3GsYHJY/xeONVzM5ONX/MohoCc+m+H29sNybmmG9jEmPDbErNdtLHtLEPzLj6u9wUqv4
         U4YWO2SaBiPIKifImzdzTEJBtVzb9ZA9dF3PVG3/m7kIeeVMm50DOefkEFK6uJRX5j0/
         vKgKxVoIRomP7o7zXFHK+Cz4I/Qny0Zk50ZN5q1nn+w45NTme4vc57Vs+iBgBBjMF4oK
         CdyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=qrpnM0BYCJho3ra0z2DRCUpe/Zqh4HIOiqiHUbFj3dg=;
        b=gV7d4FbdgnTnxXLCQQneyZUCI/hA6COkPs7WjvIdcmGSW/Z6ACX1WFTKqZqc9mY78a
         OR/5iBGAVAYeBdS2uN+wvoFilsWIT3d0W0NR5VO4pXsmA4N3itp2K0ejrVcIYj9fwE4T
         w2CnodQyysWNzXRPV8EoAStBngnx+Lp7IE18zI8D7nVWnaVztlOb5hNXAsSmGfnVFmGP
         WSiariczk38ydx0IEDiXBtEDPsJX4yGOSMMeDd6eRPcPnyd4FoRuYej2PHWL7IWjs39y
         qELX3KBa4wKRbBgb3UsJEyN9+MrHatlNDiaihrjh0poxkkausWBr9Ig4mUAvcuuE9prJ
         autQ==
X-Gm-Message-State: AOAM531fBhZsRoiXHoiexD1V0Cj+ovOdwx+N6bua1gFlwv6LYCJS23Qu
        ris9p+bDk4rYJP2B+60QgB0=
X-Google-Smtp-Source: ABdhPJyDaWi6iXjtVfHzWnbXjWGlyc6Xj4coRHU9Ih/NNluTYoawN9xA3szMFl0TDGTGBHGwX3x9+Q==
X-Received: by 2002:a9d:6755:: with SMTP id w21mr626228otm.55.1605210998273;
        Thu, 12 Nov 2020 11:56:38 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id t6sm1471030ooo.22.2020.11.12.11.56.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 11:56:37 -0800 (PST)
Date:   Thu, 12 Nov 2020 11:56:30 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>, ast@kernel.org,
        jakub@cloudflare.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Message-ID: <5fad936eeee38_2a6120874@john-XPS-13-9370.notmuch>
In-Reply-To: <1aa5f637-c044-3dc6-09d5-0b5dc0521f91@iogearbox.net>
References: <160477770483.608263.6057216691957042088.stgit@john-XPS-13-9370>
 <160477787531.608263.10144789972668918015.stgit@john-XPS-13-9370>
 <1aa5f637-c044-3dc6-09d5-0b5dc0521f91@iogearbox.net>
Subject: Re: [bpf PATCH 1/5] bpf, sockmap: fix partial copy_page_to_iter so
 progress can still be made
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann wrote:
> On 11/7/20 8:37 PM, John Fastabend wrote:
> > If copy_page_to_iter() fails or even partially completes, but with fewer
> > bytes copied than expected we currently reset sg.start and return EFAULT.
> > This proves problematic if we already copied data into the user buffer
> > before we return an error. Because we leave the copied data in the user
> > buffer and fail to unwind the scatterlist so kernel side believes data
> > has been copied and user side believes data has _not_ been received.

[...]

> > +			if (!copy) {
> > +				return copied ? copied : -EFAULT;
> >   			}
> 
> nit: no need for {}
> 
> >   
> >   			copied += copy;
> > @@ -56,6 +55,11 @@ int __tcp_bpf_recvmsg(struct sock *sk, struct sk_psock *psock,
> >   						put_page(page);
> >   				}
> >   			} else {
> > +				/* Lets not optimize peek case if copy_page_to_iter
> > +				 * didn't copy the entire length lets just break.
> > +				 */
> > +				if (copy != sge->length)
> > +					goto out;
> 
> nit: return copied;
> 
> Rest lgtm for this one.

Great, thanks for the review will fixup in v2.
