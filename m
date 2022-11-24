Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBB9637EB4
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 18:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbiKXR5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 12:57:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbiKXR5G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 12:57:06 -0500
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DF282EA;
        Thu, 24 Nov 2022 09:57:04 -0800 (PST)
Received: by mail-oo1-xc29.google.com with SMTP id j1-20020a4ad181000000b0049e6e8c13b4so358040oor.1;
        Thu, 24 Nov 2022 09:57:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EWkI3BxKgt1nZH4lZZdqPXwCE/u/6qD30xSf8+fdkEQ=;
        b=qKt15BbemeisSsBLoAZH1nJmUbhQjqlYvWZVfXxFOAKDzcMaxI3T8kUrEFvd+HkjVB
         0+F6ZhuH4GfMtnWhYIAk1nYGUvJJ3Ml6zQINWJ9/PLvuFVvIEQW0NGAW5m4E3hQHfuv2
         WVyQ76BSbaHUh+IA1Nh3+oWtCEcJcQ+ILngnvl/Jx7m8+WgXmj5uNNoBubJZHywvpglV
         eTY4pJraGxbkGbJNRK9Nxn1aFW+HU4fCT7ubvUXdpN96GDXid4QR2sb3C2gBw2lyPa+q
         vETlqgj4PBimJnSmDGK8LTsUf2i6RSDYziELTd+i0EAE0Hs/L6wAwND6Y6QYMZjwSUWl
         JNYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EWkI3BxKgt1nZH4lZZdqPXwCE/u/6qD30xSf8+fdkEQ=;
        b=stx4U8IQAn+GfBhhpEKnA66wmEnsUFTCALiZjSdaZ5Cvdbqu9yE05OZLsFOpAJj+gC
         +aZJU4cstLaZX9/2mEVy+ZYMPXOn8a8dN8aRHFDPo4dLa9YIFniQ3t7TV/enBdg7Q6ib
         xY7sGpA93Q1nnryznapGCacmODC0w8G5kyuHWsSUKFomDL8Aznk8RRDEYRcXKjx0yna9
         YT4PIi3P8et3bP/o6FZH+gAjNMPcg0CkG/nvIzostGkwejogoy7z/OsU1+lvcZ4wIaKP
         QRtJr8PjyziUpBCZKriKGlx9rST7jXR8UrKSMvrI4kHE94t1qMX58ilHQVznIr17dlOM
         jq5A==
X-Gm-Message-State: ANoB5pmdL1eR+9c/K0gqAywlhFQPl6hM6JB/8sHVIzPqloRDHi1UNmIp
        eRCY2INWngTeoQtF68f9XtA=
X-Google-Smtp-Source: AA0mqf7a4uLgVcn0JmjTvstBjq0EIIUSBDC01bgTBMPR3u5p0U9n71kv1/Y48w7CAJagGYCiCQDX1g==
X-Received: by 2002:a4a:ded5:0:b0:49e:e931:11f7 with SMTP id w21-20020a4aded5000000b0049ee93111f7mr7953271oou.73.1669312623449;
        Thu, 24 Nov 2022 09:57:03 -0800 (PST)
Received: from t14s.localdomain ([2001:1284:f013:8471:4ef9:baca:5f1a:c3fc])
        by smtp.gmail.com with ESMTPSA id t12-20020a056870e74c00b001375188dae9sm857836oak.16.2022.11.24.09.57.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 09:57:02 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 45FA64678A4; Thu, 24 Nov 2022 14:57:00 -0300 (-03)
Date:   Thu, 24 Nov 2022 14:57:00 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Firo Yang <firo.yang@suse.com>
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com, mkubecek@suse.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        firogm@gmail.com
Subject: Re: [PATCH 1/1] sctp: sysctl: referring the correct net namespace
Message-ID: <Y3+wbPhEAyPIUpbM@t14s.localdomain>
References: <20221123094406.32654-1-firo.yang@suse.com>
 <Y34ZVEeSryB0UTFD@t14s.localdomain>
 <Y38PUmjeFWApHnrh@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y38PUmjeFWApHnrh@suse.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 24, 2022 at 02:29:38PM +0800, Firo Yang wrote:
> The 11/23/2022 10:00, Marcelo Ricardo Leitner wrote:
> > On Wed, Nov 23, 2022 at 05:44:06PM +0800, Firo Yang wrote:
> > > Recently, a customer reported that from their container whose
> > > net namespace is different to the host's init_net, they can't set
> > > the container's net.sctp.rto_max to any value smaller than
> > > init_net.sctp.rto_min.
> > > 
> > > For instance,
> > > Host:
> > > sudo sysctl net.sctp.rto_min
> > > net.sctp.rto_min = 1000
> > > 
> > > Container:
> > > echo 100 > /mnt/proc-net/sctp/rto_min
> > > echo 400 > /mnt/proc-net/sctp/rto_max
> > > echo: write error: Invalid argument
> > > 
> > > This is caused by the check made from this'commit 4f3fdf3bc59c
> > > ("sctp: add check rto_min and rto_max in sysctl")'
> > > When validating the input value, it's always referring the boundary
> > > value set for the init_net namespace.
> > > 
> > > Having container's rto_max smaller than host's init_net.sctp.rto_min
> > > does make sense. Considering that the rto between two containers on the
> > > same host is very likely smaller than it for two hosts.
> > 
> > Makes sense. And also, here, it is not using the init_net as
> > boundaries for the values themselves. I mean, rto_min in init_net
> > won't be the minimum allowed for rto_min in other netns. Ditto for
> > rto_max.
> > 
> > More below.
> > 
> > > 
> > > So to fix this problem, just referring the boundary value from the net
> > > namespace where the new input value came from shold be enough.
> > > 
> > > Signed-off-by: Firo Yang <firo.yang@suse.com>
> > > ---
> > >  net/sctp/sysctl.c | 6 ++++++
> > >  1 file changed, 6 insertions(+)
> > > 
> > > diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
> > > index b46a416787ec..e167df4dc60b 100644
> > > --- a/net/sctp/sysctl.c
> > > +++ b/net/sctp/sysctl.c
> > > @@ -429,6 +429,9 @@ static int proc_sctp_do_rto_min(struct ctl_table *ctl, int write,
> > >  	else
> > >  		tbl.data = &net->sctp.rto_min;
> > >  
> > > +	if (net != &init_net)
> > > +		max = net->sctp.rto_max;
> > 
> > This also affects other sysctls:
> > 
> > $ grep -e procname -e extra sysctl.c | grep -B1 extra.*init_net
> >                 .extra1         = SYSCTL_ONE,
> >                 .extra2         = &init_net.sctp.rto_max
> >                 .procname       = "rto_max",
> >                 .extra1         = &init_net.sctp.rto_min,
> > --
> >                 .extra1         = SYSCTL_ZERO,
> >                 .extra2         = &init_net.sctp.ps_retrans,
> >                 .procname       = "ps_retrans",
> >                 .extra1         = &init_net.sctp.pf_retrans,
> > 
> > And apparently, SCTP is the only one doing such dynamic limits. At
> > least in networking.
> > 
> > While the issue you reported is fixable this way, for ps/pf_retrans,
> > it is not, as it is using proc_dointvec_minmax() and it will simply
> > consume those values (with no netns translation).
> > 
> > So what about patching sctp_sysctl_net_register() instead, to update
> > these pointers during netns creation? Right after where it update the
> > 'data' one in there:
> > 
> >         for (i = 0; table[i].data; i++)
> >                 table[i].data += (char *)(&net->sctp) - (char *)&init_net.sctp;
> 
> Thanks Marcelo. It's better. So you mean something like the following?

Yes,

> 
> --- a/net/sctp/sysctl.c
> +++ b/net/sctp/sysctl.c
> @@ -586,6 +586,11 @@ int sctp_sysctl_net_register(struct net *net)
>         for (i = 0; table[i].data; i++)
>                 table[i].data += (char *)(&net->sctp) - (char *)&init_net.sctp;
>  
> +#define SCTP_RTO_MIN_IDX 1
> +#define SCTP_RTO_MAX_IDX 2

But these should be together with the sysctl table definition, so we
don't forget to update it later on if needed.

> +       table[SCTP_RTO_MIN_IDX].extra2 = &net->sctp.rto_max;
> +       table[SCTP_RTO_MAX_IDX].extra1 = &net->sctp.rto_min;

And also the ps/pf_retrans. :-)

> +
>         net->sctp.sysctl_header = register_net_sysctl(net, "net/sctp", table);
>         if (net->sctp.sysctl_header == NULL) {
>                 kfree(table);
> 
> 
> > 
> > Thanks,
> > Marcelo
> > 
> > > +
> > >  	ret = proc_dointvec(&tbl, write, buffer, lenp, ppos);
> > >  	if (write && ret == 0) {
> > >  		if (new_value > max || new_value < min)
> > > @@ -457,6 +460,9 @@ static int proc_sctp_do_rto_max(struct ctl_table *ctl, int write,
> > >  	else
> > >  		tbl.data = &net->sctp.rto_max;
> > >  
> > > +	if (net != &init_net)
> > > +		min = net->sctp.rto_min;
> > > +
> > >  	ret = proc_dointvec(&tbl, write, buffer, lenp, ppos);
> > >  	if (write && ret == 0) {
> > >  		if (new_value > max || new_value < min)
> > > -- 
> > > 2.26.2
> > > 
