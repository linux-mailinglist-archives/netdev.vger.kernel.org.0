Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FEEA2415E5
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 07:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgHKFJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 01:09:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726134AbgHKFJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 01:09:33 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47466C06174A;
        Mon, 10 Aug 2020 22:09:33 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id l64so10640623qkb.8;
        Mon, 10 Aug 2020 22:09:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bMSxjMPm7VjNJMk372pm84tQNgfCuUZD1VrmgkqYZCk=;
        b=eLBzjVCO5YbxLczQR30kyge47su0iVcJrFjbDeldqpgB2hjXU5IW3vXcQ8JtxRodoF
         qhbLl6bjXO7Jlw5cfCnfSLBt+UguSzjYM/bCiq6Xxpf+ZkzFhamxpFsXgZzbBx6bwrRb
         AnpIjg5QVPT1+z+Qpl+qqYHwXJoByhiyqO//u5t9q3f2ygLnkR8e72dL3xFxHLsAbyRH
         0oluLqNNUANwqEYLXSTn4UMI+9lJTfM97LFe+l/JXOJSCK689qf99iDm1Firfr0u/GSu
         UpgsbvWWHqyyqD/O1gvgX4uLDpJCVFTDiHOJmuk2+ojKOft0M7v7IHvKcYcncAIGKVzp
         EkZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bMSxjMPm7VjNJMk372pm84tQNgfCuUZD1VrmgkqYZCk=;
        b=BTlPSmunqFwuBVPO3p9W4Q28xfTdbKstlBwuNWI81Q0pLMJDT6HinYuNM0rIAEU1DH
         qN4d0dt21upQPUqchocGiLu+Nv6xurOKV0gjTXSLsdVGFQ/Sa10sWP4ZzHpSfzjRUb3u
         mCMqN815UgcgHOyOYdY9Nino8YDEsU31zJB593i9VEasGDxU1L7fwAzQUbw15xcjp6OH
         1IRGidtP3qYERWQcbdat5jbEa3eNGosa1ERzP1NMfcC/sVKwgVek0GCMQKBx5Mrphnv8
         xucpN93awnxHfKRCQ/ugL7ZDzSd3SE8itwd9CJdstzz8JhyAu6lcyZGFOEVyvrjTue9o
         yluQ==
X-Gm-Message-State: AOAM533KN0JLoH61bKUB8TQKJiAicYkedFr6Ly4z7xtPKw5Dg/ciASGY
        K4DY2B7d37Fe/twe1VJoAg==
X-Google-Smtp-Source: ABdhPJx2Ee81fca74pCzQRr0gAjmwBmoPjLgb54zYmDsOm6OFBy2IQqatW+oGAXQ0UUv+/hmSrUZKA==
X-Received: by 2002:ae9:f301:: with SMTP id p1mr28616754qkg.295.1597122572273;
        Mon, 10 Aug 2020 22:09:32 -0700 (PDT)
Received: from PWN (146-115-88-66.s3894.c3-0.sbo-ubr1.sbo.ma.cable.rcncustomer.com. [146.115.88.66])
        by smtp.gmail.com with ESMTPSA id l189sm15659624qke.67.2020.08.10.22.09.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2020 22:09:31 -0700 (PDT)
Date:   Tue, 11 Aug 2020 01:09:29 -0400
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        lvs-devel@vger.kernel.org,
        NetFilter <netfilter-devel@vger.kernel.org>,
        coreteam@netfilter.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Linux-kernel-mentees] [PATCH net] ipvs: Fix uninit-value in
 do_ip_vs_set_ctl()
Message-ID: <20200811050929.GA821443@PWN>
References: <20200810220703.796718-1-yepeilin.cs@gmail.com>
 <CAM_iQpWsQubVJ-AYaLHujHwz68+nsHBcbgbf8XPMEPD=Vu+zaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpWsQubVJ-AYaLHujHwz68+nsHBcbgbf8XPMEPD=Vu+zaA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 10, 2020 at 08:57:19PM -0700, Cong Wang wrote:
> On Mon, Aug 10, 2020 at 3:10 PM Peilin Ye <yepeilin.cs@gmail.com> wrote:
> >
> > do_ip_vs_set_ctl() is referencing uninitialized stack value when `len` is
> > zero. Fix it.
> 
> Which exact 'cmd' is it here?
> 
> I _guess_ it is one of those uninitialized in set_arglen[], which is 0.

Yes, it was `IP_VS_SO_SET_NONE`, implicitly initialized to zero.

> But if that is the case, should it be initialized to
> sizeof(struct ip_vs_service_user) instead because ip_vs_copy_usvc_compat()
> is called anyway. Or, maybe we should just ban len==0 case.

I see. I think the latter would be easier, but we cannot ban all of
them, since the function does something with `IP_VS_SO_SET_FLUSH`, which
is a `len == 0` case.

Maybe we do something like this?

@@ -2432,6 +2432,8 @@ do_ip_vs_set_ctl(struct sock *sk, int cmd, void __user *user, unsigned int len)

 	if (cmd < IP_VS_BASE_CTL || cmd > IP_VS_SO_SET_MAX)
 		return -EINVAL;
+	if (len == 0 && cmd != IP_VS_SO_SET_FLUSH)
+		return -EINVAL;
 	if (len != set_arglen[CMDID(cmd)]) {
 		IP_VS_DBG(1, "set_ctl: len %u != %u\n",
 			  len, set_arglen[CMDID(cmd)]);
@@ -2547,9 +2549,6 @@ do_ip_vs_set_ctl(struct sock *sk, int cmd, void __user *user, unsigned int len)
 		break;
 	case IP_VS_SO_SET_DELDEST:
 		ret = ip_vs_del_dest(svc, &udest);
-		break;
-	default:
-		ret = -EINVAL;
 	}

   out_unlock:

Thank you,
Peilin Ye

> In either case, it does not look like you fix it correctly.
> 
> Thanks.
