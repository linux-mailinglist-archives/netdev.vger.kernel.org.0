Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECD7A4AF3D2
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 15:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231895AbiBIOMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 09:12:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234874AbiBIOMb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 09:12:31 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A80F8C05CBA5
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 06:12:30 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id fj5so4845521ejc.4
        for <netdev@vger.kernel.org>; Wed, 09 Feb 2022 06:12:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ReFq2wvfTKRlsMNx9c3dXLhgc/8SLDZSDoMffgP20ys=;
        b=Qn6JLV7HgzQ9SYrHl/tv86HmBZGIT7aharjStQ5IJDaoi+H9d2tjpYt2kb+GEoMzL7
         OCBZa9cfGv3I8wp5ROj6t0d6DSIDTEM+boriP8rWlHAP42gAlwwgJICqGKRVpg+CFmSg
         CC4+p0tAoTQc+8X90bU5wjQ7nT1k8T0XpV8Omryen4UiPb443ldh6khJYXocBGXBAijT
         G3U4Q+5hcxGBUfLmxV4EByXs3uLgrRWlmHiTvaGB/Wh2/YrC3PFGJz1nXD7NAIvM1fa+
         B6BzLqQFH+SjzQp4dG/ywM63KVhkiBE+SVzIvEiD8WlTg7BnKZQbPKhzbifXz23t23zH
         umCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ReFq2wvfTKRlsMNx9c3dXLhgc/8SLDZSDoMffgP20ys=;
        b=Vgvm2KY0tIMHclWWlhwlMNo9UUMHy3su4JO4l+303dphRVFaosezGIg/ZDs6OXCMcQ
         dmpfo90XZUaqvKszXx6FSgWHV8zqFatwJLdI6F7bqehe7LyCS6z9UjV+FyeS8Yqq58Dy
         0zKly0ZeOKZx5Vg+E7ISYlAkeewPPygA1usgZ+PEOB8Nn7zLCwsvBKXQaKrm1FiwyMbc
         +66tgsKKbF+BZw0dgiB/Pf0Za2kz3iNZUd+sXYBOXYxNzR2M99js17zCBFq+N0GrtbVd
         uBtX6s+m5wWKbVunNDI4cMR6xinMZigcbH8h2xx0FHUQYRmUsKnyrPwUdOUVTCyL1LQm
         UpUQ==
X-Gm-Message-State: AOAM530PC5iaZbXzpy5YIX6WNDIYVI9SsZYef1N/CzKxlkVnv5EMz4+M
        uR5Fwiw1FOx0YI52UGrLCyq4cQHce77OcE+lIUc=
X-Google-Smtp-Source: ABdhPJwLdmMJveoRx7sbXeXQMliOKTY31YsqZGYp3dWZ8B9sVI6i/33qnbECJOV9QE1jLWbRZo+VIw==
X-Received: by 2002:a17:906:d551:: with SMTP id cr17mr2166554ejc.392.1644415949047;
        Wed, 09 Feb 2022 06:12:29 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id u19sm6132026ejy.171.2022.02.09.06.12.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 06:12:28 -0800 (PST)
Date:   Wed, 9 Feb 2022 15:12:27 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Cc:     netdev@vger.kernel.org, tparkin@katalix.com, jhs@mojatatu.com,
        boris.sukholitko@broadcom.com, felipe@sipanda.io, tom@sipanda.io,
        sridhar.samudrala@intel.com, marcin.szycik@linux.intel.com,
        wojciech.drewek@intel.com, grzegorz.nitka@intel.com,
        michal.swiatkowski@intel.com
Subject: Re: hw offload for new protocols
Message-ID: <YgPLy1p4wBALvSGZ@nanopsycho>
References: <YgN/EiV/di4vtzdE@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgN/EiV/di4vtzdE@localhost.localdomain>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Feb 09, 2022 at 09:45:06AM CET, michal.swiatkowski@linux.intel.com wrote:
>Hi,
>
>I would like to add matching on values from protocol that isn't yet
>supported in kernel, but my hw has abilitty to offload it (session id
>in pfcp for example).
>What is a correct way to implement it in kernel? I was searching on ML
>for threads about that but I didn't find answer to all my concerns.
>
>I assume that for hw offload we should reuse tc flower, which already
>has great ability to offload bunch of widely used protocols. To match on
>my session id value I will for sure have to add another field in tc
>(user and kernel part). Something like this:
>#tc filter add dev $DEV protocol ip parent ffff: flower dst_ip $IP
>session_id 0102030405060708 action drop
>
>Should SW path be also supported? I think that yes, so, this will

Yes.


>need adding handling this new field in flow_dissector. I have read

Correct.


>thread with adding new field to it [1] and my feeling from it is: better
>do not add new fields there :) . However, if it is fine to expand
>flow_dissector, how to do it in this particular case? Can I check udp
>port in flow dissector code and based on that dissect session id from
>pfcp header? Won't this lead to a lot of new code for each different
>protocols based on well known port numbers?

I don't think it is good idea to base the flow dissector branch decision
on a well known UDP port.


>
>What about $DEV from tc command? In hw offload for example for VXLAN or
>geneve based on this hw knows what type of flow should be offloaded. It
>will be great to have the same ability for pfcp (in my case), to allow
>adding rule without pfcp specific fileds:
>#tc filter add dev $PFCP_DEV protocol ip parent ffff: flower dst_ip $IP
>action drop

Yes, I agree.


>Or maybe in this kind of flows we should always add in tc flower correct
>port number which will tell hw that this flow is pfcp?
>#tc filter add dev $DEV protocol ip parent ffff: flower dst_ip $IP
>enc_dst_port $well_know_pfcp action drop
>
>If creating new netdev (pfcp in this case) is fine solution, how pfcp
>driver should look like? Is code for receiving and xmit sufficient? Or
>is there need to implement more pfcp features in the new driver? To not
>have sth like dummy pfcp driver only to point to it in tc. There was
>review with virtual netdev [2] - which drops every packet that returns from
>classyfing (I assume not offloaded by hw). Maybe this solution is
>better?

Not sure how it fits on PFCP.


>
>I have also seen panda (flower 2) [3]. It isn' available in kernel now.
>Do we know timeline for this feature? From review discussion I don't
>know if it allow offloading cases like my in hw which wasn't design to
>support panda offload.
>
>I feel like I can solve all my concerns using u32 classifier (but I can
>be wrong). I thought about creating user space app that will translate
>human readable command to u32. Hw will try to offload u32 command if
>given flow can be offloaded, if not software path will work as usally. I
>have seen that few drivers support u32 offload, but it looks like the
>code is from before creation of flower classifier. Do You know if
>someone try this combination (user app + u32 + hw offload)?
>
>I am talking about pfcp, but there is few more protocols that hw can
>offload, but lack of support in flow dissector is successfully
>complicating hw offload.
>
>Thanks for any comments about this topic,
>Michal
>
>
>[1] https://lore.kernel.org/netdev/20210830080800.18591-1-boris.sukholitko@broadcom.com/
>[2] https://lore.kernel.org/netdev/20210929094514.15048-1-tparkin@katalix.com/
>[3] https://lore.kernel.org/netdev/20210916200041.810-1-felipe@expertise.dev/
