Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B676F2E0E47
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 19:41:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgLVSjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 13:39:32 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:55595 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726261AbgLVSjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 13:39:31 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 4671C5C0125;
        Tue, 22 Dec 2020 13:38:25 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 22 Dec 2020 13:38:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        mendozajonas.com; h=message-id:subject:from:to:cc:date
        :in-reply-to:references:content-type:mime-version
        :content-transfer-encoding; s=fm1; bh=9V8C4freSCS5J+/Kt/AqDCOOu6
        tvVMIOl8Yu1gXbPZo=; b=IIH2G9GnO2ASrc2G54CVyUa0JdmJOxYOzcYYY07tY3
        x33OYzjg6vFAVa5ve4iEyNaaIh3HyPnNlsNlwrKiyLIszA8y2sCm0hdu1gzBZnMd
        aAdSBSa6n2TyXFPK3Z9wuHJh9S2tBEAuS1O3ofplLP9L4tHakLuriKjx6L7g+FQ3
        Qc/5tKymHQIpH9pQVxocn55n3C/i9VzOGzt1LgTYhGjymczlBTCDcuItr1H0JGMX
        L1YKcufbK/iQVKP/sEcHF9T6W7AqEAFVokQMSQ3RWi2ufpWFjQe+VU1mVwH/ysPQ
        XNfdthQXqnNUehP6SyolS00a1U4h/f+5RqjJgG5T3I/w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=9V8C4freSCS5J+/Kt/AqDCOOu6tvVMIOl8Yu1gXbP
        Zo=; b=boulv4ziRr8NMBRz43yfLVvZbsEGZuV/dnxXS2Z/ilwrMdL1AXeA9WyS6
        q9tFsoB7dk89vzJWiMLLNB8vyccHlVthQSf/imX4dZVc4TlUW46R7LT6UqYxnqE4
        NgDIZQSr0QiSxk7Jn05s7y0B+okkGE6QuGrBRJtirjnm9xBcV0TckHId5zVjLx7J
        D1Azl/gDSMRtFrc5PUdg5yF+KS4MGhMyYV8fNJjKOobonwgbl/3yDcZKcpWjut6o
        OOOFSckQx1kSbehDkbnORomVeIsQdGHiTDl9oYVta4qc30A54rTsxhOyuWgR32Ra
        Uo+I0AaQDGeaUcQXNhELgYqe1qFLA==
X-ME-Sender: <xms:Hz3iX8OGK-aw0-myfiOPAXwGyr0ktvEjz-jg6SNnk0IH8WX9mYbzQg>
    <xme:Hz3iX8lF9Ex-kW25jD9CeSwRcllFR-1gzSb5ABJ3JsrrG_v03i_TadrWi7z8yEXXz
    qlGiAtwwxWzuW5Zew>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddtgedgudduiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefkuffhvfffjghftggfggfgsehtkeertddtreejnecuhfhrohhmpefurghm
    uhgvlhcuofgvnhguohiirgdqlfhonhgrshcuoehsrghmsehmvghnughoiigrjhhonhgrsh
    drtghomheqnecuggftrfgrthhtvghrnhepgfevvddvfffhieehudekgeehleduudfhhedu
    tdegffdtudegffejteejudetuddvnecukfhppeejhedrudejvddrudejvddrleehnecuve
    hluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepshgrmhesmhgv
    nhguohiirghjohhnrghsrdgtohhm
X-ME-Proxy: <xmx:Hz3iXzRE0o9tk_4UDoKdCvrBqgtgrwwc0UGlZWB6aZDbE-8HMvOmbQ>
    <xmx:Hz3iX4DKO1Iw2ep6NTCONvjwA7JOIObWyix46w2mfKV_ImaMCOrDLQ>
    <xmx:Hz3iXyS8LlJX4qkSei8PvNMCEavLvHhPTYyDYRoXZt294PD4sZ-hSQ>
    <xmx:IT3iXyKFg2Fe039pIyvnWRrucDGIRKFnDMY8iEohz8u62c-xZBGXOA>
Received: from [192.168.0.8] (unknown [75.172.172.95])
        by mail.messagingengine.com (Postfix) with ESMTPA id A3B09240057;
        Tue, 22 Dec 2020 13:38:22 -0500 (EST)
Message-ID: <4a9cab3660503483fd683c89c84787a7a1b492b1.camel@mendozajonas.com>
Subject: Re: [PATCH] net/ncsi: Use real net-device for response handler
From:   Samuel Mendoza-Jonas <sam@mendozajonas.com>
To:     Joel Stanley <joel@jms.id.au>,
        John Wang <wangzhiqiang.bj@bytedance.com>
Cc:     xuxiaohan@bytedance.com,
        =?UTF-8?Q?=E9=83=81=E9=9B=B7?= <yulei.sh@bytedance.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Gavin Shan <gwshan@linux.vnet.ibm.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Tue, 22 Dec 2020 10:38:21 -0800
In-Reply-To: <CACPK8XexOmUOdGmHCYVXVgA0z5m99XCAbixcgODSoUSRNCY+zA@mail.gmail.com>
References: <20201220123957.1694-1-wangzhiqiang.bj@bytedance.com>
         <CACPK8XexOmUOdGmHCYVXVgA0z5m99XCAbixcgODSoUSRNCY+zA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-12-22 at 06:13 +0000, Joel Stanley wrote:
> On Sun, 20 Dec 2020 at 12:40, John Wang <
> wangzhiqiang.bj@bytedance.com> wrote:
> > 
> > When aggregating ncsi interfaces and dedicated interfaces to bond
> > interfaces, the ncsi response handler will use the wrong net device
> > to
> > find ncsi_dev, so that the ncsi interface will not work properly.
> > Here, we use the net device registered to packet_type to fix it.
> > 
> > Fixes: 138635cc27c9 ("net/ncsi: NCSI response packet handler")
> > Signed-off-by: John Wang <wangzhiqiang.bj@bytedance.com>
> 
> Can you show me how to reproduce this?
> 
> I don't know the ncsi or net code well enough to know if this is the
> correct fix. If you are confident it is correct then I have no
> objections.

This looks like it is probably right; pt->dev will be the original
device from ncsi_register_dev(), if a response comes in to
ncsi_rcv_rsp() associated with a different device then the driver will
fail to find the correct ncsi_dev_priv. An example of the broken case
would be good to see though.

Cheers,
Sam

> 
> Cheers,
> 
> Joel
> 
> > ---
> >  net/ncsi/ncsi-rsp.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/net/ncsi/ncsi-rsp.c b/net/ncsi/ncsi-rsp.c
> > index a94bb59793f0..60ae32682904 100644
> > --- a/net/ncsi/ncsi-rsp.c
> > +++ b/net/ncsi/ncsi-rsp.c
> > @@ -1120,7 +1120,7 @@ int ncsi_rcv_rsp(struct sk_buff *skb, struct
> > net_device *dev,
> >         int payload, i, ret;
> > 
> >         /* Find the NCSI device */
> > -       nd = ncsi_find_dev(dev);
> > +       nd = ncsi_find_dev(pt->dev);
> >         ndp = nd ? TO_NCSI_DEV_PRIV(nd) : NULL;
> >         if (!ndp)
> >                 return -ENODEV;
> > --
> > 2.25.1
> > 


