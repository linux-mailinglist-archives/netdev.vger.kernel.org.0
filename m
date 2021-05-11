Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0CA137ACC0
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 19:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231502AbhEKRLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 13:11:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21944 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230315AbhEKRLx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 13:11:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620753046;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nYb2hmsJRk0XVTxx+a33t9xuJVs7yF/Ac8izZUEbiFc=;
        b=YsB94+TxvTbCTAFgAXNAzopmY++dRcdkEK0Dw03lk2QDlk6y/cqyNi56qKRbcqRnlhsWcj
        MQCPWZqWj009NQ2qTC+seaM7cDqAGBJaqtDiX1XoijwWUgeB9EGW+e9Lw55inXKNBOW7dn
        nG5IhA6YCfkBEx4eY8PCNJtkpO2K/W4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-402-TWPyN_vPMTOqPiP84rpdHw-1; Tue, 11 May 2021 13:10:42 -0400
X-MC-Unique: TWPyN_vPMTOqPiP84rpdHw-1
Received: by mail-wm1-f72.google.com with SMTP id g70-20020a1c9d490000b0290169ee5690c4so566560wme.4
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 10:10:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=nYb2hmsJRk0XVTxx+a33t9xuJVs7yF/Ac8izZUEbiFc=;
        b=ZoJ1aRaAOu7ivIj8cwfCVhw39V4ID/dmXgv2EbThxXVmw5bFO2+nZu8qytqcISONbl
         /ui3FGWsIxpdfhcGkjwYjojOz3UB9LyvJ0BC9FEJ3lvfSetOyoCi/ESED8JpGcx31ZkM
         eiVZnWnjtdLikooQZJUo3jjnjYSPF7KV6NZdfo8o4+zS9BacECz9Sw9+aIXETPMk39Ij
         o95OBTo6p8hv2MnJFtAOOPh3hgXFOVHFKF27rNkf6ejOdmpcesQziqSD/rH+fpsYLmx8
         fevhfNCVW3VnIQyOdng6fGI+Y/TWJ24YA9YE06KlutOkY+pMZQWEG1CmH5wq6Qxe5roT
         xiTQ==
X-Gm-Message-State: AOAM532wc6Ly/BWHbrz9sfxmI3tukUf4d0jE9+3q0o8fj+1IvH4LVis8
        fx/cPej6p0rgdaCwx8erATbY1uOi1kfIZDI4vkRhRGDkefQ0V2OmcvLcqN74Oh3spfbNF4AYsQh
        twQVzE99jItAwd7Qw
X-Received: by 2002:adf:f751:: with SMTP id z17mr38610334wrp.175.1620753041480;
        Tue, 11 May 2021 10:10:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwWSj+D/ZjcPW47FJSqCfapLnNWmnLB3iDsO5kOBl67RBGC/9SUDCp+8k859mg8aitiEIBdgQ==
X-Received: by 2002:adf:f751:: with SMTP id z17mr38610316wrp.175.1620753041304;
        Tue, 11 May 2021 10:10:41 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-108-140.dyn.eolo.it. [146.241.108.140])
        by smtp.gmail.com with ESMTPSA id y2sm4526360wmq.45.2021.05.11.10.10.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 10:10:41 -0700 (PDT)
Message-ID: <f6d8e86b3180679e11f766bd68e8ea207c56a313.camel@redhat.com>
Subject: Re: [PATCH net] mptcp: fix data stream corruption
From:   Paolo Abeni <pabeni@redhat.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.linux.dev,
        Maxim Galaganov <max@internet.ru>
Date:   Tue, 11 May 2021 19:10:39 +0200
In-Reply-To: <c7b744f0-31e3-c727-ce49-a35613b71a6@linux.intel.com>
References: <95cee926051dae0afe4d39072f446e1cad17008a.1620720059.git.pabeni@redhat.com>
         <c7b744f0-31e3-c727-ce49-a35613b71a6@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-05-11 at 09:17 -0700, Mat Martineau wrote:
> On Tue, 11 May 2021, Paolo Abeni wrote:
> 
> > Maxim reported several issues when forcing a TCP transparent proxy
> > to use the MPTCP protocol for the inbound connections. He also
> > provided a clean reproducer.
> > 
> > The problem boils down to 'mptcp_frag_can_collapse_to()' assuming
> > that only MPTCP will use the given page_frag.
> > 
> > If others - e.g. the plain TCP protocol - allocate page fragments,
> > we can end-up re-using already allocated memory for mptcp_data_frag.
> > 
> > Fix the issue ensuring that the to-be-expanded data fragment is
> > located at the current page frag end.
> > 
> > Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/178
> > Reported-and-tested-by: Maxim Galaganov <max@internet.ru>
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > ---
> > net/mptcp/protocol.c | 6 ++++++
> > 1 file changed, 6 insertions(+)
> 
> Hi Paolo -
> 
> Should this also have a:
> 
> Fixes: 18b683bff89d ("mptcp: queue data for mptcp level retransmission")
> 
> ?

Indeed! Will send a v2 soon.

Thanks!
Paolo

