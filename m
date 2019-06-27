Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F444587CB
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 18:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbfF0Q5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 12:57:30 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:36570 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbfF0Q5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 12:57:30 -0400
Received: by mail-oi1-f196.google.com with SMTP id w7so2105955oic.3;
        Thu, 27 Jun 2019 09:57:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=IhaF72y9LaEkd74gZB18fpVYHxSL2Q4mj37etwk6QQI=;
        b=hKPhZEvW6kERuv3TdJ8stywpiGJtNwmBUcEVZVoIjc//Vj9TRlQC3Ve5cJegp1v9fE
         X3faUV2ez1DQ8e+DMHXdZSYeZqRvt2d+6wIwijWHvwaBLRoW/PnlJhYKZgQ2VRXEstaf
         qpYn/7+pss1PYViYHNln4DgjlACWp7XJuxq9UNl9pQrUsJF+1Atm+rXFiQ6NXpi/3Ev5
         pzYk/kY3mwTmSdiyVpo8OnNu1lrLLdakW1hli83BCmQ7ZnDdd6jX6Mwlk5t37mqlQ5DY
         KCFJWAGch/JMa5WiaAXaQAo+1fgtDTRdr5Jh5um+CSqBsY2Ua8Dzl2q7rw4FRgouxMoD
         Z9Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=IhaF72y9LaEkd74gZB18fpVYHxSL2Q4mj37etwk6QQI=;
        b=CgdWIXNSwb2+98CEvtQpJyV0mdyeEWr2KgBZAA78G2e5fswo2ws9xhdl9WatHEJ/7X
         nY63YB5F/YvUq+KFn8Gh7Nn2MIIBY0pl8sTdLlSgjTx8lhsqfs7MFlb+ZIi6XnD7pspc
         wzG5nYKZEGTJDlQLCqhmUeM/X51E+kMSsFFkaeUM8cUSNFrj/bUCOvQTrJJEXIOOSgKR
         ehEXrwQn/flO7lXFhWzCw0JvXPpfdHjb1//HqAQ/fNGMzRhpCamsgJhTipuNmJ7AL3yb
         ttgL9hcUXo00JSpk+mTiSt0ajkIiJH90MzmBuKA5ij7D8s+F5GjS/P/OBC1MF02IBFpI
         iAQw==
X-Gm-Message-State: APjAAAVdBxc0gzbr5fXrtX8euCfqX0WsMuMVb5eWzShJKBzdyNfcPttY
        UtsI2XWTm4+B0y05qZsEOqs=
X-Google-Smtp-Source: APXvYqyDXHmCusW6+kBNaKnYPoi05Lxf+lDWYhZ5y4MIfL+VNfw7l15IWByMUpgi82VrTSgrEOA+bQ==
X-Received: by 2002:aca:c584:: with SMTP id v126mr2933259oif.60.1561654649357;
        Thu, 27 Jun 2019 09:57:29 -0700 (PDT)
Received: from rYz3n ([2600:1700:210:3790::48])
        by smtp.gmail.com with ESMTPSA id w5sm886719oic.36.2019.06.27.09.57.28
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 09:57:28 -0700 (PDT)
Date:   Thu, 27 Jun 2019 11:57:28 -0500
From:   Jiunn Chang <c0d1n61at3@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     skhan@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Linux-kernel-mentees][PATCH v2] packet: Fix undefined behavior
 in bit shift
Message-ID: <20190627165726.p6k3tugjs2gzgnjh@rYz3n>
References: <20190627010137.5612-1-c0d1n61at3@gmail.com>
 <20190627032532.18374-2-c0d1n61at3@gmail.com>
 <7f6f44b2-3fe4-85f6-df3c-ad59f2eadba2@linuxfoundation.org>
 <20190627.092253.1878691006683087825.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190627.092253.1878691006683087825.davem@davemloft.net>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 09:22:53AM -0700, David Miller wrote:
> From: Shuah Khan <skhan@linuxfoundation.org>
> Date: Wed, 26 Jun 2019 21:32:52 -0600
> 
> > On 6/26/19 9:25 PM, Jiunn Chang wrote:
> >> Shifting signed 32-bit value by 31 bits is undefined.  Changing most
> >> significant bit to unsigned.
> >> Changes included in v2:
> >>    - use subsystem specific subject lines
> >>    - CC required mailing lists
> >> 
> > 
> > These version change lines don't belong in the change log.
> 
> For networking changes I actually like the change lines to be in the
> commit log.  So please don't stray people this way, thanks.

Hello David,

Would you like me to send v3 with the change log in the patch description?

I would be happy to do that.

THX,

Jiunn
