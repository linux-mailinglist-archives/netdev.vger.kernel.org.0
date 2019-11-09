Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44423F60C2
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 18:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbfKIRlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 12:41:08 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39554 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbfKIRlI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 12:41:08 -0500
Received: by mail-pg1-f196.google.com with SMTP id 29so6243161pgm.6
        for <netdev@vger.kernel.org>; Sat, 09 Nov 2019 09:41:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=2B7miXvo12sd3AwR/N24hvrji1TnW/1jP59Zv1D2zxA=;
        b=Ux66y2/Kev7fAowQYcNDFqBF2oMucxESjkkRfo8IKup+pQkx6c41HWBsZj9GcF/XH7
         9q5bddJ0Ib4aWwuzqXvZ/f6ExZS0BhSgfZfP25ahtYi6cRFgd6bNKGUNcmMNHudNagcC
         gCsZz3t6Mq+E1k40G+tbKVjUsRtLsUqFwOo01ugae2GCJvy2GLhJrtoc20el2oh7SbBf
         ROYWJC/rPRLGrqeXE6yeGN7xdj1TF4KXEbxh+FAYZYVgj9tCuD0GO2qMFAKfYbcAHD09
         n6ptYL86QvSyY/z14h/xrMQJ/T5NEtw6+1My7DBq0+zYNnCHlHm/tL1osxRC9TA7a9Sc
         ltcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=2B7miXvo12sd3AwR/N24hvrji1TnW/1jP59Zv1D2zxA=;
        b=Rn1T4+Yd3TIJylMixRIobeK0zPGxIhcUFmdThCpa9vwmZGB6MerC7o+gAOl1cAI+QM
         RdMg2Z1iHJOa6HkJXKCTz5cNYqPc4JIi+wDy9Ym3AN77dxGSFRuxrXOlv8nkYdl8zp9b
         wjYUxottfe1sIwtl/GCUCD//PpwRvRPZH5fdU6YLhG4qvzHceEt/7O2BewI9Nd4aDu5+
         cWyEmaP3gppWX8EulpB8iZ40mjMdpvaQOSrZCiHFe5K1D4Q3HqPrLieDkNZddqEppe6f
         FKjK0c8X+TI30fFBweA4BygXElRyn4cVYIPN1g8Io9X/rE5pMhoSlMhlfmDA/zsnXCVw
         IxHQ==
X-Gm-Message-State: APjAAAWkzFIK0wxkWQsZqvitLa8OLBi6ykF8XJ+wy8xjDJnYENxW0o5X
        xfByj+hk2+8taUtqfunAuxnI56/b4Qc=
X-Google-Smtp-Source: APXvYqzxYgwMmVIq1JfKtIHriDl97HY1zcdcpAYzr8weQ2+HF6xR/h1VetUuPsLmf6vJjuss1CYESw==
X-Received: by 2002:a63:3205:: with SMTP id y5mr19364349pgy.42.1573321267604;
        Sat, 09 Nov 2019 09:41:07 -0800 (PST)
Received: from cakuba (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id a23sm5103400pjv.26.2019.11.09.09.41.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Nov 2019 09:41:07 -0800 (PST)
Date:   Sat, 9 Nov 2019 09:41:03 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Parav Pandit <parav@mellanox.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jiri Pirko <jiri@resnulli.us>,
        David M <david.m.ertman@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Or Gerlitz <gerlitz.or@gmail.com>,
        "Jason Wang (jasowang@redhat.com)" <jasowang@redhat.com>
Subject: Re: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Message-ID: <20191109094103.739033a3@cakuba>
In-Reply-To: <20191109005708.GC31761@ziepe.ca>
References: <20191107153234.0d735c1f@cakuba.netronome.com>
        <20191108121233.GJ6990@nanopsycho>
        <20191108144054.GC10956@ziepe.ca>
        <AM0PR05MB486658D1D2A4F3999ED95D45D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20191108111238.578f44f1@cakuba>
        <20191108201253.GE10956@ziepe.ca>
        <20191108133435.6dcc80bd@x1.home>
        <20191108210545.GG10956@ziepe.ca>
        <20191108145210.7ad6351c@x1.home>
        <AM0PR05MB4866444210721BC4EE775D27D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20191109005708.GC31761@ziepe.ca>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 Nov 2019 20:57:08 -0400, Jason Gunthorpe wrote:
> On Fri, Nov 08, 2019 at 10:48:31PM +0000, Parav Pandit wrote:
> > We should be creating 3 different buses, instead of mdev bus being de-multiplexer of that?
> > 
> > Hence, depending the device flavour specified, create such device on right bus?
> > 
> > For example,
> > $ devlink create subdev pci/0000:05:00.0 flavour virtio name foo subdev_id 1
> > $ devlink create subdev pci/0000:05:00.0 flavour mdev <uuid> subdev_id 2
> > $ devlink create subdev pci/0000:05:00.0 flavour mlx5 id 1 subdev_id 3  
> 
> I like the idea of specifying what kind of interface you want at sub
> device creation time. It fits the driver model pretty well and doesn't
> require abusing the vfio mdev for binding to a netdev driver.

Aren't the HW resources spun out in all three cases exactly identical?

IMHO creation of sub device should only define which HW resources are
provisioned/relegated. Specifying a driver when recreating a device
seems a little backwards.
