Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5EA15B1C3
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 21:23:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728767AbgBLUXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 15:23:37 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:43302 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727439AbgBLUXh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Feb 2020 15:23:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=2Pf0jSF3zi7Uk2v8Judqp6wA4yzjcu8TqGWMZr8zWMU=; b=a1guI9N1hKkahCYzyQPOvSJcJZ
        Mrv+fB+gU4tju0reQiS9eQ3biRqjFCb4yBnem15YB2ICJND6Hw7mvZf9Av6Tiw5BkdxrDh8jBz4N4
        1Lhgh1TtZWM7Ck/uCr8fWTGe/kZNf+GgsGOxgecNJU/0tlWjwLfTTCG9BHKophTsytDY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j1yXk-0007YK-Vi; Wed, 12 Feb 2020 21:23:32 +0100
Date:   Wed, 12 Feb 2020 21:23:32 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Per =?iso-8859-1?Q?F=F6rlin?= <Per.Forlin@axis.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "john@phrozen.org" <john@phrozen.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
Subject: Re: [Question] net: dsa: tag_qca: QCA tag and headroom size?
Message-ID: <20200212202332.GV19213@lunn.ch>
References: <1581501418212.84729@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1581501418212.84729@axis.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 12, 2020 at 09:57:00AM +0000, Per Förlin wrote:
> Hi,
> 
> ---
>  net/dsa/tag_qca.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
> index c8a128c9e5e0..70db7c909f74 100644
> --- a/net/dsa/tag_qca.c
> +++ b/net/dsa/tag_qca.c
> @@ -33,7 +33,7 @@ static struct sk_buff *qca_tag_xmit(struct sk_buff *skb, struct net_device *dev)
>  	struct dsa_port *dp = dsa_slave_to_port(dev);
>  	u16 *phdr, hdr;
>  
> -	if (skb_cow_head(skb, 0) < 0)
> >  Is it really safe to assume there is enough headroom for the QCA tag?
> 
> +	if (skb_cow_head(skb, QCA_HDR_LEN) < 0)
> > My proposal. Specify QCA tag size to make sure there is headroom.
> 
>  		return NULL;
>  
>  	skb_push(skb, QCA_HDR_LEN);

Hi Per

Yes, your change looks correct. ar9331_tag_xmit() also seems to have
the same problem.

Do you want to submit a patch?

Thanks

    Andrew
