Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7E82B5596
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 01:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731439AbgKQAMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 19:12:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730651AbgKQAMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 19:12:16 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C177C0613CF;
        Mon, 16 Nov 2020 16:12:16 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id cq7so20588159edb.4;
        Mon, 16 Nov 2020 16:12:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=u1nScHC4ykNVywOfRIS6n1BfrOeGSbVAH5aQdR1Mi30=;
        b=lIbhiWSXWM0aQphq25SIRjotXNQ+27oBuoqwD5ucEB5y16MvzriqJPskdJzIx99pNv
         5QjDFS4+jb/WE6EBBLcHDHTGkwDOCpeL7+J4V/+BR9TANYVjpJe/9e2c/UIOCpk0CPeg
         LfFtmtzGtAflvFBHapEwJFCSdoywuUlVlzuFEbXPfREHrDSZWMItnv1yx44edYdEm1uH
         TushdJgihbtNMNGOYuaPpWH/UawSRMPDgROY1vSPLVEgMqn26u/OOUwcH+AFp/UQf/Md
         jVEqgnXzqAzgk4hahmRg9tyxJ6F2A3t2vpI+pBto3O9QcO5yzYcFn8nmmDxcK7Z94EQ9
         rT2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=u1nScHC4ykNVywOfRIS6n1BfrOeGSbVAH5aQdR1Mi30=;
        b=Qxxq07WND/xQcAlSz5xvRRCLXrmUKZ7duN6CZvA7ww5K0AliYS1vajm10jeeTSauu6
         8+MRUZ2OFkucXH0fPf14addsaNbFdt3nh5z877EgXbGwqiGh8P92Dqe/3j10AP6eFzIr
         cqQENiBeX1c3xCgIjScuzjQmoh4lqfsCnudH+0NUR7IN7XgbLMYrvZERJpyVT+tYlYRP
         a0aGsuaespFNJuBy5RfMLdrWrAnl5CyUH0YAqXCePcRYbuBOd3AYp7bwmOymeCBR4CEJ
         volftt5IM3rTfGd14a7fCpqQ9wSLqdAEzv13vHLd2b2M69PCl/60vRgRSqZ1CeQToIGc
         5X5A==
X-Gm-Message-State: AOAM532DqqUsvVtHllndUy8G6uHwn54btZa+7ACvUl9oZJaf1gqtl6w9
        yS/nJfYf5E7ivG0tmvmJ3aM=
X-Google-Smtp-Source: ABdhPJyLwyxa+ZvkpuUzX7QrEMLcsFPDbud5Hp8rpuZGloFA2Zr7jUcKqr0QH3f7lXr6O9VboS01gw==
X-Received: by 2002:aa7:d443:: with SMTP id q3mr19224908edr.262.1605571934940;
        Mon, 16 Nov 2020 16:12:14 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id u8sm11326754edr.2.2020.11.16.16.12.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 16:12:14 -0800 (PST)
Date:   Tue, 17 Nov 2020 02:12:13 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Yunjian Wang <wangyunjian@huawei.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: Have netpoll bring-up DSA management interface
Message-ID: <20201117001213.3dk6fluycx5fi2h4@skbuf>
References: <20201019171746.991720-1-f.fainelli@gmail.com>
 <20201019200258.jrtymxikwrijkvpq@skbuf>
 <58b07285-bb70-3115-eb03-5e43a4abeae6@gmail.com>
 <20201019211916.j77jptfpryrhau4z@skbuf>
 <20201020181247.7e1c161b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <a8d38b5b-ae85-b1a8-f139-ae75f7c01376@gmail.com>
 <d2dbb984-604a-ecbd-e717-2e9942fdbdaa@gmail.com>
 <20201116154710.20627867@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201116235405.wkyyhqznocit4vj2@skbuf>
 <20201116160449.0cc0ee76@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201116160449.0cc0ee76@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 16, 2020 at 04:04:49PM -0800, Jakub Kicinski wrote:
> On Tue, 17 Nov 2020 01:54:05 +0200 Vladimir Oltean wrote:
> > Yeah, I think Florian just wants netconsole to work in stable kernels,
> > which is a fair point. As for my 16-line patch that I suggested to him
> > in the initial reply, what do you think, would that be a "stable"
> > candidate? We would be introducing a fairly user-visible change
> > (removing one step that is mentioned as necessary in the documentation),
> > do you think it would benefit the users more to also have that behavior
> > change backported to all LTS kernels, or just keep it as something new
> > for v5.11?
>
> Yeah, I'd think that's too risky for a backport.

Ok, I retract my charges then. Florian, depending on how quickly you
have time to resend, I might be able to double-test your patch tonight
before I go to sleep.
