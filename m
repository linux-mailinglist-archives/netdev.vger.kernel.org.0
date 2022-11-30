Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2488763D0FF
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 09:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234406AbiK3Ip1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 03:45:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236772AbiK3IpC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 03:45:02 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6CFC2AE37
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 00:44:50 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id o5-20020a17090a678500b00218cd5a21c9so1263361pjj.4
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 00:44:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HpaGoTbgjMNHPHyQnxAMVb3PqfvEuN/YEzGCOHYLMj8=;
        b=Cebl0r0TFb7RT/YNXgUmbxkFPWN48Apf3dwxAMplMI5GDEMU267JSf/phbf3j/BLeF
         3Vo2T7u/MEUuTel+bIOPijdm87JuneKpULrEZwYvoPJnDpPEKTYza2I9dqLHRIqWeVlc
         Mw2LC7rpsiL992bjUvwvXEWFl+vU+FZ3F8zsJ3Oao+0h52w/pR7A7fIVK5NLOL36yVFo
         Q5L0e26el+Q4EC/fLPs8pFX0EJp0taHgnaK0H/EZ+x7kcpZ/fq52pdXeJz0WsvnV+r86
         JkDpREo2eil/J3lnWy/QA2mRQ0EwLgvj14zMHduBUZeXz9Fng3U74Qkpx6qBBuXQmf1c
         KoXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HpaGoTbgjMNHPHyQnxAMVb3PqfvEuN/YEzGCOHYLMj8=;
        b=3ejW2++4Zg96DPT7Sm6cWJk2KDbL4oi6LC2Pez53hw+5VekfoNb9UdwBBeHV0ad5W5
         LpXvn5GFojlRCDDURJVn+7SNjSggmVAHDEa7mBpjTTatrfzzSt8Ib+bp9prYs/KcIEEn
         3QaJyU1C9sZjb4kvkx+6W1yS90nHzroXGywOM6eFwEiAHosAs6EXB8PfgNq964DkZCuB
         hJc6y/Bz4WEZtAYZxNt0zeaos2ZtNYjT/2NQOy69yEn3Uce5QX0v9QT+XRs6EsLNRRXl
         8dz7j9H12P+Ck3jZRVh/34CAF4uddiGIQBr2UV7TLuQSQNxHdgr1Mcd+9kMkkbsvQQ7u
         qWsw==
X-Gm-Message-State: ANoB5pm5kJJPqiBPMmb140qWHAfC+ffUdzk+peeWOE0BBihvFcWc237c
        jGUrfdyenNOFGicidr5xs+Q=
X-Google-Smtp-Source: AA0mqf5vtlpTxsPEdyOCRr1IFXS4oBW6ODI5Lz+PEH4aDugVnKtrfQetSr4mTf/MsWcBvbMddZQq0w==
X-Received: by 2002:a17:90a:c7d5:b0:219:63d9:d0ff with SMTP id gf21-20020a17090ac7d500b0021963d9d0ffmr2201647pjb.225.1669797890057;
        Wed, 30 Nov 2022 00:44:50 -0800 (PST)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c11-20020a170903234b00b00186ff402525sm797792plh.213.2022.11.30.00.44.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 00:44:48 -0800 (PST)
Date:   Wed, 30 Nov 2022 16:44:43 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH (repost) net-next] sched: add extack for tfilter_notify
Message-ID: <Y4cX+5n98XxFBp8o@Laptop-X1>
References: <CAM0EoMm1Jx3mcGJK_XasTpVjm7uGHzVXhXN8=MAQUExJhuPFvw@mail.gmail.com>
 <20221110092709.06859da9@kernel.org>
 <Y3MCaaHoMeG7crg5@Laptop-X1>
 <20221114205143.717fd03f@kernel.org>
 <Y3OJucOnuGrBvwYM@Laptop-X1>
 <CAM0EoMmiGBb1B=mYyG1FEvX7RRh+UvTFwguuEy9UwBPg2Jd0KA@mail.gmail.com>
 <Y3Oa1NRF9frEiiZ3@Laptop-X1>
 <CAM0EoMk_LdcSLAeQ8kLTaWNDXFe7HgBcOxZpDPtk68+TdER-Zg@mail.gmail.com>
 <Y4W9qEHzg5h9n/od@Laptop-X1>
 <20221129074320.7c15bcf5@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129074320.7c15bcf5@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 29, 2022 at 07:43:20AM -0800, Jakub Kicinski wrote:
> On Tue, 29 Nov 2022 16:07:04 +0800 Hangbin Liu wrote:
> > +unsigned int get_nlgroup(__u16 nlmsg_type)
> > +{
> > +	switch (nlmsg_type) {
> > +	case RTM_NEWTFILTER:
> > +	case RTM_DELTFILTER:
> > +	case RTM_NEWCHAIN:
> > +	case RTM_DELCHAIN:
> > +	case RTM_NEWTCLASS:
> > +	case RTM_DELTCLASS:
> > +	case RTM_NEWQDISC:
> > +	case RTM_DELQDISC:
> > +	case RTM_GETACTION:
> > +	case RTM_NEWACTION:
> > +	case RTM_DELACTION:
> > +		return RTNLGRP_TC;
> > +	}
> 
> These are rtnl message ids, they don't belong in af_netlink.

Oh, thanks very much! Now I got what Jamal said the
"namespace collision for attributes". I will see where we should
put the new helper.

Hangbin
