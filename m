Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 811E92F10C0
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 12:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728350AbhAKLER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 06:04:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbhAKLER (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 06:04:17 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4669C061786
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 03:03:36 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id j16so18403072edr.0
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 03:03:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1tg3lBgYu/JP3tg8NqJc/YjHjKsbmhHnUe6N58yjhP8=;
        b=I4dq83lT0GdUtXxm0jPLeGke0XfUZEAfdUUIfHRHCIr2LuM+K3fhDf/CR7bO9oZbFy
         H+XOdT9GgiFomj9aoPr/mHaqLJTWgaMn5JkmtarVd03k5QPOuvNAIwAPLjcXtHUeHLCN
         STQCtLSz03A7ON+Qs7sPVmw5JAFBfC63CInwBHM/KB0ydaRJDJRp2rL+k+fGl2cr8v/G
         wUS71QVrYGqG4Hpj/JcoEigi7oSmJlHKePI6Rp/cgtvTzLCRbFmt9M5HXNnyb5MgV7FN
         o5RTVOhY41Q7TvgMTRGZ8gqE7lrxxyRjbk4iNylEvu6ikBjle+2c95Q7dQ//IrTPd/yE
         AvLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1tg3lBgYu/JP3tg8NqJc/YjHjKsbmhHnUe6N58yjhP8=;
        b=Dw9/lmcSgqvjNfMKCChHtT2GW+5mKSrNe0WlHyjmXkderfulw2482z8WJmP5dL0tXp
         AyBOJDc5BMSr8nw8GjMgMMiGObbX+nVo6Td4eeRlnJkZQ3fNJcOkHFtoF2593A0Zpsoa
         f9g3uIpfXpm9ciUqY1r00C3IV81FSex+3XmQC0c2NYVC1VBFqo5TIfqApM2y0T12JPtP
         iyl1Lfn6xJrGzDLY8778+5GVDsahliXgAJuuSZ1IykrJoUspWeIzcukQxAr/8f0UMRtg
         3IxUICjMimKjitFCQTEvyImQqL8zACHgECSN7A2Z9VvhfyJRziN707I794w8xFo5nguo
         7Crw==
X-Gm-Message-State: AOAM531lW/pdIpB2Vy/yRhCRmMPwXZGNI3rAyfcW8cBkFUMj69mHSrT1
        UChIgYi+tWk+N0qXf+vHOrevgLil8OQ=
X-Google-Smtp-Source: ABdhPJwYlmLyARHwkSmABs8uecV228kZ9bazPy7ZBgj5MyG1xeFz14yB2J7/RON/xFzhAetnrh7iiA==
X-Received: by 2002:aa7:d6d8:: with SMTP id x24mr14133316edr.105.1610363015372;
        Mon, 11 Jan 2021 03:03:35 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id p22sm6867499ejx.59.2021.01.11.03.03.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 03:03:34 -0800 (PST)
Date:   Mon, 11 Jan 2021 13:03:33 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     kbuild@lists.01.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, lkp@intel.com,
        kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH v5 net-next 11/16] net: propagate errors from
 dev_get_stats
Message-ID: <20210111110333.zr6tpqpc7ckzy3gx@skbuf>
References: <20210108163159.358043-12-olteanv@gmail.com>
 <20210111105515.GE5083@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111105515.GE5083@kadam>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dan,

On Mon, Jan 11, 2021 at 01:55:16PM +0300, Dan Carpenter wrote:
> Hi Vladimir,
>
> New smatch warnings:
> net/core/rtnetlink.c:1821 rtnl_fill_ifinfo() warn: missing error code 'err'
>
> vim +/err +1821 net/core/rtnetlink.c
>
> static int rtnl_fill_ifinfo(struct sk_buff *skb,
> 			    struct net_device *dev, struct net *src_net,
> 			    int type, u32 pid, u32 seq, u32 change,
> 			    unsigned int flags, u32 ext_filter_mask,
> 			    u32 event, int *new_nsid, int new_ifindex,
> 			    int tgt_netnsid, gfp_t gfp)
> {
> 	struct ifinfomsg *ifm;
> 	struct nlmsghdr *nlh;
> 	int err = -EMSGSIZE;
>
...
>
> 	err = rtnl_fill_stats(skb, dev);
> 	if (err)
> 		goto nla_put_failure;
>
> 	if (rtnl_fill_vf(skb, dev, ext_filter_mask))
> 		goto nla_put_failure;
>
> No error codes any more on the rest of the gotos in this function.
>
>
> 	if (rtnl_port_fill(skb, dev, ext_filter_mask))
> 		goto nla_put_failure;
>
> 	if (rtnl_xdp_fill(skb, dev))
> 		goto nla_put_failure;
>
...
>
> 	nlmsg_end(skb, nlh);
> 	return 0;
>
> nla_put_failure_rcu:
> 	rcu_read_unlock();
> nla_put_failure:
> 	nlmsg_cancel(skb, nlh);
> 	return err;
> }

Thank you for this report. It is a valid issue. It has also been fixed
in v6:
https://patchwork.kernel.org/project/netdevbpf/patch/20210109172624.2028156-12-olteanv@gmail.com/
From the changelog:

Changes in v6:
- Fixed rtnetlink incorrectly returning 0 in rtnl_fill_ifinfo on
  nla_put_failure and causing "ip a" to not show any interfaces.
