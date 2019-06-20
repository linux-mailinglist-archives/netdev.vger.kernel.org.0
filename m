Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 040744CB99
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 12:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbfFTKM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 06:12:56 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:37435 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726081AbfFTKMz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 06:12:55 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id ADCEE221FB;
        Thu, 20 Jun 2019 06:12:54 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 20 Jun 2019 06:12:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=BICJki
        kO1pqeAKqFclJvZTa5QLEKlMvNvzQTH8/ESkQ=; b=QGBAPRoqPuJDv4An/YM2Pj
        nbhCYmJddHpRZX2hajArb5TmTuC6t1nI0LG0AvoEG/zWifi+c2C5V5ym+tbOJTcv
        VErt4gPwYVPMlfbcTKpcMuoi6bL0VHpxbmC4VHiR1fh9ed3I6ehFDwzsyU7LzfJ1
        2ecOKL0+y70McPilF4+TRFi2er6OG3wKs5wmdr3p/qQ3xk04mcny0jTAsoEplK+H
        DjSzi6ZHeVY1f7VSV8QejWXgS81X1/ucPqP+SsPUrCyPsMBaSCmM9ync9b0fhHm/
        +dSLHlINm2dXbvDrXeqdzQJ83zc6pEF30P1Kac/pgynkm5ZNC8PTIopJ7ZxNbs6A
        ==
X-ME-Sender: <xms:JVwLXXvBDORgKnrFD2sTGgqN1vd2Xi3pucDsQqwIvIjSwWU_8vq6ng>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrtdeggddviecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepudelfe
    drgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhes
    ihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:JVwLXUrRoYVz6ODtVoG9OPhp3xhbpss6FdOwo-mbaXv-A_C5MNyR-A>
    <xmx:JVwLXdpOxd4ZbDhExft_38sjSKfjYDZvhxhvERPFfnL5kktj2T9lnQ>
    <xmx:JVwLXU1x1rcBEdNTjAy7B4uj9Y9LzXFKjGGcpydIB-yqC9ak0IUmrw>
    <xmx:JlwLXfurpOKn7O7indjcNmZWmTnW8hrMucWwCYeyIJz6nhncoAWpPw>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id CDE61380084;
        Thu, 20 Jun 2019 06:12:52 -0400 (EDT)
Date:   Thu, 20 Jun 2019 13:12:50 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dsahern@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next v2] ipv6: Error when route does not have any
 valid nexthops
Message-ID: <20190620101250.GA18869@splinter>
References: <20190620091021.18210-1-idosch@idosch.org>
 <20190620092202.GC2504@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190620092202.GC2504@nanopsycho>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 20, 2019 at 11:22:03AM +0200, Jiri Pirko wrote:
> Thu, Jun 20, 2019 at 11:10:21AM CEST, idosch@idosch.org wrote:
> >+	if (list_empty(&rt6_nh_list)) {
> >+		NL_SET_ERR_MSG(extack,
> >+			       "Invalid nexthop configuration - no valid nexthops");
> 
> No need for a line wrap.

I wanted to be consistent with the rest of the extack usage in this
function.
