Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDEB313C3E
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 00:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727399AbfEDWti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 18:49:38 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:36765 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727259AbfEDWti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 18:49:38 -0400
Received: by mail-qt1-f196.google.com with SMTP id c35so10829779qtk.3
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 15:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=UhzhmBa6VLSdQPwHHC9c1sFGCIztL8cb/aRXL6ZdBu4=;
        b=EFBgq7ambI3/lrWrRYDnmOo7zuWBNlSrYTKux8KbbS6wMy+UZvy0Nkdh+aZa62Bl0u
         ALlVqs1lAdShuiJaljmy/GcwtDlUXlAq6IRgLbu+NG3IMT5eglSU+uycx7slBGZbPkI3
         RZY+i1BziJP7ToKK4GmpU5+RAEJPzCJtROaF2HLXFmcvN8INe1VsHMPJJDO1lefDXtIu
         xUcWusGa70YWFCPCm7IXwi047OLNLxXcqXJHyTwJrNa/2tBOQDSWzRYuwxSknOq61xE7
         cILrYa9xqqgG+a5bYuFtDW7VPFz5A3MsSlsiaNpJ/nLbXDSz6QSLSxYOYoeee+Kvu+Mr
         Mz5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=UhzhmBa6VLSdQPwHHC9c1sFGCIztL8cb/aRXL6ZdBu4=;
        b=mQb7yyT3VMMf2926un0szDLEj6mM1lHbxyTjmRFtAz4fPpDhbOYMaOuv4eXvjbMQUm
         Snzm5erolfN/T1rsinnhqngZOZlmBE8qP9BDXLr7vgOVEcc1+m3LwTmC0annQj7XV3EW
         hgT4pbclaqj+zl7j1oDezfW9FTbMtjF3sOVxDfuPw/dLk/pm2ZGxDeP3IwsWqMzV7fCp
         8jnujrjSo9gJg7wHukXHaGYsmCG4ruAqVm35wV7RNF1AczQgaH7djsWWVj+P5EOZbxmE
         ZSTok52uYdbcUerKGYdqhfNd7e7QJyfDpiw4RuKBRCbb64+PKTENp+gLA+Mgp85zIih3
         GJ1w==
X-Gm-Message-State: APjAAAUccX3WIP6whDJp9312KVK8tclnfawXLYjRLTHkgQPFcZv01uzH
        YK9PyjY4yH7ROuMVnQrVVGU=
X-Google-Smtp-Source: APXvYqyq+I/5KsOdeTrQ7FB8EW57qiMcBIyfUV087FeZY8I/T6B5pQmSTKnHu8eC6rM7XS99LAfyOw==
X-Received: by 2002:ac8:22ea:: with SMTP id g39mr9572098qta.221.1557010177110;
        Sat, 04 May 2019 15:49:37 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id c24sm3070686qkc.54.2019.05.04.15.49.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 04 May 2019 15:49:36 -0700 (PDT)
Date:   Sat, 4 May 2019 18:49:35 -0400
Message-ID: <20190504184935.GE25185@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     f.fainelli@gmail.com, andrew@lunn.ch, davem@davemloft.net,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v2 3/9] net: dsa: Allow drivers to filter packets
 they can decode source port from
In-Reply-To: <20190504135919.23185-4-olteanv@gmail.com>
References: <20190504135919.23185-1-olteanv@gmail.com>
 <20190504135919.23185-4-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Sat,  4 May 2019 16:59:13 +0300, Vladimir Oltean <olteanv@gmail.com> wrote:
> Frames get processed by DSA and redirected to switch port net devices
> based on the ETH_P_XDSA multiplexed packet_type handler found by the
> network stack when calling eth_type_trans().
> 
> The running assumption is that once the DSA .rcv function is called, DSA
> is always able to decode the switch tag in order to change the skb->dev
> from its master.
> 
> However there are tagging protocols (such as the new DSA_TAG_PROTO_SJA1105,
> user of DSA_TAG_PROTO_8021Q) where this assumption is not completely
> true, since switch tagging piggybacks on the absence of a vlan_filtering
> bridge. Moreover, management traffic (BPDU, PTP) for this switch doesn't
> rely on switch tagging, but on a different mechanism. So it would make
> sense to at least be able to terminate that.
> 
> Having DSA receive traffic it can't decode would put it in an impossible
> situation: the eth_type_trans() function would invoke the DSA .rcv(),
> which could not change skb->dev, then eth_type_trans() would be invoked
> again, which again would call the DSA .rcv, and the packet would never
> be able to exit the DSA filter and would spiral in a loop until the
> whole system dies.
> 
> This happens because eth_type_trans() doesn't actually look at the skb
> (so as to identify a potential tag) when it deems it as being
> ETH_P_XDSA. It just checks whether skb->dev has a DSA private pointer
> installed (therefore it's a DSA master) and that there exists a .rcv
> callback (everybody except DSA_TAG_PROTO_NONE has that). This is
> understandable as there are many switch tags out there, and exhaustively
> checking for all of them is far from ideal.
> 
> The solution lies in introducing a filtering function for each tagging
> protocol. In the absence of a filtering function, all traffic is passed
> to the .rcv DSA callback. The tagging protocol should see the filtering
> function as a pre-validation that it can decode the incoming skb. The
> traffic that doesn't match the filter will bypass the DSA .rcv callback
> and be left on the master netdevice, which wasn't previously possible.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Looks promising, I'll try to give this a try soon!

Thanks,
Vivien
