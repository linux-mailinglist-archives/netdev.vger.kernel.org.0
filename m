Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36C9833A4EE
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 14:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235474AbhCNNFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 09:05:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235460AbhCNNFZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 09:05:25 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E98C061574;
        Sun, 14 Mar 2021 06:05:25 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id si25so6074054ejb.1;
        Sun, 14 Mar 2021 06:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=2UqgEhkkriIfIz0QLCQzC66SqvUBn0IjNxWs+rZzdjk=;
        b=FNnIgE7to+L+jyYIV7nObsiwMZrEL40TE3XJCVE05+Ssq7didpgX3WdOMupFAs6iTX
         R0nzG84vO5i5qV7KMypb1VKKaExElhCPfGIdIQO5kyh9rkZICWLCqxlGFedNB2MsB5Ot
         KJlFwcPwTx2o1HxXP+/wYj7AXW9QTaULMF8v3FOqspLWiIWHCaIK9V19efvfC5SMAEsc
         Xe2aOjP7UM6wmJ511+cUDKdjqBydsmOJmNA9lIpG8v0N+y5qNY7mPq08X5BbI5vSrUBt
         sXI+7XLF7tvqOQ/O8jIf6CXFrp3x9Un6oEjfas6JN+gAtjMdQy0ccRYHuNdSx90XOGWo
         jnHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=2UqgEhkkriIfIz0QLCQzC66SqvUBn0IjNxWs+rZzdjk=;
        b=jRkVYFV4+YgE0fkVPdb5sCl2QjzJGX5y+JZZNoNpZhhsHLGogblerTum26NCibIZxZ
         xbdxEQHwxH11oskXTzxlMGL1BWzvaWwgZ5NMCjee3nzD6P9dhOe3o8yhwxfrFaVy15a4
         +vyBcAbdZSuPxPAj81ffcaYpglu5Efod6jf2MJkj49KR9qhq9q2bKTS2DBqrtUaDvOxE
         FdZJjudMo8GUSOJxSogDhob10Jwp/xXwkA7iITql8YKAZDGWztJ+E92K4kGiy3fNVCuc
         V4KfnZwLAkZ/y2tjbsDAkAN3BJEIIJIWrULiwb9ddAdmfIU8hkmqyotBI1E0MmOsbq2w
         uanw==
X-Gm-Message-State: AOAM532KOTyiV709ghUKiu+eTcuOxbBo9EAVnTYULjks8TuDYaCGuZcX
        JPBiMI4L+hY33xbwadSm9PI=
X-Google-Smtp-Source: ABdhPJzYhl+GE7DDYpGg5PhZaozD/mp3kztV7ZlfITNOP/wNV9rjeYKjTajlP7Qw7/4uwBQMOzI1ug==
X-Received: by 2002:a17:906:3849:: with SMTP id w9mr18819720ejc.7.1615727124033;
        Sun, 14 Mar 2021 06:05:24 -0700 (PDT)
Received: from TRWS9215 ([88.245.22.54])
        by smtp.gmail.com with ESMTPSA id u13sm5900762ejn.59.2021.03.14.06.05.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 06:05:23 -0700 (PDT)
Message-ID: <7fa4fa81235635266e7b83e2c2d5020691079f9c.camel@gmail.com>
Subject: Re: [BUG] net: rds: rds_send_probe memory leak
From:   Fatih Yildirim <yildirim.fatih@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     santosh.shilimkar@oracle.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Date:   Sun, 14 Mar 2021 16:05:21 +0300
In-Reply-To: <YE4FO01xILz98/K6@kroah.com>
References: <a3036ea4ee2a06e4b3acd3b438025754d11f65fc.camel@gmail.com>
         <YE3K+zeWnJ/hVpQS@kroah.com>
         <b1b796b48a75b3ef3d6cebac89b0be45c5bf4611.camel@gmail.com>
         <YE4FO01xILz98/K6@kroah.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2021-03-14 at 13:44 +0100, Greg KH wrote:
> On Sun, Mar 14, 2021 at 03:19:05PM +0300, Fatih Yildirim wrote:
> > On Sun, 2021-03-14 at 09:36 +0100, Greg KH wrote:
> > > On Sun, Mar 14, 2021 at 11:23:10AM +0300, Fatih Yildirim wrote:
> > > > Hi Santosh,
> > > > 
> > > > I've been working on a memory leak bug reported by syzbot.
> > > > https://syzkaller.appspot.com/bug?id=39b72114839a6dbd66c1d2104522698a813f9ae2
> > > > 
> > > > It seems that memory allocated in rds_send_probe function is
> > > > not
> > > > freed.
> > > > 
> > > > Let me share my observations.
> > > > rds_message is allocated at the beginning of rds_send_probe
> > > > function.
> > > > Then it is added to cp_send_queue list of rds_conn_path and
> > > > refcount
> > > > is increased by one.
> > > > Next, in rds_send_xmit function it is moved from cp_send_queue
> > > > list
> > > > to
> > > > cp_retrans list, and again refcount is increased by one.
> > > > Finally in rds_loop_xmit function refcount is increased by one.
> > > > So, total refcount is 4.
> > > > However, rds_message_put is called three times, in
> > > > rds_send_probe,
> > > > rds_send_remove_from_sock and rds_send_xmit functions. It seems
> > > > that
> > > > one more rds_message_put is needed.
> > > > Would you please check and share your comments on this issue?
> > > 
> > > Do you have a proposed patch that syzbot can test to verify if
> > > this
> > > is
> > > correct or not?
> > > 
> > > thanks,
> > > 
> > > gre gk-h
> > 
> > Hi Greg,
> > 
> > Actually, using the .config and the C reproducer, syzbot reports
> > the
> > memory leak in rds_send_probe function. Also by enabling
> > CONFIG_RDS_DEBUG=y, the debug messages indicates the similar as I
> > mentioned above. To give an example, below is the RDS_DEBUG
> > messages.
> > Allocated address 000000008a7476e5 has initial ref_count 1. Then
> > there
> > are three rds_message_addref calls for the same address making the
> > refcount 4, but only three rds_message_put calls which leave the
> > address still allocated.
> > 
> > [   60.570681] rds_message_addref(): addref rm 000000008a7476e5 ref
> > 1
> > [   60.570707] rds_message_put(): put rm 000000008a7476e5 ref 2
> > [   60.570845] rds_message_addref(): addref rm 000000008a7476e5 ref
> > 1
> > [   60.570870] rds_message_addref(): addref rm 000000008a7476e5 ref
> > 2
> > [   60.570960] rds_message_put(): put rm 000000008a7476e5 ref 3
> > [   60.570995] rds_message_put(): put rm 000000008a7476e5 ref 2
> > 
> 
> Ok, so the next step is to try your proposed change to see if it
> works
> or not.  What prevents you from doign that?
> 
> No need to ask people if your analysis of an issue is true or not, no
> maintainer or developer usually has the time to deal with that.  We
> much
> rather would like to see patches of things you have tested to resolve
> issues.
> 
> thanks,
> 
> greg k-h

Hi Greg,

I also would like to come with a patch to resolve the issue as well.
But couldn't figure out so far. I just would like to have a review or a
suggestion from an expert in order to move forward.
Anyway, I'm still working on it and hope to find a solution.
Will appreciate any comment, suggestion on the issue.

Thanks,
Fatih


