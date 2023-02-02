Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 560AB6887D7
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 20:55:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231835AbjBBTzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 14:55:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbjBBTzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 14:55:35 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17C2C1E2A1;
        Thu,  2 Feb 2023 11:55:35 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id v23so3024858plo.1;
        Thu, 02 Feb 2023 11:55:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XXzyoJpaBaepeQW/gec/uWdRUarHHGnTjkWTqnlvj+Q=;
        b=U+SgcU7joLtnGYyjI5whHYRTiIs5Rbl/OnS7TpAgkkzsLoMPRX3S8OlAgf0VdjDAdo
         SWRVHjRJve0dXNcxXdXQj03m60evskUtHGM83p1puK+x4+MP9VmmJiOrp3IgnOJqdsYW
         3FC0YIYvSZtbvt89df2M2vNoRhyLshBI65714yCNwaNgCZgNY2kiydwu7OLHjh0NqKIU
         Vwtd0Ktg6qOF0J7BEP53DGciDFn7LQC7N+bNw0VMWGlQjOxy4JJCW/xQ0L2o4lg9AgRa
         6M5mSYMAwuB8uT+JW3M4qymqeiGlRxtGkfjsHSdpBGPXJh7mxjtD2xjDMl/BTWvlmUrX
         iIIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XXzyoJpaBaepeQW/gec/uWdRUarHHGnTjkWTqnlvj+Q=;
        b=6ygW7zFEh5x+cQ5CNyPZFpugRxEmmleVBm6LGfc2YhUTRHQ8KeOnjAYajiqler5zab
         3Z60b3fF9Ov5yWtnKaS5pRl88j5lb4i+D6qIuYQZlEHZmcyRq4O6lO7XsUSv0QFcTRgx
         IvrKhDlZDjrHuwvuDTsZCsgK7HFH4g4/3vc240H1k1iCQFAYhSclGHd7sgQt0CIm4bTi
         TSUMRohJMS831vWcdw/bLm+ifa6v0UHxZR44/avViNzD8wkBX9pbdtGIElAeFQzeRhGc
         Le1preZ6k05by1bIdlGRhvoAW00+/w3RmYC8K8mVTT9XNfom7Jvet+kcfdRpkz1dkbZo
         Nr6w==
X-Gm-Message-State: AO0yUKWrAstwEMN9+8tZmCe9OXfFmt4GTOBGAvwQ5Hf3l8N/4BMnC+sn
        EnmBuSMrLJqqlhRrnU47DlA=
X-Google-Smtp-Source: AK7set/EdT6UKAqV0iniNQUqUFO9TPcZ+oh2aj4hEqE7B/1f4U46BLnD8kb4m048j76SiJEfQLwWSg==
X-Received: by 2002:a17:903:1111:b0:196:ea4:c261 with SMTP id n17-20020a170903111100b001960ea4c261mr8709278plh.1.1675367734404;
        Thu, 02 Feb 2023 11:55:34 -0800 (PST)
Received: from ip-172-31-38-16.us-west-2.compute.internal (ec2-52-37-71-140.us-west-2.compute.amazonaws.com. [52.37.71.140])
        by smtp.gmail.com with ESMTPSA id n3-20020a170902dc8300b00198c41d0c86sm43922pld.239.2023.02.02.11.55.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 11:55:33 -0800 (PST)
Date:   Thu, 2 Feb 2023 19:55:32 +0000
From:   Alok Tiagi <aloktiagi@gmail.com>
To:     Hillf Danton <hdanton@sina.com>
Cc:     ebiederm@xmission.com, edumazet@google.com, netdev@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] net: add new socket option SO_SETNETNS
Message-ID: <Y9wVNF5IBCYVz5jU@ip-172-31-38-16.us-west-2.compute.internal>
References: <Y9q8Ec1CJILZz7dj@ip-172-31-38-16.us-west-2.compute.internal>
 <20230202014810.744-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202014810.744-1-hdanton@sina.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 09:48:10AM +0800, Hillf Danton wrote:
> On Wed, 1 Feb 2023 19:22:57 +0000 aloktiagi <aloktiagi@gmail.com>
> > @@ -1535,6 +1535,52 @@ int sk_setsockopt(struct sock *sk, int level, int optname,
> >  		WRITE_ONCE(sk->sk_txrehash, (u8)val);
> >  		break;
> >  
> > +	case SO_SETNETNS:
> > +	{
> > +		struct net *other_ns, *my_ns;
> > +
> > +		if (sk->sk_family != AF_INET && sk->sk_family != AF_INET6) {
> > +			ret = -EOPNOTSUPP;
> > +			break;
> > +		}
> > +
> > +		if (sk->sk_type != SOCK_STREAM && sk->sk_type != SOCK_DGRAM) {
> > +			ret = -EOPNOTSUPP;
> > +			break;
> > +		}
> > +
> > +		other_ns = get_net_ns_by_fd(val);
> > +		if (IS_ERR(other_ns)) {
> > +			ret = PTR_ERR(other_ns);
> > +			break;
> > +		}
> > +
> > +		if (!ns_capable(other_ns->user_ns, CAP_NET_ADMIN)) {
> > +			ret = -EPERM;
> > +			goto out_err;
> > +		}
> > +
> > +		/* check that the socket has never been connected or recently disconnected */
> > +		if (sk->sk_state != TCP_CLOSE || sk->sk_shutdown & SHUTDOWN_MASK) {
> > +			ret = -EOPNOTSUPP;
> > +			goto out_err;
> > +		}
> > +
> > +		/* check that the socket is not bound to an interface*/
> > +		if (sk->sk_bound_dev_if != 0) {
> > +			ret = -EOPNOTSUPP;
> > +			goto out_err;
> > +		}
> > +
> > +		my_ns = sock_net(sk);
> > +		sock_net_set(sk, other_ns);
> > +		put_net(my_ns);
> > +		break;
> 
> 		cpu 0				cpu 2
> 		---				---
> 						ns = sock_net(sk);
> 		my_ns = sock_net(sk);
> 		sock_net_set(sk, other_ns);
> 		put_net(my_ns);
> 						ns is invalid ?

That is the reason we want the socket to be in an un-connected state. That
should help us avoid this situation.

> 
> > +out_err:
> > +		put_net(other_ns);
> > +		break;
> > +	}
> > +
> >  	default:
> >  		ret = -ENOPROTOOPT;
> >  		break;
