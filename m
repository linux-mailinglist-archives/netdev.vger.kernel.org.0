Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 770401D0619
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 06:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbgEMEjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 00:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725898AbgEMEjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 00:39:15 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C298FC061A0C;
        Tue, 12 May 2020 21:39:15 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id b12so4419448plz.13;
        Tue, 12 May 2020 21:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nPz4T7IaudILeXQNatPbOTERFKwRTe6GpmSyU3VsITU=;
        b=Qw7DCGV/EQa8OqlKZgpNyTLDwQa4cgMhICPeixm3o8oAQflAexa1nJfvYhpuBFVlXb
         8TNxzEzCXc713hBfn7f3LJgpa8MewCOWMqScKsygwfIBf2aRilueGNIU2sFR5vuYM09w
         lQ5Pj4c10Wbem57ca70RObkb8D2IRFGqUp8vPt8chlCa5SKwFaBaFm5NpUOjqu2mp9rd
         0il3LBCqyuwkKsm/N+R0hHQjoKYgpYTbScUqfatFJVgGvLSifdmI3/eiZLavadE8J0Gj
         ntWxP2E+qARJA67fR5W3dq7lrI6m2TnGfiubxOdvQrGxApNX1TMSTiriQa8g6x80nOI7
         /eKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nPz4T7IaudILeXQNatPbOTERFKwRTe6GpmSyU3VsITU=;
        b=eFFW0pnhQesHsBpnwMRz8zTdr8TPcQNlT8XxPaOMY0eyKjK9rvH7GEbUswK7YspvWB
         9WbUTUk9HuEbQCa+xLP7zxkh89g4zDZ5b9RrnQ4yHmsVQ9MhNTzxO8PlzKJCkYdUNAcw
         +REQCWp/z3bbDkDa7xlKyfl9RYlltOvy3hybo/p+65cVgcYeo3kptuLaV6Ecal82pVbu
         V32ea6UpMZ8TJeZkRV93H0kYubgUOmInn/eo9G29FS+stbHfEAdGt68RdZiaVb3TSmOJ
         uy4gdR5riqmegCENI707Vh5XPiKvrsFqDycOGfEzQ8F52cQAXhR2vUT2LLkfCLaNBE62
         sm1g==
X-Gm-Message-State: AGi0PuZsaJoB4qsiFZ0vUYtP9vd4k1QY3c7Wx/GpIsDwd7TI5WYf37Pv
        giIavLWNS36emGMwqt9nShw=
X-Google-Smtp-Source: APiQypKfhB6VsMblXsptA2c7dr6XLMJSvwYlkcivITW/bUquYwHEbbE06PT28xCkh9Abv4QIQetQcA==
X-Received: by 2002:a17:902:7b92:: with SMTP id w18mr22115190pll.273.1589344755182;
        Tue, 12 May 2020 21:39:15 -0700 (PDT)
Received: from f3 (ae055068.dynamic.ppp.asahi-net.or.jp. [14.3.55.68])
        by smtp.gmail.com with ESMTPSA id h193sm13425194pfe.30.2020.05.12.21.39.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 21:39:13 -0700 (PDT)
Date:   Wed, 13 May 2020 13:39:08 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     zenczykowski@gmail.com, maze@google.com, pablo@netfilter.org,
        fw@strlen.de, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2] doc: document danger of applying REJECT to INVALID CTs
Message-ID: <20200513043908.GA25216@f3>
References: <CANP3RGe3fnCwj5NUxKu4VDcw=_95yNkCiC2Y4L9otJS1Hnyd-g@mail.gmail.com>
 <20200512210038.11447-1-jengelh@inai.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512210038.11447-1-jengelh@inai.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-05-12 23:00 +0200, Jan Engelhardt wrote:
> Signed-off-by: Jan Engelhardt <jengelh@inai.de>
> ---
> 
> Simplify the trigger case by dropping mentions of P_3.
> New -A commands as proposed.
> 
>  extensions/libip6t_REJECT.man | 20 ++++++++++++++++++++
>  extensions/libipt_REJECT.man  | 20 ++++++++++++++++++++
>  2 files changed, 40 insertions(+)
> 
> diff --git a/extensions/libip6t_REJECT.man b/extensions/libip6t_REJECT.man
> index 0030a51f..cc845e6f 100644
> --- a/extensions/libip6t_REJECT.man
> +++ b/extensions/libip6t_REJECT.man
> @@ -30,3 +30,23 @@ TCP RST packet to be sent back.  This is mainly useful for blocking
>  hosts (which won't accept your mail otherwise).
>  \fBtcp\-reset\fP
>  can only be used with kernel versions 2.6.14 or later.
> +.PP
> +\fIWarning:\fP You should not indiscrimnately apply the REJECT target to
                                          ^ typo
> +packets whose connection state is classified as INVALID; instead, you should
> +only DROP these.
> +.PP
> +Consider a source host transmitting a packet P, with P experiencing so much
> +delay along its path that the source host issues a retransmission, P_2, with
> +P_2 being succesful in reaching its destination and advancing the connection
                   ^ typo
