Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52DFB4D4CEE
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 16:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbiCJPe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 10:34:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiCJPe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 10:34:57 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC6A158D9C;
        Thu, 10 Mar 2022 07:33:56 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id qt6so12866267ejb.11;
        Thu, 10 Mar 2022 07:33:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ThJhg7Y6Zed5e0dNMLyGm4kfVIWPYT9T3lVpOytMe3c=;
        b=EABUOsH74nrjCWZ3rd8ZuNqM1VulsQ817y/y7YxvUqhpfJuzjYB2EQpSGzn6BR+EO0
         pjM/dm9dJLVHBXtNmKVKbyeOedrs+St7dxELgE62rEDT049uhCRMhHvwhDNk3KMKahJE
         ZCgmti7srzFV9ZlluZ8DQrfm+2T8jAV1h9KYIwAeL97r9f23I+ILkRLlmVnb/gqFCZDk
         vVMwXtijc4lCNQ6pZ011a/XALM2E+oY4zqzr7p7q8dVEDqUjZQOzTpABQhOVVRTA3cVw
         91d1JZIuuq7iOzQGVIG57bg6hXuRgH+Koto8Gcj5o1WwPyX4oaNP44VOBhop1klLfMYy
         QA4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ThJhg7Y6Zed5e0dNMLyGm4kfVIWPYT9T3lVpOytMe3c=;
        b=GVq6mvZxymVGoz8ywkIgrTXTWjKWaQwx89J2dJqEM2C43HLBEKWUqMNnRPUtot5h9Z
         PqJ7vhLjls26xRWYPwGVFvRvlszyxK2REl3HXVHKhioDNUnQCrJhCJF8/LFvFyfu9Ayb
         2Wm0mJB34ml2p1MrZkHGQk1MgfDHi/hI4nkH+KGpzPkJOyML1mOOI5O3kHyE6D2zUdw4
         1Dv5ivCc73Tc/uCl9sXmytL1mdE3iL/Fc9be1hbftKHXSNMXxDxfWfYBxjC4T3mx68YG
         R/en+u3E0px48gCQsJSfcGZ6XPYQoGMi9fQJ0XbXjPQURJFFadvign2XlnQa8x0QBXS6
         DpaQ==
X-Gm-Message-State: AOAM533dfEwYbdDW5vBPbct+FMMSUollnxO05txO/AeK7ZrVuUAwKvWH
        eBcG0OhF4bpKEz9DV8vcJK8=
X-Google-Smtp-Source: ABdhPJx8Iw8MOc4J5cjsPoybwEFWcfZR4f2P+yj07EUWc5W0JxDPt4LapoCI1G0FWWgQflpE6+LsOw==
X-Received: by 2002:a17:907:3f0d:b0:6da:8413:9eb8 with SMTP id hq13-20020a1709073f0d00b006da84139eb8mr4743924ejc.280.1646926435326;
        Thu, 10 Mar 2022 07:33:55 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id m25-20020a170906161900b006d43be5b95fsm1932512ejd.118.2022.03.10.07.33.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 07:33:54 -0800 (PST)
Date:   Thu, 10 Mar 2022 17:33:53 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Petr Machata <petrm@nvidia.com>,
        Cooper Lees <me@cooperlees.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH v2 net-next 10/10] net: dsa: mv88e6xxx: MST Offloading
Message-ID: <20220310153353.s6dejcapieltpqpu@skbuf>
References: <20220301100321.951175-1-tobias@waldekranz.com>
 <20220301100321.951175-11-tobias@waldekranz.com>
 <20220303222658.7ykn6grkkp6htm7a@skbuf>
 <87k0d1n8ko.fsf@waldekranz.com>
 <20220310152547.etuov6kpqotnyv2p@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220310152547.etuov6kpqotnyv2p@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 10, 2022 at 05:25:47PM +0200, Vladimir Oltean wrote:
> > >> +	err = mv88e6xxx_sid_get(chip, attr->orig_dev, vattr->msti, &new_sid);
> > >> +	if (err)
> > >> +		goto unlock;
> > >> +
> > >> +	if (vlan.sid) {
> > >> +		err = mv88e6xxx_sid_put(chip, vlan.sid);
> > >> +		if (err)
> > >> +			goto unlock;
> > >> +	}
> > >> +
> > >> +	vlan.sid = new_sid;
> > >> +	err = mv88e6xxx_vtu_loadpurge(chip, &vlan);
> > >
> > > Maybe you could move mv88e6xxx_sid_put() after this succeeds?
> > 
> > Yep. Also made sure to avoid needless updates of the VTU entry if it
> > already belonged to the correct SID.
> 
> I realize I gave you conflicting advice here, first with inverting the
> refcount_inc() with the refcount_dec(), then with having fast handling
> of noop-changes to vlan.sid. I hope you're able to make some sense out
> of that and avoid the obvious issue with the refcount temporarily
> dropping to zero before going back to 1, which makes the sanity checker
> complain.

Oh wow... I didn't look at the code again, and commented based on a
false memory. Disregard, sorry. You aren't reversing sid_get with sid_put,
nor did I suggest that. There's a lot that happened just in my head,
apparently.
