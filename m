Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34F9E28F288
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 14:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbgJOMlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 08:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726309AbgJOMlm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 08:41:42 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E14C061755;
        Thu, 15 Oct 2020 05:41:42 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id r8so1477345qtp.13;
        Thu, 15 Oct 2020 05:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/ohpcLrN8Yq1+JdiLxGkTxCHhym3BMLnpPVDPygXYRk=;
        b=jsrlJuFJRhJ09IVFnOSEmAQVhUQ1PpzHJFVZzvdKgjK6xsG6gKlw74MRCyPvnoRENp
         xHwOpQy/bfmY3WQ4bWkmx9VahDwv9uk6RkNQCyei7+8JXGUswbx82D8OCL0ZeUps9+zN
         uhYyq46fE6csf0YLjAT2VdQM9oubDbqp74VqKU8tdYYuDCppxo836eY4QzYmFq2aO2AZ
         p/kOwEn/hJNItTVhaHBS3IRKXYfIiVNjqhmb/4jZBs/GWNWgQZ/eqFw8l9wKTDzyBI+6
         syYwq/22TdKRI2OOYBrsbuQqrxLYSOo0eAEXYBpp/NAaAOr/kjv8hfqgKMDMQLeS3kt9
         q9qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/ohpcLrN8Yq1+JdiLxGkTxCHhym3BMLnpPVDPygXYRk=;
        b=qPmAy3Vq3M3KYJsXhCkV2/wCdpP6iMaQv8eeG1L5la043cZz/KhMGgPJqj+Kr67pg7
         Tyaao6efh89ftjFCDPHjQDAVSP89HnYJ7TzyZI+3aYQok88RbUBijp1DEOLwIzEqokaJ
         bKKN4cyZBIMTUikXp0BzkeL1TUzq12Jd6jrICZhGIe481p6vl1e1HMdZXRfH6mEEZR54
         I3j4G81YA9zF832QIO+zwJ1aAdoAllUlcnUh4uXY9pguKOeQJLrra2w+h2nEfz+OdOTB
         L1VTdRVckx3VKOsvebMSJjrrofFTce9b736+RJhATxsZew0QhIRcrPBt4Go16R86D+es
         5S9g==
X-Gm-Message-State: AOAM533htSmf6hIN23w3VGQswqMI/08PURCTl0wmebrfU2DaZxFUlFtX
        h79RT0PEOhP1Zpn6Q5I4ZDA=
X-Google-Smtp-Source: ABdhPJzGC7u1yk3qfZkbIj2Ep7KbB3jfFLgsZAA+RTxWoVv0Lfta2D08PffkWJ6g4Q5ZrakAx+QO4Q==
X-Received: by 2002:ac8:5b82:: with SMTP id a2mr3934093qta.176.1602765701188;
        Thu, 15 Oct 2020 05:41:41 -0700 (PDT)
Received: from localhost.localdomain ([177.220.172.68])
        by smtp.gmail.com with ESMTPSA id 61sm1073927qta.19.2020.10.15.05.41.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2020 05:41:40 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 048D0C1614; Thu, 15 Oct 2020 09:41:38 -0300 (-03)
Date:   Thu, 15 Oct 2020 09:41:37 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        gnault@redhat.com, pabeni@redhat.com,
        willemdebruijn.kernel@gmail.com
Subject: Re: [PATCHv3 net-next 00/16] sctp: Implement RFC6951: UDP
 Encapsulation of SCTP
Message-ID: <20201015124137.GA11030@localhost.localdomain>
References: <cover.1602574012.git.lucien.xin@gmail.com>
 <20201014203416.6e0a1604@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201014203416.6e0a1604@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 14, 2020 at 08:34:16PM -0700, Jakub Kicinski wrote:
> On Tue, 13 Oct 2020 15:27:25 +0800 Xin Long wrote:
> > Description From the RFC:
> > 
> >    The Main Reasons:
> > 
> >    o  To allow SCTP traffic to pass through legacy NATs, which do not
> >       provide native SCTP support as specified in [BEHAVE] and
> >       [NATSUPP].
> > 
> >    o  To allow SCTP to be implemented on hosts that do not provide
> >       direct access to the IP layer.  In particular, applications can
> >       use their own SCTP implementation if the operating system does not
> >       provide one.
> 
> Marcelo, Neil - please review if you want this one to make 5.10.

On the works!

> Otherwise we can defer until after the merge window.

Probably not needed.

Thanks,
Marcelo
