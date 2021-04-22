Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA7D53680E9
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 14:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236168AbhDVM4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 08:56:33 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:44125 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230510AbhDVM4d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 08:56:33 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id EE97A12D4;
        Thu, 22 Apr 2021 08:55:57 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 22 Apr 2021 08:55:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=hUnsJZ
        Fx912SJYArMekrpRTZwS0S1MC2Jac58P5q++4=; b=eve03P83F0ISBTb4gv6srU
        awbNzfW+2lwSL2sjSqjLhEdjRE0eXAWjMSVCvbwumpSOxXuW5BKm3ofRd0DUTDM7
        3/vUBgxY4RK+0RLwpbB65mQH8yFnk7ddEq/vTv/kZIN0RNKm2pi2LB8anWBlCwS0
        QpFk1TG1kq76OAetpXSFNOSejgZ7IpBmYkfSgjFahjPD2Ny5xWPXZwMvRV/qQpjX
        AtNWue2rEV3ekOGVoRAKEpWL8pRpqRvDscHtIU1CE/twt6COPt5j++0XIZBylGVH
        fVH0UDN0+RqIg2mjaZvuGbFIzUvdKtrKWMVr2pkK1ECZz39Y3w64vhHMlRsZCmSw
        ==
X-ME-Sender: <xms:XHKBYLOSp5iiCem4v81ARl2kHhpxxS4bigrSvnkGe0ji7grgVegQkg>
    <xme:XHKBYF9kIEwl4a9_ftKqNcSwRvqq_HhC_TwiY8ylOeo8giL5NbojCAdm98Nlu_JiT
    aVhdjCwvxvaiCc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddutddgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdduheefrddukeejnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:XHKBYKRu7GRQVIfMu65atxeMRJYH8wUbFpfydDTitx4Ftwu6yakh9g>
    <xmx:XHKBYPvfJeBHQxqojVnSfMvguIGjIzDGU_a__mxsb126tQLDjtZWaQ>
    <xmx:XHKBYDekA9nMJqXWhGdlcGe0mwf4jWxcYuV3h0OjNT1_lKEUyrv-nA>
    <xmx:XXKBYK7cCFfDzqGbINwSqs5_-mlvVZ9R6d2kYmOKaF7Gm5LNmE16-g>
Received: from localhost (igld-84-229-153-187.inter.net.il [84.229.153.187])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4510F240057;
        Thu, 22 Apr 2021 08:55:56 -0400 (EDT)
Date:   Thu, 22 Apr 2021 15:55:53 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org, edumazet@google.com
Subject: Re: [PATCH net-next v3] virtio-net: page_to_skb() use build_skb when
 there's sufficient tailroom
Message-ID: <YIFyWbmtnM5IcHl8@shredder.lan>
References: <YIFaYBAryfCEBhln@shredder.lan>
 <1619093551.9680612-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1619093551.9680612-1-xuanzhuo@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 08:12:31PM +0800, Xuan Zhuo wrote:
> Thank you very much for reporting this problem. Can you try this patch? Of
> course, it also includes two patches from eric.
> 
>  af39c8f72301 virtio-net: fix use-after-free in page_to_skb()
>  f5d7872a8b8a virtio-net: restrict build_skb() use to some arches

Applied your patch on top of net-next, looks good. Feel free to add:

Tested-by: Ido Schimmel <idosch@nvidia.com>

Thanks for the quick fix
