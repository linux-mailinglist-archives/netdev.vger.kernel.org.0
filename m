Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8F3C1B5E3A
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 16:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728783AbgDWOrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 10:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726380AbgDWOrr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 10:47:47 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4BAEC08ED7D
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 07:47:46 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id g13so7160395wrb.8
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 07:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YDVqFbhkltYF1LqKa6mDYHiM9M37MHYlVFEw9eWylXw=;
        b=Kht6YfzoEKdm9rUcVhGAt3/Bb8ROegtb4UohHihcuYCynwXgYk4uLb/LAJi6jK+tVe
         FUt6ekqrPLYLVqoOYAcj3e+p6u1oN5FpOxeVFeOnwuLP7LS5yBXbFY95Q9+9EDrptGDy
         XJr3ikxg7rabp8mPSzcvId0nEGLSfQZkPynnkMj7yrhHZbZNvGoaaDPMsjewGeDEVOwX
         2a56o2giYnBM5hq6Z/+Ef2NYGzdKIIwIR7ijJbyRQ0eLb9JEBOwDbJQykWfuU7lnZyB2
         tIK38+AtbBlPUOQaBrW/BXtHeSc556WWIc3EMEWCN14f2s9b7e71QBxb9CEcRNCskjSs
         F1Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YDVqFbhkltYF1LqKa6mDYHiM9M37MHYlVFEw9eWylXw=;
        b=E+GyCS9zIjfX14U9ROkcoC9uZHl2WwRDuoNODQzwcsJmuP3rFNOasHZj6PV0We5gRL
         FfyTSrwm0vI1tslLG5Ys9veKScurchOra4zvglR9oZjTVlwz32wFvci/Le/kPtW7z5mK
         b3HP/6f/UfmMIgpYrWMiu9qlyTTBAWmera/tuhxSQfLkOg5K5UmqHhbTaRga9qTw5bL0
         hWPp+sSMoeuZcTR+baYDJYQWmNf1ufU5hIE8T/db3ozWn8W1uzfBtpYqlD7DnsKL53bM
         3U95a6qI37yRpYWlqINpDdRVRapot9JpNrBQLMsebjDGoudQM7+ZqaVouINumfsu7cWv
         wbYw==
X-Gm-Message-State: AGi0PubAUvvUS1yely1Efj1zV8wrCJFf+i8MN1veR7I4pavMZilXeAcR
        A9qGCG/S7XvcbcSld/c6Yu749g==
X-Google-Smtp-Source: APiQypL9mZAX1xWoKJftxy2iQYubknjsGHEBlkkY+A9kqeg9lrNKEXlGe4tGWa9t2Rqrp0QlUkiuew==
X-Received: by 2002:a5d:4447:: with SMTP id x7mr5283866wrr.299.1587653265610;
        Thu, 23 Apr 2020 07:47:45 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id s11sm4311726wrw.71.2020.04.23.07.47.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2020 07:47:45 -0700 (PDT)
Date:   Thu, 23 Apr 2020 16:47:44 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Maor Gottlieb <maorg@mellanox.com>
Cc:     davem@davemloft.net, jgg@mellanox.com, dledford@redhat.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        kuba@kernel.org, jiri@mellanox.com, dsahern@kernel.org,
        leonro@mellanox.com, saeedm@mellanox.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alexr@mellanox.com
Subject: Re: [PATCH V5 mlx5-next 09/16] bonding: Implement ndo_get_xmit_slave
Message-ID: <20200423144744.GP6581@nanopsycho.orion>
References: <20200423125555.21759-1-maorg@mellanox.com>
 <20200423125555.21759-10-maorg@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423125555.21759-10-maorg@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Apr 23, 2020 at 02:55:48PM CEST, maorg@mellanox.com wrote:
>Add implementation of ndo_get_xmit_slave. Find the slave by using the
>helper function according to the bond mode. If the caller set all_slaves
>to true, then it assumes that all slaves are available to transmit.
>
>Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
>Reviewed-by: Jay Vosburgh <jay.vosburgh@canonical.com>

I already send review tag. But it got lost apparently:

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
