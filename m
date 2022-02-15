Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F01554B5F4F
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 01:49:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbiBOAtL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 19:49:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiBOAtK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 19:49:10 -0500
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05A2D12F415;
        Mon, 14 Feb 2022 16:49:02 -0800 (PST)
Received: by mail-qv1-xf2a.google.com with SMTP id x3so10548368qvd.8;
        Mon, 14 Feb 2022 16:49:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XCUgampXysNSzlO8VfJaBn3GbertJYBbKUu7/uGg3YU=;
        b=B6NwdTXWsRAOctgPglzdaAVVf2S6YQkT08mXHhA5udMOA+Hh1IP6v7LWXA37U2S4zu
         gQBUfQE08+6QahBEpHTxlW2dTAR7BI2fKo82ipltvJ57NizY0KzGHytchALr69g1q92i
         XqvH/384MpRSu3JlNCE7t7A3bUbQK5XbOarSBi+kOyKQ4Faea2c4xiyP0puCjecgxOUC
         eKFsIA6rbiopMNHciUKcdrMplArINzhHD69KKYeZTTQWh4beclI2r5RvC7tq4oC78OAS
         J3agbhpc8knb+TKcMb27mFgTbiiuMnHPkPLG0MkJyJvoasOiLaHfis2Kt/Q9aru5DDQw
         9ofg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XCUgampXysNSzlO8VfJaBn3GbertJYBbKUu7/uGg3YU=;
        b=F3cbHYTwkmE9RSsoXQWxDA1r60b4bdTJbnXbh+MNK7aMVwZ4YoT7VAG1Z/lF7kAmGy
         oCv160wC24CPYUGiMgKTWlI6iyqYiUhBJGdWEPftpiFZLv/N3HzWj++0oXRf8de1hwUi
         iC/kLUUJTXjvSn2oQZbyyMLyv/ElVidiqbkukEFmp80jnn2wqaiuf4Mv05LWrfN50KSI
         nxEmj7+5Y7150m3z6O3PpdUl2cNCicvDbhwjsdox8UOCduGMhiEn3NLAhD2ig842U2bV
         ELuJgQu1Bjz/u1QmmYhT9UEIUwScxIED6Bo/hN0tFRNCeTjAJ82w7LT2zbv0vfloBlt4
         TpsQ==
X-Gm-Message-State: AOAM532FjTD1robeQWQc4dm97lS7vGLm6vmzEzyxcIC0QTt1xq/93EOm
        oLrAx+qslShDNgb/R+7C+9Q=
X-Google-Smtp-Source: ABdhPJzVZgT3Jf+a6k02zDdZASGBgLlYrO8GzZPYRXwHWQJqTz1MeuHuGhpe7Y4oZPnIeN1GDw8V5w==
X-Received: by 2002:a05:6214:1c8b:: with SMTP id ib11mr923481qvb.39.1644886141146;
        Mon, 14 Feb 2022 16:49:01 -0800 (PST)
Received: from localhost ([2600:1700:65a0:ab60:1336:e323:f59d:db64])
        by smtp.gmail.com with ESMTPSA id bq41sm15805956qkb.9.2022.02.14.16.49.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 16:49:00 -0800 (PST)
Date:   Mon, 14 Feb 2022 16:48:59 -0800
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     David Ahern <dsahern@gmail.com>, menglong8.dong@gmail.com,
        kuba@kernel.org, nhorman@tuxdriver.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dsahern@kernel.org, rostedt@goodmis.org,
        Menglong Dong <imagedong@tencent.com>
Subject: Re: [PATCH v3 net-next] net: drop_monitor: support drop reason
Message-ID: <Ygr4e/9zLkZ45YWe@pop-os.localdomain>
References: <20220127033356.4050072-1-imagedong@tencent.com>
 <cdb189e9-a804-bb02-9490-146acf8ca0a6@gmail.com>
 <YfLCMFXbGTgef5Uu@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfLCMFXbGTgef5Uu@shredder>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 06:02:56PM +0200, Ido Schimmel wrote:
> On Thu, Jan 27, 2022 at 08:53:04AM -0700, David Ahern wrote:
> > On 1/26/22 8:33 PM, menglong8.dong@gmail.com wrote:
> > > From: Menglong Dong <imagedong@tencent.com>
> > > 
> > > In the commit c504e5c2f964 ("net: skb: introduce kfree_skb_reason()")
> > > drop reason is introduced to the tracepoint of kfree_skb. Therefore,
> > > drop_monitor is able to report the drop reason to users by netlink.
> > > 
> > > For now, the number of drop reason is passed to users ( seems it's
> > > a little troublesome to pass the drop reason as string ). Therefore,
> > > users can do some customized description of the reason.
> > > 
> > > Signed-off-by: Menglong Dong <imagedong@tencent.com>
> > > ---
> > > v3:
> > > - referring to cb->reason and cb->pc directly in
> > >   net_dm_packet_report_fill()
> > > 
> > > v2:
> > > - get a pointer to struct net_dm_skb_cb instead of local var for
> > >   each field
> > > ---
> > >  include/uapi/linux/net_dropmon.h |  1 +
> > >  net/core/drop_monitor.c          | 16 ++++++++++++----
> > >  2 files changed, 13 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/include/uapi/linux/net_dropmon.h b/include/uapi/linux/net_dropmon.h
> > > index 66048cc5d7b3..b2815166dbc2 100644
> > > --- a/include/uapi/linux/net_dropmon.h
> > > +++ b/include/uapi/linux/net_dropmon.h
> > > @@ -93,6 +93,7 @@ enum net_dm_attr {
> > >  	NET_DM_ATTR_SW_DROPS,			/* flag */
> > >  	NET_DM_ATTR_HW_DROPS,			/* flag */
> > >  	NET_DM_ATTR_FLOW_ACTION_COOKIE,		/* binary */
> > > +	NET_DM_ATTR_REASON,			/* u32 */
> > >  
> > 
> > For userspace to properly convert reason from id to string, enum
> > skb_drop_reason needs to be moved from skbuff.h to a uapi file.
> > include/uapi/linux/net_dropmon.h seems like the best candidate to me.
> > Maybe others have a better idea.
> 
> I think the best option would be to convert it to a string in the kernel

This is a bad idea. Integers are much better as they are more flexible
than strings, for example if your application wants to filter with a
specific reason, a simply integer comparison is much faster than a
string comparison. More importantly, user-space could store the integer
to string mapping by itself, saving strings in kernel is just
unnecessary.

> (or report both). Then you don't need to update user space tools such as
> the Wireshark dissector [1] and DropWatch every time a new reason is
> added.
> 
> [1] https://www.wireshark.org/docs/dfref/n/net_dm.html

I don't understand why this is even an argument, we have tons of
applications need to update to catch up with newer kernel...


Thanks.
