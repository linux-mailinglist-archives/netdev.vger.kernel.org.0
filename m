Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4406E6DE8EE
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 03:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbjDLBdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 21:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjDLBdX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 21:33:23 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45A60468B;
        Tue, 11 Apr 2023 18:33:16 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id d2e1a72fcca58-633fc0484d4so731143b3a.3;
        Tue, 11 Apr 2023 18:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681263195;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7njyoKzJ51EO5yB+UcKz0vkCXJHgabT0CFKCHzXCCZ8=;
        b=lungnl9bBU45ypPeW/o26colK9OVYNlA2wNxRmSwtzL1no3pCX5s3hsIg4VaWaB15b
         6hrAomvj/CNKp23ARz26ojNunMAK1WYBeJajGFinAztS3AbzNdW3WjN38G2ElhIVBTFD
         WNhIbwI/xday4ZjEzcW6npCAUs0jn6PZ1s78GMQv243LntVclVuJtl/fH+dNdav8/fSi
         zxVPayjMECoCqAoPW0Du8WHFAlfojTmmw3KoxLxlNdPYFHCzQBerjmXxdJNgOBc9pF3U
         sginLIBFiZbq8UC4GotlOQDm8SYUI7UP9a25seCRSWgLhn2+iY7q4zIZH1zjiGMeuVDN
         fvow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681263195;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7njyoKzJ51EO5yB+UcKz0vkCXJHgabT0CFKCHzXCCZ8=;
        b=iz9TLHU6AFL5yb2+esGUVsrp823myEotQusOyUoyiOb0br7aBYcfmzRJuhql63xmgZ
         cOqNp/h05gyBMsGdnzXWTqQxsyzdK+V3F7FylB8+PvGHpBDjcccYI/TYS0tpuJI9s/X4
         Cso+W17j5pxwfCmCmO0Me8ByaAfY0Qm+WkhTWlJAyFjh2KyPYSbfKMO/GgkFW8DVc75p
         2P5wD0tOFe38Zdhw1mo5tKdYDOIn9M0f9UkdQFtZd2KuanWUX5D2102kJTA3QqBfHknm
         AvHGtrrvi3OLkmTZqquN0K+PslikPm/SLnF9zYL0wnqE1bGtkRSbvkXGXP/6y5WdCM2c
         LT+w==
X-Gm-Message-State: AAQBX9cvkqNqSlFPilX86hu+7Zfiuw7GLB+Da8Lom/IQg2NBofFGJ4Vw
        W1myYkNuun+mEgiOLLbIoTM=
X-Google-Smtp-Source: AKy350blayWcCnidBV/2PjbeRjzv6tJQpofKRYxMY/itSWcC00zFTUYtRazFn10QP2k0t0S+JGaixA==
X-Received: by 2002:aa7:9e81:0:b0:638:dc83:2051 with SMTP id p1-20020aa79e81000000b00638dc832051mr860091pfq.32.1681263195558;
        Tue, 11 Apr 2023 18:33:15 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id m9-20020aa78a09000000b00639fc7124c2sm3672126pfa.148.2023.04.11.18.33.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 18:33:15 -0700 (PDT)
From:   xu xin <xu.xin.sc@gmail.com>
X-Google-Original-From: xu xin <xu.xin16@zte.com.cn>
To:     kuba@kernel.org
Cc:     bridge@lists.linux-foundation.org, davem@davemloft.net,
        edumazet@google.com, jiang.xuexin@zte.com.cn,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, roopa@nvidia.com, yang.yang29@zte.com.cn,
        zhang.yunkai@zte.com.cn, xu.xin16@zte.com.cn, razor@blackwall.org
Subject: Re: [PATCH net-next] net/bridge: add drop reasons for bridge forwarding
Date:   Wed, 12 Apr 2023 09:33:10 +0800
Message-Id: <20230412013310.174561-1-xu.xin16@zte.com.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230407200319.72fd763f@kernel.org>
References: <20230407200319.72fd763f@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>On Thu, 6 Apr 2023 19:30:34 +0800 (CST) yang.yang29@zte.com.cn wrote:
>> From: xu xin <xu.xin16@zte.com.cn>
>> 
>> This creates six drop reasons as follows, which will help users know the
>> specific reason why bridge drops the packets when forwarding.
>> 
>> 1) SKB_DROP_REASON_BRIDGE_FWD_NO_BACKUP_PORT: failed to get a backup
>>    port link when the destination port is down.
>> 
>> 2) SKB_DROP_REASON_BRIDGE_FWD_SAME_PORT: destination port is the same
>>    with originating port when forwarding by a bridge.
>> 
>> 3) SKB_DROP_REASON_BRIDGE_NON_FORWARDING_STATE: the bridge's state is
>>    not forwarding.
>> 
>> 4) SKB_DROP_REASON_BRIDGE_NOT_ALLOWED_EGRESS: the packet is not allowed
>>    to go out through the port due to vlan filtering.
>> 
>> 5) SKB_DROP_REASON_BRIDGE_SWDEV_NOT_ALLOWED_EGRESS: the packet is not
>>    allowed to go out through the port which is offloaded by a hardware
>>    switchdev, checked by nbp_switchdev_allowed_egress().
>> 
>> 6) SKB_DROP_REASON_BRIDGE_BOTH_PORT_ISOLATED: both source port and dest
>>    port are in BR_ISOLATED state when bridge forwarding.
>
>> @@ -338,6 +344,33 @@ enum skb_drop_reason {
>>  	 * for another host.
>>  	 */
>>  	SKB_DROP_REASON_IPV6_NDISC_NS_OTHERHOST,
>> +	/** @SKB_DROP_REASON_BRIDGE_FWD_NO_BACKUP_PORT: failed to get a backup
>> +	 * port link when the destination port is down.
>> +	 */
>
>That's not valid kdoc. Text can be on the same line as the value only
>in one-line comments. Otherwise:
>	/**
>	 * @VALUE: bla bla bla
>	 *	more blas.
>	 */
>

Ok, I didn't notice that.

>> +static inline bool should_deliver(const struct net_bridge_port *p, const struct sk_buff *skb,
>> +					 enum skb_drop_reason *need_reason)
>>  {
>>  	struct net_bridge_vlan_group *vg;
>> +	enum skb_drop_reason reason;
>> 
>>  	vg = nbp_vlan_group_rcu(p);
>> -	return ((p->flags & BR_HAIRPIN_MODE) || skb->dev != p->dev) &&
>> -		p->state == BR_STATE_FORWARDING && br_allowed_egress(vg, skb) &&
>> -		nbp_switchdev_allowed_egress(p, skb) &&
>> -		!br_skb_isolated(p, skb);
>> +	if (!(p->flags & BR_HAIRPIN_MODE) && skb->dev == p->dev) {
>> +		reason = SKB_DROP_REASON_BRIDGE_FWD_SAME_PORT;
>> +		goto undeliverable;
>> +	}
>> +	if (p->state != BR_STATE_FORWARDING) {
>> +		reason = SKB_DROP_REASON_BRIDGE_NON_FORWARDING_STATE;
>> +		goto undeliverable;
>> +	}
>> +	if (!br_allowed_egress(vg, skb)) {
>> +		reason = SKB_DROP_REASON_BRIDGE_NOT_ALLOWED_EGRESS;
>> +		goto undeliverable;
>> +	}
>> +	if (!nbp_switchdev_allowed_egress(p, skb)) {
>> +		reason = SKB_DROP_REASON_BRIDGE_SWDEV_NOT_ALLOWED_EGRESS;
>> +		goto undeliverable;
>> +	}
>> +	if (br_skb_isolated(p, skb)) {
>> +		reason = SKB_DROP_REASON_BRIDGE_BOTH_PORT_ISOLATED;
>> +		goto undeliverable;
>> +	}
>> +	return true;
>> +
>> +undeliverable:
>> +	if (need_reason)
>> +		*need_reason = reason;
>> +	return false;
>
>You can return the reason from this function. That's the whole point of
>SKB_NOT_DROPPED_YET existing and being equal to 0.
>

If returning the reasons, then the funtion will have to be renamed because
'should_deliever()' is expected to return a non-zero value  when it's ok to
deliever. I don't want to change the name here, and it's better to keep its
name and use the pointer to store the reasons.

>Which is not to say that I know whether the reasons are worth adding
>here. We'll need to hear from bridge experts on that.
