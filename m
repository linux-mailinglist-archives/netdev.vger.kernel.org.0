Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAA722B13AC
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 02:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgKMBII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 20:08:08 -0500
Received: from smtp.uniroma2.it ([160.80.6.22]:41594 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbgKMBIH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 20:08:07 -0500
Received: from smtpauth-2019-1.uniroma2.it (smtpauth.uniroma2.it [160.80.5.46])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 0AD16x3Q018259;
        Fri, 13 Nov 2020 02:07:04 +0100
Received: from lubuntu-18.04 (unknown [160.80.103.126])
        by smtpauth-2019-1.uniroma2.it (Postfix) with ESMTPSA id 564D5120069;
        Fri, 13 Nov 2020 02:06:54 +0100 (CET)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=uniroma2.it;
        s=ed201904; t=1605229615; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yrYG6KQlyLelFB9Xnom+xh7yVl9B18jzkFsgx0xk8IM=;
        b=OExpun4xC0HvjYNsDxt6jvLHWdkpMNUn8pzDNXlRnDgET7R3ZYnevCiM0aaGFEp3H460bR
        rOlubfwDXo2sqlAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniroma2.it; s=rsa201904;
        t=1605229615; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yrYG6KQlyLelFB9Xnom+xh7yVl9B18jzkFsgx0xk8IM=;
        b=icJi2wo1gikuUlZ1thgbHObAjBq43nE916xWVz6TZZsv5TSZaJyi4Qg+c8oWPZgFhalMP/
        DoMMBtRbGDG2rSA1RpypUDQfavTHsqu3rQWZ3MuKYuHQ5bXUOcvUjhSge+Xa6bhS/JXi4y
        CPKfwzwoR7zLr8nvkX4Jcz87ZYBPeAekppoZDkMMNTzdhb/qo0AJKkPkxQMcMztFS0V27/
        EjmYoVnV/RBO1HclKZGabwVB0F2py14RruldCsRtBd1cXqbfplf7iYepfZ3pEslv7FnHYh
        ArCujCOTb0+fffPUihmrHDmVc2PFbcZuMd4RlWF1z5058NUPltnVknPRCAM3wA==
Date:   Fri, 13 Nov 2020 02:06:53 +0100
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: Re: [net-next,v2,3/5] seg6: add callbacks for customizing the
 creation/destruction of a behavior
Message-Id: <20201113020653.088fd559cfc2a35c45b84e4c@uniroma2.it>
In-Reply-To: <20201110145655.513eab48@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201107153139.3552-1-andrea.mayer@uniroma2.it>
        <20201107153139.3552-4-andrea.mayer@uniroma2.it>
        <20201110145655.513eab48@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,
many thanks for your review. Please see my responses inline:

On Tue, 10 Nov 2020 14:56:55 -0800
Jakub Kicinski <kuba@kernel.org> wrote:

> On Sat,  7 Nov 2020 16:31:37 +0100 Andrea Mayer wrote:
> > We introduce two callbacks used for customizing the creation/destruction of
> > a SRv6 behavior. Such callbacks are defined in the new struct
> > seg6_local_lwtunnel_ops and hereafter we provide a brief description of
> > them:
> > 
> >  - build_state(...): used for calling the custom constructor of the
> >    behavior during its initialization phase and after all the attributes
> >    have been parsed successfully;
> > 
> >  - destroy_state(...): used for calling the custom destructor of the
> >    behavior before it is completely destroyed.
> > 
> > Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
> 
> Looks good, minor nits.
> 
> > diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
> > index 63a82e2fdea9..4b0f155d641d 100644
> > --- a/net/ipv6/seg6_local.c
> > +++ b/net/ipv6/seg6_local.c
> > @@ -33,11 +33,23 @@
> >  
> >  struct seg6_local_lwt;
> >  
> > +typedef int (*slwt_build_state_t)(struct seg6_local_lwt *slwt, const void *cfg,
> > +				  struct netlink_ext_ack *extack);
> > +typedef void (*slwt_destroy_state_t)(struct seg6_local_lwt *slwt);
> 
> Let's avoid the typedefs. Instead of taking a pointer to the op take a
> pointer to the ops struct in seg6_local_lwtunnel_build_state() etc.
>

Ok, I will do it this way in v3.

> > +/* callbacks used for customizing the creation and destruction of a behavior */
> > +struct seg6_local_lwtunnel_ops {
> > +	slwt_build_state_t build_state;
> > +	slwt_destroy_state_t destroy_state;
> > +};
> > +
> >  struct seg6_action_desc {
> >  	int action;
> >  	unsigned long attrs;
> >  	int (*input)(struct sk_buff *skb, struct seg6_local_lwt *slwt);
> >  	int static_headroom;
> > +
> > +	struct seg6_local_lwtunnel_ops slwt_ops;
> >  };
> >  
> >  struct bpf_lwt_prog {
> > @@ -1015,6 +1027,45 @@ static void destroy_attrs(struct seg6_local_lwt *slwt)
> >  	__destroy_attrs(attrs, 0, SEG6_LOCAL_MAX + 1, slwt);
> >  }
> >  
> > +/* call the custom constructor of the behavior during its initialization phase
> > + * and after that all its attributes have been parsed successfully.
> > + */
> > +static int
> > +seg6_local_lwtunnel_build_state(struct seg6_local_lwt *slwt, const void *cfg,
> > +				struct netlink_ext_ack *extack)
> > +{
> > +	slwt_build_state_t build_func;
> > +	struct seg6_action_desc *desc;
> > +	int err = 0;
> > +
> > +	desc = slwt->desc;
> > +	if (!desc)
> > +		return -EINVAL;
> 
> This is impossible, right?
> 

Yes, it is. I will remove this check in v3.

> > +
> > +	build_func = desc->slwt_ops.build_state;
> > +	if (build_func)
> > +		err = build_func(slwt, cfg, extack);
> > +
> > +	return err;
> 
> no need for err, just use return directly.
> 
> 	if (!ops->build_state)
> 		return 0;
> 	return ops->build_state(...);
> 

Ok, I will do it in this way in v3.

> > +}
> > +
> > +/* call the custom destructor of the behavior which is invoked before the
> > + * tunnel is going to be destroyed.
> > + */
> > +static void seg6_local_lwtunnel_destroy_state(struct seg6_local_lwt *slwt)
> > +{
> > +	slwt_destroy_state_t destroy_func;
> > +	struct seg6_action_desc *desc;
> > +
> > +	desc = slwt->desc;
> > +	if (!desc)
> > +		return;
> > +
> > +	destroy_func = desc->slwt_ops.destroy_state;
> > +	if (destroy_func)
> > +		destroy_func(slwt);
> > +}
> > +
> >  static int parse_nla_action(struct nlattr **attrs, struct seg6_local_lwt *slwt)
> >  {
> >  	struct seg6_action_param *param;
> > @@ -1090,8 +1141,16 @@ static int seg6_local_build_state(struct net *net, struct nlattr *nla,
> >  
> >  	err = parse_nla_action(tb, slwt);
> >  	if (err < 0)
> > +		/* In case of error, the parse_nla_action() takes care of
> > +		 * releasing resources which have been acquired during the
> > +		 * processing of attributes.
> > +		 */
> 
> that's the normal behavior for a kernel function, comment is
> unnecessary IMO
> 

Yes and this is the way it should be. But before this patch, the
parse_nla_action() in case of error did not always release all the acquired
resources. From this patcheset onward, the parse_nla_action() behaves like we
expect. Therefore, I will remove the comment in v3.

> >  		goto out_free;
> >  
> > +	err = seg6_local_lwtunnel_build_state(slwt, cfg, extack);
> > +	if (err < 0)
> > +		goto free_attrs;
> 
> The function is called destroy_attrs, call the label out_destroy_attrs,
> or err_destroy_attrs.
> 

Fine, I will stick with the out_destroy_attrs to be consistent and uniform with
the out_free label in v3.

> >  	newts->type = LWTUNNEL_ENCAP_SEG6_LOCAL;
> >  	newts->flags = LWTUNNEL_STATE_INPUT_REDIRECT;
> >  	newts->headroom = slwt->headroom;
> > @@ -1100,6 +1159,9 @@ static int seg6_local_build_state(struct net *net, struct nlattr *nla,
> >  
> >  	return 0;
> >  
> > +free_attrs:
> > +	destroy_attrs(slwt);
> > +
> 
> no need for empty lines on error paths
> 

Ok.

> >  out_free:
> >  	kfree(newts);
> >  	return err;
> > @@ -1109,6 +1171,8 @@ static void seg6_local_destroy_state(struct lwtunnel_state *lwt)
> >  {
> >  	struct seg6_local_lwt *slwt = seg6_local_lwtunnel(lwt);
> >  
> > +	seg6_local_lwtunnel_destroy_state(slwt);
> > +
> >  	destroy_attrs(slwt);
> >  
> >  	return;
> 

Thank you,
Andrea
