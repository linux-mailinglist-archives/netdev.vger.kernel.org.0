Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB512A1EA5
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 15:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgKAOm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 09:42:26 -0500
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:44707 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726541AbgKAOmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 09:42:25 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 01F125800F3;
        Sun,  1 Nov 2020 09:42:24 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 01 Nov 2020 09:42:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=TKoa5k
        pepS2mQTgaqai4ftm4RY9oc0cDiXtiwp+zyZ8=; b=ODA36ChKIsvpKpS/yWy0lT
        s3UWlHI5R5P7943TpY9m+qCyiY4ejn1ZIg/ZmpyMdwW7RlfuhnmKZ8EhcnTHwtop
        qDHegAdR9B3WmrUjjk2M/crDHJCU0MJ16pYbAyimUEGFOmFVSeAhfsxRPP+O8fHM
        efJAAFJOFfqPT4fH8EhOXMTE5CxAemY7mT61C+1ouKUV+ITmzmSPXzxR6iJ+nYzj
        gRcTCYAFgtc+KoLugKMstkPrxerOhyoTUPUKqipFehLzvkExXQtH7TNb7xoiIhYx
        R8PK2hxnLaSLxHD9oW/HbPvH4ocT5CRUAFSJ8/TcoOwWxyxhUr9ItPRJsrBmvhtA
        ==
X-ME-Sender: <xms:TcmeX3owWS_qFRixhBQtvRleDkdDzdFBO8Wfs_Tu0DwsXtEvpCnyeQ>
    <xme:TcmeXxpc9Q44dz4SdnVcB8vdRYgn4Qbp1INWVLBKCbobliZRtSn4RVp__WwBdU5_W
    4z3E0scQMIBIR4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrleelgdejtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepudfhhefghfegffdugfdthfduudffgeffieekleeggeehveefudejfeffledtveeu
    necuffhomhgrihhnpehgihhthhhusgdrtghomhdptghumhhulhhushhnvghtfihorhhksh
    drtghomhenucfkphepkeegrddvvdelrdduheehrddukedvnecuvehluhhsthgvrhfuihii
    vgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdroh
    hrgh
X-ME-Proxy: <xmx:TcmeX0PrjzoazPjqfjCu3I0jmQCSeMiEoD8z736fM_9-BGCdFk6IRA>
    <xmx:TcmeX67JTH0ZyMf6RjNMHPm6bMsBMvx2sewgiibxZg388DSsQgs4Lw>
    <xmx:TcmeX273j2MN7ngNZ_xbTVj-csxoM240aJPCk9XmA2D8nHMCy3R9Sg>
    <xmx:T8meX_Gx_ymiAaldEj1YuCjwG-o0DlXwFkh4owOPt4u1QZl12meNOw>
Received: from localhost (igld-84-229-155-182.inter.net.il [84.229.155.182])
        by mail.messagingengine.com (Postfix) with ESMTPA id E14203280063;
        Sun,  1 Nov 2020 09:42:20 -0500 (EST)
Date:   Sun, 1 Nov 2020 16:42:17 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        Ivan Vecera <ivecera@redhat.com>, vyasevich@gmail.com,
        netdev <netdev@vger.kernel.org>, UNGLinuxDriver@microchip.com,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
Subject: Re: [PATCH RFC net-next 00/13] RX filtering for DSA switches
Message-ID: <20201101144217.GA714146@shredder>
References: <20200526140159.GA1485802@splinter>
 <CA+h21hqTxbPyQGcfm3qWeD80qAZ_c3xf2FNdSBBdtOu2Hz9FTw@mail.gmail.com>
 <20200528143718.GA1569168@splinter>
 <20200720100037.vsb4kqcgytyacyhz@skbuf>
 <20200727165638.GA1910935@shredder>
 <20201027115249.hghcrzomx7oknmoq@skbuf>
 <20201028144338.GA487915@shredder>
 <20201028184644.p6zm4apo7v4g2xqn@skbuf>
 <20201101112731.GA698347@shredder>
 <20201101120644.c23mfjty562t5xue@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201101120644.c23mfjty562t5xue@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 01, 2020 at 02:06:44PM +0200, Vladimir Oltean wrote:
> On Sun, Nov 01, 2020 at 01:27:31PM +0200, Ido Schimmel wrote:
> > IIRC, getting PTP to work on bridged interfaces is tricky and this is
> > something that is not currently supported by mlxsw or Cumulus:
> > https://github.com/Mellanox/mlxsw/wiki/Precision-Time-Protocol#configuring-ptp
> > https://docs.cumulusnetworks.com/cumulus-linux-42/System-Configuration/Setting-Date-and-Time/#configure-the-ptp-boundary-clock
> > 
> > If the purpose of this discussion is to get PTP working in this
> > scenario, then lets have a separate discussion about that. This is
> > something we looked at in the past, but didn't make any progress (mainly
> > because we only got requirements for PTP over routed ports).
> > 
> > Anyway, opening packet sockets on interfaces (bridged or not) that pass
> > offloaded traffic will not get you this traffic to the packet sockets.
> 
> I don't think it's a different discussion, I think my issues with what
> you're proposing are coming exactly from there. I think that user space
> today is expecting that when it uses the *_ADD_MEMBERSHIP API, it is
> sufficient in order to see that traffic over a socket. Switchdev and DSA
> are kernel-only concepts, they have no user-facing API. I am not sure
> that it is desirable to change that. I hope you aren't telling me that
> we should add a --please argument to the PACKET_ADD_MEMBERSHIP /
> IP_ADD_MEMBERSHIP UAPI just in case the network interface is a switchdev
> port...

If the goal of this thread is to get packet sockets to work with
offloaded traffic, then I think you need to teach these sockets to
instruct the bound device to trap / mirror incoming traffic to the CPU.
Maybe via a new ndo.
