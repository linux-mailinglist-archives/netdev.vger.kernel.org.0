Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2F3C17EBD7
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 23:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgCIWT6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 18:19:58 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:36741 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726536AbgCIWT6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 18:19:58 -0400
Received: by mail-qk1-f195.google.com with SMTP id u25so10953110qkk.3
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 15:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=OligLwgScnJTn7Jfo8bzBKsT8jXNOqM58vCpTRbHS+k=;
        b=KdVfMzix+TGQmZHmjPzNgFfmbVb9KrXM5R4zggUGbwC48c50nWMVIc378uCAy65H6F
         EHO25kjIaVxGs8yng7AUZpdOBx+hUQdjPKue7wGH0J/KOEB+ytYnyN6z9qBm+/4l2cu7
         0ecBdNu0t04fEMd8Wa7bMZd+P7VbeO2l/uw73CjUhaKFMZghagBo7xhXYCs2oKQiwhLp
         Lzw2RFwXT4W90IQjY3Xw2VIUT6iauELzdlZ5te0yBsWtJ4goeO6q3HMGcp2DKbct1NkF
         h+MjyY46C5nFwwDYlQxDVd6XYVDelabMtVGqULBrOa32yj1ar5dcG7T1ilEz0OLfUeO2
         iPkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=OligLwgScnJTn7Jfo8bzBKsT8jXNOqM58vCpTRbHS+k=;
        b=k0W3uVzIycm0NtxigLPb9WeQN+bPuCeCqgZJ4YlosYqoSF3CwK/LU6K+DtvzRybsSN
         whN8Apw9eQzWwuLRCSDeutLo/BREineBXa/wFUUuP2is5bFIkCD6hOhDOhy9WGe6z8e1
         wbDTzK3BBB/aiPRTIMOJJZ5n5fl8AuDOL/kpDeb2eY9/xHzxvaz9emfFma+ipzTsB+WI
         wb40zwzCa1+OWvMQjYDl+/l1WpzZAF2thIpGglijT3+44Zxz9WbZ/UCmAWQ0aMYFtqqC
         fw5pRBxpHlidyuyRGdrpumZ+lKRaIundk9jfDfJ6jS7Pbr5IQpbooAqK3+HHHCzRF4LC
         igJg==
X-Gm-Message-State: ANhLgQ3qFRaStaNvFM8uAJcWBV8/QmLwQc71BsRXRqhcrXsyzI8RjBXX
        ym1+tk4GxzKWtngAgmxsw6gHgBcVIa8=
X-Google-Smtp-Source: ADFU+vvEk2PT0cKEfOW3UGA2ft04BoqURx1z7GR4GGo3BmRJNZFWL8A1rebIKzxKd7OdmDbGnerVbQ==
X-Received: by 2002:a37:a38b:: with SMTP id m133mr7774001qke.278.1583792397008;
        Mon, 09 Mar 2020 15:19:57 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f028:aa40:30e3:a413:313c:50ab])
        by smtp.gmail.com with ESMTPSA id a21sm2420398qtp.25.2020.03.09.15.19.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 15:19:56 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id C0EB0C314F; Mon,  9 Mar 2020 19:19:53 -0300 (-03)
Date:   Mon, 9 Mar 2020 19:19:53 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Edward Cree <ecree@solarflare.com>
Cc:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: Re: [PATCH net-next ct-offload v2 05/13] net/sched: act_ct: Enable
 hardware offload of flow table entires
Message-ID: <20200309221953.GJ2546@localhost.localdomain>
References: <1583676662-15180-1-git-send-email-paulb@mellanox.com>
 <1583676662-15180-6-git-send-email-paulb@mellanox.com>
 <62d6cfde-5749-b2d6-ee04-d0a49b566d1a@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <62d6cfde-5749-b2d6-ee04-d0a49b566d1a@solarflare.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 09, 2020 at 09:25:49PM +0000, Edward Cree wrote:
> On 08/03/2020 14:10, Paul Blakey wrote:
> > Pass the zone's flow table instance on the flow action to the drivers.
> > Thus, allowing drivers to register FT add/del/stats callbacks.
> >
> > Finally, enable hardware offload on the flow table instance.
> >
> > Signed-off-by: Paul Blakey <paulb@mellanox.com>
> > Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> > ---
> > <snip>
> > diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> > index 84d5abf..d52185d 100644
> > --- a/net/sched/act_ct.c
> > +++ b/net/sched/act_ct.c
> > @@ -292,6 +292,7 @@ static int tcf_ct_flow_table_get(struct tcf_ct_params *params)
> >  		goto err_insert;
> >  
> >  	ct_ft->nf_ft.type = &flowtable_ct;
> > +	ct_ft->nf_ft.flags |= NF_FLOWTABLE_HW_OFFLOAD;
> >  	err = nf_flow_table_init(&ct_ft->nf_ft);
> >  	if (err)
> >  		goto err_init;
> > @@ -299,6 +300,7 @@ static int tcf_ct_flow_table_get(struct tcf_ct_params *params)
> >  	__module_get(THIS_MODULE);
> >  take_ref:
> >  	params->ct_ft = ct_ft;
> > +	params->nf_ft = &ct_ft->nf_ft;
> >  	ct_ft->ref++;
> >  	spin_unlock_bh(&zones_lock);
> This doesn't seem to apply to net-next (34a568a244be); the label after
>  the __module_get() is 'out_unlock', not 'take_ref'.  Is there a missing
>  prerequisite patch?  Or am I just failing to drive 'git am' correctly?

That's a mid-air collision with Eric's
[PATCH net-next] net/sched: act_ct: fix lockdep splat in tcf_ct_flow_table_get
That went in in between v1 and v2 here.

  Marcelo
