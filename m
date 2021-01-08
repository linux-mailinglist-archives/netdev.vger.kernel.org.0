Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAFA72EF65B
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 18:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728369AbhAHRSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 12:18:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728117AbhAHRSY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 12:18:24 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34377C061380
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 09:17:44 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id b5so6521366pjk.2
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 09:17:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9Z2rtNZhY/SrFZpHAhurQZ5dyMNiQC+cFKUu5glqxnA=;
        b=SxuqNp/ED8cc5S9kS/FCnisgrI20WsXiVIL10moeuGKSkGITuTLyG/NfT9WcB0Ke/W
         0yZNrh+7qw68S3uIDeyIj95dh6ynAJY6VwqKnizr9/fb7zWv14qNs1LkB6pwSQJKBIZh
         Hq+0qX4PH9rHGReN1sbl5xX5viMvGxylfBLeH8z17EpZkoUSzfd2VfoNElD8SQXsCCI+
         pmEA3k7Ww1T9Esdv13C2bsqOZSfm5ZLTyOSrqzqdo9ThpZ9mAVChJh4QOxMSJPINWs04
         hZXpDchOJizqcyqw7+iyKMRB+Dh8WbFml0uiYxfraS58/Um7Abbg9Xk5fI0ozreMMDtk
         5FSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9Z2rtNZhY/SrFZpHAhurQZ5dyMNiQC+cFKUu5glqxnA=;
        b=HO18JjvLiTATiPzuT2GWQ3auLvEPc+JMzigAghYmAEs5pyuWMFnF15A2ncIgBDlH4W
         wwYYjLPatTiaQ5XkiEEDAHt4BpPuGDNL/20d8kA1EWh3FFxbZm1xWdpAZ77FUa/EAf5z
         OIPX+JNSVK+UNbl8Dz/6FXN0uS5gAQhWQd0mlrH/wSOH3CLFiu8uBoSsI7FU9woBsTZg
         PVap3qLNmaHVjr/f03Hz4FtoCmQUqDGTCNlzWRlgU35AmWJdyXDqnYPIc1UqwfbhtuJP
         ce0up3SPzo697xBID6dj0dOut/vxt2fBp/vQT20qfKW6p3pzNIYijUf3pxiiS4XE44xI
         3VzA==
X-Gm-Message-State: AOAM531o+1L7uXCCyhdHwKVbHoS6iD5n1wgw7f0wg6MwEvVmM7G0V/1Z
        gDk2e4nfj3pF7c31CuQ5mJHK
X-Google-Smtp-Source: ABdhPJxs7B6ZkaN884vLL3LSQoriw5QmwVZUfXcMuoWf8XSIk3U0P+e7T2EdVDryCSCJP30CX27XZQ==
X-Received: by 2002:a17:90a:9e5:: with SMTP id 92mr4793065pjo.176.1610126263663;
        Fri, 08 Jan 2021 09:17:43 -0800 (PST)
Received: from thinkpad ([103.77.37.188])
        by smtp.gmail.com with ESMTPSA id 11sm9903775pgz.22.2021.01.08.09.17.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 09:17:42 -0800 (PST)
Date:   Fri, 8 Jan 2021 22:47:37 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     Hemant Kumar <hemantk@codeaurora.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH] bus: mhi: Add inbound buffers allocation flag
Message-ID: <20210108171737.GD74017@thinkpad>
References: <1609940623-8864-1-git-send-email-loic.poulain@linaro.org>
 <20210108134425.GA32678@work>
 <CAMZdPi9tUUzf0hLwLUBqB=+eGQS-eNP8NtnMF-iS1ZqUfautuw@mail.gmail.com>
 <20210108153032.GC32678@work>
 <CAMZdPi_+wHo4q1BQScXALRaTAqNh0zxsgLsri364NvTP1h+6WQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMZdPi_+wHo4q1BQScXALRaTAqNh0zxsgLsri364NvTP1h+6WQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 08, 2021 at 04:46:49PM +0100, Loic Poulain wrote:
> Hi Mani,
> 
> On Fri, 8 Jan 2021 at 16:30, Manivannan Sadhasivam <
> manivannan.sadhasivam@linaro.org> wrote:
> 
> > > > >       /* start channels */
> > > > > -     rc = mhi_prepare_for_transfer(mhi_dev);
> > > > > +     rc = mhi_prepare_for_transfer(mhi_dev,
> > MHI_CH_INBOUND_ALLOC_BUFS);
> > > >
> > > > Are you sure it requires auto queued channel?
> > > >
> > >
> > > This is how mhi-qrtr has been implemented, yes.
> > >
> >
> > skb is allocated in qrtr_endpoint_post(). Then how the host can pre
> > allocate the buffer here? Am I missing something?
> >
> 
> The initial MHI buffer is pre-allocated by the MHI core, so that mhi-qrtr
> only has to register a dl_callback without having to allocate and queue its
> own buffers. On dl_callback mhi-qrtr calls qrtr_endpoint_post(data) which
> allocates an skb and copy the MHI buffer (data) into that skb. When
> mhi-qrtr dl_callback finishes, the MHI buffer is re-queued automatically by
> the MHI core.
> 

Oops... My bad! There is the "auto_queue" for dl chan. Sorry for the noise.

Thanks,
Mani

> Regards,
> Loic
> 
> 
> >
> > Thanks,
> > Mani
> >
> > > Regards,
> > > Loic
> >
