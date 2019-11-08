Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0785DF5A65
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 22:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727647AbfKHVvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 16:51:19 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:46133 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbfKHVvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 16:51:19 -0500
Received: by mail-lf1-f66.google.com with SMTP id o65so1892522lff.13
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 13:51:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=pjTRr0Ec/7D/SD2DSIp1WRI4YQ8Q1c/X0d5DLs4SpQQ=;
        b=v6yGJOyWPww9FgRnAS7dK1eYVTIpQwh1HxWR9ZpjHlvvzMESt3N7xDyV0DPkVDnhkS
         bpMEwIpCDyTZufBBpD6LwvZGh7qzhBcc+GTQ8z79Fv2lFXXms2fdeNNpRk8SJUdpZJIs
         4ehf9AOXtrVtx+UjUmcEWUBTpw4jd7MnaSHyFun6dy17XY0gPBeLbi3x2LcFlc8tuWjl
         0gfBCk7jVnmj5iHWukHJz2gYp1Z7TWj+aMZMI4vO/UNms2/qdbI0FFMsf5drA3NUOqMi
         IPXMjJIz9R80zI6gI1Dwn2THe5oo/MIVXZ+WNcQirrhYVrg+VQ9ZIXxwVQWHyhQ4bt1A
         wEVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=pjTRr0Ec/7D/SD2DSIp1WRI4YQ8Q1c/X0d5DLs4SpQQ=;
        b=tRpTZvxsxFScrTf08zl+VVCVK00GAGtDfqbK2eiOlqcBOZkqjjW6v9ryMDfLM06Uvz
         kvZMAq8SHh0IESNe3sG/+FbZgVHfiB0o8Fyzf1r8Ek/az2pnjJ6XUtkzJ6U6uHoLyhJx
         9XZ8IBsUrHHlaiZzcSwKhvwxLVDN7TJlNyiVZ47Zzz3zeAmNhwVnhuwpT9Gk/znMcnYg
         29Txe+RbB5XpZOjxwxlmi/IewGWmANcYfQNaet4jLm9HAzMPotmLeKXfG5uOGm7PxmyJ
         NKbOqTyc5ox6JmZqeATpCJIDbewWK1D1D0+NjrBlZ8YyE24r7TNgdVhSpD8hrhs7ZpXx
         UGIw==
X-Gm-Message-State: APjAAAXyIn/Zhg/smBZ32hMo7oB+Ruq7bM8FWzslYq+J4bRKdW7tzM7e
        5bsbVyf57BXTcc+CBwK9HsmKDA==
X-Google-Smtp-Source: APXvYqzBVlVp10LBUGfJPwXg0YAxcN7fNdNGF+Hc6mgKysDtZiRWF0SB3Lc7WXQXsBSzLrEHy3XXqw==
X-Received: by 2002:a19:1ce:: with SMTP id 197mr8207726lfb.16.1573249877377;
        Fri, 08 Nov 2019 13:51:17 -0800 (PST)
Received: from cakuba ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id h16sm3791325ljb.10.2019.11.08.13.51.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 13:51:17 -0800 (PST)
Date:   Fri, 8 Nov 2019 13:51:09 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Parav Pandit <parav@mellanox.com>, alex.williamson@redhat.com,
        davem@davemloft.net, kvm@vger.kernel.org, netdev@vger.kernel.org,
        saeedm@mellanox.com, kwankhede@nvidia.com, leon@kernel.org,
        cohuck@redhat.com, jiri@mellanox.com, linux-rdma@vger.kernel.org,
        Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Message-ID: <20191108135109.0c833847@cakuba>
In-Reply-To: <20191108213952.GZ6990@nanopsycho>
References: <20191107160448.20962-1-parav@mellanox.com>
        <20191107153234.0d735c1f@cakuba.netronome.com>
        <20191108121233.GJ6990@nanopsycho>
        <20191108110640.225b2724@cakuba>
        <20191108194118.GY6990@nanopsycho>
        <20191108132120.510d8b87@cakuba>
        <20191108213952.GZ6990@nanopsycho>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 Nov 2019 22:39:52 +0100, Jiri Pirko wrote:
> >> Please let me understand how your device is different.
> >> Originally Parav didn't want to have mlx5 subfunctions as mdev. He
> >> wanted to have them tight to the same pci device as the pf. No
> >> difference from what you describe you want. However while we thought
> >> about how to fit things in, how to handle na phys_port_name, how to see
> >> things in sysfs we came up with an idea of a dedicated bus.  
> >
> >The difference is that there is naturally a main device and subslices
> >with this new mlx5 code. In mlx4 or nfp all ports are equal and
> >statically allocated when FW initializes based on port breakout.  
> 
> Ah, I see. I was missing the static part in nfp. Now I understand. It is
> just an another "pf", but not real pf in the pci terminology, right?

Ack, due to (real and perceived) HW limitations what should have been
separate PFs got squished into a single big one.

Biggest NFP chip has an insane (for a NIC) number Ethernet ports.
