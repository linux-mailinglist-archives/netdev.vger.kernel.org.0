Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 292B662991F
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 13:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbiKOMov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 07:44:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiKOMou (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 07:44:50 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32766A45C
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 04:44:48 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id 62so4818201pgb.13
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 04:44:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=M7VT4ODLwv2Wk7/Ey2cFOLMC7WZn4+qRB7ynHPaBboA=;
        b=VE2saTveuaNFXAy+muo3T6Gf8oCiwINENIUChcoTn1qO2qGuXPDmNtcewuJ17wDfHi
         IRMhpK130XogYKmsPf9QClI58JTojBUILyZEuMUbXbGMc4qwDUJGQhMhIHpGXRRyLYON
         3dE32U/zAfF0DF+dwe6WF5CCS9KbhPW8fJnC9wtc0etvAiqtNyMHmYaKl1oE0zy4HnHw
         EMgSvvdcIJT1+jMKiL4U/rf+oolk2WvtgEaE2ArbEthk3b+0ZIXz/OS0lMB5NnE93q4a
         Rvs0qvpde+EW7OyPHSOInP7jPsFiOHLzsk5MIIRADhHy7CaxLjUA7jFYvFUG5pSL3RTr
         kY3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M7VT4ODLwv2Wk7/Ey2cFOLMC7WZn4+qRB7ynHPaBboA=;
        b=BrYOe0eOytuVQV2dA9CW3OcHKoTjieaf4bSXnchE2Xv+vBDPi86nPeYv0ajAwCHi6i
         KoBEug046fxSn1M7QW3FiQIXgHqtLZMt48w8/Jm8cDbLWFMEP6k3ZukKG4WMy0Pqb6pw
         /IgjCE0zfNGHvxvMOM9hq8nPdbkFf8U7XRnYSPmLKaLOQkYwNvoXoR/mqBXUcpg2nTFd
         tZnfXUStA5BOClfWVl4B6w5ACabFrbUd4siFhhXT7BtiGyewICouDWGIFpnI4bq0I4Jo
         8WwPfdY8sbQNgxfTYX9h+3u3Z+f934N2q3Vn4OIG0mnwMFFbyt2IcA3fYWEAiO1Mm9Au
         SGew==
X-Gm-Message-State: ANoB5pnAYVge4SqkQIh+r1bPSIvM2Y+ea8KnPEwtmZ2OPZMM37vgEGzp
        YSlRwd4UpQfM/7BzrIB5g/4=
X-Google-Smtp-Source: AA0mqf6p8I6Sp3ZiDGmPNTa5bUIPmJ+BrHIE8qbG3SeUBzDBkBSexUNmL7XAHJH7tiYM5p7yAuUM+Q==
X-Received: by 2002:a62:643:0:b0:562:3aed:e40c with SMTP id 64-20020a620643000000b005623aede40cmr18515359pfg.2.1668516287647;
        Tue, 15 Nov 2022 04:44:47 -0800 (PST)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id p2-20020a170902780200b00188c04258c9sm5726668pll.52.2022.11.15.04.44.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 04:44:46 -0800 (PST)
Date:   Tue, 15 Nov 2022 20:44:41 +0800
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
Message-ID: <Y3OJucOnuGrBvwYM@Laptop-X1>
References: <20221102163646.131a3910@kernel.org>
 <Y2odOlWlonu1juWZ@Laptop-X1>
 <20221108105544.65e728ad@kernel.org>
 <Y2uUsmVu6pKuHnBr@Laptop-X1>
 <CAM0EoMmx6i42WR=7=9B1rz=6gcOxorgyLDGseeEH7EYRPMgnzg@mail.gmail.com>
 <20221109182053.05ca08b8@kernel.org>
 <CAM0EoMm1Jx3mcGJK_XasTpVjm7uGHzVXhXN8=MAQUExJhuPFvw@mail.gmail.com>
 <20221110092709.06859da9@kernel.org>
 <Y3MCaaHoMeG7crg5@Laptop-X1>
 <20221114205143.717fd03f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114205143.717fd03f@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 14, 2022 at 08:51:43PM -0800, Jakub Kicinski wrote:
> > So maybe I should stop on here?
> 
> It's a bit of a catch 22 - I don't mind the TCA_NTF_WARN_MSG itself 
> but I would prefer for the extack via notification to spread to other
> notifications.

Not sure if we could find a way to pass the GROUP ID to netlink_ack(),
and use nlmsg_notify() instead of nlmsg_unicast() in it. Then the tc monitor
could handle the NLMSG_ERROR directly.

> 
> If you have the code ready - post it, let's see how folks feel after
> sleeping on it.

I just add a new TCA_NTF_WARN_MSG enum and put the extack message here.
Is this what you want?

diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
index eb2747d58a81..6952573e7054 100644
--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -635,6 +635,7 @@ enum {
 	TCA_INGRESS_BLOCK,
 	TCA_EGRESS_BLOCK,
 	TCA_DUMP_FLAGS,
+	TCA_NTF_WARN_MSG,
 	__TCA_MAX
 };
 
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 23d1cfa4f58c..204181cec215 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1816,7 +1816,8 @@ static int tcf_fill_node(struct net *net, struct sk_buff *skb,
 			 struct tcf_proto *tp, struct tcf_block *block,
 			 struct Qdisc *q, u32 parent, void *fh,
 			 u32 portid, u32 seq, u16 flags, int event,
-			 bool terse_dump, bool rtnl_held)
+			 bool terse_dump, bool rtnl_held,
+			 struct netlink_ext_ack *extack)
 {
 	struct tcmsg *tcm;
 	struct nlmsghdr  *nlh;
@@ -1856,6 +1857,11 @@ static int tcf_fill_node(struct net *net, struct sk_buff *skb,
 		    tp->ops->dump(net, tp, fh, skb, tcm, rtnl_held) < 0)
 			goto nla_put_failure;
 	}
+
+	if (extack && extack->_msg &&
+	    nla_put_string(skb, TCA_NTF_WARN_MSG, extack->_msg))
+			goto nla_put_failure;
+
 	nlh->nlmsg_len = skb_tail_pointer(skb) - b;
 	return skb->len;

Thanks
Hangbin
