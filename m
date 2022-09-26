Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24D645E9D60
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 11:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233279AbiIZJVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 05:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234450AbiIZJU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 05:20:58 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 255954332D
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 02:18:49 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d11so5661723pll.8
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 02:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=KOoggQwhdMeV4dWVMoILfCOIn7JWbGGXOyVKCJKSp8U=;
        b=A/Bsa+6pldFG1CUxyXRrWyp1uiskWu4patarf/JH1YRVzlJwBpLBeDqjiShUkN+cZO
         tQxc6sabqsxpvhk5h7nXfiPigGRSVgzSD2lbZRI/5olKXNYgFYBW4vbrRe3tuuaOsGto
         g8E+pg/LtegoV5+FXoDnNLaCJfEmIG6ksmmPApWWwJdqiM7RVw1tyRxe8dtN/K5Fyf7d
         nmsvaiQ2Pet6MZNwf5sEXtI+8YCozTLCYQL6oEdqFQzb/1b6WhngpihHjiTLu++YcKBG
         lQaCxgbjua3TIuJj0dLKgJ7vSLz9AbCOhZC9G26kkZ1skObNKR49EVxY4hqKDmqqzKay
         o20Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=KOoggQwhdMeV4dWVMoILfCOIn7JWbGGXOyVKCJKSp8U=;
        b=rXDHbA5B5nT6ND7k2jTcJFtZ/lS/9pCpNW/wzdBsMMTLZywBMS6eNetmiWJBHcWxs7
         pVapLAbBj3cARiWQcndh6wV3YNb6LSU54/4lirDckkphPLsOb8mRwMbrciE3t4joJEni
         uRZi6mQTHcU5zBG+Bt8HqqmHnuhJ0wFf3S/lrDNfzuKnfMGdQKiJ1z5y2iryps7/Z76m
         TBYbrzDZ89e4eZqO2lu/UHEEyLFz58wesPG6vYXETex2lP0/5sudiksjXUMV4gSRp1/k
         /VYt3iRN66DvbR+o95t6FTlWEyi3T/2izBA2VZ6LY7BbqWVK2NAcXIkKHEYb3odGI9GX
         B/VQ==
X-Gm-Message-State: ACrzQf18U95EMr+Z6FyYf0ob5++0bon1Bjwf7P24uuhaapSyG8Mr9lFI
        Ae2lBApe4+oHZa3ROVj+kHiHO4+nyutX6w==
X-Google-Smtp-Source: AMsMyM6sjX4FNt0X2Q5ydOHTjGHnGncqnAX9LwumKaZQIUgMtOB42+VVqByvn6NQbj14m+pGCcHc+w==
X-Received: by 2002:a17:90b:248b:b0:205:bb67:2642 with SMTP id nt11-20020a17090b248b00b00205bb672642mr3946597pjb.142.1664183877426;
        Mon, 26 Sep 2022 02:17:57 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h16-20020aa796d0000000b00540d75197f2sm11978669pfq.143.2022.09.26.02.17.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 02:17:57 -0700 (PDT)
Date:   Mon, 26 Sep 2022 17:17:49 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Guillaume Nault <gnault@redhat.com>
Subject: Re: [PATCHv2 net-next] rtnetlink: Honour NLM_F_ECHO flag in
 rtnl_{new, set, del}link
Message-ID: <YzFuPRceyLwXLUyo@Laptop-X1>
References: <20220926071246.38805-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926071246.38805-1-liuhangbin@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 26, 2022 at 03:12:46PM +0800, Hangbin Liu wrote:
> +static void rtnl_link_notify(struct net_device *dev, u32 pid,
> +			     struct nlmsghdr *nlh)
> +{
> +	struct sk_buff *skb;
> +	int err = -ENOBUFS;
> +
> +	skb = nlmsg_new(if_nlmsg_size(dev, 0), GFP_KERNEL);
> +	if (!skb)
> +		goto errout;
> +
> +	err = rtnl_fill_ifinfo(skb, dev, dev_net(dev), RTM_NEWLINK, pid,
> +			       nlh->nlmsg_seq, 0, 0, 0, 0, NULL, 0, 0,
> +			       GFP_KERNEL);
> +	if (err < 0) {
> +		/* -EMSGSIZE implies BUG in if_nlmsg_size */
> +		WARN_ON(err == -EMSGSIZE);
> +		kfree_skb(skb);
> +		goto errout;
> +	}
> +
> +	rtnl_notify(skb, dev_net(dev), pid, RTM_NEWLINK, nlh, GFP_KERNEL);
> +
> +errout:
> +	if (err < 0)
> +		rtnl_set_sk_err(dev_net(dev), RTM_NEWLINK, err);
> +}
> +

Oh, I just find there is a similar helper function rtmsg_ifinfo_build_skb().
I will check if I can just update and re-use this helper.

Thanks
Hangbin
