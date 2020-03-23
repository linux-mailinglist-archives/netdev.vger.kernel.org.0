Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73EF1190134
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 23:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbgCWWuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 18:50:14 -0400
Received: from mail-qk1-f177.google.com ([209.85.222.177]:37650 "EHLO
        mail-qk1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbgCWWuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 18:50:14 -0400
Received: by mail-qk1-f177.google.com with SMTP id x3so5837571qki.4
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 15:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5QUtrim/6Al9T2QMhvliaYnN+EnwaN1sJQD7yWVGPRM=;
        b=BQRiZ8LTbtq/jYsiJ7r5+11Fz4Pmoek6M8i2SpT4b/p4VKqFuCKMBndQIuOfNl1m2P
         xX/17uDl4Ei/sPqzLQ1aA2dw655RxLnFZ6pdZw9lMkN+pUMfYryMwobmOfCj5qAMIsqM
         Ww76cSZpXerR9g7kkwrBjrdIQUsM4vFxUNLApcpzllnEhSi57b6XGeElamnf30hGkcx9
         TDbcybMHBFdqHbYXFUGd9BDg1YPNp8PaUyXSqM6pn1iILNnlyWxd8Sqxm63TN2G5VgRc
         ytMZ5/VbuVnbA7wFdJw6a6GW2BkMwRFmYFFmC6H0OlDI9221DALPxHVE3jXD9qqThQVy
         cHIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5QUtrim/6Al9T2QMhvliaYnN+EnwaN1sJQD7yWVGPRM=;
        b=dNCwTQ0bn4rU1jbSwFJpBIqkbcQnDdYNj4ne+31s3inKZ3ayqORVmK+u9qyEFo4iGL
         de7llR4RgZ9ecQa0czwnR4khL0tNn2t4T3Iu3XD4O7GoTHI8xk354J4PWi5THv4mhikB
         LQ2De8AOkKGUwxvv4ZkOFxML+P5tUdkS+A6qbsX3PGY6dG+gwWOqzz60uD+715ilUgQC
         0owOSl+Jbzg2zo+cSwqDivWjD/RNvvYM1qClYqAsRU8HGJ+8CMz5INulc0F5/xCqSOkX
         E4nIuz26/WmGu6wHnNrFTKIXsbfmb4yPIoHrv5i1L8zfWQwgKWWICsowJy0esa3K6tyW
         Ui/w==
X-Gm-Message-State: ANhLgQ0dUccFwbL7x88869IxEyKWwGO6PYnum1U4datrg8Vz15QTpHLf
        8eNhz3uK89OjALEtbwaf8NgKnA==
X-Google-Smtp-Source: ADFU+vvHq3WweSg5KI0JAztT/uDwMciOrh1GMKg4BvAzo8fB0/R0hqWDmtxda/kz3ZQLRQDTtk2xFw==
X-Received: by 2002:a37:6388:: with SMTP id x130mr23571443qkb.429.1585003811405;
        Mon, 23 Mar 2020 15:50:11 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id d72sm11696543qkg.102.2020.03.23.15.50.10
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 23 Mar 2020 15:50:10 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jGVtZ-00061q-Rf; Mon, 23 Mar 2020 19:50:09 -0300
Date:   Mon, 23 Mar 2020 19:50:09 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Parav Pandit <parav@mellanox.com>, Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Yuval Avnery <yuvalav@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "andrew.gospodarek@broadcom.com" <andrew.gospodarek@broadcom.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Aya Levin <ayal@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Yevgeny Kliteynik <kliteyn@mellanox.com>,
        "dchickles@marvell.com" <dchickles@marvell.com>,
        "sburla@marvell.com" <sburla@marvell.com>,
        "fmanlunas@marvell.com" <fmanlunas@marvell.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>,
        "snelson@pensando.io" <snelson@pensando.io>,
        "drivers@pensando.io" <drivers@pensando.io>,
        "aelior@marvell.com" <aelior@marvell.com>,
        "GR-everest-linux-l2@marvell.com" <GR-everest-linux-l2@marvell.com>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        mlxsw <mlxsw@mellanox.com>, Ido Schimmel <idosch@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        "jacob.e.keller@intel.com" <jacob.e.keller@intel.com>,
        Alex Vesker <valex@mellanox.com>,
        "linyunsheng@huawei.com" <linyunsheng@huawei.com>,
        "lihong.yang@intel.com" <lihong.yang@intel.com>,
        "vikas.gupta@broadcom.com" <vikas.gupta@broadcom.com>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>
Subject: Re: [RFC] current devlink extension plan for NICs
Message-ID: <20200323225009.GA1839@ziepe.ca>
References: <20200319192719.GD11304@nanopsycho.orion>
 <20200319203253.73cca739@kicinski-fedora-PC1C0HJN>
 <20200320073555.GE11304@nanopsycho.orion>
 <20200320142508.31ff70f3@kicinski-fedora-PC1C0HJN>
 <997dbf25-a3e1-168c-c756-b33e79e7c51e@mellanox.com>
 <20200323123116.769e50e4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323123116.769e50e4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 23, 2020 at 12:31:16PM -0700, Jakub Kicinski wrote:

> Right, that is the point. It's the host admin that wants the new
> entity, so if possible it'd be better if they could just ask for it 
> via devlink rather than some cloud API. Not that I'm completely opposed
> to a cloud API - just seems unnecessary here.

The cloud API provides all the permissions checks and security
elements. It cannot be avoided.

If you try to do it as you say then it is weird. You have to use the
cloud API to authorize the VM to touch a certain network, then the VM
has to somehow take that network ID and use devlink to get a netdev
for it. And the cloud side has to protect against a hostile VM sending
garbage along this communication channel.

vs simply host plugging in the correct network fully operational when
the cloud API connects the VM to the network.

Jason
