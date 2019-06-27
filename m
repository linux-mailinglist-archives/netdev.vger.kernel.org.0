Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE2F58D90
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 00:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbfF0WEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 18:04:38 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44111 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726559AbfF0WEi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 18:04:38 -0400
Received: by mail-pg1-f193.google.com with SMTP id n2so1611156pgp.11;
        Thu, 27 Jun 2019 15:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=nwwqo4OMPeEp/3IvNc965PpLmTMXL18lTWD4uQTEbxg=;
        b=k9M4knlrXmd61R4DWvoUMohmYUxb/A9pCr+92MQMtINw53nqb+ZEwK8VPwSOe9WvyH
         ND/WwVP3k0Jm1dN3WXj90f18Wvgm1+jQA0U55MWXWNp8709JP5TsylXTPjWRs8tIcNUw
         pItPz46en9YOYUacBWyZp4D3iHnPS3RmcOgFftYlzeW48UC8E0KaqfcrVeY2XbQhrBsy
         HmoEw53UOTPCzAZV6kxh10nHhIBwovvXknCyX2bVYmdujPQd/U/EPf8zd30tB1oQTHAz
         uU3FQs5mxUXfogUdrLMJJQuuPK0x6tkv9tepqk6Tgqab/KZZ4EV1y4Wjszr45buNUp1X
         YffQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=nwwqo4OMPeEp/3IvNc965PpLmTMXL18lTWD4uQTEbxg=;
        b=Mfw+DcSpXVbvfW568g/7xhmyXtgGpLkxHC2TMZEojbTn3T6GxvfmC4ffoIpk7CwiFc
         vqUauKSk+Em+Ljqm4L7YDMyHf9+SS0HRjjFW9ckMTfDyDWzEGWde+Fq4GvTM/8vW71U7
         a63KYTck+LtvllFPCkT5Yija0/v8lhoNgZqphFUMZY7rlOA0xJ9i3PaqQJ4ya7poLcC/
         sExAwhXv5X1Hl0eGbGzbnznBREpFDgRN2b4wOGk43nXBoTPjcD2XFcsnk5PnRPhhKbrO
         h1Bwd1tiouyGdD6btkWjjij0Wak3kiGhrCNbFU0+ip1mWdBMx9ervv1qHBmjbk80wWC1
         VgVA==
X-Gm-Message-State: APjAAAVQuDrhQ1KGxoxqSRj7I9cV1qohxd6MrnVTrzvsu8sno485/CM8
        dnlJoAaQ5aQM++WsyqwbEqQ=
X-Google-Smtp-Source: APXvYqzc5FveAOMflX5HizDh+qcNJBUHsV98YFwrtDsRstppx0pvQuvUX8PBO/hqOmo62KjAsFUjhA==
X-Received: by 2002:a63:4f5b:: with SMTP id p27mr5800716pgl.273.1561673077880;
        Thu, 27 Jun 2019 15:04:37 -0700 (PDT)
Received: from [172.20.53.102] ([2620:10d:c090:200::6693])
        by smtp.gmail.com with ESMTPSA id p2sm70688pfb.118.2019.06.27.15.04.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 15:04:37 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Ilya Maximets" <i.maximets@samsung.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, xdp-newbies@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        "=?utf-8?b?QmrDtnJuIFTDtnBlbA==?=" <bjorn.topel@intel.com>,
        "Magnus Karlsson" <magnus.karlsson@intel.com>,
        "Jakub Kicinski" <jakub.kicinski@netronome.com>,
        "Daniel Borkmann" <daniel@iogearbox.net>
Subject: Re: [PATCH bpf v5 1/2] xdp: hold device for umem regardless of
 zero-copy mode
Date:   Thu, 27 Jun 2019 15:04:35 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <A2E9F080-AFBE-4DA8-BAA5-73E6442DB54B@gmail.com>
In-Reply-To: <20190627101529.11234-2-i.maximets@samsung.com>
References: <20190627101529.11234-1-i.maximets@samsung.com>
 <CGME20190627101538eucas1p23924bd4173eb4b7b59c624b588ecb787@eucas1p2.samsung.com>
 <20190627101529.11234-2-i.maximets@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27 Jun 2019, at 3:15, Ilya Maximets wrote:

> Device pointer stored in umem regardless of zero-copy mode,
> so we heed to hold the device in all cases.
>
> Fixes: c9b47cc1fabc ("xsk: fix bug when trying to use both copy and 
> zero-copy on one queue id")
> Signed-off-by: Ilya Maximets <i.maximets@samsung.com>

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>

