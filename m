Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 640CA5C6D7
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 03:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbfGBB4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 21:56:36 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42030 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726781AbfGBB4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 21:56:36 -0400
Received: by mail-pg1-f194.google.com with SMTP id t132so3503193pgb.9
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 18:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=appneta.com; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=stN/jIcTtxkt6RabqwrSWPJaiRnq2+3A1E/0aRNbIVM=;
        b=qqBUbhvJ0LOwiVbEXfdDBe/HVEYqlx2/QoFVPRd/aREc2aplfnzuDV33TSY8qORmzR
         h5KNux9TsYrU+KnPyS2D2gan81KJ3k+jsEqHbbX9mocR7T5/bCFm8zStgyNfZ7i3kYfB
         6J8g6VzJWr/mYKxn+b2dXRWXOU+Q4sXHcuvzw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=stN/jIcTtxkt6RabqwrSWPJaiRnq2+3A1E/0aRNbIVM=;
        b=VHJzrilD5NBo8BGihKr61OVRpwqQ9CLhevlaUMw9PX14R5gtgvG7jDx9zN282Ar7K4
         ZzEprK8m0O7AxCGBFDzkYNzmZEIUfGOYpnxoR3FZwzZYM9mdMsFgHHjYRwgGsMIySges
         B1w8FoBw3pMh3usyWvC5SWWNRdBq3KcrhQTSFye9BLNh7rETHXuq8y8U+IJfKQEdJ6q4
         FtHFOXia956H8WIACJFpGbtPq+Iw+Jv+o2J3RnrXElRUjj2I5NNxiHfkmwLmOXY94zC/
         cgean7w0YEbWuiUs1IYlm57TwdpxQ7k5O7mIwtPHtFU3cMuO5k3icMrzz6kU6cPjmK4U
         hWcg==
X-Gm-Message-State: APjAAAV/pNKqqSt/j5xlGcxtiCsiT1Ttmo4Rs8z48Gvcr0qsFY9zmrbP
        HZt3mKginRoZ+YQUy48q5Uo7
X-Google-Smtp-Source: APXvYqwrYsK/dMW3rmcYM9cn7fBU79CkEgcA3NY8e9ZMu60O5v89syAMOxOqc1+RIddGd4bp1Ah5sg==
X-Received: by 2002:a63:f50d:: with SMTP id w13mr27794200pgh.411.1562032595919;
        Mon, 01 Jul 2019 18:56:35 -0700 (PDT)
Received: from [192.168.1.144] (64-46-6-129.dyn.novuscom.net. [64.46.6.129])
        by smtp.gmail.com with ESMTPSA id n26sm12435679pfa.83.2019.07.01.18.56.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 18:56:35 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH RESEND 4.9.y] net: check before dereferencing netdev_ops
 during busy poll
From:   Josh Elsasser <jelsasser@appneta.com>
In-Reply-To: <20190701.185156.2142325894415755085.davem@davemloft.net>
Date:   Mon, 1 Jul 2019 18:56:32 -0700
Cc:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, edumazet@google.com, mcroce@redhat.com
Content-Transfer-Encoding: 7bit
Message-Id: <84C901BF-9CA7-4A5F-9CC7-EE095EA043A5@appneta.com>
References: <20190701234143.72631-1-jelsasser@appneta.com>
 <20190701.185156.2142325894415755085.davem@davemloft.net>
To:     David Miller <davem@davemloft.net>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Jul 1, 2019, at 6:51 PM, David Miller <davem@davemloft.net> wrote:

> I just tried to apply this with "git am" to the current v4.19 -stable
> branch and it failed.

This is only needed for the v4.9 stable kernel, ndo_busy_poll (and this NPE) 
went away in kernel 4.11.

Sorry, I probably should have called that out more explicitly.

