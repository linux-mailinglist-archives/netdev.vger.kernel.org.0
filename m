Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 080052F718F
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 05:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732999AbhAOESp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 23:18:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727674AbhAOESo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 23:18:44 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88831C061575;
        Thu, 14 Jan 2021 20:18:03 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id w2so4666128pfc.13;
        Thu, 14 Jan 2021 20:18:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0QkIweyTpCRSZetj1iFXQpayDIRewARy2rsiCveZMek=;
        b=bpwtO89Smj5uy6BkWsN0DlmUNpkRf5wM9WyrbGLQbHyauAIkHchUJs5eUAkGsQwihs
         jFB+7kcxDfwlTmYcyHPMVlEW742JRN8e4GtPwXiW5bOpAQTKba2G4FOTHLjZiKcbTzzw
         X5cIMOSSo5o1lndpW91hxD6XB+i+fUQJRHmyfNzqGaEDDC8AuxIAUlBXJL92ONAFYy7E
         BEhiSDE0f33yPjzQ2/ycvZETwD8IrxMLGHqsc9TdPJZLaQfiCWJq313JtLAz3/kcqIJC
         reaM4mm6veX96rRcA1dY5ulq9LNkKnEC61lIzFCxE+9CfsVYX7vbUXcC33rCalAZcpXs
         JGJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0QkIweyTpCRSZetj1iFXQpayDIRewARy2rsiCveZMek=;
        b=FMD/71qo1I2ippP/YhV1ZRyYJWFh5kvzLX9fa7BZ3GuY60NZvQkPNr5wruqfkJmJfi
         mcm0PgsJUbGf3bWoqqtiB3UqKTdrNFq/k0crt+QHBR3+QKwYZHI/iBGR+FlJqWRnDN9K
         JzFu1OMrdyc36DG4k1FSGvhb8otscCHuL57sGdSPYFdA5pbitv2oHlNIFoihuVBsQ4dF
         Kslp+UPoGHeSPbTVf5D1D8fovXXNZsuMIX8pYb3ARsTUhzHaGtFqp9PnBQa77jLQ5zsT
         l9E7JCoduJ2cPJOJhlc1A+QbtAx6pkwEsmYMtamk2LvO/6I4p17Rh7QtFO9Q6Vr/W0vR
         vGVQ==
X-Gm-Message-State: AOAM532L2+nj/5TiorUrZpYENKEx3RGY3PwI3cxoWTGS61LhsIK1b4gm
        1QJPCyURJ2bNnuhb+sbWCV1IKXGJkkw/u7DP
X-Google-Smtp-Source: ABdhPJw5r0hUtvArF8ft747JXD9wUxTya4A8sSBUvvi43Vbscm+XKrmX9DwpZPVfnyagP8z/LuTNrg==
X-Received: by 2002:a65:4bc2:: with SMTP id p2mr10769381pgr.169.1610684283125;
        Thu, 14 Jan 2021 20:18:03 -0800 (PST)
Received: from Leo-laptop-t470s ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x14sm6608634pfp.77.2021.01.14.20.17.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 20:18:02 -0800 (PST)
Date:   Fri, 15 Jan 2021 12:17:51 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Subject: Re: [PATCHv6 bpf-next] samples/bpf: add xdp program on egress for
 xdp_redirect_map
Message-ID: <20210115041751.GD1421720@Leo-laptop-t470s>
References: <20201211024049.1444017-1-liuhangbin@gmail.com>
 <20210114142732.2595651-1-liuhangbin@gmail.com>
 <4d9b5846-bd08-09b4-53a2-3cb02a9a1eee@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d9b5846-bd08-09b4-53a2-3cb02a9a1eee@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yonghong,
On Thu, Jan 14, 2021 at 01:01:28PM -0800, Yonghong Song wrote:
> > +/* map to stroe egress interface mac address */
> 
> s/stroe/store

Thanks, I will fix it.
> > -	struct bpf_program *prog, *dummy_prog;
> > +	struct bpf_program *prog, *dummy_prog, *devmap_prog;
> > +	int devmap_prog_fd_0 = -1, devmap_prog_fd_1 = -1;
> 
> The default value is -1 here. I remembered there was a discussion
> about the default value here, does default value 0 work here?

I didn't saw the discussion. But 0 should works as in __dev_map_alloc_node
it only gets the prog when fd > 0.

static struct bpf_dtab_netdev *__dev_map_alloc_node(struct net *net,
                                                    struct bpf_dtab *dtab,
                                                    struct bpf_devmap_val *val,
                                                    unsigned int idx)
{
	...
	if (val->bpf_prog.fd > 0) {
		prog = bpf_prog_get_type_dev(val->bpf_prog.fd,
				BPF_PROG_TYPE_XDP, false);
		if (IS_ERR(prog))
			goto err_put_dev;
		if (prog->expected_attach_type != BPF_XDP_DEVMAP)
			goto err_put_prog;
	}
	...
}

> > +	if (xdp_flags & XDP_FLAGS_SKB_MODE) {
> > +		prog = bpf_object__find_program_by_title(obj, "xdp_redirect_general");
> 
> libbpf supports each section having multiple programs, so
> bpf_object__find_program_by_title() is not recommended.
> Could you change to bpf_object__find_program_by_name()?

Thanks for this reminder, I will fix it.

Thanks
Hangbin
