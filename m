Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 414B9452A05
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 06:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237039AbhKPFvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 00:51:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236895AbhKPFuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 00:50:52 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD21CC07AF6F;
        Mon, 15 Nov 2021 20:16:53 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id c32so49544250lfv.4;
        Mon, 15 Nov 2021 20:16:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=tj2K3jSiGWH1FMb04NTt49avhaO6LiWgdXeAiKO0RXQ=;
        b=m+m10IXZOfOVR3GJb0QDfHXOQwUuYZdz9nMsbTKZhs0hh8XRQ2QxgwnQE/VO+FcbTs
         lCAJLC25KkE79IIacO1nTn4g5df8s2YCv/qMrKsG2LU0idfNrTF1EEANhmWXBs4w++7Y
         3uObe2uhJx0OXR/HY5w5/IU4aWx+9562mkmPAbIcTsT3HjyHg0CBE7RRlqzhjGvClGXZ
         KhgRaF41jhASaCPZM2BeYfrO5H7KZEOH06I5KIQCiFM9OWUOYnmMzFqYBPWY3q+aDxzM
         yXoD1rLik341l4dre6KJctwOsteQZqi6OZQbw/Pdm4OGtip8C5ICx2WLE8jYguWExLu+
         G4CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=tj2K3jSiGWH1FMb04NTt49avhaO6LiWgdXeAiKO0RXQ=;
        b=gXOf4RBlDCfbGRQ4UMUI87LUkmKTdZU1GzvVyvpCFtKKRystRjMC6LxLgYAvwKLkw+
         ExYrUC5kTyKbj8KxiRiS9xOjuGXON0s2g8rRVCRTClZorBA1mfFejEzfb4f8C9LONxwg
         QJpp5JfbOMhEoLeacHM29H9Jt0B17wAJ5Gewt8mSYLZn2K965Li4fQRJZt35E4cBWMtX
         oQNDd49O8AxoseMtVXa0uAAFjibzLmq1cidMfn6V16efvg/Wkubs3wrRApUwXf3pFRJx
         etKmq8sw6cXNNtNYmEXCFCZwAZTpugKK20r0QLPttU6ogtB/q1zCGT9PjXT/5RjnAkgz
         SUHA==
X-Gm-Message-State: AOAM530O4wwlYfZXXDRVIq9v18tfLUh5TVCRTQntkGEPxrc+aDcU1b2d
        093M9NhRef3cLxktAjAEBiu5yyYwoWQ=
X-Google-Smtp-Source: ABdhPJxW/ws02JUvdtZZ5oXaJn+Ug43HkLKFSyKlZp4QiG1JN7DShwT/dtu5SXvmOE47SAlUIdPU4A==
X-Received: by 2002:a05:6512:3a8d:: with SMTP id q13mr3621131lfu.73.1637036211439;
        Mon, 15 Nov 2021 20:16:51 -0800 (PST)
Received: from [172.28.2.233] ([46.61.204.60])
        by smtp.gmail.com with ESMTPSA id v19sm1700371ljg.8.2021.11.15.20.16.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Nov 2021 20:16:50 -0800 (PST)
Message-ID: <0e94dae1-dd77-861d-1e13-856cb1b145d2@gmail.com>
Date:   Tue, 16 Nov 2021 07:16:49 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] net: dpaa2-eth: fix use-after-free in dpaa2_eth_remove
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     ioana.ciornei@nxp.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20211113172013.19959-1-paskripkin@gmail.com>
 <20211115080817.GE27562@kadam>
 <20211115172722.6a582623@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <20211115172722.6a582623@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/16/21 04:27, Jakub Kicinski wrote:
> I'd ignore that path, it's just special casing that's supposed to keep
> the driver-visible API sane. Nobody should be touching netdev past
> free_netdev(). Actually if you can it'd be interesting to add checks
> for using whatever netdev_priv(ndev) returned past free_netdev(ndev).
> 
> Most UAFs that come to mind from the past were people doing something
> like:
> 
> 	struct my_priv *mine = netdev_priv(ndev);
> 
> 	netdev_unregister(ndev);
> 	free_netdev(ndev);
> 
> 	free(mine->bla); /* UAF, free_netdev() frees the priv */
> 
I've implemented this checker couple of months ago. The latest smatch 
(v1.72) should warn about this type of bugs. All reported bugs are fixed 
already :)

My checker warns about using priv pointer after free_netdev() and 
free_candev() calls. There are a few more wrappers like 
free_sja1000dev(), so it worth to add them to check list too. Will add 
them today later


Important thing, that there are complex situations like

	struct priv *priv = get_priv_from_smth(smth);

	free_netdev(priv->netdev);
	clean_up_priv(priv);

and for now I have no idea how to handle it (ex: ems_usb_disconnect).




With regards,
Pavel Skripkin
