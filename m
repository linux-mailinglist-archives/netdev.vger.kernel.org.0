Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A73E366BBC8
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 11:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbjAPKdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 05:33:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbjAPKdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 05:33:12 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C108D1ABEF
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 02:33:09 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id qx13so8642328ejb.13
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 02:33:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YeGXDxWALjQca1HWZbagjWMlBn+oHnM0cGi2xPFNoaU=;
        b=EE6M8F7P2ZQP/BsmGmPkypLR48J5JZr2+f6FmYdP9dbhxy8nzpMGPDuECEtFpJegiO
         QZj26ZkREaosiAuDJaRigfsteHbWLh68+K8BRWFD8loFv+xcmZe4aKIU/aiQ9FauqacQ
         T3BCYyWdl7/vwMx3unaNvvoEbg2r47vhF6yWFffiFcWCAuSQFNwCHnLj19HAh199nVNs
         06POnv9zWceN3ek1ODXIKcEt/XA25CF2ePBsbb6joOfIOfVHY/q2Haqr66FEXsLfo1Li
         OwdpJRRx6Gg9+N3H7MK706NLa5ipIAGFVjzdLDGT83k239wc/Ek7VlBHi9roriL5gcA3
         9hyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YeGXDxWALjQca1HWZbagjWMlBn+oHnM0cGi2xPFNoaU=;
        b=eNLrL5Ai+1FlWJ2uY5wxHTmHhpZyoe4htrTWwzCTbLu/sQDkFTrmZSgjGW2AWLi/Nj
         AEgbD5bLmj1IOceTNpZb89KFDLCM9JZa/gWCcXJmaCu3ryDIrFWDhfPfjmbuZSwFl3WK
         fLw5PhJW5gL6xEnxGTSBIxPBIr5u8M1hEp6y3iGONdHxb6mrVt7oDGZosWuVzPmp5HGS
         hiBKlUXM1Z3Nks8mfOliq87kF9BS0EoN0WKEuMuEPuMJY9+9XqIsKRhTceO2mPsb00zp
         oZu70xEfTsdSjp4y69z3nnp2hT+WYm5BCto0uAwZHQp37gTtzM0TZ6ATXKXy5+BEMmgW
         vYPQ==
X-Gm-Message-State: AFqh2krOoo8vtaMbQ9rmb2jDAJTF5KWTxaDL1bb/4+PFFQxYrh9W7FBN
        YmUeyBD8M3JxtUFsWRk8l0zCYQ==
X-Google-Smtp-Source: AMrXdXsSohLGR9VXomplmiQB077cgSbIy7ICu0SvfoGripkpomx8RitGhFow7B32SJuHw04N7Oxs0w==
X-Received: by 2002:a17:906:9f07:b0:7ec:27d7:1838 with SMTP id fy7-20020a1709069f0700b007ec27d71838mr94829769ejc.22.1673865188182;
        Mon, 16 Jan 2023 02:33:08 -0800 (PST)
Received: from localhost ([217.111.27.204])
        by smtp.gmail.com with ESMTPSA id lb19-20020a170907785300b0084d1efe9af6sm11603942ejc.58.2023.01.16.02.33.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 02:33:07 -0800 (PST)
Date:   Mon, 16 Jan 2023 11:33:05 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH net-next 7/9] devlink: allow registering parameters after
 the instance
Message-ID: <Y8Un4cJdm/aBcIOK@nanopsycho>
References: <Y72T11cDw7oNwHnQ@nanopsycho>
 <20230110122222.57b0b70e@kernel.org>
 <Y76CHc18xSlcXdWJ@nanopsycho>
 <20230111084549.258b32fb@kernel.org>
 <f5d9201b-fb73-ebfe-3ad3-4172164a33f3@intel.com>
 <Y7+xv6gKaU+Horrk@unreal>
 <Y8AgaVjRGgWtbq5X@nanopsycho>
 <Y8BmgpxAuqJKe8Pc@unreal>
 <Y8ENScADGSf2AUDA@nanopsycho>
 <Y8O67bd/PuxVGTFf@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8O67bd/PuxVGTFf@unreal>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Jan 15, 2023 at 09:35:57AM CET, leon@kernel.org wrote:
>On Fri, Jan 13, 2023 at 08:50:33AM +0100, Jiri Pirko wrote:
>> Thu, Jan 12, 2023 at 08:58:58PM CET, leon@kernel.org wrote:
>> >On Thu, Jan 12, 2023 at 03:59:53PM +0100, Jiri Pirko wrote:
>> >> Thu, Jan 12, 2023 at 08:07:43AM CET, leon@kernel.org wrote:
>> >> >On Wed, Jan 11, 2023 at 01:29:03PM -0800, Jacob Keller wrote:
>> >> >> 
>> >> >> 
>> >> >> On 1/11/2023 8:45 AM, Jakub Kicinski wrote:
>> >> >> > On Wed, 11 Jan 2023 10:32:13 +0100 Jiri Pirko wrote:
>> >> >> >>>> I'm confused. You want to register objects after instance register?  
>> >> >> >>>
>> >> >> >>> +1, I think it's an anti-pattern.  
>> >> >> >>
>> >> >> >> Could you elaborate a bit please?
>> >> >> > 
>> >> >> > Mixing registering sub-objects before and after the instance is a bit
>> >> >> > of an anti-pattern. Easy to introduce bugs during reload and reset /
>> >> >> > error recovery. I thought that's what you were saying as well.
>> >> >> 
>> >> >> I was thinking of a case where an object is dynamic and might get added
>> >> >> based on events occurring after the devlink was registered.
>> >> >> 
>> >> >> But the more I think about it the less that makes sense. What events
>> >> >> would cause a whole subobject to be registerd which we wouldn't already
>> >> >> know about during initialization of devlink?
>> >> >> 
>> >> >> We do need some dynamic support because situations like "add port" will
>> >> >> add a port and then the ports subresources after the main devlink, but I
>> >> >> think that is already supported well and we'd add the port sub-resources
>> >> >> at the same time as the port.
>> >> >> 
>> >> >> But thinking more on this, there isn't really another good example since
>> >> >> we'd register things like health reporters, regions, resources, etc all
>> >> >> during initialization. Each of these sub objects may have dynamic
>> >> >> portions (ex: region captures, health events, etc) but the need for the
>> >> >> object should be known about during init time if its supported by the
>> >> >> device driver.
>> >> >
>> >> >As a user, I don't want to see any late dynamic object addition which is
>> >> >not triggered by me explicitly. As it doesn't make any sense to add
>> >> >various delays per-vendor/kernel in configuration scripts just because
>> >> >not everything is ready. Users need predictability, lazy addition of
>> >> >objects adds chaos instead.
>> >> >
>> >> >Agree with Jakub, it is anti-pattern.
>> >> 
>> >> Yeah, but, we have reload. And during reload, instance is still
>> >> registered yet the subobject disappear and reappear. So that would be
>> >> inconsistent with the init/fini flow.
>> >> 
>> >> Perhaps during reload we should emulate complete fini/init notification
>> >> flow to the user?
>> >
>> >"reload" is triggered by me explicitly and I will get success/fail result
>> >at the end. There is no much meaning in subobject notifications during
>> >that operation.
>> 
>> Definitelly not. User would trigger reload, however another entity
>> (systemd for example) would listen to the notifications and react
>> if necessary.
>
>Listen yes, however it is not clear if notification sequence should
>mimic fini/init flow.

Well, it makes sense to me. Why do you think it should not?

>
>Thanks
>
>> 
>> >
>> >Thanks
