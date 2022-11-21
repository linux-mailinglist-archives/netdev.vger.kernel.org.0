Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A60D6632C28
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 19:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbiKUSem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 13:34:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiKUSel (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 13:34:41 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA180C9026
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 10:34:40 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id v3so11928140pgh.4
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 10:34:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MJ/eIphOvJ+krrUlut1ktc+A75IR0teayMjIOfJ9tPM=;
        b=1UfGFg71L+NHns8RT5RsOevZvdDzKe421ePb/G4TMZMsxvwk0a3h0KIo4t7Fpe1z2f
         6ankQ6WitS+VGHTJKDBAfQ3LfDijp5nbpFDHV78RbEmjqYTcMeXK5OA8weg13PN2LARx
         JtAW735HR5s0uxCqjGu2e4/u4/t84FiZqP8FBJj4UjiJMrinefLcx2dwxZbbVpD7zc8F
         cYLDmiiR/ZZ/8/TNOQoyRoHP5V50Lq3/FoAF1hWMWedx2qSywlAotM6JqVzPtuIG9e4O
         mwXTlR61tju4GPP9sRjhX8tFW9ecr+EH3s5N2qpvl9i3kQrdmVr18pYTry+joI694QY3
         qhUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MJ/eIphOvJ+krrUlut1ktc+A75IR0teayMjIOfJ9tPM=;
        b=HUJIRIVz986CYi5CRureYjIXcXZcLdDRYxH5e56VLJnnJaNkNRvQhX7ATIvWJ2PvY2
         p8OkmXIWXML8rOAvQU8eX/nX1Alrnwve+nyTPuF4WlYwrG/QfWrJyPgbv3iIU1CPrzPc
         67Un/4xUZPCEOtFJ66dZhg9AqedFGVkkhmnReB+RlR4Qv8KAWXEVgZn4D6om4nlMJxWh
         Zh1rCXtjufnCVjMqOYL4jiYF7VtqkoInMahx+6uquDPDoVfO9hpB3Ct40+lDVvRY1j/M
         /Z8Ci9JTbt+bTkryymSDvwjGImpy3TduVIoobft0fCZSEQMTUsePlqGuVsT6xpg+KSLu
         dbjA==
X-Gm-Message-State: ANoB5pmKwjkBmJC4AKAPqx/By/+4sRYLcVs0ACb+C+gkwEeyBjhZG68I
        /HOoBMRc1XM75KlFwbdYtFJukzkkMCpkeem5
X-Google-Smtp-Source: AA0mqf4yBx3cJC4IauoR+DzCU+n6AbmfV9n2TS2VO0sRaDLb+mHWlBo+Yt2IbqsbJxA3HlMCDvaw7Q==
X-Received: by 2002:a65:55cd:0:b0:477:1bb6:c6f4 with SMTP id k13-20020a6555cd000000b004771bb6c6f4mr16558002pgs.417.1669055680209;
        Mon, 21 Nov 2022 10:34:40 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id b5-20020a170903228500b001889e58d520sm10063297plh.184.2022.11.21.10.34.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 10:34:39 -0800 (PST)
Date:   Mon, 21 Nov 2022 10:34:37 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [patch iproute2] devlink: load ifname map on demand from
 ifname_map_rev_lookup() as well
Message-ID: <20221121103437.513d13d4@hermes.local>
In-Reply-To: <Y3s8PUndcemwO+kk@nanopsycho>
References: <20221109124851.975716-1-jiri@resnulli.us>
        <Y3s8PUndcemwO+kk@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Nov 2022 09:52:13 +0100
Jiri Pirko <jiri@resnulli.us> wrote:

> Wed, Nov 09, 2022 at 01:48:51PM CET, jiri@resnulli.us wrote:
> >From: Jiri Pirko <jiri@nvidia.com>
> >
> >Commit 5cddbb274eab ("devlink: load port-ifname map on demand") changed
> >the ifname map to be loaded on demand from ifname_map_lookup(). However,
> >it didn't put this on-demand loading into ifname_map_rev_lookup() which
> >causes ifname_map_rev_lookup() to return -ENOENT all the time.
> >
> >Fix this by triggering on-demand ifname map load
> >from ifname_map_rev_lookup() as well.
> >
> >Fixes: 5cddbb274eab ("devlink: load port-ifname map on demand")
> >Signed-off-by: Jiri Pirko <jiri@nvidia.com>  
> 
> Stephen, its' almost 3 weeks since I sent this. Could you please check
> this out? I would like to follow-up with couple of patches to -next
> branch which are based on top of this fix.
> 
> Thanks!

David applied it to iproute2-next branch already
