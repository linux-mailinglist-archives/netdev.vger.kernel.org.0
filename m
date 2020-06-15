Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C26B1F923D
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 10:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729230AbgFOIvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 04:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728496AbgFOIvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 04:51:09 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A56AC061A0E;
        Mon, 15 Jun 2020 01:51:08 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id r18so7318028pgk.11;
        Mon, 15 Jun 2020 01:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=sjNYNYB2PAqYsekC8o7YkscXKB6lDVKLys43kVcoOyw=;
        b=MfGKyzEsW7VC3DPvSItwZ3BVWqoTwlo4UIX2/khNf38eXAOW+JSrQk1vUsv6Img/xE
         LQTKx52rR9V/RXvrb1t9GY3yf47p4HArkMQS9wdLWWxLuXDHnmNdxbv61/PJNH1uLI+f
         QeMJGSo9ILr9xekl/ffPEHfOwolZgRcY+4r/2mbeo2HLulsnc/b+gbiUsEPoQ37PKTOU
         ctdBAOE9SDCLmvB2UJ5l71KPyuXK+laLZLeMgFFtdIK+NcJIVitEk21pk/mfb+rX7vvI
         Upsa0u2g6NmC/rmzZ0rmt5Fgnwbr1mfH4cImC5TLBRxIouGx4zNPOpSU7fC61BYQUusj
         CQAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=sjNYNYB2PAqYsekC8o7YkscXKB6lDVKLys43kVcoOyw=;
        b=b04j0VVFIgCAft32Rk2Q4O3DCISnGI8LumBIL0teSxaWiIez4CynpqXXE2/YM1xKbv
         3t95dfYdq5Mvc7clNi76BAflrXwjedssGVIpXI8fd9qU30LIYBO0D1Yk36KDQp45hRm5
         8702xEUinGuDETpe5n2So3vHKQVfC1NcfUbgSQHPRocHI/1oSjGJIpBs38AAkgXkS+BO
         oAfjlND39F2MqhOA/O3zSP+/2tREInAusvTmUo5ON+DeMojOcNkJd7PoDQF3wSSeignU
         6XbBlQRPm+LIbv/QaMvFo3zoGV/Qat2agJHOYanwhMWicUL6ygTrpixs9ZYnrjZJ/HCK
         bQ5Q==
X-Gm-Message-State: AOAM531xCRKSDx3N4sOM/wxP60G2F+1qpakwjwcaBZ2qrzkPxrTQP7rN
        JzsnXtj7kfXZ9Acw8pXE984=
X-Google-Smtp-Source: ABdhPJxKUl31bIVb8tdHx+D3dY3Nl8RmRodAViGpikCEs6HDQ2ODhR2hUBl1THwHLDuUQ+Cxdfa3Eg==
X-Received: by 2002:a63:1310:: with SMTP id i16mr20123019pgl.351.1592211068094;
        Mon, 15 Jun 2020 01:51:08 -0700 (PDT)
Received: from localhost ([43.224.245.180])
        by smtp.gmail.com with ESMTPSA id e78sm13199951pfh.50.2020.06.15.01.51.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Jun 2020 01:51:07 -0700 (PDT)
Date:   Mon, 15 Jun 2020 16:48:55 +0800
From:   Geliang Tang <geliangtang@gmail.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Peter Krystad <peter.krystad@linux.intel.com>,
        netdev@vger.kernel.org, mptcp@lists.01.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mptcp: use list_first_entry_or_null
Message-ID: <20200615084855.GB29964@OptiPlex>
References: <9958d3f15d2d181eb9d48ffe5bf3251ec900f27a.1591941826.git.geliangtang@gmail.com>
 <alpine.OSX.2.22.394.2006121114030.74555@mjmartin-mac01.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.OSX.2.22.394.2006121114030.74555@mjmartin-mac01.local>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 12, 2020 at 11:22:31AM -0700, Mat Martineau wrote:
> 
> Hello Geliang,
> 
> On Fri, 12 Jun 2020, Geliang Tang wrote:
> 
> > Use list_first_entry_or_null to simplify the code.
> > 
> > Signed-off-by: Geliang Tang <geliangtang@gmail.com>
> > ---
> > net/mptcp/protocol.h | 5 +----
> > 1 file changed, 1 insertion(+), 4 deletions(-)
> > 
> > diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
> > index 86d265500cf6..55c65abcad64 100644
> > --- a/net/mptcp/protocol.h
> > +++ b/net/mptcp/protocol.h
> > @@ -234,10 +234,7 @@ static inline struct mptcp_data_frag *mptcp_rtx_head(const struct sock *sk)
> > {
> > 	struct mptcp_sock *msk = mptcp_sk(sk);
> > 
> > -	if (list_empty(&msk->rtx_queue))
> > -		return NULL;
> > -
> > -	return list_first_entry(&msk->rtx_queue, struct mptcp_data_frag, list);
> > +	return list_first_entry_or_null(&msk->rtx_queue, struct mptcp_data_frag, list);
> > }
> > 
> > struct mptcp_subflow_request_sock {
> > -- 
> > 2.17.1
> 
> As Matthieu mentioned on your earlier patch, please submit patches to netdev
> with either a [PATCH net] or [PATCH net-next] tag. In this case, these are
> non-critical bug fixes so they should be targeted at net-next.
> 
> Note that net-next branch is currently closed to submissions due to the v5.8
> merge window. Please resubmit both MPTCP patches for net-next when David
> announces that it is open again. The change does look ok but will not be
> merged now.
> 
> Thanks for your patch,
> 
> --
> Mat Martineau
> Intel

Hi Mat,

Thanks for your reply.
I have already resend patch v2 to you.

-Geliang
