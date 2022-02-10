Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9F284B17E8
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 23:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344800AbiBJWFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 17:05:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237490AbiBJWFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 17:05:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C7411EB0
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 14:05:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644530723;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CHki4NQGix/o6xHSAHI1vc1+xjLGEOdiSoRfFNXvPi8=;
        b=PpDT6XkXf3creYyG6jbvlXe1wHUxjLTI2hqjT9tUoxoepJu4eSj/5TfXsrrz8UGqKleKr+
        8zKjLHCUHNeEgsjb7mIDBICLZqo4L57/DlM+GhknuUzP/Rr1Hok5fbfEWNaJUGd9f4zWHC
        busXz2MD1wSUnFnJmD6BfJ4fN37vEFk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-401-9GjTUw3AMCKbU_hlhpxmWA-1; Thu, 10 Feb 2022 17:05:20 -0500
X-MC-Unique: 9GjTUw3AMCKbU_hlhpxmWA-1
Received: by mail-wr1-f71.google.com with SMTP id j8-20020adfa548000000b001e33074ac51so3055639wrb.11
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 14:05:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=CHki4NQGix/o6xHSAHI1vc1+xjLGEOdiSoRfFNXvPi8=;
        b=yl1dCF4MAw8w1y10rnpT6VuKORL23Fyq7WhWqEU+kbvdgttPpjlw+tt7bNGvIVu9Eh
         fZbXk7Y6wm94oNtz5Q8EEzlINpfWfzaDzR5ssfAnTjBIXLxvyZOTKBOcXxWWMHJ5ZGqr
         EB9m98UHkXHn1KmTkPXi/sjiE4K/ySIwT540W/Rjp9Eb6bnZPGrnBULJ5n2BV+mni3S6
         FUiIBlfuQn+Yt5Yp6zgPkmSxUFNX41c9V1EDiJFl2HECN/qJPle7yqFhU0n2W+NEIhXG
         d/pKg3bJKPbx9dHHj4LJb9LlxavhqjxjwZ/8sjguMEeIqed90NAMEnKRsVluijFPAe7n
         rKIg==
X-Gm-Message-State: AOAM532lW0wAb2E7tXZsdyRk1oJ/o0DhnoM7vb0Ss3MfWEOqYfpwn4Fg
        Z4tWMyWv5EPfmmSpnuPb6TCqEbXgXatsjL28hey10L0r7Y0gE3/RO3Oja23YG6P/D2AuOvxvq3b
        +eVAogrOfkK0HsLEQ
X-Received: by 2002:adf:ed8e:: with SMTP id c14mr5846582wro.688.1644530719503;
        Thu, 10 Feb 2022 14:05:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwCXcAZE5KzedQudWeRn9dls4oSg7GDgn8W191HvOGCvVb9GnBGrQNKTte3JgfdQBUZWUt2ZQ==
X-Received: by 2002:adf:ed8e:: with SMTP id c14mr5846567wro.688.1644530719255;
        Thu, 10 Feb 2022 14:05:19 -0800 (PST)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id b25sm990992wmj.46.2022.02.10.14.05.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 14:05:18 -0800 (PST)
Date:   Thu, 10 Feb 2022 23:05:16 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH net-next] ipv6: Reject routes configurations that specify
 dsfield (tos)
Message-ID: <20220210220516.GA31389@pc-4.home>
References: <51234fd156acbe2161e928631cdc3d74b00002a7.1644505353.git.gnault@redhat.com>
 <7bbeba35-17a7-f8ba-0587-4bb1c9b6721e@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7bbeba35-17a7-f8ba-0587-4bb1c9b6721e@linuxfoundation.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 10, 2022 at 11:23:20AM -0700, Shuah Khan wrote:
> On 2/10/22 8:08 AM, Guillaume Nault wrote:
> > The ->rtm_tos option is normally used to route packets based on both
> > the destination address and the DS field. However it's ignored for
> > IPv6 routes. Setting ->rtm_tos for IPv6 is thus invalid as the route
> > is going to work only on the destination address anyway, so it won't
> > behave as specified.
> > 
> > Suggested-by: Toke Høiland-Jørgensen <toke@redhat.com>
> > Signed-off-by: Guillaume Nault <gnault@redhat.com>
> > ---
> > The same problem exists for ->rtm_scope. I'm working only on ->rtm_tos
> > here because IPv4 recently started to validate this option too (as part
> > of the DSCP/ECN clarification effort).
> > I'll give this patch some soak time, then send another one for
> > rejecting ->rtm_scope in IPv6 routes if nobody complains.
> > 
> >   net/ipv6/route.c                         |  6 ++++++
> >   tools/testing/selftests/net/fib_tests.sh | 13 +++++++++++++
> >   2 files changed, 19 insertions(+)
> > 
> > diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> > index f4884cda13b9..dd98a11fbdb6 100644
> > --- a/net/ipv6/route.c
> > +++ b/net/ipv6/route.c
> > @@ -5009,6 +5009,12 @@ static int rtm_to_fib6_config(struct sk_buff *skb, struct nlmsghdr *nlh,
> >   	err = -EINVAL;
> >   	rtm = nlmsg_data(nlh);
> > +	if (rtm->rtm_tos) {
> > +		NL_SET_ERR_MSG(extack,
> > +			       "Invalid dsfield (tos): option not available for IPv6");
> 
> Is this an expected failure on ipv6, in which case should this test report
> pass? Should it print "failed as expected" or is returning fail from errout
> is what should happen?

This is an expected failure. When ->rtm_tos is set, iproute2 fails with
error code 2 and prints
"Error: Invalid dsfield (tos): option not available for IPv6.".

The selftest redirects stderr to /dev/null by default (unless -v is
passed on the command line) and expects the command to fail and
return 2. So the default output is just:

IPv6 route with dsfield tests
    TEST: Reject route with dsfield                                     [ OK ]

Of course, on a kernel that accepts non-null ->rtm_tos, "[ OK ]"
becomes "[FAIL]", and the the failed tests couter is incremented.

> > +		goto errout;
> > +	}
> > +
> >   	*cfg = (struct fib6_config){
> >   		.fc_table = rtm->rtm_table,
> >   		.fc_dst_len = rtm->rtm_dst_len,
> > diff --git a/tools/testing/selftests/net/fib_tests.sh b/tools/testing/selftests/net/fib_tests.sh
> > index bb73235976b3..e2690cc42da3 100755
> > --- a/tools/testing/selftests/net/fib_tests.sh
> > +++ b/tools/testing/selftests/net/fib_tests.sh
> > @@ -988,12 +988,25 @@ ipv6_rt_replace()
> >   	ipv6_rt_replace_mpath
> >   }
> > +ipv6_rt_dsfield()
> > +{
> > +	echo
> > +	echo "IPv6 route with dsfield tests"
> > +
> > +	run_cmd "$IP -6 route flush 2001:db8:102::/64"
> > +
> > +	# IPv6 doesn't support routing based on dsfield
> > +	run_cmd "$IP -6 route add 2001:db8:102::/64 dsfield 0x04 via 2001:db8:101::2"
> > +	log_test $? 2 "Reject route with dsfield"
> > +}
> > +
> >   ipv6_route_test()
> >   {
> >   	route_setup
> >   	ipv6_rt_add
> >   	ipv6_rt_replace
> > +	ipv6_rt_dsfield
> >   	route_cleanup
> >   }
> > 
> 
> With the above comment addressed or explained.
> 
> Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
> 
> thanks,
> -- Shuah
> 

